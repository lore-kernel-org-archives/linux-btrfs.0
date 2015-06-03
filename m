Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbbFCDxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jun 2015 23:53:41 -0400
Date: Wed, 3 Jun 2015 11:53:37 +0800
From: Eryu Guan <eguan@redhat.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: default subvolume deletion test
Message-ID: <20150603035337.GL3672@dhcp-13-216.nay.redhat.com>
References: <7bc395d36b55628462db15e4eb8ee8e772bb94c9.1433298839.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7bc395d36b55628462db15e4eb8ee8e772bb94c9.1433298839.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 02, 2015 at 07:35:03PM -0700, Omar Sandoval wrote:
> Add a regression test for a problem where attempting to delete the
> default subvolume would fail (as expected), but not until after all
> submounts under the subvolume were unmounted.

I think the subject can be more specific than "btrfs: default subvolume
deletion test", because btrfs/009 test the deletion of default subvol
too, but this test tests more.

> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>  tests/btrfs/089     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/089.out | 10 +++++++
>  tests/btrfs/group   |  1 +
>  3 files changed, 93 insertions(+)
>  create mode 100755 tests/btrfs/089
>  create mode 100644 tests/btrfs/089.out
> 
> diff --git a/tests/btrfs/089 b/tests/btrfs/089
> new file mode 100755
> index 000000000000..af28d996d5c6
> --- /dev/null
> +++ b/tests/btrfs/089
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# FS QA Test 089
> +#
> +# Test deleting the default subvolume, making sure that it fails and that
> +# submounts under it are not unmounted prematurely. This is a regression test
> +# for Linux commit "Btrfs: don't invalidate root dentry when subvolume deletion
> +# fails".
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 YOUR NAME HERE.  All Rights Reserved.

The copyright should be fixed.

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
> +$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/testvol" | _filter_scratch
> +testvol_id=$($BTRFS_UTIL_PROG subvolume list "$SCRATCH_MNT/testvol" | awk '{print $2}')

I found there's a helper to get subvol id, see _btrfs_get_subvolid in
common/rc

> +$BTRFS_UTIL_PROG subvolume set-default "$testvol_id" "$SCRATCH_MNT"
> +
> +# Bind-mount a directory under the default subvolume.
> +mkdir "$SCRATCH_MNT/testvol/testdir"
> +touch "$SCRATCH_MNT/testvol/testdir/testfile"
> +mkdir "$SCRATCH_MNT/testvol/mnt"
> +mount --bind "$SCRATCH_MNT/testvol/testdir" "$SCRATCH_MNT/testvol/mnt"
> +
> +# Now attempt to delete the default subvolume, which should fail.
> +$BTRFS_UTIL_PROG subvolume delete "$SCRATCH_MNT/testvol" 2>&1 | _filter_btrfs_subvol_delete
> +
> +# Make sure that the subvolume and bind mount survived.
> +cd "$SCRATCH_MNT"
> +find | sort
> +
> +cd "$here"
> +_scratch_unmount

The cd and _scratch_unmount are not necessary here, _require_scratch
deals with the umount.

Thanks,
Eryu
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/089.out b/tests/btrfs/089.out
> new file mode 100644
> index 000000000000..eb9c5112e12e
> --- /dev/null
> +++ b/tests/btrfs/089.out
> @@ -0,0 +1,10 @@
> +QA output created by 089
> +Create subvolume 'SCRATCH_MNT/testvol'
> +ERROR: cannot delete 'SCRATCH_MNT/testvol' - Operation not permitted
> +Delete subvolume 'SCRATCH_MNT/testvol'
> +.
> +./testvol
> +./testvol/mnt
> +./testvol/mnt/testfile
> +./testvol/testdir
> +./testvol/testdir/testfile
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
