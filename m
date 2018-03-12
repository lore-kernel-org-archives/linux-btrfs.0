Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37276 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbeCLGVr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 02:21:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1evGo6-0004Gr-8A
        for linux-btrfs@vger.kernel.org; Mon, 12 Mar 2018 07:19:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid1 volume stuck as read-only: How to dump, recreate and
 restore its content?
Date: Mon, 12 Mar 2018 06:19:31 +0000 (UTC)
Message-ID: <pan$16a8$693752e8$556456d2$4e57d94b@cox.net>
References: <CAEm4ggntj1ccp6PXvECDVrj0_RXrzn6fX7mu+CWtHNwCAoXbvg@mail.gmail.com>
        <20180311174713.53tqlmjn6t3d4gwh@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Borowski posted on Sun, 11 Mar 2018 18:47:13 +0100 as excerpted:

> On Sun, Mar 11, 2018 at 11:28:08PM +0700, Andreas Hild wrote:
>> Following a physical disk failure of a RAID1 array, I tried to mount
>> the remaining volume of a root partition with "-o degraded". For some
>> reason it ended up as read-only as described here:
>> https://btrfs.wiki.kernel.org/index.php/
Gotchas#raid1_volumes_only_mountable_once_RW_if_degraded
>> 
>> 
>> How to precisely do this: dump, recreate and restore its contents?
>> Could someone please provided more details how to recover this volume
>> safely?
> 
>> Linux debian 4.9.0-4-amd64 #1 SMP Debian 4.9.65-3 (2017-12-03) x86_64
>> GNU/Linux
> 
>> [ 1313.279140] BTRFS warning (device sdb2): missing devices (1)
>> exceeds the limit (0), writeable mount is not allowed
> 
> I'd recommend instead going with kernel 4.14 or newer (available in
> stretch-backports), which handles this case well without the need to
> restore.  If there's no actual data loss (there shouldn't be, it's RAID1
> with only a single device missing), you can mount degraded normally,
> then balance the data onto the new disk.
> 
> Recovery with 4.9 is unpleasant.

Second the 4.14+ kernel with the per-chunk-check (vs. older per-device) 
patches recommendation, both in general and if the priority is getting 
the existing filesystem back into normal writable condition.

And since we're talking about upgrades, I'll mention that 4.7 btrfs-tools 
version as well.  For normal operations, mounting, writing, balance, 
scrub, etc, it's the kernel version that does the work (the userspace 
scrub and balance commands just call the appropriate kernel 
functionality), so it's the kernel version that's important to keep 
current as having the latest bugfixes.  However, when things go wrong and 
you're running commands such as btrfs check, restore, or rescue, as well 
as when you create a new btrfs with mkfs.btrfs, it's the userspace code 
that does the work and thus the userspace code you want to have the 
latest bugfixes in ordered to have the greatest chance at a fix.

And with userspace versions synced with kernelspace and coming out 
shortly after the kernel release of the same major.minor, five such 
kernel releases a year, and 4.15 being the current kernel release, 4.7 
userspace is 8 kernel series releases and over a year and a half 
outdated.  Put differently, 4.7 is missing a year and a half worth of 
bugfixes that you won't have when you run it to try to check or recover 
that btrfs that won't mount!  Do you *really* want to risk your data on 
bugs that were after all discovered and fixed over a year ago?


Meanwhile, if the priority is simply ensuring access to the data, and 
you'd prefer to stick with the 4.9-LTS series kernel if possible, then 
the existing read-only filesystem should let you do just that, reliably 
read the files in ordered to copy them elsewhere, say to a new btrfs, tho 
it can just as easily be non-btrfs if desired, since you're just copying 
the files as normal.  It's a read-only filesystem, but that shouldn't 
prevent you copying the files off, just prevent writing.

No need to worry about btrfs restore at all, which after all is designed 
for disaster recovery and thus (among other things) doesn't verify 
checksums on the data it recovers, in ordered to give the best chance at 
recovery when things are already badly wrong, so just copying the data 
off the read-only filesystem is a better option when it's available, as 
it is here.


Alternatively, since the value of data is defined not by empty claims but 
by the backups you consider it worth having of that data (and raid is not 
a backup), you either have a backup to copy from if necessary, or by lack 
of said backup, you defined the value of the data as too trivial to be 
worth bothering with a backup, in which case it's trivial enough it may 
not be worth bothering copying it off, either -- just blow it away with a 
fresh mkfs and start over.

And should you be reconsidering your backup-action (or lack thereof) 
definition of the value of the data... consider yourself luck fate didn't 
take you up on that definition... this time... and take the opportunity 
presented to make that backup while you have the chance, because fate may 
actually take you up on that value definition, next time. =:^)

(FWIW, about a year ago I upgraded even my backups to ssd, because I 
wasn't comfortable with amount of unprotected data I had in the delta 
between current/working and last backup, because backups were enough of a 
hassle I kept putting them off.  By buying ssds, I deliberately chose to 
spend money to bring down the hassle cost of the backups, and thus my 
"trivial value" threshold definition, and backups are fast enough now 
that as I predicted, I make them far more often.  So I'm walking my own 
talk, and am able to sleep much more comfortably now as I'm not worrying 
about that backup I put off and the chance fate might take me up on my 
formerly too-high-for-comfort "trivial" threshold definition.=:^)

(And as it happens, I'm actually running from a system/root filesystem 
backup ATM, as an upgrade didn't go well and x wouldn't start, so I 
reverted.  But my root/system filesystem is under 10 gigs, on SSD for the 
backup as well as the working copy, so a full backup copy of root takes 
only a few minutes and I made one before upgrading a few packages I had 
some doubts about due to previous upgrade issues with them, so the delta 
between working and that backup was literally the five package upgrades I 
was it turned out rightly worried about.  So that investment in ssds for 
backup has paid off.  While in this particular case simply taking a 
snapshot and recovering to it when the upgrade went bad would have worked 
just as well, having the independent filesystem backup on a different set 
of physical devices means I don't have to worry about loss of the 
filesystem or physical devices containing it, either! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

