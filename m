Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbcGLD7A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 23:59:00 -0400
Date: Tue, 12 Jul 2016 11:58:57 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/3] btrfs: add test for an incremental send after moving
 directories around
Message-ID: <20160712035857.GK2432@eguan.usersys.redhat.com>
References: <1467462728-14495-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467462728-14495-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 02, 2016 at 01:32:08PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that an incremental send operation works after doing radical changes
> in the directory hierarchy that involve switching the inode that directory
> entries point to.
> 
> This test exercises scenarios used to fail in btrfs and are fixed by the
> following patches for the linux kernel:
> 
>  "Btrfs: send, fix failure to move directories with the same name around"
>  "Btrfs: incremental send, fix invalid paths for rename operations"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/btrfs/124     | 261 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/124.out |   2 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 264 insertions(+)
>  create mode 100755 tests/btrfs/124
>  create mode 100644 tests/btrfs/124.out
> 
> diff --git a/tests/btrfs/124 b/tests/btrfs/124
> new file mode 100755
> index 0000000..38635a3
> --- /dev/null
> +++ b/tests/btrfs/124
> @@ -0,0 +1,261 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/124
> +#
> +# Test that an incremental send operation works after doing radical changes
> +# in the directory hierarchy that involve switching the inode that directory
> +# entries point to.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
> +# Author: Filipe Manana <fdmanana@suse.com>
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
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
	cd /
to make it consistent with other _cleanup :)

> +	rm -fr $send_files_dir
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_fssum
> +
> +send_files_dir=$TEST_DIR/btrfs-test-$seq

These three tests all take use of $TEST_DIR, but don't _require_test, I
think we need it in these tests.

> +
> +rm -f $seqres.full
> +rm -fr $send_files_dir
> +mkdir $send_files_dir
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +# case 1
> +mkdir -p $SCRATCH_MNT/case_1/d/p1
> +mkdir $SCRATCH_MNT/case_1/p1
> +
> +# case 2
> +mkdir -p $SCRATCH_MNT/case_2/a
> +mkdir $SCRATCH_MNT/case_2/d
> +mkdir $SCRATCH_MNT/case_2/e
> +mkdir $SCRATCH_MNT/case_2/f
> +mkdir $SCRATCH_MNT/case_2/ance
> +mkdir $SCRATCH_MNT/case_2/d/ance
> +mkdir $SCRATCH_MNT/case_2/a/c
> +mv $SCRATCH_MNT/case_2/e $SCRATCH_MNT/case_2/d/ance
> +mv $SCRATCH_MNT/case_2/f $SCRATCH_MNT/case_2/d/ance
> +mv $SCRATCH_MNT/case_2/ance $SCRATCH_MNT/case_2/d/ance
> +
> +# case 3
> +mkdir -p $SCRATCH_MNT/case_3/d
> +mkdir $SCRATCH_MNT/case_3/a
> +mkdir $SCRATCH_MNT/case_3/waiting_dir
> +mkdir -p $SCRATCH_MNT/case_3/pre/ance
> +mkdir $SCRATCH_MNT/case_3/d/ance
> +mkdir $SCRATCH_MNT/case_3/a/c
> +mv $SCRATCH_MNT/case_3/waiting_dir $SCRATCH_MNT/case_3/d/ance
> +
> +# case 4
> +mkdir -p $SCRATCH_MNT/case_4/tmp
> +mkdir $SCRATCH_MNT/case_4/below_ance
> +mkdir -p $SCRATCH_MNT/case_4/pre/wait_dir
> +mkdir $SCRATCH_MNT/case_4/desc
> +mkdir $SCRATCH_MNT/case_4/ance
> +mv $SCRATCH_MNT/case_4/below_ance $SCRATCH_MNT/case_4/ance
> +mkdir $SCRATCH_MNT/case_4/other_dir
> +
> +# Filesystem looks like:
> +#
> +# .                                                                  (ino 256)
> +# |--- case_1/                                                       (ino 257)
> +# |       |---- d/                                                   (ino 258)
> +# |       |     |--- p1/                                             (ino 259)
> +# |       |
> +# |       |---- p1/                                                  (ino 260)
> +# |
> +# |--- case_2/                                                       (ino 261)
> +# |       |---- a/                                                   (ino 262)
> +# |       |     |---- c/                                             (ino 268)
> +# |       |
> +# |       |---- d/                                                   (ino 263)
> +# |             |---- ance/                                          (ino 267)
> +# |                     |---- e/                                     (ino 264)
> +# |                     |---- f/                                     (ino 265)
> +# |                     |---- ance/                                  (ino 266)
> +# |
> +# |--- case_3/                                                       (ino 269)
> +# |       |---- a/                                                   (ino 271)
> +# |       |     |---- c/                                             (ino 276)
> +# |       |
> +# |       |---- d/                                                   (ino 270)
> +# |       |     |---- ance/                                          (ino 275)
> +# |       |             |---- waiting_dir/                           (ino 272)
> +# |       |
> +# |       |---- pre/                                                 (ino 273)
> +# |              |---- ance/                                         (ino 274)
> +# |
> +# |--- case_4/                                                       (ino 277)
> +#         |---- tmp/                                                 (ino 278)
> +#         |---- pre/                                                 (ino 280)
> +#         |      |---- wait_dir/                                     (ino 281)
> +#         |
> +#         |---- desc/                                                (ino 282)
> +#         |---- ance/                                                (ino 283)
> +#         |       |---- below_ance/                                  (ino 279)
> +#         |
> +#         |---- other_dir/                                           (ino 284)
> +#
> +_run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1

Please avoid using _run_btrfs_util_prog and run_check, as Dave explained
before (and I summarized them in this email
http://www.spinics.net/lists/fstests/msg03311.html :-)

So just dump the output and do necessary filters to match golden image.
I think this also makes it easier to know what's failing, the diff
output shows it directly, there's no need to check $seqres.full again.

And this test failed due to memory allocation, is this expected?

At subvol /mnt/testarea/scratch/mysnap2
ERROR: send ioctl failed with -12: Cannot allocate memory
failed: '/usr/bin/btrfs send -p /mnt/testarea/scratch/mysnap1 /mnt/testarea/scratch/mysnap2 -f /mnt/testarea/test/btrfs-test-127/2.snap'

I'm using btrfs-progs v4.6

Otherwise these three tests look good to me.

Thanks,
Eryu
