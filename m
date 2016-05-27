Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50944 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755537AbcE0PmT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 11:42:19 -0400
Date: Fri, 27 May 2016 11:42:10 -0400
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs for 4.7, part 2
Message-ID: <20160527154210.illgoqxoyjhj7dbp@floor.thefacebook.com>
References: <cover.1464254502.git.dsterba@suse.com>
 <20160527001414.opeu5ffezblckpd4@floor.thefacebook.com>
 <20160527111822.GV29147@twin.jikos.cz>
 <20160527143527.bctpuav5la3vchu4@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160527143527.bctpuav5la3vchu4@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 10:35:27AM -0400, Chris Mason wrote:
> On Fri, May 27, 2016 at 01:18:22PM +0200, David Sterba wrote:
> > On Thu, May 26, 2016 at 08:14:14PM -0400, Chris Mason wrote:
> > > On Thu, May 26, 2016 at 11:27:06AM +0200, David Sterba wrote:
> > > > Hi,
> > > > 
> > > > please pull a few more patches that did not go to pull #1 for 4.7, minor
> > > > cleanups and fixes. Thanks.
> > > 
> > > Thanks Dave!  Trying to figure out why we're failing btrfs/011, but I
> > > don't see how it could be related to this bunch.  I'll nail it down.
> > 
> > 011 passes here, there are some unrelated soft-failures (mismatching
> > output with new progs). I'm now testing a branch without "btrfs: scrub:
> > Set bbio to NULL before calling btrfs_map_block", that seems to be the
> > only likely offender.
> 
> I'm getting errors from btrfs fi show -d, after the very last round of
> device replaces.  A little extra debugging:
> 
> bytenr mismatch, want=4332716032, have=0
> ERROR: cannot read chunk root
> ERROR reading /dev/vdh
> failed /dev/vdh
> 
> Which is cute because the very next command we run fscks /dev/vdh and
> succeeds.
> 
> So the page cache is stale and this isn't related to any of our patches.

close_ctree() calls into btrfs_close_devices(), which calls
btrfs_close_one_device(), which uses:

call_rcu(&device->rcu, free_device);

close_ctree() also does an rcu_barrier() to make sure and wait for
free_device() to finish.

But, free_device() just puts the work into schedule_work(), so we don't
know for sure the blkdev_put is done when we exit.

It's been this way for a while, so its not holding up my pull request to
Linus.  But I'll fix it up.

-chris

