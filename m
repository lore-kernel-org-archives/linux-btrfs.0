Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751595AbdFBOGx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:06:53 -0400
Date: Fri, 2 Jun 2017 16:05:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 6/6] btrfs-progs: test: Introduce functions to prepare
 and cleanup loop device
Message-ID: <20170602140551.GL12135@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170531055610.11606-1-quwenruo@cn.fujitsu.com>
 <20170531055610.11606-7-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170531055610.11606-7-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 31, 2017 at 01:56:10PM +0800, Qu Wenruo wrote:
> +# prepare loop device using specified size and path
> +# $1: path of the file
> +# $2: size of the device, optional, default value is '2G'
> +prepare_loop_dev()
> +{
> +	local path="$1"
> +	local size="$2"
> +
> +	[[ "$path" ]] || _fail "path must be specified for prepare_loop_dev()"

There's _assert_path helper, for this purpose.

> +	[[ "$size" ]] || size='2G'
> +
> +	# Cleanup if it's already mounted or set up as loop device
> +	cleanup_loop_dev $path

Any reference to paths must be quoted.

> +	run_check touch $path
> +	chmod a+rw $path
> +	run_check truncate -s $size $path
> +
> +	run_check_stdout $SUDO_HELPER losetup --find --show $path
> +}
> +
> +# cleanup loop device based on its backend file
> +# $1: the path of the backend file
> +#
> +# We don't want to populate result in cleanup, so any error will only be
> +# caught manually, don't call run_check here.
> +cleanup_loop_dev()
> +{
> +	local path="$1"
> +
> +	loop_dev=$(losetup -l | tail -n +2 | grep $path | cut -f1 -d\ )

So, this lists existing loop devices, skips the heading, looks for some
random unquoted path, and extracts a filename. Also known as 'losetup -j $path'.

> +	if [ ! -z "$loop_dev" ]; then
> +		umount $loop_dev &> /dev/null

I'd like to preserve the output of commands, even if it fills the log.
It's usually helpful. The umount call is unconditional, so if you want
to discard erros when the device is not mounted, I suggest to do
'findmnt', umount and catch any errors. Eg. we want to know when the
umount fails, so we should not try to delete the loop device, as below.
Unexpectedly failing umount can be something worth investigating.

> +		$SUDO_HELPER losetup -d $loop_dev || \
> +			_fail "failed to detach $path"
> +	fi
> +}
> +
>  prepare_test_dev()
>  {
>  	# num[K/M/G/T...]
> diff --git a/tests/misc-tests/006-image-on-missing-device/test.sh b/tests/misc-tests/006-image-on-missing-device/test.sh
> index 5b6fe065..8249c0e9 100755
> --- a/tests/misc-tests/006-image-on-missing-device/test.sh
> +++ b/tests/misc-tests/006-image-on-missing-device/test.sh
> @@ -23,21 +23,15 @@ setup_root_helper
>  prepare_devices()
>  {
>  	for i in `seq $ndevs`; do
> -		touch img$i
> -		chmod a+rw img$i
> -		truncate -s0 img$i
> -		truncate -s2g img$i
> -		devs[$i]=`run_check_stdout $SUDO_HELPER losetup --find --show img$i`
> +		devs[$i]=$(prepare_loop_dev img$i)
>  	done
>  }
>  
>  cleanup_devices()
>  {
> -	for dev in ${devs[@]}; do
> -		run_mayfail $SUDO_HELPER losetup -d $dev
> -	done
>  	for i in `seq $ndevs`; do
> -		truncate -s0 img$i
> +		cleanup_loop_dev img$i
> +		rm img$i
>  	done
>  	run_check $SUDO_HELPER losetup --all
>  }
> diff --git a/tests/misc-tests/011-delete-missing-device/test.sh b/tests/misc-tests/011-delete-missing-device/test.sh
> index 5b5f9786..ad4b7d45 100755
> --- a/tests/misc-tests/011-delete-missing-device/test.sh
> +++ b/tests/misc-tests/011-delete-missing-device/test.sh
> @@ -16,21 +16,15 @@ setup_root_helper
>  prepare_devices()
>  {
>  	for i in `seq $ndevs`; do
> -		touch img$i
> -		chmod a+rw img$i
> -		truncate -s0 img$i
> -		truncate -s2g img$i
> -		devs[$i]=`run_check_stdout $SUDO_HELPER losetup --find --show img$i`
> +		devs[$i]=$(prepare_loop_dev img$i)
>  	done
>  }
>  
>  cleanup_devices()
>  {
> -	for dev in ${devs[@]}; do
> -		run_mayfail $SUDO_HELPER losetup -d $dev
> -	done
>  	for i in `seq $ndevs`; do
> -		truncate -s0 img$i
> +		cleanup_loop_dev img$i
> +		rm img$i
>  	done
>  	run_check $SUDO_HELPER losetup --all
>  }
> diff --git a/tests/mkfs-tests/001-basic-profiles/test.sh b/tests/mkfs-tests/001-basic-profiles/test.sh
> index 0dc9a2bd..98bd9e6b 100755
> --- a/tests/mkfs-tests/001-basic-profiles/test.sh
> +++ b/tests/mkfs-tests/001-basic-profiles/test.sh
> @@ -16,21 +16,15 @@ setup_root_helper
>  prepare_devices()
>  {
>  	for i in `seq $ndevs`; do
> -		touch img$i
> -		chmod a+rw img$i
> -		truncate -s0 img$i
> -		truncate -s2g img$i
> -		devs[$i]=`run_check_stdout $SUDO_HELPER losetup --find --show img$i`
> +		devs[$i]=$(prepare_loop_dev img$i)
>  	done
>  }
>  
>  cleanup_devices()
>  {
> -	for dev in ${devs[@]}; do
> -		run_check $SUDO_HELPER losetup -d $dev
> -	done
>  	for i in `seq $ndevs`; do
> -		truncate -s0 img$i
> +		cleanup_loop_dev img$i
> +		rm img$i
>  	done
>  	run_check $SUDO_HELPER losetup --all
>  }
> diff --git a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
> index 63fb1785..aacff6ee 100755
> --- a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
> +++ b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
> @@ -13,11 +13,7 @@ dmname=\
>  btrfs-test-with-very-long-name-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
>  dmdev=/dev/mapper/$dmname
>  
> -run_check truncate -s0 img
> -chmod a+w img
> -run_check truncate -s2g img
> -
> -loopdev=`run_check_stdout $SUDO_HELPER losetup --find --show img`
> +loopdev=$(prepare_loop_dev img)
>  run_check $SUDO_HELPER dmsetup create $dmname --table "0 1048576 linear $loopdev 0"
>  
>  dmbase=`readlink -f $dmdev`
> @@ -36,5 +32,5 @@ run_check $SUDO_HELPER $TOP/btrfs inspect-internal dump-super $dmdev
>  
>  # cleanup
>  run_check $SUDO_HELPER dmsetup remove $dmname
> -run_mayfail $SUDO_HELPER losetup -d $loopdev
> -run_check truncate -s0 img
> +cleanup_loop_dev img
> +rm img
> diff --git a/tests/mkfs-tests/006-partitioned-loopdev/test.sh b/tests/mkfs-tests/006-partitioned-loopdev/test.sh
> index 12f37842..b005ef3d 100755
> --- a/tests/mkfs-tests/006-partitioned-loopdev/test.sh
> +++ b/tests/mkfs-tests/006-partitioned-loopdev/test.sh
> @@ -12,12 +12,8 @@ check_prereq mkfs.btrfs
>  
>  setup_root_helper
>  
> -run_check truncate -s0 img
> -chmod a+w img
>  cp partition-1g-1g img
> -run_check truncate -s2g img
> -
> -loopdev=$(run_check_stdout $SUDO_HELPER losetup --partscan --find --show img)
> +loopdev=$(prepare_loop_dev img)
>  base=$(basename $loopdev)
>  
>  # expect partitions named like loop0p1 etc
> @@ -27,5 +23,5 @@ for looppart in $(ls /dev/$base?*); do
>  done
>  
>  # cleanup
> -run_check $SUDO_HELPER losetup -d $loopdev
> -run_check truncate -s0 img
> +cleanup_loop_dev img
> +rm img
> -- 
> 2.13.0
> 
> 
> 
