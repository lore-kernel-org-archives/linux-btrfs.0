Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48278 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbaD1Bs1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 21:48:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WeagE-0002CQ-E7
	for linux-btrfs@vger.kernel.org; Mon, 28 Apr 2014 03:48:26 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 03:48:26 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 03:48:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Confusing output of btrfs fi df
Date: Mon, 28 Apr 2014 01:48:15 +0000 (UTC)
Message-ID: <pan$bf8bb$295ee5d2$1cf4d367$4ef83ac5@cox.net>
References: <20140427153726.GA20596@mars>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Malte Schumacher posted on Sun, 27 Apr 2014 17:37:26 +0200 as
excerpted:

> Chris and Duncan: I tried both your suggestions but unfortunately
> without success. Here is the output:
> 
> mars:~ # btrfs balance start -susage=0 -f -v /mnt/btrfs/
> Dumping filters: flags 0xa, state 0x0, force is on
>   SYSTEM (flags 0x2): balancing, usage=0
>   Done, had to relocate 0 out of 2708 chunks
>   
> mars:~ # btrfs fi df /mnt/btrfs/
>   Data, RAID1: total=2.64TiB, used=2.22TiB
>   System, RAID1: total=8.00MiB, used=380.00KiB
>   System, single: total=4.00MiB, used=0.00
>   Metadata, RAID1: total=4.00GiB, used=2.94GiB
> --------------------------------------------
> 
> mars:~ # btrfs balance start -sconvert=raid1,soft -f -v /mnt/btrfs/
> Dumping filters: flags 0xa, state 0x0, force is on
>   SYSTEM (flags 0x300): converting, target=16, soft is on
>   Done, had to relocate 0 out of 2708 chunks
> 
> mars:~ # btrfs fi df /mnt/btrfs/
>   Data, RAID1: total=2.64TiB, used=2.22TiB
>   System, RAID1: total=8.00MiB, used=380.00KiB
>   System, single: total=4.00MiB, used=0.00
>   Metadata, RAID1: total=4.00GiB, used=2.94GiB

OK, this is interesting  It may be that you're reproducing something a 
couple other people saw earlier, but I've never seen here, which might be 
because I tend to do -m<whatever (metadata) and let it handle -s/system 
at the same time, instead of doing -s<whatever> explicitly.

So try this one:

btrfs balance start -musage=0 -v

(-f shouldn't be needed for this one because you're not doing -s 
specifically, and not forcing a lower redundancy level.)

It may or may not free a couple metadata chunks too, but at least here, 
that's /exactly/ what I've used, and it has /never/ failed to cleanup 
that unused system chunk.

If that fails to remove the extra system chunk, then we have a mystery 
indeed.  What's different on your system and why isn't it working?

If it succeeds in removing it, then we have a different and more limited 
bug/mystery.  -s sometimes ignores system chunks it's documented to 
balance, while -m is doing both metadata and system, as expected.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

