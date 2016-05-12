Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42039 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbcELFCE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 01:02:04 -0400
Date: Wed, 11 May 2016 22:01:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, david@fromorbit.com,
        hch@infradead.org
Subject: Re: [PATCH] fstests: generic: Test reserved extent map search
 routine on deduped file
Message-ID: <20160512050118.GC6648@birch.djwong.org>
References: <1463028695-7806-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463028695-7806-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2016 at 12:51:35PM +0800, Qu Wenruo wrote:
> For fully dedupe file, which means all its file exntents are pointing to
> the same bytenr, btrfs can cause soft lockup when calling fiemap ioctl
> on that file, like the following output:
> ------
> CPU: 1 PID: 7500 Comm: xfs_io Not tainted 4.5.0-rc6+ #2
> Hardware name: XXXXXXXXXXXXXXXXXXXXXXXXXXX
> task: ffff880027681b40 ti: ffff8800276e0000 task.ti: ffff8800276e0000
> RIP: 0010:[<ffffffffa02583e4>]  [<ffffffffa02583e4>]
> __merge_refs+0x34/0x120 [btrfs]
> RSP: 0018:ffff8800276e3c08  EFLAGS: 00000202
> RAX: ffff8800269cc330 RBX: ffff8800269cdb18 RCX: 0000000000000007
> RDX: 00000000000061b0 RSI: ffff8800269cc4c8 RDI: ffff8800276e3c88
> RBP: ffff8800276e3c20 R08: 0000000000000000 R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff880026ea3cb0
> R13: ffff8800276e3c88 R14: ffff880027132a50 R15: ffff880027430000
> FS:  00007f10201df700(0000) GS:ffff88003fa00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f10201ec000 CR3: 0000000027603000 CR4: 00000000000406e0
> Stack:
>  0000000000000000 0000000000000000 0000000000000000 ffff8800276e3ce8
>  ffffffffa0259f38 0000000000000005 ffff8800274c6870 ffff8800274c7d88
>  0000000000c10000 0000000000000000 0000000000000001 0000000027431190
> Call Trace:
>  [<ffffffffa0259f38>] find_parent_nodes+0x448/0x740 [btrfs]
>  [<ffffffffa025a4f2>] btrfs_check_shared+0x102/0x1b0 [btrfs]
>  [<ffffffff811fdcad>] ? __might_fault+0x4d/0xa0
>  [<ffffffffa021899c>] extent_fiemap+0x2ac/0x550 [btrfs]
>  [<ffffffff811ce156>] ? __filemap_fdatawait_range+0x96/0x160
>  [<ffffffffa01f8ee0>] ? btrfs_get_extent+0xb30/0xb30 [btrfs]
>  [<ffffffffa01f5da5>] btrfs_fiemap+0x45/0x50 [btrfs]
>  [<ffffffff81246bb8>] do_vfs_ioctl+0x498/0x670
>  [<ffffffff81246e09>] SyS_ioctl+0x79/0x90
>  [<ffffffff8184e997>] entry_SYSCALL_64_fastpath+0x12/0x6f
> Code: 41 55 41 54 53 4c 8b 27 4c 39 e7 0f 84 e9 00 00 00 49 89 fd 49 8b
> 34 24 49 39 f5 48 8b 1e 75 17 e9 d5 00 00 00 49 39 dd 48 8b 03 <48> 89
> de 0f 84 b9 00 00 00 48 89 c3 8b 46 2c 41 39 44 24 2c 75
> ------
> 
> Also btrfs will return wrong flag for all these extents, they should
> have SHARED(0x2000) flag, while btrfs still consider them as exclusive
> extents.
> 
> On the other hand, with unmerged xfs reflink patches, xfs can handle it
> without problem, and for patched btrfs, it can also handle it well.
> 
> This test case will create a large fully deduped file to check if the fs
> can handle the fiemap ioctl and return correct SHARED flag for any fs
> which support reflink.
> 
> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  common/punch          | 17 +++++++++++
>  tests/generic/352     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/352.out |  5 ++++
>  tests/generic/group   |  1 +
>  4 files changed, 105 insertions(+)
>  create mode 100755 tests/generic/352
>  create mode 100644 tests/generic/352.out
> 
> diff --git a/common/punch b/common/punch
> index 43f04c2..44c6e1c 100644
> --- a/common/punch
> +++ b/common/punch
> @@ -218,6 +218,23 @@ _filter_fiemap()
>  	_coalesce_extents
>  }
>  
> +_filter_fiemap_flags()
> +{
> +	$AWK_PROG '
> +		$3 ~ /hole/ {
> +			print $1, $2, $3;
> +			next;
> +		}
> +		$5 ~ /0x[[:xdigit:]]*8[[:xdigit:]][[:xdigit:]]/ {
> +			print $1, $2, "unwritten";
> +			next;
> +		}
> +		$5 ~ /0x[[:xdigit:]]+/ {
> +			print $1, $2, $5;
> +		}' |
> +	_coalesce_extents
> +}
> +
>  # Filters fiemap output to only print the 
>  # file offset column and whether or not
>  # it is an extent or a hole
> diff --git a/tests/generic/352 b/tests/generic/352
> new file mode 100755
> index 0000000..83f24ec
> --- /dev/null
> +++ b/tests/generic/352
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# FS QA Test 352
> +#
> +# Test fiemap ioctl on heavily deduped file
> +#
> +# This test case will check if extent backref search goes
> +# without problem and return correct SHARED flag.
> +# Which btrfs will soft lock up and return wrong shared flag.
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
> +. ./common/punch
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch_reflink
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +nr=$((8192 * $LOAD_FACTOR))
> +blocksize=$((128 * 1024))
> +file="$SCRATCH_MNT/tmp"
> +
> +# write the initial block for later reflink
> +$XFS_IO_PROG -f -c "pwrite 0 $blocksize" -c "fsync" $file | _filter_xfs_io
> +
> +# use reflink to create the rest of the file, whose all extents are all
> +# pointing to the first extent
> +for i in $(seq 1 $nr); do
> +	$XFS_IO_PROG -c "reflink $file 0 $(($i * $blocksize)) $blocksize" \
> +		$file > /dev/null

FYI, there's a _reflink_range helper for this now.

(There's also a _pwrite_byte helper.)

> +done
> +
> +# then call fiemap on that file to test both the shared flag and if
> +# reserved extent mapping search will cause soft lockup
> +$XFS_IO_PROG -c "fiemap -v" $file | _filter_fiemap_flags

I think this test needs _require_fiemap or else it'll fail on things
that don't support fiemap, like NFS.

PS: How well does btrfs handle generic/17[56]?

--D

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/352.out b/tests/generic/352.out
> new file mode 100644
> index 0000000..a87c507
> --- /dev/null
> +++ b/tests/generic/352.out
> @@ -0,0 +1,5 @@
> +QA output created by 352
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +0: [0..2097151]: 0x2000
> +1: [2097152..2097407]: 0x2001
> diff --git a/tests/generic/group b/tests/generic/group
> index 36fb759..3f00386 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -354,3 +354,4 @@
>  349 blockdev quick rw
>  350 blockdev quick rw
>  351 blockdev quick rw
> +352 auto clone
> -- 
> 2.8.2
> 
> 
> 
