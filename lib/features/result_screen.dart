// При открытии запускается «генерация»: сначала лоадер (2–3 сек), затем отображается картинка-заглушка (asset или по URL)
// Кнопки:
// “Try another” — повторная «генерация» (снова лоадер → картинка)
// “New prompt” — возврат на экран 1, введённый текст сохраняется
// При ошибке имитации — показать сообщение об ошибке и кнопку “Retry”

import 'package:b1c_test_app/bloc/image_generator_bloc.dart';
import 'package:b1c_test_app/bloc/storage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends StatefulWidget {
  static const path = '/result';
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text('Result'), pinned: true),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Prompt: '),
                    TextSpan(
                      text: context.read<ImageGeneratorBloc>().currentPromt,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

          BlocConsumer<ImageGeneratorBloc, ImageState>(
            builder: (context, state) {
              return switch (state) {
                ImageError error => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              error.message,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ImageGeneratorBloc>().add(
                              ImageRegeneratePromt(),
                            );
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),

                ImageSuccess success => SliverFillRemaining(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.network(
                              '$success',
                              width: 200,
                              height: 300,

                              frameBuilder: (_, child, frame, wsl) {
                                return AnimatedCrossFade(
                                  firstChild: child,
                                  alignment: Alignment.center,
                                  secondChild: Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                  crossFadeState: frame == null
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 250),
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 20,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.read<ImageGeneratorBloc>().add(
                                  ImageRegeneratePromt(),
                                );
                              },
                              child: Text('Try another'),
                            ),

                            OutlinedButton(
                              onPressed: () {
                                final promt = context
                                    .read<ImageGeneratorBloc>()
                                    .currentPromt;
                                context.read<StorageBloc>().add(promt);
                                context.pop();
                              },
                              child: Text('New prompt'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                _ => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              };
            },
            listener: (_, state) {},
          ),
        ],
      ),
    );
  }
}
