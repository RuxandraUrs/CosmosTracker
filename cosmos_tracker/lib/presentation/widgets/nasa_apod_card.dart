import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/apod_cubit.dart';
import '../bloc/apod_state.dart';

class NasaApodCard extends StatelessWidget {
  const NasaApodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      child: BlocBuilder<ApodCubit, ApodState>(
        builder: (context, state) {
          if (state is ApodLoading) {
            return const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ApodLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Image.network(
                      state.apodData.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[900],
                          child: const Center(child: Icon(Icons.broken_image, color: Colors.white)),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black54,
                      child: const Text(
                        "NASA Picture of the Day",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.apodData.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.apodData.date,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),

                ExpansionTile(
                  title: const Text("Read Explanation", style: TextStyle(fontSize: 14)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        state.apodData.explanation,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is ApodError) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}