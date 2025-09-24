import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ord_cost/features/costeo/data/repositories/costeo_repository_impl.dart';
import 'package:ord_cost/features/costeo/domain/entities/calculo_detallado.dart';
import 'package:ord_cost/features/costeo/domain/entities/order.dart';
import 'package:ord_cost/features/costeo/domain/entities/order_calc.dart';
import 'package:ord_cost/features/costeo/domain/entities/period_params.dart';
import 'package:ord_cost/features/costeo/domain/entities/totales.dart';
import 'package:ord_cost/features/costeo/domain/usecases/calcular_detallado.dart';
import 'package:ord_cost/features/costeo/domain/usecases/calcular_orden.dart';
import 'package:ord_cost/features/costeo/domain/usecases/calcular_totales.dart';

final calculoDetalladoProvider = Provider<AsyncValue<List<CalculoDetallado>>>((ref) {
  final ordersAsync = ref.watch(ordersProvider);
  final paramsAsync = ref.watch(paramsProvider);

  return ordersAsync.when(
    data: (orders) => paramsAsync.when(
      data: (params) {
        final calcularDetallado = CalcularDetallado();
        final calculos = calcularDetallado.execute(orders, params);
        return AsyncValue.data(calculos);
      },
      loading: () => const AsyncValue.loading(),
      error: AsyncValue.error,
    ),
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

final calculoProvider = Provider<AsyncValue<List<OrderCalc>>>((ref) {
  final ordersAsync = ref.watch(ordersProvider);
  final paramsAsync = ref.watch(paramsProvider);

  return ordersAsync.when(
    data: (orders) => paramsAsync.when(
      data: (params) {
        final calcularOrden = CalcularOrden();
        final calculatedOrders = orders.map((order) => calcularOrden.execute(order, params)).toList();
        return AsyncValue.data(calculatedOrders);
      },
      loading: () => const AsyncValue.loading(),
      error: AsyncValue.error,
    ),
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

final costeoRepositoryProvider = Provider<InMemoryCosteoRepository>((ref) {
  return InMemoryCosteoRepository();
});

final factoresProvider = Provider<AsyncValue<FactoresCalculo>>((ref) {
  final ordersAsync = ref.watch(ordersProvider);
  final paramsAsync = ref.watch(paramsProvider);

  return ordersAsync.when(
    data: (orders) => paramsAsync.when(
      data: (params) {
        final calcularDetallado = CalcularDetallado();
        final factores = calcularDetallado.calcularFactores(orders, params);
        return AsyncValue.data(factores);
      },
      loading: () => const AsyncValue.loading(),
      error: AsyncValue.error,
    ),
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

final ordersProvider = StateNotifierProvider<OrdersNotifier, AsyncValue<List<OrderInput>>>((ref) {
  final repository = ref.watch(costeoRepositoryProvider);
  return OrdersNotifier(repository);
});

final paramsProvider = StateNotifierProvider<ParamsNotifier, AsyncValue<PeriodParams>>((ref) {
  final repository = ref.watch(costeoRepositoryProvider);
  return ParamsNotifier(repository);
});

final totalesDetalladosProvider = Provider<AsyncValue<TotalesCalculo>>((ref) {
  final calculoDetalladoAsync = ref.watch(calculoDetalladoProvider);

  return calculoDetalladoAsync.when(
    data: (calculos) {
      final calcularDetallado = CalcularDetallado();
      final totales = calcularDetallado.calcularTotales(calculos);
      return AsyncValue.data(totales);
    },
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

final totalesProvider = Provider<AsyncValue<TotalesPeriodo>>((ref) {
  final calculoAsync = ref.watch(calculoProvider);
  final paramsAsync = ref.watch(paramsProvider);

  return calculoAsync.when(
    data: (orders) => paramsAsync.when(
      data: (params) {
        final calcularTotales = CalcularTotales();
        final totales = calcularTotales.execute(orders, params);
        return AsyncValue.data(totales);
      },
      loading: () => const AsyncValue.loading(),
      error: AsyncValue.error,
    ),
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

class OrdersNotifier extends StateNotifier<AsyncValue<List<OrderInput>>> {
  final InMemoryCosteoRepository _repository;
  OrdersNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadOrders();
  }

  Future<void> addOrder(OrderInput order) async {
    final currentOrders = state.value ?? [];
    final newOrders = [...currentOrders, order];
    final result = await _repository.saveOrders(newOrders);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = AsyncValue.data(newOrders),
    );
  }

  Future<void> removeOrder(int index) async {
    final currentOrders = state.value ?? [];
    final newOrders = List<OrderInput>.from(currentOrders)..removeAt(index);
    final result = await _repository.saveOrders(newOrders);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = AsyncValue.data(newOrders),
    );
  }

  Future<void> updateOrder(int index, OrderInput order) async {
    final currentOrders = state.value ?? [];
    final newOrders = List<OrderInput>.from(currentOrders);
    newOrders[index] = order;
    final result = await _repository.saveOrders(newOrders);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = AsyncValue.data(newOrders),
    );
  }

  Future<void> _loadOrders() async {
    state = const AsyncValue.loading();
    final result = await _repository.loadOrders();
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (orders) => state = AsyncValue.data(orders),
    );
  }
}

class ParamsNotifier extends StateNotifier<AsyncValue<PeriodParams>> {
  final InMemoryCosteoRepository _repository;
  ParamsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadParams();
  }

  Future<void> setMI(double mi) async {
    final currentParams = state.value;
    if (currentParams == null) return;

    final newParams = currentParams.copyWith(materialesIndirectos: mi);
    final result = await _repository.saveParams(newParams);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = AsyncValue.data(newParams),
    );
  }

  Future<void> setMOI(double moi) async {
    final currentParams = state.value;
    if (currentParams == null) return;

    final newParams = currentParams.copyWith(manoObraIndirecta: moi);
    final result = await _repository.saveParams(newParams);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = AsyncValue.data(newParams),
    );
  }

  Future<void> setTasaPercent(double percent) async {
    final currentParams = state.value;
    if (currentParams == null) return;

    final newParams = currentParams.copyWith(tasaCIFFactor: percent / 100);
    final result = await _repository.saveParams(newParams);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) => state = AsyncValue.data(newParams),
    );
  }

  Future<void> _loadParams() async {
    state = const AsyncValue.loading();
    final result = await _repository.loadParams();
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (params) => state = AsyncValue.data(params),
    );
  }
}
