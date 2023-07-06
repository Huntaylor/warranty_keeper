import 'package:go_router/go_router.dart';
import 'package:warranty_keeper/app_library.dart';
import 'package:warranty_keeper/modules/cubit/current_warranties/current_warranties_cubit.dart';
import 'package:warranty_keeper/modules/cubit/new_warranty/new_warranty_cubit.dart';
import 'package:warranty_keeper/modules/cubit/warranty_details/warranty_details_cubit.dart';
import 'package:warranty_keeper/presentation/current_warranties/widgets/current_widget_card.dart';
import 'package:warranty_keeper/routes/paths.dart';

class CurrentWarrantiesView extends StatelessWidget {
  static const routeName = '/currentWarrantiesView';

  const CurrentWarrantiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Current Warranties'),
      ),
      body: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentCubit = context.read<CurrentWarrantiesCubit>();
    final newRead = context.read<NewWarrantyCubit>();
    final detailsCubit = context.read<WarrantyDetailsCubit>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
        child: BlocBuilder<CurrentWarrantiesCubit, CurrentWarrantiesState>(
          builder: (context, state) {
            return (state.warrantyInfoList.isEmpty)
                ? Text(context.appLocalizations.noCurrentWarranties)
                : ListView.builder(
                    itemCount: state.warrantyInfoList.length,
                    itemBuilder: (context, index) {
                      return CurrentWidgetCard(
                        onSelect: () {
                          context.push(Paths.warranty.selected.path);
                          detailsCubit.selectedWarrantyInitial(
                            state.warrantyInfoList[index],
                          );
                        },
                        onEdit: () {
                          newRead.editWarrantyInitial(
                              state.warrantyInfoList[index]);
                          context.push(Paths.warranty.newWarranty.path);
                        },
                        onRemove: () => currentCubit.removeWarranty(index),
                        warrantyInfo: state.warrantyInfoList[index],
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
