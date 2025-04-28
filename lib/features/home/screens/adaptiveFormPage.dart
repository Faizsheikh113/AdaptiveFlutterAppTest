import 'package:cupertino_material3_mix/features/home/widgets/adaptive_appbar.dart';
import 'package:cupertino_material3_mix/features/home/widgets/adaptive_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFormScreen extends StatefulWidget {
  const AdaptiveFormScreen({super.key});

  @override
  State<AdaptiveFormScreen> createState() => _AdaptiveFormScreenState();
}

class _AdaptiveFormScreenState extends State<AdaptiveFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _gender = 'Male';
  bool _agreeTerms = false;
  bool _notifications = true;
  DateTime? _selectedDate;

  final List<String> _allHobbies = ['Running', 'Coading', 'Gaming'];
  final Set<String> _selectedHobbies = {};

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Name: ${_nameController.text}');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Gender: $_gender');
      debugPrint('Hobbies: $_selectedHobbies');
      debugPrint('Terms: $_agreeTerms');
      debugPrint('Notifications: $_notifications');
      debugPrint('Date: $_selectedDate');
    }
  }

  void _onHobbyToggle(String hobby, bool selected) {
    setState(() {
      if (selected) {
        _selectedHobbies.add(hobby);
      } else {
        _selectedHobbies.remove(hobby);
      }
    });
  }

  void _pickDate(BuildContext context) async {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    if (isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (_) => SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (newDate) {
              setState(() => _selectedDate = newDate);
            },
          ),
        ),
      );
    } else {
      final picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() => _selectedDate = picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: const Text("Adaptive Form"),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      child: AdaptiveFormComponents(
        formKey: _formKey,
        nameController: _nameController,
        emailController: _emailController,
        gender: _gender,
        onGenderChanged: (g) => setState(() => _gender = g),
        selectedHobbies: _selectedHobbies,
        allHobbies: _allHobbies,
        onHobbyToggle: _onHobbyToggle,
        agreeTerms: _agreeTerms,
        onAgreeChanged: (v) => setState(() => _agreeTerms = v),
        notifications: _notifications,
        onNotificationsChanged: (v) => setState(() => _notifications = v),
        selectedDate: _selectedDate,
        onDateTap: () => _pickDate(context),
        onSubmit: _submitForm,
      ),
    );
  }
}

class AdaptiveFormComponents extends StatelessWidget {
  const AdaptiveFormComponents({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.gender,
    required this.onGenderChanged,
    required this.selectedHobbies,
    required this.allHobbies,
    required this.onHobbyToggle,
    required this.agreeTerms,
    required this.onAgreeChanged,
    required this.notifications,
    required this.onNotificationsChanged,
    required this.selectedDate,
    required this.onDateTap,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final String gender;
  final void Function(String) onGenderChanged;
  final Set<String> selectedHobbies;
  final List<String> allHobbies;
  final void Function(String, bool) onHobbyToggle;
  final bool agreeTerms;
  final bool notifications;
  final void Function(bool) onAgreeChanged;
  final void Function(bool) onNotificationsChanged;
  final DateTime? selectedDate;
  final VoidCallback onDateTap;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: isIOS ? _buildCupertinoForm() : _buildMaterialForm(),
      ),
    );
  }

  Widget _buildCupertinoForm() {
    return ListView(
      children: [
        CupertinoFormSection.insetGrouped(
          header: const Text('User Info'),
          children: [
            CupertinoTextFormFieldRow(
              controller: nameController,
              placeholder: 'Name',
              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
            ),
            CupertinoTextFormFieldRow(
              controller: emailController,
              placeholder: 'Email',
              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
            ),
          ],
        ),
        CupertinoFormSection.insetGrouped(
          header: const Text('Hobbies'),
          children: allHobbies.map((hobby) {
            return CupertinoFormRow(
              prefix: Text(hobby),
              child: CupertinoSwitch(
                value: selectedHobbies.contains(hobby),
                onChanged: (v) => onHobbyToggle(hobby, v),
              ),
            );
          }).toList(),
        ),
        CupertinoFormSection.insetGrouped(
          header: const Text('Gender'),
          children: ['Male', 'Female'].map((g) {
            return CupertinoFormRow(
              prefix: Text(g),
              child: CupertinoRadio(
                value: g,
                groupValue: gender,
                onChanged: (v) => onGenderChanged(v!),
              ),
            );
          }).toList(),
        ),
        CupertinoFormSection.insetGrouped(
          header: const Text('Preferences'),
          children: [
            CupertinoFormRow(
              prefix: const Text('Agree Terms'),
              child: CupertinoSwitch(
                value: agreeTerms,
                onChanged: onAgreeChanged,
              ),
            ),
            CupertinoFormRow(
              prefix: const Text('Notifications'),
              child: CupertinoSwitch(
                value: notifications,
                onChanged: onNotificationsChanged,
              ),
            ),
          ],
        ),
        CupertinoFormSection.insetGrouped(
          header: const Text('Date'),
          children: [
            CupertinoButton(
              onPressed: onDateTap,
              child: Text(
                selectedDate?.toString().split(' ').first ?? 'Pick Date',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CupertinoButton.filled(
          onPressed: onSubmit,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildMaterialForm() {
    return ListView(
      children: [
        //Name TextField
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 10),
        //Name EmailTextField
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 20),
        //Hobbies Checkbox
        const Text('Hobbies', style: TextStyle(fontWeight: FontWeight.bold)),
        ...allHobbies.map((hobby) {
          return CheckboxListTile(
            value: selectedHobbies.contains(hobby),
            onChanged: (val) => onHobbyToggle(hobby, val!),
            title: Text(hobby),
          );
        }),
        const SizedBox(height: 10),
        //Gender Radio selection
        const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
        RadioListTile(
          title: const Text('Male'),
          value: 'Male',
          groupValue: gender,
          onChanged: (val) => onGenderChanged(val!),
        ),
        RadioListTile(
          title: const Text('Female'),
          value: 'Female',
          groupValue: gender,
          onChanged: (val) => onGenderChanged(val!),
        ),
        RadioListTile(
          title: const Text('Other'),
          value: 'Other',
          groupValue: gender,
          onChanged: (val) => onGenderChanged(val!),
        ),
        //Agreement Switch
        SwitchListTile(
          title: const Text('Agree Terms'),
          value: agreeTerms,
          onChanged: onAgreeChanged,
        ),
        //notifaction
        SwitchListTile(
          title: const Text('Notifications'),
          value: notifications,
          onChanged: onNotificationsChanged,
        ),
        const SizedBox(height: 10),
        //Date picker
        ListTile(
          title: const Text('Select Date'),
          subtitle: Text(selectedDate?.toString().split(' ').first ?? 'Not selected'),
          trailing: const Icon(Icons.calendar_today),
          onTap: onDateTap,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSubmit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
