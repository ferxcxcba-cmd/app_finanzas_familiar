class Validators {
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'El monto es requerido';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Ingresa un monto válido';
    }
    if (amount <= 0) {
      return 'El monto debe ser mayor a 0';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'La descripción es requerida';
    }
    if (value.length < 3) {
      return 'La descripción debe tener al menos 3 caracteres';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  static String? validateGoalTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'El título es requerido';
    }
    if (value.length < 3) {
      return 'El título debe tener al menos 3 caracteres';
    }
    return null;
  }

  static String? validateBudgetLimit(String? value) {
    if (value == null || value.isEmpty) {
      return 'El límite de presupuesto es requerido';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Ingresa un monto válido';
    }
    if (amount <= 0) {
      return 'El límite debe ser mayor a 0';
    }
    return null;
  }
}
