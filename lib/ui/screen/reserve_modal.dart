import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_parking/logic/data/reserve_cubit.dart';
import 'package:smart_parking/ui/widget/custom_button.dart';
import 'package:time_duration_picker/time_duration_picker.dart';

class ReserveModal extends StatefulWidget {
  const ReserveModal({super.key});

  @override
  State<ReserveModal> createState() => _ReserveModalState();
}

class _ReserveModalState extends State<ReserveModal> {
  bool isLoading = false;

  String fromTime = " 00:00 AM";
  String toTime = " 12:00 PM";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReserveCubit, ReserveState>(listener: (context, state) {
      if (state is LoadingState) {
        isLoading = true;
      }
      if (state is ShowMessageState) {
        isLoading = false;
      }
      if (state is ChangedFromTimeState) {
        fromTime= state.value;
      }
      if (state is ChangedToTimeState) {
        toTime = state.value;
      }
    }, builder: (context, snapshot) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 8),
                child: TimeDurationPicker(
                  diameter: 300,
                  icon1Data: Icons.circle_outlined,
                  icon2Data: Icons.circle,
                  knobDecoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.redAccent, Colors.brown],
                    ),
                  ),
                  clockTextStyle: const TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                  clockDecoration: const BoxDecoration(color: Colors.white),
                  onIcon1RotatedCallback: (value) {
                    context.read<ReserveCubit>().changeFrom(value);
                  },
                  onIcon2RotatedCallback: (value) {
                    setState(() {
                      context.read<ReserveCubit>().changeTo(value);
                    });
                  },
                ),
              ),
              Padding(padding:  const EdgeInsetsDirectional.only(bottom: 8),
                child: Text("از ساعت : ${fromTime.toString()}" , textDirection: TextDirection.rtl,),
              ),
              Padding(padding:  const EdgeInsetsDirectional.only(bottom: 8),
                child: Text("تا ساعت : ${toTime.toString()}",textDirection: TextDirection.rtl,),
              ),
              CustomButton(
                isLoading: isLoading,
                text: "ثبت",
                onTap: () {
                  context.read<ReserveCubit>().reserve(
                        from: fromTime ,
                        to: toTime ,
                      );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
