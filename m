Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34991 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400AbbJHJjt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 05:39:49 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1444230527-4639-1-git-send-email-jmaggard@netgear.com>
References: <1444230527-4639-1-git-send-email-jmaggard@netgear.com>
Date: Thu, 8 Oct 2015 10:39:48 +0100
Message-ID: <CAL3q7H72PVQRXrWhT=uZcww2K+Y7-bZE5u5K4OMnz-FAKT3-ZA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: test unmount during quota rescan
From: Filipe Manana <fdmanana@gmail.com>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Justin Maggard <jmaggard@netgear.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 7, 2015 at 4:08 PM, Justin Maggard <jmaggard10@gmail.com> wrote:
> This test case tests if we are able to unmount a filesystem while
> a quota rescan is running.  Up to now (4.3-rc4) this would result
> in a kernel NULL pointer dereference.

Please mention here the title of the patch that fixes this problem
("btrfs: qgroup: exit the rescan worker during umount").

>
> Signed-off-by: Justin Maggard <jmaggard@netgear.com>
> ---
>  tests/btrfs/104     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/104.out |  1 +
>  tests/btrfs/group   |  1 +
>  3 files changed, 87 insertions(+)
>  create mode 100755 tests/btrfs/104
>  create mode 100644 tests/btrfs/104.out
>
> diff --git a/tests/btrfs/104 b/tests/btrfs/104
> new file mode 100755
> index 0000000..7c51298
> --- /dev/null
> +++ b/tests/btrfs/104
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/200

104 (should match the file name)

> +#
> +# btrfs quota scan/unmount sanity test
> +#
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 NETGEAR, Inc.  All Rights Reserved.
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
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +
> +status=1       # failure is the default!
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +       $UMOUNT_PROG $loop_mnt >/dev/null 2>&1
> +       _destroy_loop_device $loop_dev1
> +       rm -rf $loop_mnt
> +       rm -f $fs_img1
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_test
> +
> +rm -f $seqres.full
> +
> +loop_mnt=$TEST_DIR/$seq.$$.mnt
> +fs_img1=$TEST_DIR/$seq.$$.img1
> +mkdir $loop_mnt
> +$XFS_IO_PROG -f -c "truncate 1G" $fs_img1 >>$seqres.full 2>&1

Don't redirect stdout/stderr here. If the truncate fails, xfs_io
prints something to stderr, resulting in a test failure due to
mismatch with the golden output.

> +
> +loop_dev1=`_create_loop_device $fs_img1`
> +
> +_mkfs_dev $loop_dev1 >>$seqres.full 2>&1
> +_mount $loop_dev1 $loop_mnt

Any reason to use a loop device on not the scratch device as most
other tests do?

> +for i in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p
> +do
> +  for j in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p

Coding style in xfstests is:

for ... ; do
done

Also use 8 spaces tabs for indentation.

> +  do
> +    for k in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p
> +    do
> +      for l in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p
> +      do
> +       touch $loop_mnt/${i}${j}${k}${l}
> +      done
> +    done
> +  done
> +done >>$seqres.full 2>&1
> +echo 3 > /proc/sys/vm/drop_caches
> +$BTRFS_UTIL_PROG quota enable $loop_mnt
> +$UMOUNT_PROG $loop_mnt
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/104.out b/tests/btrfs/104.out
> new file mode 100644
> index 0000000..1ed84bc
> --- /dev/null
> +++ b/tests/btrfs/104.out
> @@ -0,0 +1 @@
> +QA output created by 104
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index e92a65a..6218adf 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -106,3 +106,4 @@
>  101 auto quick replace
>  102 auto quick metadata enospc
>  103 auto quick clone compress
> +104 auto qgroup
> --
> 2.6.1
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
