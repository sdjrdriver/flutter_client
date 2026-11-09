import 'package:shared_preferences/shared_preferences.dart';

const String kVoiceCallInProgressChannelIdKey =
    'voice_call_in_progress_channel_id';

/// Gateway connection id of the session in [kVoiceCallInProgressChannelIdKey],
/// so cleanup after an interrupted session disconnects exactly that
/// connection - not the same account on another device, and not a session
/// joined again after the restart.
const String kVoiceCallInProgressConnectionIdKey =
    'voice_call_in_progress_connection_id';

Future<void> markVoiceCallInProgress(
  String channelId, {
  String? connectionId,
}) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(kVoiceCallInProgressChannelIdKey, channelId);
    if (connectionId == null || connectionId.isEmpty) {
      await prefs.remove(kVoiceCallInProgressConnectionIdKey);
    } else {
      await prefs.setString(kVoiceCallInProgressConnectionIdKey, connectionId);
    }
  } on Object {
    return;
  }
}

Future<void> clearVoiceCallInProgress() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(kVoiceCallInProgressChannelIdKey);
    await prefs.remove(kVoiceCallInProgressConnectionIdKey);
  } on Object {
    return;
  }
}

/// Connection id recorded with the interrupted session; call right after
/// [takeInterruptedVoiceCallChannelId]. Reported once.
Future<String?> takeInterruptedVoiceCallConnectionId() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? connectionId = prefs.getString(
      kVoiceCallInProgressConnectionIdKey,
    );
    await prefs.remove(kVoiceCallInProgressConnectionIdKey);
    if (connectionId == null || connectionId.isEmpty) {
      return null;
    }
    return connectionId;
  } on Object {
    return null;
  }
}

Future<String?> takeInterruptedVoiceCallChannelId() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? channelId = prefs.getString(kVoiceCallInProgressChannelIdKey);
    await prefs.remove(kVoiceCallInProgressChannelIdKey);
    if (channelId == null || channelId.isEmpty) {
      return null;
    }
    return channelId;
  } on Object {
    return null;
  }
}
