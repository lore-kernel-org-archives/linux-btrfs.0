Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbbFDFaj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jun 2015 01:30:39 -0400
Date: Thu, 4 Jun 2015 13:30:36 +0800
From: Eryu Guan <eguan@redhat.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: test premature submount unmounting when
 deleting default subvolume
Message-ID: <20150604053036.GN3672@dhcp-13-216.nay.redhat.com>
References: <cbf811009efa5a8bc78a75aa98c8f27cc4a4c7f3.1433307753.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cbf811009efa5a8bc78a75aa98c8f27cc4a4c7f3.1433307753.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 02, 2015 at 10:05:30PM -0700, Omar Sandoval wrote:
> Add a regression test for a problem where attempting to delete the
> default subvolume would fail (as expected), but not until after all
> submounts under the subvolume were unmounted.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> v1->v2:
> - Simpler test: just depends on umount of the bind mount succeeding
>   instead of running find. Without the patch applied, the bind mount
>   will disappear so umount will fail.
> - Fix Eryu's comments (better subject, copyright, use
>   _btrfs_get_subvolid)
> 
>  tests/btrfs/089     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/089.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 84 insertions(+)
>  create mode 100755 tests/btrfs/089
>  create mode 100644 tests/btrfs/089.out
> 
> diff --git a/tests/btrfs/089 b/tests/btrfs/089
> new file mode 100755
> index 000000000000..c81df2a3b225
> --- /dev/null
> +++ b/tests/btrfs/089
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# FS QA Test 089
> +#
> +# Test deleting the default subvolume, making sure that it fails and that

Here says to make sure the deletion of default subvol fails, but...

> +# submounts under it are not unmounted prematurely. This is a regression test
> +# for Linux commit "Btrfs: don't invalidate root dentry when subvolume deletion
> +# fails".
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Omar Sandoval.  All Rights Reserved.
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
> +. ./common/filter.btrfs
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +# Create a new subvolume and make it the default subvolume.
> +$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/testvol" >> $seqres.full 2>&1 \
> +	|| _fail "couldn't create subvol"
> +testvol_id=$(_btrfs_get_subvolid "$SCRATCH_MNT" testvol)
> +$BTRFS_UTIL_PROG subvolume set-default $testvol_id "$SCRATCH_MNT" >> $seqres.full 2>&1 \
> +	|| _fail "couldn't set default"
> +
> +# Bind-mount a directory under the default subvolume.
> +mkdir "$SCRATCH_MNT/testvol/testdir"
> +touch "$SCRATCH_MNT/testvol/testdir/testfile"
> +mkdir "$SCRATCH_MNT/testvol/mnt"
> +mount --bind "$SCRATCH_MNT/testvol/testdir" "$SCRATCH_MNT/testvol/mnt"
> +
> +# Now attempt to delete the default subvolume, which should fail.
> +$BTRFS_UTIL_PROG subvolume delete "$SCRATCH_MNT/testvol" >> $seqres.full 2>&1

the result of deletion of default subvol is not checked and ignored
here. The description should match the test.

Otherwise looks good to me.

Reviewed-by: Eryu Guan <eguan@redhat.com>

Thanks,
Eryu
> +
> +# Unmount the bind mount, which should still be alive.
> +$UMOUNT_PROG "$SCRATCH_MNT/testvol/mnt"
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/089.out b/tests/btrfs/089.out
> new file mode 100644
> index 000000000000..a7fcdee9b767
> --- /dev/null
> +++ b/tests/btrfs/089.out
> @@ -0,0 +1,2 @@
> +QA output created by 089
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index ffe18bff0d21..616d060758c1 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -91,6 +91,7 @@
>  086 auto quick clone
>  087 auto quick send
>  088 auto quick metadata
> +089 auto quick subvol
>  090 auto quick metadata
>  091 auto quick qgroup
>  092 auto quick send
> -- 
> 2.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
