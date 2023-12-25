import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReserveCubit extends Cubit<ReserveState> {
  ReserveCubit() : super(InitialState());

  void reserve({required String from, required String to}) async {
    emit(LoadingState());
    // final now = DateTime.now();
    // if (to.isAfter(from) && (from.isAtSameMomentAs(now) || from.isAfter(now))) {
    //   // TODO backend
    //   emit(ShowMessageState(
    //       isSuccess: true,
    //       message: "رزرو شما با موفقیت در سیستم ثبت شد.",
    //       icon: const Icon(Icons.check, color: Colors.white)));
    //   return;
    // }
    emit(ShowMessageState(
        isSuccess: false,
        message: "ساعت و تاریخ انتخاب شده معتبر نمی باشد. ",
        icon: const Icon(Icons.cancel_outlined, color: Colors.white)));
  }

  void changeFrom(String value){
    emit(ChangedFromTimeState(value));
  }
  void changeTo(String value){
    emit(ChangedToTimeState(value));
  }

}

@immutable
class ReserveState {}

class InitialState extends ReserveState {}

class ChangedFromTimeState extends ReserveState {
  final String value;

  ChangedFromTimeState(this.value);

}

class ChangedToTimeState extends ReserveState {
  final String value;

  ChangedToTimeState(this.value);

}

class LoadingState extends ReserveState {}

class ShowMessageState extends ReserveState {
  final bool isSuccess;
  final String message;
  final Icon icon;

  ShowMessageState({
    required this.isSuccess,
    required this.message,
    required this.icon,
  });
}
