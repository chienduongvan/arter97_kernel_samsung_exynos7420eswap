#!/bin/bash
if [ ! "${1}" = "skip" ] ; then
	./build_clean.sh
	./build_kernel.sh CC='$(CROSS_COMPILE)gcc' "$@" || exit 1
fi

if [ -e boot.img ] ; then
	rm arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat version)".zip 2>/dev/null
	cp boot.img kernelzip/boot.img
	tail -n $(($(cat ramdisk/default.prop | wc -l) - $(grep -n "START OVERRIDE" ramdisk/default.prop | cut -d : -f 1) + 1)) ramdisk/default.prop > kernelzip/kernel.prop
	cd kernelzip/
	7z a -mx9 arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat ../version)"-tmp.zip *
	zipalign -v 4 arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat ../version)"-tmp.zip ../arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat ../version)".zip
	rm arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat ../version)"-tmp.zip
	cd ..
	ls -al arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat version)".zip
	rm kernelzip/boot.img kernelzip/kernel.prop
fi
