import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProvider<U extends IBasePaginationRepository>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoading());

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true => 추가로 데이터 더 가져옴
    // false => 새로 고침(현재 상태 덮어씀)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true => CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    // 5 case
    // 1. CursorPagination => 정상적으로 데이터가 있는 상태
    // 2. CursorPaginationLoading => 데이터가 로딩 중(현재 캐시 없음)
    // 3. CursorPaginationError => 에러 발생
    // 4. CursorPaginationRefetching => 첫번째 데이터부터 다시 데이터 로딩
    // 5. CursorPaginationFetchMore => 추가 데이터 로딩 요청

    // 바로 리턴
    // 1) hasMore => false(state에서) => 더 이상 처리하지 않음
    // 2) 로딩중 - fetchMore: true
    //    fetchMore가 아닐때 - 새로고침의 의도가 잇을 수 있다
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationParams params = PaginationParams(
        count: fetchCount,
      );

      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        params = params.copyWith(
          after: pState.data.last.id,
        );
      } else {
        // 데이터를 처음부터 가져오는 상황
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(paginationParams: params);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        state = resp.copyWith(
          data: [...pState.data, ...resp.data],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터 검색 중 예외발생');
    }
  }
}
