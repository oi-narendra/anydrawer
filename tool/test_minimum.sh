#!/usr/bin/env bash
set -euo pipefail

# Test the public package on the minimum SDK without its newer lint tooling.
package_root=$(cd "$(dirname "$0")/.." && pwd)
consumer_dir=$(mktemp -d)
trap 'rm -rf "$consumer_dir"' EXIT
package_name=$(sed -n 's/^name: //p' "$package_root/pubspec.yaml")
cat > "$consumer_dir/pubspec.yaml" <<YAML
name: minimum_sdk_test
publish_to: none
environment:
  sdk: '>=3.6.0 <4.0.0'
dependencies:
  $package_name:
    path: '$package_root'
dev_dependencies:
  flutter_test:
    sdk: flutter
YAML
cp -R "$package_root/test" "$consumer_dir/test"
cd "$consumer_dir"
flutter pub get
flutter test --reporter expanded
