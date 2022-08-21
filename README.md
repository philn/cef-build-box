
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
toolbox run -c cef-buildbox ./compile-cef
```
