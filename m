Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750760AbdCNFhs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 01:37:48 -0400
Date: Tue, 14 Mar 2017 13:37:36 +0800
From: Eryu Guan <eguan@redhat.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: fstests@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs/139: creation/deletion within qgroup limits
Message-ID: <20170314053736.GZ14226@eguan.usersys.redhat.com>
References: <20170313213716.9579-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313213716.9579-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[please cc linux-btrfs@vger.kernel.org for btrfs specific tests]

On Mon, Mar 13, 2017 at 04:37:16PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> If we create and delete files within the qgroup limits, qg->reserved
> (allocations before commits) over-inflates and causes -EDQUOT to
> be returned pre-maturely.
> 
> Also, 32/64bit data-type exchanges can cause reserved (u64)
> to go negative (very large) and -EDQUOT is returned
> pre-maturely.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Thanks for the test! I tested it with 4.10 kernel and test failed. I
assume it's expected result. Some comments inline.

> ---
>  tests/btrfs/139     |  75 +++++++++++++++++++++++++
>  tests/btrfs/139.out | 156 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/group   |   1 +
>  3 files changed, 232 insertions(+)
>  create mode 100755 tests/btrfs/139
>  create mode 100644 tests/btrfs/139.out
> 
> diff --git a/tests/btrfs/139 b/tests/btrfs/139
> new file mode 100755
> index 0000000..df0ef3e
> --- /dev/null
> +++ b/tests/btrfs/139
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# FS QA Test 139
> +#
> +# Check if btrfs quota limits are not reached when you constantly
> +# create and delete files within the exclusive qgroup limits.
> +#
> +# Finally we create files to exceed the quota.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 SUSE. All Rights Reserved.
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +_supported_fs btrfs
> +_supported_os Linux

Need _require_scratch, it check if SCRATCH_DEV is present and unmounts
it if so.

> +
> +_scratch_mkfs > /dev/null 2>&1
> +#_scratch_mount

Then need to _scratch_mount here.

> +
> +SUBVOL=$SCRATCH_MNT/subvol
> +
> +_run_btrfs_util_prog subvolume create $SUBVOL
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT

I always see this message in dmesg, not sure if it affects test?

BTRFS info (device sdc2): qgroup_rescan_init failed with -115

> +_run_btrfs_util_prog qgroup limit -e 1G $SUBVOL
> +
> +for i in $(seq 1 10); do
> +	for j in $(seq 1 7); do
> +		$XFS_IO_PROG -f -c "pwrite 0 128m" $SUBVOL/file_$j | _filter_xfs_io

No need to filter & print xfs_io stdout, it makes the .out file not
necessarily too long. We can discard stdout, so if error happens the
stderr output could break the .out file match anyway.

		$XFS_IO_PROG -f -c "pwrite 0 128m" $SUBVOL/file_$j >/dev/null


> +	done
> +	rm -f $SUBVOL/file*
> +done
> +
> +for j in $(seq 1 8); do
> +	$XFS_IO_PROG -f -c "pwrite 0 128m" $SUBVOL/file_$j | _filter_xfs_io

pwrite error is expected here, and newer xfs_io only prints "pwrite" not
"pwrite64", so _filter_xfs_io_error should be used to filter the error
message from stderr (not stdout).

	$XFS_IO_PROG -f -c "pwrite 0 128m" $SUBVOL/file_$j 2>&1 | _filter_xfs_io_error

> +done

Better to add comments about these two for loops, what is the purpose of
each loop etc.

Thanks,
Eryu
