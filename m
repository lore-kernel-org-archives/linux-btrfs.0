Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34239 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbCSSPx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 14:15:53 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1425230409-22366-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1425230409-22366-1-git-send-email-chandan@linux.vnet.ibm.com>
Date: Thu, 19 Mar 2015 18:15:52 +0000
Message-ID: <CAL3q7H5kBoYxR65oFO25wYZpEePivaR3ZYax0KS0bCt3fNtMgg@mail.gmail.com>
Subject: Re: [PATCH] btrfs/052: Fix test case to work on 64K block size.
From: Filipe David Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 1, 2015 at 5:20 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> The test case passes file offsets which don't align with 64K block size. This
> causes btrfs_ioctl_clone() to return with -EINVAL. Fix this by using offsets
> which are multiples of 64k.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Filipe Manana <fdmanana@suse.com>

Thanks for this.

> ---
>  tests/btrfs/052     |  71 ++++----
>  tests/btrfs/052.out | 468 ++++++++++++++++++++++++++--------------------------
>  2 files changed, 272 insertions(+), 267 deletions(-)
>
> diff --git a/tests/btrfs/052 b/tests/btrfs/052
> index c75193d..462f9ce 100755
> --- a/tests/btrfs/052
> +++ b/tests/btrfs/052
> @@ -59,70 +59,75 @@ test_btrfs_clone_same_file()
>         _scratch_mkfs >/dev/null 2>&1
>         _scratch_mount $MOUNT_OPTIONS
>
> -       # Create a file with 5 extents, 4 of 8Kb each and 1 of 64Kb.
> -       $XFS_IO_PROG -f -c "pwrite -S 0x01 -b 8192 0 8192" $SCRATCH_MNT/foo \
> -               | _filter_xfs_io
> +       # Create a file with 5 extents, 4 of 128Kb each and 1 of 1024Kb.
> +       $XFS_IO_PROG -f -c "pwrite -S 0x01 -b 131072 0 131072" \
> +                    $SCRATCH_MNT/foo | _filter_xfs_io
>         sync
> -       $XFS_IO_PROG -c "pwrite -S 0x02 -b 8192 8192 8192" $SCRATCH_MNT/foo \
> -               | _filter_xfs_io
> +
> +       $XFS_IO_PROG -c "pwrite -S 0x02 -b 131072 131072 131072" \
> +                    $SCRATCH_MNT/foo | _filter_xfs_io
>         sync
> -       $XFS_IO_PROG -c "pwrite -S 0x03 -b 8192 16384 8192" $SCRATCH_MNT/foo \
> -               | _filter_xfs_io
> +
> +       $XFS_IO_PROG -c "pwrite -S 0x03 -b 131072 262144 131072" \
> +                    $SCRATCH_MNT/foo | _filter_xfs_io
>         sync
> -       $XFS_IO_PROG -c "pwrite -S 0x04 -b 8192 24576 8192" $SCRATCH_MNT/foo \
> -               | _filter_xfs_io
> +
> +       $XFS_IO_PROG -c "pwrite -S 0x04 -b 131072 393216 131072" \
> +                    $SCRATCH_MNT/foo | _filter_xfs_io
>         sync
> -       $XFS_IO_PROG -c "pwrite -S 0x05 -b 65536 32768 65536" $SCRATCH_MNT/foo \
> -               | _filter_xfs_io
> +
> +       $XFS_IO_PROG -c "pwrite -S 0x05 -b 131072 524288 1048576" \
> +                    $SCRATCH_MNT/foo | _filter_xfs_io
>         sync
>
>         # Digest of initial content.
>         md5sum $SCRATCH_MNT/foo | _filter_scratch
>
>         # Same source and target ranges - must fail.
> -       $CLONER_PROG -s 8192 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
> +       $CLONER_PROG -s 131072 -d 131072 -l 131072 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
>         # Check file content didn't change.
>         md5sum $SCRATCH_MNT/foo | _filter_scratch
>
>         # Intersection between source and target ranges - must fail too.
> -       $CLONER_PROG -s 4096 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
> +       $CLONER_PROG -s 65536 -d 131072 -l 131072 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
>         # Check file content didn't change.
>         md5sum $SCRATCH_MNT/foo | _filter_scratch
>
>         # Clone an entire extent from a higher range to a lower range.
> -       $CLONER_PROG -s 24576 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
> +       $CLONER_PROG -s 393216 -d 0 -l 131072 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
>
> -       # Check entire file, the 8Kb block at offset 0 now has the same content
> -       # as the 8Kb block at offset 24576.
> +       # Check entire file, the 128Kb block at offset 0 now has the same content
> +       # as the 128Kb block at offset 393216.
>         od -t x1 $SCRATCH_MNT/foo
>
>         # Clone an entire extent from a lower range to a higher range.
> -       $CLONER_PROG -s 8192 -d 16384 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
> +       $CLONER_PROG -s 131072 -d 262144 -l 131072 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
>
> -       # Check entire file, the 8Kb block at offset 0 now has the same content
> -       # as the 8Kb block at offset 24576, and the 8Kb block at offset 16384
> -       # now has the same content as the 8Kb block at offset 8192.
> +       # Check entire file, the 128Kb block at offset 0 now has the same content
> +       # as the 128Kb block at offset 393216, and the 128Kb block at offset 262144
> +       # now has the same content as the 128Kb block at offset 131072.
>         od -t x1 $SCRATCH_MNT/foo
>
>         # Now clone 1 extent and an half into the file range starting at offset
> -       # 65536. So we get the second half of the extent at offset 16384 and the
> -       # whole extent at 24576 cloned into the middle of the 64Kb extent that
> -       # starts at file offset 32768. This makes the clone ioctl process more
> -       # extent items from the b+tree and forces a split of the large 64Kb
> -       # extent at the end of the file.
> -       $CLONER_PROG -s 20480 -d 65536 -l 12288 $SCRATCH_MNT/foo \
> +       # 1048576. So we get the second half of the extent at offset 262144 and
> +       # the whole extent at 393216 cloned into the middle of the 1024Kb extent
> +       # that starts at file offset 524288. This makes the clone ioctl process
> +       # more extent items from the b+tree and forces a split of the large
> +       # 1024Kb extent at the end of the file.
> +       $CLONER_PROG -s 327680 -d 1048576 -l 196608 $SCRATCH_MNT/foo \
>                 $SCRATCH_MNT/foo
>
>         # Check entire file. Besides the previous changes, we now should have
> -       # 4096 bytes with the value 0x02 at file offset 65536, and 8192 bytes
> -       # with value 0x04 at the file offset 69632. The ranges [32768, 65536[
> -       # and [77824, 98304[ should remain with all bytes having the value 0x05.
> +       # 65536 bytes with the value 0x02 at file offset 1048576, and 131072
> +       # bytes with value 0x04 at the file offset 1114112. The ranges
> +       # [524288, 1048576[ and [1245184, 1572864[ should remain with all bytes
> +       # having the value 0x05.
>         od -t x1 $SCRATCH_MNT/foo
>
> -       # Now update 8Kb of data at offset 0. The extent at this position is a
> -       # clone of the extent at offset 24576. Check that writing to this offset
> -       # doesn't change data at offset 24576.
> -       $XFS_IO_PROG -c "pwrite -S 0xff -b 8192 0 8192" $SCRATCH_MNT/foo \
> +       # Now update 128Kb of data at offset 0. The extent at this position is a
> +       # clone of the extent at offset 393216. Check that writing to this
> +       # offset doesn't change data at offset 393216.
> +       $XFS_IO_PROG -c "pwrite -S 0xff -b 131072 0 131072" $SCRATCH_MNT/foo \
>                 | _filter_xfs_io
>         od -t x1 $SCRATCH_MNT/foo
>
> diff --git a/tests/btrfs/052.out b/tests/btrfs/052.out
> index 53a1868..d5c11ac 100644
> --- a/tests/btrfs/052.out
> +++ b/tests/btrfs/052.out
> @@ -1,499 +1,499 @@
>  QA output created by 052
>  Testing with a cow file (default)
> -wrote 8192/8192 bytes at offset 0
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 8192
> +wrote 131072/131072 bytes at offset 131072
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 16384
> +wrote 131072/131072 bytes at offset 262144
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 24576
> +wrote 131072/131072 bytes at offset 393216
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 65536/65536 bytes at offset 32768
> +wrote 1048576/1048576 bytes at offset 524288
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
> +1000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> -wrote 8192/8192 bytes at offset 0
> +6000000
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  Testing with a nocow file (-O nodatacow)
> -wrote 8192/8192 bytes at offset 0
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 8192
> +wrote 131072/131072 bytes at offset 131072
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 16384
> +wrote 131072/131072 bytes at offset 262144
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 24576
> +wrote 131072/131072 bytes at offset 393216
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 65536/65536 bytes at offset 32768
> +wrote 1048576/1048576 bytes at offset 524288
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
> +1000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> -wrote 8192/8192 bytes at offset 0
> +6000000
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  Testing with a cow file and lzo compression
> -wrote 8192/8192 bytes at offset 0
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 8192
> +wrote 131072/131072 bytes at offset 131072
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 16384
> +wrote 131072/131072 bytes at offset 262144
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 24576
> +wrote 131072/131072 bytes at offset 393216
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 65536/65536 bytes at offset 32768
> +wrote 1048576/1048576 bytes at offset 524288
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
> +1000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> -wrote 8192/8192 bytes at offset 0
> +6000000
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  Testing with a cow file and zlib compression
> -wrote 8192/8192 bytes at offset 0
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 8192
> +wrote 131072/131072 bytes at offset 131072
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 16384
> +wrote 131072/131072 bytes at offset 262144
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 24576
> +wrote 131072/131072 bytes at offset 393216
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 65536/65536 bytes at offset 32768
> +wrote 1048576/1048576 bytes at offset 524288
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
> +1000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> -wrote 8192/8192 bytes at offset 0
> +6000000
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  Testing with a nocow file and lzo compression
> -wrote 8192/8192 bytes at offset 0
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 8192
> +wrote 131072/131072 bytes at offset 131072
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 16384
> +wrote 131072/131072 bytes at offset 262144
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 24576
> +wrote 131072/131072 bytes at offset 393216
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 65536/65536 bytes at offset 32768
> +wrote 1048576/1048576 bytes at offset 524288
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
> +1000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> -wrote 8192/8192 bytes at offset 0
> +6000000
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  Testing with a nocow file and zlib compression
> -wrote 8192/8192 bytes at offset 0
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 8192
> +wrote 131072/131072 bytes at offset 131072
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 16384
> +wrote 131072/131072 bytes at offset 262144
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 8192/8192 bytes at offset 24576
> +wrote 131072/131072 bytes at offset 393216
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 65536/65536 bytes at offset 32768
> +wrote 1048576/1048576 bytes at offset 524288
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  clone failed: Invalid argument
> -5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
> +4717a9cbd3150f6fd998927e8057860f  SCRATCH_MNT/foo
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
> +1000000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> -wrote 8192/8192 bytes at offset 0
> +6000000
> +wrote 131072/131072 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
>  0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  *
> -0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +0400000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +1400000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +2000000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
> +4000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>  *
> -0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
> +4200000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
>  *
> -0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
> +4600000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>  *
> -0300000
> +6000000
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
