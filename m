Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54779 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdE1F4v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 01:56:51 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dErBw-0002lY-TE
        for linux-btrfs@vger.kernel.org; Sun, 28 May 2017 07:56:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs mounts RO, kernel oops on RW
Date: Sun, 28 May 2017 05:56:34 +0000 (UTC)
Message-ID: <pan$3ce02$7e425613$62194897$37882c38@cox.net>
References: <CAHPjZW7Af2KzRr_HTaCNGqRAM0SsV8+gJWSRis6eCjGeXNBK7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bill Williamson posted on Sun, 28 May 2017 12:46:00 +1000 as excerpted:

> Version details:
> btrfs-progs v4.9.1
> Linux bigserver 4.10.0-22-generic #24-Ubuntu SMP Mon May 22
> 17:43:20 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> Array Details:
> root@bigserver:~# btrfs fi df /mnt/storage
> Data, RAID1: total=12.48TiB, used=12.25TiB
> System, RAID1: total=32.00MiB, used=2.11MiB
> Metadata, RAID1: total=14.00GiB, used=13.31GiB
> GlobalReserve, single: total=512.00MiB, used=0.00
> 
> 
> root@bigserver:~# btrfs fi show /mnt/storage Label: none  uuid:
> c792d033-b0a6-44a0-bd37-9825de7eeb8b
>         Total devices 10 FS bytes used 12.27TiB
>         devid    1 size 2.73TiB used 2.71TiB path /dev/sde
>         devid    2 size 3.64TiB used 3.62TiB path /dev/sdh
>         devid    5 size 1.82TiB used 1.80TiB path /dev/sdg
>         devid    6 size 1.82TiB used 1.80TiB path /dev/sdc
>         devid    8 size 1.36TiB used 1.35TiB path /dev/sdb
>         devid    9 size 3.64TiB used 3.62TiB path /dev/sdf
>         devid   12 size 1.82TiB used 1.80TiB path /dev/sdd
>         devid   13 size 4.55TiB used 4.53TiB path /dev/sdk
>         devid   14 size 3.64TiB used 3.62TiB path /dev/sdi
>         devid   15 size 3.64TiB used 134.00GiB path /dev/sdj

Only one device with free space of any size.  That can be an issue for 
raid1, which needs two devices with free space for it to be worth 
anything.  But you were working on that and it doesn't seem to be your 
current issue...


> Issue:
> I can mount my btrfs readonly (recovery option not necessary).
> Attempting to mount it readwrite results in a kernel null pointer
> exception.
> 
> Background:
> I have a home server with a bunch of disks running btrfs raid 1.  When
> it starts to fill up I add another disk and re-balance.
> I added a new 4TB disk and began the re-balance.  After a while I needed
> to shut down the server, and did so gracefully with a shutdown -h now. 
> Upon rebooting the array wouldn't mount, so I put "noauto"
> into fstab to allow a graceful bootup and diagnose from there.

So far, so good.

> At first I got the failed to read log tree error, so I ran
> btrfs-zero-log.  It walked back 3-4 transactions but now seems okay.
> 
> After that fix:
> - btrfs check shows no errors.
> - mounting the filesystem RO works great, I can read files.
> - mounting the filesystem RW results in a huge kernel exception and a
> hang, centering around can_overcommit and
> btrfs_async_reclaim_metadata_space

Try using the skip_balance mount option.  See the btrfs (5) manpage (you 
must specify the 5, or you'll get the section 8 general btrfs command 
manpage).

If that works, you can resume or cancel the balance once the filesystem 
is mounted writable.

But the filesystem is clearly not healthy, and that won't make it 
healthy, just eliminate the current heart-attack trigger.  I'd observe 
the sysadmin's rules of backups below before trying anything else, 
including the skip_balance mount option.


> My "you're screwed, it's dead" backup plan is to build another server
> and buy 2x8TB drives, and then copy the data I care about over, but I'd
> much rather save myself the trouble and $$$ and repair the array if
> possible.

The sysadmin's first rule of backups:  The value of your data is defined 
by the number and currency of your backups: No backups, you are defining 
your data as of only trivial value, worth less than the time/trouble/
resources necessary to make those backups.  (In)Actions speak louder than 
words, so the definition holds regardless of any after-the-fact protests 
to the contrary.

Put differently, if you don't /already/ have backups, then by definition, 
you /don't/ care about any data on those drives and need not bother 
copying it over as that would be as much of a hassle as making the backup 
in the first place and you've already demonstrated you don't value the 
data enough to do that.

Put yet differently, if the potential loss of that data has changed your 
mind about its value, better make that backup **NOW**, preferably before 
any further attempts to mount writable, with or without skip_balance, 
while you have the chance and before further inaction tempts fate by 
continuing to define the data as throw-away value.  Next time you might 
not get that chance!

(The second rule of backups is that a would-be backup isn't a backup 
until you've tested it restorable/usable.  Until then, it's only a would-
be backup, as the backup simply isn't complete until it has been tested.)


After that, assuming skip_balance works, I'd try a scrub.  Given that 
both data and metadata are raid1, that should ensure everything matches 
checksum and eliminate any wrote-one-mirror-crashed-while-writing-the-
other, type errors.  Of course if the filesystem is corrupted enough, 
when you get to that point it might crash if it can't fix it, but at 
least here, I've found scrub pretty reliable at fixing problems such as 
bad shutdowns.

If scrub finds errors and they're all correctable, you're likely healthy 
again, but it might be worth running a read-only btrfs check to be sure.  
Same if scrub finds some uncorrectable errors. If the check reports 
errors, post them here and see what the experts say (I'm not a dev, just 
another user, and that sort of thing is normally beyond me), before 
actually trying to fix them.


Meanwhile, turning the topic a bit, toward your suggested 8 TB drives.  
Be aware that many of those are archive-targeted drives and aren't 
designed for normal use.  Linux (generally, not just btrfs) originally 
had problems with them but they've been fixed for a few kernel cycles 
now.  However, unless you really /are/ going to use them for archiving, 
that is, write once and shelve them, btrfs, and any other COW-based 
filesystem, isn't going to be your best choice for filesystem on them, as 
COW is a worst-case for the technology they use.  A more conventional 
filesystem should work better, altho ordinary usage performance still 
isn't going to be great because they're not /designed/ for that sort of 
usage, but rather for mostly write once and archive, or alternatively, 
for a write, save, whole-drive (firmware command level) secure-erase, 
reuse, cycle.

So if you're going for the really large drives, do be aware of that and 
buy archive-usage or otherwise based on what you actually plan to do with 
the drives.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

