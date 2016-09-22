Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756475AbcIVHO2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 03:14:28 -0400
Date: Thu, 22 Sep 2016 15:14:20 +0800
From: Eryu Guan <eguan@redhat.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: check whether we can truncate heavily
 reflinked file
Message-ID: <20160922071420.GR27776@eguan.usersys.redhat.com>
References: <20160922021308.4594-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160922021308.4594-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 10:13:08AM +0800, Wang Xiaoguang wrote:
> In btrfs, there is a bug about btrfs' truncate codes, it'll leak
> some fs space as the truncate operation proceeds. If this truncate
> operation is very large, later metadata request in this truncate
> operation may fail for enospc error. I also have sent a kernel
> patch fot btrfs to fix this issue.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  tests/generic/379     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/379.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 89 insertions(+)
>  create mode 100755 tests/generic/379
>  create mode 100644 tests/generic/379.out
> 
> diff --git a/tests/generic/379 b/tests/generic/379
> new file mode 100755
> index 0000000..3d2918a
> --- /dev/null
> +++ b/tests/generic/379
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# FS QA Test 379
> +#
> +# Create a heavily reflinked file, then check whether we can truncate
> +# it correctly.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Fujitsu.  All Rights Reserved.
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
> +. ./common/reflink
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_scratch_reflink
> +
> +_scratch_mkfs_sized $((32 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +dummyfile1=$SCRATCH_MNT/dummyfile1
> +dummyfile2=$SCRATCH_MNT/dummyfile2
> +blocksize=$((128 * 1024))
> +
> +# create two dummy files, which is used to occupy some fs space first.
> +_pwrite_byte 0xcdcdcdcd 0 $((8 * 1024 * 1024)) $dummyfile1 > /dev/null
> +_pwrite_byte 0xcdcdcdcd 0 $((1 * 1024 * 1024)) $dummyfile2 > /dev/null
> +_pwrite_byte 0xcdcdcdcd 0 $blocksize  $testfile > /dev/null
> +
> +echo "Silence is golden"
> +# try to do reflink unless we get enospc error.
> +i=1
> +while true; do
> +	_reflink_range $testfile 0 $testfile $(($i * $blocksize)) $blocksize \
> +		2>&1 | grep -q "No space left on device"
> +	if [ $? -eq 0 ]; then
> +		break
> +	fi
> +	i=$((i + 1))
> +done

As Darrick said, this still needs too long time to finish on XFS, it
took me almost 30 minutes.

You don't have to loop until the reflinked file consumes all free space,
you can do a fixed number of reflinks then use dd or xfs_io to occupy
the rest of free space. e.g. I ran 16384 reflinks and this could still
reproduce the btrfs bug and test finished in 57s for XFS on my test vm.

# create dummy file, which is used to occupy some fs space first.
_pwrite_byte 0xcdcdcdcd 0 $((1 * 1024 * 1024)) $dummyfile2 > /dev/null
_pwrite_byte 0xcdcdcdcd 0 $blocksize  $testfile > /dev/null

echo "Silence is golden"
i=0
while [ $i -lt 16384 ]; do
	_reflink_range $testfile 0 $testfile $(($i * $blocksize)) $blocksize >/dev/null 2>&1
	i=$((i + 1))
done

# consume all remaining free space
dd if=/dev/zero of=$SCRATCH_MNT/space >/dev/null 2>&1
sync

# them rm dummfile2 and do truncate here

Thanks,
Eryu

> +
> +# fs is almost full now and fs internal operations may need some free space,
> +# for example, in btrfs, transaction will need to reserve space first, so here
> +# free 1MB space.
> +rm -rf $dummyfile2
> +$XFS_IO_PROG -f -c "truncate 0" $testfile
> +
> +status=0
> +exit
> diff --git a/tests/generic/379.out b/tests/generic/379.out
> new file mode 100644
> index 0000000..ec12148
> --- /dev/null
> +++ b/tests/generic/379.out
> @@ -0,0 +1,2 @@
> +QA output created by 379
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index a602b01..73fce91 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -381,3 +381,4 @@
>  376 auto quick metadata
>  377 attr auto quick metadata
>  378 auto quick metadata
> +379 auto clone
> -- 
> 2.9.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
