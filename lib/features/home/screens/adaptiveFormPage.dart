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
  String _selectedCountry = 'USA';
  String _gender = 'Male';
  bool _agreeTerms = false;
  bool _notifications = true;
  DateTime? _selectedDate;

  final List<String> _allHobbies = ['Running', 'Coding', 'Gaming'];
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

  void _onCountryChanged(String newCountry) {
    setState(() {
      _selectedCountry = newCountry;
    });
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
        builder: (_) => Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate ?? DateTime.now(),
                  mode: CupertinoDatePickerMode.dateAndTime, // <-- Changed
                  onDateTimeChanged: (newDate) {
                    setState(() => _selectedDate = newDate);
                  },
                ),
              ),
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
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
        selectedCountry: _selectedCountry,
        onCountryChanged: _onCountryChanged,
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
    required this.selectedCountry,
    required this.onCountryChanged,
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
  final String selectedCountry;
  final void Function(String) onCountryChanged;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return SafeArea(
      child: Form(
        key: formKey,
        child: isIOS ? _buildCupertinoForm(context) : _buildMaterialForm(),
      ),
    );
  }

  Widget _buildCupertinoForm(BuildContext context) {
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
          header: const Text('Country'),
          children: [
            CupertinoFormRow(
              prefix: const Text('Country'),
              child: GestureDetector(
                onTap: () => _showCupertinoCountryPicker(context),
                child: Text(selectedCountry),
              ),
            ),
          ],
        ),

        CupertinoFormSection.insetGrouped(
          header: const Text('Hobbies'),
          children: allHobbies.map((hobby) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hobby),
                CupertinoCheckbox(
                  value: selectedHobbies.contains(hobby),
                  onChanged: (v) => onHobbyToggle(hobby, v!),
                ),
              ],
            );
          }).toList(),
        ),

         CupertinoFormSection.insetGrouped(
          header: const Text('Gender'),
          children: ['Male', 'Female', 'Other'].map((g) {
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
          header: const Text('Date & Time'),
          children: [
            CupertinoButton(
              onPressed: onDateTap,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              child: Text(
                selectedDate != null
                    ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')} ${selectedDate!.hour.toString().padLeft(2, '0')}:${selectedDate!.minute.toString().padLeft(2, '0')}'
                    : 'Pick Date & Time',
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

  void _showCupertinoCountryPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                  initialItem: ['USA', 'India', 'Canada'].indexOf(selectedCountry),
                ),
                onSelectedItemChanged: (index) {
                  onCountryChanged(['USA', 'India', 'Canada'][index]);
                },
                children: const [
                  Text('USA'),
                  Text('India'),
                  Text('Canada'),
                ],
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialForm() {
    return ListView(
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: selectedCountry,
          items: ['USA', 'India', 'Canada'].map((country) {
            return DropdownMenuItem(
              value: country,
              child: Text(country),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onCountryChanged(val);
          },
          decoration: const InputDecoration(labelText: 'Country'),
        ),
        const SizedBox(height: 20),

        const Text('Hobbies', style: TextStyle(fontWeight: FontWeight.bold)),
        ...allHobbies.map((hobby) {
          return CheckboxListTile(
            value: selectedHobbies.contains(hobby),
            onChanged: (val) => onHobbyToggle(hobby, val!),
            title: Text(hobby),
          );
        }),
        const SizedBox(height: 10),

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

        SwitchListTile(
          title: const Text('Agree Terms'),
          value: agreeTerms,
          onChanged: onAgreeChanged,
        ),
        SwitchListTile(
          title: const Text('Notifications'),
          value: notifications,
          onChanged: onNotificationsChanged,
        ),
        const SizedBox(height: 10),

        ListTile(
          title: const Text('Select Date'),
          subtitle: Text(
            selectedDate != null
                ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                : 'Not selected',
          ),
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




// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class AdaptiveFormScreen extends StatefulWidget {
//   const AdaptiveFormScreen({super.key});

//   @override
//   State<AdaptiveFormScreen> createState() => _AdaptiveFormScreenState();
// }

// class _AdaptiveFormScreenState extends State<AdaptiveFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   String _gender = 'Male';
//   bool _agreeTerms = false;
//   bool _notifications = true;
//   DateTime? _selectedDate;
//   String _selectedCountry = 'USA';

//   final List<String> _countries = ['USA', 'Canada', 'India', 'UK', 'Australia'];
//   final List<String> _allHobbies = ['Running', 'Coding', 'Gaming'];
//   final Set<String> _selectedHobbies = {};

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       debugPrint('Name: ${_nameController.text}');
//       debugPrint('Email: ${_emailController.text}');
//       debugPrint('Gender: $_gender');
//       debugPrint('Hobbies: $_selectedHobbies');
//       debugPrint('Country: $_selectedCountry');
//       debugPrint('Terms: $_agreeTerms');
//       debugPrint('Notifications: $_notifications');
//       debugPrint('Date: $_selectedDate');
//     }
//   }

//   void _onHobbyToggle(String hobby, bool selected) {
//     setState(() {
//       if (selected) {
//         _selectedHobbies.add(hobby);
//       } else {
//         _selectedHobbies.remove(hobby);
//       }
//     });
//   }

//   void _pickDate(BuildContext context) async {
//     final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
//     if (isIOS) {
//       showCupertinoModalPopup(
//         context: context,
//         builder: (_) => SizedBox(
//           height: 250,
//           child: CupertinoDatePicker(
//             mode: CupertinoDatePickerMode.date,
//             onDateTimeChanged: (newDate) {
//               setState(() => _selectedDate = newDate);
//             },
//           ),
//         ),
//       );
//     } else {
//       final picked = await showDatePicker(
//         context: context,
//         initialDate: _selectedDate ?? DateTime.now(),
//         firstDate: DateTime(2000),
//         lastDate: DateTime(2100),
//       );
//       if (picked != null) {
//         setState(() => _selectedDate = picked);
//       }
//     }
//   }

//   void _showCupertinoCountryPicker(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (_) => SizedBox(
//         height: 250,
//         child: CupertinoPicker(
//           backgroundColor: CupertinoColors.systemBackground,
//           itemExtent: 32,
//           scrollController: FixedExtentScrollController(
//             initialItem: _countries.indexOf(_selectedCountry),
//           ),
//           onSelectedItemChanged: (index) {
//             setState(() => _selectedCountry = _countries[index]);
//           },
//           children: _countries.map((c) => Text(c)).toList(),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

//     return isIOS
//         ? CupertinoPageScaffold(
//             navigationBar: const CupertinoNavigationBar(
//               middle: Text('Adaptive Form'),
//             ),
//             child: _buildForm(isIOS),
//           )
//         : Scaffold(
//             appBar: AppBar(title: const Text('Adaptive Form')),
//             body: _buildForm(isIOS),
//           );
//   }

//   Widget _buildForm(bool isIOS) {
//     return SafeArea(
//       child: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             // Name Field
//             isIOS
//                 ? CupertinoTextFormFieldRow(
//                     controller: _nameController,
//                     placeholder: 'Name',
//                     validator: (val) => val == null || val.isEmpty ? 'Required' : null,
//                   )
//                 : TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(labelText: 'Name'),
//                     validator: (val) => val == null || val.isEmpty ? 'Required' : null,
//                   ),
//             const SizedBox(height: 10),

//             // Email Field
//             isIOS
//                 ? CupertinoTextFormFieldRow(
//                     controller: _emailController,
//                     placeholder: 'Email',
//                     validator: (val) => val == null || val.isEmpty ? 'Required' : null,
//                   )
//                 : TextFormField(
//                     controller: _emailController,
//                     decoration: const InputDecoration(labelText: 'Email'),
//                     validator: (val) => val == null || val.isEmpty ? 'Required' : null,
//                   ),
//             const SizedBox(height: 20),

//             // Country Picker
//             isIOS
//                 ? GestureDetector(
//                     onTap: () => _showCupertinoCountryPicker(context),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: CupertinoColors.systemGrey6,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(_selectedCountry),
//                           const Icon(CupertinoIcons.chevron_down, size: 20),
//                         ],
//                       ),
//                     ),
//                   )
//                 : DropdownButtonFormField<String>(
//                     value: _selectedCountry,
//                     decoration: const InputDecoration(labelText: 'Country'),
//                     items: _countries
//                         .map((country) => DropdownMenuItem(
//                               value: country,
//                               child: Text(country),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) setState(() => _selectedCountry = value);
//                     },
//                   ),
//             const SizedBox(height: 20),

//             // Hobbies
//             const Text('Hobbies', style: TextStyle(fontWeight: FontWeight.bold)),
//             ..._allHobbies.map((hobby) {
//               return isIOS
//                   ? Row(
//                       children: [
//                         CupertinoCheckbox(
//                           value: _selectedHobbies.contains(hobby),
//                           onChanged: (v) => _onHobbyToggle(hobby, v!),
//                         ),
//                         Text(hobby),
//                       ],
//                     )
//                   : CheckboxListTile(
//                       value: _selectedHobbies.contains(hobby),
//                       onChanged: (v) => _onHobbyToggle(hobby, v!),
//                       title: Text(hobby),
//                     );
//             }),
//             const SizedBox(height: 20),

//             // Gender
//             const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
//             ...['Male', 'Female', 'Other'].map((g) {
//               return isIOS
//                   ? Row(
//                       children: [
//                         CupertinoRadio<String>(
//                           value: g,
//                           groupValue: _gender,
//                           onChanged: (val) => setState(() => _gender = val!),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(g),
//                       ],
//                     )
//                   : RadioListTile<String>(
//                       title: Text(g),
//                       value: g,
//                       groupValue: _gender,
//                       onChanged: (val) => setState(() => _gender = val!),
//                     );
//             }),
//             const SizedBox(height: 20),

//             // Terms Agreement
//             isIOS
//                 ? Row(
//                     children: [
//                       CupertinoSwitch(
//                         value: _agreeTerms,
//                         onChanged: (v) => setState(() => _agreeTerms = v),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text('Agree to Terms'),
//                     ],
//                   )
//                 : SwitchListTile(
//                     title: const Text('Agree to Terms'),
//                     value: _agreeTerms,
//                     onChanged: (v) => setState(() => _agreeTerms = v),
//                   ),
//             const SizedBox(height: 10),

//             // Notifications
//             isIOS
//                 ? Row(
//                     children: [
//                       CupertinoSwitch(
//                         value: _notifications,
//                         onChanged: (v) => setState(() => _notifications = v),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text('Notifications'),
//                     ],
//                   )
//                 : SwitchListTile(
//                     title: const Text('Notifications'),
//                     value: _notifications,
//                     onChanged: (v) => setState(() => _notifications = v),
//                   ),
//             const SizedBox(height: 20),

//             // Date Picker
//             ListTile(
//               title: const Text('Select Date'),
//               subtitle: Text(
//                 _selectedDate?.toString().split(' ').first ?? 'Pick Date',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               trailing: const Icon(Icons.calendar_today),
//               onTap: () => _pickDate(context),
//             ),
//             const SizedBox(height: 20),

//             // Submit Button
//             isIOS
//                 ? CupertinoButton.filled(
//                     onPressed: _submitForm,
//                     child: const Text('Submit'),
//                   )
//                 : ElevatedButton(
//                     onPressed: _submitForm,
//                     child: const Text('Submit'),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

