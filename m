Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:41704 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbbBPVLb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 16:11:31 -0500
Date: Tue, 17 Feb 2015 08:10:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic test for fsync followed by truncate and
 link
Message-ID: <20150216211056.GJ12722@dastard>
References: <1423831674-25678-1-git-send-email-fdmanana@suse.com>
 <20150216003337.GG12722@dastard>
 <20150216041957.GA32547@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150216041957.GA32547@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 16, 2015 at 12:19:58PM +0800, Liu Bo wrote:
> On Mon, Feb 16, 2015 at 11:33:37AM +1100, Dave Chinner wrote:
> > On Fri, Feb 13, 2015 at 12:47:54PM +0000, Filipe Manana wrote:
> > > This test is motivated by an fsync issue discovered in btrfs.
> > > The issue was that we could lose file data, that was previously fsync'ed
> > > successfully, if we end up shrinking (via truncate) the file, add a hard
> > > link to our file and then persist the fsync log later via an fsync of
> > > other inode for example. After a power loss our file content wouldn't
> > > match what it had when we last fsync'ed, but instead it had the data
> > > prior to that fsync.
> > 
> > Prior to which fsync?
> > 
> > XFS has strictly ordered metadata journalling, which means
> > transactions committed prior to *any* fsync will be present on disk
> > after the fsync. ext4 is not quite so strict, but has essentially
> > the same behaviour. ext3 in ordered mode behaves like XFS.
> > 
> > As such, ext3, ext4 and XFS return the state of the file as "0xaa for
> > 0 to 5k, 0x00 out to 32k" and the hardlink foo_link is present after
> > the filesystem is remounted and the log replayed.
> 
> But xfs doesn't work as above, something wrong?  

Maybe. I didn't check the exact output XFS or ext4 were giving, just
that is was different to what the test expected.

XFS and ext4 also behave differently w.r.t. data vs metadata
ordering, so there's a good change what you see here is the XFS
metadata being written, but not the corresponding block zeroing
that occurred on extenstion....

> -------------------------------------
> cat xfs/generic/044.out.bad
....
> File content after:
> 0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> *
> 0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> *
> 0100000

So the truncate down to 5k should have resulted in zeros past 5k,
but the zeros only start at 8k. Yup, that looks like setattr didn't
flush the zeroed tail page on truncate up. I'll have a further look
at that. Thanks for the head's up!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
