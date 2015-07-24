Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23550 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbbGXRw3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 13:52:29 -0400
Date: Fri, 24 Jul 2015 10:52:22 -0700
From: Omar Sandoval <osandov@fb.com>
To: Eryu Guan <eguan@redhat.com>
CC: <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Subject: Re: [PATCH 3/3] btrfs: add a test of replace missing dev in diff raid
Message-ID: <20150724175222.GB14974@huxley.DHCP.TheFacebook.com>
References: <cover.1437683940.git.osandov@fb.com>
 <74be00ec0764de749fe43c1e4b20cc2cc35a4671.1437683940.git.osandov@fb.com>
 <20150724032832.GO3945@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150724032832.GO3945@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2015 at 11:28:32AM +0800, Eryu Guan wrote:
> On Thu, Jul 23, 2015 at 01:51:51PM -0700, Omar Sandoval wrote:
> > From: Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
> > 
> > Test of missing device replace in different raid modes.  This
> > test requires SCRATCH_DEV_POOL contain 5 same size devices.
> > 
> > This issue has been fixed by Omar's patch:
> > 	Btrfs: RAID 5/6 missing device scrub+replace
> > 
> > Signed-off-by: Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  tests/btrfs/095     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/095.out |  2 ++
> >  tests/btrfs/group   |  1 +
> >  3 files changed, 96 insertions(+)
> >  create mode 100755 tests/btrfs/095
> >  create mode 100644 tests/btrfs/095.out
> > 
> > diff --git a/tests/btrfs/095 b/tests/btrfs/095
> > new file mode 100755
> > index 000000000000..2dfb919fe4f6
> > --- /dev/null
> > +++ b/tests/btrfs/095
> > @@ -0,0 +1,93 @@
> > +#! /bin/bash
> > +# FS QA Test No. btrfs/095
> > +#
> > +# Test of missing device replace in different raid mode
> > +#
> > +# Be sure $SCRATCH_DEV_POOL including 5 devices. And all
> > +# devices in pool must be in the same size.
> > +#
> > +# To check the fs after replacing a dev, a scrub run is performed.
> > +#
> > +# This issue has been fixed by Omar Sandoval's patch:
> > +# 	Btrfs: RAID 5/6 missing device scrub+replace
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
> > +# Author: Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +status=1
> > +trap "exit \$status" 0 1 2 3 15
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_need_to_be_root
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +_require_scratch_dev_pool 5
> 
> Need a call of _require_scratch_dev_pool_equal_size here
> 
> > +_btrfs_get_profile_configs replace-missing
> > +
> > +rm -f $seqres.full
> > +
> > +REPLACE_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $5}'`
> > +export SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{print $1,$2,$3,$4}'`
> > +
> > +run_test () {
> > +	local mkfs_opts=$1
> 
> echo the $mkfs_opts to $seqres.full is useful for debug purpose, so if
> some profile config fails we know what config is failing.
> 
> echo "Test $mkfs_opts" >>$seqres.full
> 
> > +	_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1 || _fail "mkfs failed"
> 
> Continue to test next profile config if mkfs failed, _fail breaks out
> the whole test.
> 
> > +	_scratch_mount
> > +
> > +	PRUNE_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
> > +	PRUNE_DEV_ID=`$BTRFS_UTIL_PROG fi show $SCRATCH_MNT | grep $PRUNE_DEV | awk '{print $2}'`
> > +
> > +	# dd some data
> > +	dd if=/dev/urandom of="$SCRATCH_MNT"/file1 bs=1M count=1 \
> > +		>>$seqres.full 2>&1 || _fail "dd failed"
> > +	dd if=/dev/urandom of="$SCRATCH_MNT"/file2 bs=1M count=2 \
> > +		>>$seqres.full 2>&1 || _fail "dd failed"
> > +	dd if=/dev/urandom of="$SCRATCH_MNT"/file3 bs=1M count=4 \
> > +		>>$seqres.full 2>&1 || _fail "dd failed"
> 
> I don't think the _fail here is necessary either.
> 
> > +
> > +	# prune the device PRUNE_DEV && remount by degraded mode
> > +	umount $SCRATCH_MNT
> 
> _scratch_unmount
> 
> > +	dd if=/dev/zero of=$PRUNE_DEV bs=1M count=1 >>$seqres.full 2>&1 \
> > +		|| _fail "dd failed"
> 
> $WIPEFS_PROG -a $PRUNE_DEV ?
> 
> > +	mount -o degraded $SCRATCH_DEV $SCRATCH_MNT
> 
> _scratch_mount "-o degraded"
> 
> > +
> > +	# replace the missing dev $PRUNE_DEV with $REPLACE_DEV and scrub it
> > +	$BTRFS_UTIL_PROG replace start -B -r $PRUNE_DEV_ID $REPLACE_DEV \
> > +		$SCRATCH_MNT -f >>$seqres.full 2>&1 || _fail "replace failed"
> 
> Don't _fail here, just echo error messages to break golden image. Better
> to append the error message to $seqres.full too, for debug purpose.
> 
> > +	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >>$seqres.full 2>&1 \
> > +		|| _fail "scrub failed"
> 
> Here too.
> 
> > +
> > +	umount $SCRATCH_MNT
> 
> _scratch_unmount
> 
> > +}
> > +
> > +echo "Silence is golden"
> > +for t in "${_btrfs_profile_configs[@]}"; do
> > +	run_test "$t"
> > +done
> > +
> > +status=0
> > +exit
> > diff --git a/tests/btrfs/095.out b/tests/btrfs/095.out
> > new file mode 100644
> > index 000000000000..80ad3b9c2a7b
> > --- /dev/null
> > +++ b/tests/btrfs/095.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 095
> > +Silence is golden
> > diff --git a/tests/btrfs/group b/tests/btrfs/group
> > index ffe18bff0d21..f20a191c24be 100644
> > --- a/tests/btrfs/group
> > +++ b/tests/btrfs/group
> > @@ -96,3 +96,4 @@
> >  092 auto quick send
> >  093 auto quick clone
> >  094 auto quick send
> > +095 auto
> 
> Should also be in "replace" group.
> 
> Thanks,
> Eryu

Thanks for reviewing, I'll fix this all up in a v2.

-- 
Omar
