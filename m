Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55001 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984AbaLBWm2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 17:42:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xvw9I-0002Bc-Qv
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 23:42:24 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 23:42:24 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 23:42:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs stuck with lot's of files
Date: Tue, 2 Dec 2014 22:42:10 +0000 (UTC)
Message-ID: <pan$198ba$a9250423$a431044e$2b1dca0b@cox.net>
References: <1417434411.20237.1.camel@gentoo.org>
	<547CB7D0.4040800@pobox.com> <1417485029.4310.22.camel@gentoo.org>
	<pan$9649c$5bf442fc$686ccac2$96f1d79b@cox.net>
	<20141202185613.72992959@spike.private.network>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ian Armstrong posted on Tue, 02 Dec 2014 18:56:13 +0000 as excerpted:

> On Tue, 2 Dec 2014 12:48:21 +0000 (UTC)
> Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> FWIW, agreed that it's unlikely to be the drive, especially if you're
>> not seeing bus resets or drive errors in dmesg and smart says the drive
>> is fine, as I expect it does/will.  It may be a btrfs bug or scaling
>> issue, of which btrfs still has some, or it could simply be the single
>> mode vs raid0 mode issue I explain below.
> 
> I encountered a similar problem here a few days ago on a btrfs raid1
> partition while using rsync to clone a (~30GB) directory.
> 
> Everything started fine, but I came back an hour later to find rsync had
> apparently stalled at about 20% with cpu usage at 100% on a single
> kworker thread. I was able to kill rsync eventually, and after a while
> (don't know how long, but >10 minutes) cpu usage returned to normal.
> Restarting rsync resulted in kworker at 100% cpu in less than a minute.
> Once stalled there was little drive access happening. Another raid1
> partition (mdadm/ext4) on the same drive pair was having no problems.
> Nothing showed in the system logs.
> 
> In this instance I'd forgotten to delete a temporary 500GB file before
> starting rsync, so although recently balanced (musage=80/dusage=80) it
> was running at near capacity.
> 
> After a reboot, deleting the 500GB file & running balance, everything
> returned to normal. Ran rsync again & it completed fine.
> 
> Running slackware current, with Kernel 3.16.4

FWIW that was my point -- there are still such bugs out there, often 
corner-case so they don't affect most folks most of the time, but out 
there.

I had a similar stall recently, a kworker stuck at 100% that went away 
after I killed whatever app had triggered the problem (pan, the news 
program I'm writing this with, as it happens).  In my case I chalked it 
up to a known corner-case bug in my slightly old 3.17.0 kernel (my use-
case doesn't do read-only snapshots so I'm not affected by that known bug 
that effectively blacklists 3.17.0 for some users; this would have been a 
different one).  I don't /know/ it was that bug, but it most likely was, 
as it's a known but rare corner-case that AFAIK is already fixed in the 
late 3.18-rcs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

