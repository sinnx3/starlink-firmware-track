DROP TABLE IF EXISTS fw_versions;
DROP TABLE IF EXISTS notes;

CREATE TABLE fw_versions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date_added TEXT NOT NULL,
  type TEXT NOT NULL,
  version_info TEXT NOT NULL,
  reddit_thread TEXT
);

CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date_added TEXT NOT NULL,
  note TEXT NOT NULL,
  version_id INTEGER NOT NULL,
  FOREIGN KEY (version_id) REFERENCES fw_versions (id)
);

-- Init import from spreadsheet at time of website launch

-- INSERT INTO fw_versions (type, date_added, version_info, reddit_thread)
-- -- Dishy Firmware
-- VALUES 
-- ('dishy', '2020-10-26', '???', ''),
-- ('dishy', '2020-11-01', 'Old version: ____654.release', ''),
-- ('dishy', '2020-11-10', 'New version: ____758.release', ''),
-- ('dishy', '2020-11-20', 'e2447448-74b0-42f7-b6c8-2bb5a608871a.release', ''),
-- ('dishy', '2020-11-23', '56d5e0aa-c1e8-4d25-aa65-dd8699aaaf62.release', ''),
-- ('dishy', '2020-11-29', '37f8cd77-1e7c-47ea-b1a5-de99ebf16dee.release', ''),
-- ('dishy', '2020-12-06', '5eb22757-5bc1-440f-ab64-9d5053986827.release', ''),
-- ('dishy', '2020-12-11', 'e09928da-4e31-4040-a34e-61d38c10b37f.release', ''),
-- ('dishy', '2020-12-19', '0a3e5881-1312-453f-9c97-8aa7fa2abb89.release', ''),
-- ('dishy', '2021-01-09', '48b97eee-bda8-4593-b1d2-785ad4e493de.release', ''),
-- ('dishy', '2021-01-24', 'd9aff5fa-0334-49bc-b69d-b92a9c7871fa.release', ''),
-- ('dishy', '2021-02-01', '3a1d5d0c-c93b-40b8-a884-021a9c1da1dc.release', ''),
-- ('dishy', '2021-02-09', 'e68dfc80-fa1a-4fa4-9b21-d7ee2a918496.release', ''),
-- ('dishy', '2021-02-12', '7db91a39-b61e-43fe-8bbe-ecb570197cae.release', ''),
-- ('dishy', '2021-02-19', 'a95d0312-a6de-412e-9379-c6bee964f9e0.release', ''),
-- ('dishy', '2021-03-03', '848e54d2-015a-49cb-a814-34d7c5fc7e1a.release', ''),
-- ('dishy', '2021-03-09', 'a8a9195a-8258-4dfc-8b5e-15f272cc2436.release', ''),
-- ('dishy', '2021-03-17', '19f05dfc-9d07-4989-b47f-87c8f87b0a25.release', ''),
-- ('dishy', '2021-03-18', 'd61f015c-556a-42b4-ac91-d8e41d157871.release', ''),
-- ('dishy', '2021-03-21', '39d476b5-2102-44ec-bb7e-e526cc8f94f8.release', ''),
-- ('dishy', '2021-03-22', '5f1ea9d9-7896-44da-821a-7a1ab07e78b9.release', ''),
-- ('dishy', '2021-03-24', 'bbd50ae9-da59-4f1d-b0e4-57c776b31ad1.release', ''),
-- ('dishy', '2021-03-26', 'b44f4294-6a78-4a57-b41c-5b613617086a.release', ''),
-- ('dishy', '2021-04-01', '3912b4a3-9eaf-4f9e-81a3-18d8c837a26b.release', ''),
-- ('dishy', '2021-04-07', '89d35d68-5aa5-456a-9727-75f325ccdf46.release', ''),
-- ('dishy', '2021-04-14', '57d28427-764b-40de-9c10-fcac5cd7e956.release', ''),
-- ('dishy', '2021-04-21', 'feb4dfde-e080-4e6a-bcbe-21511ee9c8bc.release', ''),
-- ('dishy', '2021-04-28', '1f86ec34-34ea-4e7a-9758-3842e72422fb.release', ''),
-- ('dishy', '2021-05-01', 'c8d90754-fd1e-45e6-b1a9-643c25725696.release', ''),
-- ('dishy', '2021-05-05', '3da423b9-e7aa-4cc8-949a-34a1169c81b8.release', ''),
-- ('dishy', '2021-05-07', 'fd689710-a5ee-45c8-9c8a-ff15c943cd70.release', ''),
-- ('dishy', '2021-05-12', '68fdc22b-c4ca-4ee8-92c5-2b51d07ef282.release', ''),
-- ('dishy', '2021-05-18', '1752790c-3c41-4df6-96b1-037e914d842c.uterm.release', ''),
-- ('dishy', '2021-06-03', 'db6b5d22-a642-43d6-bbec-97a816e3dbd6.uterm.release', ''),
-- ('dishy', '2021-06-15', 'a4908729-5051-4d3b-aacc-446ef9b26cdc.uterm.release', ''),
-- ('dishy', '2021-06-21', '990b956d-a7fc-4c9b-a3ab-c09a309ac425.uterm.release', ''),
-- ('dishy', '2021-06-25', '4990ce8d-5028-4e51-a015-e9ab1b1ebe1a.uterm.release ', ''),
-- ('dishy', '2021-06-30', '26d12814-ee70-4c5c-8ef4-d18ea55e409c.uterm.release', ''),
-- ('dishy', '2021-07-09', '2bc83694-2dec-48c8-9061-88b86cdd5d89.uterm.release', ''),
-- ('dishy', '2021-07-14', '61627314-cce5-482b-bf9a-e516b4d8b8e0.uterm.release', ''),
-- ('dishy', '2021-07-26', '6390f89c-448c-4fe6-8e1c-14708993ef7c.uterm.release', ''),
-- ('dishy', '2021-07-28', 'e825ab2c-1e21-4e24-bc77-6ffe80e76669.uterm.release', ''),
-- ('dishy', '2021-08-04', '2f1e0cbf-f2ab-499e-a515-6dd702e23d0c.uterm.release', ''),
-- ('dishy', '2021-08-12', '04295e41-1659-4d0e-bf7a-3e5793aa930b.uterm.release', ''),
-- ('dishy', '2021-08-21', 'ffbfa775-4438-44aa-8cf8-be2cf0485d9c.uterm.release', ''),
-- ('dishy', '2021-08-26', 'f9ff8ff1-b950-4524-8515-a105a2709cc4.uterm.release', 'https://www.reddit.com/r/Starlink/comments/pc56i6/new_firmware_update/'),
-- ('dishy', '2021-09-04', '145e5395-7df8-4887-92f3-061883259d78.uterm.release', 'https://www.reddit.com/r/Starlink/comments/phpmfv/new_terminal_version_4_hours_ago/'),
-- ('dishy', '2021-09-10', '329e8b03-63e0-4e6b-b7b7-332246516629.uterm.release', 'https://www.reddit.com/r/Starlink/comments/po5sbi/firmware_release/'),
-- ('dishy', '2021-09-15', 'ad4f7638-538d-4de9-a161-f91a6dadc6ee.uterm.release', 'https://www.reddit.com/r/Starlink/comments/pop4y9/new_firmware_received_this_morning_44_ontario/'),
-- ('dishy', '2021-09-22', 'fbed6cae-4e45-4526-82b0-1fd503197f54.uterm.release', 'https://www.reddit.com/r/Starlink/comments/pt0ff3/new_firmware/'),
-- ('dishy', '2021-09-26', '55aa8754-4a14-4c93-be61-a8520373ab9e.uterm.release', 'https://www.reddit.com/r/Starlink/comments/pwa09b/new_firmware_this_morning_556n/'),
-- ('dishy', '2021-09-30', '98601479-46bd-4c5a-acbf-2d4839518ce2.uterm.release', 'https://www.reddit.com/r/Starlink/comments/pyhjqr/firmware_98601479_93021/'),
-- ('dishy', '2021-10-07', '3155b85a-29b0-4de0-8c5e-c23c321bf245.uterm.release', 'https://www.reddit.com/r/Starlink/comments/q4lto5/new_firmware/?'),
-- ('dishy', '2021-10-20', 'bad40e7c-d5e4-4fbc-aee1-d35401e1f0ee.uterm.release', 'https://www.reddit.com/r/Starlink/comments/qbxlje/new_firmware/'),
-- ('dishy', '2021-10-28', 'df17edeb-5964-4be7-a022-1bec132edf8b.uterm.release', 'https://www.reddit.com/r/Starlink/comments/qhdy1n/new_firmware_edf8b/'),
-- ('dishy', '2021-11-02', '593080c7-f17b-4a3b-be52-7e231ab8284e.uterm.release', 'https://www.reddit.com/r/Starlink/comments/qlpghh/new_update/'),
-- ('dishy', '2021-11-10', 'a31345de-c1c5-45d3-be6c-7443438776b9.uterm.release', 'https://www.reddit.com/r/Starlink/comments/qr60dh/new_firmware/'),
-- ('dishy', '2021-11-19', '86bab8ba-c91b-48a2-a495-e9ef466bad1c.uterm.release', 'https://www.reddit.com/r/Starlink/comments/qzlzpm/new_firmware_86bab8bac91b48a2a495e9ef466bad1c/'),
-- ('dishy', '2021-12-02', 'dd5393bc-ecec-4fc6-9c67-4d0fa0cd2e50.uterm.release', 'https://www.reddit.com/r/Starlink/comments/r727qp/new_firmware/'),
-- ('dishy', '2021-12-02', 'ea6ec638-dcb9-419f-a32e-e7b69679c55c.uterm.release', 'https://www.reddit.com/r/Starlink/comments/r767on/firmware_update_122/'),
-- ('dishy', '2021-12-10', 'e6baeba8-7f8a-4a98-a392-7923cbb48980.uterm.release', ''),
-- ('dishy', '2021-12-13', '0a1098c3-8ead-4482-a64c-207e58ffac3d.uterm.release', 'https://www.reddit.com/r/Starlink/comments/rfo4xn/0a1098c38ead4482a64c207e58ffac3dutermrelease/'),
-- ('dishy', '2021-12-18', '0a38f6f7-00f1-4187-bc68-f8ee12545830.uterm.release', 'https://www.reddit.com/r/Starlink/comments/rj60qd/new_firmware_this_morning/'),
-- ('dishy', '2022-01-07', '64ff6712-2820-4582-b1e2-fb0230950957.uterm.release', 'https://www.reddit.com/r/Starlink/comments/rz1pil/great_to_see_my_average_power_is_back_down_to_45/  '),
-- ('dishy', '2022-01-12', '992cafb5-61c7-46a3-9ef7-5907c8cf90fd.uterm.release', 'https://www.reddit.com/r/Starlink/comments/s28l4e/new_fw/'),
-- ('dishy', '2022-01-21', '5564993e-1c93-4219-95b1-3fdb2373c468.uterm.release', 'https://www.reddit.com/r/Starlink/comments/s9ccl8/new_firmware_12122_5564993e/'),
-- ('dishy', '2022-01-28', '46a3d9e8-e05f-4f07-9556-fea1b83ccaac.uterm.release', 'https://www.reddit.com/r/Starlink/comments/selh2f/new_firmware_220128/'),
-- ('dishy', '2022-02-02', 'd4f1288e-cf7f-4df9-b898-71c9f7910c15.uterm.release', 'https://www.reddit.com/r/Starlink/comments/sip3j9/d4f1288ecf7f4df9b89871c9f7910c15utermrelease/'),


-- -- Router Firmware
-- ('router', '2021-03-12', '2020-12-15-ebee324-prod', ''),
-- ('router', '2021-??-??', '2021.1.0.mr987-prod', ''),
-- ('router', '2021-03-18', '2021.5.0.mr1287-prod', ''),
-- ('router', '2021-03-??', '2021.7.0.mr1455-prod', ''),
-- ('router', '2021-04-14', '2021.10.0.mr1742-prod', ''),
-- ('router', '2021-05-04', '2021.12.0.mr2037-prod', ''),
-- ('router', '2021-05-05', '2021.13.0.mr2106-prod', ''),
-- ('router', '2021-05-06', '2021.14.0.mr2130-prod', ''),
-- ('router', '2021-05-08', '2021.15.0.mr2181-prod', ''),
-- ('router', '2021-05-18', '2021.16.0.mr2262-prod', ''),
-- ('router', '2021-05-24', '2021.17.0.mr2358-prod', ''),
-- ('router', '2021-05-25', '2021.18.0.mr2404-prod', ''),
-- ('router', '2021-06-18', '2021.19.0.mr2666-prod', ''),
-- ('router', '2021-07-09', '2021.20.0.mr2920-prod', ''),
-- ('router', '2021-07-18', '2021.22.0.mr3104-prod', ''),
-- ('router', '2021-08-05', '2021.23.0.mr3374-prod', ''),
-- ('router', '2021-08-06', '2021.24.0.mr3451-prod', ''),
-- ('router', '2021-08-17', '2021.26.0.mr3674-prod', ''),
-- ('router', '2021-08-19', '2021.26.1.mr3694-prod', ''),
-- ('router', '2021-08-19', '2021.27.0.mr4629-prod', 'https://www.reddit.com/r/Starlink/comments/pop4y9/new_firmware_received_this_morning_44_ontario/hd377or?utm_source=share&utm_medium=web2x&context=3'),
-- ('router', '2021-09-24', '2021.28.0.mr4964-prod', ''),
-- ('router', '2021-10-03', '2021.29.0.mr5234-prod', ''),
-- ('router', '2021-10-16', '2021.30.0.mr5586-prod', ''),
-- ('router', '2021-10-28', '2021.35.0.mr6087-prod', ''),
-- ('router', '2021-11-06', '2021.38.0.mr6396-prod', ''),
-- ('router', '2021-11-09', '2021.42.0.mr6584-prod', ''),
-- ('router', '2021-11-10', '2021.43.0.mr6661-prod', ''),
-- ('router', '2021-11-15', '2021.44.0.mr6798-prod', 'https://www.reddit.com/r/Starlink/comments/qunrp9/starlink_router_update/'),
-- ('router', '2021-11-15', '2021.45.0.mr6895-prod', 'https://www.reddit.com/r/Starlink/comments/qupq34/new_router_version_2021450mr6895prod/'),
-- ('router', '2021-12-05', '2021.48.0.mr7520-prod', ''),
-- ('router', '2021-12-08', '2021.49.0.mr7621-prod', 'https://www.reddit.com/r/Starlink/comments/rbo63r/starlink_router_update/'),
-- ('router', '2021-12-13', '2021.51.0.mr7792-prod', ''),
-- ('router', '2021-12-19', '2021.52.0.mr8090-prod', ''),
-- ('router', '2022-01-07', '2022.01.0.mr8624-prod', 'https://www.reddit.com/r/Starlink/comments/ryqg40/router_just_rebooted_and_just_found_this/'),
-- ('router', '2022-01-18', '2022.02.0.mr8910-prod', ''),
-- ('router', '2022-01-23', '2022.03.0.mr9052-prod', ''),


-- -- Mobile App Firmware
-- ('app', '2021-08-02', '2.0.3', ''),
-- ('app', '2021-08-04', '2.0.5', ''),
-- ('app', '2021-08-10', '2.0.7', ''),
-- ('app', '2021-08-16', '2.0.8', ''),
-- ('app', '2021-08-26', '2.0.9', ''),
-- ('app', '2021-09-03', '2.0.10', ''),
-- ('app', '2021-09-13', '2.0.11', ''),
-- ('app', '2021-10-20', '2.0.12', ''),
-- ('app', '2021-10-28', '2.0.13', ''),
-- ('app', '2021-11-01', '2.0.14', ''),
-- ('app', '2021-11-09', '2.0.15', ''),
-- ('app', '2021-11-12', '2.0.16', ''),
-- ('app', '2021-11-20', '2.0.17', ''),
-- ('app', '2021-11-23', '2.0.18', ''),
-- ('app', '2021-12-09', '2.0.19', ''),
-- ('app', '2022-01-07', '2.0.20', ''),
-- ('app', '2022-01-15', '2.0.21', ''),


-- -- Web UI Firmware
-- ('web', '2020-01-01', '1.0.20', ''),
-- ('web', '2021-01-23', '1.0.23', ''),
-- ('web', '2021-04-16', '1.0.31', ''),
-- ('web', '2021-05-01', '1.0.35', ''),
-- ('web', '2021-05-26', '1.0.36', ''),
-- ('web', '2021-06-09', '1.0.37', ''),
-- ('web', '2021-06-25', '1.0.38', ''),
-- ('web', '2021-10-07', '2.0.12', ''),
-- ('web', '2021-11-28', '2.0.16', ''),
-- ('web', '2022-01-29', '0.0.0', ''),


-- -- Hardware Firmware
-- ('hardware', '2020-11-05', 'rev1_pre_production', ''),
-- ('hardware', '2021-04-15', 'rev2_proto2', 'https://www.reddit.com/r/Starlink/comments/nq4lia/dish_hardware_versions/'),
-- ('hardware', '2021-10-08', 'rev2_proto3', 'https://www.reddit.com/r/Starlink/comments/q3qb1b/this_is_getting_out_of_hand_now_there_are_two_of/'),
-- ('hardware', '2021-11-09', 'rev2_proto4', ''),
-- ('hardware', '2021-11-19', 'rev3_proto2', '');


-- INSERT INTO notes (date_added, note, version_id)
-- VALUES 
-- -- Dishy Notes
-- ('2020-11-23', 'SNR capped at 9', '5'),
-- ('2021-01-09', '100 ms spikes gone', '10'),
-- ('2021-02-19', 'Added mastNotNearVertical, slowEthernetSpeeds', '15'),
-- ('2021-03-18', 'speed boost, IPv6 improved', '19'),
-- ('2021-04-07', 'DHCP lease reduced to 5 min on LAN side - noticable when using own router running Tomato (DNSmasq restarts every 2.5 min)', '25'),
-- ('2021-04-14', 'Connection seems more stable with less "beta downtime". DHCP 121 (RFC 3442) added eliminating the need for a static route in supported routers (OpenWRT, GoogleWiFi)', '26'),
-- ('2021-04-21', 'obstructions dropped. New gRPC method: dish_emc. Looks unimplemented', '27'),
-- ('2021-04-28', 'Improved latency 60ms to 30ms', '28'),
-- ('2021-05-05', "I have had Starlink since Feb 12th of this year. I'm located in the Mid East of Nevada at 39.25 All I can say now is that it is better than ever for gaming for me. I have been gaming on it since I got it and in the beginning it was a little rough. Short disconnects that would completely boot me from games or having a minute or two of no satellites. But now its great. My speeds have been very consistent. Usually sitting between 180-240ish down. Which is way better then when I first got it where it was all over the place. I have not had a disconnect from a game in over a month. I play FPS games like Warzone/Apex and both have been running great. My latencies are anywhere from 40-100ms which is still very playable for me. I never notice if anyone in my family is playing at the same time either which most the time 3 phones are connected a tv is streaming and 3 of us playing on PC. It has been fantastic these past couple of months. I have loved it since the day I got it and it has showed very consistent progress for me. I can't wait for what the future holds with Starlink.", '30'),
-- ('2021-05-18', 'First version with "uterm" in the version string', '33'),
-- ('2021-06-03', 'Support for drawing a detailed obstruction map in the Starlink mobile app. Appears to handle obstructions better', '34'),
-- ('2021-06-21', 'Removes getDishContext method from public gRPC API (may have been removed also in a slightly earlier version)', '36'),
-- ('2021-06-25', 'network/statistics - Direct link to stats page on the web application (v 1.0.38) does not work. Reloading stats page on the web app (v1.0.38)  does not work (reported as bug)', '37'),
-- ('2021-07-09', 'Current Version as of 7/22 (61627314 appears to have been rolled back)', '39'),
-- ('2021-07-26', "May be update that switches to best satellite, resulting in far fewer network obstructions. Can anyone confirm. (My data says this improvement happened mid-July --Nelson)  I've noticed and agree with Nelson, not one disconnect, gaming has been stellar! -- Smith", '41'),
-- ('2021-07-26', 'UK, getting regular drops on this firmware, video calls/teams  drop 6-7 times/hr - previously none (zero obstructions)', '41'),
-- ('2021-07-28', 'FOV appears to have gotten somewhat smaller. Obstruction time went down as well.', '42'),
-- ('2021-08-04', 'Not experienced this in the UK, its very stable so far.', '43'),
-- ('2021-08-04', 'I have seen a slight uptick in drops, but still less than 30 seconds each day. (Colorado, USA)', '43'),
-- ('2021-08-04', 'Not experiencing in SW Ohio, very stable to date.', '43'),
-- ('2021-08-04', 'Stable in NZ', '43'),
-- ('2021-08-12', 'Improved outage reasons. Starlink support confirms too sensitive to minor "no satellite" outages. Some report they had this version and then were rolled back.', '44'),
-- ('2021-08-12', 'Getting random phantom obstructions in the app with this update, usually for 0.4s. (USA Idaho)', '44'),
-- ('2021-08-12', 'Our stabilty has been horrible this week, worst I have seen thus far (Colorado)', '44'),
-- ('2021-08-21', 'Multiple reports of continous 1-10 second drop outs', '45'),
-- ('2021-08-21', 'I think I received this update late, Starlink stability has improved greatly as of yesterday morning', '45'),
-- ('2021-08-21', 'Stable in EU/NL', '45'),
-- ('2021-09-22', 'Web brower dishy stats still broken', '50'),
-- ('2021-09-26', 'Web brower dishy stats still broken', '51'),
-- ('2021-09-30', 'Stats are working via browser again...!', '52'),
-- ('2021-09-30', 'Stability is trash at the moment. It was rock solid for months and now with the last couple of versions I get major packet loss and latency spikes.', '52'),
-- ('2021-10-07', 'Seems faster?', '53'),
-- ('2021-10-07', 'snr is not reporting in Web or Phone app anymore (shows 0). Other than that, seems okay.', '53'),
-- ('2021-10-07', 'Way faster for me. Consistently lower ping and faster speed.', '53'),
-- ('2021-10-07', 'Suspecting due to no SNR data and debug under snr showing 0 now reports "poor connection"  Seems less latency overall - still up and down on download transfer speeds', '53'),
-- ('2021-10-28', 'Web browser dishy stats working again, slightly more network problems than usual but otherwise ok', '55'),
-- ('2021-11-02', 'Less packet loss', '56'),
-- ('2021-11-19', 'Web browser showing disconnected when trying to view stats/obstructions this way.', '58'),
-- ('2021-11-19', "ditto re-booted system after update and shows 'disconnected' in browser. Manually set host files and most functionality returned to Edge browser.", '58'),
-- ('2021-11-19', "Can't connect to router in Edge or Chrome --- Firefox the only browser that seems to work", '58'),
-- ('2021-12-02', 'Web browser stats work again', '59'),
-- ('2021-12-02', 'Web Browser Stats down again in Microsoft Edge', '60'),
-- ('2021-12-10', 'Download speeds dropped off a bit, could be network issues.', '61'),
-- ('2021-12-10', 'firmware reverted back to ea6ec638', '61'),
-- ('2021-12-13', 'Australia NSW, reduced outages per 12hr period', '62'),
-- ('2021-12-13', 'Ping significantly higher and less stable', '62'),
-- ('2022-01-07', 'Seems much better than 0a38f6f7', '64'),
-- ('2022-01-07', 'Downloads over 300Mbps, Upload hit 58Mbps (1st time since June); Latency loaded lower than normal; 80-90ms', '64'),
-- ('2022-01-07', 'opposite here for me downloads are down and uploads are reduced with higher latency intermitent dropouts  {clear dishy view of sky}', '64'),
-- ('2022-01-12', 'Snow melting setting added, extra debug alerts added.', '65'),
-- ('2022-01-12', 'firmware reverted back to 64ff6712-2820-4582-b1e2-fb0230950957.uterm.release after 7 hours and 38 minutes', '65'),
-- ('2022-01-12', 'Got obstruction for the first time, outages seem more frequent.', '65'),
-- ('2022-01-12', 'seem to have network issues more frequent', '65'),
-- ('2022-01-21', 'shows the snow melt setting on web, but requires you to change it on mobile still', '66'),
-- ('2022-01-21', 'Speed testing UI now on the web version instead of linking to Fast.com - DOES NOT WORK IF using third party router', '66'),
-- ('2022-01-28', 'Constant slower speeds after update (45Mb/s down 20Mb/s up)', '67'),
-- ('2022-02-02', 'Speeds are unchanged from 46a3d9ea, No outages/obstructions reported yet', '68'),


-- -- Router Notes
-- ('2021-03-12', 'Out of box firmware on date of delivery.', '69'),
-- ('2021-??-??', 'Original firmware, shipped 3/8/21', '70'),
-- ('2021-08-19', 'Has anyone received this version yet? If so, any noticeable differences?', '87'),
-- ('2021-10-16', 'Users are reporting rollbacks to 29 10/22/2021 - unknown reason', '91'),
-- ('2021-10-16', 'Confirmed rollback 10/24 back to mr5234', '91'),
-- ('2021-11-15', 'Notice there is a public ipv4 assigned now', '97'),
-- ('2022-01-07', 'Remote troubleshooting', '102'),


-- -- Mobile Notes
-- ('2021-08-02', 'Fully redesigned app that includes dark mode', '105'),
-- ('2021-08-04', 'Reboot router and dish options back in advanced options. Includes option to un-stow dish w/o having to unplug dishy. Dish mount deviation from vertical warning set to 30°, support confirmed it should be 40°.', '106'),
-- ('2021-08-10', 'Improved Outage log, consolidated Support home screen', '107'),
-- ('2021-08-26', 'Outage screen improvements, increase minimum outage duration to 2 second, and bug fixes', '109'),
-- ('2021-09-03', 'Added Speedtest. Shows speed both from your device and directly from the Starlink router.', '110'),
-- ('2021-09-13', 'Added Polish translations', '111'),
-- ('2021-10-20', 'New check for obstructions. Show current outage reason on status screen. Add "Stowed" and "Disconnected" alerts. Added option to setup additional starlink.', '112'),
-- ('2021-10-28', 'Various bug fixes', '113'),
-- ('2021-11-01', 'Improved support topics, additional speed test info.', '114'),
-- ('2021-11-09', 'Various bug fixes', '115'),
-- ('2021-11-12', 'Updated alert messages. Various bug fixes.', '116'),
-- ('2021-11-20', 'Revamped speed test user interface, various bug fixes | Added "Wifi Debug" under advanced button', '117'),
-- ('2021-11-23', 'Various bug fixes per Play store', '118'),
-- ('2021-12-09', 'Improved Support Messages Interface. View PDF Attachments and Billing Statements. Various Bug Fixes. ', '119'),
-- ('2022-01-07', 'Improved Speed test and general bug fixes & improvements.', '120'),
-- ('2022-01-15', 'Add snow melt mode configuration - Add pending software update alert - Various UI improvements', '121'),


-- -- Web Notes
-- ('2020-01-01', 'Dishy Web Client version until Dishy firmware 4990ce8d, when it became 1.0.38', '122'),
-- ('2021-05-01', 'Add WPA3 and allow split 2.4Ghz / 5GHz SSID names', '125'),
-- ('2021-05-26', 'Add connected device details (signal %, IP, MAC, mfg, and connection type)', '126'),
-- ('2021-06-09', 'Improved obstruction diagram', '127'),
-- ('2021-06-25', 'Dishy Web Client update, added check for obstructions', '128'),
-- ('2021-10-07', 'Web portal version listed at 192.168.100.1', '129'),
-- ('2021-11-28', 'Web portal version listed at 192.168.100.1 when using Firefox. Wont pull up in Edge or Chrome', '130'),
-- ('2022-01-29', 'Showing zeroes with 5564993e and mr9052 firmware currently', '131');