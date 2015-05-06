Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:32797 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbbEFIyl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 04:54:41 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1430852599-22724-3-git-send-email-anand.jain@oracle.com>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
	<1430852599-22724-1-git-send-email-anand.jain@oracle.com>
	<1430852599-22724-3-git-send-email-anand.jain@oracle.com>
Date: Wed, 6 May 2015 09:54:40 +0100
Message-ID: <CAL3q7H6SkeQo2-bJYhuxJn4c93gDHUJ6tYsj3P5+2mtZ+eJh1g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] xfstests: btrfs: test device replace, with EIO on
 the src dev
From: Filipe David Manana <fdmanana@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 5, 2015 at 8:03 PM, Anand Jain <anand.jain@oracle.com> wrote:
> This test case will test to confirm the replace works when
> the replacing source device has EIO errors.
>
> EIO condition is achieved using the DM device.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: accepts Dave Chinner's review comments
>
>  tests/btrfs/087     | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/087.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 73 insertions(+)
>  create mode 100755 tests/btrfs/087
>  create mode 100644 tests/btrfs/087.out
>
> diff --git a/tests/btrfs/087 b/tests/btrfs/087
> new file mode 100755
> index 0000000..01b8aec
> --- /dev/null
> +++ b/tests/btrfs/087
> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/087
> +#
> +#test device replace works when the source device has EIO
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
> +_require_dmerror
> +
> +rm -f $seqres.full
> +
> +dev1="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $2}'`"
> +dev2="`echo $SCRATCH_DEV_POOL | $AWK_PROG '{print $3}'`"
> +
> +_init_dmerror
> +_scratch_mkfs_dmerror "-f -d raid1 -m raid1 $dev1"
> +_mount_dmerror
> +
> +#$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT | _filter_btrfs_filesystem_show
> +
> +error_devid=`$BTRFS_UTIL_PROG filesystem show -m $SCRATCH_MNT |\
> +                       egrep $DMERROR_DEV | $AWK_PROG '{print $2}'`
> +
> +# now load the error into the DMERROR_DEV
> +_load_dmerror_table
> +
> +_run_btrfs_util_prog replace start -B $error_devid $dev2 $SCRATCH_MNT

Can we make this more interesting/useful by having a non-empty fs
before exercising the replace?

For e.g. fsstress with a bunch snapshots:

snapshot_cmd="$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT"
snapshot_cmd="$snapshot_cmd $SCRATCH_MNT/snap_\`date +'%H_%M_%S_%N'\`"
$FSSTRESS_PROG -d $SCRATCH_MNT -n 200 -p 8 $FSSTRESS_AVOID -x
"$snapshot_cmd" -X 50

Same observation for your other test in this patch series.

thanks


> +
> +echo "Silence is golden"
> +status=0; exit
> diff --git a/tests/btrfs/087.out b/tests/btrfs/087.out
> new file mode 100644
> index 0000000..e84c64c
> --- /dev/null
> +++ b/tests/btrfs/087.out
> @@ -0,0 +1,2 @@
> +QA output created by 087
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index e9c15af..d66b4fc 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -89,3 +89,4 @@
>  084 auto quick send
>  085 auto quick metadata subvol
>  086 auto quick clone
> +087 auto quick replace
> --
> 2.0.0.153.g79dcccc
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
