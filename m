Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbcF0J3S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 05:29:18 -0400
Date: Mon, 27 Jun 2016 17:29:16 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/6] fstests: btrfs: test RAID1 device reappear and
 balanced
Message-ID: <20160627092916.GU23649@eguan.usersys.redhat.com>
References: <1463495530-425-5-git-send-email-anand.jain@oracle.com>
 <1465980527-19031-1-git-send-email-anand.jain@oracle.com>
 <20160621133137.GY5140@eguan.usersys.redhat.com>
 <e4fb70f9-2e96-1c32-fbe7-0c1fa4cf8b95@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e4fb70f9-2e96-1c32-fbe7-0c1fa4cf8b95@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 22, 2016 at 07:01:54PM +0800, Anand Jain wrote:
> 
> 
> On 06/21/2016 09:31 PM, Eryu Guan wrote:
> > On Wed, Jun 15, 2016 at 04:48:47PM +0800, Anand Jain wrote:
> > > From: Anand Jain <Anand.Jain@oracle.com>
> > > 
> > > The test does the following:
> > >   Initialize a RAID1 with some data
> > > 
> > >   Re-mount RAID1 degraded with _dev1_ and write up to
> > >   half of the FS capacity
> > 
> > If test devices are big enough, this test consumes much longer test
> > time. I tested with 15G scratch dev pool and this test ran ~200s on my
> > 4vcpu 8G memory test vm.
> 
>  Right. Isn't that a good design? So that it gets tested differently
>  on different HW config. ?

Not in fstests. We should limit the run time of tests to an acceptable
amount, for auto group it's within 5 minutes.

>  However the test time can be reduced by using smaller vdisk.

I think either limit the write size or _notrun if the $max_fs_size is
too big (say 30G).

More comments below.

> 
> Thanks, Anand
> 
> 
> > Is it possible to limit the file size or the device size used? So it
> > won't grow with device size. I'm thinking about something like
> > _scratch_mkfs_sized, but that doesn't work for dev pool.
> > 
> > >   Save md5sum checkpoint1
> > > 
> > >   Re-mount healthy RAID1
> > > 
> > >   Let balance re-silver.
> > >   Save md5sum checkpoint2
> > > 
> > >   Re-mount RAID1 degraded with _dev2_
> > >   Save md5sum checkpoint3
> > > 
> > >   Verify if all three md5sum match
> > > 
> > > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > > ---
> > > v2:
> > >   add tmp= and its rm
> > >   add comments to why _reload_btrfs_ko is used
> > >   add missing put and test_mount at notrun exit
> > >   use echo instead of _fail when checkpoints are checked
> > >   .out updated to remove Silence..
> > > 
> > >  tests/btrfs/123     | 169 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/btrfs/123.out |   7 +++
> > >  tests/btrfs/group   |   1 +
> > >  3 files changed, 177 insertions(+)
> > >  create mode 100755 tests/btrfs/123
> > >  create mode 100644 tests/btrfs/123.out
> > > 
> > > diff --git a/tests/btrfs/123 b/tests/btrfs/123
> > > new file mode 100755
> > > index 000000000000..33decfd1c434
> > > --- /dev/null
> > > +++ b/tests/btrfs/123
> > > @@ -0,0 +1,169 @@
> > > +#! /bin/bash
> > > +# FS QA Test 123
> > > +#
> > > +# This test verify the RAID1 reconstruction on the reappeared
> > > +# device. By using the following steps:
> > > +# Initialize a RAID1 with some data
> > > +#
> > > +# Re-mount RAID1 degraded with dev2 missing and write up to
> > > +# half of the FS capacity.
> > > +# Save md5sum checkpoint1
> > > +#
> > > +# Re-mount healthy RAID1
> > > +#
> > > +# Let balance re-silver.
> > > +# Save md5sum checkpoint2
> > > +#
> > > +# Re-mount RAID1 degraded with dev1 missing
> > > +# Save md5sum checkpoint3
> > > +#
> > > +# Verify if all three checkpoints match
> > > +#
> > > +#---------------------------------------------------------------------
> > > +# Copyright (c) 2016 Oracle.  All Rights Reserved.
> > > +#
> > > +# This program is free software; you can redistribute it and/or
> > > +# modify it under the terms of the GNU General Public License as
> > > +# published by the Free Software Foundation.
> > > +#
> > > +# This program is distributed in the hope that it would be useful,
> > > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +# GNU General Public License for more details.
> > > +#
> > > +# You should have received a copy of the GNU General Public License
> > > +# along with this program; if not, write the Free Software Foundation,
> > > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > > +#---------------------------------------------------------------------
> > > +#
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +
> > > +_supported_fs btrfs
> > > +_supported_os Linux
> > > +_require_scratch_nocheck
> > 
> > Why don't check filesystem after test? A comment would be good if
> > there's a good reason. Patch 6 needs it as well :)

And can you please add comments on _require_scratch_nocheck in this
patch and patch 6, and rebase the whole series after Dave pushed my
pull request(on 06-25) to upstream, and resend?

Thanks,
Eryu

> > 
> > > +_require_scratch_dev_pool 2
> > > +
> > > +# the mounted test dir prevent btrfs unload, we need to unmount
> > > +_test_unmount
> > > +_require_btrfs_loadable
> > > +
> > > +_scratch_dev_pool_get 2
> > > +
> > > +dev1=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
> > > +dev2=`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
> > > +
> > > +dev1_sz=`blockdev --getsize64 $dev1`
> > > +dev2_sz=`blockdev --getsize64 $dev2`
> > > +# get min of both
> > > +max_fs_sz=`echo -e "$dev1_sz\n$dev2_sz" | sort | head -1`
> > > +max_fs_sz=$(( max_fs_sz/2 ))
> > > +if [ $max_fs_sz -gt 1000000 ]; then
> > > +	bs="1M"
> > > +	count=$(( max_fs_sz/1000000 ))
> > > +else
> > > +	max_fs_sz=$(( max_fs_sz*2 ))
> > > +	_scratch_dev_pool_put
> > > +	_test_mount
> > > +	_notrun "Smallest dev size $max_fs_sz, Need at least 2M"
> > > +fi
> > > +
> > > +echo >> $seqres.full
> > > +echo "max_fs_sz=$max_fs_sz count=$count" >> $seqres.full
> > > +echo "-----Initialize -----" >> $seqres.full
> > > +_scratch_pool_mkfs "-mraid1 -draid1" >> $seqres.full 2>&1
> > > +_scratch_mount >> $seqres.full 2>&1
> > > +_run_btrfs_util_prog filesystem show
> > > +dd if=/dev/zero of="$SCRATCH_MNT"/tf1 bs=$bs count=1 \
> > > +					>>$seqres.full 2>&1
> > > +count=$(( count-- ))
> > > +echo "unmount" >> $seqres.full
> > > +echo "clean btrfs ko" >> $seqres.full
> > > +_scratch_unmount
> > > +
> > > +# un-scan the btrfs devices
> > > +_reload_btrfs_ko
> > > +
> > > +
> > > +echo >> $seqres.full
> > > +echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
> > > +echo
> > > +echo "Write data with degraded mount"
> > > +# Since we didn't run dev scan, btrfs kernel does not know
> > > +# about the dev2
> > > +# don't use _scratch_mount as we want to control
> > > +# the device used for mounting.
> > > +
> > > +_mount -o degraded $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
> > > +_run_btrfs_util_prog filesystem show
> > > +dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
> > > +					>>$seqres.full 2>&1
> > > +checkpoint1=`md5sum $SCRATCH_MNT/tf2`
> > > +echo $checkpoint1 >> $seqres.full 2>&1
> > > +_scratch_unmount
> > > +echo "unmount" >> $seqres.full
> > > +
> > > +echo >> $seqres.full
> > > +echo "-----Mount normal-----" >> $seqres.full
> > > +echo
> > > +echo "Mount normal after balance"
> > > +_run_btrfs_util_prog device scan
> > > +_scratch_mount >> $seqres.full 2>&1
> > > +_run_btrfs_util_prog filesystem show
> > > +echo >> $seqres.full
> > > +_run_btrfs_util_prog balance start ${SCRATCH_MNT}
> > > +
> > > +checkpoint2=`md5sum $SCRATCH_MNT/tf2`
> > > +echo $checkpoint2 >> $seqres.full 2>&1
> > > +
> > > +echo >> $seqres.full
> > > +echo "-----Mount degraded but with other dev -----" >> $seqres.full
> > > +echo
> > > +echo "Mount degraded but with other dev"
> > > +_scratch_unmount
> > > +# un-scan the btrfs devices
> > > +_reload_btrfs_ko
> > > +_mount -o degraded $dev2 $SCRATCH_MNT >>$seqres.full 2>&1
> > > +_run_btrfs_util_prog filesystem show
> > > +checkpoint3=`md5sum $SCRATCH_MNT/tf2`
> > > +echo $checkpoint3 >> $seqres.full 2>&1
> > > +
> > > +if [ "$checkpoint1" != "$checkpoint2" ]; then
> > > +	echo $checkpoint1
> > > +	echo $checkpoint2
> > > +	echo "Inital sum does not match with after balance"
> > > +fi
> > > +
> > > +if [ "$checkpoint1" != "$checkpoint3" ]; then
> > > +	echo $checkpoint1
> > > +	echo $checkpoint3
> > > +	echo "Inital sum does not match with data on dev2 written by balance"
> > > +fi
> > > +
> > > +_scratch_dev_pool_put
> > > +_test_mount
> > > +
> > > +status=0
> > > +exit
> > > diff --git a/tests/btrfs/123.out b/tests/btrfs/123.out
> > > new file mode 100644
> > > index 000000000000..1aa77036b55b
> > > --- /dev/null
> > > +++ b/tests/btrfs/123.out
> > > @@ -0,0 +1,7 @@
> > > +QA output created by 123
> > > +
> > > +Write data with degraded mount
> > > +
> > > +Mount normal after balance
> > > +
> > > +Mount degraded but with other dev
> > > diff --git a/tests/btrfs/group b/tests/btrfs/group
> > > index da0e27fa308d..1c4bfa8dbc96 100644
> > > --- a/tests/btrfs/group
> > > +++ b/tests/btrfs/group
> > > @@ -124,3 +124,4 @@
> > >  120 auto quick snapshot metadata
> > >  121 auto quick snapshot qgroup
> > >  122 auto quick snapshot qgroup
> > > +123 auto replace
> > > --
> > > 2.7.0
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
