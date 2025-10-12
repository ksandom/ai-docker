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

    " >&2
}

function complainMissingModels
{
    echo "$modelPath doesn't appear to exist yet." >&2
    echo "It doesn't make sense to start without it, or without contents." >&2
    echo "If this is the correct path, you can run:
    ../../../tools/sd-createModelDirs \"$modelPath\""
}

function checkModelPath
{
    for checkPath in "$modelPath"/{,Stable-diffusion,VAE}; do
        if [ ! -e "$checkPath" ]; then
            complainMissingModels
            exit 1
        fi
    done
}


# Path-derived information.
fullPath="$(pwd)"
read -r remaining containerName < <(splitPath "$fullPath")
read -r remaining technology < <(splitPath "$remaining")

# Dockerfile-derived information.
port="$(grep EXPOSE Dockerfile | awk '{print $2}')"

# Models.
if [ ! -e config.sh ]; then
    cp -v ../config.example.sh config.sh
    echo -e "^--- Remember to edit this to make sure that things like models are where you think they are." >&2
fi

. config.sh



# Sumarise everything.
summariseEverything
