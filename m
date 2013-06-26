Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59503 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3FZPuO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 11:50:14 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D7FA87C0353
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 09:50:13 -0600 (MDT)
Date: Wed, 26 Jun 2013 11:50:11 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Dave Chinner <david@fromorbit.com>
CC: Eric Sandeen <sandeen@redhat.com>, Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [BULK]  Re: [PATCH] xfstests: unmount scratch mnt in test 307
Message-ID: <20130626155011.GN4288@localhost.localdomain>
References: <1367611895-6852-1-git-send-email-jbacik@fusionio.com>
 <51841AC5.3090309@redhat.com>
 <20130503232721.GA19978@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130503232721.GA19978@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 03, 2013 at 07:27:21PM -0400, Dave Chinner wrote:
> On Fri, May 03, 2013 at 03:15:01PM -0500, Eric Sandeen wrote:
> > On 5/3/13 3:11 PM, Josef Bacik wrote:
> > > So if you have a mount command that doesn't use /etc/mtab then it will spit out
> > > a different device for the mounted device.  So say we have
> > > 
> > > SCRATCH_DEV_POOL="/dev/sda /dev/sdb /dev/sdc"
> > > 
> > > we will turn this into
> > > 
> > > SCRATCH_DEV="/dev/sda"
> > > SCRATCH_DEV_POOL="/dev/sdb /dev/sdc"
> > > 
> > > and then when you mkfs this you do _scratch_mkfs $SCRATCH_DEV_POOL which turns
> > > into this
> > > 
> > > mkfs.btrfs /dev/sdb /dev/sdc /dev/sda
> > > 
> > > becuase we do
> > > 
> > > mkfs $* $SCRATCH_DEV
> > > 
> > > Then btrfs will always show the lowest devid in /proc/mounts to maintain
> > > consistency, so even though we do mount /dev/sda $SCRATCH_MNT, you will see
> > > /dev/sdb as the mounted device in /proc/mounts.  So then say the next test wants
> > > to just use $SCRATCH_DEV, it will do _require_scratchdev which will check to see
> > > if $SCRATCH_DEV is mounted, which it will look like it is not because
> > > /proc/mounts shows /dev/sdb instead of /dev/sda, and so it won't umount
> > > $SCRATCH_MNT, and then that test will fail because we can't mkfs the device
> > > because it is busy.  I reproduced this on a box that doesn't use /etc/mtab by
> > > doing
> > > 
> > > ./check btrfs/307 generic/015
> > > 
> > > and 015 would fail.  With this patch it passes now.  Thanks,
> > > 
> > > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > > ---
> > >  tests/btrfs/307 |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/tests/btrfs/307 b/tests/btrfs/307
> > > index 87314c6..15157b3 100644
> > > --- a/tests/btrfs/307
> > > +++ b/tests/btrfs/307
> > > @@ -35,6 +35,7 @@ _cleanup()
> > >  {
> > >      cd /
> > >      rm -f $tmp.*
> > > +    umount $SCRATCH_MNT
> > >  }
> > >  
> > >  # get standard environment, filters and checks
> > > 
> > 
> > This seems fine for this particular test.
> > 
> > Is it really a hard requirement that each test unmount SCRATCH_[DEV|MNT] if it used it?
> > If so, fine... the README does indicate this.
> > 
> > But I wonder if we can make it a little more foolproof by updating _require_scratch
> > to handle this situation more gracefully?
> 
> It already tries to unmount $SCRATCH_DEV, and will through an error
> if it's not mounted on $SCRATCH_MNT. I guess the opposite checks are
> necessary in this case i.e. check that SCRATCH_MNT is not mounted,
> and through an error if it's not SCRATCH_DEV that is mounted
> there...
> 

Just realized this never went in and I had forgotten to address y'alls comments,
so I've sent another patch that accomplishes what you asked for and fixes my
problem.  Thanks,

Josef
