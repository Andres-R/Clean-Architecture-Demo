import 'package:clean_arch_course/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:clean_arch_course/src/authentication/presentation/widgets/add_users_dialog.dart';
import 'package:clean_arch_course/src/authentication/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();

  void getUsers() {
    BlocProvider.of<AuthenticationBloc>(context).add(const GetUsersEvent());
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          // body: state is GettingUsers
          //     ? const Center(child: CircularProgressIndicator())
          //     : Center(child: ListView.builder()),
          body: BodyWidget(state: state),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return AddUserDialog(
                    nameController: nameController,
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  final AuthenticationState state;

  @override
  Widget build(BuildContext context) {
    if (state is GettingUsers) {
      return const LoadingWidget(message: 'Fetching Users');
    } else if (state is CreatingUser) {
      return const LoadingWidget(message: 'Creating User');
    } else if (state is UsersLoaded) {
      final loadedState = state as UsersLoaded;
      return ListView.builder(
        itemCount: loadedState.users.length,
        itemBuilder: (context, index) {
          final user = loadedState.users[index];
          return ListTile(
            leading: Image.network(user.avatar),
            title: Text(user.name),
            subtitle: Text(user.createdAt.substring(10)),
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
