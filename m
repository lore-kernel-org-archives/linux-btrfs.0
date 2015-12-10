Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34704 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbbLJRZt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 12:25:49 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1448878620-16382-6-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
	<1448878620-16382-6-git-send-email-chandan@linux.vnet.ibm.com>
Date: Thu, 10 Dec 2015 17:25:48 +0000
Message-ID: <CAL3q7H6b0wn-ZVgd5asJBD60OORgpijs0h-vkCr+cUKnTQ+DRw@mail.gmail.com>
Subject: Re: [PATCH V2 5/5] Fix btrfs/096 to work on non-4k block sized filesystems
From: Filipe Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 10:17 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit makes use of the new _filter_xfs_io_blocks_modified filtering
> function to print information in terms of file blocks rather than file
> offset.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks!

> ---
>  tests/btrfs/096     | 45 +++++++++++++++++++++++++--------------------
>  tests/btrfs/096.out | 15 +++++----------
>  2 files changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/tests/btrfs/096 b/tests/btrfs/096
> index f5b3a7f..896a209 100755
> --- a/tests/btrfs/096
> +++ b/tests/btrfs/096
> @@ -51,30 +51,35 @@ rm -f $seqres.full
>  _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount
>
> -# Create our test files. File foo has the same 2K of data at offset 4K as file
> -# bar has at its offset 0.
> -$XFS_IO_PROG -f -s -c "pwrite -S 0xaa 0 4K" \
> -               -c "pwrite -S 0xbb 4k 2K" \
> -               -c "pwrite -S 0xcc 8K 4K" \
> -               $SCRATCH_MNT/foo | _filter_xfs_io
> +BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
>
> -# File bar consists of a single inline extent (2K size).
> -$XFS_IO_PROG -f -s -c "pwrite -S 0xbb 0 2K" \
> -               $SCRATCH_MNT/bar | _filter_xfs_io
> +# Create our test files. File foo has the same 2k of data at offset $BLOCK_SIZE
> +# as file bar has at its offset 0.
> +$XFS_IO_PROG -f -s -c "pwrite -S 0xaa 0 $BLOCK_SIZE" \
> +               -c "pwrite -S 0xbb $BLOCK_SIZE 2k" \
> +               -c "pwrite -S 0xcc $(($BLOCK_SIZE * 2)) $BLOCK_SIZE" \
> +               $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
>
> -# Now call the clone ioctl to clone the extent of file bar into file foo at its
> -# offset 4K. This made file foo have an inline extent at offset 4K, something
> -# which the btrfs code can not deal with in future IO operations because all
> -# inline extents are supposed to start at an offset of 0, resulting in all sorts
> -# of chaos.
> -# So here we validate that the clone ioctl returns an EOPNOTSUPP, which is what
> -# it returns for other cases dealing with inlined extents.
> -$CLONER_PROG -s 0 -d $((4 * 1024)) -l $((2 * 1024)) \
> +# File bar consists of a single inline extent (2k in size).
> +$XFS_IO_PROG -f -s -c "pwrite -S 0xbb 0 2k" \
> +               $SCRATCH_MNT/bar | _filter_xfs_io_blocks_modified
> +
> +# Now call the clone ioctl to clone the extent of file bar into file
> +# foo at its $BLOCK_SIZE offset. This made file foo have an inline
> +# extent at offset $BLOCK_SIZE, something which the btrfs code can not
> +# deal with in future IO operations because all inline extents are
> +# supposed to start at an offset of 0, resulting in all sorts of
> +# chaos.
> +# So here we validate that the clone ioctl returns an EOPNOTSUPP,
> +# which is what it returns for other cases dealing with inlined
> +# extents.
> +$CLONER_PROG -s 0 -d $BLOCK_SIZE -l 2048 \
>         $SCRATCH_MNT/bar $SCRATCH_MNT/foo
>
> -# Because of the inline extent at offset 4K, the following write made the kernel
> -# crash with a BUG_ON().
> -$XFS_IO_PROG -c "pwrite -S 0xdd 6K 2K" $SCRATCH_MNT/foo | _filter_xfs_io
> +# Because of the inline extent at offset $BLOCK_SIZE, the following
> +# write made the kernel crash with a BUG_ON().
> +$XFS_IO_PROG -c "pwrite -S 0xdd $(($BLOCK_SIZE + 2048)) 2k" \
> +            $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
>
>  status=0
>  exit
> diff --git a/tests/btrfs/096.out b/tests/btrfs/096.out
> index 235198d..2a4251e 100644
> --- a/tests/btrfs/096.out
> +++ b/tests/btrfs/096.out
> @@ -1,12 +1,7 @@
>  QA output created by 096
> -wrote 4096/4096 bytes at offset 0
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 2048/2048 bytes at offset 4096
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 4096/4096 bytes at offset 8192
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 2048/2048 bytes at offset 0
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Blocks modified: [0 - 0]
> +Blocks modified: [1 - 1]
> +Blocks modified: [2 - 2]
> +Blocks modified: [0 - 0]
>  clone failed: Operation not supported
> -wrote 2048/2048 bytes at offset 6144
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Blocks modified: [1 - 1]
> --
> 2.1.0
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
