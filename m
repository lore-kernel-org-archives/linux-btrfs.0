Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40931 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbbDYAm0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 20:42:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YloAo-00020N-Nu
	for linux-btrfs@vger.kernel.org; Sat, 25 Apr 2015 02:42:22 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 02:42:22 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 02:42:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to repair a BTRFS block?
Date: Sat, 25 Apr 2015 00:42:12 +0000 (UTC)
Message-ID: <pan$680be$6c095edf$ea91e4f5$d6164a0f@cox.net>
References: <55320BAE.1030007@gnieh.org> <5539345C.1040905@gnieh.org>
	<553A810F.6010907@gnieh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Monperrus posted on Fri, 24 Apr 2015 19:44:47 +0200 as excerpted:

> Hi Duncan,
> 
>> The kernel log (dmesg, also logged to syslog/journald on most systems)
>> from during the scrub should capture more information on those errors.
> Thanks. The dmesg log indeed contains the file path (see below).
> 
> The error is in /home/martin/XXXXX. It is related to a low-level error
> ("failed command: READ DMA").
> 
> Beyond this corrupted file, is my disk dead?
> Can I repair the file system or re-create a new one on the same disk?

A direct answer is beyond my knowledge level, certainly without SMART 
status information, etc.  What I do know is that assuming the rest of the 
device is responding fine, most drives keep a number of reserved sectors 
available and will automatically substitute them in on a *write* to an 
affected dead sector.

So if the device in general appears to be working fine, and assuming the 
SMART status still passes, I'd backup everything else on that partition, 
unmount it, then do something like a badblocks destructive write (-w) 
test to the partition.  If it comes back clean, I'd consider the device 
usable again.

Also note that if you run smartctl -A (attributes) on the device before 
attempting anything else and check the raw value for ID 5 (reallocated 
sector count), then check again after doing something like that badblocks 
-w, you can see if it actually relocated any sectors.  Finally, note that 
while it's possible to have a one-off, once a drive starts reallocating 
sectors it often fails relatively quickly as that can indicate a failing 
media layer and once it starts to go, often it doesn't stop.  So once you 
see that value move from zero, do keep an eye on it and if you notice the 
value starting to climb, get the data off that thing as soon as possible.

And of course it should go without saying, but I'll repeat the sysadmin's 
data value rule of thumb anyway, for the benefit of others reading as 
well.  If you care about the data, by definition, you have a (tested) 
backup (a corollary rule states that an untested backup isn't a backup at 
all).  If you don't have a backup, by definition you do NOT care about 
that data, /regardless/ of any claims to the contrary.  Unfortunately, 
many (most?) people end up learning this the hard way, finding out too 
late how much more value the data had than they thought, and thus that 
they /should/ have cared about it more (more backups, more testing of 
them) than they did.

(For those who end up in that situation...)  On the flip side there's the 
big picture.  During hurricane Katrina a data hosting firm in New Orleans 
made (tech) headlines by blogging live their struggle to stay powered and 
online.  I was one of thousands watching that, along with the mainstream 
news about the flooding, looting and dying going on.  Obviously losing a 
bit of data ends up pretty far down the list when you're wet and cold and 
just lost your house and possibly members of your family!  A bit of data 
loss might hurt a bit, but in the big picture, if you're still healthy, 
and have a job and a home and family, it's /not/ the end of the world.  A 
bit of perspective helps! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

