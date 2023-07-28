set export

APP_NAME := "EpochTime"
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

bump-version number:
    go run Scripts/xcode-app-version-bumper/*go --number {{ number }}

[private]
archive sdk scheme destination archive-path:
    #!/bin/zsh

    CONFIGURATION="Release"

    xcodebuild archive -scheme "{{ scheme }}" -project $PROJECT \
        -configuration $CONFIGURATION -destination "{{ destination }}" \
        -sdk "{{ sdk }}" -archivePath "{{ archive-path }}"

[private]
export-archive export-options archive:
    #!/bin/zsh

    xcodebuild -exportArchive -archivePath "{{ archive }}" -exportPath . -exportOptionsPlist "{{ export-options }}"
