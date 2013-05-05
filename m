Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:51160 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956Ab3EEBpo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 May 2013 21:45:44 -0400
Date: Sun, 5 May 2013 11:45:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [3.9] parallel fsmark perf is real bad on sparse devices
Message-ID: <20130505014540.GF19978@dastard>
References: <20130504011547.GB19978@dastard>
 <20130504112005.5844.26279@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130504112005.5844.26279@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 04, 2013 at 07:20:05AM -0400, Chris Mason wrote:
> Quoting Dave Chinner (2013-05-03 21:15:47)
> > Hi folks,
> > 
> > It's that time again - I ran fsmark on btrfs and found performance
> > was awful.
> > 
> > tl;dr: memory pressure causes random writeback of metadata ("bad"),
> > fragmenting the underlying sparse storage. This causes a downward
> > spiral as btrfs cycles through "good" IO patterns that get
> > fragmented at the device level due to the "bad" IO patterns
> > fragmenting the underlying sparse device.
> > 
> 
> Really interesting Dave, thanks for all this analysis.
> 
> We're going to have hard time matching xfs fragmentation just because
> the files are zero size and we don't have the inode tables.  But, I'll
> take a look at the metadata memory pressure based writeback, sounds like
> we need to push a bigger burst.

Yeah, I wouldn't expect it to behave like XFS does given all the
metadata writeback ordering optimisation XFS has, but the level of
fragmentation was a surprise. Fragmentation by itself isn't so much
of a problem - ext4 is just as bad as btrfs in terms of the amount of
image fragmentation, but it doesn't have the 100:1 IOPS explosion in
the backing device.

Run the test and have a look at the iowatcher movies - they
are quite instructive as they show the two separate phases
that write alternately over the same sections of the disk. A
picture^Wmovie is worth a thousand words ;)

FWIW, the main reason I thought it is important enough to report
because if the filesystem is being unfriendly to sparse files, then
it is almost certainly being unfriendly to the internal mapping
tables in modern SSDs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
