# Releasing a formula

The formulae in this tap are the single source of truth — source repos never carry a copy. To ship a new version of `<formula>`:

1. **Tag and release in the source repo.**

   ```bash
   cd <source-repo>
   git tag v0.1.0
   git push --tags
   gh release create v0.1.0 --generate-notes
   ```

   GitHub auto-publishes the source tarball at:

   ```
   https://github.com/slashome/<repo>/archive/refs/tags/v0.1.0.tar.gz
   ```

2. **Compute the tarball checksum.**

   ```bash
   curl -sL https://github.com/slashome/<repo>/archive/refs/tags/v0.1.0.tar.gz \
     | shasum -a 256
   ```

3. **Bump `Formula/<formula>.rb`** in this repo:

   - `url`: new tag URL
   - `sha256`: value from step 2
   - For Python formulae: regenerate the `resource` blocks between the `>>> resources` / `<<< resources` markers with either:
     - `pip install homebrew-pypi-poet && poet --resources <pkg1> --also <pkg2>`
     - or `brew install pipgrip && brew update-python-resources Formula/<formula>.rb`

4. **Test locally before pushing.**

   ```bash
   brew install --build-from-source slashome/tap/<formula>
   brew test slashome/tap/<formula>
   brew audit --strict --new slashome/tap/<formula>
   ```

5. **Commit and push.** That's it — `brew update` on user machines will pick the new version up on next run.
