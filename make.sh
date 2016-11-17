#!/bin/bash
# Version 20161115.1

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
	echo "Parameter 8: media Framework (1-4, Enigma2 only))"
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

case $1 in
	[1-9] | 1[0-9] | 2[0-9] | 3[0-6]) REPLY=$1;;
	*)
		echo "Target receivers:"
		echo "    1)  Kathrein UFS-910"
		echo "    2)  Kathrein UFS-912"
		echo "    3)  Kathrein UFS-913"
		echo "    4)  Kathrein UFS-922"
		echo "    5)  Kathrein UFC-960"
		echo "    6)  Topfield TF77X0 HDPVR"
		echo "    7)  IPBOX55"
		echo "    8)  IPBOX99"
		echo "    9)  IPBOX9900"
		echo "   10)  Cuberevo [ IPBOX 9000 ]"
		echo "   11)  Cuberevo mini [ IPBOX 900 ]"
		echo "   12)  Cuberevo mini2 [ IPBOX 910 ]"
		echo "   13)  Cuberevo 250 [ IPBOX 91 ]"
		echo "   14)  Cuberevo 9500HD [ 7000HD ]"
		echo "   15)  Cuberevo 2000HD"
		echo "   16)  Cuberevo mini_fta [ 200HD ]"
		echo "   17)  Xsarius Alpha [ Cuberevo 3000HD ]"
		echo "   18)  Fortis HDbox [ Fortis FS9000/9200 ]"
		echo "   19)  Octagon SF1008P [ Fortis HS9510 ]"
		echo "   20*) Atevio AV7500 [ Fortis HS8200 ]"
		echo "   21)  Fortis HS7110"
		echo "   22)  Fortis HS7119"
		echo "   23)  Fortis HS7420"
		echo "   24)  Fortis HS7429"
		echo "   25)  Fortis HS7810A"
		echo "   26)  Fortis HS7819"
		echo "   27)  Atemio AM520"
		echo "   28)  Atemio AM530"
		echo "   29)  Edision Argus VIP1 v1 [ single tuner + 2 CI + 2 USB ]"
		echo "   30)  SpiderBox HL-101"
		echo "   31)  SPARK"
		echo "   32)  SPARK7162"
		echo "   33)  B4Team ADB 5800S"
		echo "   34)  Vitamin HD5000"
		echo "   35)  SagemCom 88 series"
		echo "   36)  Ferguson Ariva @Link 200"
		read -p "Select target (1-36)? ";;
esac

case "$REPLY" in
	 1) TARGET="ufs910";;
	 2) TARGET="ufs912";;
	 3) TARGET="ufs913";;
	 4) TARGET="ufs922";;
	 5) TARGET="ufc960";;
	 6) TARGET="tf7700";;
	 7) TARGET="ipbox55";;
	 8) TARGET="ipbox99";;
	 9) TARGET="ipbox9900";;
	10) TARGET="cuberevo";;
	11) TARGET="cuberevo_mini";;
	12) TARGET="cuberevo_mini2";;
	13) TARGET="cuberevo_250hd";;
	14) TARGET="cuberevo_9500hd";;
	15) TARGET="cuberevo_2000hd";;
	16) TARGET="cuberevo_mini_fta";;
	17) TARGET="cuberevo_3000hd";;
	18) TARGET="fortis_hdbox";;
	19) TARGET="octagon1008";;
	20) TARGET="atevio7500";;
	21) TARGET="hs7110";;
	22) TARGET="hs7119";;
	23) TARGET="hs7420";;
	24) TARGET="hs7429";;
	25) TARGET="hs7810a";;
	26) TARGET="hs7819";;
	27) TARGET="atemio520";;
	28) TARGET="atemio530";;
	29) TARGET="hl101";;
	30) TARGET="hl101";;
	31) TARGET="spark";;
	32) TARGET="spark7162";;
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
			[1-4])	REPLY=$7;;
			*)	echo -e "\nWhich Neutrino variant do you want to build?"
				echo "   1)  Neutrino mp (cst-next)"
				echo "   2) Neutrino mp (cst-next-ni)"
				echo "   3)  Neutrino HD2 exp"
				echo "   4*)  Neutrino mp (Tangos)"
#				echo "   5)  Neutrino mp (martii-github)"
				read -p " Select Neutrino variant (1-4)? ";;
		esac
		case "$REPLY" in
			1)	echo "make yaud-neutrino-mp-cst-next" > $CURDIR/build
				NEUTRINO_VAR=mp-cst-next;;
			2)	echo "make yaud-neutrino-mp-cst-next-ni" > $CURDIR/build
				NEUTRINO_VAR=mp-cst-next-ni;;
			3)	echo "make yaud-neutrino-hd2" > $CURDIR/build
				NEUTRINO_VAR=neutrino-hd2;;
			*)	echo "make yaud-neutrino-mp-tangos" > $CURDIR/build
				NEUTRINO_VAR=mp-tangos;;
		esac
		echo "NEUTRINO_VARIANT=$NEUTRINO_VAR" >> config
		MEDIAFW="buildinplayer"

		if [ "$LASTIMAGE1" ] || [ "$LASTIMAGE3" ] || [ ! "$LASTBOX" == "$TARGET" ]; then
			if [ -e ./.deps ]; then
				echo -n "Settings changed, performing distclean..."
				make distclean 2> /dev/null > /dev/null
				echo "[Done]"
			fi
		fi;;
#	enigma*)
	*)
		# Determine the OpenPLi diff-level
		case $7 in
			[0-5])	REPLY=$7;;
			*)	echo
				echo "Please select one of the following Enigma2 revisions (default = 2):"
				echo "================================================================================================="
				echo " 0) Newest                 - E2 OpenPLi  any framework (CAUTION: may fail due to outdated patch)"
				echo "================================================================================================="
				echo " 1) Use your own Enigma2 git dir without patchfile"
				echo "================================================================================================="
				echo " 2) Mon, 16 May 2016 22:46 - E2 OpenPLi  any framework  577fa5ab7d5f0f83f18d625b547d148e93cf27d3"
				echo " 3) Thu, 31 Mar 2016 21:52 - E2 OpenPLi  any framework  7d63bf16e99741f0a5798b84a3688759317eecb3"
				echo " 4) Mon, 17 Aug 2015 07:08 - E2 OpenPLi  any framework  cd5505a4b8aba823334032bb6fd7901557575455"
				echo " 5) Sun, 19 Apr 2015 17:05 - E2 OpenPLi  any framework  4f2db7ace4d9b081cbbb3c13947e05312134ed8e"
				echo "================================================================================================="
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

		echo "make yaud-enigma2" > $CURDIR/build

		if [ "$LASTIMAGE2" ] || [ "$LASTIMAGE3" ] || [ ! "$LASTBOX" == "$TARGET" ]; then
			if [ -e ./.deps ]; then
				echo -n "Settings changed, performing distclean..."
				make distclean 2> /dev/null > /dev/null
				echo "[Done]"
			fi
		elif [ ! "$DIFF" == "$LASTDIFF" ]; then
			echo "$DIFF $LASTDIFF"
			echo -n "Diff changed, OpenPli Enigma2 will be rebuilt ."
			rm -f ./.deps/enigma2.do_prepare
			rm -f ./.deps/enigma2_networkbrowser
			rm -f ./.deps/enigma2_openwebif
		fi;;
	esac

echo "MEDIAFW=$MEDIAFW" >> config

chmod 755 $CURDIR/build
##############################################
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

