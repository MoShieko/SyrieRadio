# SyriaRadio

SwiftUI iOS radio app for Syrian radio streams.

## What is included

- Live radio playback with `AVPlayer`
- Discover, Stations, Favorites, and Settings tabs
- Search and city filtering
- Floating mini player and full Now Playing screen
- Play/pause, previous/next, volume, favorites, and sleep timer controls
- Lock Screen, Control Center, Bluetooth, and headset media controls
- Accessible, labeled navigation and localized playback feedback
- Local image asset for every radio station
- Eight live radio stations with a local logo for every station
- Playback status driven by the real `AVPlayer` and `AVPlayerItem` state
- StoreKit 2 Premium purchase and restore flow
- Advertisements only after the Premium entitlement has been checked
- Responsive layouts with polished loading, empty, paused, and error states

## Premium and StoreKit

The product identifier is `Mohammed.Shieko.SyriaRadio.premium`. Create a
matching non-consumable in App Store Connect before release. The included
`SyriaRadio/SyriaRadio.storekit` configuration is selected by the shared
Debug scheme for local purchase and restore testing. Its `4.99` price is only a
local test value; the production UI never hard-codes a price and displays only
the localized value returned by the App Store.

Premium access is granted only from verified StoreKit 2 current entitlements.
The app loads the localized product name, description, and price from the App
Store and listens for transaction updates while it is running.

Set `APP_STORE_APP_ID` in the target's Release build settings after App Store
Connect assigns the app's numeric Apple ID. The review button uses that ID to
open the permanent `action=write-review` page. Until it is configured, the app
also attempts an Apple catalog lookup by bundle identifier and shows a clear
message if the app has not been published yet.

## Advertising

Verified Premium users never receive banner or audio-advertisement requests.
The Debug configuration is hard-wired to Google's official iOS test app and
banner identifiers:

- App: `ca-app-pub-3940256099942544~1458002511`
- Banner: `ca-app-pub-3940256099942544/2435281174`

Release uses the production `ADMOB_APP_ID` and `ADMOB_BANNER_UNIT_ID` build
settings. Never replace the Debug identifiers with production identifiers.

## Legal and App Store metadata

- In-app Privacy Policy and Terms of Use are available from Settings.
- Public policy: `PRIVACY_POLICY.md`
- Public terms: `TERMS_OF_USE.md`
- Enter the public privacy-policy URL in App Store Connect before submission.
- Review the App Store privacy answers whenever advertising or other SDKs change.

## Change stations

Edit `SyriaRadio/RadioModels.swift` and update `RadioStation.all`. Each station needs an `imageName` that matches an image set in `SyriaRadio/Assets.xcassets`.
