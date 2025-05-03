import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_summer/constants/color.dart';

class InfomationPage extends StatelessWidget {
  const InfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {}

    final List<String> imagePathsClear = [
      'assets/bottle/clear01.png',
      'assets/bottle/clear02.png',
      'assets/bottle/clear03.png',
      'assets/bottle/clear04.png',
    ];
    final List<String> imagePathsCloudy = [
      'assets/bottle/Cloudy01.png',
      'assets/bottle/Cloudy02.png',
      'assets/bottle/Cloudy03.png',
      'assets/bottle/Cloudy04.png',
    ];
    final List<String> imagePathsColor = [
      'assets/bottle/Color01.png',
      'assets/bottle/Color02.png',
      'assets/bottle/Color03.png',
      'assets/bottle/Color04.png',
    ];
    final List<String> imagePathsOther = [
      'assets/bottle/Other01.png',
      'assets/bottle/Other02.png',
      'assets/bottle/Other03.png',
      'assets/bottle/Other04.png',
    ];
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.clear_plas,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.descri_1,
                style: const TextStyle(fontSize: 15, color: FontColor),
              ),
              const SizedBox(height: 5),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  mainAxisSpacing: 15, // spacing between rows
                  crossAxisSpacing: 15, // spacing between columns
                  childAspectRatio: 1.5, // aspect ratio of each item
                ),
                itemCount: 4, // total items in grid
                itemBuilder: (context, index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Image.asset(
                        imagePathsClear[index],
                      ),
                    ),
                  );
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Expanded(
                    flex: 40,
                    child: Divider(
                      thickness: 1.5,
                      color: SecondaryColor,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.cloudy_plas,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.descri_2,
                style: const TextStyle(fontSize: 15, color: FontColor),
              ),
              const SizedBox(height: 5),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  mainAxisSpacing: 15, // spacing between rows
                  crossAxisSpacing: 15, // spacing between columns
                  childAspectRatio: 1.5, // aspect ratio of each item
                ),
                itemCount: 4, // total items in grid
                itemBuilder: (context, index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Image.asset(
                        imagePathsCloudy[index],
                      ),
                    ),
                  );
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Expanded(
                    flex: 40,
                    child: Divider(
                      thickness: 1.5,
                      color: SecondaryColor,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.color_plas,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.descri_3,
                style: const TextStyle(fontSize: 15, color: FontColor),
              ),
              const SizedBox(height: 5),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  mainAxisSpacing: 15, // spacing between rows
                  crossAxisSpacing: 15, // spacing between columns
                  childAspectRatio: 1.5, // aspect ratio of each item
                ),
                itemCount: 4, // total items in grid
                itemBuilder: (context, index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Image.asset(
                        imagePathsColor[index],
                      ),
                    ),
                  );
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Expanded(
                    flex: 40,
                    child: Divider(
                      thickness: 1.5,
                      color: SecondaryColor,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.other,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.descri_4,
                style: const TextStyle(fontSize: 15, color: FontColor),
              ),
              const SizedBox(height: 5),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  mainAxisSpacing: 15, // spacing between rows
                  crossAxisSpacing: 15, // spacing between columns
                  childAspectRatio: 1.5, // aspect ratio of each item
                ),
                itemCount: 4, // total items in grid
                itemBuilder: (context, index) {
                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Image.asset(
                        imagePathsOther[index],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
