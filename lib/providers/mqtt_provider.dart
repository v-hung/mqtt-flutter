// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

enum MqttState { connected, disconnected, connecting }

class MqttModel {
  MqttState connect;
  MqttServerClient? client; 

  MqttModel({
    required this.connect,
    this.client,
  });

  MqttModel.unknown()
    : connect = MqttState.disconnected;

  MqttModel changeState (MqttState connect) {
    return MqttModel(connect: connect, client: client);
  }
}

class MqttNotifier extends StateNotifier<MqttModel> {
  MqttNotifier(): super(MqttModel.unknown()) {
    connect();
  }

  String clientId = Uuid().v4();
  
  Future<void> init() async {
  }

  Future<void> connect() async {
    state = state.changeState(MqttState.connecting);
    await Future.delayed(const Duration(seconds: 1));
    // MqttServerClient client = MqttServerClient.withPort('broker.hivemq.com', 'client-1', 1883);
    state.client = MqttServerClient('103.75.186.218', '');
    state.client?.port = 1883;
    state.client?.logging(on: true);
    state.client?.keepAlivePeriod = 60;
    
    state.client?.onConnected = onConnected;
    state.client?.onDisconnected = onDisconnected;
    // state.client?.onUnsubscribed = onUnsubscribed;
    // state.client?.onSubscribed = onSubscribed;
    // state.client?.onSubscribeFail = onSubscribeFail;
    // state.client?.pongCallback = pong;

    final connMessage = MqttConnectMessage()
      .withClientIdentifier(clientId)
      // .authenticateAs('username', 'password')
      // .withWillTopic('willtopic')
      // .withWillMessage('Will message')
      // .startClean()
      .withWillQos(MqttQos.atLeastOnce);

    state.client?.connectionMessage = connMessage;

    try {
      await state.client?.connect();
    } catch (e) {
      print('-------------------error--------------------------');
      print('Exception: $e');
      print('--------------------------------------------------');
      state.client?.disconnect();
    }

    // state.client?.subscribe('topic/', MqttQos.atLeastOnce);

    // state.client?.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   print(c);
    //   final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    //   final payload =
    //       MqttPublishPayload.bytesToStringAsString(message.payload.message);
    //   final data = jsonDecode(payload);

    //   print('Received message:$payload from topic: ${c[0].topic}>');
    // });

     const topic = 'test'; // Not a wildcard topic
  state.client?.subscribe(topic, MqttQos.atMostOnce);

  /// The client has a change notifier object(see the Observable class) which we then listen to to get
  /// notifications of published updates to each subscribed topic.
  state.client?.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMess = c![0].payload as MqttPublishMessage;
    final pt =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print(
        'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    print('');
  });

  /// If needed you can listen for published messages that have completed the publishing
  /// handshake which is Qos dependant. Any message received on this stream has completed its
  /// publishing handshake with the broker.
  state.client?.published!.listen((MqttPublishMessage message) {
    print(
        'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
  });

    

    // client.subscribe('test', MqttQos.atMostOnce);

    // client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    //   final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
    //   final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);

    //   print('Received message:$payload from topic: ${c[0].topic}>');
    // });

    // client.published?.listen((MqttPublishMessage message) {
    //   print('EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    // });

    // final builder = MqttClientPayloadBuilder();
    // builder.addString('Hello from mqtt_client');

    // client.publishMessage('test', MqttQos.exactlyOnce, builder.payload!);
  }

  void onConnected() {
    print('Connected');
    state = state.changeState(MqttState.connected);
  }

  // unconnected
  void onDisconnected() {
    print('Disconnected');
    state = state.changeState(MqttState.disconnected);
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
    // print('Ping response client callback invoked');
  }

  void sendMessageToTopic(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    state.client?.publishMessage('test', MqttQos.exactlyOnce, builder.payload!);
    print('send message');
  }

  void subscribeTopic(String topic) {
    print('subscribeTopic');
    print(state.connect);
    if (state.connect != MqttState.connected) return;
      state.client?.subscribe(topic, MqttQos.atMostOnce);

      state.client?.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
  }
}

final mqttProvider = StateNotifierProvider<MqttNotifier, MqttModel>((ref) {
  return MqttNotifier();
});


final mqttConnectProvider = Provider<MqttState>((ref) {
  final mqtt = ref.watch(mqttProvider);
  return mqtt.connect;
});

