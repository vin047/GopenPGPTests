# GopenPGPTests
Set of projects to test [GopenPGP](https://github.com/ProtonMail/gopenpgp) library on mobile platforms

## iOS Tests
From the `ios` directory:
```bash
xcodebuild \
    -workspace GopenPGPTests.xcworkspace \
    -scheme GopenPGP \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone X,OS=12.2' \
    test
```
