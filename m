Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59988 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbbLNLwK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 06:52:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a8Rfg-0002vH-2w
	for linux-btrfs@vger.kernel.org; Mon, 14 Dec 2015 12:52:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 12:52:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 12:52:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check inconsistency with raid1, part 1
Date: Mon, 14 Dec 2015 11:51:57 +0000 (UTC)
Message-ID: <pan$c4332$ebbeb2d6$2298daa7$4db71b7a@cox.net>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
	<566E584B.5040104@cn.fujitsu.com>
	<CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 14 Dec 2015 00:24:21 -0700 as excerpted:

>> Personally speaking, it may be a false alert from btrfsck.
>> So in this case, I can't provide much help.
>>
>> If you're brave enough, mount it rw to see what will happen(although it
>> may mount just OK).
> 
> I'm brave enough. I'll give it a try tomorrow unless there's another
> request for more info before then.

Given the off-by-one generations and my own btrfs raid1 experience, I'm 
guessing the likely result is a good mount and either no problems or a 
good initial mount but lockup once you try actually doing too much (like 
actually reading the affected blocks) with the filesystem.

Looks like a normal generation-out-of-sync condition, common with forced 
unsynced/not-remounted-ro shutdowns.  If so, btrfs should redirect reads 
to the updated current generation device, but you'll need to do a scrub 
to get everything 100% back in sync.

The catch I found, at least when I still had the then-failing (but not 
failed, it was just finding more and more sectors that needed redirected 
to spares) ssd still in my raid1, also with an on-boot service that read 
a rather large dir into cache, was that after so many errors from the 
failing device, instead of continuing to redirect errors to the good 
device, btrfs just gives up, which resulted in a system crash, here.

But when there weren't that many errors on the failing device, or when I 
intercepted the boot process and mounted everything but didn't run normal 
post-mount services (systemd emergency target instead of my usual default 
multi-user) so the service that cached that dir didn't have a chance to 
run, so all those errors didn't trigger, I could still mount normally, 
and from there, I could run scrub, which took care of the problem without 
triggering the usual too many errors crash, and after scrub, I could 
invoke normal multi-user mode and start all services including the 
caching service, and go about my usual business.

So if I'm correct, mount normally and scrub, and you should be fine, tho 
you may have to abort a normal boot if it accesses too many bad files, in 
ordered to be able to finish the scrub before a crash.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

