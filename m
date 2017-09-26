Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967311AbdIZJCi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 05:02:38 -0400
Date: Tue, 26 Sep 2017 17:02:36 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstests: btrfs/150 regression test for reading
 compressed data
Message-ID: <20170926090236.GI8034@eguan.usersys.redhat.com>
References: <20170920235243.11822-1-bo.li.liu@oracle.com>
 <20170922232127.12032-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170922232127.12032-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 22, 2017 at 05:21:27PM -0600, Liu Bo wrote:
> We had a bug in btrfs compression code which could end up with a
> kernel panic.
> 
> This is adding a regression test for the bug and I've also sent a
> kernel patch to fix the bug.
> 
> The patch is "Btrfs: fix kernel oops while reading compressed data".
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Hmm, I can't reproduce the panic with 4.13 kernel, which doesn't have
the fix applied. Can you please help confirm if it panics on your test
environment?

> ---
> v2: - Fix ambiguous copyright.
>     - Use /proc/$pid/make-it-fail to specify IO failure
>     - Use bash -c to run test only when pid is odd.
>     - Add test to dangerous group.
> 
>  tests/btrfs/150     | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/150.out |   3 ++
>  tests/btrfs/group   |   1 +
>  3 files changed, 107 insertions(+)
>  create mode 100755 tests/btrfs/150
>  create mode 100644 tests/btrfs/150.out
> 
> diff --git a/tests/btrfs/150 b/tests/btrfs/150
> new file mode 100755
> index 0000000..8891c38
> --- /dev/null
> +++ b/tests/btrfs/150
> @@ -0,0 +1,103 @@
> +#! /bin/bash
> +# FS QA Test btrfs/150
> +#
> +# This is a regression test which ends up with a kernel oops in btrfs.
> +# It occurs when btrfs's read repair happens while reading a compressed
> +# extent.
> +# The patch to fix it is
> +#	Btrfs: fix kernel oops while reading compressed data
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Oracle.  All Rights Reserved.
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
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_fail_make_request
> +_require_scratch_dev_pool 2 

Trailing whitespace in above line.

> +
> +SYSFS_BDEV=`_sysfs_dev $SCRATCH_DEV`
> +enable_io_failure()
> +{
> +        echo 100 > $DEBUGFS_MNT/fail_make_request/probability
> +        echo 1000 > $DEBUGFS_MNT/fail_make_request/times
> +        echo 0 > $DEBUGFS_MNT/fail_make_request/verbose
> +        echo 1 > $SYSFS_BDEV/make-it-fail
> +}
> +
> +disable_io_failure()
> +{
> +        echo 0 > $SYSFS_BDEV/make-it-fail
> +        echo 0 > $DEBUGFS_MNT/fail_make_request/probability
> +        echo 0 > $DEBUGFS_MNT/fail_make_request/times
> +}
> +
> +_scratch_pool_mkfs "-d raid1 -b 1G" >> $seqres.full 2>&1
> +
> +# It doesn't matter which compression algorithm we use.
> +_scratch_mount -ocompress
> +
> +# Create a file with all data being compressed
> +$XFS_IO_PROG -f -c "pwrite -W 0 8K" $SCRATCH_MNT/foobar | _filter_xfs_io
> +
> +# Raid1 consists of two copies and btrfs decides which copy to read by reader's
> +# %pid.  Now we inject errors to copy #1 and copy #0 is good.  We want to read
> +# the bad copy to trigger read-repair.
> +while [[ -z $result ]]; do
> +	# invalidate the page cache
> +	$XFS_IO_PROG -f -c "fadvise -d 0 8K" $SCRATCH_MNT/foobar

Does 'echo 3 > /proc/sys/vm/drop_caches' work?

Thanks,
Eryu

> +
> +	enable_io_failure
> +
> +	result=$(bash -c "
> +	if [ \$((\$\$ % 2)) == 1 ]; then
> +		echo 1 > /proc/\$\$/make-it-fail
> +		exec $XFS_IO_PROG -c \"pread 0 8K\" \$SCRATCH_MNT/foobar
> +	fi")
> +
> +	disable_io_failure
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/150.out b/tests/btrfs/150.out
> new file mode 100644
> index 0000000..c492c24
> --- /dev/null
> +++ b/tests/btrfs/150.out
> @@ -0,0 +1,3 @@
> +QA output created by 150
> +wrote 8192/8192 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 70c3f05..e73bb1b 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -152,3 +152,4 @@
>  147 auto quick send
>  148 auto quick rw
>  149 auto quick send compress
> +150 auto quick dangerous
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
