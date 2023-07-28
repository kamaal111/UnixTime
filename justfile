set export

APP_NAME := "EpochTime"
PROJECT := "UnixTime.xcodeproj"
MAC_SCHEME := "UnixTime (macOS)"
IOS_SCHEME := "UnixTime (iOS)"

default:
  just --list

archive-ios:
    just archive "iphoneos" "$IOS_SCHEME" "platform=iOS" "$APP_NAME-iOS"

archive-mac:
    just archive "macosx" "$MAC_SCHEME" "platform=macOS" "$APP_NAME-macOS"

bump-version number:
    go run Scripts/xcode-app-version-bumper/*go --number {{ number }}

[private]
archive sdk scheme destination name:
    #!/bin/zsh

    CONFIGURATION="Release"
    ARCHIVE_FILE="{{ name }}.xcarchive"

    xcodebuild -scheme "{{ scheme }}" -project $PROJECT \
        -configuration $CONFIGURATION -destination "{{ destination }}" \
        -sdk "{{ sdk }}" -archivePath $ARCHIVE_FILE archive
