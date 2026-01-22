import '../../domain/entities/apod.dart';

abstract class ApodState {}

class ApodInitial extends ApodState {}

class ApodLoading extends ApodState {}

class ApodLoaded extends ApodState {
  final Apod apodData;
  ApodLoaded(this.apodData);
}

class ApodError extends ApodState {
  final String message;
  ApodError(this.message);
}