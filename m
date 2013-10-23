Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39118 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab3JWNKL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 09:10:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VYyCN-0005Xx-23
	for linux-btrfs@vger.kernel.org; Wed, 23 Oct 2013 15:10:07 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 15:10:07 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 15:10:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Itermittent data corruption and dmesg spam
Date: Wed, 23 Oct 2013 13:09:47 +0000 (UTC)
Message-ID: <pan$e329a$d93aeb28$8695cc60$e3bf4121@cox.net>
References: <6844836.rMEZUtNbVg@noether>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henry de Valence posted on Tue, 22 Oct 2013 23:58:33 -0400 as excerpted:

> Second, I’m having some intermittent data corruption issues, and I’m not
> really sure how to pin down the cause. Sometimes, I’ll get errors trying
> to read a file due to a failed checksum, but when I run btrfs scrub, it
> reports that everything is OK. For instance, this time I booted, I get a
> line in dmesg saying
> 
> btrfs: bdev /dev/bcache0 errs: wr 0, rd 0, flush 0, corrupt 16, gen 0
> 
> but when I run btrfs scrub I get:
> 
> scrub status for 56118d27-c9a8-483c-afaa-e429d59884e9
>      scrub started at Tue Oct 22 22:46:17 2013 and finished after 2802
>      seconds total bytes scrubbed: 426.03GB with 0 errors

I know nothing (other than its general purpose) about bcache so I'll stay 
away from that angle, but...

[This takes a bit of a long way around, but comes back to your issue, so 
be patient...]

This reminds me of some years ago when I had some hard to pin down memory 
corruption issues.  Memtest would say everything was OK, and most of the 
time the system was fine, but every once in awhile, things would go 
haywire.  (In my case, one of the most common symptoms was a bunzip2 
failure due to checksum mismatch... but it wasn't the file, it was the 
memory as a retry would bunzip just fine.)  I had occasional mcheck 
errors too, when the hardware would catch the issue.

My problem ultimately turned out to be borderline speed-certified 
memory.  A BIOS update eventually gave me the ability to de-clock the 
memory from its rating just slightly (IIRC from 333 MHz to 330 or some 
such, this was in the DDR1 era), after which I was actually able to 
tighten some of the other ratings (various wait-state settings) a bit and 
get back some of the speed lost by the slightly lower clock.  The memory 
cells themselves were fine thus memcheck coming up clean, and so was the 
bus... most of the time, but at the rated clock speed every once in 
awhile...

Then later I upgraded memory and didn't have the problem at all with the 
new memory, so it was indeed the memory modules that weren't quite 
reliable at the rated speed, NOT the mobo or on-board bus.

Back to your current situation, someone else just recently had a problem 
that, like my memory experience but with storage not memory, traced to a 
SATA system that wasn't quite stable at the rated SATA-3 speeds.  When he 
forced it back to SATA-2, it worked just fine.  (Unfortunately for SATA, 
it's halving the speed, not the loss of a percent or two with a slightly 
lower clock that I was able to do on my memory, and even then make it up 
to some extent with slightly tighter wait-state timings.  But IIRC he was 
on spinning rust anyway, which means the physical platter speed was in 
practice the normal bottleneck anyway so at least he didn't lose much 
except a bit of cache-access-speed.)

So I'd suggest using hdparm or the like to (temporarily) force a lower 
SATA/SAS/whatever speed and see if that helps at all.  If it does, you 
can investigate that further and decide what to do then.  If it doesn't, 
you can return to your normal speeds and no harm done.

Of course the bcache device complicates things a bit, but I guess you can 
try setting speed for both devices one at a time, and possibly try 
disabling the cache and running direct too (assuming that's possible with 
bcache).  But with the exception of those comments, as I said I'll leave 
the bcache stuff for you to figure out as I know little or nothing about 
it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

