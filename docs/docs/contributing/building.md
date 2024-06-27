# Building packages

::: info
For building `linkpanel-nginx` or `linkpanel-php`, at least 2 GB of memory is required!
:::

Here is more detailed information about the build scripts that are run from `src`:

## Installing LinkPanel from a branch

The following is useful for testing a Pull Request or a branch on a fork.

1. Install Node.js [Download](https://nodejs.org/en/download) or use [Node Source APT](https://github.com/nodesource/distributions)

```bash
# Replace with https://github.com/username/linkpanelcp.git if you want to test a branch that you created yourself
git clone https://github.com/linkpanelcp/linkpanelcp.git
cd ./linkpanelcp/

# Replace main with the branch you want to test
git checkout main

cd ./src/

# Compile packages
./hst_autocompile.sh --all --noinstall --keepbuild '~localsrc'

cd ../install

bash hst-install-{os}.sh --with-debs /tmp/linkpanelcp-src/deb/
```

Any option can be appended to the installer command. [See the complete list](../introduction/getting-started#list-of-installation-options).

## Build packages only

```bash
# Only LinkPanel
./hst_autocompile.sh --linkpanel --noinstall --keepbuild '~localsrc'
```

```bash
# LinkPanel + linkpanel-nginx and linkpanel-php
./hst_autocompile.sh --all --noinstall --keepbuild '~localsrc'
```

## Build and install packages

::: info
Use if you have LinkPanel already installed, for your changes to take effect.
:::

```bash
# Only LinkPanel
./hst_autocompile.sh --linkpanel --install '~localsrc'
```

```bash
# LinkPanel + linkpanel-nginx and linkpanel-php
./hst_autocompile.sh --all --install '~localsrc'
```

## Updating LinkPanel from GitHub

The following is useful for pulling the latest staging/beta changes from GitHub and compiling the changes.

::: info
The following method only supports building the `linkpanel` package. If you need to build `linkpanel-nginx` or `linkpanel-php`, use one of the previous commands.
:::

1. Install Node.js [Download](https://nodejs.org/en/download) or use [Node Source APT](https://github.com/nodesource/distributions)

```bash
v-update-sys-linkpanel-git [USERNAME] [BRANCH]
```

**Note:** Sometimes dependencies will get added or removed when the packages are installed with `dpkg`. It is not possible to preload the dependencies. If this happens, you will see an error like this:

```bash
dpkg: error processing package linkpanel (–install):
dependency problems - leaving unconfigured
```

To solve this issue, run:

```bash
apt install -f
```
