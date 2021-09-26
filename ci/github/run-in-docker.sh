cd "$(dirname $0)/../.."

if [ -z "$BUILD_TYPE" ]; then
    echo BUILD_TYPE is required
    exit 1
fi

if [ "$IN_DOCKER" == "1" ]; then
    main
else
    docker run --rm \
        -e IN_DOCKER=1 -e BUILD_TYPE \
        -v $(pwd):/work:z \
        beefweb-dev "/work/$0"
fi
