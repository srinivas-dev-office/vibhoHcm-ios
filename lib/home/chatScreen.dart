import 'dart:math';

import 'package:vibeshr/untils/export_file.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  ServiceController serviceController = Get.put(ServiceController());

  List<ChatMessage> messages = [
    ChatMessage(
        messageContent: "Hi👋🏻 I'm Vibhohcm bot. How can i assist you today?",
        messageType: "receiver"),
    ChatMessage(
        messageContent: "I Want To Apply For Leave",
        messageType: "option",
        identifier: 1),
    ChatMessage(
        messageContent: "Check Status Of Last Applied Leave",
        messageType: "option",
        identifier: 2),
    ChatMessage(
        messageContent: "How many leaves do i have?",
        messageType: "option",
        identifier: 3),
    ChatMessage(
        messageContent: "Payslip of this month",
        messageType: "option",
        identifier: 4),
    ChatMessage(
        messageContent: "Attendance report for this month",
        messageType: "option",
        identifier: 5),
    ChatMessage(
        messageContent: "Check In Today", messageType: "option", identifier: 6),
  ];
  bool isSend = false;
  Map messageData = {};
  Future chatAPI(String message) async {
    setState(() {
      isSend = true;
    });
    Map data = await Services.chatWithBot(
        message: message, endpoint:
         
         "https://chatbot.vibhohcm.com/api/Chatbot/get-response"
        );
    messageData = data;
    try {
      if (messageData != {}) {
        setState(() {
          messages.add(ChatMessage(
              messageContent: messageData["data"]["choices"][0]["message"]
                  ["content"],
              messageType: "receiver"));
        });
      }
    } catch (e) {
      setState(() {
        messages.add(ChatMessage(
            messageContent: messageData["message"], messageType: "receiver"));
      });
    }
    // }
    setState(() {
      isSend = false;
    });
  }

  Future chatAPIOptions(Map payload) async {
    setState(() {
      isSend = true;
    });
    Map data = await Services.chatWithBot(
        message: payload,
        endpoint:
        // "https://chatbot.vibhohcm.com/api"
            "https://chatbot.vibhohcm.com/api/Static/get-response"
    // https://aichatbot-backend-303t.onrender.com/api/Chatbot/get-response
    );
    messageData = data;
    if (messageData != {}) {
      if (messageData["options"] == null) {
        if (messageData["widget"] != null) {
          setState(() {
            messages.add(ChatMessage(
                messageContent: messageData["message"],
                identifier: messageData["identifier"],
                messageType: "widget"));
          });
        } else {
          setState(() {
            messages.add(ChatMessage(
                messageContent: messageData["message"],
                messageType: "receiver"));
          });
        }
      } else {
        setState(() {
          for (int i = 0; i < messageData["options"].length; i++) {
            messages.add(ChatMessage(
                messageContent: messageData["options"][i]["value"],
                identifier: messageData["options"][i]["identifier"],
                messageType: "option"));
          }
        });
      }
    }
    // }
    setState(() {
      isSend = false;
    });
  }

  String messageSending = "";
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kwhite,
      //  backgroundColor: Kbackground,
      appBar: VibhoAppBar(
        bColor: Kwhite,
        title: "Chat board",
        trailing: GestureDetector(
          onTap: () {
            Get.toNamed(KNotification);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Image.asset(
              "assets/images/bell.png",
              width: 25,
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(children: [
              ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return messages[index].messageType == "widget"
                      ? GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015, 8),
                              lastDate: DateTime(2101),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      // background: white,
                                      primary: KOrange,
                                      //onPrimary: white,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        primary: Kbluedark,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            setState(() {
                              messages.add(ChatMessage(
                                  messageContent: picked.toString(),
                                  messageType: "sender"));
                              chatAPIOptions({
                                "identifier": messages[index].identifier,
                                "value": picked.toString()
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10.r, top: 2.r),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: Colors.black,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  messages[index].messageContent!,
                                  style: TextStyle(
                                      letterSpacing: 0.5,
                                      wordSpacing: 1,
                                      fontSize: 12.sp,
                                      fontWeight: kFW700,
                                      color: Kwhite),
                                ),
                              ),
                            ),
                          ),
                        )
                      : messages[index].messageType == "option"
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  messages.add(ChatMessage(
                                      messageContent:
                                          messages[index].messageContent,
                                      messageType: "sender"));
                                  chatAPIOptions({
                                    "identifier": messages[index].identifier,
                                    "value": messages[index].messageContent
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10.r, top: 2.r),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Colors.black,
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      messages[index].messageContent!,
                                      style: TextStyle(
                                          letterSpacing: 0.5,
                                          wordSpacing: 1,
                                          fontSize: 12.sp,
                                          fontWeight: kFW700,
                                          color: Kwhite),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(10.r),
                              child: Align(
                                alignment:
                                    (messages[index].messageType == "receiver"
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    color: (messages[index].messageType ==
                                            "receiver"
                                        ? Colors.grey.shade200
                                        : Klightpink),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    messages[index].messageContent!,
                                    style: TextStyle(
                                        letterSpacing: 0.5,
                                        wordSpacing: 1,
                                        fontSize: 12.sp,
                                        fontWeight: kFW700,
                                        color: Klight),
                                  ),
                                ),
                              ),
                            );
                },
              ),
              const SizedBox(
                height: 100,
              )
            ]),
          ),
          isSend == false
              ? const SizedBox()
              : const Align(
                  alignment: Alignment.bottomLeft,
                  child: SpinKitThreeBounce(
                    color: KOrange,
                    size: 30.0,
                  ),
                ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Container(
          //     margin: EdgeInsets.all(10.r),
          //     padding: const EdgeInsets.all(10),
          //     height: 60,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(13.r),
          //         //color: KOrange.withOpacity(0.3),
          //         color: Klightpink),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         // GestureDetector(
          //         //   onTap: () {},
          //         //   child: Container(
          //         //     height: 30,
          //         //     width: 30,
          //         //     decoration: BoxDecoration(
          //         //       color: Colors.lightBlue,
          //         //       borderRadius: BorderRadius.circular(30),
          //         //     ),
          //         //     child: const Icon(
          //         //       Icons.add,
          //         //       color: Colors.white,
          //         //       size: 20,
          //         //     ),
          //         //   ),
          //         // ),
          //         const SizedBox(
          //           width: 5,
          //         ),
          //         Expanded(
          //           child: TextField(
          //             controller: serviceController.message,
          //             onChanged: (value) {
          //               setState(() {
          //                 messageSending = value;
          //               });
          //             },
          //             decoration: InputDecoration(
          //                 hintText: "Send message........",
          //                 hintStyle: TextStyle(
          //                     color: KdarkText.withOpacity(0.8),
          //                     fontSize: 13.sp,
          //                     fontWeight: kFW500),
          //                 border: InputBorder.none),
          //           ),
          //         ),
          //         const SizedBox(
          //           width: 15,
          //         ),
          //         FloatingActionButton(
          //           onPressed: () {
          //             setState(() {
          //               messages.add(ChatMessage(
          //                   messageContent: serviceController.message.text,
          //                   messageType: "sender"));
          //               messageSending = serviceController.message.text;
          //               serviceController.message.clear();
          //               FocusManager.instance.primaryFocus?.unfocus();
          //               chatAPI(messageSending);
          //             });
          //           },
          //           child: Icon(
          //             Icons.send,
          //             color: Kwhite,
          //             size: 18,
          //           ),
          //           backgroundColor: KOrange,
          //           elevation: 10,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomSheet: BottomSheet(
        backgroundColor: Colors.white,
        onClosing: () {},
        builder: (context) {
          return Container(
            margin: EdgeInsets.all(10.r),
            padding: const EdgeInsets.all(10),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.r),
                //color: KOrange.withOpacity(0.3),
                color: Klightpink),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     height: 30,
                //     width: 30,
                //     decoration: BoxDecoration(
                //       color: Colors.lightBlue,
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: const Icon(
                //       Icons.add,
                //       color: Colors.white,
                //       size: 20,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                    controller: serviceController.message,
                    onChanged: (value) {
                      setState(() {
                        messageSending = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Send message........",
                        hintStyle: TextStyle(
                            color: KdarkText.withOpacity(0.8),
                            fontSize: 13.sp,
                            fontWeight: kFW500),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      messages.add(ChatMessage(
                          messageContent: serviceController.message.text,
                          messageType: "sender"));
                      messageSending = serviceController.message.text;
                      serviceController.message.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                      chatAPI(messageSending);
                    });
                  },
                  child: Icon(
                    Icons.send,
                    color: Kwhite,
                    size: 18,
                  ),
                  backgroundColor: KOrange,
                  elevation: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChatMessage {
  String? messageContent;
  String? messageType;
  dynamic identifier;
  ChatMessage(
      {@required this.messageContent,
      @required this.messageType,
      this.identifier});
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.showIndicator = false,
    this.bubbleColor = KOrange,
    this.flashingCircleDarkColor = Kwhite,
    this.flashingCircleBrightColor = Ktextcolor,
  });

  final bool showIndicator;
  final Color bubbleColor;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _appearanceController;

  late Animation<double> _indicatorSpaceAnimation;

  late Animation<double> _smallBubbleAnimation;
  late Animation<double> _mediumBubbleAnimation;
  late Animation<double> _largeBubbleAnimation;

  late AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1.0),
  ];

  @override
  void initState() {
    super.initState();

    _appearanceController = AnimationController(
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _indicatorSpaceAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    ).drive(Tween<double>(
      begin: 0.0,
      end: 60.0,
    ));

    _smallBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    _mediumBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _largeBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.showIndicator) {
      _showIndicator();
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _showIndicator();
      } else {
        _hideIndicator();
      }
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _repeatingController.dispose();
    super.dispose();
  }

  void _showIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 750)
      ..forward();
    _repeatingController.repeat();
  }

  void _hideIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 150)
      ..reverse();
    _repeatingController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _indicatorSpaceAnimation,
      builder: (context, child) {
        return SizedBox(
          height: _indicatorSpaceAnimation.value,
          child: child,
        );
      },
      child: Stack(
        children: [
          AnimatedBubble(
            animation: _smallBubbleAnimation,
            left: 6,
            bottom: 6,
            bubble: CircleBubble(
              size: 6,
              bubbleColor: widget.bubbleColor,
            ),
          ),
          AnimatedBubble(
            animation: _mediumBubbleAnimation,
            left: 10,
            bottom: 10,
            bubble: CircleBubble(
              size: 16,
              bubbleColor: widget.bubbleColor,
            ),
          ),
          AnimatedBubble(
            animation: _largeBubbleAnimation,
            left: 12,
            bottom: 12,
            bubble: StatusBubble(
              repeatingController: _repeatingController,
              dotIntervals: _dotIntervals,
              flashingCircleDarkColor: widget.flashingCircleDarkColor,
              flashingCircleBrightColor: widget.flashingCircleBrightColor,
              bubbleColor: widget.bubbleColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBubble extends StatelessWidget {
  const AnimatedBubble({
    super.key,
    required this.animation,
    required this.left,
    required this.bottom,
    required this.bubble,
  });

  final Animation<double> animation;
  final double left;
  final double bottom;
  final Widget bubble;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            alignment: Alignment.bottomLeft,
            child: child,
          );
        },
        child: bubble,
      ),
    );
  }
}

class StatusBubble extends StatelessWidget {
  const StatusBubble({
    super.key,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
    required this.bubbleColor,
  });

  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: bubbleColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlashingCircle(
            index: 0,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
          FlashingCircle(
            index: 1,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
          FlashingCircle(
            index: 2,
            repeatingController: repeatingController,
            dotIntervals: dotIntervals,
            flashingCircleDarkColor: flashingCircleDarkColor,
            flashingCircleBrightColor: flashingCircleBrightColor,
          ),
        ],
      ),
    );
  }
}

class FlashingCircle extends StatelessWidget {
  const FlashingCircle({
    super.key,
    required this.index,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
  });

  final int index;
  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repeatingController,
      builder: (context, child) {
        final circleFlashPercent = dotIntervals[index].transform(
          repeatingController.value,
        );
        final circleColorPercent = sin(pi * circleFlashPercent);

        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              flashingCircleDarkColor,
              flashingCircleBrightColor,
              circleColorPercent,
            ),
          ),
        );
      },
    );
  }
}

class FakeMessage extends StatelessWidget {
  const FakeMessage({
    super.key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      height: isBig ? 128 : 36,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.grey.shade300,
      ),
    );
  }
}

class CircleBubble extends StatelessWidget {
  const CircleBubble({
    super.key,
    required this.size,
    required this.bubbleColor,
  });

  final double size;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bubbleColor,
      ),
    );
  }
}
