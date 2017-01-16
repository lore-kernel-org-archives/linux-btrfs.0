Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbdAPEbC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 23:31:02 -0500
Date: Mon, 16 Jan 2017 12:30:59 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: splitted large dio write could trigger
 assertion on btrfs
Message-ID: <20170116043059.GD1859@eguan.usersys.redhat.com>
References: <1484259726-3561-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484259726-3561-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2017 at 02:22:06PM -0800, Liu Bo wrote:
> On btrfs, if a large dio write (>=128MB) got splitted, the outstanding_extents
> assertion would complain.  Note that CONFIG_BTRFS_ASSERT is required.
> 
> Regression test for
>   Btrfs: adjust outstanding_extents counter properly when dio write is split
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> I didn't figure out how to check if CONFIG_BTRFS_ASSERT is enabled, but since
> there is no btrfs specific stuff in the test case, it might be better to not
> have such a _require check b/c it doesn't make sense to other FS.
> 
>  tests/generic/392     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/392.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 78 insertions(+)
>  create mode 100755 tests/generic/392
>  create mode 100644 tests/generic/392.out

There're over 400 generic tests now, seems your repo hasn't been updated
for a long time :)

> 
> diff --git a/tests/generic/392 b/tests/generic/392
> new file mode 100755
> index 0000000..4d88c44
> --- /dev/null
> +++ b/tests/generic/392
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# FS QA Test generic/392
> +#
> +# If a larger dio write (size >= 128M) got splitted, the assertion in endio
> +# would complain (CONFIG_BTRFS_ASSERT is required).
> +#
> +# Regression test for
> +#   Btrfs: adjust outstanding_extents counter properly when dio write is split
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
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
> +_supported_os Linux
> +_require_scratch
> +_require_odirect
> +
> +# 2G / 1K
> +fsblock=$((1 << 21))
> +fssize=$((1 << 31))
> +_require_fs_space $SCRATCH_MNT $fsblock

You should mkfs & mount $SCRATCH_DEV first before _require_fs_space,
otherwise it's testing against the wrong fs.

> +
> +_scratch_mkfs_sized $fssize >> $seqres.full 2>&1

_scratch_mkfs_sized also make sure SCRATCH_DEV is big enough to make the
filesystem, in this test _require_fs_space and _scratch_mkfs_sized both
could do the work, only one is needed.

But not all filesystems have _scratch_mkfs_sized support, I'd prefer
using _require_fs_space.

Thanks,
Eryu

> +_scratch_mount >> $seqres.full 2>&1
> +
> +echo "Silence is golden"
> +
> +blocksize=$(( (128 + 1) * 2 * 1024 * 1024))
> +$XFS_IO_PROG -f -d -c "pwrite -b ${blocksize} 0 ${blocksize}" $SCRATCH_MNT/testfile.$seq >> $seqres.full 2>&1
> +
> +_scratch_unmount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/392.out b/tests/generic/392.out
> new file mode 100644
> index 0000000..665233c
> --- /dev/null
> +++ b/tests/generic/392.out
> @@ -0,0 +1,2 @@
> +QA output created by 392
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 2c16bd1..1631933 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -394,3 +394,4 @@
>  389 auto quick acl
>  390 auto freeze stress dangerous
>  391 auto quick rw
> +392 auto quick dangerous
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
