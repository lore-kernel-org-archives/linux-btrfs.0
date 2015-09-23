Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22468 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752913AbbIWD7I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 23:59:08 -0400
Subject: Re: [PATCH 0/4] btrfs: update qgroups in drop snapshot
To: Mark Fasheh <mfasheh@suse.de>, <linux-btrfs@vger.kernel.org>
References: <1442952948-21389-1-git-send-email-mfasheh@suse.de>
CC: <jbacik@fb.com>, <clm@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56022381.6030606@cn.fujitsu.com>
Date: Wed, 23 Sep 2015 11:58:57 +0800
MIME-Version: 1.0
In-Reply-To: <1442952948-21389-1-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

I'd like to test the patchset, but it seems to be a little out of date, 
and failed to apply to integration-4.3.

Would you please rebase it to integration-4.3?

Thanks,
Qu

Mark Fasheh wrote on 2015/09/22 13:15 -0700:
> Hi,
>
> The following 4 patches fix a regression introduced in Linux
> 4.2 where btrfs_drop_snapshot() wasn't updating qgroups, resulting in
> them going bad.
>
> The original e-mail pointing this out is below:
>
> http://www.spinics.net/lists/linux-btrfs/msg46093.html
>
>
> The first two patches are from Josef and fix bugs in our counting of
> roots (which is critical for qgroups to work correctly). Both were
> sent to the list already:
>
> http://www.spinics.net/lists/linux-btrfs/msg47035.html
> http://www.spinics.net/lists/linux-btrfs/msg47150.html
>
> Truth be told, most of the time fixing this was spent figuring out
> those two issues. Once I realized I was seeing a bug and we fixed it
> correctly, my drop snapshot patch got dramatically smaller.
>
> I also re-added some of the tracing in qgroup.c that we recently
> lost. It is again possible to debug qgroup operations on a live
> system, allowing us to find issues like the two above by narrowing
> down our operations and manually walking through them via
> cat sys/debug/tracing.
>
> The entire patch series can be tested with the following xfstests.git
> patch, which will be sent to the appropriate list shortly)
>
> https://github.com/markfasheh/xfstests/commit/b09ca51c012824e44546b13862ab1f93a6f2f675
>
> Thanks,
> 	--Mark
>
>
> From: Mark Fasheh <mfasheh@suse.de>
>
> [PATCH] btrfs: add test for quota groups and drop snapshot
>
> Test btrfs quota group consistency operations during snapshot
> delete. Btrfs has had long standing issues with drop snapshot
> failing to properly account for quota groups. This test crafts
> several snapshot trees with shared and exclusive elements. One of
> the trees is removed and then quota group consistency is checked.
>
> This issue is fixed by the following linux kernel patches:
>     Btrfs: use btrfs_get_fs_root in resolve_indirect_ref
>     Btrfs: keep dropped roots in cache until transaciton commit
>     btrfs: qgroup: account shared subtree during snapshot delete
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>   tests/btrfs/098   | 166 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/group |   1 +
>   2 files changed, 167 insertions(+)
>   create mode 100644 tests/btrfs/098
>
> diff --git a/tests/btrfs/098 b/tests/btrfs/098
> new file mode 100644
> index 0000000..7977a90
> --- /dev/null
> +++ b/tests/btrfs/098
> @@ -0,0 +1,166 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/098
> +#
> +# Test btrfs quota group consistency operations during snapshot
> +# delete. Btrfs has had long standing issues with drop snapshot
> +# failing to properly account for quota groups. This test crafts
> +# several snapshot trees with shared and exclusive elements. One of
> +# the trees is removed and then quota group consistency is checked.
> +#
> +# This issue is fixed by the following linux kernel patches:
> +#
> +#    Btrfs: use btrfs_get_fs_root in resolve_indirect_ref
> +#    Btrfs: keep dropped roots in cache until transaciton commit
> +#    btrfs: qgroup: account shared subtree during snapshot delete
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
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
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	rm -fr $tmp
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_need_to_be_root
> +
> +rm -f $seqres.full
> +
> +# Create an fs tree of a given height at a target location. This is
> +# done by agressively creating inline extents to expand the number of
> +# nodes required. We also add an traditional extent so that
> +# drop_snapshot is forced to walk at least one extent that is not
> +# stored in metadata.
> +#
> +# NOTE: The ability to vary tree height for this test is very useful
> +# for debugging problems with drop_snapshot(). As a result we retain
> +# that parameter even though the test below always does level 2 trees.
> +_explode_fs_tree () {
> +    local level=$1;
> +    local loc="$2";
> +    local bs=4095;
> +    local cnt=1;
> +    local n;
> +
> +    if [ -z $loc ]; then
> +	echo "specify location for fileset"
> +	exit 1;
> +    fi
> +
> +    case $level in
> +	1)# this always reproduces level 1 trees	
> +	    n=10;
> +	    ;;
> +	2)# this always reproduces level 2 trees
> +	    n=1500
> +	    ;;
> +	3)# this always reproduces level 3 trees
> +	    n=1000000;
> +	    ;;
> +	*)
> +	    echo "Can't make level $level trees";
> +	    exit 1;
> +	    ;;
> +    esac
> +
> +    mkdir -p $loc
> +    for i in `seq -w 1 $n`;
> +    do
> +	dd status=none if=/dev/zero of=$loc/file$i bs=$bs count=$cnt
> +    done
> +
> +    bs=131072
> +    cnt=1
> +    dd status=none if=/dev/zero of=$loc/extentfile bs=$bs count=$cnt
> +}
> +
> +# Force the default leaf size as the calculations for making our btree
> +# heights are based on that.
> +run_check _scratch_mkfs "--nodesize 16384"
> +_scratch_mount
> +
> +# populate the default subvolume and create a snapshot ('snap1')
> +_explode_fs_tree 1 $SCRATCH_MNT/files
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap1
> +
> +# create new btree nodes in this snapshot. They will become shared
> +# with the next snapshot we create.
> +_explode_fs_tree 1 $SCRATCH_MNT/snap1/files-snap1
> +
> +# create our final snapshot ('snap2'), populate it with
> +# exclusively owned nodes.
> +#
> +# As a result of this action, snap2 will get an implied ref to the
> +# 128K extent created in the default subvolume.
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT/snap1 $SCRATCH_MNT/snap2
> +_explode_fs_tree 1 $SCRATCH_MNT/snap2/files-snap2
> +
> +# Enable qgroups now that we have our filesystem prepared. This
> +# will kick off a scan which we will have to wait for.
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> +
> +# Remount to clear cache, force everything to disk
> +_scratch_unmount
> +_scratch_mount
> +
> +# Finally, delete snap1 to trigger btrfs_drop_snapshot(). This
> +# snapshot is most interesting to delete because it will cause some
> +# nodes to go exclusively owned for snap2, while some will stay shared
> +# with the default subvolume. That exercises a maximum of the drop
> +# snapshot/qgroup interactions.
> +#
> +# snap2s imlied ref from to the 128K extent in files/ can be lost by
> +# the root finding code in qgroup accounting due to snap1 no longer
> +# providing a path to it. This was fixed by the first two patches
> +# referenced above.
> +_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap1
> +
> +# There is no way from userspace to force btrfs_drop_snapshot to run
> +# at a given time (even via mount/unmount). We must wait for it to
> +# start and complete. This is the shortest time on my tests systems I
> +# have found which always allows drop_snapshot to run to completion.
> +sleep 45
> +
> +_scratch_unmount
> +
> +# generate a qgroup report and look for inconsistent groups
> +#  - don't use _run_btrfs_util_prog here as it captures the output and
> +#    we need to grep it.
> +$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | grep -E -q "Counts for qgroup.*are different"
> +if [ $? -ne 0 ]; then
> +    status=0
> +fi
> +
> +exit
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index e13865a..d78a355 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -100,3 +100,4 @@
>   095 auto quick metadata
>   096 auto quick clone
>   097 auto quick send clone
> +098 auto qgroup
>
