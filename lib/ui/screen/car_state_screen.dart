import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/data/car_state_screen_cubit.dart';

class CarStateScreen extends StatefulWidget {
  const CarStateScreen({super.key});

  @override
  State<CarStateScreen> createState() => _CarStateScreenState();
}

class _CarStateScreenState extends State<CarStateScreen> {
  String enterParkingTime = "12:00 PM";
  String enterLotTime = "12:04 PM";
  String priceTillNow = "17000 تومان";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<CarStateScreenCubit, CarStateScreenState>(
        listener: (context, state) {
          if(state is GotCarStatusState){
            enterParkingTime = state.enterParkingTime;
            enterLotTime = state.enterLotTime;
            priceTillNow = state.priceTillNow;
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Text(
                        "زمان ورود به پارکینگ:",
                        style: TextStyle(fontWeight: FontWeight.bold,),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: Text(enterParkingTime),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Text(
                        "زمان ورود به جایگاه پارک:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: Text(enterLotTime),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "هزینه پارکینگ تا الان:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Text(priceTillNow),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
