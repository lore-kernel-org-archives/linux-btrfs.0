Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42561 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaKCIY4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 03:24:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XlCwZ-0007FO-08
	for linux-btrfs@vger.kernel.org; Mon, 03 Nov 2014 09:24:55 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 09:24:54 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 09:24:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can't mount: open_ctree failed!
Date: Mon, 3 Nov 2014 08:24:43 +0000 (UTC)
Message-ID: <pan$901bb$2d7c5187$2273ad88$c0473d97@cox.net>
References: <m35i04$u5p$1@ger.gmane.org> <5456B0C8.8070402@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Sun, 02 Nov 2014 14:31:36 -0800 as excerpted:

> On 11/02/2014 07:18 AM, Florian Lindner wrote:
>> # btrfsck /dev/sdb1
>> # btrfsck --init-extent-tree /dev/sdb1
>> # btrfsck --init-csum-tree /dev/sdb1
> 
> Notably missing from all these commands is "--repair"...
> 
> I don't know that's your problem for sure, but it's where I would
> start...

Well, btrfs check --repair has been actively discouraged for some time, 
unless (one or more of three):

1) You have a backup of the raw devices (which of course means you must 
have room for it).

2) Your next step would be to give up and do a mkfs, since in that case 
you're taking zero additional risk.

3) You have posted here with the logs, etc, and a btrfs dev has suggested 
using --repair as the problem indicated in the logs is known to be 
handled correctly by btrfs check --repair.


The problem is that while btrfs check getting better, certainly when the
--repair option was first introduced and still to some extent, there's a 
non-zero risk that btrfs check won't recognize and fix the real problem, 
but instead will make the situation worse.

So STARTING with --repair has been actively discouraged.

That said, the --init-* options are pretty serious already, with their 
own risks, and indeed, in the general case (that is, where --init-* isn't 
known to be the correct fix based on the logs), I'd suggest trying
--repair before trying them.

But do be careful about suggesting that people /start/ with --repair, 
because there have certainly been people who posted logs where some other 
fix was indicated, that ended up making things unrecoverable because
--repair did the wrong thing for that error at that point in time, 
screwing things up such that even btrfs restore couldn't retrieve files.  
I think it has actually been awhile since the risk of --repair seriously 
damaging the filesystem instead of simply refusing to do anything if it 
didn't understand the problem was substantial, but it's still non-zero, 
and if people don't have backups and want anything off the filesystem, 
either getting full raw device backups first or doing the btrfs restore 
first to get what they can off the filesystem without chance of damaging 
it further, before trying anything that does have such a chance, even if 
it's remote, is a good idea.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

