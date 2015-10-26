Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36458 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbbJZIb5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 04:31:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZqdC2-0003vn-TX
	for linux-btrfs@vger.kernel.org; Mon, 26 Oct 2015 09:31:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 09:31:50 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 09:31:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: corrupted RAID1: unsuccessful recovery / help needed
Date: Mon, 26 Oct 2015 08:31:42 +0000 (UTC)
Message-ID: <pan$deb9e$70dd599$c247d7fb$410817e7@cox.net>
References: <562DC606.3070602@lukas-pirl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lukas Pirl posted on Mon, 26 Oct 2015 19:19:50 +1300 as excerpted:

> TL;DR: RAID1 does not recover, I guess the interesting part in the stack
> trace is: [elided, I'm not a dev so it's little help to me]
> 
> I'd appreciate some help for repairing a corrupted RAID1.
> 
> Setup:
> * Linux 4.2.0-12, Btrfs v3.17, 
> `btrfs fi show`:
>    uuid: 5be372f5-5492-4f4b-b641-c14f4ad8ae23
>    Total devices 6 FS bytes used 2.87TiB
>    devid 1 size 931.51GiB used 636.00GiB path /dev/mapper/[...]
>    devid 2 size 931.51GiB used 634.03GiB path /dev/mapper/
>    devid 3 size   1.82TiB used   1.53TiB path /dev/mapper/
>    devid 4 size   1.82TiB used   1.53TiB path /dev/mapper/
>    devid 6 size   1.82TiB used   1.05TiB path /dev/mapper/
>    *** Some devices missing
> * disks are dm-crypted

FWIW... Older btrfs userspace such as your v3.17 is "OK" for normal 
runtime use, assuming you don't need any newer features, as in normal 
runtime, it's the kernel code doing the real work and userspace for the 
most part simply makes the appropriate kernel calls to do that work.

But, once you get into a recovery situation like the one you're in now, 
current userspace becomes much more important, as the various things 
you'll do to attempt recovery rely far more on userspace code directly 
accessing the filesystem, and it's only the newest userspace code that 
has the latest fixes.

So for a recovery situation, the newest userspace release (4.2.2 at 
present) as well as a recent kernel is recommended, and depending on the 
problem, you may at times need to run integration or apply patches on top 
of that.

> What happened:
> * devid 5 started to die (slowly)
> * added a new disk (devid 6) and tried `btrfs device delete`
> * failed with kernel crashes (guess:) due to heavy IO errors
> * removed devid 5 from /dev (deactivated in dm-crypt)
> * tried `btrfs balance`
>    * interrupted multiple times due to kernel crashes
>      (probably due to semi-corrupted file system?)
> * file system did not mount anymore after a required hard-reset
> * no successful recovery so far:
>    if not read-only, kernel IO blocks eventually (hard-reset required)
> * tried:
>    * `-o degraded`
>      -> IO freeze, kernel log: http://pastebin.com/Rzrp7XeL
>    * `-o degraded,recovery`
>      -> IO freeze, kernel log: http://pastebin.com/VemHfnuS
>    * `-o degraded,recovery,ro`
>      -> file system accessible, system stable
> * going rw again does not fix the problem
> 
> I did not btrfs-zero-log so far because my oops did not look very
> similar to the one in the Wiki and I did not want to risk to make
> recovery harder.

General note about btrfs and btrfs raid.  Given that btrfs itself remains 
a "stabilizing, but not yet fully mature and stable filesystem", while 
btrfs raid will often let you recover from a bad device, sometimes that 
recovery is in the form of letting you mount ro, so you can access the 
data and copy it elsewhere, before blowing away the filesystem and 
starting over.

Back to the problem at hand.  Current btrfs has a known limitation when 
operating in degraded mode.  That being, a btrfs raid may be write-
mountable only once, degraded, after which it can only be read-only 
mounted.  This is because under certain circumstances in degraded mode, 
btrfs will fall back from its normal raid mode to single mode chunk 
allocation for new writes, and once there's single-mode chunks on the 
filesystem, btrfs mount isn't currently smart enough to check that all 
chunks are actually available on present devices, and simply jumps to the 
conclusion that there's single mode chunks on the missing device(s) as 
well, so refuses to mount writable after that in ordered to prevent 
further damage to the filesystem and preserve the ability to mount at 
least ro, to copy off what isn't damaged.

There's a patch in the pipeline for this problem, that checks individual 
chunks instead of leaping to conclusions based on the presence of single-
mode chunks on a degraded filesystem with missing devices.  If that's 
your only problem (which the backtraces might reveal but I as a non-dev 
btrfs user can't tell), the patches should let you mount writable.

But that patch isn't in kernel 4.2.  You'll need at least kernel 4.3-rc, 
and possibly btrfs integration, or to cherrypick the patches onto 4.2.


Meanwhile, in keeping with the admin's rule on backups, by definition, if 
you valued the data more than the time and resources necessary for a 
backup, by definition, you have a backup available, otherwise, by 
definition, you valued the data less than the time and resources 
necessary to back it up.

Therefore, no worries.  Regardless of the fate of the data, you saved 
what your actions declared of most valuable to you, either the data, or 
the hassle and resources cost of the backup you didn't do.  As such, if 
you don't have a backup (or if you do but it's outdated), the data at 
risk of loss is by definition of very limited value.

That said, it appears you don't even have to worry about loss of that 
very limited value data, since mounting degraded,recovery,ro gives you 
stable access to it, and you can use the opportunity provided to copy it 
elsewhere, at least to the extent that the data we already know is of 
limited value is even worth the hassle of doing that.

Which is exactly what I'd do.  Actually, I've had to resort to btrfs 
restore[1] a couple times when the filesystem wouldn't mount at all, so 
the fact that you can mount it degraded,recovery,ro, already puts you 
ahead of the game. =:^)

So yeah, first thing, since you have the opportunity, unless your backups 
are sufficiently current that it's not worth the trouble, copy off the 
data while you can.

Then, unless you wish to keep the filesystem around in case the devs want 
to use it to improve btrfs' recovery system, I'd just blow it away and 
start over, restoring the data from backup once you have a fresh 
filesystem to restore to.  That's the simplest and fastest way to a fully 
working system once again, and what I did here after using btrfs restore 
to recover the delta between current and my backups.

---
[1] Btrfs restore: Yes, I have backups, but I don't always keep them 
current.  To the extent that I risk losing the difference between current 
and backup, my actions obviously define that difference as not worth the 
hassle cost of more frequent backups vs. the risk.  But while my actions 
define that delta data as of relatively low value, it's not of /no/ 
value, and to the extent btrfs restore allows me to recover it, I 
appreciate that I can do so, avoiding the loss of the delta between my 
backup and what was current.  Of course, that lowers the risk of loss 
even further, letting me put off updating the backups even longer if I 
wanted, but I haven't actually done so.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

