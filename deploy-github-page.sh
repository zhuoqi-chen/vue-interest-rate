npm run build
rm -rf docs
mkdir docs
cp -R ./dist/* docs/
git add docs
git commit -m "deploy to github page"
git push