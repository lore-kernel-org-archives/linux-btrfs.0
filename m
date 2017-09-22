Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30338 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdIVThg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 15:37:36 -0400
Date: Fri, 22 Sep 2017 12:33:49 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs/150 regression test for reading
 compressed data
Message-ID: <20170922193348.GC8109@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170920235243.11822-1-bo.li.liu@oracle.com>
 <20170921043952.GQ10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170921043952.GQ10621@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 21, 2017 at 02:39:52PM +1000, Dave Chinner wrote:
> On Wed, Sep 20, 2017 at 05:52:43PM -0600, Liu Bo wrote:
> > We had a bug in btrfs compression code which could end up with a
> > kernel panic.
> > 
> > This is adding a regression test for the bug and I've also sent a
> > kernel patch to fix the bug.
> > 
> > The patch is "Btrfs: fix kernel oops while reading compressed data".
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  tests/btrfs/150     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/150.out |   3 ++
> >  tests/btrfs/group   |   1 +
> >  3 files changed, 106 insertions(+)
> >  create mode 100755 tests/btrfs/150
> >  create mode 100644 tests/btrfs/150.out
> > 
> > diff --git a/tests/btrfs/150 b/tests/btrfs/150
> > new file mode 100755
> > index 0000000..834be51
> > --- /dev/null
> > +++ b/tests/btrfs/150
> > @@ -0,0 +1,102 @@
> > +#! /bin/bash
> > +# FS QA Test btrfs/150
> > +#
> > +# This is a regression test which ends up with a kernel oops in btrfs.
> 
> group += dangerous

OK.

> 
> > +# It occurs when btrfs's read repair happens while reading a compressed
> > +# extent.
> > +# The patch for this is 
> > +# xxxxx
> 
> Incomplete?

Urr, thanks for pointing it out.

> 
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
> 
> You're signing off this patch an Oracle employee, but claiming
> personal copyright. Please clarify who owns the copyright - if it's
> your personal copyright then please sign off with a personal email
> address, not your employer's...
> 
> Also, I note that these recently added tests from you:
> 
> tests/btrfs/140:# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
> tests/btrfs/141:# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
> tests/btrfs/142:# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
> tests/btrfs/143:# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
> tests/generic/406:# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
> 
> all have this same ambiguity - personal copyright with employer
> signoff in the commit. This definitely needs clarification and
> fixing if it is wrong....
>

All right, will fix all of them (in a separate one).

> 
> > +disable_io_failure()
> > +{
> > +        echo 0 > $SYSFS_BDEV/make-it-fail
> > +        echo 0 > $DEBUGFS_MNT/fail_make_request/probability
> > +        echo 0 > $DEBUGFS_MNT/fail_make_request/times
> > +}
> > +
> > +_scratch_pool_mkfs "-d raid1 -b 1G" >> $seqres.full 2>&1
> > +
> > +# It doesn't matter which compression algorithm we use.
> > +_scratch_mount -ocompress
> > +
> > +# Create a file with all data being compressed
> > +$XFS_IO_PROG -f -c "pwrite -W 0 8K" $SCRATCH_MNT/foobar | _filter_xfs_io
> 
> needs an fsync to reach disk.

'pwrite -W' has ensured that.

> 
> > +# Raid1 consists of two copies and btrfs decides which copy to read by reader's
> > +# %pid.  Now we inject errors to copy #1 and copy #0 is good.  We want to read
> > +# the bad copy to trigger read-repair.
> > +while true; do
> > +	disable_io_failure
> > +	# invalidate the page cache
> > +	$XFS_IO_PROG -f -c "fadvise -d 0 128K" $SCRATCH_MNT/foobar | _filter_xfs_io
> > +
> > +	enable_io_failure
> > +	od -x $SCRATCH_MNT/foobar > /dev/null &
> 
> why are you using od to read the data when the output is piped to
> dev/null? why not just xfs_io -c "pread 0 8k" ?

Oh yes, that's better, will do.

thanks,

-liubo
