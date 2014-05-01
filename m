Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51012 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaEARQZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 May 2014 13:16:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wfuau-0000jw-HX
	for linux-btrfs@vger.kernel.org; Thu, 01 May 2014 19:16:24 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 19:16:24 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 19:16:24 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: task sync:2450 blocked for more than 120 seconds.
Date: Thu, 1 May 2014 17:16:06 +0000 (UTC)
Message-ID: <pan$5efeb$21e4ebfc$652f5a00$7fae9e71@cox.net>
References: <ljq5o6$f0d$1@ger.gmane.org> <ljsvpb$cl6$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Neuer User posted on Thu, 01 May 2014 10:14:35 +0200 as excerpted:

> It's probably best to copy al my data to another disk, then delete the
> parttiion and make a new ext4 partition. btrfs is probably still too
> experimental, I guess.

I thought I replied to this one but it was to a different, similar 
problem, post.

The blocked task bug isn't entirely uncommon, and is apparently a number 
of bugs with similar symptoms.  One thing the devs have been requesting 
on such reports is the output from a sysrq-w, which dumps the blocked 
tasks so the devs can trace where the blocks are happening and fix the 
bugs.  Either alt-sysrq-w, if you're running direct on hardware, or
echo w > /proc/sysrq-trigger, which should work in VMs, etc, as well.

But you're correct, tracking down and fixing all these bugs is likely to 
take awhile, and if you simply want something that works and don't have 
the luxury of testing and waiting for fixes, switching back to ext4 or 
whatever, until btrfs has matured a bit longer, would be the recommended 
course of action.

And one more comment, a hint for next time.  On mailing lists it's common 
to quote what you're replying to and reply below it.  Top posting the 
reply works for that post, but messes things up for others trying to 
reply to the thread as well and for later readers, since now there's 
either a mixture of top-posted and in-context-posted replies at multiple 
levels or people end up omitting entirely the second level and deeper 
quotes that might have put the whole thing in context.  Either case makes 
the thread difficult to follow or to properly reply to. =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

