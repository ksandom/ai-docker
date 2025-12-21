# Thing-specific (not user-specific) config.
# Users usually shouldn't mess with this file.

# The port that the app will listen on inside the container.
insidePort=7860

# Set the default port that the container will export. The user may want to override this in their config.sh
port="$insidePort"

# The default model location that the user will want to override.
modelPath="models"

# Where models should be mounted inside the container.
internalModelPath="/opt/models"
