Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29395 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751406AbbAZJbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 04:31:53 -0500
Message-ID: <54C6097F.8040600@cn.fujitsu.com>
Date: Mon, 26 Jan 2015 17:31:43 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Xing Gu <gux.fnst@cn.fujitsu.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, <david@fromorbit.com>, <eguan@redhat.com>
Subject: Re: [PATCH v5] btrfs: add regression test for remount with thread_pool
 resized
References: <1422261834-8691-1-git-send-email-gux.fnst@cn.fujitsu.com>
In-Reply-To: <1422261834-8691-1-git-send-email-gux.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH v5] btrfs: add regression test for remount with 
thread_pool resized
From: Xing Gu <gux.fnst@cn.fujitsu.com>
To: <fstests@vger.kernel.org>
Date: 2015年01月26日 16:43
> Regression test for a btrfs issue of resizing 'thread_pool' when
> remount the fs.
>
> This regression was introduced by the following linux kernel commit:
>      btrfs: Added btrfs_workqueue_struct implemented ordered
>      execution based on kernel workqueue
>      08a9ff3264181986d1d692a4e6fce3669700c9f8
> And it was fixed by the following linux kernel commit:
>      btrfs: fix crash in remount(thread_pool=) case
>      800ee2247f483b6d05ed47ef3bbc90b56451746c
>
> Signed-off-by: Xing Gu <gux.fnst@cn.fujitsu.com>
> ---
>   v4->v5: Redirect stderr to /dev/null.
>
>   v3->v4: Remove the check for a bug message.
>
>   v2->v3: Add the regresssion commit in description.
>           Remove "dmesg -c > /dev/null".
>           Echo "Silence is golden" to indicate that an empty output
>           file is expected.
>
>   v1->v2: Add the fix commit in description.
>           Add the check for a bug message.
> ---
>   tests/btrfs/082     | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/082.out |  2 ++
>   tests/btrfs/group   |  1 +
>   3 files changed, 68 insertions(+)
>   create mode 100755 tests/btrfs/082
>   create mode 100644 tests/btrfs/082.out
>
> diff --git a/tests/btrfs/082 b/tests/btrfs/082
> new file mode 100755
> index 0000000..c52e5f3
> --- /dev/null
> +++ b/tests/btrfs/082
> @@ -0,0 +1,65 @@
> +#!/bin/bash
> +# FS QA Test No. btrfs/082
> +#
> +# Regression test for a btrfs issue of resizing 'thread_pool' when
> +# remount the fs.
> +#
> +# This regression was introduced by the following linux kernel commit:
> +#     btrfs: Added btrfs_workqueue_struct implemented ordered
> +#     execution based on kernel workqueue
> +#     08a9ff3264181986d1d692a4e6fce3669700c9f8
> +# And it was fixed by the following linux kernel commit:
> +#     btrfs: fix crash in remount(thread_pool=) case
> +#     800ee2247f483b6d05ed47ef3bbc90b56451746c
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
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
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +    rm -f $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
IMHO, it's better to add a new btrfs_mkfs_filter(or something similar) 
to common/filter.btrfs,
and modify the btrfs case in common/rc:scratch_mkfs() to use the filter 
to wipe the "Performing TRIM"
line *ONLY*, as other btrfs filters do.

Thanks,
Qu
> +
> +_scratch_mount "-o thread_pool=6"
> +_scratch_mount "-o remount,thread_pool=10"
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/082.out b/tests/btrfs/082.out
> new file mode 100644
> index 0000000..2977f14
> --- /dev/null
> +++ b/tests/btrfs/082.out
> @@ -0,0 +1,2 @@
> +QA output created by 082
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index e29999b..fd2fa76 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -84,3 +84,4 @@
>   079 auto rw metadata
>   080 auto snapshot
>   081 auto quick clone
> +082 auto quick remount

