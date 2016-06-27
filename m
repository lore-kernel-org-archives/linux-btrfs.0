Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbcF0I0j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 04:26:39 -0400
Date: Mon, 27 Jun 2016 16:26:37 +0800
From: Eryu Guan <eguan@redhat.com>
To: jeffm@suse.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] fstests: btrfs/125: test sysfs exports of allocation
 and device membership info
Message-ID: <20160627082637.GS23649@eguan.usersys.redhat.com>
References: <1466780914-23884-1-git-send-email-jeffm@suse.com>
 <1466780914-23884-3-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466780914-23884-3-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 11:08:33AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> This tests the sysfs publishing for btrfs allocation and device
> membership info under a number of different layouts, similar to the
> btrfs replace test. We test the allocation files only for existence and
> that they contain numerical values. We test the device membership
> by mapping the devices used to create the file system to sysfs paths
> and matching them against the paths used for the device membership
> symlinks.
> 
> It passes on kernels without a /sys/fs/btrfs/<fsid> directory.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  common/config       |   4 +-
>  common/rc           |   7 ++
>  tests/btrfs/125     | 193 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/125.out |   2 +
>  tests/btrfs/group   |   1 +
>  5 files changed, 205 insertions(+), 2 deletions(-)
>  create mode 100755 tests/btrfs/125
>  create mode 100644 tests/btrfs/125.out
> 
> diff --git a/common/config b/common/config
> index c25b1ec..c5e65f7 100644
> --- a/common/config
> +++ b/common/config
> @@ -201,13 +201,13 @@ export DEBUGFS_PROG="`set_prog_path debugfs`"
>  # newer systems have udevadm command but older systems like RHEL5 don't.
>  # But if neither one is available, just set it to "sleep 1" to wait for lv to
>  # be settled
> -UDEV_SETTLE_PROG="`set_prog_path udevadm`"
> +UDEVADM_PROG="`set_prog_path udevadm`"
>  if [ "$UDEV_SETTLE_PROG" == "" ]; then

$UDEVADM_PROG should be checked here, not $UDEV_SETTLE_PROG anymore.

>  	# try udevsettle command
>  	UDEV_SETTLE_PROG="`set_prog_path udevsettle`"
>  else
>  	# udevadm is available, add 'settle' as subcommand
> -	UDEV_SETTLE_PROG="$UDEV_SETTLE_PROG settle"
> +	UDEV_SETTLE_PROG="$UDEVADM_PROG settle"
>  fi
>  # neither command is available, use sleep 1
>  if [ "$UDEV_SETTLE_PROG" == "" ]; then
> diff --git a/common/rc b/common/rc
> index 4b05fcf..f4c4312 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -76,6 +76,13 @@ _btrfs_get_subvolid()
>  	$BTRFS_UTIL_PROG sub list $mnt | grep $name | awk '{ print $2 }'
>  }
>  
> +_btrfs_get_feature_flags()
> +{
> +	local dev=$1
> +	local class=$2
> +	$BTRFS_SHOW_SUPER_PROG $dev | grep ^${class}_flags | awk '{print $NF}'
> +}
> +
>  _btrfs_get_fsid()
>  {
>  	local dev=$1
> diff --git a/tests/btrfs/125 b/tests/btrfs/125
> new file mode 100755
> index 0000000..83f1921
> --- /dev/null
> +++ b/tests/btrfs/125
> @@ -0,0 +1,193 @@
> +#! /bin/bash
> +# FS QA Test No. 125
> +#
> +# Test of the btrfs sysfs publishing
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2013-2016 SUSE.  All rights reserved.

Copyright year is 2016.

> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "== QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1

Missing _cleanup and trap, use "./new btrfs" to generate new btrfs test.

> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs

Missing "_supported_os" call. Following the template create by the
'./new' script makes it easier :)

> +_require_scratch
> +_require_scratch_dev_pool
> +_require_command "$UDEVADM_PROG"

We usually provide a program name as a second param

_require_command "$UDEVADM_PROG" udevadm

> +
> +rm -f $seqres.full
> +rm -f $tmp.tmp

This should be "rm -f $tmp.*" and belongs to _cleanup()

> +
> +check_file() {
> +	local file=$1
> +	base="$(echo "$file" | sed -e 's#/sys/fs/btrfs/[0-9a-f-][0-9a-f-]*/##')"
> +	if [ ! -f "$file" ]; then
> +		echo "$base missing."
> +		return 0

No need to return 0/1 based on failure/pass, because check_chunk()
doesn't need to exit on failure.

> +	else
> +		value="$(cat $file)"
> +		if [ -n "$(echo $value | tr -d 0-9)" ]; then
> +			echo "ERROR: $base: numerical value expected" \
> +			     "(got $value)"
> +			return 0
> +		fi
> +	fi
> +	return 1
> +}
> +
> +check_chunk() {
> +	path=$1
> +	mkfs_options=$2
> +	error=false
> +
> +	chunktype=$(basename $path)
> +	if [ ! -d "$path" ]; then
> +		echo "No $chunktype directory."
> +		exit 1

Don't exit, 'return' just works.

> +	fi
> +
> +	for file in bytes_may_use bytes_pinned bytes_reserved bytes_used \
> +		    disk_total disk_used flags total_bytes \
> +		    total_bytes_pinned; do
> +		if check_file "$path/$file"; then
> +			error=true
> +		fi

No need to check errors

> +	done
> +
> +	if [ "$chunktype" = "data" -o "$chunktype" = "mixed" ]; then
> +		opt="-d"
> +	elif [ "$chunktype" = "metadata" -o "$chunktype" = "system" ]; then
> +		opt="-m"
> +	fi
> +
> +	profile=$(echo $mkfs_options | sed -e "s/.*$opt \([[:alnum:]]*\).*/\1/")
> +	if [ ! -d "$path/$profile" ]; then
> +		echo "No $profile dir for $chunktype"
> +		exit 1

Don't exit, 'return' is OK.

> +	fi
> +
> +	for file in total_bytes used_bytes; do
> +		if check_file $path/$profile/$file; then
> +			error=true
> +		fi

No need to check errors

> +	done
> +
> +	$error && exit 1

Because no need to exit.

> +}
> +
> +check_dev_link() {

"{" in a seperate line.

> +	local dev=$1
> +	DEV="/sys/$($UDEVADM_PROG info --query=path $dev)"
> +	DEV="$(readlink -f $DEV)"
> +	found=false
> +	for link in $sysfs_base/devices/*; do
> +		LINK="$(readlink -f $link)"
> +		if [ "$LINK" = "$DEV" ]; then
> +			found=true
> +			break
> +		fi
> +	done
> +	if ! $found; then
> +		echo "Symlink for $dev missing in $sysfs_base/devices"
> +		return 1
> +	fi
> +	return 0
> +}

check_dev_link() is basiclly checking every device used by this btrfs
filesystem is listed in $sysfs_base/devices/ dir and points to a valid
device entry in sysfs, so I think we can do something like this:

check_dev_link()
{
	local dev=$1
	local dname=`_short_dev $dev`

	if [ ! -e $sysfs_base/devices/$dname ]; then
		echo "Symlink for $dev is missing in $sysfs_base/devices"
	fi
}

And we don't require $UDEVADM_PROG in this test. Hope I didn't miss
anything.

> +
> +workout()
> +{
> +	local mkfs_options="$1"
> +	local num_devs4raid="$2"
> +	local fssize
> +	local used_devs=""
> +
> +	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt $num_devs4raid ]; then
> +		echo "Skip workout $1 $2 $3 $4"
> +		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL," \
> +		     "required: $num_devs4raid"

These echos breaks golden image and fails the test if there aren't
enough devices in $SCRATCH_DEV_POOL

You should call _require_scratch_dev_pool with a number as parameter to
specify the minium number of devices needed in this test.

_require_scratch_dev_pool 4

> +		echo "Skip workout $1 $2 $3 $4" >> $seqres.full
> +		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL," \
> +		     "required: $num_devs4raid" >> $seqres.full
> +		return 0
> +	fi
> +
> +	if [ "$num_devs4raid" -gt 1 ]; then
> +		used_devs=$(echo $SCRATCH_DEV_POOL|tr '\t' ' '| \
> +			    cut -d ' ' -f 2-$num_devs4raid)
> +	fi
> +
> +	_scratch_mkfs $mkfs_options $used_devs >> $seqres.full 2>&1 || \

You should update $SCRATCH_DEV_POOL to contain $num_devs4raid devices
and call _scratch_pool_mkfs here, and reset $SCRATCH_DEV_POOL to
original dev list for next test. _scratch_mkfs only creates filesystem
on SCRATCH_DEV.

> +	_fail "mkfs failed"

Don't _fail, just print out error message and return, so next profile
config can be tested.

> +
> +	_scratch_mount
> +
> +	# Check allocation
> +	sysfs_base="/sys/fs/btrfs/$(_btrfs_get_fsid $SCRATCH_DEV)"

Hmm, I think _btrfs_get_fsid should work on $SCRATCH_MNT, $SCRATCH_DEV
might not be in current $SCRATCH_DEV_POOL (though not likely).

> +
> +	# Feature isn't present for testing
> +	if [ ! -d "$sysfs_base" ]; then
> +		echo "Skipping sysfs test: $sysfs_base not found." \
> +		     >> $seqres.full
> +		return
> +	fi

Test should _notrun if feature is not present. And we do the check
before any actual tests.

> +
> +	mixed=false
> +	case "$mkfs_options" in
> +	*-M*)
> +		mixed=true;
> +		;;
> +	esac
> +
> +	check_chunk "$sysfs_base/allocation/system" "$mkfs_options"
> +	if $mixed; then
> +		check_chunk "$sysfs_base/allocation/mixed" "$mkfs_options"
> +	else
> +		check_chunk "$sysfs_base/allocation/data" "$mkfs_options"
> +		check_chunk "$sysfs_base/allocation/metadata" "$mkfs_options"
> +	fi
> +
> +	for dev in $used_devs; do
> +		check_dev_link $dev || exit 1

Don't exit.

> +	done
> +
> +	umount $SCRATCH_MNT > /dev/null 2>&1

_scratch_unmount

Thanks,
Eryu

> +}
> +
> +workout "-m single -d single" 1
> +workout "-m single -d single -M" 1
> +workout "-m dup -d single" 1
> +workout "-m dup -d dup -M" 1
> +workout "-m raid0 -d raid0" 2
> +workout "-m raid1 -d raid1" 2
> +workout "-m raid5 -d raid5" 2
> +workout "-m raid6 -d raid6" 3
> +workout "-m raid10 -d raid10" 4
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/125.out b/tests/btrfs/125.out
> new file mode 100644
> index 0000000..91f76e8
> --- /dev/null
> +++ b/tests/btrfs/125.out
> @@ -0,0 +1,2 @@
> +== QA output created by 125
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 8b5050e..3535f02 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -127,3 +127,4 @@
>  122 auto quick snapshot qgroup
>  123 auto quick qgroup
>  124 auto quick metadata
> +125 auto quick metadata
> -- 
> 1.8.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
