Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12044 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933028AbaFJCKU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jun 2014 22:10:20 -0400
Date: Tue, 10 Jun 2014 12:10:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests: add test for btrfs clone + fsync durability
Message-ID: <20140610021017.GL4453@dastard>
References: <1402027700-9813-1-git-send-email-fdmanana@gmail.com>
 <1402282132-618-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1402282132-618-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 09, 2014 at 03:48:52AM +0100, Filipe David Borba Manana wrote:
> Regression test for btrfs ioctl clone operation + fsync + log
> recovery. The issue was that doing an fsync after cloning into
> a file didn't gave any persistence guarantees as it should.
> What happened was that the in memory metadata (extent maps)
> weren't updated, which made the fsync code not able to detect
> that file data has been changed and must be persisted to the
> log.
> 
> This issue is fixed by the following linux kernel btrfs patch:
> 
>     Btrfs: make fsync work after cloning into a file
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Test small files too, consisting of a single inline extent, as
>     it triggers different code paths.
> 
>  tests/btrfs/056     | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/056.out | 129 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/group   |   1 +
>  3 files changed, 280 insertions(+)
>  create mode 100755 tests/btrfs/056
>  create mode 100644 tests/btrfs/056.out
> 
> diff --git a/tests/btrfs/056 b/tests/btrfs/056
> new file mode 100755
> index 0000000..e066442
> --- /dev/null
> +++ b/tests/btrfs/056
> @@ -0,0 +1,150 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/056
> +#
> +# Regression test for btrfs ioctl clone operation + fsync + log recovery.
> +# The issue was that doing an fsync after cloning into a file didn't gave any
> +# persistence guarantees as it should. What happened was that the in memory
> +# metadata (extent maps) weren't updated, which made the fsync code not able
> +# to detect that file data has been changed.
> +#
> +# This issue is fixed by the following linux kernel btrfs patch:
> +#
> +#    Btrfs: make fsync work after cloning into a file
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
> +	_cleanup_flakey
> +	rm -fr $tmp
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmflakey
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_btrfs_cloner
> +_require_btrfs_fs_feature "no_holes"
> +_require_btrfs_mkfs_feature "no-holes"
> +_require_dm_flakey
> +_need_to_be_root
> +
> +rm -f $seqres.full
> +
> +test_btrfs_clone_fsync_log_recover()
> +{
> +	_scratch_mkfs "$1" >/dev/null 2>&1
> +	_init_flakey
> +	SAVE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
> +	MOUNT_OPTIONS="$MOUNT_OPTIONS $2"
> +	_mount_flakey
> +
> +	# Create a file with 4 extents and 1 hole, all with a size of 8Kb each.
> +	# The hole is in the range [16384, 24576[.
> +	$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 8192 0 8192" \
> +			-c "fsync" \
> +			-c "pwrite -S 0x02 -b 8192 8192 8192" \
> +			-c "fsync" \
> +			-c "pwrite -S 0x04 -b 8192 24576 8192" \
> +			-c "fsync" \
> +			-c "pwrite -S 0x05 -b 8192 32768 8192" \
> +			-c "fsync" \
> +		$SCRATCH_MNT/foo | _filter_xfs_io
> +
> +	# Clone destination file, 1 extent of 96kb.
> +	$XFS_IO_PROG -f -c "pwrite -S 0xff -b 98304 0 98304" -c "fsync" \
> +		$SCRATCH_MNT/bar | _filter_xfs_io

I've seen this pattern before ;)

Use the "-s" option to xfs_io rather than repeated "pwrite/fsync"
pairs.

Otherwise looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
