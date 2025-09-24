# OrdaCost - Sistema de Costeo por Órdenes

Una aplicación Flutter moderna para el cálculo de costos por órdenes de producción, implementada con Clean Architecture, Material 3 y Riverpod.

## 🚀 Características

- **Gestión de Órdenes**: Crear, editar y eliminar órdenes de producción
- **Parámetros CIF**: Configurar costos indirectos de fabricación
- **Cálculos Automáticos**: CIF aplicado, costo de producción y costo unitario
- **Reportes**: Totales del período, COGM, WIP y análisis de sobre/sub-aplicación
- **UI Moderna**: Material 3 con tema claro/oscuro
- **Navegación**: ShellRoute con NavigationBar
- **Internacionalización**: Formateo de moneda en Quetzales (es_GT)

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture** con separación clara de responsabilidades:

```
lib/
├── app/                    # Configuración de la app
│   ├── router/            # Navegación con go_router
│   └── theme/             # Temas Material 3
├── core/                  # Funcionalidad compartida
│   ├── errors/            # Manejo de errores
│   └── utils/             # Utilidades (formateo)
└── features/
    └── costeo/            # Módulo de costeo
        ├── domain/        # Lógica de negocio pura
        ├── data/          # Implementación de repositorios
        └── presentation/  # UI y providers
```

## 🛠️ Tecnologías

- **Flutter**: Framework UI
- **Dart 3.x**: Lenguaje de programación
- **Riverpod**: Gestión de estado
- **go_router**: Navegación declarativa
- **Material 3**: Sistema de diseño
- **Clean Architecture**: Arquitectura limpia
- **SOLID**: Principios de diseño

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter_riverpod: ^2.4.9    # Estado
  go_router: ^12.1.3          # Navegación
  intl: ^0.19.0               # Internacionalización
  google_fonts: ^6.1.0        # Tipografías
  dartz: ^0.10.1              # Programación funcional
  equatable: ^2.0.5           # Igualdad de objetos
```

## 🚀 Cómo Ejecutar

### Prerrequisitos

- Flutter SDK 3.16.0 o superior
- Dart 3.3.0 o superior
- Android Studio / VS Code
- Dispositivo Android o emulador

### Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd ord_cost
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Compilación

- **Debug**: `flutter build apk --debug`
- **Release**: `flutter build apk --release`

## 🎨 Configuración del Splash Nativo

Para activar el splash nativo:

1. **Agregar imagen del logo**
   - Coloca tu imagen en `assets/images/splash_logo.png`
   - Tamaño recomendado: 200x200 píxeles

2. **Generar archivos nativos**
   ```bash
   flutter pub run flutter_native_splash:create
   ```

3. **Verificar configuración**
   - Los archivos se generan automáticamente en Android e iOS
   - Color de fondo: Indigo (#6750A4)

## 📱 Funcionalidades

### Gestión de Órdenes
- Crear órdenes con MP, MOD y unidades
- Estados: En Proceso / Terminada
- Edición y eliminación
- Validación de formularios

### Parámetros CIF
- Tasa CIF (porcentaje sobre MOD)
- Materiales Indirectos
- Mano de Obra Indirecta
- Cálculo automático de CIF Real

### Resultados
- Cálculo por orden: CIF, Costo Producción, Costo Unitario
- Totales del período: COGM, WIP
- Análisis de sobre/sub-aplicación
- Tabla de resumen con scroll horizontal

## 🧪 Testing

```bash
# Ejecutar tests
flutter test

# Análisis de código
flutter analyze

# Formateo
dart format .
```

## 📊 Datos de Ejemplo

La aplicación incluye datos precargados:
- Órdenes 145-149 con diferentes estados
- Parámetros CIF: Tasa 180%, MI Q1,200, MOI Q6,400
- Cálculos automáticos al iniciar

## 🎯 Casos de Uso

### CalcularOrden
- Aplica tasa CIF sobre MOD
- Calcula costo de producción (MP + MOD + CIF)
- Determina costo unitario si hay unidades

### CalcularTotales
- Suma órdenes terminadas → COGM
- Suma órdenes en proceso → WIP
- Compara CIF aplicado vs real
- Calcula sobre/sub-aplicación

## 🔄 Extensibilidad

### Nuevos Métodos de CIF
- Implementar nuevos casos de uso
- Extender `CalcularOrden` sin modificar existentes
- Seguir principio OCP (Open/Closed)

### Persistencia
- Reemplazar `InMemoryCosteoRepository`
- Implementar con Hive, SQLite o API
- Mantener interfaz `CosteoRepository`

## 📝 Notas de Desarrollo

- **Formateo**: Moneda en Quetzales (es_GT)
- **Redondeo**: 2 decimales en todos los cálculos
- **Validación**: Mínima pero efectiva
- **UI**: Responsive con Material 3
- **Navegación**: ShellRoute con NavigationBar

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

---

**OrdaCost** - Sistema de Costeo por Órdenes desarrollado con Flutter y Clean Architecture.