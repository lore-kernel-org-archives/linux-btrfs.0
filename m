Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35007 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbHQJSL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 05:18:11 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1439791637-6517-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1439791637-6517-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Mon, 17 Aug 2015 10:18:09 +0100
Message-ID: <CAL3q7H54dxHnwsA3+DaHEOBL2DGoU1BwJTMweD3pcQyovM9E3w@mail.gmail.com>
Subject: Re: [PATCH v2] fstests: btrfs: Add reserved space leak check for
 rewrite dirty page
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 17, 2015 at 7:07 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Btrfs qgroup reserve codes lacks check for rewriting dirty page, causing
> every write, even rewriting a uncommitted dirty page, to reserve space.
>
> But only written data will free the reserved space, resulting reserved
> space leaking.
>
> The bug exists almost from the beginning of btrfs qgroup codes, but
> nobody found it.
>
> For example:
>
> 1)Write [0, 12K) into file A
>   reserve 12K space
>
> File A:
> 0       4K      8K      12K
> |<--------dirty-------->|
> reserved: 12K
>
> 2)Write [0,4K) into file A
> 0       4K      8K      12K
> |<--------dirty-------->|
> reserved: 16K <<< Should be 12K
>
> 3) Commit transaction
> Dirty pages [0,12) written to disk.
> Free 12K reserved space.
> reserved: 4K <<< Should be 0
>
> This testcase will test such problem.
> Kernel fix will need some huge change, so won't be soon.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks for doing this Qu.
Just a few comments inlined below.

> ---
> changelog:
> v2:
>   Reduce write size inside loop to ensure even commit happens, we can still
>   continue write.
> ---
>  tests/btrfs/089     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/089.out | 13 ++++++++
>  tests/btrfs/group   |  1 +
>  3 files changed, 99 insertions(+)
>  create mode 100755 tests/btrfs/089
>  create mode 100644 tests/btrfs/089.out
>
> diff --git a/tests/btrfs/089 b/tests/btrfs/089
> new file mode 100755
> index 0000000..d521910
> --- /dev/null
> +++ b/tests/btrfs/089
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# FS QA Test 089
> +#
> +# Check for btrfs reserved space leaking caused by overlap dirty range.

No mention of qgroups here. Re-phrasing it as "Check for qgroup
reserved space leaks caused by re-writing dirty ranges." would make it
more clear imho.

> +# This problem exists almost from qgroup function.

Confusing phrase. Function = implementation? Almost = always? Perhaps
we don't need this phrase at all, or just say it's a bug that's been
present in many implementations of btrfs' qgroup feature and for a
long time.

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Fujitsu. All Rights Reserved.
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
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_need_to_be_root
> +
> +# Use big blocksize to ensure there is still enough space left for metadata
> +# space reserve.
> +BLOCKSIZE=$(( 2 * 1024 * 1024 )) # 2M block size
> +FILESIZE=$(( 128 * 1024 * 1024 )) # 128M file size
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +_require_fs_space $SCRATCH_MNT $(($FILESIZE * 2 / 1024))
> +
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog qgroup limit $FILESIZE 5 $SCRATCH_MNT
> +
> +# loop 5 times without sync to ensure reserved space leak will happen
> +for i in `seq 1 5`; do
> +       # Use 1/4 of the file size, to ensure even commit is trigger by
> +       # dirty page threshold or commit interval, we should still be
> +       # able to continue write
> +       $XFS_IO_PROG -f -c "pwrite -b $BLOCKSIZE 0 $(($FILESIZE / 4))" \
> +               $SCRATCH_MNT/foo | _filter_xfs_io
> +done
> +
> +# remove the file and sync, to ensure all space freed

This comment feels like it should go to above the call to "rm", and
here a small explanation of why we do "sync" before calling "rm"
wouldn't hurt (not everyone is too familiar with the qgroups
implementation and knows that it frees space reservation at
transaction commit time).

> +sync
> +# error shouldn't happen, as BLOCKSIZE is large enough for metdata cow
> +rm $SCRATCH_MNT/foo || _fail "reserved space leak detected"

Why do we need || _fail ...? If rm fails it prints an error message to
stderr which makes the test fail.

> +sync
> +
> +# We should be able to write $FILESIZE - $BLOCKSIZE data
> +$XFS_IO_PROG -f -c "pwrite -b $BLOCKSIZE 0 $(($FILESIZE - $BLOCKSIZE))" \
> +       $SCRATCH_MNT/foo | _filter_xfs_io
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/089.out b/tests/btrfs/089.out
> new file mode 100644
> index 0000000..642bede
> --- /dev/null
> +++ b/tests/btrfs/089.out
> @@ -0,0 +1,13 @@
> +QA output created by 089
> +wrote 33554432/33554432 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 33554432/33554432 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 33554432/33554432 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 33554432/33554432 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 33554432/33554432 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 132120576/132120576 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index ffe18bf..da37e46 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -91,6 +91,7 @@
>  086 auto quick clone
>  087 auto quick send
>  088 auto quick metadata
> +089 auto quick qgroup
>  090 auto quick metadata
>  091 auto quick qgroup
>  092 auto quick send
> --
> 1.8.3.1
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
