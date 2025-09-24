import 'package:dartz/dartz.dart';
import 'package:ord_cost/core/errors/failures.dart';
import 'package:ord_cost/features/costeo/domain/entities/order.dart';
import 'package:ord_cost/features/costeo/domain/entities/period_params.dart';

abstract class CosteoRepository {
  Future<Either<Failure, List<OrderInput>>> loadOrders();
  Future<Either<Failure, PeriodParams>> loadParams();
  Future<Either<Failure, Unit>> saveOrders(List<OrderInput> orders);
  Future<Either<Failure, Unit>> saveParams(PeriodParams params);
}
