Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56372 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932345AbaFJBj3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jun 2014 21:39:29 -0400
Date: Tue, 10 Jun 2014 11:39:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, lczerner@redhat.com
Subject: Re: [PATCH v5] xfstests: add test for btrfs cloning with file holes
Message-ID: <20140610013925.GJ4453@dastard>
References: <1401499053-11162-1-git-send-email-fdmanana@gmail.com>
 <1401806261-14232-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401806261-14232-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 03:37:41PM +0100, Filipe David Borba Manana wrote:
> Regression test for the btrfs ioctl clone operation when the source range
> contains hole(s) and the FS has the NO_HOLES feature enabled (file holes
> don't need file extent items in the btree to represent them).
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
>     Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Increased test coverage by testing the cases where a hole overlaps
>     the start and end of the cloning range.
> 
> V3: Test the case where the cloning range includes an hole at the end
>     of the source file and might increase the size of the target file.
> 
> V4: Added test for the case where the clone range covers only a hole at
>     the beginning of the source file.
>     Made the test be skipped if the available version of mkfs.btrfs
>     doesn't support the no-holes feature. And when testing the case
>     where the no-holes feature isn't enabled, explicitly ask mkfs.btrfs
>     to disable no-holes (future versions of mkfs.btrfs might enable
>     this feature by default).
> 
> V5: Detect if kernel supports NO_HOLES feature too. Added some messages
>     (echoes) before each od call to make it easier to match output
>     with each specific test.
> 
>  common/rc           |  25 ++++
>  tests/btrfs/055     | 173 ++++++++++++++++++++++++++
>  tests/btrfs/055.out | 347 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/group   |   1 +
>  4 files changed, 546 insertions(+)
>  create mode 100755 tests/btrfs/055
>  create mode 100644 tests/btrfs/055.out
> 
> diff --git a/common/rc b/common/rc
> index f27ee53..e2136d0 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2177,6 +2177,31 @@ _require_btrfs_send_stream_version()
>  	fi
>  }
>  
> +_require_btrfs_mkfs_feature()
> +{
> +	if [ -z $1 ]; then
> +		echo "Missing feature name argument for _require_btrfs_mkfs_feature"
> +		exit 1
> +	fi
> +	feat=$1
> +	$MKFS_BTRFS_PROG -O list-all 2>&1 | \
> +		grep '^[ \t]*'"$feat"'\b' > /dev/null 2>&1
> +	[ $? -eq 0 ] || \
> +		_notrun "Feature $feat not supported in the available version of mkfs.btrfs"
> +}
> +
> +_require_btrfs_fs_feature()
> +{
> +	if [ -z $1 ]; then
> +		echo "Missing feature name argument for _require_btrfs_fs_feature"
> +		exit 1
> +	fi
> +	feat=$1
> +	modprobe btrfs > /dev/null 2>&1
> +	[ -e /sys/fs/btrfs/features/$feat ] || \
> +		_notrun "Feature $feat not supported by the available btrfs version"
> +}
> +
>  init_rc()
>  {
>  	if [ "$iam" == new ]
> diff --git a/tests/btrfs/055 b/tests/btrfs/055
> new file mode 100755
> index 0000000..be38d09
> --- /dev/null
> +++ b/tests/btrfs/055
> @@ -0,0 +1,173 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/055
> +#
> +# Regression test for the btrfs ioctl clone operation when the source range
> +# contains hole(s) and the FS has the NO_HOLES feature enabled (file holes
> +# don't need file extent items in the btree to represent them).
> +#
> +# This issue is fixed by the following linux kernel btrfs patch:
> +#
> +#    Btrfs: fix clone to deal with holes when NO_HOLES feature is enabled
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
> +    rm -fr $tmp
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
> +_require_btrfs_cloner
> +_require_btrfs_fs_feature "no_holes"
> +_require_btrfs_mkfs_feature "no-holes"

Nice kernel/userspace consistency in naming there ;)

> +_need_to_be_root
> +
> +rm -f $seqres.full
> +
> +test_btrfs_clone_with_holes()
> +{
> +	_scratch_mkfs "$1" >/dev/null 2>&1
> +	_scratch_mount
> +
> +	# Create a file with 4 extents and 1 hole, all with a size of 8Kb each.
> +	$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 8192 0 8192" $SCRATCH_MNT/foo \
> +		| _filter_xfs_io
> +	sync
> +	$XFS_IO_PROG -c "pwrite -S 0x02 -b 8192 8192 8192" $SCRATCH_MNT/foo \
> +		| _filter_xfs_io
> +	sync
> +	# After the following write we get an hole in the range [16384, 24576[
> +	$XFS_IO_PROG -c "pwrite -S 0x04 -b 8192 24576 8192" $SCRATCH_MNT/foo \
> +		| _filter_xfs_io
> +	sync
> +	$XFS_IO_PROG -c "pwrite -S 0x05 -b 8192 32768 8192" $SCRATCH_MNT/foo \
> +		| _filter_xfs_io
> +	sync
> +
> +	# Clone destination file, 1 extent of 96kb.
> +	$XFS_IO_PROG -f -c "pwrite -S 0xff -b 98304 0 98304" $SCRATCH_MNT/bar \
> +		| _filter_xfs_io
> +	sync

As Lukas mentioned, this is way too verbose and hard to read.
This:

	# Create a file with 4 extents and 1 hole, all with a size of 8Kb each.
	$XFS_IO_PROG -fs \
		-c "pwrite -S 0x01 -b 8192 0 8192" \
		-c "pwrite -S 0x02 -b 8192 8192 8192" \
		-c "pwrite -S 0x04 -b 8192 24576 8192" \
		-c "pwrite -S 0x05 -b 8192 32768 8192" \
		$SCRATCH_MNT/foo | _filter_xfs_io

	# Clone destination file, 1 extent of 96kb.
	$XFS_IO_PROG -fs -c "pwrite -S 0xff -b 98304 0 98304" \
		$SCRATCH_MNT/bar | _filter_xfs_io

is much more compact and far easier to read. It's also the same
style as many of the other tests use for compound operations like
this.

Other than that the test look sgood.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
