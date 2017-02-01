#!/bin/bash
rm .version
# Bash Color
green='\033[01;32m'
red='\033[01;31m'
cyan='\033[01;36m'
blue='\033[01;34m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
DEFCONFIG="lineageos-wt86518_defconfig"
KERNEL="zImage"

#Hyper Kernel Details
BASE_VER="Phantom"
VER="-r6-$(date +"%Y-%m-%d"-%H%M)-"
Hyper_VER="$BASE_VER$VER$TC"

# Vars
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=dev-harsh1998
export KBUILD_BUILD_HOST=Dummy-Server
export LOCALVERSION="-PhAnToM™"

# Paths
KERNEL_DIR=`pwd`
RESOURCE_DIR="/home/harshit/kernel/lenovo"
ANYKERNEL_DIR="$RESOURCE_DIR/hyper"
TOOLCHAIN_DIR="/home/harshit/kernel/tc"
REPACK_DIR="$ANYKERNEL_DIR"
PATCH_DIR="$ANYKERNEL_DIR/patch"
MODULES_DIR="$ANYKERNEL_DIR/modules"
ZIP_MOVE="$RESOURCE_DIR/kernel_out"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm/boot"

# Functions
function make_kernel {
		make $DEFCONFIG $THREAD
		make $KERNEL $THREAD
                make dtbs $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/zImage
}

#function make_modules {
#		cd $KERNEL_DIR
#		make modules $THREAD
#		find $KERNEL_DIR -name '*.ko' -exec cp {} $MODULES_DIR/ \;
#		cd $MODULES_DIR
#       $STRIP --strip-unneeded *.ko
#      cd $KERNEL_DIR
#}

function make_dtb {
		$KERNEL_DIR/dtbToolCM -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
		cp -vr $KERNEL_DIR/arch/arm/boot/dt.img $REPACK_DIR/dtb
}

function make_zip {
		cd $REPACK_DIR
                zip -r `echo $Hyper_VER$TC`.zip *
		mv  `echo $Hyper_VER$TC`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

DATE_START=$(date +"%s")


echo -e "${green}"
echo "--------------------------------------------------------"
echo "Wellcome !!!   Initiatig To Compile $Hyper_VER    "
echo "--------------------------------------------------------"
echo -e "${restore}"

echo -e "${cyan}"
while read -p "Plese Select Desired Toolchain for compiling Phantom Kernel

SABERMOD-4.9---->(1)

Phantom-4.9---->(2)


" echoice
do
case "$echoice" in
	1 )
		export CROSS_COMPILE=$TOOLCHAIN_DIR/saber-4.9/bin/arm-eabi-
		export LD_LIBRARY_PATH=$TOOLCHAIN_DIR/saber-4.9/lib/
		STRIP=$TOOLCHAIN_DIR/saber-4.9/bin/arm-eabi-
		TC="SM"
		rm -rf $MODULES_DIR/*
		rm -rf $ZIP_MOVE/*
		rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
		cd $ANYKERNEL_DIR
		rm -rf zImage
		rm -rf dtb
                cd $KERNEL_DIR
		make clean && make mrproper
		echo "cleaned directory"
		echo "Compiling Hyper Kernel Using SABERMOD-4.9 Toolchain"
		break
		;;
	2 )
		export CROSS_COMPILE=$TOOLCHAIN_DIR/Phantom-4.9/bin/arm-eabi-
		export LD_LIBRARY_PATH=$TOOLCHAIN_DIR/Phantom-4.9/lib/
		STRIP=$TOOLCHAIN_DIR/uber-4.9/bin/arm-eabi-
		TC="UB"
		rm -rf $MODULES_DIR/*
		rm -rf $ZIP_MOVE/*
		rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
		cd $ANYKERNEL_DIR
		rm -rf zImage
		rm -rf dtb
		cd $KERNEL_DIR
		make clean && make mrproper
		echo "cleaned directory"
		echo "Compiling Phantom Kernel Using Phantom-4.9 Toolchain"
		break
		;;

	* )
		echo
		echo "Invalid Selection try again !!"
		echo
		;;
esac
done
echo -e "${restore}"

echo
while read -p "Do you want to start Building Phantom Kernel ?

Yes Or No ? 

Enter Y for Yes Or N for No
" dchoice
do
case "$dchoice" in
	y|Y )
		make_kernel
		make_dtb
		make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid Selection try again !!"
		echo
		;;
esac
done
echo -e "${green}"
echo $Hyper_VER$TC.zip
echo "------------------------------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo " "
cd $ZIP_MOVE
