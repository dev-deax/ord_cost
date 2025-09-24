import 'package:dartz/dartz.dart';
import 'package:ord_cost/core/errors/failures.dart';
import 'package:ord_cost/features/costeo/domain/entities/order.dart';
import 'package:ord_cost/features/costeo/domain/entities/period_params.dart';
import 'package:ord_cost/features/costeo/domain/repositories/costeo_repository.dart';

class InMemoryCosteoRepository implements CosteoRepository {
  List<OrderInput> _orders = [];

  PeriodParams? _params;
  InMemoryCosteoRepository() {
    _initializeData();
  }

  @override
  Future<Either<Failure, List<OrderInput>>> loadOrders() async {
    try {
      return Right(List.from(_orders));
    } catch (e) {
      return const Left(RepositoryFailure(message: 'Error al cargar órdenes'));
    }
  }

  @override
  Future<Either<Failure, PeriodParams>> loadParams() async {
    try {
      if (_params == null) {
        return const Left(RepositoryFailure(message: 'Parámetros no encontrados'));
      }
      return Right(_params!);
    } catch (e) {
      return const Left(RepositoryFailure(message: 'Error al cargar parámetros'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveOrders(List<OrderInput> orders) async {
    try {
      _orders = List.from(orders);
      return const Right(unit);
    } catch (e) {
      return const Left(RepositoryFailure(message: 'Error al guardar órdenes'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveParams(PeriodParams params) async {
    try {
      _params = params;
      return const Right(unit);
    } catch (e) {
      return const Left(RepositoryFailure(message: 'Error al guardar parámetros'));
    }
  }

  void _initializeData() {
    _orders = [
      const OrderInput(
        orden: 145,
        mp: 820,
        mod: 1420,
        unidades: 100,
        status: OrderStatus.enProceso,
      ),
      const OrderInput(
        orden: 146,
        mp: 790,
        mod: 1840,
        unidades: 150,
        status: OrderStatus.enProceso,
      ),
      const OrderInput(
        orden: 147,
        mp: 640,
        mod: 3220,
        unidades: 120,
        status: OrderStatus.terminada,
      ),
      const OrderInput(
        orden: 148,
        mp: 730,
        mod: 1200,
        unidades: 200,
        status: OrderStatus.terminada,
      ),
      const OrderInput(
        orden: 149,
        mp: 825,
        mod: 1720,
        unidades: 80,
        status: OrderStatus.terminada,
      ),
    ];

    _params = const PeriodParams(
      tasaCIFFactor: 1.8,
      materialesIndirectos: 1200,
      manoObraIndirecta: 6400,
    );
  }
}
