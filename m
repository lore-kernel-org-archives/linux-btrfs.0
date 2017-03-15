Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16370 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751273AbdCODBL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 23:01:11 -0400
Subject: Re: [PATCH] fstests: generic: Test space allocation when there is
 only fragmented space
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
References: <20170308022040.13827-1-quwenruo@cn.fujitsu.com>
CC: Filipe Manana <fdmanana@kernel.org>, Liu Bo <bo.li.liu@oracle.com>,
        Eryu Guan <eguan@redhat.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <712d5564-3d3f-e5f2-3c41-f4d39acce455@cn.fujitsu.com>
Date: Wed, 15 Mar 2017 11:01:05 +0800
MIME-Version: 1.0
In-Reply-To: <20170308022040.13827-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any comment on this patch?

Thanks,
Qu

At 03/08/2017 10:20 AM, Qu Wenruo wrote:
> This test case will test if file system works well when handling large
> write while available space are all fragmented.
>
> This can expose a bug in a btrfs unmerged patch, which wrongly modified
> the delayed allocation code, to exit before allocating all space, and
> cause hang when unmounting.
>
> The wrong patch is:
> [PATCH v6 1/2] btrfs: Fix metadata underflow caused by btrfs_reloc_clone_csum error
>
> The test case will:
> 1) Fill small filesystem with page sized small files
>    All these files has a sequential number as file name
> 2) Remove files with odd number as file name
>    This will free almost half of the space
> 3) Try to write a file which takes 1/8 of the file system
>
> The method to create fragmented fs may not be generic enough, but should
> work for most extent based fs.
> Unless one file system will allocate extents from both end of its free
> space.
>
> Cc: Filipe Manana <fdmanana@kernel.org>
> Cc: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  tests/generic/416     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/416.out |  3 ++
>  tests/generic/group   |  1 +
>  3 files changed, 103 insertions(+)
>  create mode 100755 tests/generic/416
>  create mode 100644 tests/generic/416.out
>
> diff --git a/tests/generic/416 b/tests/generic/416
> new file mode 100755
> index 0000000..925524b
> --- /dev/null
> +++ b/tests/generic/416
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# FS QA Test 416
> +#
> +# Test fs behavior when large write request can't be met by one single extent
> +#
> +# Inspired by a bug in a btrfs fix, which doesn't get exposed by current test
> +# cases
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Fujitsu.  All Rights Reserved.
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os IRIX Linux
> +_require_scratch
> +
> +fs_size=$((128 * 1024 * 1024))
> +page_size=$(get_page_size)
> +
> +# We will never reach this number though
> +nr_files=$(($fs_size / $page_size))
> +
> +# Use small fs to make the fill more faster
> +_scratch_mkfs_sized $fs_size >> $seqres.full 2>&1
> +
> +_scratch_mount
> +
> +fill_fs()
> +{
> +	dir=$1
> +	for i in $(seq -w $nr_files); do
> +		# xfs_io can't return correct value when it hit ENOSPC, use
> +		# dd here to detect ENOSPC
> +		dd if=/dev/zero of=$SCRATCH_MNT/$i bs=$page_size count=1 \
> +			&> /dev/null
> +		if [ $? -ne 0 ]; then
> +			break
> +		fi
> +	done
> +}
> +
> +fill_fs $SCRATCH_MNT
> +
> +# remount to sync every thing into fs, and drop all cache
> +_scratch_remount
> +
> +# remove all files with odd file names, which should free near half
> +# of the space
> +rm $SCRATCH_MNT/*[13579]
> +sync
> +
> +# We should be able to write at least 1/8 of the whole fs size
> +# The number 1/8 is for btrfs, which only has about 47M for data.
> +# And half of the 47M is already taken up, so only 1/8 is safe here
> +$XFS_IO_PROG -f -c "pwrite 0 $(($fs_size / 8))" $SCRATCH_MNT/large_file | \
> +	_filter_xfs_io
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/416.out b/tests/generic/416.out
> new file mode 100644
> index 0000000..8d2ffac
> --- /dev/null
> +++ b/tests/generic/416.out
> @@ -0,0 +1,3 @@
> +QA output created by 416
> +wrote 16777216/16777216 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/tests/generic/group b/tests/generic/group
> index b510d41..59f94f9 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -418,3 +418,4 @@
>  413 auto quick
>  414 auto quick clone
>  415 auto clone
> +416 auto enospc
>


