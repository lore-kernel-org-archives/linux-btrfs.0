Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35235 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906AbaI2TD4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 15:03:56 -0400
Message-ID: <5429AD14.5000805@fb.com>
Date: Mon, 29 Sep 2014 15:03:48 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Eryu Guan <eguan@redhat.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 01/15] btrfs: new test to run btrfs balance and subvolume
 test simultaneously
References: <1411704901-12723-1-git-send-email-eguan@redhat.com> <1411704901-12723-2-git-send-email-eguan@redhat.com>
In-Reply-To: <1411704901-12723-2-git-send-email-eguan@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/26/2014 12:14 AM, Eryu Guan wrote:
> Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> with fsstress running in background.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>   common/rc           | 110 +++++++++++++++++++++++++++++++++++++++++++++++--
>   tests/btrfs/059     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/059.out |   2 +
>   tests/btrfs/group   |   1 +
>   4 files changed, 224 insertions(+), 4 deletions(-)
>   create mode 100755 tests/btrfs/059
>   create mode 100644 tests/btrfs/059.out
>
> diff --git a/common/rc b/common/rc
> index 4dab101..2393c4b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -582,11 +582,17 @@ _scratch_pool_mkfs()
>   {
>       case $FSTYP in
>       btrfs)
> -	$MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV_POOL > /dev/null
> -	;;
> +        # if dup profile is in mkfs options call _scratch_mkfs instead
> +        # because dup profile only works with single device
> +        if [[ "$*" =~ dup ]]; then
> +            _scratch_mkfs $*
> +        else
> +            $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV_POOL > /dev/null
> +        fi
> +        ;;
>       *)
> -	echo "_scratch_pool_mkfs is not implemented for $FSTYP" 1>&2
> -	;;
> +        echo "_scratch_pool_mkfs is not implemented for $FSTYP" 1>&2
> +        ;;
>       esac
>   }
>
> @@ -2489,6 +2495,102 @@ _get_free_inode()
>   	echo $nr_inode
>   }
>
> +# get btrfs profile configs being tested
> +#
> +# A set of pre-set profile configs are exported via _btrfs_profile_configs
> +# array. Default configs can be overridden by setting BTRFS_PROFILE_CONFIGS
> +# var in the format "metadata_profile:data_profile", multiple configs can be
> +# seperated by space, e.g.
> +# export BTRFS_PROFILE_CONFIGS="raid0:raid0 raid1:raid1 dup:single"
> +_btrfs_get_profile_configs()
> +{
> +	if [ "$FSTYP" != "btrfs" ]; then
> +		return
> +	fi
> +
> +	# no user specified btrfs profile configs, export the default configs
> +	if [ -z "$BTRFS_PROFILE_CONFIGS" ]; then
> +		# default configs
> +		_btrfs_profile_configs=(
> +			"-m single -d single"
> +			"-m dup -d single"
> +			"-m raid0 -d raid0"
> +			"-m raid1 -d raid0"
> +			"-m raid1 -d raid1"
> +			"-m raid10 -d raid10"
> +			"-m raid5 -d raid5"
> +			"-m raid6 -d raid6"
> +		)
> +
> +		# remove dup/raid5/raid6 profiles if we're doing device replace
> +		# dup profile indicates only one device being used (SCRATCH_DEV),
> +		# but we don't want to replace SCRATCH_DEV, which will be used in
> +		# _scratch_mount/_check_scratch_fs etc.
> +		# and raid5/raid6 doesn't support replace yet
> +		if [ "$1" == "replace" ]; then
> +			_btrfs_profile_configs=(
> +				"-m single -d single"
> +				"-m raid0 -d raid0"
> +				"-m raid1 -d raid0"
> +				"-m raid1 -d raid1"
> +				"-m raid10 -d raid10"
> +				# add these back when raid5/6 is working with replace
> +				#"-m raid5 -d raid5"
> +				#"-m raid6 -d raid6"
> +			)
> +		fi
> +		export _btrfs_profile_configs
> +		return
> +	fi
> +
> +	# parse user specified btrfs profile configs
> +	local i=0
> +	local cfg=""
> +	for cfg in $BTRFS_PROFILE_CONFIGS; do
> +		# turn "metadata:data" format to "-m metadata -d data"
> +		# and assign it to _btrfs_profile_configs array
> +		cfg=`echo "$cfg" | sed -e 's/^/-m /' -e 's/:/ -d /'`
> +		_btrfs_profile_configs[$i]="$cfg"
> +		let i=i+1
> +	done
> +
> +	if [ "$1" == "replace" ]; then
> +		if echo ${_btrfs_profile_configs[*]} | grep -q raid[56]; then
> +			_notrun "RAID5/6 doesn't support btrfs device replace yet"
> +		fi
> +	   	if echo ${_btrfs_profile_configs[*]} | grep -q dup; then
> +			_notrun "Do not set dup profile in btrfs device replace test"
> +		fi
> +	fi
> +	export _btrfs_profile_configs
> +}
> +
> +# stress btrfs by running balance operation in a loop
> +_btrfs_stress_balance()
> +{
> +	local btrfs_mnt=$1
> +	while true; do
> +		$BTRFS_UTIL_PROG balance start $btrfs_mnt
> +	done
> +}
> +
> +# stress btrfs by creating/mounting/umounting/deleting subvolume in a loop
> +_btrfs_stress_subvolume()
> +{
> +	local btrfs_dev=$1
> +	local btrfs_mnt=$2
> +	local subvol_name=$3
> +	local subvol_mnt=$4
> +
> +	mkdir -p $subvol_mnt
> +	while true; do
> +		$BTRFS_UTIL_PROG subvolume create $btrfs_mnt/$subvol_name
> +		$MOUNT_PROG -o subvol=$subvol_name $btrfs_dev $subvol_mnt
> +		$UMOUNT_PROG $subvol_mnt
> +		$BTRFS_UTIL_PROG subvolume delete $btrfs_mnt/$subvol_name
> +	done
> +}
> +
>   init_rc()
>   {
>   	if [ "$iam" == new ]
> diff --git a/tests/btrfs/059 b/tests/btrfs/059
> new file mode 100755
> index 0000000..5017299
> --- /dev/null
> +++ b/tests/btrfs/059
> @@ -0,0 +1,115 @@
> +#! /bin/bash
> +# FSQA Test No. btrfs/059
> +#
> +# Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> +# with fsstress running in background.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2014 Red Hat Inc. All rights reserved.
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
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +# we check scratch dev after each loop
> +_require_scratch_nocheck
> +_require_scratch_dev_pool 4
> +_btrfs_get_profile_configs
> +
> +rm -f $seqres.full
> +
> +run_test()
> +{
> +	local mkfs_opts=$1
> +	local subvol_mnt=$TEST_DIR/$seq.mnt
> +
> +	echo "Test $mkfs_opts" >>$seqres.full
> +
> +	_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
> +	# make sure we created btrfs with desired options
> +	if [ $? -ne 0 ]; then
> +		echo "mkfs $mkfs_opts failed" | tee -a $seqres.full
> +		return
> +	fi
> +	_scratch_mount >>$seqres.full 2>&1
> +
> +	args=`_scale_fsstress_args -p 20 -n 100 $FSSTRESS_AVOID -d $SCRATCH_MNT/stressdir`
> +	echo "Run fsstress $args" >>$seqres.full
> +	$FSSTRESS_PROG $args >/dev/null 2>&1 &
> +	fsstress_pid=$!
> +
> +	echo -n "Start balance worker: " >>$seqres.full
> +	_btrfs_stress_balance $SCRATCH_MNT >/dev/null 2>&1 &
> +	balance_pid=$!
> +	echo "$balance_pid" >>$seqres.full
> +
> +	echo -n "Start subvolume worker: " >>$seqres.full
> +	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt >/dev/null 2>&1 &
> +	subvol_pid=$!
> +	echo "$subvol_pid" >>$seqres.full
> +
> +	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
> +	wait $fsstress_pid
> +
> +	kill $balance_pid $subvol_pid
> +	wait
> +	# wait for the balance operation to finish
> +	while ps aux | grep "balance start" | grep -qv grep; do
> +		sleep 1
> +	done

This bit isn't needed, killing the balance pid also won't do anything, 
just waiting is enough, it'll only exit once the balance is finished. 
If you really want to stop the balance you can use

btrfs ba cancel

and then just wait for the pid to exit, that is good enough.  Thanks,

Josef
