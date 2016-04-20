Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:38934 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbcDTAte (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 20:49:34 -0400
Subject: Re: [PATCH] btrfs: Test that qgroup counts are valid after snapshot
 creation
To: Mark Fasheh <mfasheh@suse.de>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20160419222530.GU2187@wotan.suse.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <5716D1F6.6010507@jp.fujitsu.com>
Date: Wed, 20 Apr 2016 09:48:54 +0900
MIME-Version: 1.0
In-Reply-To: <20160419222530.GU2187@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/04/20 7:25, Mark Fasheh wrote:
> This has been broken since Linux v4.1. We may have worked out a solution on
> the btrfs list but in the meantime sending a test to expose the issue seems
> like a good idea.
>
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>   tests/btrfs/122   | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/group |  1 +

You forgot to add tests/btrfs/122.out.

>   2 files changed, 89 insertions(+)
>   create mode 100755 tests/btrfs/122
>
> diff --git a/tests/btrfs/122 b/tests/btrfs/122
> new file mode 100755
> index 0000000..b7e9e4b
> --- /dev/null
> +++ b/tests/btrfs/122
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/122
> +#
> +# Test that qgroup counts are valid after snapshot creation. This has
> +# been broken in btrfs since Linux v4.1
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
> +#
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +# Force a small leaf size to make it easier to blow out our root
> +# subvolume tree
> +_scratch_mkfs "--nodesize 16384"

nodesize 16384 is the default value. Do you
intend other value, for example 4096?

> +_scratch_mount
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +
> +mkdir "$SCRATCH_MNT/snaps"
> +
> +# First make some simple snapshots - the bug was initially reproduced like this
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT "$SCRATCH_MNT/snaps/empty1"
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT "$SCRATCH_MNT/snaps/empty2"
> +
> +# This forces the fs tree out past level 0, adding at least one tree
> +# block which must be properly accounted for when we make our next
> +# snapshots.
> +mkdir "$SCRATCH_MNT/data"
> +for i in `seq 0 640`; do
> +    $XFS_IO_PROG -f -c "pwrite 0 1M" "$SCRATCH_MNT/data/file$i" > /dev/null 2>&1
> +done;

";" after "done" is not necessary.

Thanks,
Satoru

> +
> +# Snapshot twice.
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT "$SCRATCH_MNT/snaps/snap1"
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT "$SCRATCH_MNT/snaps/snap2"
> +
> +_scratch_unmount
> +
> +# generate a qgroup report and look for inconsistent groups
> +$BTRFS_UTIL_PROG check --qgroup-report $SCRATCH_DEV 2>&1 | \
> +			grep -q -E "Counts for qgroup.*are different"
> +if [ $? -ne 0 ]; then
> +	status=0
> +fi
> +
> +exit
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 9403daa..f7e8cff 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -122,3 +122,4 @@
>   119 auto quick snapshot metadata qgroup
>   120 auto quick snapshot metadata
>   121 auto quick snapshot qgroup
> +122 auto quick snapshot qgroup
>
