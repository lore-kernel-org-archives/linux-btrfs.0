Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:44250 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbeGQFtz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 01:49:55 -0400
Date: Tue, 17 Jul 2018 13:19:03 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: fstests@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH v2] fstests: btrfs/168 verify device ready after device
 delete
Message-ID: <20180717051903.GK2830@desktop>
References: <20180703084753.21116-1-anand.jain@oracle.com>
 <20180706060137.1672-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180706060137.1672-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2018 at 02:01:37PM +0800, Anand Jain wrote:
> This test case verifies if the device ready return success after the
> device delete.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Need some helps from btrfs folks to see if it's a valid test. Thanks!

Eryu

> ---
> v1->v2: use _run_btrfs_util_prog instead of open coding it.
> 
>  tests/btrfs/168     | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/168.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 71 insertions(+)
>  create mode 100755 tests/btrfs/168
>  create mode 100644 tests/btrfs/168.out
> 
> diff --git a/tests/btrfs/168 b/tests/btrfs/168
> new file mode 100755
> index 000000000000..0d3e99839209
> --- /dev/null
> +++ b/tests/btrfs/168
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2018 Oracle. All Rights Reserved.
> +#
> +# FS QA Test 168
> +#
> +# Test if btrfs is still reported ready after the device delete
> +#
> +# This could be fixed by the following kernel commit:
> +#  btrfs: fix missing superblock update in the device delete commit transaction
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
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
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_command "$BTRFS_TUNE_PROG" btrfstune
> +_require_scratch_dev_pool 2
> +
> +_scratch_dev_pool_get 2
> +dev_1=$(echo $SCRATCH_DEV_POOL | awk '{print $1}')
> +dev_2=$(echo $SCRATCH_DEV_POOL | awk '{print $2}')
> +
> +# normal delete device and then check for ready
> +run_check _scratch_pool_mkfs "-d single -m single"
> +_scratch_mount
> +_run_btrfs_util_prog device delete $dev_1 $SCRATCH_MNT
> +_run_btrfs_util_prog device ready $dev_2
> +
> +_scratch_unmount
> +# delete a seed device and then check for ready
> +run_check $BTRFS_TUNE_PROG -S 1 $dev_2
> +run_check _mount $dev_2 $SCRATCH_MNT
> +_run_btrfs_util_prog device add -f $dev_1 $SCRATCH_MNT
> +run_check mount -o rw,remount $dev_1 $SCRATCH_MNT
> +_run_btrfs_util_prog device delete $dev_2 $SCRATCH_MNT
> +_run_btrfs_util_prog device ready $dev_1
> +
> +_scratch_unmount
> +_scratch_dev_pool_put
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/168.out b/tests/btrfs/168.out
> new file mode 100644
> index 000000000000..893a41d859c8
> --- /dev/null
> +++ b/tests/btrfs/168.out
> @@ -0,0 +1,2 @@
> +QA output created by 168
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 5cff3bd6cc03..7bc3ea457992 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -170,3 +170,4 @@
>  165 auto quick subvol
>  166 auto quick qgroup
>  167 auto quick replace volume
> +168 auto quick volume
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
