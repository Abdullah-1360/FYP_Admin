# GitHub Pages Deployment Guide

## Quick Start

Your Flutter admin panel is now ready for GitHub Pages deployment! Follow these steps:

### 1. Initialize Git Repository (if not already done)

```bash
cd admin_panel
git init
git add .
git commit -m "Initial commit with GitHub Pages setup"
```

### 2. Create GitHub Repository

1. Go to [GitHub](https://github.com) and create a new repository named `ADMIN`
2. **Important**: Make sure the repository is public (GitHub Pages requires a paid plan for private repos)
3. Don't initialize with README, .gitignore, or license (we already have these)

### 3. Connect Local Repository to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/ADMIN.git
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

### 4. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click on **Settings** tab
3. Scroll down to **Pages** in the left sidebar
4. Under **Source**, select "Deploy from a branch"
5. Select **gh-pages** branch (this will be created automatically by the GitHub Action)
6. Click **Save**

### 5. Configure GitHub Actions Permissions

1. In your repository, go to **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, select "Read and write permissions"
3. Check "Allow GitHub Actions to create and approve pull requests"
4. Click **Save**

### 6. Trigger First Deployment

Make any small change to trigger the deployment:

```bash
# Make a small change (e.g., update README)
git add .
git commit -m "Trigger initial deployment"
git push origin main
```

### 7. Monitor Deployment

1. Go to the **Actions** tab in your GitHub repository
2. You should see a workflow running called "Deploy Flutter Web to GitHub Pages"
3. Wait for it to complete (usually takes 2-5 minutes)
4. Once complete, your app will be available at: `https://YOUR_USERNAME.github.io/ADMIN/`

## Troubleshooting

### Common Issues:

1. **Workflow fails**: Check the Actions logs for specific error messages
2. **404 Page**: Ensure the gh-pages branch was created and Pages is configured correctly
3. **Blank page**: Check browser console for errors, might be CORS issues with your backend API
4. **Assets not loading**: Verify the base-href is set correctly in the build command

### Updating Your App

Every time you push to the `main` branch, your app will automatically rebuild and redeploy:

```bash
git add .
git commit -m "Your update message"
git push origin main
```

## Custom Domain (Optional)

To use a custom domain:

1. Add a `CNAME` file to your repository root with your domain
2. Configure your domain's DNS to point to `YOUR_USERNAME.github.io`
3. Update the GitHub Pages settings to use your custom domain

## Next Steps

- Configure your backend API to allow CORS requests from your GitHub Pages domain
- Set up environment variables for different deployment environments
- Consider using GitHub Secrets for sensitive configuration

Your Flutter admin panel is now live on GitHub Pages! 🚀