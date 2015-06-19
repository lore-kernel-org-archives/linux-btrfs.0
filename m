Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38892 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbbFSRtS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 13:49:18 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1ebef916f54960cf6fef34be950e3d38cc3a50b0.1433537929.git.osandov@osandov.com>
References: <1ebef916f54960cf6fef34be950e3d38cc3a50b0.1433537929.git.osandov@osandov.com>
Date: Fri, 19 Jun 2015 18:49:17 +0100
Message-ID: <CAL3q7H6c16k2B2Tw3o6e734Qg59b1AGUPZRDpp0yw+tou57TbA@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: test premature submount unmounting when
 deleting default subvolume
From: Filipe David Manana <fdmanana@gmail.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 5, 2015 at 10:00 PM, Omar Sandoval <osandov@osandov.com> wrote:
> Add a regression test for a problem where attempting to delete the
> default subvolume would fail (as expected), but not until after all
> submounts under the subvolume were unmounted.
>
> Reviewed-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Filipe Manana <fdmanana@suse.com>

Thanks for doing this.

> ---
> v2->v3:
> - Update description (thanks, Eryu)
> - Remove unneeded touch
>
> v1->v2:
> - Simpler test: just depends on umount of the bind mount succeeding
>   instead of running find. Without the patch applied, the bind mount
>   will disappear so umount will fail.
> - Fix Eryu's comments (better subject, copyright, use
>   _btrfs_get_subvolid)
>
>  tests/btrfs/089     | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/089.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 82 insertions(+)
>  create mode 100755 tests/btrfs/089
>  create mode 100644 tests/btrfs/089.out
>
> diff --git a/tests/btrfs/089 b/tests/btrfs/089
> new file mode 100755
> index 000000000000..537269824b62
> --- /dev/null
> +++ b/tests/btrfs/089
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# FS QA Test 089
> +#
> +# Test deleting the default subvolume, making sure that submounts under it are
> +# not unmounted prematurely. This is a regression test for Linux commit "Btrfs:
> +# don't invalidate root dentry when subvolume deletion fails".
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
> +$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/testvol" >>$seqres.full 2>&1 \
> +       || _fail "couldn't create subvol"
> +testvol_id=$(_btrfs_get_subvolid "$SCRATCH_MNT" testvol)
> +$BTRFS_UTIL_PROG subvolume set-default $testvol_id "$SCRATCH_MNT" >>$seqres.full 2>&1 \
> +       || _fail "couldn't set default"
> +
> +# Bind-mount a directory under the default subvolume.
> +mkdir "$SCRATCH_MNT/testvol/testdir"
> +mkdir "$SCRATCH_MNT/testvol/mnt"
> +mount --bind "$SCRATCH_MNT/testvol/testdir" "$SCRATCH_MNT/testvol/mnt"
> +
> +# Now attempt to delete the default subvolume.
> +$BTRFS_UTIL_PROG subvolume delete "$SCRATCH_MNT/testvol" >>$seqres.full 2>&1
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



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
