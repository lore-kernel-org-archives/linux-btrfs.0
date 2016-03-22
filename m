Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcCVEAP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 00:00:15 -0400
Date: Tue, 22 Mar 2016 12:00:13 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] fstest: btrfs: test single 4k extent after
 subpagesize buffered writes
Message-ID: <20160322040013.GH11419@eguan.usersys.redhat.com>
References: <1457396879-30572-1-git-send-email-bo.li.liu@oracle.com>
 <1458255398-26833-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458255398-26833-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 17, 2016 at 03:56:38PM -0700, Liu Bo wrote:
> This is to test if COW enabled btrfs can end up with single 4k extents
> when doing subpagesize buffered writes.

What happens if btrfs is mounted with "nodatacow" option? Does it need
to _notrun if cow is disabled?

> 
> The patch to fix the problem is
>   https://patchwork.kernel.org/patch/8527991/
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: - Teach awk to know system's pagesize.
>     - Add "Silence is golden" to output.
>     - Use local variables to lower case.
>     - Add comments to make code clear.

This should be v3, and this patch was buried in the v2 thread :)

> 
>  tests/btrfs/027     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/027.out |   2 ++
>  tests/btrfs/group   |   1 +
>  3 files changed, 105 insertions(+)
>  create mode 100755 tests/btrfs/027
>  create mode 100644 tests/btrfs/027.out
> 
> diff --git a/tests/btrfs/027 b/tests/btrfs/027
> new file mode 100755
> index 0000000..19d324b
> --- /dev/null
> +++ b/tests/btrfs/027
> @@ -0,0 +1,102 @@
> +#! /bin/bash
> +# FS QA Test 027
> +#
> +# When btrfs is using cow mode, buffered writes of sub-pagesize can end up with
> +# single 4k extents.
> +# Ref:
> +#     "Stray 4k extents with slow buffered writes"
> +#     https://www.spinics.net/lists/linux-btrfs/msg52628.html

After going through this thread, my understanding is that nodatacow
btrfs should pass this test even on unpatched kernel (e.g. v4.5). But
my test on v4.5 kernel failed with nodatacow mount option, pagesize
extent is still found.

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Liu Bo.  All Rights Reserved.
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
> +
> +	# restore expire
> +	echo $default_expire > /proc/sys/vm/dirty_expire_centisecs
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +echo "Silence is golden"
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_io_command "fiemap"
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +default_expire=`cat /proc/sys/vm/dirty_expire_centisecs`
> +# Make it flush dirty pages more frequently to make sure we reproduce the bug.
> +echo 50 > /proc/sys/vm/dirty_expire_centisecs
> +
> +tfile=$SCRATCH_MNT/testfile
> +pagesize=$(get_page_size)
> +sublen=$((RANDOM % pagesize))
> +
> +$XFS_IO_PROG -f -c "pwrite 0 $pagesize" $tfile > /dev/null 2>&1
> +# write some subpagesize data first.
> +$XFS_IO_PROG -c "pwrite $pagesize $sublen" $tfile > /dev/null 2>&1
> +
> +# Mix up "abnormal" subpagesize writes with normal pagesize based writes
> +toff=$((pagesize + sublen))
> +for ((i = 0; i < 10000; i++))
> +do
> +	tlen=$pagesize
> +	if [ $((i % 2)) = 0 ]; then
> +		tlen=$((pagesize * 3))
> +	fi
> +	if [ $((i % 1000)) = 0 ]; then
> +		tlen=$((RANDOM % pagesize))
> +	fi
> +
> +	$XFS_IO_PROG -c "pwrite $toff $tlen" $tfile > /dev/null 2>&1
> +	toff=$((toff + tlen))
> +done

fstests prefers this format:

for ...; do
	...
done

Thanks,
Eryu

> +
> +sync
> +
> +# check for single PAGESIZE extent
> +$XFS_IO_PROG -c "fiemap -v" $tfile >> $seqres.full 2>&1
> +$XFS_IO_PROG -c "fiemap -v" $tfile | \
> +awk -v pgsize=$pagesize '{n = pgsize/512; if ($4 == n) print $4}'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/027.out b/tests/btrfs/027.out
> new file mode 100644
> index 0000000..ef78cda
> --- /dev/null
> +++ b/tests/btrfs/027.out
> @@ -0,0 +1,2 @@
> +QA output created by 027
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index a2fa412..f06d5fe 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -29,6 +29,7 @@
>  024 auto quick compress
>  025 auto quick send clone
>  026 auto quick compress prealloc
> +027 auto
>  029 auto quick clone
>  030 auto quick send
>  031 auto quick subvol clone
> -- 
> 2.5.0
> 
