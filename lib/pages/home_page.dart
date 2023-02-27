import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mqtt/providers/mqtt_provider.dart';
import 'package:mqtt/utils/colors.dart';
import 'package:mqtt/widgets/bottom_nav_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rive/rive.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // static var now = new DateTime.now();
  // static var formatter = DateFormat ('yyyy-MM-dd');
  // static String formattedDate = formatter.format(now);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final heightSafeArea = MediaQuery.of(context).size.height -
      AppBar().preferredSize.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Thái Nguyên City", style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: primary
            ),),
            const SizedBox(height: 3,),
            Text("Chủ Nhật, 23/2/2023", style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w500,
              color: primary.withOpacity(0.7)
            ),)
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.go('/camera'), 
            icon: const Icon(Icons.stream_rounded),
            color: primary,
          ),
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.menu),
            color: primary,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: size.height - heightSafeArea),
        decoration: BoxDecoration(
          color: Colors.lime[100]
        ),
        child: Stack(
          // fit: StackFit.expand,
          children: [
            SizedBox(
              width: size.width,
              height: heightSafeArea * 0.6 + 20,
              // decoration: BoxDecoration(color: Colors.green),
              child: const RiveAnimation.asset(
                "assets/anim/winter-animation.riv",
                // artboard: "",
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Text("🌦", style: TextStyle(
                        fontSize: 24
                      ),),
                      SizedBox(height: 5,),
                      Text("Mostly\nCloudy", style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),)
                    ],
                  ),
                  const SizedBox(width: 20,),
                  const Text("34°", style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w700
                  ),)
                ],
              ),
            ),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                // expand: false,
                initialChildSize: 0.4,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      // shrinkWrap: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Nhiệt độ bây giờ", style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600
                          ),),
                          const SizedBox(height: 20,),
                          BottomBodyWidget(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar: const BottomNavBarCustom(),
    );
  }
}

class BottomBodyWidget extends ConsumerWidget {
  const BottomBodyWidget({super.key});

  static const List<Map<String, dynamic>> temperatureList = [
    {
      "icon" : Icons.thermostat_auto_rounded,
      "label": "Feel Like",
      "value": "34°"
    },
    {
      "icon" : Icons.wind_power_rounded,
      "label": "Wind",
      "value": "10 km/h"
    },
    {
      "icon" : Icons.umbrella_rounded,
      "label": "Precipitation",
      "value": "50%"
    },
    {
      "icon" : Icons.water_drop_rounded,
      "label": "Humidify",
      "value": "59%"
    }
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for(var i = 0; i < temperatureList.length; i++) ...[
          SizedBox(
            width: (screenSize.width - (15 * 2) - 10 * 2) / 2,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(temperatureList[i]['icon'] as IconData, color: primary, size: 24,),
                ),
                const SizedBox(width: 10,),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(temperatureList[i]['label'], style: TextStyle(
                      fontSize: 12,
                      color: primary.withOpacity(0.7)
                    ),),
                    const SizedBox(height: 3,),
                    Text(temperatureList[i]['value'], style: const TextStyle(
                      // fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: primary
                    ),)
                  ],
                ))
              ],
            ),
          )
        ]
     ],
    );
  }
}