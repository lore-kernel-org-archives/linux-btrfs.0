Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33981 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab3LGLX5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Dec 2013 06:23:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VpFzG-0001Gy-CY
	for linux-btrfs@vger.kernel.org; Sat, 07 Dec 2013 12:23:54 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 12:23:54 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 12:23:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can't remove empty directory after kernel panic, no errors in
 dmesg
Date: Sat, 7 Dec 2013 11:23:34 +0000 (UTC)
Message-ID: <pan$4b17c$7a4e1e36$4569b4d4$d3dc2dcf@cox.net>
References: <CADdntNuHYRAK_kcDJf1bnJeuTmc=CRx7TeyJPv4hsW9NPyd6mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niklas Schnelle posted on Sat, 07 Dec 2013 11:36:45 +0100 as excerpted:

> Hi List,
> 
> so first the basics. I'm running Arch Linux with 3.13-rc2, btrfs-progs
> 0.20rc1.3-2 from the repo and I'm using a SSD.
> So I was having kernel panics with my USB 3.0 Gigabit card and was
> trying to get a panic output. These panics are intermittent and most
> often happen while using Chromium. Anyway so my system paniced while I
> was in Chromium.
> After the reboot Chromium reported that its preferences are corrupted,
> thankfully I've both backups and an older snapshot. So I wanted to copy
> over my ~/.config/chromium from the snapshot.
> However I couldn't delete that directory, rm -rf reported it to not be
> empty. Renaming worked via "mv chromium bad" but now I can't delete the
> bad directory, this is the output:
> http://pastebin.com/FWTPGGH1
> 
> any idea how to get that directory deleted or how to obtain more
> information?

That sort of behavior is a(n almost[1]) sure sign of filesystem 
corruption.  On a normal filesystem, you'd fsck it and hope that fixed 
the errors, and you can try btrfsck too, first without the --repair 
option, just to see what it gives you, then if you want to risk it 
(btrfsck still not being fully tested yet, see the manpage), with the 
option.

But before you try that repair option, you can try a few other things 
first.  Here's a link to a post with a list of things to try, in the 
order of least to greatest risk.  (It that case IIRC the filesystem 
wouldn't mount at all, so the problem was worse.  But the point is, 
there's other things you can try first -- btrfsck --repair isn't always 
the first recommended option.)

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

Meanwhile, FWIW I have my btrfs filesystems (also on ssd, actually dual 
SSD in btrfs raid1 mode) split up into independent filesystems on 
separate partitions, so all my data eggs aren't in the same basket, and 
recovery from one going bad isn't so difficult.  As a result, since most 
of it's still readable, I'd probably first do a scrub (raid1 mode both 
data and metadata so hopefully one copy is good), then if that didn't 
work I'd ensure my backups were current, then do a balance and/or btrfsck 
--repair, hoping that would fix it.  If that didn't fix it, I'd probably 
simply blow it away and restore from backup.  Since I have things splitup 
into multiple independent filesystems, the biggest is only double-digit 
gigs, and being on SSD, doing a mkfs.btrfs on the partition automatically 
does a trim/discard on the entire partition, zeroing it out, and copying 
over the tens of gigs from the backup will only take a few minutes.  It's 
not like the multiple TB btrfs filesystems on spinning rust I see people 
reporting as taking a good fraction of a day or longer.

---
[1] Almost: Barring something like selinux or the like, where root is 
/not/ necessarily all powerful!  I also once had problems getting 
something to execute, even tho execute permissions were set... until I 
remembered that partition was mounted noexec!  Of course the equivalent 
here would be a read-only mount, but that can't be it or you'd not have 
been able to rename/move the directory, either.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

