import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt/providers/mqtt_provider.dart';

// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
// }

// class _HomePageState extends ConsumerState<HomePage> {

//   @override
//   void initState() {
//     super.initState();

//     ref.read(mqttProvider.notifier).connect();
//     // print(value); // Hello world
//   }

//   @override
//   Widget build(BuildContext context) {
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   // context.read(stateProvider).state = text;
//     //   print('1');
//     // });
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           child: Consumer(
//             builder: (context, ref, child) {
//               final mqtt = ref.watch(mqttProvider.notifier).state;
//               if (mqtt.connect == MqttState.connected) {
//                 return const Text("Connected");
//               }
//               else if (mqtt.connect == MqttState.connecting) {
//                 return const Text("connecting");
//               }
//               else if (mqtt.connect == MqttState.disconnected) {
//                 return const Text("disconnected");
//               }
//               return Container();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(mqttProvider.notifier).connect();
    // });

    // final list = ref.watch(mqttStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final mqttState = ref.watch(mqttConnectProvider);
                  print('change state');
                  if (mqttState == MqttState.connected) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      color: Colors.green,
                      child: const Text('Connected', style: TextStyle(color: Colors.white),),
                    );
                  }
                  else if (mqttState == MqttState.connecting) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      color: Colors.blue,
                      child: const Text('connecting...', style: TextStyle(color: Colors.white)),
                    );
                  }
                  else if (mqttState == MqttState.disconnected) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      color: Colors.red,
                      child: const Text('Disconnected', style: TextStyle(color: Colors.white)),
                    );
                  }
                  return Container();
                },
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                  ),
                  // child: Consumer(
                  //   builder: (context, ref, child) {
                  //     return ListView.builder(
                  //       itemCount: 4,
                  //       itemBuilder: (context, position) {
                  //         return const Text("1");
                  //       },
                  //     );
                  //   },
                  // )
                  // child: ListView.builder(
                  //   itemCount: data.length,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       title: Text(data.toString()),
                  //     );
                  //   },
                  // )
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(mqttProvider.notifier).sendMessageToTopic('test', 'hello world');
                },
                child: const Text('Send message'),
              ),
              const SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}