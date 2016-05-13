Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21766 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbcEMFSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 01:18:07 -0400
Date: Thu, 12 May 2016 22:17:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: Test SHARED flag about fiemap ioctl
 before and after sync
Message-ID: <20160513051751.GB6621@birch.djwong.org>
References: <1463104372-10533-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463104372-10533-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2016 at 09:52:52AM +0800, Qu Wenruo wrote:
> The test case will check SHARED flag returned by fiemap ioctl on
> reflinked files before and after sync.
> 
> Normally SHARED flag won't change just due to a normal sync operation.
> 
> But btrfs doesn't handle SHARED flag well, and this time it won't check
> any delayed extent tree(reverse extent searching tree) modification, but
> only metadata already committed to disk.
> 
> So btrfs will not return correct SHARED flag on reflinked files if there
> is no sync to commit all metadata.
> 
> This testcase will just check it.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ------
> And of course, xfs handles it quite well. Nice work Darrick.
> Also the test case needs the new infrastructure introduced in previous
> generic/352 test case.
> ---
>  tests/generic/353     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/353.out |  9 ++++++
>  tests/generic/group   |  1 +
>  3 files changed, 96 insertions(+)
>  create mode 100755 tests/generic/353
>  create mode 100644 tests/generic/353.out
> 
> diff --git a/tests/generic/353 b/tests/generic/353
> new file mode 100755
> index 0000000..1e9117e
> --- /dev/null
> +++ b/tests/generic/353
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# FS QA Test 353
> +#
> +# Check if fiemap ioctl returns correct SHARED flag on reflinked file
> +# before and after sync the fs
> +#
> +# Btrfs has a bug in checking shared extent, which can only handle metadata
> +# already committed to disk, but not delayed extent tree modification.
> +# This caused SHARED flag only occurs after sync.

I noticed this a while ago, but figured it was just btrfs being btrfs.  Ho hum.

Thanks for writing a test and getting the problem fixed.

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Fujitsu. All Rights Reserved.
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

tmp isn't used for anything in this testcase.

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
> +_require_fiemap
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +blocksize=64k
> +file1="$SCRATCH_MNT/file1"
> +file2="$SCRATCH_MNT/file2"
> +
> +# write the initial file
> +_pwrite_byte 0xcdcdcdcd 0 $blocksize $file1 | _filter_xfs_io
> +
> +# reflink initial file
> +_reflink_range $file1 0 $file2 0 $blocksize | _filter_xfs_io
> +
> +# check their fiemap to make sure it's correct
> +$XFS_IO_PROG -c "fiemap -v" $file1 | _filter_fiemap_flags
> +$XFS_IO_PROG -c "fiemap -v" $file2 | _filter_fiemap_flags
> +
> +# sync and recheck, to make sure the fiemap doesn't change just
> +# due to sync
> +sync
> +$XFS_IO_PROG -c "fiemap -v" $file1 | _filter_fiemap_flags
> +$XFS_IO_PROG -c "fiemap -v" $file2 | _filter_fiemap_flags

Nowadays, when I write a test that prints similar output one after the other I
will also write a comment to the output to distinguish the two cases, e.g.:

+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
fiemap before sync
+0: [0..127]: 0x2001
+0: [0..127]: 0x2001
fiemap after sync
+0: [0..127]: 0x2001
+0: [0..127]: 0x2001

This way when a bunch of tests regress some months later it's easier
for me to relearn what's going on.

(I wasn't always good at doing that.)

Otherwise, everything looks ok.

--D

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/353.out b/tests/generic/353.out
> new file mode 100644
> index 0000000..0cd8981
> --- /dev/null
> +++ b/tests/generic/353.out
> @@ -0,0 +1,9 @@
> +QA output created by 353
> +wrote 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +linked 65536/65536 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +0: [0..127]: 0x2001
> +0: [0..127]: 0x2001
> +0: [0..127]: 0x2001
> +0: [0..127]: 0x2001
> diff --git a/tests/generic/group b/tests/generic/group
> index 3f00386..0392d4d 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -355,3 +355,4 @@
>  350 blockdev quick rw
>  351 blockdev quick rw
>  352 auto clone
> +353 auto quick clone
> -- 
> 2.5.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
