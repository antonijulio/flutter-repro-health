import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reprohealth_app/constant/assets_constants.dart';
import 'package:reprohealth_app/constant/routes_navigation.dart';
import 'package:reprohealth_app/screen/forum/view_model/forum_view_model.dart';
import 'package:reprohealth_app/theme/theme.dart';

class LihatForumWidget extends StatelessWidget {
  const LihatForumWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ForumViewModel>(context, listen: false).getForumList();
    return Consumer<ForumViewModel>(
      builder: (context, forumViewModel, child) {
        // Mendapatkan daftar forum
        final forumList = forumViewModel.forumList;

        // Mendapatkan hasil pencarian daftar forum
        final searchResults = forumViewModel.searchResults;
        final displayedList = searchResults ?? forumList?.response;

        // Urutkan forumListnya berdasarkan kriteria yang berbeda
        forumList?.response?.sort((a, b) {
          // Terbaru
          if (forumViewModel.kategoriListMap.contains('Terbaru')) {
            return b.date?.compareTo(a.date ?? DateTime(0)) ?? 0;
          }

          // Terlama
          else if (forumViewModel.kategoriListMap.contains('Terlama')) {
            return a.date?.compareTo(b.date ?? DateTime(0)) ?? 0;
          }

          // Populer
          else if (forumViewModel.kategoriListMap.contains('Populer')) {
            return (b.view ?? 0).compareTo(a.view ?? 0);
          }
          return 0;
        });

        return forumList == null
            ? const Center(
                child: Text('Tidak terdapat pertanyaan'),
              )
            : ListView.builder(
                itemCount: displayedList?.length,
                itemBuilder: (context, index) {
                  final forum = displayedList?[index];
                  return SizedBox(
                    width: 360.0,
                    height: 198.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                left: 16,
                                top: 16,
                                bottom: 8,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      forum?.status == true
                                          ? "Terjawab"
                                          : "Belum Terjawab",
                                      style: forum?.status == true
                                          ? regular10Green500
                                          : regular10Red,
                                    ),
                                    const SizedBox(width: 8),
                                    Image.asset(
                                      Assets.assetsEllips,
                                      width: 2,
                                      height: 2,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      forum?.date != null
                                          ? "Diunggah ${_calculateDaysAgo(forum!.date!)} yang lalu"
                                          : '',
                                      style: regular10Grey200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                left: 16,
                                bottom: 8,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  forum?.title?.toString() ?? '',
                                  style: medium14Grey900,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                left: 16,
                                bottom: 12,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  forum?.content?.toString() ?? '',
                                  textAlign: TextAlign.justify,
                                  style: regular10Grey400,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AvatarStack(
                                    height: 32,
                                    width: 53.82,
                                    avatars: [
                                      for (var n = 0; n < 2; n++)
                                        const NetworkImage(
                                          'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg',
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 168),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          RoutesNavigation.detailForumView);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Lihat Forum',
                                          style: regular12Grey400,
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          Assets.assetsNextIcon,
                                          width: 6.59,
                                          height: 11.17,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  String _calculateDaysAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays} hari';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam';
    } else {
      return '${difference.inMinutes} menit';
    }
  }
}
