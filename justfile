set export
set dotenv-load

APP_NAME := "EpochStamp"
PROJECT := "UnixTime.xcodeproj"
MAC_SCHEME := "UnixTime (macOS)"
IOS_SCHEME := "UnixTime (iOS)"

default:
  just --list

archive-ios:
    #!/bin/zsh

    ARCHIVE_PATH="$APP_NAME-iOS.xcarchive"

    just archive "iphoneos" "$IOS_SCHEME" "platform=iOS" "$ARCHIVE_PATH"
    just export-archive "ExportOptions/IOS.plist" "$ARCHIVE_PATH"

archive-mac:
    #!/bin/zsh

    ARCHIVE_PATH="$APP_NAME-macOS.xcarchive"

    just archive "macosx" "$MAC_SCHEME" "platform=macOS" "$ARCHIVE_PATH"
    just export-archive "ExportOptions/Mac.plist" "$ARCHIVE_PATH"

archive-and-upload-ios: archive-ios
    just upload-app ios $APP_NAME.ipa

archive-and-upload-mac: archive-mac
    just upload-app macos $APP_NAME.pkg

bump-version number:
    go run Scripts/xcode-app-version-bumper/*go --number {{ number }}

resize-mac-screenshots:
    #!/bin/zsh

    cd Scripts/resize-image
    for screenshot in ../../Screenshots/Mac/**/*(.)
    do
        echo "Resizing $screenshot:t"
        go run . -i $screenshot -o ../../Screenshots/Mac -s 2880x1800
    done

[private]
archive sdk scheme destination archive-path:
    #!/bin/zsh

    CONFIGURATION="Release"

    xcodebuild archive -scheme "{{ scheme }}" -project $PROJECT \
        -configuration $CONFIGURATION -destination "{{ destination }}" \
        -sdk "{{ sdk }}" -archivePath "{{ archive-path }}"

[private]
export-archive export-options archive:
    xcodebuild -exportArchive -archivePath "{{ archive }}" -exportPath . -exportOptionsPlist "{{ export-options }}"

[private]
upload-app target binary-name:
    xcrun altool --upload-app -t {{ target }} -f {{ binary-name }} -u kamaal.f1@gmail.com -p $APP_STORE_CONNECT_PASSWORD
