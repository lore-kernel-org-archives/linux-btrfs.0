Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbbHFLqg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Aug 2015 07:46:36 -0400
Date: Thu, 6 Aug 2015 19:46:34 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: generic test for fsync of file with multiple
 links
Message-ID: <20150806114634.GE17933@dhcp-13-216.nay.redhat.com>
References: <1438834290-30636-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438834290-30636-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2015 at 05:11:30AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that when we have a file with multiple hard links belonging to
> different parent directories, if we remove one of those links, fsync the
> file using one of its other links (that has a parent directory different
> from the one we removed a link from), power fail and then replay the
> fsync log/journal, the hard link we removed is not available anymore and
> all the filesystem metadata is in a consistent state.

Looks good to me, just one minor question below

> 
> This test is motivated by an issue found in btrfs, where the test fails
> with:
> 
>   generic/107 2s ... - output mismatch (see .../results/generic/107.out.bad)
>     --- tests/generic/107.out	2015-08-04 09:47:46.922131256 +0100
>     +++ /home/fdmanana/git/hub/xfstests/results//generic/107.out.bad
>     @@ -1,3 +1,5 @@
>      QA output created by 107
>      Entries in testdir:
>      foo2
>     +foo3
>     +rmdir: failed to remove '/home/fdmanana/btrfs-tests/scratch_1/testdir': Directory not empty
>     ...
>     (Run 'diff -u tests/generic/107.out .../generic/107.out.bad'  to see the entire diff)
>   _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent (see .../generic/107.full)
>   _check_dmesg: something found in dmesg (see .../generic/107.dmesg)
> 
>   $ cat /home/fdmanana/git/hub/xfstests/results//generic/107.full
>   _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
>   *** fsck.btrfs output ***
>   checking extents
>   checking free space cache
>   checking fs roots
>   root 5 inode 257 errors 200, dir isize wrong
> 	unresolved ref dir 257 index 3 namelen 4 name foo3 filetype 1 \
>           errors 5, no dir item, no inode ref
> 
>   $ cat /home/fdmanana/git/hub/xfstests/results//generic/107.dmesg
>   (...)
>   [188897.707311] BTRFS info (device dm-0): failed to delete reference to \
>     foo3, inode 258 parent 257
>   [188897.711345] ------------[ cut here ]------------
>   [188897.713369] WARNING: CPU: 10 PID: 19452 at fs/btrfs/inode.c:3956 \
>     __btrfs_unlink_inode+0x182/0x35a [btrfs]()
>   [188897.717661] BTRFS: Transaction aborted (error -2)
>   (...)
>   [188897.747898] Call Trace:
>   [188897.748519]  [<ffffffff8145f077>] dump_stack+0x4f/0x7b
>   [188897.749602]  [<ffffffff81095de5>] ? console_unlock+0x356/0x3a2
>   [188897.750682]  [<ffffffff8104b3b0>] warn_slowpath_common+0xa1/0xbb
>   [188897.751936]  [<ffffffffa04c5d09>] ? __btrfs_unlink_inode+0x182/0x35a [btrfs]
>   [188897.753485]  [<ffffffff8104b410>] warn_slowpath_fmt+0x46/0x48
>   [188897.754781]  [<ffffffffa04c5d09>] __btrfs_unlink_inode+0x182/0x35a [btrfs]
>   [188897.756295]  [<ffffffffa04c6e8f>] btrfs_unlink_inode+0x1e/0x40 [btrfs]
>   [188897.757692]  [<ffffffffa04c6f11>] btrfs_unlink+0x60/0x9b [btrfs]
>   [188897.758978]  [<ffffffff8116fb48>] vfs_unlink+0x9c/0xed
>   [188897.760151]  [<ffffffff81173481>] do_unlinkat+0x12b/0x1fb
>   [188897.761354]  [<ffffffff81253855>] ? lockdep_sys_exit_thunk+0x12/0x14
>   [188897.762692]  [<ffffffff81174056>] SyS_unlinkat+0x29/0x2b
>   [188897.763741]  [<ffffffff81465197>] system_call_fastpath+0x12/0x6f
>   [188897.764894] ---[ end trace bbfddacb7aaada8c ]---
>   [188897.765801] BTRFS warning (device dm-0): __btrfs_unlink_inode:3956: \
>     Aborting unused transaction(No such entry).
> 
> Tested against ext3/4, xfs, reiserfs and f2fs too, and all these
> filesystems currently pass this test (on a 4.1 linux kernel at least).
> 
> The btrfs issue is fixed by the linux kernel patch titled:
> "Btrfs: fix stale dir entries after removing a link and fsync".
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/generic/107     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/107.out |  3 ++
>  tests/generic/group   |  1 +
>  3 files changed, 103 insertions(+)
>  create mode 100755 tests/generic/107
>  create mode 100644 tests/generic/107.out
> 
> diff --git a/tests/generic/107 b/tests/generic/107
> new file mode 100755
> index 0000000..7d107d7
> --- /dev/null
> +++ b/tests/generic/107
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# FSQA Test No. 107
> +#
> +# Test that when we have a file with multiple hard links belonging to different
> +# parent directories, if we remove one of those links, fsync the file using one
> +# of its other links (that has a parent directory different from the one we
> +# removed a link from), power fail and then replay the fsync log/journal, the
> +# hard link we removed is not available anymore and all the filesystem metadata
> +# is in a consistent state.
> +#
> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
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
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmflakey
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_dm_flakey
> +_require_metadata_journaling $SCRATCH_DEV
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_init_flakey
> +_mount_flakey
> +
> +# Create our test directory and file.
> +mkdir $SCRATCH_MNT/testdir
> +touch $SCRATCH_MNT/foo
> +ln $SCRATCH_MNT/foo $SCRATCH_MNT/testdir/foo2
> +ln $SCRATCH_MNT/foo $SCRATCH_MNT/testdir/foo3
> +
> +# Make sure everything done so far is durably persisted.
> +sync
> +
> +# Now we remove one of our file's hardlinks in the directory testdir.
> +unlink $SCRATCH_MNT/testdir/foo3

What's the difference between unlink and rm? I tried rm and all was
fine. Just curious, any reason to use unlink here?

Given that unlink is from coreutils and available on every distro,

Reviewed-by: Eryu Guan <eguan@redhat.com>
