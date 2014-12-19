Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21815 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLSJ3n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 04:29:43 -0500
Date: Fri, 19 Dec 2014 17:29:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] xfstests: btrfs: add test case for qgroup account on
 shared extents
Message-ID: <20141219092931.GC10451@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1418723004-30543-1-git-send-email-bo.li.liu@oracle.com>
 <1418977902-25174-1-git-send-email-bo.li.liu@oracle.com>
 <5493EE1A.7060008@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5493EE1A.7060008@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Satoru san,
On Fri, Dec 19, 2014 at 06:21:30PM +0900, Satoru Takeuchi wrote:
> Hi Liu,
> 
> On 2014/12/19 17:31, Liu Bo wrote:
> > This is a regression test of
> > 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")',
> > it's used to verify that removing shared extents can end up incorrect
> > qgroup accounting.
> > 
> > It can produce qgroup related warnings.
> > 
> > The fix is https://patchwork.kernel.org/patch/5499981/
> > "Btrfs: fix a warning of qgroup account on shared extents"
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> V4 also passed my test,

Thanks for your active testing!

Thanks,

-liubo

> 
> Thanks,
> Satoru
> 
> > Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> > Reviewed-by: Eryu Guan <eguan@redhat.com>
> > ---
> > v4: - remove inproper run_check macro and add filter macro for xfs_io
> >      - use awk's regexp directly
> >      - add test case description
> > 
> > v3: - remove trailing whilespace.
> >      - add the fix link for more details of the problem.
> > 
> > v2: - use new seq number 017 instead 080
> >      - use 'cloner' to get shared extents
> >      - use XFS_IO_PROG instead
> > 
> >   tests/btrfs/017     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >   tests/btrfs/017.out |  5 ++++
> >   tests/btrfs/group   |  1 +
> >   3 files changed, 88 insertions(+)
> >   create mode 100755 tests/btrfs/017
> >   create mode 100644 tests/btrfs/017.out
> > 
> > diff --git a/tests/btrfs/017 b/tests/btrfs/017
> > new file mode 100755
> > index 0000000..7937607
> > --- /dev/null
> > +++ b/tests/btrfs/017
> > @@ -0,0 +1,82 @@
> > +#! /bin/bash
> > +# FS QA Test No. 017
> > +#
> > +# Verify that removing shared extents can end up incorrect qgroup accounting.
> > +#
> > +# Regression of 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")',
> > +# this will throw a warning into dmesg.
> > +#
> > +# The issue is fixed by https://patchwork.kernel.org/patch/5499981/
> > +# "Btrfs: fix a warning of qgroup account on shared extents"
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2014 Liu Bo.  All Rights Reserved.
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
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +
> > +_need_to_be_root
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +_require_cloner
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs "--nodesize 4096"
> > +_scratch_mount
> > +
> > +$XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo | _filter_xfs_io
> > +
> > +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
> > +
> > +$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
> > +$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink
> > +$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink2
> > +
> > +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> > +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> > +
> > +rm -fr $SCRATCH_MNT/foo*
> > +rm -fr $SCRATCH_MNT/snap/foo*
> > +
> > +sync
> > +
> > +$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $AWK_PROG '/[0-9]/ {print $2" "$3}'
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/btrfs/017.out b/tests/btrfs/017.out
> > new file mode 100644
> > index 0000000..7658e2e
> > --- /dev/null
> > +++ b/tests/btrfs/017.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 017
> > +wrote 8192/8192 bytes at offset 0
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +4096 4096
> > +4096 4096
> > diff --git a/tests/btrfs/group b/tests/btrfs/group
> > index abb2fe4..e29999b 100644
> > --- a/tests/btrfs/group
> > +++ b/tests/btrfs/group
> > @@ -19,6 +19,7 @@
> >   014 auto balance
> >   015 auto quick snapshot
> >   016 auto quick send
> > +017 auto quick qgroup
> >   018 auto quick subvol
> >   019 auto quick send
> >   020 auto quick replace
> > 
> 
