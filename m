Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53334 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbLaJee (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 04:34:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aEZcs-0007rn-D6
	for linux-btrfs@vger.kernel.org; Thu, 31 Dec 2015 10:34:30 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 10:34:30 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 10:34:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS - Write Barriers
Date: Thu, 31 Dec 2015 09:34:24 +0000 (UTC)
Message-ID: <pan$a3e98$17648899$36c99b28$62a3ab29@cox.net>
References: <4794805.EoAJ2iVUQK@orione>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fugazzi® posted on Thu, 31 Dec 2015 09:01:51 +0000 as excerpted:

> Just one question for the gurus here.
> 
> I was wondering: if I disable write barriers in btrfs with the mount
> option nobarrier I just disable the periodic flushes of the hardware
> disk cache or I'm disabling also the order of the writes directed to the
> hard disk?
> 
> What I mean is: is it safe to disable write barrier with a UPS with
> which I will likely have the hardware always powered even in the event
> of a kernel crash, freeze, etc?
> 
> I'm asking because if also the ordering of the write is no more
> guaranteed I guess it would not be safe to disable write barrier even if
> the possibility of an unexpected power down of the HD was remote because
> in the case of a crash the order of the write would be messed up anyway
> and we could boot up with a completely corrupted fs.

>From the wiki mount options page:

https://btrfs.wiki.kernel.org/index.php/Mount_options

>>>>>

nobarrier

Do not use device barriers. NOTE: Using this option greatly increases the 
chances of you experiencing data corruption during a system crash or a 
power failure. This means full file-system corruption, and not just 
losing or corrupting data that was being written during the event. 

<<<<<

IOW, use at your own risk.

In theory you should be fine if you *NEVER* have a system crash (it's not 
just loss of power!), but as btrfs itself is still "stabilizING, not yet 
fully stable and mature", it can itself crash the system occasionally, 
and while that's normally OK as the atomic transaction nature of btrfs 
and the fact that it crashes or at minimum forces itself to read-only if 
it thinks something's wrong will normally save the filesystem from too 
much damage, if it happens to get into that state with nobarrier set, 
then all bets are off, because the normally atomic transactions that 
would either all be there or not be there at all are no onger atomic, and 
who knows /what/ sort of state you'll be in when you reboot.

So while it's there for the foolish, and perhaps the slightly less 
foolish once the filesystem fully stabilizes and matures, right now, you 
really /are/ playing Russian roulette with your data if you turn it on.

I'd personally recommend staying about as far away from it as you do the 
uninsulated live service mains coming into your building... on the SUPPLY 
side of the voltage stepdown transformer!  And for those that don't do 
that, well, there's Darwin awards.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

