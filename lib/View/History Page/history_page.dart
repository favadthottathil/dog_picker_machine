import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_picker/DB%20Bloc/db_bloc.dart';
import 'package:dog_picker/Model/dog_image_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DbBloc>(context).add(DbLoadImages());
  }

  @override
  Widget build(BuildContext context) {
    final dbBloc = BlocProvider.of<DbBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: BlocBuilder<DbBloc, DbState>(
        bloc: dbBloc,
        builder: (context, state) {
          if (state is DbImageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DbImageError) {
            return Center(child: Text(state.error));
          }

          if (state is DbImageLoaded) {
            List<DogImageModel> imageUrls = state.imageUrls;

            imageUrls = imageUrls.reversed.toList();

            return GridView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                DogImageModel image = imageUrls[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: CachedNetworkImage(
                      imageUrl: image.imageUrl,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 200,
                childAspectRatio: 2,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
