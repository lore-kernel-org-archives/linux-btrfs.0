Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36627 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab3HXL5D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 07:57:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VDCSi-000731-TM
	for linux-btrfs@vger.kernel.org; Sat, 24 Aug 2013 13:57:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 13:57:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Aug 2013 13:57:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help interpreting RAID1 space allocation
Date: Sat, 24 Aug 2013 11:56:42 +0000 (UTC)
Message-ID: <pan$6915b$40024f4d$2b0976b0$d4dddbcf@cox.net>
References: <25d36b2410416c9a767766fb9be313b6@lixil.net> <
	C0968F38-8432-41C3-B916-DC00C5C69B34@colorremedies.com> <
	27E06913-DDBB-4B75-86D3-A8F6C5B09F99@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 23 Aug 2013 22:58:14 -0600 as excerpted:

> So it says it's degraded but it really isn't?
> I'm not sure what's up here.

In general, this was my experience a couple months ago when I tried it 
then, as well.

And yes, IIRC the wiki actually describes the "degraded" mount option as 
allowing it to mount "degraded" IF NECESSARY, NOT saying that it'll force 
degraded.

I found one additional quirk, however, which was rather disturbing.  You 
may recall my thread about it then...

Background:  I was actually trying to mount a dual device raid1 root 
without an initr*, using rootflags=device=.  However, that didn't work.  
The only way I could mount from the kernel commandline was using 
degraded.  (I'm guessing the double-equals in the rootflags=device= got 
parsed incorrectly, probably trying to take rootflags=device as the name, 
which of course doesn't apply to anything, as it should be rootflags.  
This because it definitely took the rootflags=degraded parameter just 
fine.  That'd be a kernel bug, but I'm not sure that's it; I just know 
others have reported trouble with rootflags=device=whatever on this list, 
as well.)

So, while I was trying to get it to work (while I was still 
experimenting, and before I gave up and setup a simple initramfs using 
dracut), I booted with root=/dev/sdaX rootflags=degraded, and it worked.  
I then made a change to the filesystem, and rebooted again to the other 
one, using root=/dev/sdbX rootflags=degraded, and that worked too.  I 
then made a different change to the same file, thus diverging the two 
separately mounted devices with a different write to each one.

Then I rebooted back to my main system (not yet on btrfs at that point), 
and mounted the btrfs normally -- it mounted without the degraded option 
as both devices were found in the scan, DESPITE the fact that the two 
component devices now had diverged content.  I checked and the later 
change was shown, and there were no errors or warnings with the mount or 
with reading the file.

I then booted degraded again, to the one with the other change, AND IT 
STILL HAD THE CHANGE I HAD WRITTEN!!!

So the mount of both together had given me NO WARNING OR ERROR about 
diverged copies; it simply showed one of them.  BUT THE OTHER ONE WASN'T 
AUTO-DETECTED OR FIXED, EITHER.

With mdraid, attempting to mount (well, re-add, in the case of mdraid) 
with both devices would have triggered an automatic resync.  I expected 
at LEAST a warning with btrfs, but I didn't get it.  I guess I'd have had 
to manually initiate a scrub to detect and fix it, but was new enough to 
(multi-device) btrfs at the time that trying that didn't occur to me.  
I'm not sure what a full rebalance would have done.

That was rather disturbing to me, to say the least.

But for my usage, knowing and noting the problem to avoid in the future 
was enough.

I blew away my (then) test btrfs with a fresh mkfs.btrfs raid1 both data 
and metadata, copied root from my main system over to it once again, and 
set it up with an initr* mount to avoid kernel commandline degraded-
mounting.  Meanwhile, I don't do any more degraded tests.  I do scrubs 
every so often (after a bad shutdown the other day I actually had a scrub 
find and fix some bad checksums for the first time, and files that were 
definitely giving problems before the scrub worked just fine afterward, 
so I was glad I had btrfs checksums and raid1 copies to restore, the 
feature worked as advertised! =:^), and...

If I ever do lose a device and have to go degraded, I know *NOT* to try 
degraded-mounting both devices read/write separately, and then 
recombining them once again.  If I need to degraded-mount one, fine, but 
I'll make sure it's only the one, and if I do mount the other, I'll 
either mount it read-only, or if I do end up mounting them both read/
write, I'll blow one away and then add it as a new device, in ordered to 
avoid having problems figuring out which divergent copy I'm going to be 
dealing with once I'm using both devices again.

With that sort of ground rule, I think I should be fine.  But it's 
certainly a lot different than mdraid works in the same setup.  Btrfs 
definitely has its own raid1 rules -- the mdraid raid1 rules do *NOT* 
apply.

Meanwhile, hopefully at some point as btrfs heads toward stable, it gets 
a write signature or whatever it is that mdraid has, so it can detect and 
warn when raid1 devices diverge, and ideally can auto-sync, at least if 
configured to do so.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

