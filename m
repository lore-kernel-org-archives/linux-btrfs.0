Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46827 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161857AbcE3Uzi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 16:55:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b7UDn-0008JK-0V
	for linux-btrfs@vger.kernel.org; Mon, 30 May 2016 22:55:35 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 22:55:34 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 22:55:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Runaway SLAB usage by 'bio' during 'device replace'
Date: Mon, 30 May 2016 20:55:25 +0000 (UTC)
Message-ID: <pan$555d9$34a6c7$c401e1ca$b9b438b8@cox.net>
References: <CAMbyGOMdgMKK=ttSR0NujhdbnitMwU+4+ebH6z5YW4U=zxnxtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Johnson posted on Mon, 30 May 2016 11:48:02 -0700 as excerpted:

> I have a RAID6 array that had a failed HDD. The drive failed completely
> and has been removed from the system. I'm running a 'device replace'
> operation with a new disk. The array is ~20TB so this will take a few
> days.

This isn't a direct answer to your issue as I'm a user and list regular, 
not a dev, and that's beyond me, but it's something you need to know, if 
you don't already...

Btrfs raid56 mode remains for the time being in general negatively-
recommended, except specifically for testing with throw-away data, due to 
two critical but not immediately data destroying bugs, one related to 
serial device replacement, the other to balance restriping.  They may or 
may not be related to each other, as neither one has been fully traced.

The serial replace bug has to do with replacing multiple devices, one at 
a time.  The first replace appears to work fine by all visible measures, 
but apparently doesn't return the array to full working condition after 
all, because an attempt to replace a second device fails, and can bring 
down the filesystem.  Unfortunately it doesn't always happen, and due to 
the size of devices these days, working arrays tend to be multi-TB 
monsters that take time to get to this point, so all we have at this 
point is multiple reports of the same issue, but no real way to reproduce 
it.  I believe but am not sure that the problem can occur regardless of 
whether btrfs replace or device add/delete was used.

The restriping bug has to do with restriping to a different width, either 
manually doing a filtered balance after adding devices, or automatically, 
as triggered by btrfs device delete.  Again, multiple reports but not 
nailed down to anything specifically reproducible yet.  The problem here 
is that the restripes, while apparently producing correct results, can 
inexplicably take an order of magnitude (or worse) longer than they 
should.  What one might expect to take hours takes over a week, and on 
the big arrays that might be expected to take 2-3 days, months.

The problem, again, isn't correctness, but the fact that over such long 
periods, the risk of device loss is increased, and if the array was 
already being reshaped/rebalanced to repair loss of one device, loss of 
another device may kill it.

Neither of these bugs affects normal runtime operation, but both are 
critical enough with regard to what people normally use parity-raid for, 
so they /can/ take a device (or two with raid6) loss and repair the array 
to get back to normal operation, that raid56 remains negatively 
recommended for anything but testing with throw-away data, until after 
these bugs can be fully traced and fixed.


Your particular issue doesn't appear to be directly related to either of 
the above.  In fact, I know I've seen patches recently having to do with 
memory leaks that may well fix your problem (tho you'd have to be running 
4.6 at least to have them at this point, and perhaps even 4.7-rc1.

But given the situation, either be sure you have backups and are prepared 
to use them if the array goes south on you due to failed or impractical 
device replacement, or switch to something other than btrfs raid56 mode.  
Btrfs redundancy-raid (raid1 and raid10) are more mature and tested, and 
thus may be options if they fit your filesystem space and device layout 
needs.  Alternatively, btrfs (or other filesystems) on top of dm/md-raid 
may be an option, tho you obviously lose some features of btrfs that 
way.  And of course zfs is the closest btrfs-comparable that's reasonably 
mature and may be an option, tho there are licensing and hardware issues 
(it likes lots of memory on linux due to double-caching of some elements 
as its caching scheme doesn't work well with that of linux, and ecc 
memory is very strongly recommended) if using it on linux.

I'd suggest giving btrfs raid56 another few kernel releases, six months 
to a year, and then check back.  I'd hope the bugs can be properly traced 
and fixed within a couple kernel cycles, so four months or so, but I 
prefer a few cycles to stabilize with no known critical bugs, before I 
recommend it (I was getting close to recommending it after the last known 
critical bug was fixed in 4.1, when these came up), which puts the 
projected timeframe at 8-12 months, before I could really consider raid56 
mode as reasonably stable as btrfs in general, which is to say, 
stabilizing, but not yet fully stable, so even then, the standard admin 
backup rule that if you don't have backups you consider the data to be 
worth less than the time/resources/hassle to do those backups, still 
applies more strongly than it would to a fully mature filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

