import 'package:b1c_test_app/bloc/storage_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryWidget extends StatelessWidget {
  final void Function(String value)? onTap;
  const HistoryWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageBloc, List<String>>(
      builder: (_, __) {
        final list = context.watch<StorageBloc>().state;

        if (list.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'No history yet',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverList.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => Divider(height: 8),
            itemBuilder: (context, index) => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                list[index],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
              onTap: onTap == null
                  ? null
                  : () {
                      onTap?.call(list[index]);
                    },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}
