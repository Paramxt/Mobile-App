import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'web_socket_notifier.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Consumer<WebSocketNotifier>(
        builder: (context, notifier, child) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.noti,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        notifier.clearNotifications(); // ล้างการแจ้งเตือน
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: notifier.notifications.isNotEmpty
                      ? ListView.builder(
                          itemCount: notifier.notifications.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(notifier.notifications[index]),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            AppLocalizations.of(context)!.no_noti,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
