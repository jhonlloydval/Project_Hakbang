import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hakbang/features/user/data/user_repo.dart';
import 'package:hakbang/features/user/presentation/design/app_colors.dart';
import 'package:hakbang/features/user/presentation/pages/signup_page.dart';
import 'package:verification_code_field/verification_code_field.dart';

class VerificationTimer extends StatefulWidget {
  final String email;
  final String token;
  const VerificationTimer({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<VerificationTimer> createState() => _VerificationTimerState();
}

class _VerificationTimerState extends State<VerificationTimer> {
  static ValueNotifier<int> endTime = ValueNotifier(
    DateTime.now().millisecondsSinceEpoch + 1000 * 59,
  );
  ValueNotifier<CountdownTimerController> countTime = ValueNotifier(
    CountdownTimerController(endTime: endTime.value),
  );

  Widget _buildCodeField() {
    return VerificationCodeField(
      codeDigit: CodeDigit.six,
      enabled: true,
      filled: true,
      fillColor: AppColors.surface2,
      fieldSize: 40,
      onSubmit: (value) async {
        try {
          var data = await UserRepo.verifyCode(widget.token, value);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(data["message"]),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SignupPage(authFullname: null, authemail: widget.email),
            ),
          );
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(error.toString()),
            ),
          );
        }
      },
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      countTime.value = CountdownTimerController(endTime: endTime.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: Text(
            "Verify Account",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          backgroundColor: AppColors.bg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.textPrimary,
              size: 28,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "To verify your account, please check the verification code sent to your account: ${widget.email} ",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                _buildCodeField(),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: countTime,
                  builder: (context, count, child) {
                    return ValueListenableBuilder(
                      valueListenable: endTime,
                      builder: (context, end, child) {
                        return CountdownTimer(
                          controller: count,
                          endTime: end,
                          widgetBuilder: (context, time) {
                            if (time == null) {
                              return TextButton(
                                onPressed: () {
                                  setState(() {
                                    endTime.value =
                                        DateTime.now().millisecondsSinceEpoch +
                                        1000 * 60;
                                    countTime.value = CountdownTimerController(
                                      endTime: endTime.value,
                                    );
                                  });
                                },
                                child: Text(
                                  "Resend Code?",
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }
                            return Text(
                              ' Resend Verification Email in 00:${time.sec! > 9 ? time.sec : "0${time.sec}"}',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
