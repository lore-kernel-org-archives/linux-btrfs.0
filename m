Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54139 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbbDYILZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Apr 2015 04:11:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YlvBJ-0002mL-9E
	for linux-btrfs@vger.kernel.org; Sat, 25 Apr 2015 10:11:21 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 10:11:21 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 10:11:21 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to repair a BTRFS block?
Date: Sat, 25 Apr 2015 08:11:14 +0000 (UTC)
Message-ID: <pan$7f475$aaba5b51$559e51d4$8eddaa05@cox.net>
References: <55320BAE.1030007@gnieh.org> <5539345C.1040905@gnieh.org>
	<553A810F.6010907@gnieh.org>
	<pan$680be$6c095edf$ea91e4f5$d6164a0f@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Sat, 25 Apr 2015 00:42:12 +0000 as excerpted:

> Also note that if you run smartctl -A (attributes) on the device before
> attempting anything else and check the raw value for ID 5 (reallocated
> sector count), then check again after doing something like that
> badblocks -w, you can see if it actually relocated any sectors. 
> Finally, note that while it's possible to have a one-off, once a drive
> starts reallocating sectors it often fails relatively quickly as that
> can indicate a failing media layer and once it starts to go, often it
> doesn't stop.  So once you see that value move from zero, do keep an eye
> on it and if you notice the value starting to climb, get the data off
> that thing as soon as possible.

FWIW, I'm running btrfs raid1 (both data/metadata) here.  I run multiple 
btrfs filesystems (with the raid1 on parallel partitions on two ssds) 
instead of subvolumes.  Of course SSDs have a far different wear life 
than spinning rust, and the most-used sectors are expected to drop out as 
the device ages.

When I bought my SSDs, I found that one had been used some and then 
returned, with me getting it.  However, smart said no relocated sectors 
at the time and I decided to call it a good thing, since it meant the one 
should wear out first, instead of having them both wear out together.

I normally keep / mounted read-only, unless I'm updating, and that has 
proven to be a good decision as I rarely have problems with it.  /home, 
OTOH, is of course mounted writable, and occasionally doesn't get cleanly 
unmounted, so it tends to see problems once in awhile.  However, scrub 
normally fixes them right up (as it can because I'm running raid1 and 
there's a second, generally valid, copy to copy over the bad one).

After writing the above, I decided it was time to do a scrub, and sure 
enough, it found some problems on /home.  I actually had to run it twice 
to fix them all.  Each time it said (with no-background, raw, per-device 
reporting options set) that the one device had a read-error and several 
unverified errors.  After the second scrub, a third scrub found no 
further errors.

The btrfs errors occurred as lower level ata errors logged in dmesg, very 
similar to what you posted, above.

But I ran smartctl -A on the device both before and after the scrubs, as 
it happens the first one because I had looked up -A in the manpage and 
run it while composing the above reply in ordered to check that -A was 
actually what I wanted.

Before the scrubs, the previously-used device had 19 sectors 
reallocated.  Afterward it was 20.  So the first scrub probably triggered 
the reallocation but didn't fix the problem, while the second scrub fixed 
the problem as it could now write to the newly reallocated sector.

The kicker, of course, is that because I'm running btrfs raid1, there was 
a second copy (on the newer device, which doesn't report any reallocated 
sectors yet) btrfs could use to fix the bad one, and doing so forced a 
write to that sector, thus triggering the reallocation by the device 
firmware.  (Of course due to btrfs cow, it writes the new copy elsewhere 
too, but apparently in doing so it triggered a write to the old sector as 
well.)

If I hadn't been running raid such that btrfs could find or create from 
parity a second copy, fixing that would have been a lot harder, tho with 
the data from the ata error I could have unmounted and tried to use dd to 
write to exactly that sector, trying to trigger the device's sector 
reallocation that way.  But that's a lot lower level, with a much larger 
chance for user error, particularly as I've never attempted it before.  
With btrfs scrub, I just had to do the scrub and the details were handled 
for me. =:^)

Meanwhile, the device with a raw value of zero reallocated sectors has a 
cooked value of 253 for that attribute.  The device with a raw value of 
20 reallocated sectors has a cooked value of 100, with a threshold value 
of 36.  So I'm watching it.

FWIW, I bought three SSDs at the time, thinking I'd use one for something 
else, which I never did.  So I already have a spare SSD to connect and do 
a btrfs replace, when the time comes.  It's apparently new (not returned 
like the one was), so should last quite some time, based on the fact that 
the one that was new seems to be just fine, so far.  At a guess, the 
current new-at-installation one will be about where the used one was, by 
the time I have to switch out the used one.  So they should stay nicely 
staggered. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

