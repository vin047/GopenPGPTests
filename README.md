# GopenPGP Tests
Set of projects to test [GopenPGP](https://github.com/vin047/gopenpgp) library on mobile platforms

## iOS Tests
```bash
xcodebuild \
    -workspace gopenpgp.xcworkspace \
    -scheme gopenpgp \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone X,OS=12.2' \
    test
```
