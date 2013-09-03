Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45409 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab3ICPic (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 11:38:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VGsgZ-0003Gz-D7
	for linux-btrfs@vger.kernel.org; Tue, 03 Sep 2013 17:38:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 17:38:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 17:38:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how long should btrfs fi balance take?
Date: Tue, 3 Sep 2013 15:38:08 +0000 (UTC)
Message-ID: <pan$2cffb$e1ffc74d$ec98967$4c4556a7@cox.net>
References: <201309031821.35507.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Tue, 03 Sep 2013 18:21:35 +1000 as excerpted:

> # btrfs filesystem df /
> Data: total=100.57GB, used=77.00GB
> System, DUP: total=8.00MB, used=24.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=3.50GB, used=2.35GB
> Metadata: total=8.00MB, used=0.00
> 
> I've had btrfs filesystem balance running on a partition of my 120G
> Intel SSD for almost 7 hours.

> Should a balance take so long anyway?  It's been mostly CPU bound an on
> E4600  CPU, that's a bit dated but it's still dual-core 64bit and
> whatever the btrfs  utility has done to use 327 minutes of CPU time is
> probably wrong.
> 
> Any suggestions on other information I should provide?  I'm using
> 3.10.7 in  Debian package linux-image-3.10-2-amd64 version 3.10.7-1 and
> version 0.19+20130705-1 of the btrfs-tools in Debian/Unstable.

My system's somewhat different, AMD fx6100 six-core, dual Corsair Neutron 
SSDs mostly in btrfs raid1 mode, and I chose to partition my SSDs and run 
multiple independent filesystems rather than putting all my data eggs in 
one still under development btrfs filesystem basket, but it's fairly fast 
SSD and the filesystem times can be scaled for the data involved, so this 
should be relevant:

A timed balance on my /home takes roughly two minutes, with the balance 
saying it relocated 16 out of 16 chunks.  According to btrfs fi df /home:

Data, RAID1: total=13.00GB, used=11.52GB
System, RAID1: total=32.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=521.69MB

... and btrfs fi sh

Total devices 2 FS bytes used 12.03GB
devid    2 size 20.00GB used 14.03GB path /dev/sda6
devid    1 size 20.00GB used 14.04GB path /dev/sdb6

So it's a 20-gig filesystem with two copies, 13 gig data of which 11.5 is 
used, 1 gig metadata just over half used, about 14 gig total usage.

14 gig relocated in ~2 minutes is ~7 gigs a minute.

You have about 104 gig of data and metadata combined, so to scale it 
should take roughly 15 minutes.  If your SSD is slow or you're only on 
SATA2 instead of the SATA3 I'm on, that might double to half an hour, but 
there's really no reason it should take over an hour on what I know of 
your hardware.

Meanwhile, 3.11 was JUST released, and you're running 3.10.7, so you're 
basically running a current kernel.  Similarly, your btrfs tools are a 
snapshot from early July so they're slightly behind but not bad.

So you're running into a bug.

I'm just a btrfs user but I follow the list, and I'd guess you might be 
running into the chunk looping bug I saw a patch go by on the list for.  
You might try the /just/ released 3.11 and see if it helps.

Meanwhile, I'm running a git kernel, 3.11-rc6-00072-g1f8b766 (3.11-series 
but about two weeks old I guess), and in checking the balance time I 
posted above, my first balance /home segfaulted, and shortly after that, 
various apps quit responding.  I rebooted using magic-srq to sync and 
mount-readonly what was possible before the reboot (and / is mounted read-
only normally, so it wasn't ever in serious danger), and the balance 
completed after the reboot.  I then did another balance without issue -- 
it completed successfully, and I did a scrub to be sure -- no errors to 
fix.  So whatever triggered the balance segfault the first time around 
appears to have disappeared along with the reboot.

I guess I don't know which is worse, a looping balance that eats CPU but 
never completes, or a segfaulting balance that triggers unresponsive apps 
and forces a semi-graceful reboot.

But either way, seven hours for about a hundred gig on what should be a 
reasonably fast SSD, yes, there's definitely something wrong.  I'd reboot 
and see if the balance completes then and/or if you can run a balance in 
reasonable time after the reboot.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

