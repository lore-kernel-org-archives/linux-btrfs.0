Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60259 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab3JJFQB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 01:16:01 -0400
Message-ID: <52563761.1090600@cn.fujitsu.com>
Date: Thu, 10 Oct 2013 13:13:05 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Eryu Guan <eguan@redhat.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests btrfs/012: test balance while creating and deleting
 subvolumes
References: <1381380733-27117-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1381380733-27117-1-git-send-email-eguan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2013 12:52 PM, Eryu Guan wrote:

Gui Hecheng has send a patch for this before:

[PATCH V2] xfstest: an regression test for btrfs balance
https://patchwork.kernel.org/patch/3006261/

Thanks,
Wang
> Do subvolume create/delete in loop at back ground and do filesystem
> balance at the same time could trigger
>
> kernel BUG at fs/btrfs/relocation.c:2255!
>
> on 3.12-rc4 kernel.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>   tests/btrfs/012     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/012.out | 11 ++++++++
>   tests/btrfs/group   |  1 +
>   3 files changed, 86 insertions(+)
>   create mode 100755 tests/btrfs/012
>   create mode 100644 tests/btrfs/012.out
>
> diff --git a/tests/btrfs/012 b/tests/btrfs/012
> new file mode 100755
> index 0000000..3f72a9b
> --- /dev/null
> +++ b/tests/btrfs/012
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/012
> +#
> +# Test btrfs balance while creating and deleting subvolumes
> +#
> +# On buggy kernel this could trigger:
> +# kernel BUG at fs/btrfs/relocation.c:2255!
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
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
> +_require_scratch_dev_pool
> +
> +subvolume=subvol_$seq
> +rm -f $seqres.full
> +
> +subvolume_create_delete()
> +{
> +	while true; do
> +		$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/$subvolume >/dev/null
> +		$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/$subvolume >/dev/null
> +	done
> +}
> +
> +_scratch_pool_mkfs >> $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +subvolume_create_delete &
> +
> +for i in `seq 1 10`;do
> +	$BTRFS_UTIL_PROG filesystem balance start $SCRATCH_MNT >>$seqres.full 2>&1
> +	echo "Done balance loop $i"
> +done
> +kill $!
> +wait
> +
> +# No crash, test passed
> +status=0
> +exit
> diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
> new file mode 100644
> index 0000000..9604f1b
> --- /dev/null
> +++ b/tests/btrfs/012.out
> @@ -0,0 +1,11 @@
> +QA output created by 012
> +Done balance loop 1
> +Done balance loop 2
> +Done balance loop 3
> +Done balance loop 4
> +Done balance loop 5
> +Done balance loop 6
> +Done balance loop 7
> +Done balance loop 8
> +Done balance loop 9
> +Done balance loop 10
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index d2fe030..c12b9e9 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -14,3 +14,4 @@
>   009 auto quick
>   010 auto quick
>   011 auto
> +012 auto quick

