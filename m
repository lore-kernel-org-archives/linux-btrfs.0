Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58215 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaHSF03 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 01:26:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XJbwB-0002bG-Ps
	for linux-btrfs@vger.kernel.org; Tue, 19 Aug 2014 07:26:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 07:26:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 07:26:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Putting very big and small files in one subvolume?
Date: Tue, 19 Aug 2014 05:26:15 +0000 (UTC)
Message-ID: <pan$a781a$be78f232$594de0b3$8bff06fe@cox.net>
References: <CAH-HCWVDtPv9gYxpcA4drK=FDes_0z8QTxqOBcocWf9T_b4tyQ@mail.gmail.com>
	<pan$df1ba$a20420a2$2ac33113$90ec0a1@cox.net> <lstftk$tmt$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Mon, 18 Aug 2014 19:16:20 +0100 as excerpted:

>> OTOH, I tend to be rather more of an independent partition booster than
>> many.  The biggest reason for that is the too many eggs in one basket
>> problem.  Fully separate filesystems on separate partitions...
> 
> I do so similarly myself. A good scheme that I have found to work well
> for my cases is to have separate partitions for:
> 
> /boot
> /var
> /var/log
> /
> /usr
> /home
> /mnt/data...

Of course with "the new layout" ala systemd, etc, a separate /usr is 
claimed to be broken (but see below), as too many binaries and libs, plus 
a lot of config needed in early boot, are located there.  It used to be 
that distros went to some pain to ensure that all binaries needed in 
early boot were located in /bin and were either statically linked or had 
the necessary libs in /lib (instead of /usr/bin and /usr/lib 
respectively), but as systems have become more complicated, that has 
become more difficult, and the systemd folks made headlines saying it was 
no longer supported, tho I imagine that was to the great relief of the 
various distro folks who formerly had to deal with it.

Tho it can still be made to work with an initr* that ensures both / and 
/usr are mounted before doing the pivot_root or whatever and handing 
control over to the main system init (which on more and more distros is 
systemd).  And since most distros use an initr* anyway, as long as it's 
configured to mount /usr before switching to the main system init, it 
doesn't necessarily appear to be broken.

But that's why some distros are doing root-and-usr unification, 
effectively putting /everything/ in /usr/bin and /usr/lib, and taking 
advantage of /usr/share for distro-based config so /etc can be left for 
site-specific config.

FWIW, I've actually reversed that here:  /usr -> .  So anything installed 
in /usr/bin actually ends up installed in /bin. =:^)


Meanwhile, another lesson I learned, this one unfortunately the hard way 
unlike the always-keep-tmp-on-its-own-filesystem rule I mentioned above, 
is that either restoring from backup or simply falling back to that 
backup as /, is *MUCH* simpler if everything the package manager installs 
to is on the same filesystem.

I learned that when I lost air conditioning, here in Phoenix in the 
summer, when I had gone away with the system left on.  Outside temps in 
the shade can reach 50C (122F) here, and when I came back I expect the 
room was 60C+ (140F), with the computer easily reaching 70C+.  The CPU 
survived and was fine after I cooled things back down, but the disk had 
head-crashed.

Unfortunately I had separate / /usr and /var, and I ended up restoring 
from backups from different dates for each.  The package manager's 
installed-package database was in /var/db, so what it said was installed 
didn't match what actually got restored to either / or /usr.

Fortunately the system worked well enough that I could boot back up and 
reinstall from (nearly) current binary builds (gentoo, so without the 
binary builds I'd have ahd to rebuild from sources), but because the 
installed-package database was out-of-sync with what was actually in-
place, uninstalling the old versions as I reinstalled missed quite a few 
odd files here and there.

I was dealing with THAT mistake for QUITE some time as I was still 
cleaning up stray files nearly two years later.

So these days (with some minor state tracking exceptions) my policy is 
that anything the package manager touches is on root, along with the 
database tracking it all, so the installed-package database is always 
automatically in sync with whatever backup I end up using, since all 
installed files are on the same partition as the database and that 
partition is backed up as a whole.

As a result, that partition includes /usr (which made it extremely easy 
to make /usr a symlink /usr -> . as mentioned above, when I decided to do 
so) and /var, tho as I mentioned /var/log is separate.  The minor state-
tracking exceptions are the packages that need actively writable state, 
mostly kept in /var/lib by default, since my rootfs is read-only by 
default.  Where necessary I have these symlinked to corresponding subdirs 
of /home/var, which as part of /home is writable by default.  But they're 
state only and should it be necessary I could start with clean state.  
But / is still only 8 GB in size, more or less half used.  That's small 
enough I can keep multiple identically sized backup root partitions on 
various devices.

> And all the better and easy to do using GPT partition tables.

Absolutely and enthusiastically agreed!

I use GPT on anything I partition these days, misc. USB based external 
and thumb drives included.  Among other reasons (robustness and lack of 
primary/secondary/logical partition hassles) GPT partition names/labels 
form an integral part of my device/partition ID scheme, such that I can 
immediately identify on-sight the functionality (home, root, log, etc), 
target machine (netbook, workstation, portable, etc), containing device 
(938 GiB Seagate external drive #3, etc), working or backup generation, 
date I setup the partition, etc.

That dramatically helps keeping things straight when there's several 
generations of backup for various partitions on various machines, 
floating around on various devices both internal and external. =:^)

> Special NOTE: Myself, I consider btrfs *quotas* to be still very
> experimental at the moment and not to be used with valued data!

Definitely so.  There's a set of patches currently floating around that 
should dramatically improve quota stability and reliability, but they've 
not hit mainline yet (and look to be delayed until 3.18 now due to a mixup 
during the 3.17 merge window), and the existing btrfs quota code simply 
has too many known problems to be recommended for anything besides pure 
experimental usage.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

