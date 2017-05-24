Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35358 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S936712AbdEXKRH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 06:17:07 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dDTLc-0001tj-Je
        for linux-btrfs@vger.kernel.org; Wed, 24 May 2017 12:16:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
Date: Wed, 24 May 2017 10:16:50 +0000 (UTC)
Message-ID: <pan$8532b$ae0e1e6d$c1cd3583$d6dbef31@cox.net>
References: <20170501170641.GG3516@merlins.org>
        <20170501180856.GH3516@merlins.org>
        <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
        <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
        <pan$e2463$2d3d82e9$144941f3$9eeef2a4@cox.net>
        <20170523165847.fbu45eq3w24tyh3c@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Tue, 23 May 2017 09:58:47 -0700 as excerpted:

> That's a valid point, and in my case, I can back it up/restore, it just
> takes a bit of time, but most of the time is manually babysitting all
> those subvolumes that I need to recreate by hand with btrfs send/restore
> relationships, which all get lost during backup/restore.
> This is the most painful part.
> What's too big? I've only ever used a filesystem that fits on on a raid
> of 4 data drives. That value has increased over time, but I don't have a
> a crazy array of 20+ drives as a single filesystem, or anything.
> Since drives have gotten bigger, but not that much faster, I use bcache
> to make things more acceptable in speed.

What's too big?  That depends on your tolerance for pain, but given the 
subvolumes manually recreated by hand with send/receive scenario, I'd 
probably try to break it down so while there's the same number of 
snapshots to restore, the number of subvolumes the snapshots are taken 
against are limited.

My own rule of thumb is if it's taking so long that it's a barrier to 
doing it, I really need to either break things down further, or upgrade 
to faster storage.  The latter is why I'm actually looking at upgrading 
my media and second backup set, on spinning rust, to ssd.  Because while 
I used to do backups spinning rust to spinning rust of that size all the 
time, ssds have spoiled me, and now I dread doing the spinning rust 
backups... or restores.   Tho in my case the spinning rust is only a half-
TB, so a pair of half-TB to 1 TB ssds for an upgrade is still cost 
effective.  It's not like I'm going multi-TB, which would still be cost 
prohibitive on SSD, particularly since I want raid1, so doubling the 
number of SSDs.

Meanwhile, what I'd do with that raid of four drives (and /did/ do with 
my 4-drive raid back a few storage generations ago, when 300 GB spinning-
rust disks were still quite big, and what I do with my paired SSDs with 
btrfs now) is partition them up and do raids of partitions on each drive.

One thing that's nice about that is that you can actually do a set of 
backups on a second set of partitions on the same physical devices, 
because the physical device redundancy of the raids covers loss of a 
device, and the separate partitions and raids (btrfs raid1 now) cover the 
fat-finger or simple loss of filesystem risk.  A second set of backups to 
separate devices can then be made just in case, and depending on the 
need, swapped out to off-premises or uploaded to the cloud or whatever, 
but you always have the primary backup at hand to boot to or mount if the 
working copy fails, by simply pointing to the backup partitions and 
filesystem instead of the normal working copy.  For root, I even have a 
grub menu item that switches to the backup copy, and for fstab, I have a 
set of stubs that are assembled via script into three copies of fstab 
that swap working and backup copies as necessary, with /etc/fstab itself 
being a symlink to the working copy one, that I simply switch to point to 
the one that loads the backup copies as working, on the backup.  Or I can 
mount the root filesystem for maintenance from the initramfs, and switch 
the fstab symlink from there, before exiting maintenance and booting the 
main system.

I learned this "split it up" method the hard way back before mdraid had 
write-intent bitmaps, and I had only two much larger raids, working and 
backup, where if one device dropped out and I brought it back in, I had 
to wait way too long for the huge working raid to resync.  When I split 
things up by function into multiple raids, most of the time only some of 
them were active and only one or two of the active ones would actually 
have been being written at the time so were out of sync, and syncing them 
was fast as they were much smaller than the larger full system raids I 
had been using previously.

>> *BUT*, and here's the "go further" part, keep in mind that
>> subvolume-read-
>> only is a property, gettable and settable by btrfs property.
>> 
>> So you should be able to unset the read-only property of a subvolume or
>> snapshot, move it, then if desired, set it again.
>> 
>> Of course I wouldn't expect send -p to work with such a snapshot, but
>> send -c /might/ still work, I'm not actually sure but I'd consider it
>> worth trying.  (I'd try -p as well, but expect it to fail...)
> 
> That's an interesting point, thanks for making it.
> In that case, I did have to destroy and recreate the filesystem since
> btrfs check --repair was unable to fix it, but knowing how to reparent
> read only subvolumes may be handy in the future, thanks.

Hopefully you won't end up testing it any time soon, but if you do, 
please confirm whether my suspicions that send -p won't work after 
toggling and reparenting, but send -c still will, are correct.

(For those who read this out of thread context where I believe I already 
stated it, my own use-case involves neither snapshots nor send-receive.  
But it'd be useful information to confirm, both for others, and in case I 
suddenly find myself with a different use-case for some reason or other.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

