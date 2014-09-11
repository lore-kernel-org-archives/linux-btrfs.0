Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34621 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751573AbaIKDvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 23:51:21 -0400
Date: Wed, 10 Sep 2014 23:51:19 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>, linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
Message-ID: <20140911035119.GA10787@hungrycats.org>
References: <541043B8.7010601@barrowhillfarm.org.uk>
 <54109BCD.5000106@inwind.it>
 <20140910193212.GA2549@wheatley.student.rit.edu>
 <5410D0A8.6040204@inwind.it>
 <20140911012516.GA3367@wheatley.student.rit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140911012516.GA3367@wheatley.student.rit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 10, 2014 at 09:25:17PM -0400, Sean Greenslade wrote:
> On Thu, Sep 11, 2014 at 12:28:56AM +0200, Goffredo Baroncelli wrote:
> > The WD datasheet says something different. It reports "Non-recoverable 
> > read errors per bits read" less than 1/10^14. They express the number of 
> > error in terms of number of bit reading.
> > 
> > You instead are saying that the error depends by the disk age.
> > 
> > These two sentence are very different.
> > 
> > ( and of course all these values depend also by the product quality).
> 
> I'm not certain how those specs are determined. I was basing my
> statements on knowledge of how read errors occur in rotating media.

This is a complex topic.  Different drives built by the same vendor have
different behavior coded in their firmware (this is why WD drives come in
half a dozen colors).  A consumer drive will keep retrying to read
data and hide errors from the host as long as possible, while a drive
intended for deployment in a RAID array will fail out quickly based on
the assumption that another drive somewhere in the system has a redundant
copy that the host can use to recover the lost data.  Some disks even
support configurable error responses in their firmware.

Some disks have bugs in their firmware, and some of those bugs make the
data sheets and most of this discussion entirely moot.  The firmware is
gonna do what the firmware's gonna do.

It's a bad idea to try to rewrite a fading sector in some cases.
If the drive is located in a climate-controlled data center then it
should be OK; however, there are multiple causes of read failure and
some of them will also cause writes to damage adjacent data on the disk.
Spinning disks stop being able to position their heads properly around
-10C or so, a fact that will be familiar to anyone who's tried to use a
laptop outside in winter.  Maybe someone dropped the computer, and the
read errors are due to the heads vibrating with the shock--a read retry
a few milliseconds later would be OK, but a rewrite (without a delay,
so the heads are still vibrating from the shock) would just wipe out
some nearby data with no possibility of recovery.

> They are both the same, generally. If the sector is damaged (e.g.
> manufacturing fault), then it can do several things. It can always
> return bad data, which will result in a reallocation. It can also
> partially fail. For example, accept the data, but slowly lose it over
> some period of time. It's still due to bad media, but if you were to
> read it quickly enough, you may be able to catch it before it goes bad.
> If the drive catches (and re-writes) it, then it may have staved off
> losing that data that time around. 

Most of the reallocations I've observed in the field happen when a
sector is written, not read.  If bad sectors were reallocated on reads
then repeatedly attempting to read a marginal bad sector would make it go
away as soon as one of the reads is successful.  Also this theory (that
reads correct bad sectors) doesn't match the behavior of SMART statistics
for disks with bad sector counters when they do have read errors.

> Yes, the error rate is almost entirely determined by the manufacturing
> of the physical media. Controllers can attempt to work around that, but
> they won't go searching for media defects on their own (at least, I've
> never seen a drive that does.)

Most disks can search for defects on their own, but the host has to issue a
SMART command to initiate such a search.  They will also track defect
rates and log recent error details (with varying degrees of bugginess).

smartmontools is your friend.  It's not a replacement for btrfs scrub, but
it collects occasionally useful complementary information about the
health of the drive.

There used to be a firmware feature for drives to test themselves
whenever they are spinning and idle for four continuous hours, but most
modern disks will power themselves down if they are idle for much less
time...and who has a disk that's idle for four hours at a time anyway?  ;)

> Disks have latent errors. Nothing you can do will change this, and the
> number of reads you do will not affect the error rate of the media. It
> _will_ affect how often those errors are detected, however. And with
> btrds, this is a Good Thing(TM). If errors are found, they can be
> corrected by either the disk controller itself (on the block level) or
> the filesystem on its level. 
> 
> Scrub your disks, folks. A scrubbed disk is a happy disk.

Seconded.  Also remember that not all storage errors are due to disk
failure.  There's a lot of RAM, high-speed signalling, and wire between
the host CPU and a disk platter.  SMART self-tests won't detect failures
in those, but scrubs will.
