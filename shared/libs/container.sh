# Functions to help with building and running containers.

function splitPath
{
    local path="$1"

    echo "$(dirname "$path") $(basename "$path")"
}

function summariseEverything
{
    echo "Container details:
    containerName       $containerName
    fullPath            $fullPath
    technology          $technology

    port                $port

    modelPath           $modelPath
    optDir              $optDir

    " >&2
}

function complainMissingModels
{
    local testedPath="$1"

    echo "$testedPath doesn't appear to exist yet." >&2
    echo "It doesn't make sense to start without it, or without contents." >&2
    echo "If this is the correct path, you can run:
    ../../../tools/sd-createModelDirs \"$modelPath\""
}

function checkModelPath
{
    for checkPath in "$modelPath"/{,Stable-diffusion,VAE}; do
        if [ ! -e "$checkPath" ]; then
            complainMissingModels "$checkPath"
            exit 1 # TODO Maybe a return is better in case we want to do more with this later.
        fi
    done

    checkPath="$modelPath/Stable-diffusion"
    modelSize="$(du -sk "$modelPath/Stable-diffusion" | awk '{print $1}')"

    if [ "$modelSize" -lt "$minModelSize" ]; then
        echo "There's very little data in the model directory \"$checkPath\". Try downloading some models first." >&2
        exit 1 # TODO Maybe a return is better in case we want to do more with this later.
    fi
}

function createCache
{
    mkdir -p cache/opt
}


# Defaults that probably shouldn't be adjusted by the user.
minModelSize=1024

# Path-derived information.
fullPath="$(pwd)"
read -r remaining containerName < <(splitPath "$fullPath")
read -r remaining technology < <(splitPath "$remaining")

# Other paths.
optDir="$(pwd)/cache/opt"

# Dockerfile-derived information.
port="$(grep EXPOSE Dockerfile | awk '{print $2}')"

# Thing config.
if [ ! -e .thing-general-config.sh ]; then
    echo ".thing-general-config.sh does not exist. That suggests that this thing has not been set up correctly. If you are the thing developer, please see docs/thing/creatingAThing.md" >&2
    exit 1
fi

. .thing-general-config.sh

# User config.
if [ ! -e config.sh ]; then
    cp -v ../config.example.sh config.sh
    echo -e "^--- Remember to edit this to make sure that things like models are where you think they are." >&2
fi

. config.sh



# Sumarise everything.
summariseEverything
