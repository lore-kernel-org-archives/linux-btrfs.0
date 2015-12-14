Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44061 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbbLNGvy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 01:51:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a8Mz5-00007X-Cd
	for linux-btrfs@vger.kernel.org; Mon, 14 Dec 2015 07:51:47 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 07:51:47 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 07:51:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel lockup, might be helpful log.
Date: Mon, 14 Dec 2015 06:51:41 +0000 (UTC)
Message-ID: <pan$42e96$8159f644$233ed3aa$27e4f2e6@cox.net>
References: <566DF757.8020807@birds-are-nice.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Birdsarenice posted on Sun, 13 Dec 2015 22:55:19 +0000 as excerpted:

> Meanwhile, I did get lucky: At one crash I happened to be logged in and
> was able to hit dmesg seconds before it went completely. So what I have
> here is information that looks like it'll help you track down a
> rarely-encountered and hard-to-reproduce bug which can cause the system
> to lock up completely in event of certain types of hard drive failure.
> It might be nothing, but perhaps someone will find it of use - because
> it'd be a tricky one to both reproduce and get a good error report if it
> did occur.
> 
> I see an 'invalid opcode' error in here, that's pretty unusual

Disclaimer:  I'm a list regular and (small-scale) sysadmin, not a dev, 
and most certainly not a btrfs dev.  Take what I saw with that in mind, 
tho I've been active on-list for over a year and thus now have a 
reasonable level of practical sysadmin configuration and crisis recovery 
level btrfs experience.

You could well be quite correct with the unusual crash log and its value, 
I'll leave that up to the devs to decide, but that "invalid opcode: 0000" 
bit is in fact not at all unusual on btrfs.  Tho I can say it fooled me 
originally as well, because it certainly /looks/ both suspicious and in 
general unusual.

Based on how a dev explained it to me, I believe btrfs actually 
deliberately uses opcode 0000 to trigger a semi-controlled crash in 
instances where code that "should never happen" actually gets executed 
for some reason, leaving the kernel is an unknown and thus not 
trustworthy enough to reliably write to storage devices and do a 
controlled shutdown.  That's of course why the tracebacks are there, to 
help the devs figure out where it was and what triggered it, but the 0000 
opcode itself is actually quite frequently found in these tracebacks, 
because it's the method chosen to deliberately trigger them.

I'd guess the same technique is actually used in various other (non-
btrfs) kernel code as well, but in fully stable code it actually is very 
rarely seen, precisely because it /does/ mean the kernel reached code 
that it is never expected to reach, meaning something specific went wrong 
to get to that point, and in fully stable code, it's rare that any code 
paths actually leading to that sort of execution point remain, as they've 
all been found over the years.

But of course btrfs, while no longer experimental, remains "still 
stabilizing and maturing, not yet fully stable or mature", so there's 
still code paths left that do still occasionally reach these intended to 
be unreachable code points, and when that happens, triggering a crash and 
hopefully getting a traceback that helps the devs figure out which code 
path has the bug and why, is a good thing to do, and this is apparently 
the way it's done.

(BTW, compliments on the nick and email address. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

