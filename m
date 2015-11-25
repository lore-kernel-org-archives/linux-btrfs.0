Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35789 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbbKYLL2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:11:28 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1448449386-4186-7-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
	<1448449386-4186-7-git-send-email-chandan@linux.vnet.ibm.com>
Date: Wed, 25 Nov 2015 11:11:27 +0000
Message-ID: <CAL3q7H5W9LcoVx9MA9dOdGaeDiNYs1scDz3orN6FGjK+3Pgwog@mail.gmail.com>
Subject: Re: [PATCH 06/12] Fix btrfs/094 to work on non-4k block sized filesystems
From: Filipe Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 25, 2015 at 11:03 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit makes use of the new _filter_xfs_io_blocks_modified filtering
> function to print information in terms of file blocks rather than file
> offset.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  tests/btrfs/094     | 78 +++++++++++++++++++++++++++++++----------------------
>  tests/btrfs/094.out | 17 +++---------
>  2 files changed, 49 insertions(+), 46 deletions(-)
>
> diff --git a/tests/btrfs/094 b/tests/btrfs/094
> index 6f6cdeb..868c088 100755
> --- a/tests/btrfs/094
> +++ b/tests/btrfs/094
> @@ -67,36 +67,41 @@ mkdir $send_files_dir
>  _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount "-o compress"
>
> -# Create the file with a single extent of 128K. This creates a metadata file
> -# extent item with a data start offset of 0 and a logical length of 128K.
> -$XFS_IO_PROG -f -c "pwrite -S 0xaa 64K 128K" -c "fsync" \
> -       $SCRATCH_MNT/foo | _filter_xfs_io
> -
> -# Now rewrite the range 64K to 112K of our file. This will make the inode's
> -# metadata continue to point to the 128K extent we created before, but now
> -# with an extent item that points to the extent with a data start offset of
> -# 112K and a logical length of 16K.
> -# That metadata file extent item is associated with the logical file offset
> -# at 176K and covers the logical file range 176K to 192K.
> -$XFS_IO_PROG -c "pwrite -S 0xbb 64K 112K" -c "fsync" \
> -       $SCRATCH_MNT/foo | _filter_xfs_io
> -
> -# Now rewrite the range 180K to 12K. This will make the inode's metadata
> -# continue to point the the 128K extent we created earlier, with a single
> -# extent item that points to it with a start offset of 112K and a logical
> -# length of 4K.
> -# That metadata file extent item is associated with the logical file offset
> -# at 176K and covers the logical file range 176K to 180K.
> -$XFS_IO_PROG -c "pwrite -S 0xcc 180K 12K" -c "fsync" \
> -       $SCRATCH_MNT/foo | _filter_xfs_io
> +BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
> +
> +# Create the file with a single extent of 32 blocks. This creates a metadata
> +# file extent item with a data start offset of 0 and a logical length of
> +# 32 blocks.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa $((16 * $BLOCK_SIZE)) $((32 * $BLOCK_SIZE))" \
> +            -c "fsync" $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
> +
> +# Now rewrite the block range [16, 28[ of our file. This will make
> +# the inode's metadata continue to point to the single 32 block extent
> +# we created before, but now with an extent item that points to the
> +# extent with a data start offset referring to the 28th block and a
> +# logical length of 4 blocks.
> +# That metadata file extent item is associated with the block range
> +# [44, 48[.
> +$XFS_IO_PROG -c "pwrite -S 0xbb $((16 * $BLOCK_SIZE)) $((28 * $BLOCK_SIZE))" \
> +            -c "fsync" $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
> +
> +
> +# Now rewrite the block range [45, 48[. This will make the inode's
> +# metadata continue to point the 32 block extent we created earlier,
> +# with a single extent item that points to it with a start offset
> +# referring to the 28th block and a logical length of 1 block.
> +# That metadata file extent item is associated with the block range
> +# [44, 45[.
> +$XFS_IO_PROG -c "pwrite -S 0xcc $((45 * $BLOCK_SIZE)) $((3 * $BLOCK_SIZE))" \
> +            -c "fsync" $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
>
>  _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
>
> -# Now clone that same region of the 128K extent into a new file, so that it
> +# Now clone that same region of the 32 block extent into a new file, so that it
>  # gets referenced twice and the incremental send operation below decides to
>  # issue a clone operation instead of copying the data.
>  touch $SCRATCH_MNT/bar
> -$CLONER_PROG -s $((176 * 1024)) -d $((176 * 1024)) -l $((4 * 1024)) \
> +$CLONER_PROG -s $((44 * $BLOCK_SIZE)) -d $((44 * $BLOCK_SIZE)) -l $BLOCK_SIZE \
>         $SCRATCH_MNT/foo $SCRATCH_MNT/bar
>
>  _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
> @@ -105,10 +110,11 @@ _run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
>  _run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
>         -f $send_files_dir/2.snap
>
> -echo "File digests in the original filesystem:"
> -md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
> -md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> -md5sum $SCRATCH_MNT/mysnap2/bar | _filter_scratch
> +# echo "File digests in the original filesystem:"
> +declare -A src_fs_hash
> +src_fs_hash[mysnap1_foo]=$(md5sum $SCRATCH_MNT/mysnap1/foo | cut -f 1 -d ' ')
> +src_fs_hash[mysnap2_foo]=$(md5sum $SCRATCH_MNT/mysnap2/foo | cut -f 1 -d ' ')
> +src_fs_hash[mysnap2_bar]=$(md5sum $SCRATCH_MNT/mysnap2/bar | cut -f 1 -d ' ')
>
>  # Now recreate the filesystem by receiving both send streams and verify we get
>  # the same file contents that the original filesystem had.
> @@ -119,10 +125,18 @@ _scratch_mount
>  _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
>  _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
>
> -echo "File digests in the new filesystem:"
> -md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
> -md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
> -md5sum $SCRATCH_MNT/mysnap2/bar | _filter_scratch
> +# echo "File digests in the new filesystem:"
> +declare -A dst_fs_hash
> +dst_fs_hash[mysnap1_foo]=$(md5sum $SCRATCH_MNT/mysnap1/foo | cut -f 1 -d ' ')
> +dst_fs_hash[mysnap2_foo]=$(md5sum $SCRATCH_MNT/mysnap2/foo | cut -f 1 -d ' ')
> +dst_fs_hash[mysnap2_bar]=$(md5sum $SCRATCH_MNT/mysnap2/bar | cut -f 1 -d ' ')
> +
> +for key in "${!src_fs_hash[@]}"; do
> +       if [ ${src_fs_hash[$key]} != ${dst_fs_hash[$key]} ]; then
> +               echo "Mimatching hash value detected against \
> +$(echo $key | tr _ /)"
> +       fi
> +done
>
>  status=0
>  exit
> diff --git a/tests/btrfs/094.out b/tests/btrfs/094.out
> index c3ac1bf..fe26ea0 100644
> --- a/tests/btrfs/094.out
> +++ b/tests/btrfs/094.out
> @@ -1,15 +1,4 @@
>  QA output created by 094
> -wrote 131072/131072 bytes at offset 65536
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 114688/114688 bytes at offset 65536
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 12288/12288 bytes at offset 184320
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -File digests in the original filesystem:
> -f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap1/foo
> -f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap2/foo
> -7fccf6175f5c68504b408719a21db99f  SCRATCH_MNT/mysnap2/bar
> -File digests in the new filesystem:
> -f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap1/foo
> -f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap2/foo
> -7fccf6175f5c68504b408719a21db99f  SCRATCH_MNT/mysnap2/bar
> +Blocks modified: [16 - 47]
> +Blocks modified: [16 - 43]
> +Blocks modified: [45 - 47]

Hi Chandan,

I can't agree with this change. We're no longer checking that file
data is correct after the cloning operations. The md5sum checks were
exactly for that. So essentially the test is only verifying the clone
operations don't fail with errors, it no longer checks for data
corruption...

Same comment applies to at least a few other patches in the series.

> --
> 2.1.0
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
