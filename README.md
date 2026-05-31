# WISC-IV Test Prototype

Flutter prototype for a WISC-like assessment workflow on Android and Windows.

## Overview

This project is an experimental Flutter app for administering test subtests, selecting children, showing questions, capturing scores, timing sessions, storing data locally, and displaying results.

## Features

- Child selection flow
- Subtest and question screens
- Score buttons and timer widget
- Local persistence through SQLite
- JSON question assets
- Result model and scoring service foundation
- Android, Windows, web, Linux, macOS, and iOS project scaffolding

## Project Structure

```text
lib/main.dart                      App entry point
lib/screens/                       Home, child selection, subtest, question, and results screens
lib/models/                        Child, question, and result models
lib/services/db_service.dart       Local database service
lib/services/scoring_service.dart  Scoring logic foundation
lib/widgets/                       Reusable score and timer widgets
lib/assets/questions/              JSON question data
test/                              Widget and child flow tests
```

## Requirements

- Flutter SDK
- Dart SDK compatible with `>=2.18.0 <4.0.0`

## Run Locally

```bash
flutter pub get
flutter run
```

For Windows desktop:

```bash
flutter run -d windows
```

## Test

```bash
flutter test
```
