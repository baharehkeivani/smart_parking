import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking/logic/data/car_state_screen_cubit.dart';
import 'package:smart_parking/ui/screen/car_state_screen.dart';
import 'package:smart_parking/ui/screen/reserve_modal.dart';

import '../../logic/data/main_screen_cubit.dart';
import '../../logic/data/reserve_cubit.dart';
import '../../logic/model/lot_model.dart';
import '../../module/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime lastUpdate = DateTime.now();
  DateTime now = DateTime.now();

  @override
  void initState() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      context.read<MainScreenCubit>().updateNow();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text(
            'پارکینگ هوشمند',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: context.read<MainScreenCubit>().logout,
          ),
        ),
        body: BlocConsumer<MainScreenCubit, MainScreenState>(
            listener: (context, state) {
          if (state is UpdateSuccessState) {
            lastUpdate = DateTime.now();
            now = DateTime.now();
          }
          if (state is UpdateNowState) {
            now = DateTime.now();
          }
          if (state is LogoutState) {
            context.pushReplacement('/');
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.only(start: 10, end: 4),
                        child: Text(
                          "آخرین به روز رسانی :",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${now.difference(lastUpdate).inMinutes} دقیقه پیش',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed:
                            context.read<MainScreenCubit>().getSpacesStatus,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child:
                            Column(children: _parkingSectionsUI(isLeft: false)),
                      ),
                      Flexible(
                          child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: 30,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black12,
                        ),
                      )),
                      Flexible(
                        child:
                            Column(children: _parkingSectionsUI(isLeft: true)),
                      ),
                    ],
                  ),
                ),
                Text(
                  "تعداد جایگاه خالی : ${context.read<MainScreenCubit>().lots.where((element) => element.status == LotStatus.free).length}",
                )
              ],
            ),
          );
        }));
  }

  List<Widget> _parkingSectionsUI({required bool isLeft}) {
    const borderSide = BorderSide(color: Colors.black12, width: 2);

    return List.generate(
      context.read<MainScreenCubit>().carsEachColumn,
      (index) {
        Widget child = const SizedBox();

        final lot = context.read<MainScreenCubit>().lots[index +
            (isLeft ? 0 : context.read<MainScreenCubit>().carsEachColumn)];

        switch (lot.status) {
          case LotStatus.free:
            child = Text(
              'LOT ${lot.x + 1}-${lot.y + 1}',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            );
            break;
          case LotStatus.occupied:
            child = Image.asset('assets/image/car.png');
            break;
          case LotStatus.reserved:
            child = Text(
              Constants.instance.lotStates[LotStatus.reserved]!,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            );
            break;
        }
        return GestureDetector(
          onTap: () {
            if (lot.x == Constants.instance.userModel?.carSpace?.x &&
                lot.y == Constants.instance.userModel?.carSpace?.y) {
              showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                        surfaceTintColor: Colors.transparent,
                        title: const Text(
                          "وضعیت فعلی خودرو",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        content: BlocProvider(
                          create: (dialogContext) => CarStateScreenCubit(),
                          child: const CarStateScreen(),
                        ),
                        actions: [
                          FilledButton(
                            onPressed: dialogContext.pop,
                            child: const Text(
                              "متوجه شدم.",
                              textDirection: TextDirection.rtl,
                            ),
                          )
                        ],
                      ));
            } else if (lot.status == LotStatus.free) {
              showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (context) => BlocProvider(
                        create: (context) => ReserveCubit(),
                        child: const ReserveModal(),
                      ));
            }
          },
          child: Container(
            height: 80,
            width: 100,
            decoration: BoxDecoration(
              border: Border(
                left: isLeft ? borderSide : BorderSide.none,
                right: !isLeft ? borderSide : BorderSide.none,
                top: borderSide,
                bottom:
                    index == context.read<MainScreenCubit>().carsEachColumn - 1
                        ? borderSide
                        : BorderSide.none,
              ),
              borderRadius: index == 0
                  ? BorderRadius.only(
                      topLeft: isLeft ? const Radius.circular(12) : Radius.zero,
                      topRight:
                          !isLeft ? const Radius.circular(12) : Radius.zero,
                    )
                  : index == context.read<MainScreenCubit>().carsEachColumn - 1
                      ? BorderRadius.only(
                          bottomLeft:
                              isLeft ? const Radius.circular(12) : Radius.zero,
                          bottomRight:
                              !isLeft ? const Radius.circular(12) : Radius.zero,
                        )
                      : BorderRadius.zero,
              color: lot.x == Constants.instance.userModel?.carSpace?.x &&
                      lot.y == Constants.instance.userModel?.carSpace?.y
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.transparent,
            ),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
}
