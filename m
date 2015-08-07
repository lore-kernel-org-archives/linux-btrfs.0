Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36425 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbbHGKbF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 06:31:05 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1430852599-22724-4-git-send-email-anand.jain@oracle.com>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
	<1430852599-22724-1-git-send-email-anand.jain@oracle.com>
	<1430852599-22724-4-git-send-email-anand.jain@oracle.com>
Date: Fri, 7 Aug 2015 11:31:04 +0100
Message-ID: <CAL3q7H4W663uBV=Xoc4Xs=LxQ5rzoV1hyNy-FQxO1qJDsmu6Gw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] xfstests: btrfs: test device delete with EIO on
 src dev
From: Filipe David Manana <fdmanana@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 5, 2015 at 8:03 PM, Anand Jain <anand.jain@oracle.com> wrote:
> This test case tests if the device delete would work when
> the source device has failed with EIO errors.
>
> EIO errors are achieved usign the DM device.
>
> Also this test needs the latest btrfs-progs and kernel patch

Not patch, but patch set instead. I was looking for a patch with that
title and didn't found any, only a cover letter with the subject:
"[PATCH 0/8 v2] device delete by devid".

> under title
>   [PATCH] device delete by devid
>
> When this patch is not found in the btrfs-progs, this test
> will not run. However when the require patch is not found
> in the kernel it will fail gracefully.

What's the status of these patches (both kernel and btrfs-progs)? I've
noticed they've been around since april and no feedback on the mailing
list.

>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: accepts Dave Chinner's review comments, thanks
>
>  common/rc           |  6 +++++
>  tests/btrfs/088     | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/088.out |  2 ++
>  tests/btrfs/group   |  1 +
>  4 files changed, 80 insertions(+)
>  create mode 100755 tests/btrfs/088
>  create mode 100644 tests/btrfs/088.out
>
> diff --git a/common/rc b/common/rc
> index 447ab7f..aca7a62 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2685,6 +2685,12 @@ _require_test_fcntl_advisory_locks()
>                 _notrun "Require fcntl advisory locks support"
>  }
>
> +_require_btrfs_dev_del_by_devid()
> +{
> +       $BTRFS_UTIL_PROG device delete --help | egrep devid > /dev/null 2>&1
> +       [ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old (must support 'btrfs device delete <devid> /<mnt>')"
> +}
> +
>  _get_total_inode()
>  {
>         if [ -z "$1" ]; then
> diff --git a/tests/btrfs/088 b/tests/btrfs/088
> new file mode 100755
> index 0000000..87814ec
> --- /dev/null
> +++ b/tests/btrfs/088
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/088
> +#
> +# test device delete when the source device has EIO
> +#
> +# Copyright (c) 2015 Oracle.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +
> +_cleanup()
> +{
> +       _cleanup_dmerror
> +       rm -f $tmp
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmerror
> +
> +_supported_fs btrfs
> +_supported_os Linux
> +_need_to_be_root
> +_require_scratch_dev_pool 3
> +_require_btrfs_dev_del_by_devid
> +_require_dmerror
> +
> +rm -f $seqres.full
> +
> +dev1="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $2}'`"
> +dev2="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $3}'`"
> +
> +_init_dmerror
> +_scratch_mkfs_dmerror "-f -d raid1 -m raid1 $dev1 $dev2"
> +_mount_dmerror
> +
> +#$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | _filter_btrfs_filesystem_show
> +
> +error_devid=`$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT |\
> +                       egrep $DMERROR_DEV | $AWK_PROG '{print $2}'`

Any reason to not run here fsstress like the test from patch 2? Doing
the device delete with a non-empty fs is a lot more interesting and
can help find bugs and regressions in the future.

> +
> +# now load the error into the DMERROR_DEV
> +_load_dmerror_table
> +
> +_run_btrfs_util_prog device delete $error_devid $SCRATCH_MNT
> +
> +echo "Silence is golden"
> +status=0; exit
> diff --git a/tests/btrfs/088.out b/tests/btrfs/088.out
> new file mode 100644
> index 0000000..c24480a
> --- /dev/null
> +++ b/tests/btrfs/088.out
> @@ -0,0 +1,2 @@
> +QA output created by 088
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index d66b4fc..d474c47 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -90,3 +90,4 @@
>  085 auto quick metadata subvol
>  086 auto quick clone
>  087 auto quick replace
> +088 auto quick replace
> --
> 2.0.0.153.g79dcccc
>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
