# Things

Things are different pieces of software that we want to run.

If there's something you want to run, this is the place to be.

## Layout

Because of the sheer number of things that you can run, they are separated out into categories. Eg:

```
/
    /things
        /stableDiffusion
            /automatic1111
            /comfyUI
        /llama
            /llama.cpp
            /olama
```

## Building and running

There should be a README.md within each thing to give you specifics. But in general:

* get into the directory of the thing you want to run.
* Run `./build` to build the thing.
* Run `./run` to run it.

## Creating a thing

There is [documentation to help you create a thing](../docs/thing/creatingAThing.md).
