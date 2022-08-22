
# Semi-automatic and reproducible CEF build

## Initial container setup

To be done once (hopefully). This container will have the basic build dependencies installed.

```bash
podman build -t cef-buildbox:v1 .
toolbox create -c cef-buildbox --image cef-buildbox:v1
```

## Get the code (lots of it)

To get the code or update the checkout. In this example the code will be stored in `cef-build`. You need around 30GB of free disk space.

```bash
toolbox run -c cef-buildbox python3 /cef/automate-git.py --download-dir=$PWD/cef-build --branch=5060 --no-distrib --no-build
```

## Compile the things

This will bake a release build in `cef-build/chromium/src/cef/binary_distrib`.

```bash
toolbox run -c cef-buildbox ./compile-cef --download-dir=$PWD/cef-build --no-debug-build
```

## Host the stuff

Write a SHA1 checksum file for each tarball, and host everything through a Web server.

```fish
for f in (find cef-build/chromium/src/cef/binary_distrib -name "*.tar.bz2")
      sha1sum $f | cut -d' ' -f1 > $f.sha1
end
python -m http.server --directory cef-build/chromium/src/cef/binary_distrib/ 8080
```

## Customize the gstcef build

See https://github.com/centricular/gstcefsrc/pull/51

```bash
rm -fr build/ third_party/
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCEF_VERSION="103.0.12+g8eb56c7+chromium-103.0.5060.134" -DCEF_BUILDS_HOMEPAGE_URL="http://0.0.0.0:8080/" -B build -S .
ninja -C build
```
