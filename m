Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53269 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbbEABsd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 21:48:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yo046-0004uE-Ac
	for linux-btrfs@vger.kernel.org; Fri, 01 May 2015 03:48:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 May 2015 03:48:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 May 2015 03:48:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [REGRESSION] Hang during backup with rsync
Date: Fri, 1 May 2015 01:48:23 +0000 (UTC)
Message-ID: <pan$b4d5f$f3e14022$274533d9$ff98a48f@cox.net>
References: <1943792.PglQ59K4TH@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Thu, 30 Apr 2015 19:29:57 +0200 as excerpted:

> The hang was: Mouse pointer in KDE not movable anymore, Ctrl-Alt-F1 had
> no effect. I waited for a minute at least. Maybe it would have reacted
> after a longer time, but I wanted my machine back. Disks where idle, if
> I remember correctly. After reboot both filesystems mount okay.

This response is in regard to what to do at an apparent hang, and has 
nothing directly to do with btrfs...

Two comments:

1) Depending on your graphics hardware and driver config, a modern 
"KMS" (kernel modesetting) setup is more likely to "soft" hang in X mode 
and not switch back to text mode, even when the system is otherwise not 
hung and a VT switch would have worked fine pre-KMS-era.

While I'm no kernel or graphics expert, the problem from here /seems/ to 
be that a modern KMS kernel generally uses high-res framebuffer mode at 
the CLI as well, and because the basic kernel handling is unified 
framebuffer and kernel-mode-switching for both X and CLI modes, switching 
from X to CLI doesn't involve switching to the entirely separate VGA mode 
driver and with it the forced hardware reset that it used to.  Without 
that driver switch and forced reset, even if the switch actually occurs 
successfully in terms of what you might type, what is actually displayed 
may remain frozen, such that if you only have a local session, you 
generally have to reboot anyway, but if you already have a CLI login 
going in the VT you tried to switch to or can login blind, sometimes you 
can at least manage a controlled reboot, by doing an init 6 or systemctl 
reboot or whatever, even if the display is frozen and shows nothing.  Of 
course it doesn't always work, but given the chance to avoid an unclean 
shutdown, try it and see.

So no response at an attempted VT switch (your ctrl-alt-F1) doesn't mean 
what it used to...

2) Along the same lines, there's the kernel's magic-sysrequest (sysrq/srq) 
functionality.  Assuming you have it enabled in your kernel, you can try 
a series of alt-sysrq-key sequences and very possibly use that to avoid 
an entirely uncontrolled shutdown, even when major functionality upto and 
including all of userspace is non-functional.

There's enough explanations written and googlable on the subject that 
I'll avoid a full explanation here, but the main point I have to make is 
that in addition to often allowing a semi-controlled shutdown/reboot, by 
using the keys in the prescribed sequence and noting at which point (if 
any) you actually get a response, you get at least some indication of how 
badly your system was actually locked up.

What I'd try first, right after the VT switch didn't work, is alt-srq-k.  
Called the secure-term sequence as it can be used to help avoid suspected 
keyloggers of certain (but not all) types, this tells the kernel to force-
kill anything running on your current VT and reset it.  This can be used 
to kill an unresponsive X, for instance, and normally you'll get 
automatically switched to a CLI login, either due to automatic switching 
back to a previous VT (in the case of X on its own VT), or to automatic 
respawning of the login after the kernel kills it along with whatever 
else you were doing if you were already at the CLI.

This alt-srq-k sequence is thus a good first fallback if ctrl-alt-Fx 
appears to do nothing, since it apparently forces the VT reset that 
switching to a VGAmode CLI used to, that switching to a KMS mode CLI 
doesn't.

If that doesn't work, it's time for the usual REISUB sequence,

* alt-srq-r (unraw the input, take out of X mode)

* alt-srq-e (tErminate, aka SIGTERM, all of userspace, allowing anything 
still alive to terminate gracefully if it can)

* alt-srq-i (kIll, aka SIGKILL, all userspace, forcefully killing 
anything that ignored the SIGTERM but still allowing the kernel to do 
normal cleanup if it can)

(Tho from my own experience, if the K and R sequences don't help, then 
the E and I sequences aren't likely to do much either, as they're 
probably locked up bad enough that nothing will be gained, but OTOH, 
nothing is lost by trying them, either.)

* alt-srq-s (Sync, force an emergency sync to storage of anything still 
write-cached)

alt-srq-s can be used at any time, without disrupting normal operation 
except for any I/O triggered by the forced sync.  I've come to use it 
regularly immediately before I do anything that I think /might/ trigger 
system instability, so everything's synced before I try it, just in 
case.  Think of this as a forced version of the sync command.

* alt-srq-u (remoUnt read-only, forcing all still functional filesystems 
read-only)

The S and U steps are critical to a semi-controlled shutdown, and where 
they work, can often mean the difference between a filesystem with no 
errors on reboot as the kernel saved and cleanly mounted read-only to the 
extent it could, and various filesystem corruptions, if these steps 
weren't done or if the kernel was badly enough corrupted it was afraid to 
write anything lest it make the problem worse.

* alt-srq-b (reBoot, force a reboot without any further cleanup).


Now:

* If the K/secure-term doesn't work you know there's some issue.  Often 
this can be graphics related, if the other steps work.

* Normally, on issue of the S/sync, you'll see a burst of storage device 
activity as the kernel syncs all dirty writebuffers.  If you have the 
common storage device activity LED, you'll see it there.

If you don't see activity on the S/sync and/or U/remoUnt steps, you know 
the system is pretty far dead, and can expect filesystem errors on reboot.

* Finally, if the kernel responds to the B/reBoot step, but you did *NOT* 
see activity at the S and/or U steps, then you know that the kernel was 
still alive enough to respond to magic-srq and do the reboot, but that it 
thought itself corrupted and thus feared to write to storage for the sync 
and remount steps as it couldn't guarantee it wouldn't scribble somewhere 
other than where it should be writing, thus risking corrupting things 
even worse than an unclean shutdown might.


So, when I see descriptions of apparent system hangs such as yours, 
above, a big thing I look for is whether the K/REISUB magic-srq sequences 
were tried, and if so, at which step, if any, the kernel responded.

* If the user was in X and the secure-term K sequence worked, the problem 
wasn't too bad, and may have been a graphics system issue.

* If the S and R sequences worked, then the problem was worse, but either 
wasn't storage related, or at least was minor enough that the kernel felt 
it safe to sync and remount.

* If only the B sequence responded, then at least the kernel was still 
alive, but it considered the situation serious enough that it dare not do 
the sync/remount writes lest it risk scribbling on other partitions, etc.

* If not even the B sequence responded, then the kernel was effectively 
dead as well, and the problem was very serious indeed!

Unfortunately, the above hang description doesn't mention trying magic 
sysrq at all, and assuming you didn't try them, not only did you 
potentially needlessly endanger your data (if the S/R steps would have 
worked), but now we are missing that key bit of information about how 
badly the kernel /itself/ thought things were.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

