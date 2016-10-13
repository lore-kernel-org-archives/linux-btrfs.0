Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34491 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754536AbcJMLnD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 07:43:03 -0400
Received: by mail-io0-f196.google.com with SMTP id i202so4728679ioi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 04:42:59 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476356653-22839-2-git-send-email-robbieko@synology.com>
References: <1476356653-22839-1-git-send-email-robbieko@synology.com> <1476356653-22839-2-git-send-email-robbieko@synology.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 13 Oct 2016 12:42:57 +0100
Message-ID: <CAL3q7H4-dRftBRV=wx6aPVta1QMkDUkLNrutty++ruFstYM=og@mail.gmail.com>
Subject: Re: [PATCH 1/4] btrfs: add test for an incremental send don't skip
 overwrite ref for inode 256
To: robbieko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 13, 2016 at 12:04 PM, robbieko <robbieko@synology.com> wrote:
> From: Robbie Ko <robbieko@synology.com>
>
> Test that an incremental send operation does not skip overwrite ref
> for inode 256, it's always exist.

Tests should have a description that non-developers can understand
(like QA people for e.g.).
I doubt most QA people know how send works internally.

>
> This test exercises scenarios used to fail in btrfs and are fixed by
> the following patches for the linux kernel:

patches -> path

>
> "Btrfs: incremental send, fix don't skip inode 256 in overwrite_ref"
>
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  tests/btrfs/131     | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/131.out |   2 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 113 insertions(+)
>  create mode 100755 tests/btrfs/131
>  create mode 100644 tests/btrfs/131.out
>
> diff --git a/tests/btrfs/131 b/tests/btrfs/131
> new file mode 100755
> index 0000000..2359841
> --- /dev/null
> +++ b/tests/btrfs/131
> @@ -0,0 +1,110 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/131
> +#
> +# Test that an incremental send operation does not skip inode 256 check
> +# overwrite ref, because inode 256 always exist.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
> +# Author: Filipe Manana <fdmanana@suse.com>

No, I'm not the author of this test.

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
> +tmp=/tmp/$$
> +status=1       # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -fr $send_files_dir
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_test
> +_require_scratch
> +_require_fssum
> +
> +send_files_dir=$TEST_DIR/btrfs-test-$seq
> +
> +rm -f $seqres.full
> +rm -fr $send_files_dir
> +mkdir $send_files_dir
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +mkdir $SCRATCH_MNT/a1
> +mkdir $SCRATCH_MNT/a2
> +
> +# Filesystem looks like:
> +#
> +# .                                                             (ino 256)
> +# |--- a1/                                                      (ino 257)
> +# |
> +# |--- a2/                                                      (ino 258)
> +#
> +_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
> +
> +_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
> +
> +_scratch_unmount
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +touch $SCRATCH_MNT/a2
> +
> +# Filesystem now looks like:
> +#
> +# .                                                             (ino 256)
> +# |--- a2                                                       (ino 257)
> +#
> +_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
> +
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
> +rm $send_files_dir/1.snap
> +
> +run_check $FSSUM_PROG -A -f -w $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
> +run_check $FSSUM_PROG -A -f -w $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
> +
> +_run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
> +_run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
> +       -f $send_files_dir/2.snap
> +
> +# Now recreate the filesystem by receiving both send streams and verify we get
> +# the same content that the original filesystem had.
> +_scratch_unmount
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
> +run_check $FSSUM_PROG -r $send_files_dir/1.fssum $SCRATCH_MNT/mysnap1
> +_run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
> +run_check $FSSUM_PROG -r $send_files_dir/2.fssum $SCRATCH_MNT/mysnap2
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/131.out b/tests/btrfs/131.out
> new file mode 100644
> index 0000000..d118ca9
> --- /dev/null
> +++ b/tests/btrfs/131.out
> @@ -0,0 +1,2 @@
> +QA output created by 131
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index f3a7a4f..a7a070a 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -133,3 +133,4 @@
>  128 auto quick send
>  129 auto quick send
>  130 auto clone send
> +131 auto quick send
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
