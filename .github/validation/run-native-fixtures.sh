set -euo pipefail

products="$RUNNER_TEMP/derived-data/Build/Products/Debug-iphonesimulator"
fixture_app="$RUNNER_TEMP/NativeFixtures.app"
ditto "$products/Modern Stagecoach.app" "$fixture_app"
python3 - "$fixture_app/Info.plist" <<'PY'
import plistlib
import sys
path = sys.argv[1]
with open(path, "rb") as stream:
    info = plistlib.load(stream)
info["CFBundleIdentifier"] = "com.tugcantopaloglu.Modern-Stagecoach.NativeFixtures"
info.pop("UIApplicationSceneManifest", None)
info.pop("UIMainStoryboardFile", None)
with open(path, "wb") as stream:
    plistlib.dump(info, stream)
PY

sources=()
while IFS= read -r -d '' source; do
  sources+=("$source")
done < <(find "Modern Stagecoach" -name '*.swift' ! -name AppDelegate.swift ! -name SceneDelegate.swift -print0)
xcrun swiftc -swift-version 5 -parse-as-library -module-name Modern_Stagecoach \
  -sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)" \
  -target "$(uname -m)-apple-ios16.4-simulator" \
  -F "$products/ALBusSeatView" -F "$products/iOSDropDown" -F "$products/lottie-ios" \
  -framework UIKit -framework ALBusSeatView -framework iOSDropDown -framework Lottie \
  -Xlinker -rpath -Xlinker '@executable_path/Frameworks' \
  "${sources[@]}" .github/validation/NativeFixtures.swift \
  -o "$fixture_app/Modern Stagecoach"

device="$(xcrun simctl create NativeFixtures com.apple.CoreSimulator.SimDeviceType.iPhone-16 com.apple.CoreSimulator.SimRuntime.iOS-18-5)"
cleanup() {
  xcrun simctl shutdown "$device" >/dev/null 2>&1 || true
  xcrun simctl delete "$device" >/dev/null 2>&1 || true
}
trap cleanup EXIT
xcrun simctl boot "$device"
xcrun simctl bootstatus "$device" -b
xcrun simctl install "$device" "$fixture_app"
xcrun simctl launch "$device" com.tugcantopaloglu.Modern-Stagecoach.NativeFixtures
container="$(xcrun simctl get_app_container "$device" com.tugcantopaloglu.Modern-Stagecoach.NativeFixtures data)"
for attempt in {1..120}; do
  if [ -f "$container/Documents/fixture-result.json" ]; then
    cp "$container/Documents/fixture-result.json" "$RUNNER_TEMP/fixture-result.json"
    python3 - "$RUNNER_TEMP/fixture-result.json" <<'PY'
import json
import sys
with open(sys.argv[1], encoding="utf-8") as stream:
    report = json.load(stream)
print(json.dumps(report, indent=2))
if not report["passed"]:
    raise SystemExit(1)
PY
    exit 0
  fi
  sleep 1
done
xcrun simctl spawn "$device" log show --last 2m --predicate 'process == "Modern Stagecoach"'
exit 1
