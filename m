Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55134 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaD0BVr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 21:21:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WeDmo-0008NX-PV
	for linux-btrfs@vger.kernel.org; Sun, 27 Apr 2014 03:21:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 03:21:42 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 03:21:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Confusing output of btrfs fi df
Date: Sun, 27 Apr 2014 01:21:30 +0000 (UTC)
Message-ID: <pan$f399b$352875cd$836588d2$a41de4b4@cox.net>
References: <20140426140915.GA12958@mars>
	<20140426143023.GK2391@carfax.org.uk> <20140426181827.GA14687@mars>
	<A666D949-AB49-4A9B-9BD8-2D1206F5CCB0@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 26 Apr 2014 15:28:03 -0600 as excerpted:

>>>   btrfs balance start -dprofiles=single -mprofiles=single 
>>> -sprofiles=single /mountpoint
>
>> After that btrfs fi df shows the following:
>> 
>> Data, RAID1: total=2.64TiB, used=2.22TiB
>> System, RAID1: total=8.00MiB, used=380.00KiB
>> > System, single: total=4.00MiB, used=0.00 <
>> Metadata, RAID1: total=4.00GiB, used=2.94GiB
> 
> Hmm, seems like a bug. What about
> 
> btrfs balance start -sconvert=raid1,soft -f -v

... Or simply...

btrfs balance start -susage=0 -f -v

In theory, metadata includes system, so system shouldn't need to be done 
on its own.  If system IS explicitly listed, however, force must be used 
as well, as you found out.

The convert=raid1 should convert all named types to raid1, while the soft 
keeps it from redoing all chunks that are already in target mode.

usage=N says only do the chunks with usage at or below N%, and 
profile=single says only do those in single profile.

So since the system chunk in question is single mode, balance start -
sprofile=single -f /should/ have converted it, but didn't.  My guess is 
that for some reason it didn't realize that you actually wanted system 
converted and what to, since you only gave it the existing profile, not 
the target profile.  For metadata it did the right thing anyway, but 
apparently not for system.

But given the above, there's multiple ways to skin that cat.  The 
-sconvert=raid1,soft -f /should/ do it as well, and I expect it will, 
since that actually tells it the target format.

But if for some reason that doesn't work either, I /know/ the -susage=0 
-f should do it, since usage=0 is the one I've always used to do it here.

If you did -musage=0, that should actually include both metadata and 
system, and doesn't need -f.  I've found that to be the case here too.  
But the -m might find a few additional non-system metadata blocks to free 
in the process, which wouldn't be a bad thing but could take a bit more 
time.  (Tho at 0 usage it shouldn't take much! =:^)

Actually, given your metadata total of 4 GiB, nearly 3 GiB used, it's 
quite possible that would end up returning a couple chunks, giving you 
3.5 GiB total, still nearly 3 GiB used.  Tho it depends on whether 
there's actually free metadata chunks or not, since the usage=0 says 
don't bother if they aren't totally empty.  (It normally wouldn't free 
all the way down to 3 GiB metadata total, however, since the filesystem 
reserves a couple hundred MiB for its own use, metadata chunks are 256 MiB 
each, and they're raid1, so they're allocated in pairs.  Thus, even a 
full balance would probably leave you at 3.5 GiB total metadata, still 
just under 3 GiB used.)


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

