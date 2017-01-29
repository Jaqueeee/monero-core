if [ -z $BUILD_TYPE ]; then
    BUILD_TYPE=release
fi

# echo "Building IOS armv7"
# $SHELL get_libwallet_api.sh $BUILD_TYPE-ios armv7
# echo "Building IOS arm64"
# $SHELL get_libwallet_api.sh $BUILD_TYPE-ios arm64

echo "Building IOS armv7"
rm -r monero/build
mkdir -p monero/build/release
pushd monero/build/release
cmake -D IOS=ON -D ARCH=armv7 -D CMAKE_BUILD_TYPE=debug -D STATIC=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="/Users/jacob/crypto/monero-core/monero"  ../..
make -j4 && make install
popd
echo "Building IOS arm64"
rm -r monero/build
mkdir -p monero/build/release
pushd monero/build/release
cmake -D IOS=ON -D ARCH=arm64 -D CMAKE_BUILD_TYPE=debug -D STATIC=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="/Users/jacob/crypto/monero-core/monero"  ../..
make -j4 && make install
popd

echo "Creating fat library for armv7 and arm64"
pushd monero
mkdir -p lib-ios
lipo -create lib-armv7/libwallet_merged.a lib-arm64/libwallet_merged.a -output lib-ios/libwallet_merged.a
lipo -create lib-armv7/libunbound.a lib-arm64/libunbound.a -output lib-ios/libunbound.a
lipo -create lib-armv7/libepee.a lib-arm64/libepee.a -output lib-ios/libepee.a
popd