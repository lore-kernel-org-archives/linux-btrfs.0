Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46637 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3HFUn3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Aug 2013 16:43:29 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4EE109A06A2
	for <linux-btrfs@vger.kernel.org>; Tue,  6 Aug 2013 14:43:29 -0600 (MDT)
Date: Tue, 6 Aug 2013 16:43:25 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Schmidt <list.xfs@jan-o-sch.net>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>,
        <sbehrens@giantdisaster.de>
Subject: Re: [PATCH v2 2/2] xfstests btrfs/316: test send / receive
Message-ID: <20130806204325.GB2397@localhost.localdomain>
References: <1374678449-21780-1-git-send-email-list.xfs@jan-o-sch.net>
 <1374678449-21780-3-git-send-email-list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1374678449-21780-3-git-send-email-list.xfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 24, 2013 at 05:07:29PM +0200, Jan Schmidt wrote:
> Basic send / receive functionality test for btrfs. Requires current
> version of fsstress built (-x support). Relies on fssum tool but can
> skip the test if it failed to build.
> 
> Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
> ---
>  README              |    3 +
>  tests/btrfs/316     |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/316.out |    4 ++
>  tests/btrfs/group   |    1 +
>  4 files changed, 121 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/316
>  create mode 100644 tests/btrfs/316.out
> 
> diff --git a/README b/README
> index a49ca7c..d287f63 100644
> --- a/README
> +++ b/README
> @@ -26,6 +26,9 @@ Preparing system for tests (IRIX and Linux):
>        http://www.extra.research.philips.com/udf/, then copy the udf_test 
>        binary to xfstests/src/. If you wish to disable UDF verification test
>        set the environment variable DISABLE_UDF_TEST to 1.
> +    - If you wish to run the btrfs send / receive components of the suite
> +      install fssum from
> +        git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git
>  	
>      
>      - create one or two partitions to use for testing
> diff --git a/tests/btrfs/316 b/tests/btrfs/316
> new file mode 100755
> index 0000000..2e86428
> --- /dev/null
> +++ b/tests/btrfs/316
> @@ -0,0 +1,113 @@
> +#! /bin/bash
> +# FSQA Test No. 314
> +#
> +# Run fsstress to create a reasonably strange file system, make a
> +# snapshot (base) and run more fsstress. Then take another snapshot
> +# (incr) and send both snapshots to a temp file. Remake the file
> +# system and receive from the files. Check both states with fssum.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2013 STRATO.  All rights reserved.
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
> +# creator
> +owner=list.btrfs@jan-o-sch.net
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=`mktemp -d`
> +status=1
> +
> +_cleanup()
> +{
> +	echo "*** unmount"
> +	umount $SCRATCH_MNT 2>/dev/null
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_command $FSSUM_PROG fssum
> +
> +rm -f $seqres.full
> +
> +workout()
> +{
> +	fsz=$1
> +	ops=$2
> +
> +	umount $SCRATCH_DEV >/dev/null 2>&1
> +	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
> +	echo ""                                     >>$seqres.full
> +	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
> +		|| _fail "size=$fsz mkfs failed"
> +	run_check _scratch_mount "-o noatime"
> +
> +	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n $ops $FSSTRESS_AVOID -x \
> +		"$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/base"
> +
> +	run_check $BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/incr
> +
> +	echo "# $BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap" \
> +		>> $seqres.full
> +	$BTRFS_UTIL_PROG send $SCRATCH_MNT/base > $tmp/base.snap 2>> $seqres.full \
> +		|| _fail "failed: '$@'"
> +	echo "# $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base\
> +		$SCRATCH_MNT/incr > $tmp/incr.snap" >> $seqres.full
> +	$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/base \
> +		$SCRATCH_MNT/incr > $tmp/incr.snap 2>> $seqres.full \
> +		|| _fail "failed: '$@'"
> +
> +	run_check $FSSUM_PROG -A -f -w $tmp/base.fssum $SCRATCH_MNT/base
> +	run_check $FSSUM_PROG -A -f -w $tmp/incr.fssum -x $SCRATCH_MNT/incr/base \
> +		$SCRATCH_MNT/incr
> +
> +	umount $SCRATCH_DEV >/dev/null 2>&1
> +	echo "*** mkfs -dsize=$fsz"    >>$seqres.full
> +	echo ""                                     >>$seqres.full
> +	_scratch_mkfs_sized $fsz >>$seqres.full 2>&1 \
> +		|| _fail "size=$fsz mkfs failed"
> +	run_check _scratch_mount "-o noatime"
> +
> +	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/base.snap
> +	run_check $FSSUM_PROG -r $tmp/base.fssum $SCRATCH_MNT/base
> +
> +	run_check $BTRFS_UTIL_PROG receive $SCRATCH_MNT < $tmp/incr.snap
> +	run_check $FSSUM_PROG -r $tmp/incr.fssum $SCRATCH_MNT/incr
> +}
> +
> +echo "*** test send / receive"
> +
> +fssize=`expr 2000 \* 1024 \* 1024`
> +ops=200
> +
> +workout $fssize $ops
> +
> +echo "*** done"
> +status=0
> +exit
> diff --git a/tests/btrfs/316.out b/tests/btrfs/316.out
> new file mode 100644
> index 0000000..4564c85
> --- /dev/null
> +++ b/tests/btrfs/316.out
> @@ -0,0 +1,4 @@
> +QA output created by 316
> +*** test send / receive
> +*** done
> +*** unmount
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index bc6c256..11d708a 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -9,3 +9,4 @@
>  276 auto rw metadata
>  284 auto
>  307 auto quick
> +316 auto rw metadata

I applied and ran this locally and gave everything a look over, you can add

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
