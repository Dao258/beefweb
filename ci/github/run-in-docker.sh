cd "$(dirname $0)/../.."

if [ -z "$BUILD_TYPE" ]; then
    echo BUILD_TYPE is required
    exit 1
fi

if [ -z "$DOCKER_IMAGE" ]; then
    DOCKER_IMAGE=beefweb-main-dev
fi

if [ "$IN_DOCKER" == "1" ]; then
    main
else
    docker run --rm \
        -e IN_DOCKER=1 -e BUILD_TYPE \
        -v $(pwd):/work:z \
        "$DOCKER_IMAGE" "/work/$0"
fi
