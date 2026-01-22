import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; 
import '../../core/service_locator.dart';
import '../bloc/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoritesCubit>()..loadFavorites(),
      child: Scaffold(
        body: Stack(
          children: [
             Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/space_bg.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
            ),
            
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text("Mission Log (History)", style: TextStyle(color: Colors.white)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FavoritesLoaded) {
                    if (state.positions.isEmpty) {
                      return const Center(
                        child: Text("No missions recorded yet.", style: TextStyle(color: Colors.white70)),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: state.positions.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = state.positions.length - 1 - index;
                        final item = state.positions[reversedIndex];

                        String formattedDate = "Unknown Date";
                        if (item.timestamp != null) {
                          formattedDate = DateFormat('MMM d, yyyy • HH:mm').format(item.timestamp!);
                        }

                        return Card(
                          color: const Color(0xFF15192B).withValues(alpha: 0.8),
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.1))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.public, color: Colors.blueAccent, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.locationName ?? "Unknown Location",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(color: Colors.white10),
                                const SizedBox(height: 8),

                                // Rândul 2: Coordonatele
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoColumn("LAT", item.latitude.toString()),
                                    _buildInfoColumn("LNG", item.longitude.toString()),
                                    // Data în dreapta
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text("TIME", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                        const SizedBox(height: 4),
                                        Text(formattedDate, style: const TextStyle(color: Colors.amberAccent, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is FavoritesError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white70, fontFamily: 'monospace')),
      ],
    );
  }
}