Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33976 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbbLJRZH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 12:25:07 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1448878620-16382-3-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
	<1448878620-16382-3-git-send-email-chandan@linux.vnet.ibm.com>
Date: Thu, 10 Dec 2015 17:25:06 +0000
Message-ID: <CAL3q7H6yWY6BuWs8-w6vbWgPJWjg97tkgwwhs+k-J1POAQPGPw@mail.gmail.com>
Subject: Re: [PATCH V2 2/5] Fix btrfs/017 to work on non-4k block sized filesystems
From: Filipe Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 10:16 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit makes use of the new _filter_xfs_io_blocks_modified filtering
> function to print information in terms of file blocks rather than file
> offset.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks!

> ---
>  tests/btrfs/017     | 16 ++++++++++++----
>  tests/btrfs/017.out |  3 +--
>  2 files changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/tests/btrfs/017 b/tests/btrfs/017
> index f8855e3..34c5f0a 100755
> --- a/tests/btrfs/017
> +++ b/tests/btrfs/017
> @@ -63,13 +63,21 @@ rm -f $seqres.full
>  _scratch_mkfs "--nodesize 65536" >>$seqres.full 2>&1
>  _scratch_mount
>
> -$XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo | _filter_xfs_io
> +BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
> +EXTENT_SIZE=$((2 * $BLOCK_SIZE))
> +
> +$XFS_IO_PROG -f -d -c "pwrite 0 $EXTENT_SIZE" $SCRATCH_MNT/foo \
> +       | _filter_xfs_io_blocks_modified
>
>  _run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
>
> -$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
> -$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink
> -$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink2
> +$CLONER_PROG -s 0 -d 0 -l $EXTENT_SIZE $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
> +
> +$CLONER_PROG -s 0 -d 0 -l $EXTENT_SIZE $SCRATCH_MNT/foo \
> +            $SCRATCH_MNT/snap/foo-reflink
> +
> +$CLONER_PROG -s 0 -d 0 -l $EXTENT_SIZE $SCRATCH_MNT/foo \
> +            $SCRATCH_MNT/snap/foo-reflink2
>
>  _run_btrfs_util_prog quota enable $SCRATCH_MNT
>  _run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> diff --git a/tests/btrfs/017.out b/tests/btrfs/017.out
> index f940f3a..503eb88 100644
> --- a/tests/btrfs/017.out
> +++ b/tests/btrfs/017.out
> @@ -1,5 +1,4 @@
>  QA output created by 017
> -wrote 8192/8192 bytes at offset 0
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Blocks modified: [0 - 1]
>  65536 65536
>  65536 65536
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
