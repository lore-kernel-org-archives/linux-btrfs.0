Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40213 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab3KJK3k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 05:29:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VfSGv-0001F1-Qu
	for linux-btrfs@vger.kernel.org; Sun, 10 Nov 2013 11:29:37 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 11:29:37 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 11:29:37 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.10.11 scrub OOM crash
Date: Sun, 10 Nov 2013 10:29:17 +0000 (UTC)
Message-ID: <pan$6aed8$65fef48b$2e6cd73c$d2a7aa4d@cox.net>
References: <201311101048.17277.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Sun, 10 Nov 2013 10:48:17 +1100 as excerpted:

> I've got an AMD64 system with 8G of RAM and 1G of swap.  It runs as a
> home file server with 2*3TB disks in a RAID-1 array and a 120G SSD for
> root and /home.  It also does some light desktop work (running KDE and
> web browsing with Chromium).
> 
> When a btrfs scrub is run from cron the system gives an OOM and then
> locks up after apparently killing some processes (after a reboot I see
> syslog entries about some processes being killed - even though it didn't
> appear to kill X or anything the system is hung).
> 
> The system really shouldn't have a OOM.  For light desktop use a total
> of 8G of RAM and 1G of swap should be more than enough.  Most of the
> time swap is hardly used and there are several gigs of RAM used for
> cache.
> 
> The kernel is Debian package 3.10.11-1.
> 
> This is the same system about which I reported the 3.11.5 kernel
> infinite loop bug.  I had this crash on scrub issue before I upgraded to
> 3.11.5.  I'm not certain that 3.11.5 fixed the crash on scrub problem,
> maybe 3.11.5 just crashed the system before it could be up for long
> enough.

Do you have disk quotas (btrfs qgroups) enabled?  There's a known current 
problem with some really nasty memory usage and/or leaks somewhere with 
them enabled, and even 16-gig systems are often not enough to avoid OOMs 
in certain cases with qgroups enabled.  As I'm sure you know given that 
previous experience, btrfs remains in general classified as experimental, 
but qgroups are known to make things MUCH worse currently and are 
definitely negative-recommended.  If at all possible, disable quotes on 
btrfs and reboot (without a reboot, some qgroups structures remain in 
memory and the problems remain with them).  If your use-case requires 
quotas, the STRONG recommendation is to use a different filesystem where 
they're considered stable, at this point.

If it's not quotas/qgroups, I'm not sure, and simply fall back to the 
general recommendations on the wiki, etc.


Meanwhile, the threads getting the OOMs are going to be btrfs-worker 
threads.  Killing them leaves open I/O and the locks for that I/O won't 
get cleaned up, thus effectively stalling I/O for anything on that btrfs 
volume (AFAIK the entire volume, not just that subvolume), tho I'm not 
sure whether it'll affect all I/O (on other btrfs volumes and non-btrfs 
filesystems) or not.  Existing tasks will continue to operate as long as 
they don't do any I/O to the locked-up volumes, and from my experience 
with similar lockups under somewhat different circumstances (and with a 
btrfs rootfs but mounted read-only, so it's not directly affected), if 
something's already in cache you can read it, but you can't write 
anything out to the affected filesystem, and if you try to read anything 
in that's not already cached, the process trying to do that read will 
lockup as well.

Which generally means that altho the system often isn't entirely dead, 
it's running pretty crippled, and depending on where the actual lockup is 
(especially if it's on root, but /home tends to be bad too, and if 
they're on the same btrfs filesystem...), it can appear dead.

And while to the extent possible a controlled shut down and after that, 
magic-sysrequests, does appear to safely save data on non-affected 
volumes (either non-btrfs or entirely separate btrfs filesystems, again, 
subvolumes on the same filesystem are locked up too I believe), since 
writes to the affected filesystem are locked up, it won't properly 
unmount or remount-read-only, so for it you gotta take the hard shutdown 
and hope there's not too much damage.  (Tho of course with btrfs being 
experimental, if you're running it without tested backups to restore from 
if worse comes to worse, you're doing it wrong, which means that any 
damage there might be simply means restoring from that backup, at worst.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

