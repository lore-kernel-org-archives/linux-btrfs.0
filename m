Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56191 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbcAVOv7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 09:51:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aMd48-0000Np-PL
	for linux-btrfs@vger.kernel.org; Fri, 22 Jan 2016 15:51:56 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 15:51:56 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 15:51:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to
 one cpu core?
Date: Fri, 22 Jan 2016 14:51:47 +0000 (UTC)
Message-ID: <pan$3f45c$28137200$2a7440f$6da4e9ad@cox.net>
References: <56A230C3.3080100@netcologne.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christian Rohmann posted on Fri, 22 Jan 2016 14:38:11 +0100 as excerpted:

> I am currently doing a big "btrfs balance" to extend a 8 drive RAID6 to
> 12 drives using
>  "btrfs balance start -dstripes 1..11 -mstripes 1..11"
> 
> With kernel 4.4 and btrfs progs 4.4 it's running fine for a few days now
> and the new disks are slowing getting more and more extents.
> But somehow the process is VERY slow (3% in 3 days) and there is almost
> no additional disk utilization.
> 
> The process doing the balance is doing 100% cpu (one core) so apparently
> the whole thing is very much single threaded and therefore CPU-bound in
> this case.
> 
> Is this a known issue or is there anything I can do to speed this up? I
> mean the disks have plenty of iops left to work with and the box has
> many more CPU cores idling away.

[This is only intended to be a stop-gap reply, until someone with more 
detailed/direct knowledge/experience on the topic can reply.]

My own use-case is btrfs raid1, but from what I've seen on the list, 
raid56 mode maintenance that involves recalculating parity, as converting 
from an 8-device stripe to a 12-device stripe will, is indeed /very/ slow.

I didn't know it was single-core limited, however.  If it's slow/complex 
calculations, AND limited to a single core, plus given the likely size of 
a filesystem of 8-12 devices in the day of multi-TB devices... ~1%/day, 
100 days to complete... Ouch, that's going to be painful!

The good thing is that it happens online, so you can be using the 
filesystem and the other cores while it's happening.  Plus, balances are 
interruptable.  You can reboot or whatever and it should pick up and 
continue where it left off.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

