Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:37459 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbcAFITd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 03:19:33 -0500
Date: Wed, 6 Jan 2016 03:09:08 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: Psalle <psalleetsile@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: raid1 vs raid5
Message-ID: <20160106080907.GA30773@wheatley.ludlow.local>
References: <568BEE3F.4060402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <568BEE3F.4060402@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 05, 2016 at 05:24:31PM +0100, Psalle wrote:
> Hello all and excuse me if this is a silly question. I looked around in the
> wiki and list archives but couldn't find any in-depth discussion about this:
> 
> I just realized that, since raid1 in btrfs is special (meaning only two
> copies in different devices), the effect in terms of resilience achieved
> with raid1 and raid5 are the same: you can lose one drive and not lose data.
> 
> So!, presuming that raid5 were at the same level of maturity, what would be
> the pros/cons of each mode?

This is true for "classic" RAID: assume you have 3x 1TB disks. RAID1
will give you 1.5TB, whereas RAID5 will give you 2TB.

RAID1 = 1/2 total disk space (assuming equally-sized disks)
RAID5 = (N-1)*single disk space (same assumption)

> As a corollary, I guess that if raid1 is considered a good compromise, then
> functional equivalents to raid6 and beyond could simply be implemented as
> "storing n copies in different devices", dropping any complex parity
> computations and making this mode entirely generic.

This is akin to what has been mentioned on the list earlier as "N-way
mirroring" and I agree that it will be very nice to have once
implemented. However it is not the same as RAID5/6 since the parity
schemes are used to get more usable storage than just simple mirroring
would allow for.

Thus, the main pro of RAID5/6 is more usable storage, and the main con
is more computational complexity (and thus more cpu requirements, slower
access time, more fragile error states, etc.)

> Since this seems pretty obvious, I'd welcome your insights on what are
> the things I'm missing, since it doesn't exist (and it isn't planned
> to be this way, AFAIK). I can foresee consistency difficulties, but
> that seems hardly insurmountable if its being done for raid1?

Fixing an inconsistency in RAID1 is much easier than RAID5/6. No math,
just checking csums. Fixing an inconsistency in RAID5/6 involves busting
out the parity math. This is why repairing RAID5/6 only became possible
in btrfs relatively recently. Generating the parity data was relatively
easy, but rebuilding missing data with it was a more difficult task.

--Sean
