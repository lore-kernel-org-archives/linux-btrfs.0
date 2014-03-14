Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55905 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbaCNGmx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 02:42:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOLpT-0004vU-LZ
	for linux-btrfs@vger.kernel.org; Fri, 14 Mar 2014 07:42:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 07:42:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 07:42:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Incremental backup for a raid1
Date: Fri, 14 Mar 2014 06:42:27 +0000 (UTC)
Message-ID: <pan$60e7c$45de97e1$2fb9daeb$288befdc@cox.net>
References: <1564384.fRV1HUkfCq@fuchsia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Schuerig posted on Thu, 13 Mar 2014 20:12:44 +0100 as excerpted:

> My backup use case is different from the what has been recently
> discussed in another thread. I'm trying to guard against hardware
> failure and other causes of destruction.
> 
> I have a btrfs raid1 filesystem spread over two disks. I want to backup
> this filesystem regularly and efficiently to an external disk (same
> model as the ones in the raid) in such a way that
> 
> * when one disk in the raid fails, I can substitute the backup and
> rebalancing from the surviving disk to the substitute only applies the
> missing changes.
> 
> * when the entire raid fails, I can re-build a new one from the backup.
> 
> The filesystem is mounted at its root and has several nested subvolumes
> and snapshots (in a .snapshots subdir on each subvol).
> 
> Is it possible to do what I'm looking for?

AFAICS, as mentioned down the other subthread, the closest thing to this 
would be N-way mirroring, a coming feature on the roadmap for 
introduction after raid5/6 mode[1] gets completed.  The current raid1 
mode is 2-way-mirroring only, regardless of the number of devices.

N-way-mirroring is actually my most hotly anticipated feature for a 
different reason[2], but for you it would work like this:

1) Setup the 3-way (or 4-way if preferred) mirroring and balance to 
ensured copies of all data on all devices.

2) Optionally scrub to ensure the integrity of all copies.

3) Disconnect the backup device(s).  (Don't btrfs device delete, this 
would remove the copy.  Just disconnect.)  

4) Store the backups.

5) Periodically get them out and reconnect.

6) Rebalance to update.  (Since the devices remain members of the mirror, 
simply outdated, the balance should only update, not rewrite the entire 
thing.)

7) Optionally scrub to verify.

8) Repeat steps 3-7 as necessary.

If you went 4-way so two backups and alternated the one you plugged in, 
it'd also protect against mishap that might take out all devices during 
steps 5-7 when the backup is connected as well, since you'd still have 
that other backup available.

Unfortunately, completing raid5/6 support is still an ongoing project, 
and as a result, fully functional and /reasonably/ tested N-way-mirroring 
remains the same 6-months-minimum away that it has been for over a year 
now.  But I sure am anticipating that day!

---
[1] Currently, the raid5/6 support is incomplete, the parity is 
calculated and writes are done, but some restore scenarios aren't yet 
properly supported and raid5/6-mode scrub isn't complete either, so the 
current code is considered testing-only, not for deployment where the 
raid5/6 feature would actually be relied on.  That has remained the 
raid5/6 status for several kernels now, as the focus has been on bugfixing 
other areas including snapshot-aware defrag which is currently 
deactivated due to horrible scaling issues (current defrag COWS the 
operational mount only, duplicating previously shared blocks), send/
receive.

[2] In addition to loss of N-1 device-protection, I really love btrfs' 
data integrity features and the ability to recover from other copies if 
the one is found to be corrupted, which is why I'm running raid1 mode 
here.  But currently, there's only the two copies and if both get 
corrupted...  My sweet spot would be three copies, allowing corruption of 
two and recovery from the third, which is why I personally am so hotly 
anticipating N-way-mirroring, but unfortunately, it's looking a bit like 
the proverbial carrot on the stick in front of the donkey, these days.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

