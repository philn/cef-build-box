
# Semi-automatic and reproducible CEF build

## Initial container setup

To be done once (hopefully):

```bash
podman build -t cef-buildbox:v1 .
toolbox create -c cef-buildbox --image cef-buildbox:v1
```

## Get the code (lots of it)

To get the code or update the checkout:

```bash
toolbox run -c cef-buildbox python3 /cef/automate-git.py --download-dir=$PWD/cef-build --branch=5060 --no-distrib --no-build
```

## Compile the things

```bash
toolbox run -c cef-buildbox ./compile-cef --no-debug-build
```

## Host the stuff

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
