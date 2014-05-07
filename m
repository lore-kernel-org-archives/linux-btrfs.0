Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29747 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbaEGU6j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 16:58:39 -0400
Message-ID: <536A9E73.90802@fb.com>
Date: Wed, 7 May 2014 16:58:27 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/09/2014 11:44 PM, Wang Shilong wrote:
> Test flow is to run fsstress after triggering quota rescan.
> the ruler is simple, we just remove all files and directories,
> sync filesystem and see if qgroup's ref and excl are nodesize.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> v1->v2:
> 	switch into new helper _run_btrfs_util_prog()
> ---
>   tests/btrfs/041     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/041.out |  3 +++
>   tests/btrfs/group   |  1 +
>   3 files changed, 80 insertions(+)
>   create mode 100644 tests/btrfs/041
>   create mode 100644 tests/btrfs/041.out
>
> diff --git a/tests/btrfs/041 b/tests/btrfs/041
> new file mode 100644
> index 0000000..92bd080
> --- /dev/null
> +++ b/tests/btrfs/041
> @@ -0,0 +1,76 @@
> +#! /bin/bash
> +# FSQA Test No. btrfs/041
> +#
> +# Quota rescan stress test, we run fsstress and quota rescan concurrently
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2014 Fujitsu.  All rights reserved.
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
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +run_check _scratch_mkfs "-b 1g --nodesize 4096"
> +run_check _scratch_mount
> +

Add "-o nospace_cache" here please, otherwise I don't get the same output.

> +# -w ensures that the only ops are ones which cause write I/O
> +run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
> +		$FSSTRESS_AVOID >&/dev/null
> +
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT \
> +       $SCRATCH_MNT/snap1 >>$seqres.full 2>&1

_run_btrfs_util_prog will already redirect to $seqres.full, you don't 
need this part.

> +
> +run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -p 5 -n 1000 \
> +       $FSSTRESS_AVOID >&/dev/null
> +
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> +
> +#ignore removing subvolume errors
> +rm -rf $SCRATCH_MNT/* >& /dev/null
> +
> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT >> $seqres.full 2>&1

Same here.

> +_run_btrfs_util_prog qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' \
> +	| $AWK_PROG '{print $1" "$2" "$3 }'
> +

You can't use _run_btrfs_util_prog here, it will eat the output.  You 
need to use $BTRFS_UTIL_PROG instead.  Fix these up and resend, this is 
a really important test and I needed it to make sure my qgroups patch 
was right (which it is now.)  Thanks,

Josef
