# How to create a new thing

## Steps

### 1. Follow things layout

Make sure to follow the structure laid out in the [things README.md](../../things/README.md).

If there isn't an appropriate category, add one.

Inside that category, create the directory for your new thing.

### 2. Run thing-prep

Once **inside** the new thing directory, run

```bash
things/stableDiffusion/example$ ../../../shared/tools/thing-prep
```

## Trouble shooting

### Failed to find the repo root

TODO If this occurs, document how it happened, and how to fix it.

Possible causes:

* Called the script from outside of the repo tree. You should be calling it from within the new thing directory that has been created within a category within the things directory.

### Expected the first part of the relativeThingDir to be "things"

```
Expected the first part of the relativeThingDir to be \"things\", but it was \"$firstLevel\".
```

Possible causes:

* You tried to run thing-prep from somewhere other than the things/ directory structure.

### Not enough levels of abstraction

```
Not enough levels ($levels) of abstraction. Expected things/CATEGORY/thing
```

Possible causes:

* The thing you're creating should be within a category directory within the things directory. See "Follow things layout" above.
