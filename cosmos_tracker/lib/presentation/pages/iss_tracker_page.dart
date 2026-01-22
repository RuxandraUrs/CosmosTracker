import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/service_locator.dart';
import '../../core/notification_service.dart'; 
import '../bloc/iss_cubit.dart';
import '../bloc/iss_state.dart';
import '../bloc/apod_cubit.dart';
import '../widgets/nasa_apod_card.dart';
import '../widgets/iss_map.dart';

class IssTrackerPage extends StatelessWidget {
  const IssTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<IssCubit>()..loadIssLocation()),
        BlocProvider(create: (_) => sl<ApodCubit>()..loadApod()),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Cosmos Dashboard', 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.history, color: Colors.white, size: 24),
                onPressed: () {
                   context.push('/history'); 
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/space_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: const Color(0xFF0B0D17).withValues(alpha: 0.85), 
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const NasaApodCard(),

                    const SizedBox(height: 10),
                    const Divider(color: Colors.white24, indent: 20, endIndent: 20),
                    const SizedBox(height: 10),

                    const Text(
                      "ISS Real-Time Tracking",
                      style: TextStyle(
                        fontSize: 16, 
                        letterSpacing: 1.5, 
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    BlocBuilder<IssCubit, IssState>(
                      builder: (context, state) {
                        if (state is IssLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                          );
                        } else if (state is IssLoaded) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5))
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.public, color: Colors.blueAccent, size: 20),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        state.locationName,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              IssMap(
                                latitude: state.position.latitude, 
                                longitude: state.position.longitude
                              ),

                              const SizedBox(height: 20),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildCoordinateBox("LATITUDE", state.position.latitude.toString()),
                                  _buildCoordinateBox("LONGITUDE", state.position.longitude.toString()),
                                ],
                              ),

                              const SizedBox(height: 30),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => context.read<IssCubit>().loadIssLocation(),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Update'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white10,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  FilledButton.icon(
                                    onPressed: () {
                                      context.read<IssCubit>().saveLocation(
                                        state.position, 
                                        state.locationName
                                      );

                                      NotificationService().showNotification(
                                        id: DateTime.now().millisecond,
                                        title: 'Mission Log Updated! 🚀',
                                        body: 'Location "${state.locationName}" has been saved.',
                                      );
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: const [
                                              Icon(Icons.check_circle, color: Colors.white),
                                              SizedBox(width: 10),
                                              Text('Location saved to history!'),
                                            ],
                                          ),
                                          backgroundColor: Colors.deepPurple,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.save_alt),
                                    label: const Text('Save'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40), 
                            ],
                          );
                        } else if (state is IssError) {
                          return Text(state.message, style: const TextStyle(color: Colors.redAccent));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF15192B).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.blueGrey, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: Colors.white)),
        ],
      ),
    );
  }
}