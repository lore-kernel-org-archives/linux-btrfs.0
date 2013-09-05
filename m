Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33733 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab3IESoF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 14:44:05 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2E7A89A06BC
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 12:44:05 -0600 (MDT)
Date: Thu, 5 Sep 2013 14:44:02 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests btrfs/309: test btrfs-convert
Message-ID: <20130905184402.GE15634@localhost.localdomain>
References: <51FEB5AF.7060806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51FEB5AF.7060806@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 04, 2013 at 03:12:31PM -0500, Eric Sandeen wrote:
> Turns out btrfs-convert broke on July 3, and lo! we
> do not have a regression test, and now we have one,
> and there was much rejoicing.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/tests/btrfs/309 b/tests/btrfs/309
> new file mode 100755
> index 0000000..acb2d6d
> --- /dev/null
> +++ b/tests/btrfs/309
> @@ -0,0 +1,118 @@
> +#! /bin/bash
> +# FS QA Test No. 309
> +#
> +# Test btrfs-convert
> +#
> +# 1) create ext4 filesystem & populate it
> +# 2) convert it to btrfs, mount it, verify contents
> +# 3) verify archived ext4 image integriy & contents
> +# 4) populate btrfs fs with new data
> +# 5) roll back conversion to original ext4
> +# 6) verify rolled-back fs integrity & contents
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
> +echo "== QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter.btrfs
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
> +MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
> +E2FSCK_PROG="`set_prog_path e2fsck`"
> +
> +_require_command $BTRFS_CONVERT_PROG btrfs-convert
> +_require_command $MKFS_EXT4_PROG mkfs.ext4
> +_require_command $E2FSCK_PROG e2fsck
> +
> +rm -f $seqres.full
> +
> +# Create & populate an ext4 filesystem
> +$MKFS_EXT4_PROG -b 4096 $SCRATCH_DEV > $seqres.full 2>&1 || \
> +	_notrun "Could not create ext4 filesystem"
> +# Manual mount so we don't use -t btrfs or selinux context
> +mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
> +
> +cp -aR /lib/modules/`uname -r`/ $SCRATCH_MNT
> +_scratch_unmount
> +
> +# Convert it to btrfs, mount it, verify the data
> +$BTRFS_CONVERT_PROG $SCRATCH_DEV >> $seqres.full 2>&1 || \
> +	_fail "btrfs-convert failed"
> +_scratch_mount || _fail "Could not mount new btrfs fs"
> +# (Ignore the symlinks which may be broken/nonexistent)
> +diff -r /lib/modules/`uname -r`/ $SCRATCH_MNT/`uname -r`/ 2>&1 | grep -vw "source\|build"
> +
> +# Old ext4 image file should exist & be consistent
> +$E2FSCK_PROG -fn $SCRATCH_MNT/ext2_saved/image >> $seqres.full 2>&1 || \
> +	_fail "archived ext4 image is corrupt"
> +
> +# And the files in that image should match
> +mkdir -p $SCRATCH_MNT/mnt
> +mount -o loop $SCRATCH_MNT/ext2_saved/image $SCRATCH_MNT/mnt || \
> +	_fail "could not loop mount saved ext4 image"
> +# Ignore the symlinks which may be broken/nonexistent
> +diff -r /lib/modules/`uname -r`/ $SCRATCH_MNT/mnt/`uname -r`/ 2>&1 | grep -vw "source\|build"
> +umount $SCRATCH_MNT/mnt
> +
> +# Now put some fresh data on the btrfs fs
> +mkdir -p $SCRATCH_MNT/new 
> +cp -aR /lib/modules/`uname -r`/ $SCRATCH_MNT/new
> +
> +_scratch_unmount
> +
> +# Now restore the ext4 device
> +$BTRFS_CONVERT_PROG -r $SCRATCH_DEV >> $seqres.full 2>&1 || \
> +	_fail "btrfs-convert rollback failed"
> +
> +# Check it again
> +$E2FSCK_PROG -fn $SCRATCH_DEV >> $seqres.full 2>&1 || \
> +        _fail "restored ext4 image is corrupt"
> +
> +# Mount the un-converted ext4 device & check the contents
> +mount -t ext4 $SCRATCH_DEV $SCRATCH_MNT
> +# (Ignore the symlinks which may be broken/nonexistent)
> +diff -r /lib/modules/`uname -r`/ $SCRATCH_MNT/`uname -r`/ 2>&1 | grep -vw "source\|build"
> +
> +_scratch_unmount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/309.out b/tests/btrfs/309.out
> new file mode 100644
> index 0000000..2f5d4a9
> --- /dev/null
> +++ b/tests/btrfs/309.out
> @@ -0,0 +1 @@
> +== QA output created by 309
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index bc6c256..7907abc 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -9,3 +9,4 @@
>  276 auto rw metadata
>  284 auto
>  307 auto quick
> +309 auto

After fixing the test #'s it worked and looks reasonable.

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
