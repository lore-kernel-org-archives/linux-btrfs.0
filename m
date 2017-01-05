Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55270 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1033461AbdAEJXz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jan 2017 04:23:55 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cP4Gw-0004ko-G5
        for linux-btrfs@vger.kernel.org; Thu, 05 Jan 2017 10:23:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: kernel crash after upgrading to 4.9
Date: Thu, 5 Jan 2017 09:23:35 +0000 (UTC)
Message-ID: <pan$bae57$81ae2edc$f6b8d81e$acf53525@cox.net>
References: <c0d145b6-6c81-ef52-4876-85eab927bae7@techsquare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matt McKinnon posted on Wed, 04 Jan 2017 10:25:17 -0500 as excerpted:

> Hi All,
> 
> I seem to have a similar issue to a subject in December:
> 
> Subject: page allocation stall in kernel 4.9 when copying files from one
> btrfs hdd to another
> 
> In my case, this is caused when rsync'ing large amounts of data over NFS
> to the server with the BTRFS file system.  This was not apparent in the
> previous kernel (4.7).
> 
> The poster mentioned some suggestions from Ducan here:
> 
> https://mail-archive.com/linux-btrfs@vger.kernel.org/msg60083.html
> 
> But those are not visible in the thread.  What suggestions were given to
> help alleviate this pain?

In his case the copying was from 7.2krpm to 5.6krpm drives, but not the 
reverse or when copying from slower to faster.

I said that sounded very much like an earlier bug report to both this 
list and LKML, where Linus responded, suggesting twiddling the dirty_* 
writecache knobs...  Here's my earlier post there quoted (nearly) 
verbatim, including footnotes.  I don't know how much memory your system 
has but the below numbers for my 16 GB system should give you a 
reasonable idea for initial ballpark settings...

It's generally accepted wisdom among kernel devs and sysadmins[1] that 
the existing dirty* write-cache defaults, set at a time when common 
system memories measured in the MiB, not the GiB of today, are no longer 
appropriate and should be lowered, but the lack of agreement as to 
precisely what the settings should be, combined with inertia and the lack 
of practical pressure given that those who know about the problem have 
long since adjusted their own systems accordingly, means the existing now 
generally agreed to be inappropriate defaults continue to remain. =:^(

These knobs can be tweaked in several ways.  For temporary 
experimentation, it's generally easiest to write (as root) updated values 
directly to the /proc/sys/vm/dirty_* files themselves.  Once you find 
values you are comfortable with, most distros have an existing sysctl 
config[2] that can be altered as appropriate, so the settings get 
reapplied at each boot.

Various articles with the details are easily googled so I'll be brief 
here, but here's the apropos settings and comments from my own
/etc/sysctl.conf and a brief explanation:

# write-cache, foreground/background flushing
# vm.dirty_ratio = 10 (% of RAM)
# make it 3% of 16G ~ half a gig
vm.dirty_ratio = 3
# vm.dirty_bytes = 0

# vm.dirty_background_ratio = 5 (% of RAM)
# make it 1% of 16G ~ 160 M
vm.dirty_background_ratio = 1
# vm.dirty_background_bytes = 0

# vm.dirty_expire_centisecs = 2999 (30 sec)
# vm.dirty_writeback_centisecs = 499 (5 sec)
# make it 10 sec
vm.dirty_writeback_centisecs = 1000


The *_bytes and *_ratio files configure the same thing in different ways, 
ratio being percentage of RAM, bytes being... bytes.  Set one or the 
other as you prefer and the other one will be automatically zeroed out.  
The vm.dirty_background_* settings control when the kernel starts lower 
priority flushing, while high priority vm.dirty_* (not background) 
settings control when the kernel forces threads trying to do further 
writes to wait until some currently in-flight writes are completed.

(Rereading this now, I seem to have been inaccurate on one detail.  I'm 
not a dev and definitely not a kernel dev, but from what I've read, once 
foreground writeback is triggered, the kernel actually accounts writes to 
the threads actually doing the writing, causing them to spend much of 
their time they'd otherwise be using to dirty even more memory in IO-
wait, waiting to write out memory they've already dirtied, thus 
throttling their ability to dirty even more memory, ultimately slowing 
down their ability to dirty memory to the speed at which writeback is 
actually occurring.)

But those values only apply to size up until the expiry time has 
occurred, at which point writeback is still forced.  That's where that 
setting comes in.

The problem is that memory has gotten bigger much faster than the speed 
of actually writing out to slow spinning rust has increased. (Fast ssds 
have far less issues in this regard, tho slow flash like common USB thumb 
drives remain affected, indeed, sometimes even more so.)  Common random-
write spinning rust write speeds are 100 MiB/sec and may be as low as 30 
MiB/sec.  Meanwhile, the default 10% dirty_ratio, at 16 GiB memory size, 
approaches[3] 1.6 GiB, ~1600 MiB.  At 100 MiB/sec that's 16 seconds worth 
of writeback to clear.  At 30 MiB/sec, that's... well beyond the 30 
second expiry time!

To be clear, there's still a bug if the system crashes as a result -- the 
normal case should simply be a system that at worst doesn't respond for 
the writeback period, to be sure a problem in itself when that period 
exceeds double-digit seconds, but surely less of one than a total crash, 
as long as the system /does/ come back after perhaps half a minute or so.

Anyway, as you can see from the above excerpt from my own sysctl.conf, 
for my 16 GiB system, I use a much more reasonable 1% background writeback 
trigger, ~160 MiB on 16 GiB, and 3% high-priority/foreground, ~ half a 
GiB on 16 GiB.  I actually set those long ago, before I switched to btrfs 
and before I switched to ssd as well, but even tho ssd should work far 
better with the defaults than spinning rust does, those settings don't 
hurt on ssd either, and I've seen no reason to change them.

So try 1% background and 3% foreground flushing ratios on your 32 GiB 
system as well, and see if that helps, or possibly try setting the _bytes 
values instead, since 1% is still quite huge in writeback time terms, on 
32 GiB.  Tweaking those down on the previously reported bug certainly 
helped there as he couldn't reproduce after that, and it looks like 
you're running 2+ GiB dirty based on your posted meminfo now, so it 
should reduce that, and hopefully eliminate the trigger for you, tho of 
course it won't fix the root bug.  As I said it shouldn't crash in any 
case, even if it goes unresponsive for half a minute or so at a time, so 
there's certainly a bug to fix, but that will hopefully let you work 
without running into it.

Again, you can write the new values direct to the proc interface without 
rebooting, for experimentation.  Once you find values appropriate for 
you, however, write them to sysctl.conf or whatever your distro uses 
instead, so they get applied automatically at each boot.

---
[1] Sysadmins:  Like me, no claim to dev here, nor am I a professional 
sysadmin, but arguably I do take the responsibility of adminning my own 
systems more seriously than most appear to, enough to claim sysadmin as 
an appropriate descriptor.

[2] Sysctl config.  Look in /etc/sysctl.d/* and/or /etc/sysctl.conf, as 
appropriate to your distro.

[3] Approaches: The memory figure used for calculating this percentage 
excludes some things so it won't actually reach 10% of total memory.  But 
the exclusions are small enough that they can be hand-waved away for 
purposes of this discussion.



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

