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
    . Scripts/XcTools/.venv/bin/activate
    pip install -e Scripts/XcTools
    python3 -c "from Scripts.XcTools.src.xctools_kamaalio.cli import cli; cli()" bump-version \
        --build-number {{number}}

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

    . Scripts/XcTools/.venv/bin/activate
    pip install -e Scripts/XcTools
    python3 -c "from Scripts.XcTools.src.xctools_kamaalio.cli import cli; cli()" archive \
        --configuration $CONFIGURATION --scheme "{{ scheme }}" --destination "{{ destination }}" \
        --sdk {{ sdk }} --archive-path "{{ archive-path }}" --project $PROJECT

[private]
export-archive export-options archive:
    #!/bin/zsh

    . Scripts/XcTools/.venv/bin/activate
    pip install -e Scripts/XcTools
    python3 -c "from Scripts.XcTools.src.xctools_kamaalio.cli import cli; cli()" export-archive \
        --archive-path "{{ archive }}" --export-options "{{ export-options }}"

[private]
upload-app target binary-name:
    . Scripts/XcTools/.venv/bin/activate
    pip install -e Scripts/XcTools
    python3 -c "from Scripts.XcTools.src.xctools_kamaalio.cli import cli; cli()" upload \
        --file {{ binary-name }} --target {{ target }} --username kamaal.f1@gmail.com \
        --password $APP_STORE_CONNECT_PASSWORD
