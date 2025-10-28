import 'package:b1c_test_app/bloc/image_generator_bloc.dart';
import 'package:b1c_test_app/bloc/storage_bloc.dart';
import 'package:b1c_test_app/features/history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Поле ввода с placeholder: «Describe what you want to see…»
// Кнопка “Generate” (неактивна, если поле пустое)
class PromtScreen extends StatefulWidget {
  static const path = '/';
  const PromtScreen({super.key});

  @override
  State<PromtScreen> createState() => _PromtScreenState();
}

class _PromtScreenState extends State<PromtScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              'AI Image Generator',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            centerTitle: false,
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Create stunning visuals with AI',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Describe what you want to see and our AI will generate it for you',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: 6,
                    maxLength: 2048,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      hintText: 'Describe what you want to see...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: controller,
                  builder: (_, __) {
                    return SizedBox(
                      width: MediaQuery.widthOf(context),
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.text.isEmpty
                            ? null
                            : () {
                                context.go('/result');
                                context.read<ImageGeneratorBloc>().add(
                                  ImageGeneratePromtEvent(controller.text),
                                );
                                // Save to history
                                context.read<StorageBloc>().add(
                                  controller.text,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.text.isEmpty
                              ? theme.colorScheme.primary.withValues(alpha: 0.5)
                              : theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Generate Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Divider(height: 1, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'HISTORY',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Divider(height: 1, color: Colors.grey.shade300),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: HistoryWidget(
              onTap: (value) {
                controller.text = value;
                context.go('/result');
                context.read<ImageGeneratorBloc>().add(
                  ImageGeneratePromtEvent(controller.text),
                );
                // Save to history
                context.read<StorageBloc>().add(controller.text);
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
