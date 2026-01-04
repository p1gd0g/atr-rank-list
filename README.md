## build

set version;

```
$ENV:build_vsn='0.14.0'
```

build web:

```
flutter build web --build-name=$ENV:build_vsn --dart-define=vsn=$ENV:build_vsn --output=public
```

## icon 

```
flutter pub add flutter_launcher_icons
dart run flutter_launcher_icons:generate
dart run flutter_launcher_icons
```
