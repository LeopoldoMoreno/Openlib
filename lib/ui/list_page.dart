import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:openlib/services/open_library.dart';

import 'extensions.dart';
import 'package:openlib/ui/components/page_title_widget.dart';
import 'package:openlib/ui/results_page.dart';

class ListPage extends ConsumerWidget {
  final String listType;
  final List<ListBookData> listBooks;
  const ListPage({super.key, required this.listType, required this.listBooks});
  final double imageHeight = 145;
  final double imageWidth = 105;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("OpenLib"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: TitleText(listType),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(5),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 13.0,
                    mainAxisExtent: 205,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ResultPage(
                              searchQuery: listBooks[index].title!,
                            );
                          }));
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  height: imageHeight,
                                  width: imageWidth,
                                  imageUrl: listBooks[index].thumbnail!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 0.1,
                                            blurRadius: 1)
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: "#E3E8E9".toColor(),
                                    ),
                                    height: imageHeight,
                                    width: imageWidth,
                                  ),
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey,
                                      ),
                                      height: imageHeight,
                                      width: imageWidth,
                                      child: const Center(
                                        child: Icon(Icons.image_rounded),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: SizedBox(
                                    width: imageWidth,
                                    child: Text(
                                      listBooks![index].title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      );
                    },
                    childCount: listBooks!.length,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
