Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36850 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbbJTPAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 11:00:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZoYOP-0007oW-H7
	for linux-btrfs@vger.kernel.org; Tue, 20 Oct 2015 17:00:01 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 17:00:01 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 17:00:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
Date: Tue, 20 Oct 2015 14:59:48 +0000 (UTC)
Message-ID: <pan$cd91$f507a03b$fece202f$598f398a@cox.net>
References: <CANznX5GOKcDMFTV2E-yDdvHWWf7Sn4o0PeX3vk0CZd2xmZo9mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Janos Toth F. posted on Mon, 19 Oct 2015 10:39:06 +0200 as excerpted:

> I was in the middle of replacing the drives of my NAS one-by-one (I
> wished to move to bigger and faster storage at the end), so I used one
> more SATA drive + SATA cable than usual. Unfortunately, the extra cable
> turned out to be faulty and it looks like it caused some heavy damage to
> the file system.
> 
> There was no "devive replace" running at the moment or the disaster. The
> first round already got finished hours ago and I planned to start the
> next one before going to sleep. So, it was a full RAID-5 setup in normal
> state. But one of the active, mounted devices was the first replacment
> HDD and it was hanging on the spare SATA cable.
> 
> I tried to save some file to my mounted samba share and I realized the
> file system because read-only. I rebooted the machine and saw that my
> /data can't be mounted.
> According to SmartmonTools, one of the drives was suffering from SATA
> communication errors.
> 
> I tried some tirivial recovery methods and I tried to search the mailing
> list archives but I didn't really find a solution. I wonder if somebody
> can help with this.
> 
> Should I run "btrfs rescue chunk-recover /dev/sda"?
> 
> Here are some raw details:
> 
> # uname -a
> Linux F17a_NAS 4.2.3-gentoo #2 SMP Sun Oct 18 17:56:45 CEST 2015
> x86_64 AMD E-350 Processor AuthenticAMD GNU/Linux
> 
> # btrfs --version
> btrfs-progs v4.2.2

OK, nice and current kernel and userspace, vital for btrfs raid56 mode 
especially, as it's so new...

> # mount /dev/sda /data -o ro,recovery
> mount: wrong fs type, bad option, bad superblock on /dev/sda, ...

Did you try mount -o degraded ?  The recovery option is for a different 
problem and you probably simply need degraded at this point.  But there's 
no indication that you tried degraded.

If one of the devices is/was on a faulting cable, then it's likely not 
being detected properly, and btrfs is simply failing to mount it business-
as-usual because it's degraded, and btrfs wants to ensure that you know 
that before it lets you mount, to maximize the chances of fixing the 
problem before something else goes wrong as well, where the two problems 
combined really /could/ screw up the filesystem beyond simple repair.

Do note that due to a bug with the current kernel, you may get just one 
writable mount to fix the problem.  Attempting a second degraded writable 
mount will often fail due to the bug, and you can only do degraded,ro 
after that, which will let you copy off the data to elsewhere but won't 
let you repair the filesystem, as a writable mount is required for that.  
So if you don't have current backups and you want to maximize your chance 
of saving the data, mounting degraded,ro *first* and (assuming it mounts) 
taking that opportunity to backup, before attempting to mount degraded,rw 
in ordered to replace the screwed up device, is recommended.

Once you have a current backup of anything on it that you consider 
important[1], then do a btrfs filesystem show and see if it says some 
devices missing (as it probably will if you had to use the degraded 
option), after which you can mount degraded,rw and replace/remove the 
missing device.

Meanwhile, should you end up having mounted degraded,rw, and not gotten 
the missing devices properly deleted/replaced before a second degraded 
mount, which probably won't let you mount rw due to that bug I mentioned, 
there's patches available, I believe already applied to the latest kernel 
4.3-rc, that should let you mount degraded,rw more than once, if the data 
and metadata is actually all still available.

The bug is that btrfs currently looks only at the number of devices and 
the chunk-types when deciding whether a filesystem can be mounted 
degraded,rw, while if new data is written in degraded,rw mode, it may 
have to fallback new writes to single chunk write mode.  That's fine for 
the first writable mount, but on the second, it sees those single chunks 
and devices missing, and thinks that single mode with devices missing 
means data is missing too, even tho as long as no further devices went 
missing, it could have only been written to the present devices, so no 
data should actually be missing at all.  But current btrfs doesn't know 
that as it only looks at the number of devices vs what's supposed to be 
there, along with the chunk type, and if there's any single type chunks 
with devices missing, it gives up and won't allow writable mount.

What the patches make btrfs do instead is look at the individual chunks.  
If all the chunks are actually available (as they should be in this 
second degraded writable-mount scenario), then it can still mount 
degraded,rw despite missing devices, thus allowing you to actually remove/
replace the missing device, since it needs writable mount in ordered to 
be able to do that remove/replace.

---
[1] If you're a regular reader of the list, you'll know that I regularly 
point to the sysadmin's rule of backups: If it's not backed up, by 
definition you don't care about the data as much as the time/hassle/
resources saved by not backing up, despite any protests to the contrary 
after loss, because your actions spoke louder than your words and your 
actions said you valued the time/resources saved in not making the backup 
more than the data.  By that definition, you either have the backup, or 
you don't really care about the data anyway and have saved what you value 
most, the time/resources that would have otherwise gone into the backup.  
That said, valuing the time/resources saved more than the calculated 
potential risk of losing the data is one thing, actually having it at 
risk right now is something entirely different since it changes the risk 
factor in the equation, so despite the data not being worth the backup 
cost when the risk was theoretical, it may still be worth the cost once 
that risk factor jumps dramatically, making it worthwhile to take the 
opportunity to do the backup if you get the chance once you know the data 
is at increased risk of being lost entirely, even if it wasn't 
worthwhile, while that risk was much lower.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

