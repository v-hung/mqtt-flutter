import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<MqttServerClient> connect() async {
  // MqttServerClient client = MqttServerClient.withPort('broker.hivemq.com', 'client-1', 1883);
  MqttServerClient client = MqttServerClient('103.75.186.218', '');
  client.port = 1883;
  client.logging(on: true);
  client.keepAlivePeriod = 30;
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;

  final connMessage = MqttConnectMessage()
    .withClientIdentifier("client_1")
    .keepAliveFor(30)
    // .authenticateAs('username', 'password')
    // .withWillTopic('willtopic')
    // .withWillMessage('Will message')
    // .startClean()
    .withWillQos(MqttQos.atLeastOnce);

  client.connectionMessage = connMessage;

  try {
    print('client connecting....');
    await client.connect();
  } catch (e) {
    print('-------------------error--------------------------');
    print('Exception: $e');
    print('--------------------------------------------------');
    client.disconnect();
  }

  // print(client.connectionStatus?.state == MqttConnectionState.connected);

  // client.subscribe('test', MqttQos.atMostOnce);

  client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);

    print('Received message:$payload from topic: ${c[0].topic}>');
  });

  client.published?.listen((MqttPublishMessage message) {
    print('EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });

  final builder = MqttClientPayloadBuilder();
  builder.addString('Hello from mqtt_client');

  client.publishMessage('test', MqttQos.exactlyOnce, builder.payload!);

  return client;
}

void onConnected() {
  print('Connected');
}

// unconnected
void onDisconnected() {
  print('Disconnected');
}

// subscribe to topic succeeded
void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

// subscribe to topic failed
void onSubscribeFail(String topic) {
  print('Failed to subscribe $topic');
}

// unsubscribe succeeded
void onUnsubscribed(String? topic) {
  print('Unsubscribed topic: $topic');
}

// PING response received
void pong() {
  print('Ping response client callback invoked');
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VlcPlayerController _videoPlayerController = VlcPlayerController.network(
    'rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4',
    hwAcc: HwAcc.full,
    autoPlay: true,
    options: VlcPlayerOptions(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mqtt flutter'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          // alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () async {
                  await connect();
                },
                child: const Text('connect'),
              ),
              const SizedBox(height: 20,),
              VlcPlayer(
                controller: _videoPlayerController, 
                aspectRatio: 16/9,
                placeholder: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}