Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cust-198-154-114-217.corexchange.com ([198.154.114.217]:38741
	"EHLO vkenny.zootboy.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbaIKEXV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 00:23:21 -0400
Date: Thu, 11 Sep 2014 00:23:18 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Goffredo Baroncelli <kreijack@inwind.it>, linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
Message-ID: <20140911042318.GB3367@wheatley.student.rit.edu>
References: <541043B8.7010601@barrowhillfarm.org.uk>
 <54109BCD.5000106@inwind.it>
 <20140910193212.GA2549@wheatley.student.rit.edu>
 <5410D0A8.6040204@inwind.it>
 <20140911012516.GA3367@wheatley.student.rit.edu>
 <20140911035119.GA10787@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140911035119.GA10787@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 10, 2014 at 11:51:19PM -0400, Zygo Blaxell wrote:
> This is a complex topic. 

I agree, and I make no claim to be an expert in any of this.

> Some disks have bugs in their firmware, and some of those bugs make the
> data sheets and most of this discussion entirely moot.  The firmware is
> gonna do what the firmware's gonna do.

Agreed. That's why I like that fact that btrfs provides another layer of
error checking / correction.

> It's a bad idea to try to rewrite a fading sector in some cases.
> If the drive is located in a climate-controlled data center then it
> should be OK; however, there are multiple causes of read failure and
> some of them will also cause writes to damage adjacent data on the disk.
> Spinning disks stop being able to position their heads properly around
> -10C or so, a fact that will be familiar to anyone who's tried to use a
> laptop outside in winter.  Maybe someone dropped the computer, and the
> read errors are due to the heads vibrating with the shock--a read retry
> a few milliseconds later would be OK, but a rewrite (without a delay,
> so the heads are still vibrating from the shock) would just wipe out
> some nearby data with no possibility of recovery.

Of course, the drive can't always know what's going on outside. It just
tries its best (we hope). 

> Most of the reallocations I've observed in the field happen when a
> sector is written, not read.

Very true. I believe what happens is that a sector is marked for
re-allocation when the read fails, and a write to that sector will
trigger the actual reallocation. Hence the "pending reallocations" SMART
attribute.

> Most disks can search for defects on their own, but the host has to issue a
> SMART command to initiate such a search.  They will also track defect
> rates and log recent error details (with varying degrees of bugginess).

And again, it's up to the questionable firmware's discretion as to how
that search is done / how thorough it is. And it has to be triggered by
the user / script. I don't consider that to really be "on its own," as
btrfs scrub requires the same level of input/scripting.

> smartmontools is your friend.  It's not a replacement for btrfs scrub, but
> it collects occasionally useful complementary information about the
> health of the drive.

I can't find the link, but there was a study done that shows an
alarmingly high percentage of disk failures showed no SMART errors
before failing. 

> There used to be a firmware feature for drives to test themselves
> whenever they are spinning and idle for four continuous hours, but most
> modern disks will power themselves down if they are idle for much less
> time...and who has a disk that's idle for four hours at a time anyway?  ;)

My backup destination is touched once a day. It averages about 20 hours
a day idle. Though it probably doesn't need to be testing itself 80% of
the time. That would be a mite excessive =P

> > Scrub your disks, folks. A scrubbed disk is a happy disk.
> 
> Seconded.  Also remember that not all storage errors are due to disk
> failure.  There's a lot of RAM, high-speed signalling, and wire between
> the host CPU and a disk platter.  SMART self-tests won't detect failures
> in those, but scrubs will.

But we'll save the ECC RAM discussion for another day, perhaps.

--Sean
