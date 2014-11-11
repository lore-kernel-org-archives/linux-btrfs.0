Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37588 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaKKWkS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 17:40:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XoK6G-0001yP-NW
	for linux-btrfs@vger.kernel.org; Tue, 11 Nov 2014 23:39:48 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Nov 2014 23:39:48 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Nov 2014 23:39:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: transid failed / mount Problem on Linux pc6 3.17.2-1-ARCH #1
 SMP PREEMPT Thu Oct 30 20:49:39 CET 2014 x86_64 GNU/Linux
Date: Tue, 11 Nov 2014 22:39:28 +0000 (UTC)
Message-ID: <pan$9e48b$dee08040$a812fe40$6995150@cox.net>
References: <5461EF65.4040206@automatix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juergen Sauer posted on Tue, 11 Nov 2014 12:13:41 +0100 as excerpted:

> this event occoured today in the morning.
> Accidentially the Archive Machine was kickt  into hibernation.
> 
> After reactivating the archive Btrfs filesystem was "readonly", after
> rebooting the system the "archive" btrfs filesystem was not mountable
> anymore.

FWIW, I've had similar issues with both mdraid in the past, and with 
btrfs now, with both hibernation and suspend-to-ram.

Tho after early experiences I switched to mdraid-1 some time in the past, 
and now btrfs raid1 mode, which (even with the more mature mdraid) tends 
to be more resilient than raid5 and faster than raid6.  At least with 
raid1, there's multiple copies of the data, and at least in my 
experience, that dramatically increases the reliability of recovery from 
temporary or permanent dropout of one device.

The general problem seems to be that in the resume process, some devices 
wake up faster than others, and even "awake" devices don't necessarily 
fully stabilize for a minute or two.  Back on mdraid, I noticed some 
devices coming up with model number strings and UIDs that would have 
incorrect characters in some position, tho they'd stabilize over time.  
Obviously, this plays havoc with kernel efforts to ensure the devices it 
woke up to are the same devices it had when it went to sleep (either 
suspend to ram or hibernate to disk).

And the same general problems continue to occur with the pair of SSDs I 
have now, with suspend-to-ram instead of hibernate, while the original 
devices I noticed the problem on were spinning rust of an entirely 
different brand.

So it's not a btrfs-specific issue, or a device specific issue, or a 
motherboard specific issue since I've upgraded since I first saw it too, 
or a suspend/hibernate type specific issue.  It's a general issue.  Tho I 
/have/ noticed on the current equipment, that if I suspend for a 
relatively short period, an hour or two, it seems to come back with fewer 
problems than if I suspend for 6 hours or more... say if I suspend while 
I'm at work or overnite.  (FWIW, the old machine seemed to hibernate and 
resume reasonably well other than this but couldn't reliably resume from 
suspend, while the new machine is the opposite, I never got it to resume 
from hibernation, but other than this, it reliably resumes from suspend.)

Unfortunately, the only reliable solution seems to be to fully shut down 
instead of suspending or hibernating, and obviously, after running into 
issues a few times, I eventually quit experimenting further.  But the 
fact that I'm running systemd on fast ssds now, does ameliorate the 
problem quite a bit, both due to faster booting, and by making the lost 
cache of a reboot far less of an issue because reading the data back in 
is so much faster on ssd.

So it seems both suspend and hibernate seem to work better with single 
devices where one device being slower to stabilize won't be the issue it 
is with raid (either mdraid or btrfs raid), and raid doesn't combine well 
with suspend/hibernate. =:^(

Too bad, as being able to suspend and wake up right away was saving on 
the electric bill. =:^(

So if it's really critical, as it arguably might be on an archive 
machine, I'd consider pointing whatever suspend/hibernate triggers at 
shutdown or reboot, instead.  If it's not possible to accidentally 
hibernate the thing, it triggers shutdown/reboot instead, it won't/can't 
be accidentally hibernated. =:^)

> I tried every thing of recovery possibilities I know. Nothing worked.
> 
> Here I liste the Problem of the Machine, it would be very ugly to loose
> thoes data.
> 
> Do you have any further ideas, what I may try to recover my archive
> filesystem?
> 
> The archive Filesystem is an raid5-multi device btrfs.

Btrfs raid5, or mdraid-5 with btrfs on top?  Because it's common 
knowledge that btrfs raid56 modes aren't yet fully implemented, and while 
they work in normal operation, recovery from a lost device is iffy at 
best because the code simply isn't complete for that yet.  As such a 
raid5/6 mode btrfs is best effectively considered a raid0 in terms of 
reliability, don't count on recovering anything if a single device is 
lost, even temporarily.  Depending on the circumstances, it's not always 
/quite/ that bad, but raid0 reliability, or more accurately the lack 
thereof, is what you plan for when you setup a btrfs raid5 or raid6, 
because that's effectively what it is until the recovery code is complete 
and tested, and that way you won't be caught with critical data on it if 
it does go south, any more than you would put critical data on a raid0.

So I /hope/ you meant mdraid-5, on top of which you had btrfs.  With 
that, once the mdraid level is recovered, you are basically looking at a 
standard btrfs recovery as if it were a single device.  That's still not 
a great position to be in as you are after all looking at a recovery with 
a non-zero chance of failure, but let's call it an 80% chance of 
recovery, over a 10% chance, you're still in far better shape than with 
btrfs raid5/6 at that point.

If you /did/ mean btrfs raid56 mode, then take a look at the raid56 
information on the wiki and the links from there to additional 
information on Marc MERLIN's site, as he is the regular around here that 
has done the most intensive testing of raid56 mode and has written about 
it extensively, and other than getting one of the devs to take personal 
interest in your special case, that's the best chance you have at 
recovery.

https://btrfs.wiki.kernel.org/index.php/RAID56

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

