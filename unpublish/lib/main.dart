import 'package:flutter/material.dart';
import 'package:unpublish/unpub_service.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PackagesView(),
    );
  }
}

class PackagesView extends StatefulWidget {
  const PackagesView({
    super.key,
  });

  @override
  State<PackagesView> createState() => _PackagesViewState();
}

class _PackagesViewState extends State<PackagesView> {
  final _unpubSvc = UnpubService();

  late Future<List<({String name, String version})>> _packages;

  void _getPackages() {
    _packages = _unpubSvc.listPackages();
    setState(() {});
  }

  Future<void> _deletePackage(String name, [String? opaqueToken]) async {
    await _unpubSvc.deletePackage(name, opaqueToken);
    _getPackages();
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    String name,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    final token = await showDialog<String?>(
      context: context,
      builder: (context) => const DeleteDialog(),
    );

    /// If token is null, user cancelled
    if (token == null) return;

    print('_showDeleteDialog $token');

    try {
      await _deletePackage(name, token);
      messenger
          .showSnackBar(SnackBar(content: Text('$name removed successfully')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    _getPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('unpub.dbank.engineering'),
        actions: [
          ElevatedButton(onPressed: _getPackages, child: const Text('RELOAD')),
        ],
      ),
      body: FutureBuilder<List<({String name, String version})>>(
        future: _packages,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final packages = snapshot.data!;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.separated(
                itemBuilder: (context, idx) {
                  final package = packages[idx];
                  return PackageListTile(
                    package: package,
                    onPressedDelete: () async =>
                        await _showDeleteDialog(context, package.name),
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: packages.length,
              ),
            ),
          );
        },
      ),
    );
  }
}

class PackageListTile extends StatelessWidget {
  const PackageListTile({
    super.key,
    required this.package,
    required this.onPressedDelete,
  });

  final ({String name, String version}) package;
  final Future<void> Function() onPressedDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(package.name),
      subtitle: Text(package.version),
      trailing: OutlinedButton(
        onPressed: onPressedDelete,
        child: const Text('DELETE'),
      ),
    );
  }
}

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({super.key});

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  final _controller = TextEditingController();
  String token = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        controller: _controller,
        onChanged: (value) => setState(() {
          token = value;
        }),
        decoration: const InputDecoration(
            hintText: 'Opaque Token', border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL')),
        TextButton(
            onPressed:
                token.isEmpty ? null : () => Navigator.of(context).pop(token),
            child: const Text('CONFIRM')),
      ],
    );
  }
}
