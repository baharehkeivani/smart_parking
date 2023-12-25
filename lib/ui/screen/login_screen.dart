import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking/logic/data/login_screen_cubit.dart';
import 'package:smart_parking/ui/widget/custom_button.dart';

import '../widget/flush_bar/flush_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoginMode = true;

  TextEditingController passwordController = TextEditingController();
  FocusNode passwordNode = FocusNode();

  TextEditingController idController = TextEditingController();
  FocusNode idNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  FocusNode nameNode = FocusNode();

  TextEditingController familyNameController = TextEditingController();
  FocusNode familyNameNode = FocusNode();

  TextEditingController carIdController = TextEditingController();
  FocusNode carIdNode = FocusNode();

  TextEditingController carTypeController = TextEditingController();
  FocusNode carTypeNode = FocusNode();

  void submit() {
    if (isLoginMode) {
      context
          .read<LoginScreenCubit>()
          .login(id: idController.text, password: passwordController.text);
    } else {
      context.read<LoginScreenCubit>().signup(
            id: idController.text,
            password: passwordController.text,
            name: nameController.text,
            familyName: familyNameController.text,
            carId: carIdController.text,
            carType: carTypeController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<LoginScreenCubit, LoginScreenState>(
          listener: (context, state) {
            if (state is LoadingState) {
              loading = true;
            }
            if (state is LoginSuccessState) {
              context.pushReplacementNamed("main");
              loading = false;
            }
            if (state is SignUpSuccessState) {
              context.pushReplacementNamed("main");
              loading = false; // TODO : should add verification in the future
            }
            if (state is ToggledModeState) {
              idController.clear();
              passwordController.clear();
              nameController.clear();
              familyNameController.clear();
              carTypeController.clear();
              carIdController.clear();
              formKey.currentState!.reset();
              isLoginMode = !isLoginMode;
            }
            if (state is FailedState) {
              loading = false;
              FlushBar(
                message: state.message,
                borderRadius: BorderRadius.circular(8),
                margin: const EdgeInsets.fromLTRB(8, 64, 8, 0),
                duration: const Duration(seconds: 2),
                flushBarPosition: FlushBarPosition.top,
                textDirection: TextDirection.rtl,
                backgroundColor: Colors.black87,
              ).show(context);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                AnimatedContainer(
                  width: double.infinity,
                  height: isLoginMode
                      ? screenSize.height * 0.6
                      : screenSize.height * 0.2,
                  color: Colors.redAccent,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
                  duration: const Duration(seconds: 1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        AnimatedContainer(
                          height: isLoginMode ? 275 : 0,
                            curve: Curves.linearToEaseOut,
                            duration: const Duration(seconds: 1),
                            child: Image.asset('assets/image/parking.webp')),
                      const Text(
                        "پارکینگ هوشمند",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 36,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if (!isLoginMode)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              focusNode: nameNode,
                              controller: nameController,
                              onTapOutside: (_) {
                                nameNode.unfocus();
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'نام',
                                  hintTextDirection: TextDirection.rtl),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "* الزامی"),
                              ]),
                              onFieldSubmitted: (value) {
                                nameNode.unfocus();
                                familyNameNode.requestFocus();
                              },
                            ),
                          ),
                        if (!isLoginMode)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              focusNode: familyNameNode,
                              controller: familyNameController,
                              onTapOutside: (_) {
                                familyNameNode.unfocus();
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'نام خانوادگی',
                                  hintTextDirection: TextDirection.rtl),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "* الزامی"),
                              ]),
                              onFieldSubmitted: (value) {
                                familyNameNode.unfocus();
                                idNode.requestFocus();
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TextFormField(
                            focusNode: idNode,
                            controller: idController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            onTapOutside: (_) {
                              idNode.unfocus();
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'کد ملی',
                                hintTextDirection: TextDirection.rtl,
                                hintText:
                                    'کد ملی خود را وارد کنید. مثال: ۰۹۱۲۳۴۵۶۷۸'),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "* الزامی"),
                              MinLengthValidator(10,
                                  errorText: "کد ملی صحیح نمی باشد."),
                              MaxLengthValidator(10,
                                  errorText: "کد ملی صحیح نمی باشد."),
                            ]),
                            onChanged: (value) {
                              if (value.length > 10) {
                                idController.text = value.substring(0, 10);
                              }
                              if (value.length == 10) {
                                idNode.unfocus();
                                if (isLoginMode) {
                                  passwordNode.requestFocus();
                                } else {
                                  carIdNode.requestFocus();
                                }
                              }
                            },
                            onFieldSubmitted: (value) {
                              idNode.unfocus();
                              if (isLoginMode) {
                                passwordNode.requestFocus();
                              } else {
                                carIdNode.requestFocus();
                              }
                            },
                          ),
                        ),
                        if (!isLoginMode)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              focusNode: carIdNode,
                              controller: carIdController,
                              onTapOutside: (_) {
                                carIdNode.unfocus();
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'پلاک ماشین',
                                  hintTextDirection: TextDirection.rtl),
                              validator: MultiValidator([
                                RequiredValidator(errorText: "* الزامی"),
                              ]),
                              onFieldSubmitted: (value) {
                                carIdNode.unfocus();
                                carTypeNode.requestFocus();
                              },
                            ),
                          ),
                        if (!isLoginMode)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: TextFormField(
                              focusNode: carTypeNode,
                              controller: carTypeController,
                              onTapOutside: (_) {
                                carTypeNode.unfocus();
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'نوع ماشین',
                                  hintTextDirection: TextDirection.rtl,
                                  hintText: "مثال : پژو پارس زرشکی"),
                              onFieldSubmitted: (value) {
                                carTypeNode.unfocus();
                                passwordNode.requestFocus();
                              },
                            ),
                          ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: isLoginMode ? 24 : 8),
                          child: TextFormField(
                              focusNode: passwordNode,
                              obscureText: true,
                              controller: passwordController,
                              textDirection: TextDirection.rtl,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'گذرواژه',
                                  hintTextDirection: TextDirection.rtl,
                                  hintText: 'گذرواژه خود را وارد کنید.'),
                              onTapOutside: (_) {
                                passwordNode.unfocus();
                              },
                              onFieldSubmitted: (value) {
                                if (formKey.currentState!.validate()) {
                                  submit();
                                }
                              },
                              validator: MultiValidator([
                                RequiredValidator(errorText: "* الزامی"),
                                MinLengthValidator(4,
                                    errorText:
                                        "گذرواژه باید حداقل ۴ حرف داشته باشد."),
                              ]) //Function to check validation
                              ),
                        ),
                        CustomButton(
                          isLoading: loading,
                          text: isLoginMode ? "ورود" : "ثبت نام",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              submit();
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: context.read<LoginScreenCubit>().toggleMode,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(top: 8),
                            child: Text(
                              isLoginMode
                                  ? "ثبت کد ملی در سامانه"
                                  : "ورود به سامانه",
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
