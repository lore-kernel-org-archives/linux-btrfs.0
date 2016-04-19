Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34214 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbcDSHfN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 03:35:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1asQBe-0003zX-Iw
	for linux-btrfs@vger.kernel.org; Tue, 19 Apr 2016 09:35:06 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 09:35:06 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 09:35:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID5 Unable to remove Failing HD
Date: Tue, 19 Apr 2016 07:35:01 +0000 (UTC)
Message-ID: <pan$d96e4$2cb56bbb$1d5f6612$721cfc21@cox.net>
References: <CAKUFzr8gm-yN01CY=H_j6jdEXJL5b0A_vS6gJ5iH1YN1+ZJAvg@mail.gmail.com>
	<56BAFC15.6080106@oracle.com> <5714A1F7.3050509@bouton.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lionel Bouton posted on Mon, 18 Apr 2016 10:59:35 +0200 as excerpted:

> Hi,
> 
> Le 10/02/2016 10:00, Anand Jain a écrit :
>>
>> Thanks for the report. Fixes are in the following patch sets
>>
>>  concern1:
>>  Btrfs to fail/offline a device for write/flush error:
>>    [PATCH 00/15] btrfs: Hot spare and Auto replace
>>
>>  concern2:
>>  User should be able to delete a device when device has failed:
>>    [PATCH 0/7] Introduce device delete by devid
>>
>>  If you were able to tryout these patches, pls lets know.
> 
> Just found out this thread after digging for a problem similar to mine.
> 
> I just got the same error when trying to delete a failed hard drive on a
> RAID1 filesystem with a total of 4 devices.
> 
> # btrfs device delete 3 /mnt/store/
> ERROR: device delete by id failed: Inappropriate ioctl for device
> 
> Were the patch sets above for btrfs-progs or for the kernel ?

Looks like you're primarily interested in the concern2 patches, device 
delete by devid.

A quick search of the list back-history reveals that an updated patch 
set, 00/15 now (look for [PATCH 00/15] Device delete by id ), was posted 
by dserba on the 15th of February.  It was the kernel patches and was 
slated for the kernel 4.6 dev cycle.  However, the patch set was pulled 
at that time due to test failures, tho they were suspected to actually be 
from something else.

I haven't updated to kernel 4.6 git yet (tho I'm on 4.5 and generally do 
run git post rc4 or so, which was just released), so I'll probably update 
shortly) so can't check whether it ultimately made it in or not, but if 
it's not in 4.6 it certainly won't be in anything earlier as stable 
patches must be in devel mainline first.

So I'd say check 4.6 devel, and if it's not there as appears to be 
likely, you'll have to grab the patches off the list and apply them 
yourself.

> Currently the kernel is 4.1.15-r1 from Gentoo. I used btrfs-progs-4.3.1
> (the Gentoo stable version) but it didn't support delete by devid so I
> upgraded to btrfs-progs-4.5.1 which supports it but got the same
> "inappropriate ioctl for device" error when I used the devid.

FWIW, I'm a gentooer also, but I'm on ~amd64 not stable, and as I said I 
run current stable and later devel kernels.  I also often update the 
(often unfortunately lagging, even on ~arch) btrfs-progs ebuild to the 
latest as announced here and normally run that.

And FWIW I run btrfs raid1 mode also, but on only two ssds, which 
decomplicates things since btrfs raid1 is only 2-way-mirroring anyway.  I 
also partition up the ssds and run multiple independent btrfs, the 
largest only 24 GiB usable size (24 GiB partitions on two devices, 
raid1), so my data eggs aren't all in one btrfs basket and it's easier to 
recover from just one btrfs failing.  As an example, my / is only 8 GiB 
and contains everything installed by portage but a few bits of /var which 
need to be writable at runtime, because I keep my / mounted read-only by 
default, only mounting it writable to update.  An 8 GiB root is easy to 
duplicate elsewhere for backup, and indeed, my first backup is another 
set of 8 GiB partitions in btrfs raid1, on the same ssds, with the second 
backup being an 8 GiB reiserfs partition on spinning rust, with all three 
bootable from grub (separately installed to each of the three physical 
devices, each of which has its own /boot, with the one that's booted 
selected from grub), should it be needed.

> I don't have any drive available right now for replacing this one (so no
> btrfs dev replace possible right now). The filesystem's data could fit
> on only 2 of the 4 drives (in fact I just added 2 old drives that were
> previously used with md and rebalanced, which is most probably what
> triggered one of the new drives failure). So I can't use replace and
> would prefer not to lose redundancy while waiting for new drives to get
> there.

I did have to use btrfs replace for one of the ssds, but as it happens I 
did have a spare, as the old netbook I intended to put it in died before 
I got it installed.  And the failing ssd wasn't entirely failed, just 
needing more and more frequent scrubs as sectors failed, and the replace 
(replaces as I have multiple btrfs on the pair of ssds) went quite 
well... and fast on the ssds. =:^) 

> So the obvious thing to do in this circumstance is to delete the drive,
> forcing the filesystem to create the missing replicas in the process and
> only reboot if needed (no hotplug). Unfortunately I'm not sure of the
> conditions where this is possible (which kernel version supports this if
> any ?). If there is a minimum kernel version where device delete works,
> can https://btrfs.wiki.kernel.org/index.php/Gotchas be updated ? I don't
> have a wiki account yet but I'm willing to do it myself if I can get
> reliable information.

As I said, it'd be 4.6 if it's even there.  Otherwise you'll have to 
apply the patches yourself.

> I can reboot this system and I expect the current drive to appear
> missing (it doesn't even respond to smartctl) and I suppose "device
> delete missing" will work then. But should I/must I upgrade the kernel
> to avoid this problem in the future and if yes which version(s)
> support(s) failed device delete?

It's good to see (I think it was in your followup) that you have the 
critical stuff backed up already, and that what's not backed up you're 
not too worried about losing.  Despite btrfs not being entirely stable as 
yet, it's surprising the number of cases we see where that's not the case.

So kudos for being a wise sysadmin, and appreciating that data that's not 
backed up is data that by your actions you're defining as not worth the 
trouble of the backup.  Far too many appreciate that only after reality 
takes them up on that definition and they actually (at least potentially, 
btrfs restore can sometimes get them out of the hole they dug themselves 
into) lose what wasn't backed up. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

