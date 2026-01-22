import 'package:equatable/equatable.dart';
import '../../domain/entities/iss_position.dart';

abstract class IssState extends Equatable {
  const IssState();

  @override
  List<Object> get props => [];
}

class IssInitial extends IssState {}

class IssLoading extends IssState {}

class IssLoaded extends IssState {
  final IssPosition position;
  final String locationName; 

  const IssLoaded(this.position, {this.locationName = "Calculating..."});

  @override
  List<Object> get props => [position, locationName];
}

class IssError extends IssState {
  final String message;

  const IssError(this.message);

  @override
  List<Object> get props => [message];
}