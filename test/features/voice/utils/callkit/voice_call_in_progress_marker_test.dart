import 'package:flutter_test/flutter_test.dart';
import 'package:fluxer_app/features/voice/utils/callkit/call_in_progress_marker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test(
    'a session that dies in a call is reported once on next launch',
    () async {
      await markVoiceCallInProgress('c1');
      expect(await takeInterruptedVoiceCallChannelId(), 'c1');
      expect(await takeInterruptedVoiceCallChannelId(), isNull);
    },
  );

  test('leaving the call clears the marker', () async {
    await markVoiceCallInProgress('c1');
    await clearVoiceCallInProgress();
    expect(await takeInterruptedVoiceCallChannelId(), isNull);
  });

  test('the connection id is reported with the channel, once', () async {
    await markVoiceCallInProgress('c1', connectionId: 'conn1');
    expect(await takeInterruptedVoiceCallChannelId(), 'c1');
    expect(await takeInterruptedVoiceCallConnectionId(), 'conn1');
    expect(await takeInterruptedVoiceCallConnectionId(), isNull);
  });

  test('a new mark without connection id drops the old one', () async {
    await markVoiceCallInProgress('c1', connectionId: 'conn1');
    await markVoiceCallInProgress('c2');
    expect(await takeInterruptedVoiceCallChannelId(), 'c2');
    expect(await takeInterruptedVoiceCallConnectionId(), isNull);
  });

  test('leaving the call clears the connection id too', () async {
    await markVoiceCallInProgress('c1', connectionId: 'conn1');
    await clearVoiceCallInProgress();
    expect(await takeInterruptedVoiceCallConnectionId(), isNull);
  });

  test('switching channels keeps only the latest channel', () async {
    await markVoiceCallInProgress('c1');
    await markVoiceCallInProgress('c2');
    expect(await takeInterruptedVoiceCallChannelId(), 'c2');
  });
}
