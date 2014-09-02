Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59751 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaIBFUy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 01:20:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XOgWN-0002Jc-GD
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 07:20:47 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 07:20:47 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 07:20:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120
 seconds
Date: Tue, 2 Sep 2014 05:20:29 +0000 (UTC)
Message-ID: <pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
	<540498AF.6030109@fb.com>
	<CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

john terragon posted on Mon, 01 Sep 2014 18:36:49 +0200 as excerpted:

> I was trying it again and it seems to have completed, albeit very slowly
> (even for an usb flash drive). Was the 3.14 series the last immune one
> from this problem? Should I try the latest 3.14.x?

The 3.14 series was before the switch to generic kworker threads, while 
btrfs still had its own custom work-queue threads.  There was known to be 
a very specific problem with the kworker threads, but in 3.17-rc3 that 
should be fixed.

So it may well be a problem with btrfs in general, at least as it exists 
today and historically, in which case 3.14.x won't help you much if at 
all.

But I'd definitely recommend trying it.  If 3.14 is significantly faster 
and it's repeatedly so, then there's obviously some other regression, 
either with kworker threads or with something else, since then.  If not, 
then at least we know for sure kworker threads aren't a factor, since 
3.14 was previous to them entering the picture.


The other possibility I'm aware of would be erase-block related.  I see 
you're using autodefrag so it shouldn't be direct file fragmentation, but 
particularly if the filesystem has been used for some time, it might be 
the firmware trying to shuffle things around and having trouble due to 
having already used up all the known-free erase blocks so it's having to 
stop and free one by shifting things around every time it needs another 
one, and that's what's taking the time.

What does btrfs fi show say about free space (the device line (lines, for 
multi-device btrfs) size vs. used, not the top line, is the interesting 
bit)?  What does btrfs fi df say for data and metadata (total vs. used)?

For btrfs fi df ideally your data/metadata spread between used and total 
shouldn't be too large (a few gig for data and a gig or so for metadata 
isn't too bad, assuming a large enough device, of course).  If it is, a 
balance may be in order, perhaps using the -dusage=20 and/or -musage=20 
style options to keep it from rebalancing everything (read up on the wiki 
and choose your number, 5 might be good if there's plenty of room, you 
might need 50 or higher if you're close to full, more than about 80 and 
you might as well just use -d or -m and forget the usage bit).

Similarly, for btrfs fi show, you want as much space as possible left, 
several gigs at least if your device isn't too small for that to be 
practical.  Again, if btrfs fi df is out of balance it'll use more space 
in show as well, and a balance should retrieve some of it.

Once you have some space to work with (or before the balance if you 
suspect your firmware is SERIOUSLY out of space and shuffling, as that'll 
slow the balance down too, and again after), try running fstrim on the 
device.  It may or may not work on that device, but if it does and the 
firmware /was/ out of space and having to shuffle hard, it could improve 
performance *DRAMATICALLY*.  The reason being that on devices where it 
works, fstrim will tell the firmware what blocks are free, allowing it 
more flexibility in erase-block shuffling.

If that makes a big difference, you can /try/ the discard mount option.  
Tho doing the trim/discard as part of normal operations can slow them 
down some too.  The alternative would be to simply run fstrim 
periodically, perhaps every Nth rsync or some such.  Note that as the 
fstrim manpage says, the output of fstrim run repeatedly will be the 
same, since it only knows what areas are candidates to trim, not which 
ones are already trimmed, but it shouldn't hurt the device any to 
repeatedly fstrim it, and if you do it every N rsyncs, it should keep 
things from getting too bad again.

The other thing to consider if you haven't already is the ssd_spread 
mount option.  The documentation suggests it can be helpful on lower 
quality SSDs and USB sticks which fits your use-case, so I'd try it.  Tho 
it probably won't work at its ideal unless you do a fresh mkfs (or near 
full balance with it enabled).  But it's something to at least consider 
and possibly try if you haven't.  Depending on the firmware and erase-
block layout, it could help.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

