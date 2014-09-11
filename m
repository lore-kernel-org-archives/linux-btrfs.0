Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cust-198-154-114-217.corexchange.com ([198.154.114.217]:33262
	"EHLO vkenny.zootboy.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbaIKBZ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 21:25:26 -0400
Date: Wed, 10 Sep 2014 21:25:17 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
Message-ID: <20140911012516.GA3367@wheatley.student.rit.edu>
References: <541043B8.7010601@barrowhillfarm.org.uk>
 <54109BCD.5000106@inwind.it>
 <20140910193212.GA2549@wheatley.student.rit.edu>
 <5410D0A8.6040204@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5410D0A8.6040204@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 11, 2014 at 12:28:56AM +0200, Goffredo Baroncelli wrote:
> The WD datasheet says something different. It reports "Non-recoverable 
> read errors per bits read" less than 1/10^14. They express the number of 
> error in terms of number of bit reading.
> 
> You instead are saying that the error depends by the disk age.
> 
> These two sentence are very different.
> 
> ( and of course all these values depend also by the product quality).

I'm not certain how those specs are determined. I was basing my
statements on knowledge of how read errors occur in rotating media.

> I think that there is two source of error:
> - a platter/disk degradation (due to ageing, wearing...), which may require a 
> sector relocation
> - other sources of error which are not permanent and that may be corrected
> by a 2nd read
> 
> I don't have any idea about which one is bigger (even I suspect the second).

They are both the same, generally. If the sector is damaged (e.g.
manufacturing fault), then it can do several things. It can always
return bad data, which will result in a reallocation. It can also
partially fail. For example, accept the data, but slowly lose it over
some period of time. It's still due to bad media, but if you were to
read it quickly enough, you may be able to catch it before it goes bad.
If the drive catches (and re-writes) it, then it may have staved off
losing that data that time around. 

> > So doing reads, especially across the entire media surface, is a great
> > way to make the disk perform these sector checks. But sometimes the disk
> > cannot correct the error. 
> 
> I read this as: the error rate is greater than 1/10^14, but the CRC and
> some multiple reading and sector remapping lower the error rate below 1/10^14.
> 
> If behind this there are a "dumb" drive which returns an error as soon as 
> the CRC doesn't match, or a smart drive which retries several time until
> it got a good value doesn't matter: the error rate is still 1/10^14.

Yes, the error rate is almost entirely determined by the manufacturing
of the physical media. Controllers can attempt to work around that, but
they won't go searching for media defects on their own (at least, I've
never seen a drive that does.)

> > Long story short, reads don't cause media errors, and scrubs help detect
> > errors early.
> 
> Nobody told that a reading "cause" a media "error"; however assuming (this is how
> I read the WD datasheet) the error rate constant, if you increase the number 
> of reading then you have more errors.
> 
> May be that I was not clear, however I didn't want to say that "scrubbing reduces 
> the life of disk", I wanted to point out that the size of the disk and the error
> rate are becoming comparable.

I know that wasn't your implication, but I wanted to be sure that things
weren't misinterpreted. I'll clarify:

Disks have latent errors. Nothing you can do will change this, and the
number of reads you do will not affect the error rate of the media. It
_will_ affect how often those errors are detected, however. And with
btrds, this is a Good Thing(TM). If errors are found, they can be
corrected by either the disk controller itself (on the block level) or
the filesystem on its level. 

Scrub your disks, folks. A scrubbed disk is a happy disk.

--Sean
