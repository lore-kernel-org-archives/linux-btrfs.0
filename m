Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45964 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3EEO4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 10:56:50 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 527F99A0017
	for <linux-btrfs@vger.kernel.org>; Sun,  5 May 2013 08:56:50 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130505014540.GF19978@dastard>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20130504011547.GB19978@dastard>
 <20130504112005.5844.26279@localhost.localdomain>
 <20130505014540.GF19978@dastard>
Message-ID: <20130505145646.5844.66306@localhost.localdomain>
Subject: Re: [BULK]  Re: [3.9] parallel fsmark perf is real bad on sparse devices
Date: Sun, 5 May 2013 10:56:46 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Dave Chinner (2013-05-04 21:45:40)
> On Sat, May 04, 2013 at 07:20:05AM -0400, Chris Mason wrote:
> > Quoting Dave Chinner (2013-05-03 21:15:47)
> > > Hi folks,
> > > 
> > > It's that time again - I ran fsmark on btrfs and found performance
> > > was awful.
> > > 
> > > tl;dr: memory pressure causes random writeback of metadata ("bad"),
> > > fragmenting the underlying sparse storage. This causes a downward
> > > spiral as btrfs cycles through "good" IO patterns that get
> > > fragmented at the device level due to the "bad" IO patterns
> > > fragmenting the underlying sparse device.
> > > 
> > 
> > Really interesting Dave, thanks for all this analysis.
> > 
> > We're going to have hard time matching xfs fragmentation just because
> > the files are zero size and we don't have the inode tables.  But, I'll
> > take a look at the metadata memory pressure based writeback, sounds like
> > we need to push a bigger burst.
> 
> Yeah, I wouldn't expect it to behave like XFS does given all the
> metadata writeback ordering optimisation XFS has, but the level of
> fragmentation was a surprise. Fragmentation by itself isn't so much
> of a problem - ext4 is just as bad as btrfs in terms of the amount of
> image fragmentation, but it doesn't have the 100:1 IOPS explosion in
> the backing device.

The frustrating part of fsmark is watching all those inodes and dentries
suck down our ram, while the FS gets slammed doing writes on pages
that we actually want to keep around.  

> 
> Run the test and have a look at the iowatcher movies - they
> are quite instructive as they show the two separate phases
> that write alternately over the same sections of the disk. A
> picture^Wmovie is worth a thousand words ;)

;) Will do.  We already have a few checks to skip btree writeback if
there isn't much actually dirty.  But that's a tricky knob to turn
because balance_dirty_pages gets angry when you ignore it.

This is one of those tests where keeping the metadata out of the page
cache should make life easier.

> 
> FWIW, the main reason I thought it is important enough to report
> because if the filesystem is being unfriendly to sparse files, then
> it is almost certainly being unfriendly to the internal mapping
> tables in modern SSDs....

Definitely.  The other side of it is that memory pressure based
writeback means writing before we needed to, which means COWs that we
didn't need to do, which means more work for the allocator, which also
means more COWs that we didn't need to do.  So, even without the sparse
backing store, we'll go faster if we tune this well.

-chris

