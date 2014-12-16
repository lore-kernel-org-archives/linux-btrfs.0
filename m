Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaLPMKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 07:10:47 -0500
Date: Tue, 16 Dec 2014 20:10:43 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: btrfs/080 add test case for qgroup account on
 shared extents
Message-ID: <20141216121043.GF15495@dhcp-13-216.nay.redhat.com>
References: <1418723004-30543-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418723004-30543-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 16, 2014 at 05:43:24PM +0800, Liu Bo wrote:
> This is a regression test of
> 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")'
> 
> It can produce qgroup related warnings.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

I have trouble applying the patch, can you please take a look?

patch: **** malformed patch at line 83: diff --git a/tests/btrfs/080.out b/tests/btrfs/080.out

And for new test case, "btrfs: add test case for qgroup ..." is good
enough, the seq number may be changed in future.

Some comments inline by looking at the patch.

> ---
>  tests/btrfs/080     | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/080.out |  3 +++
>  2 files changed, 76 insertions(+)
>  create mode 100755 tests/btrfs/080
>  create mode 100644 tests/btrfs/080.out

You need to add test description to tests/btrfs/group too. And you can
use the first unused seq number, I think it's 017 now.

> 
> diff --git a/tests/btrfs/080 b/tests/btrfs/080
> new file mode 100755
> index 0000000..2a12bf2
> --- /dev/null
> +++ b/tests/btrfs/080
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# FS QA Test No. 080
> +#
> +# Regression of 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")'
> +# this will throw a warning into dmesg.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Liu Bo.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#-----------------------------------------------------------------------
> +#
> +
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
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +run_check _scratch_mkfs "-b 1g --nodesize 4096"
> +run_check _scratch_mount

I'm not sure if we need run_check here, I'll look at it again when I
can run the test.

> +
> +run_check xfs_io -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo

Use $XFS_IO_PROG here, which adds "-F" option if fs is not xfs.

> +
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
> +
> +run_check cp --reflink $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
> +run_check cp --reflink $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink
> +run_check cp --reflink $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink2

Need _require_cp_reflink first.

> +
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> +
> +rm -fr $SCRATCH_MNT/* >& /dev/null

I prefer "rm -fr $SCRATCH_MNT/* >/dev/null 2>&1"

But we use /bin/bash for all fstests tests, >& can work too..

> +
> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> +
> +$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | $AWK_PROG '{print $2" "$3}'

Will dmesg log be checked? As the test will trigger warnings in dmesg, I
assume that's how the test determine pass/fail.

Thanks,
Eryu
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/080.out b/tests/btrfs/080.out
> new file mode 100644
> index 0000000..eafa7c3
> --- /dev/null
> +++ b/tests/btrfs/080.out
> @@ -0,0 +1,3 @@
> +QA output created by 080
> +4096 4096
> +4096 4096
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
