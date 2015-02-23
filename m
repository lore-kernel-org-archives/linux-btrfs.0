Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46443 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbbBWUOk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 15:14:40 -0500
Message-ID: <54EB8A1F.2050207@sandeen.net>
Date: Mon, 23 Feb 2015 14:14:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic test for fsync after removing xattrs
References: <1424721327-25972-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1424721327-25972-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/23/15 1:55 PM, Filipe Manana wrote:
> This test is motivated by an fsync issue discovered in btrfs.
> The issue was that the fsync log replay code did not remove xattrs that
> were deleted before the inode was fsynced. The result was unexpected
> and differed from xfs and ext3/4 for example.
> 
> The btrfs issue was fixed by the following linux kernel patch:
> 
>    Btrfs: remove deleted xattrs on fsync log replay
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/generic/061     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/061.out |  10 +++++
>  tests/generic/group   |   1 +
>  3 files changed, 126 insertions(+)
>  create mode 100755 tests/generic/061
>  create mode 100644 tests/generic/061.out
> 
> diff --git a/tests/generic/061 b/tests/generic/061
> new file mode 100755
> index 0000000..a5eb668
> --- /dev/null
> +++ b/tests/generic/061
> @@ -0,0 +1,115 @@
> +#! /bin/bash
> +# FS QA Test No. 061

Could you describe what the test actually does first in the header
comment?  You have the btrfs-specific flaw, but (I say this after
having looked at 034 just this morning) sometimes it's nice to
have a concise description of the test.

i.e.:

# Test that log replay properly handles deleted xattrs after an fsync
<or whatever is the proper operational description>

at the very top, so it's clear from a glance what the test *does*
without having to read through it.

Also - for this and 034 and possibly others, anything which tests log
replay really can't be wholly generic.  ext2 doesn't have a journal, for
example, and ext4 can run without one.

I was going to make an:

_excluded_fs ext2

type helper, but that doesn't solve the ext4 problem, so I think
maybe a 

_requires_metadata_journaling

or similar might be a good idea.  Thoughts?  Unfortunately that would
need some special-casing for ext4, to see if it has jbd2 turned on or
not, but I can help with that.

(dumpe2fs -h $TEST_DEV | grep has_journal)

Thanks,
-Eric

> +#
> +# This test is motivated by an fsync issue discovered in btrfs.
> +# The issue was that the fsync log replay code did not remove xattrs that
> +# were deleted before the inode was fsynced.
> +#
> +# The btrfs issue was fixed by the following linux kernel patch:
> +#
> +#  Btrfs: remove deleted xattrs on fsync log replay
> +#
> +#-----------------------------------------------------------------------
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
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmflakey
> +. ./common/attr
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_need_to_be_root
> +_require_scratch
> +_require_dm_flakey
> +_require_attrs
> +
> +_crash_and_mount()
> +{
> +	# Simulate a crash/power loss.
> +	_load_flakey_table $FLAKEY_DROP_WRITES
> +	_unmount_flakey
> +	_load_flakey_table $FLAKEY_ALLOW_WRITES
> +	_mount_flakey
> +}
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_init_flakey
> +_mount_flakey
> +
> +# Create out test file and add 3 xattrs to it.
> +touch $SCRATCH_MNT/foobar
> +$SETFATTR_PROG -n user.attr1 -v val1 $SCRATCH_MNT/foobar
> +$SETFATTR_PROG -n user.attr2 -v val2 $SCRATCH_MNT/foobar
> +$SETFATTR_PROG -n user.attr3 -v val3 $SCRATCH_MNT/foobar
> +
> +# Make sure everything is durably persisted.
> +sync
> +
> +# Now delete the second xattr and fsync the inode.
> +$SETFATTR_PROG -x user.attr2 $SCRATCH_MNT/foobar
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
> +
> +_crash_and_mount
> +
> +# After the fsync log is replayed, the file should have only 2 xattrs, the ones
> +# named user.attr1 and user.attr3. The btrfs fsync log replay bug left the file
> +# with the 3 xattrs that we had before deleting the second one and fsyncing the
> +# file.
> +echo "xattr names and values after first fsync log replay:"
> +$GETFATTR_PROG --absolute-names --dump $SCRATCH_MNT/foobar | _filter_scratch
> +
> +# Now write some data to our file, fsync it, remove the first xattr, add a new
> +# hard link to our file and commit the fsync log by fsyncing some other new
> +# file. This is to verify that after log replay our first xattr does not exist
> +# anymore.
> +echo "hello world!" >> $SCRATCH_MNT/foobar
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foobar
> +$SETFATTR_PROG -x user.attr1 $SCRATCH_MNT/foobar
> +ln $SCRATCH_MNT/foobar $SCRATCH_MNT/foobar_link
> +touch $SCRATCH_MNT/qwerty
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/qwerty
> +
> +_crash_and_mount
> +
> +# Now only the xattr with name user.attr3 should be set in our file.
> +echo "xattr names and values after second fsync log replay:"
> +$GETFATTR_PROG --absolute-names --dump $SCRATCH_MNT/foobar | _filter_scratch
> +
> +status=0
> +exit
> diff --git a/tests/generic/061.out b/tests/generic/061.out
> new file mode 100644
> index 0000000..028d9e6
> --- /dev/null
> +++ b/tests/generic/061.out
> @@ -0,0 +1,10 @@
> +QA output created by 061
> +xattr names and values after first fsync log replay:
> +# file: SCRATCH_MNT/foobar
> +user.attr1="val1"
> +user.attr3="val3"
> +
> +xattr names and values after second fsync log replay:
> +# file: SCRATCH_MNT/foobar
> +user.attr3="val3"
> +
> diff --git a/tests/generic/group b/tests/generic/group
> index 85ff384..758f0e2 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -62,6 +62,7 @@
>  057 metadata auto quick
>  059 metadata auto quick
>  060 metadata auto quick
> +061 metadata auto quick
>  062 attr udf auto quick
>  068 other auto freeze dangerous stress
>  069 rw udf auto quick
> 

