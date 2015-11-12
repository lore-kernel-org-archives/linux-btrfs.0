Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51044 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbbKLGqg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 01:46:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZwleN-0007fe-QT
	for linux-btrfs@vger.kernel.org; Thu, 12 Nov 2015 07:46:28 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 07:46:27 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 07:46:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
Date: Thu, 12 Nov 2015 06:46:19 +0000 (UTC)
Message-ID: <pan$1d74$e90b44a9$d090dc10$a5a0a518@cox.net>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
	<5643F62D.6050703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Thu, 12 Nov 2015 10:15:09 +0800 as excerpted:

> Anand Jain wrote on 2015/11/09 18:56 +0800:
>> These set of patches provides btrfs hot spare and auto replace support
>> for you review and comments.
>>
>> First, here below are the simple example steps to configure the same:
>>
>> Add a spare device:
>>      btrfs spare add /dev/sde -f
> 
> I'm sorry but I didn't quite see the benefit of a spare device.

You could ask the mdraid folks much the same question about spares there, 
and the answer would I think be very much the same...  I'll just present 
a couple points of the several that can be made.

Perhaps the biggest point for this particular case...

What you're forgetting is that the work here introduces the _global_ 
spare -- one spare device (or pool of devices) for the whole set of 
btrfs, no matter how many independent btrfs there happen to be on a 
machine.

Your example used just one filesystem, in which case this point is null 
and void, but what of the case where there's two?  You can't have the 
same device be part of *both* filesystems.  What if the device is part of 
btrfs A, but btrfs b is the one that loses a device?  In your example, 
you're out of luck.  But as a global spare, the "extra" device doesn't 
become attached to a specific btrfs until one of the existing devices 
goes bad.  With working global spares, the first btrfs to have a bad 
device will see the spare and be able to grab it, no matter which of the 
two (or 10 or 100) separate btrfs it happens to be, as it's a _global_ 
spare, not actually attached to a specific btrfs until it is needed as a 
replacement.

By extension, there's the spare _pool_.  Suppose you have three separate 
btrfs and three separate "extra" devices.  You can attach one to each 
btrfs and be fine... if the existing devices all play nice and a second 
one doesn't go out on any of them until all three have had one device go 
out.  But what happens if one btrfs gets some real heavy unexpected use 
and loses three devices before the other two btrfs lose any?  With global 
spares, the unlucky btrfs can call for one at a time, and assuming 
there's time for it to fully integrate before the next one dies, it can 
call for the next and the next, and get all three, one at a time, without 
the admin having to worry about manually device deleting the second and 
third devices from their other btrfs, to attach to the unlucky/greedy one.

And that three btrfs, three-device global-spare-pool scenario, with an 
unlucky/greedy btrfs ending up getting all three spares, brings up a 
second point...

In that scenario without global hot-spares, say you've added one more 
device to what ends up the unlucky btrfs than it'd need, so with auto-
repair it can detect a failing device and automatically device-delete it 
down to its device-minimum (either due to raid level or due to 
capacity).  Now another device fails.  Oops!  Can't auto-repair now!

But in the global hot-spare-pool scenario, with one repair done, there's 
still two spares in the pool, so at the second device failure, it can 
automatically pull a second from the pool (where given the pool it can be 
instead of already attached to one of the other btrfs') and complete the 
second repair, still without admin intervention.  Same again for the 
third.

So an admin who doesn't want to have to intervene when he's supposedly on 
vacation can setup a queue of spares, and sure, if he's a good admin, 
when a device goes bad and a spare is automatically pulled in to replace 
it, he'll be notified, and he'll probably login to check logs and see 
what happened, but no problem, there's still others in the queue.

In fact, since the common folk wisdom says this sort of bad event 
(someone you know getting a disease like cancer or dying, devices in your 
machines going bad, friends having their significant others leave them... 
at least here in the US, folk wisdom says it always happens in threes, so 
particularly once two happen, people start wondering who/where the third 
one is going to occur) happens in threes, a somewhat superstitious admin 
could ensure he had four, well, he's cautious too, so make it five, 
global spares setup, just in case.  Then it wouldn't matter if the three 
devices going bad were all on the same btrfs, or one each on the three, 
or two on one and a third elsewhere, he'd still have two additional 
devices in the pool, just to cover his a** if the three /did/ go out.

Now about time he loses a fourth, he better be on the phone confirming a 
ticket home, but even then, he still has the one still in the pool, as he 
was cautious, too, hopefully giving him time to actually /make/ it home 
before two more go out leaving the pool empty and a btrfs a device down.  
And if he's /that/ unlucky, well, maybe he better make a call to his 
lawyer confirming his last will and testament before he steps on that 
plane, too. =:^(

Just a short mention of a third point, too.

Devices in the pool presumably will be idle and thus spun down, thus not 
already wearing out like they would be if they were already in use all 
that time they're in the spare pool.

Those are the biggest and most obvious ones I know of.  Talk to any good 
admin who has handled lots of raid and I'm sure they'll provide a few 
more.

FWIW, there's also a case to be made for spare pools that may not be 
global, but that can still be attached to more than one btrfs/raid, if 
desired.  Consider the case for two pools, one with fast but small ssds 
while the other has slow but large spinning rust, with the ability to map 
individual btrfs to one or the other pool, or to neither, for instance.  
But this patch series simply introduces the global pool and 
functionality, leaving such fancy additional functionality for later.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

