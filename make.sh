#!/bin/bash
# Version 20170302.1

##############################################

if [ "$(id -u)" = "0" ]; then
	echo ""
	echo "You are running as root. Do not do this, it is dangerous."
	echo "Aborting the build. Log in as a regular user and retry."
	echo ""
	exit 1
fi

##############################################

if [ "$1" == -h ] || [ "$1" == --help ]; then
	echo "Parameter 1: target system (1-36)"
	echo "Parameter 2: kernel (1-2)"
	echo "Parameter 3: optimization (1-4)"
	echo "Parameter 4: player (1-2)"
	echo "Parameter 5: external LCD support (1-3)"
	echo "Parameter 6: image (Enigma=1/2 Neutrino=3/4 (1-4)"
	echo "Parameter 7: Neutrino variant (1-4) or Enigma2 diff (0-4)"
	echo "Parameter 8: media Framework (1-3, Enigma2 only))"
	echo "Parameter 9: destination (1-2)"
	exit
fi

##############################################

echo "     _             _ _             _      _                _     _ _    "
echo "    / \  _   _  __| (_) ___  _ __ (_) ___| | _____      __| | __| | |_  "
echo "   / _ \| | | |/ _  | |/ _ \|  _ \| |/ _ \ |/ / __|___ / _  |/ _  | __| "
echo "  / ___ \ |_| | (_| | | (_) | | | | |  __/   <\__ \___| (_| | (_| | |_  "
echo " /_/   \_\__,_|\__,_|_|\___/|_| |_|_|\___|_|\_\___/    \__,_|\__,_|\__| "
echo


##############################################

# Determine image type and receiver model of the previous build, if any
if [ -e ./config ]; then
	cp ./config ./config.old
	LASTBOX=`grep -e "BOXTYPE=" ./config.old | awk '{print substr($0,9,length($0)-7)}'`
	LASTIMAGE1=`grep -e "enigma2" ./config.old`
	LASTIMAGE2=`grep -e "neutrino" ./config.old`
	LASTIMAGE3=`grep -e "tvheadend" ./config.old`
	if [ $LASTIMAGE1 ]; then
		LASTDIFF=`grep -e "E2_DIFF=" ./config.old | awk '{print substr($0,9,length($0)-7)}'`
	fi
	rm -f ./config.old
fi

##############################################

CURDIR=`pwd`
echo -ne "\nChecking the .elf files in $CURDIR/root/boot..."
set='audio_7100 audio_7105 audio_7109 audio_7111 video_7100 video_7105 video_7109 video_7111'
ELFMISSING=0
for i in $set;
do
	if [ ! -e $CURDIR/root/boot/$i.elf ]; then
		echo -e -n "\n\033[31mERROR\033[0m: file $i.elf is missing in ./root/boot"
		ELFMISSING=1
	fi
done
if [ "$ELFMISSING" == "1" ]; then
	echo -e "\n"
	echo "Correct this and retry."
	echo
	exit
fi
echo " [OK]"
if [ -e $CURDIR/root/boot/put_your_elf_files_here ]; then
	rm $CURDIR/root/boot/put_your_elf_files_here
fi
echo

##############################################

# Check if a build from ../cdk is present
if [ -e ../cdk/lastChoice ]; then
	echo -e -n "\nBuild from cdk found, performing make distclean..."
	make distclean 2> /dev/null > /dev/null
	echo " [Done]"
	rm ../cdk/lastChoice
fi

##############################################
case $1 in
	[1-9] | 1[0-9] | 2[0-9] | 3[0-6]) REPLY=$1;;
	*)
		echo "Target receivers:"
		echo
		echo "  Kathrein             Fortis"
		echo "    1)  UFS-910          7)  FS9000 / FS9200 (formerly Fortis HDbox)"
		echo "    2)  UFS-912          8)  HS9510 (formerly Octagon SF1008P)"
		echo "    3)  UFS-913          9*) HS8200 (formerly Atevio AV7500)"
		echo "    4)  UFS-922         10)  HS7110"
		echo "    5)  UFC-960         11)  HS7119"
		echo "                        12)  HS7420"
		echo "  Topfield              13)  HS7429"
		echo "    6)  TF77X0 HDPVR    14)  HS7810A"
		echo "                        15)  HS7819"
		echo
		echo "  AB IPBox             Cuberevo"
		echo "   16)  55HD            19)  id."
		echo "   17)  99HD            20)  mini"
		echo "   18)  9900HD          21)  mini2"
		echo "   19)  9000HD          22)  250HD"
		echo "   20)  900HD           23)  9500HD / 7000HD"
		echo "   21)  910HD           24)  2000HD"
		echo "   13)  91HD            25)  mini_fta / 200HD"
		echo "                        26)  3000HD / Xsarius Alpha"
		echo
		echo "  Fulan                Atemio"
		echo "   27)  Spark           29)  AM520"
		echo "   28)  Spark7162       30)  AM530"
		echo
		echo "  Various"
		echo "   31)  Edision Argus VIP1 v1 [ single tuner + 2 CI + 2 USB ]"
		echo "   32)  SpiderBox HL-101"
		echo "   33)  B4Team ADB 5800S"
		echo "   34)  Vitamin HD5000"
		echo "   35)  SagemCom 88 series"
		echo "   36)  Ferguson Ariva @Link 200"
		echo
		read -p "Select target (1-36)? ";;
esac

case "$REPLY" in
	 1) TARGET="ufs910";;
	 2) TARGET="ufs912";;
	 3) TARGET="ufs913";;
	 4) TARGET="ufs922";;
	 5) TARGET="ufc960";;
	 6) TARGET="tf7700";;
	 7) TARGET="fortis_hdbox";;
	 8) TARGET="octagon1008";;
#	 9) TARGET="atevio7500";;
	10) TARGET="hs7110";;
	11) TARGET="hs7119";;
	12) TARGET="hs7420";;
	13) TARGET="hs7429";;
	14) TARGET="hs7810a";;
	15) TARGET="hs7819";;
	16) TARGET="ipbox55";;
	17) TARGET="ipbox99";;
	18) TARGET="ipbox9900";;
	19) TARGET="cuberevo";;
	20) TARGET="cuberevo_mini";;
	21) TARGET="cuberevo_mini2";;
	22) TARGET="cuberevo_250hd";;
	23) TARGET="cuberevo_9500hd";;
	24) TARGET="cuberevo_2000hd";;
	25) TARGET="cuberevo_mini_fta";;
	26) TARGET="cuberevo_3000hd";;
	27) TARGET="spark";;
	28) TARGET="spark7162";;
	29) TARGET="atemio520";;
	30) TARGET="atemio530";;
	31) TARGET="hl101";;
	32) TARGET="hl101";;
	33) TARGET="adb_box";;
	34) TARGET="vitamin_hd5000";;
	35) TARGET="sagemcom88";;
	36) TARGET="arivalink200";;
	 *) TARGET="atevio7500";;
esac
echo "BOXTYPE=$TARGET" > config

##############################################

case $2 in
	[1-2]) REPLY=$2;;
	*)	echo -e "\nKernel:"
		echo "   1)  STM 24 P0209 [2.6.32.46]"
		echo "   2*) STM 24 P0217 [2.6.32.71]"
		read -p "Select kernel (1-2)? ";;
esac

case "$REPLY" in
	1)  KERNEL="p0209";;
#	2)  KERNEL="p0217";;
	*)  KERNEL="p0217";;
esac
echo "KERNEL=$KERNEL" >> config

##############################################

case $3 in
	[1-4]) REPLY=$3;;
	*)	echo -e "\nOptimization:"
		echo "   1*) optimization for size"
		echo "   2)  optimization normal"
		echo "   3)  Kernel debug"
		echo "   4)  debug (includes Kernel debug)"
		read -p "Select optimization (1-4)? ";;
esac

case "$REPLY" in
#	1)  OPTIMIZATIONS="size";;
	2)  OPTIMIZATIONS="normal";;
	3)  OPTIMIZATIONS="kerneldebug";;
	4)  OPTIMIZATIONS="debug";;
	*)  OPTIMIZATIONS="size";;
esac
echo "OPTIMIZATIONS=$OPTIMIZATIONS" >> config

##############################################

case $4 in
	[1-2]) REPLY=$4;;
	*)	echo -e "\nPlayer:"
		echo "   1)  Player XXX (stmfb-3.1_stm24_0104, for internal testing)"
		echo "   2*) Player 191 (stmfb-3.1_stm24_0104, recommended)"
		read -p "Select player (1-2)? ";;
esac

case "$REPLY" in
	1)	echo "PLAYER_VER=XXX" >> config
		echo "MULTICOM_VER=324" >> config
		;;
#	2)	echo "PLAYER_VER=191" >> config
	*)	echo "PLAYER_VER=191" >> config
		echo "MULTICOM_VER=324" >> config
		;;
#	*)	;;
esac

##############################################

case $5 in
	[1-3]) REPLY=$5;;
	*)	echo -e "\nExternal LCD support:"
		echo "   1*) No external LCD"
		echo "   2)  graphlcd for external LCD"
		echo "   3)  lcd4linux for external LCD"
		read -p "Select external LCD support (1-3)? ";;
esac

case "$REPLY" in
#	1) EXTERNAL_LCD="none";;
	2) EXTERNAL_LCD="externallcd";;
	3) EXTERNAL_LCD="lcd4linux";;
	*) EXTERNAL_LCD="none";;
esac
echo "EXTERNAL_LCD=$EXTERNAL_LCD" >> config

##############################################

case $6 in
	[1-4])	REPLY=$6;;
	*)	echo -e "\nWhich Image do you want to build:"
		echo "   1)  Enigma2"
		echo "   2*) Enigma2 (includes WLAN drivers)"
		echo "   3)  Neutrino"
		echo "   4)  Neutrino (includes WLAN drivers)"
		read -p "Select Image to build (1-4)? ";;
esac

case "$REPLY" in
	1) IMAGE="enigma2";;
#	2) IMAGE="enigma2-wlandriver";;
	3) IMAGE="neutrino";;
	4) IMAGE="neutrino-wlandriver";;
	*) IMAGE="enigma2-wlandriver";;
esac
echo "IMAGE=$IMAGE" >> config

case "$IMAGE" in
	neutrin*)
		case $7 in
			[1-8])	REPLY=$7;;
			*)	echo -e "\nWhich Neutrino variant do you want to build?"
				echo "   1)   Neutrino mp (cst-next)"
				echo "   2)   Neutrino mp (cst-next + plugins)"
				echo "   3)   Neutrino mp (cst-next-ni)"
				echo "   4)   Neutrino mp (cst-next-ni + plugins)"
				echo "   5)   Neutrino HD2 exp"
				echo "   6)   Neutrino HD2 exp + plugins"
				echo "   7)   Neutrino mp (Tangos)"
				echo "   8*)  Neutrino mp (Tangos + plugins)"
#				echo "   9)  Neutrino mp (martii-github)"
				read -p " Select Neutrino variant (1-8)? ";;
		esac
		case "$REPLY" in
			1)	echo "make yaud-neutrino-mp-cst-next" > $CURDIR/build
				NEUTRINO_VAR=mp-cst-next;;
			2)	echo "make yaud-neutrino-mp-cst-next" > $CURDIR/build
				NEUTRINO_VAR=mp-cst-next-plugins;;
			3)	echo "make yaud-neutrino-mp-cst-next-ni" > $CURDIR/build
				NEUTRINO_VAR=mp-cst-next-ni;;
			4)	echo "make yaud-neutrino-mp-cst-next-ni" > $CURDIR/build
				NEUTRINO_VAR=mp-cst-next-ni-plugins;;
			5)	echo "make yaud-neutrino-hd2" > $CURDIR/build
				NEUTRINO_VAR=neutrino-hd2;;
			6)	echo "make yaud-neutrino-hd2" > $CURDIR/build
				NEUTRINO_VAR=neutrino-hd2-plugins;;
			7)	echo "make yaud-neutrino-mp-tangos" > $CURDIR/build
				NEUTRINO_VAR=mp-tangos;;
			*)	echo "make yaud-neutrino-mp-tangos" > $CURDIR/build
				NEUTRINO_VAR=mp-tangos-plugins;;
		esac
		echo "NEUTRINO_VARIANT=$NEUTRINO_VAR" >> config
		MEDIAFW="buildinplayer"

		if [ "$LASTIMAGE1" ] || [ "$LASTIMAGE3" ] || [ ! "$LASTBOX" == "$TARGET" ]; then
			if [ -e ./.deps/ ]; then
				echo -n -e "\nSettings changed, performing distclean..."
				make distclean 2> /dev/null > /dev/null
				echo "[Done]"
			fi
		fi;;
#	enigma*)
	*)
		case $8 in
			[1-3]) REPLY=$8;;
			*)	echo -e "\nMedia Framework:"
				echo "   1)  eplayer3"
				echo "   2)  gstreamer"
				echo "   3*) gstreamer+eplayer3 (recommended)"
				read -p "Select media framework (1-3)? ";;
		esac

		case "$REPLY" in
			1) MEDIAFW="eplayer3";;
			2) MEDIAFW="gstreamer";;
		#	3) MEDIAFW="gst-eplayer3";;
			*) MEDIAFW="gst-eplayer3";;
		esac

		# Determine the OpenPLi diff-level
		case $7 in
			[0-5])	REPLY=$7;;
			*)	echo
				echo "Please select one of the following Enigma2 revisions (default = 2):"
				echo "=================================================================================================="
				echo " 0)  Newest                 - E2 OpenPLi  any framework (CAUTION: may fail due to outdated patch)"
				echo "=================================================================================================="
				echo " 1)  Use your own Enigma2 git dir without patchfile"
				echo "=================================================================================================="
				echo " 2*) Mon, 16 May 2016 22:46 - E2 OpenPLi  any framework  577fa5ab7d5f0f83f18d625b547d148e93cf27d3"
				echo " 3)  Thu, 31 Mar 2016 21:52 - E2 OpenPLi  any framework  7d63bf16e99741f0a5798b84a3688759317eecb3"
				echo " 4)  Mon, 17 Aug 2015 07:08 - E2 OpenPLi  any framework  cd5505a4b8aba823334032bb6fd7901557575455"
				echo " 5)  Sun, 19 Apr 2015 17:05 - E2 OpenPLi  any framework  4f2db7ace4d9b081cbbb3c13947e05312134ed8e"
				echo "=================================================================================================="
				echo "Media Framework         : $MEDIAFW"
				read -p "Select Enigma2 revision : ";;
		esac

		case "$REPLY" in
			1)	DIFF="1"
				REVISION="local";;
			3)	DIFF="3"
				REVISION="7d63bf16e99741f0a5798b84a3688759317eecb3";;
			4)	DIFF="4"
				REVISION="cd5505a4b8aba823334032bb6fd7901557575455";;
			5)	DIFF="5"
				REVISION="4f2db7ace4d9b081cbbb3c13947e05312134ed8e";;
			0)	DIFF="0"
				REVISION="newest";;
			*)	DIFF="2"
				REVISION="577fa5ab7d5f0f83f18d625b547d148e93cf27d3";;
		esac
		echo "E2_DIFF=$DIFF" >> config
		echo "E2_REVISION=$REVISION" >> config

		echo "make yaud-enigma2" > $CURDIR/build

		if [ "$LASTIMAGE2" ] || [ "$LASTIMAGE3" ] || [ ! "$LASTBOX" == "$TARGET" ]; then
			if [ -e ./.deps/ ]; then
				echo -n -e "\nSettings changed, performing distclean..."
				make distclean 2> /dev/null > /dev/null
				echo " [Done]"
			fi
		elif [ ! "$DIFF" == "$LASTDIFF" ]; then
			echo -n -e "\nDiff changed, OpenPli Enigma2 will be rebuilt."
			rm -f ./.deps/enigma2.do_prepare
			rm -f ./.deps/enigma2_networkbrowser
			rm -f ./.deps/enigma2_openwebif
		fi;;
	esac

echo "MEDIAFW=$MEDIAFW" >> config

##############################################

case "$TARGET" in
	hs7110|hs7119|hs7420|hs7429|hs7810a|hs7819)
		case $9 in
			[1-2])	REPLY=$9;;
			*)	echo -e "\nWhere will the image be running:"
				echo "   1*) Flash memory or hard disk"
				echo "   2)  USB stick"
				read -p "Select destination (1-2)? ";;
		esac

		case "$REPLY" in
#			1) DESTINATION="flash";;
			2) DESTINATION="USB";;
			*) DESTINATION="flash";;
		esac
		echo "DESTINATION=$DESTINATION" >> config;;
	*)
		;;
esac


##############################################

chmod 755 $CURDIR/build

make printenv
##############################################
echo "Your build environment is ready :-)"
echo
read -p "Do you want to start the build now (Y*/n)? "

case "$REPLY" in
	N|n|No|NO|no) echo -e "\nOK. To start the build, execute ./build in this directory.\n"
		exit;;
  	*)	$CURDIR/build;;
esac

