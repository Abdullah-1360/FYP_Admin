# AI Plant Admin Panel

A Flutter web application for managing the AI Plant healthcare system.

## Features

- User Management
- Doctor Management
- Medicine Management
- Analytics Dashboard
- Admin Management

## Deployment to GitHub Pages

This project is configured to automatically deploy to GitHub Pages using GitHub Actions.

### Setup Instructions

1. **Push your code to GitHub**:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **Enable GitHub Pages**:
   - Go to your repository on GitHub
   - Navigate to Settings → Pages
   - Under "Source", select "Deploy from a branch"
   - Select "gh-pages" branch
   - Click "Save"

3. **Configure Repository Settings**:
   - Go to Settings → Actions → General
   - Under "Workflow permissions", select "Read and write permissions"
   - Check "Allow GitHub Actions to create and approve pull requests"
   - Click "Save"

4. **Automatic Deployment**:
   - The GitHub Action will automatically trigger on pushes to `main` or `master` branch
   - Your app will be available at: `https://yourusername.github.io/ADMIN/`

### Manual Build (Optional)

To build the project locally:

```bash
# Get dependencies
flutter pub get

# Build for web
flutter build web --release

# Serve locally (optional)
flutter run -d web-server --web-port 8080
```

### Project Structure

```
admin_panel/
├── lib/
│   ├── models/          # Data models
│   ├── screens/         # UI screens
│   ├── services/        # API services
│   ├── utils/           # Utilities
│   └── widgets/         # Reusable widgets
├── web/                 # Web-specific files
├── .github/workflows/   # GitHub Actions
└── pubspec.yaml         # Dependencies
```

## Getting Started with Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Dependencies

- Flutter SDK 3.8.1+
- Dio (HTTP client)
- Google Fonts
- FL Chart (Analytics)
- SidebarX (Navigation)
- Image Picker
- Cached Network Image
- Flutter Secure Storage

### Troubleshooting

1. **Build fails**: Ensure Flutter SDK version compatibility
2. **Pages not loading**: Check the base-href in the build command
3. **Assets not found**: Verify asset paths in pubspec.yaml
4. **CORS issues**: Configure your backend API to allow requests from GitHub Pages domain

For more information, check the GitHub Actions logs in the "Actions" tab of your repository.
