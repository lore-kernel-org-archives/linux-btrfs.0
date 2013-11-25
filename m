Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:45654 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3KYCOK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 21:14:10 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: stan@hardwarefreak.com
Subject: Re: Triple parity and beyond
Date: Mon, 25 Nov 2013 13:14:06 +1100
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <201311241619.08668.russell@coker.com.au> <52927343.9000203@hardwarefreak.com>
In-Reply-To: <52927343.9000203@hardwarefreak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201311251314.06277.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 25 Nov 2013, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> > If that is the problem then the solution would be to just enable
> > read-ahead. Don't we already have that in both the OS and the disk
> > hardware?  The hard- drive read-ahead buffer should at least cover the
> > case where a seek completes but the desired sector isn't under the
> > heads.
> 
> I'm not sure if read-ahead would solve such a problem, if indeed this is
> a possible problem.  AFAIK the RAID5/6 drivers process stripes serially,
> not asynchronously, so I'd think the rebuild may still stall for ms at a
> time in such a situation.

For a RAID block device (such as Linux software RAID) read-ahead should work 
well.  For a RAID type configuration managed by the filesystem where you might 
have different RAID levels in the same filesystem it might not be possible.

It would be a nice feature to have RAID-0 for unimportant files and RAID-1 or 
RAID-6 for important files on the same filesystem.  But that type of thing 
would really complicate RAID rebuild.

> >> So  this
> >> might slow down a stripe read by dozens of milliseconds, maybe a full
> >> second.  If this happens to multiple drives many times throughout the
> >> rebuild it will add even more elapsed time, possibly additional hours.
> > 
> > Have you observed such 1 second reads in practice?
> 
> We seem to have regular reports from DIY hardware users intentionally
> using mismatched consumer drives, as many believe this gives them
> additional protection against a firmware bug in a given drive model.
> But then they often see multiple second timeouts causing drives to be
> kicked, or performance to be slow, because of the mismatched drives.

I've had that happen in my own RAID-1 and had reports of the same from other 
people.  My problem was that one of the disks was a WD "Green" drive that 
aggressively parked the heads.  When I replaced the array the disk in question 
had parked it's heads about a million times more than it was supposed to but 
it still worked.

I think that if you want to buy two different disks from your local discount 
store then you are likely to end up with one that's not well suited to server 
use because they often don't have more than two types of disks on offer.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
