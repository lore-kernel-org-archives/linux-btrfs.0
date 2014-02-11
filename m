Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57223 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaBKUgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 15:36:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WDK3b-0003Rf-Jt
	for linux-btrfs@vger.kernel.org; Tue, 11 Feb 2014 21:35:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 21:35:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 21:35:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
Date: Tue, 11 Feb 2014 20:35:19 +0000 (UTC)
Message-ID: <pan$9c91a$c8fe6c36$f85dce0f$d0a92204@cox.net>
References: <20140209224055.3175e70f@system>
	<191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
	<20140211041527.57ef96c4@system>
	<pan$e606d$929b6b8a$283bf1a2$38f7ec5@cox.net>
	<CAJbEPe44PoBQkovMz=-w=A4DYYS2vAVoS+29z7J8Q+xaQrYGXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Saint Germain posted on Tue, 11 Feb 2014 11:04:57 +0100 as excerpted:

> The big problem I currently have is that based on your input, I hesitate
> a lot on my partitioning scheme: should I use a dedicated /boot
> partition or should I have one global BTRFS partition ?
> It is not very clear in the doc (a lof of people used a dedicated /boot
> because at that time, grub couldn't natively boot BTRFS it seems, but it
> has changed).
> Could you recommend a partitioning scheme for a simple RAID1 with 2
> identical hard drives (just for home computing, not business).

FWIW... I'm planning to and have your previous message covering that 
still marked unread to reply to later.  But "real life" has temporarily 
been monopolizing my time so the last day or two I've only done 
relatively short and quick replies.  That one will require a bit more 
time to answer to my satisfaction.

So I'm punting for the moment.  But FWIW I tend to be a reasonably heavy 
partitioner (tho nowhere near what I used to be), so a lot of folks will 
consider my setup somewhat extreme.  That's OK.  It's my computer, setup 
for my purposes, not their computer for theirs, and it works very well 
for me, so it's all good. =:^)

But hopefully I'll get back to that with a longer reply by the end of the 
week.  If I don't, you can probably consider that monopoly lasting longer 
than I thought, and it could be that I'll never get back to properly 
reply.  But it's an interesting enough topic to me that I'll /probably/ 
get back, just not right ATM.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

