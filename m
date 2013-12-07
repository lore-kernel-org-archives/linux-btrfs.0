Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f41.google.com ([209.85.128.41]:43194 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab3LGMhH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Dec 2013 07:37:07 -0500
Received: by mail-qe0-f41.google.com with SMTP id gh4so1465214qeb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 04:37:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$4b17c$7a4e1e36$4569b4d4$d3dc2dcf@cox.net>
References: <CADdntNuHYRAK_kcDJf1bnJeuTmc=CRx7TeyJPv4hsW9NPyd6mg@mail.gmail.com>
	<pan$4b17c$7a4e1e36$4569b4d4$d3dc2dcf@cox.net>
Date: Sat, 7 Dec 2013 12:37:05 +0000
Message-ID: <CADdntNt_5yvz0KC3StkJ0sOEw55oHWq4fV0qfOLaXymrYWOLUA@mail.gmail.com>
Subject: Re: Can't remove empty directory after kernel panic, no errors in dmesg
From: Niklas Schnelle <niklas.schnelle@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, so I tried btrfsck from a live stick and I got the following:
After btrfsck --repair the errors are displayed again though.

 btrfsck ./btrfsroot
Checking filesystem on ./btrfsroot
UUID: 2966e7fc-22dd-414a-9197-ec512d94a622
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 470 inode 60984 errors 200
root 470 inode 62463 errors 200
root 470 inode 62522 errors 200
root 470 inode 62536 errors 200
root 470 inode 62561 errors 200
root 470 inode 62594 errors 200
root 470 inode 68067 errors 400
root 470 inode 318806 errors 400
root 470 inode 318814 errors 400
root 470 inode 653218 errors 400
root 474 inode 60984 errors 200
root 474 inode 62463 errors 200
root 474 inode 62522 errors 200
root 474 inode 62536 errors 200
root 474 inode 62561 errors 200
root 474 inode 62594 errors 200
found 38006717310 bytes used err is 1
total csum bytes: 114009592
total tree bytes: 2296799232
total fs tree bytes: 2007769088
total extent tree bytes: 148426752
btree space waste bytes: 525760756
file data blocks allocated: 221531045888
 referenced 176664707072
Btrfs v0.20-rc1



On Sat, Dec 7, 2013 at 11:23 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Niklas Schnelle posted on Sat, 07 Dec 2013 11:36:45 +0100 as excerpted:
>
>> Hi List,
>>
>> so first the basics. I'm running Arch Linux with 3.13-rc2, btrfs-progs
>> 0.20rc1.3-2 from the repo and I'm using a SSD.
>> So I was having kernel panics with my USB 3.0 Gigabit card and was
>> trying to get a panic output. These panics are intermittent and most
>> often happen while using Chromium. Anyway so my system paniced while I
>> was in Chromium.
>> After the reboot Chromium reported that its preferences are corrupted,
>> thankfully I've both backups and an older snapshot. So I wanted to copy
>> over my ~/.config/chromium from the snapshot.
>> However I couldn't delete that directory, rm -rf reported it to not be
>> empty. Renaming worked via "mv chromium bad" but now I can't delete the
>> bad directory, this is the output:
>> http://pastebin.com/FWTPGGH1
>>
>> any idea how to get that directory deleted or how to obtain more
>> information?
>
> That sort of behavior is a(n almost[1]) sure sign of filesystem
> corruption.  On a normal filesystem, you'd fsck it and hope that fixed
> the errors, and you can try btrfsck too, first without the --repair
> option, just to see what it gives you, then if you want to risk it
> (btrfsck still not being fully tested yet, see the manpage), with the
> option.
>
> But before you try that repair option, you can try a few other things
> first.  Here's a link to a post with a list of things to try, in the
> order of least to greatest risk.  (It that case IIRC the filesystem
> wouldn't mount at all, so the problem was worse.  But the point is,
> there's other things you can try first -- btrfsck --repair isn't always
> the first recommended option.)
>
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999
>
> Meanwhile, FWIW I have my btrfs filesystems (also on ssd, actually dual
> SSD in btrfs raid1 mode) split up into independent filesystems on
> separate partitions, so all my data eggs aren't in the same basket, and
> recovery from one going bad isn't so difficult.  As a result, since most
> of it's still readable, I'd probably first do a scrub (raid1 mode both
> data and metadata so hopefully one copy is good), then if that didn't
> work I'd ensure my backups were current, then do a balance and/or btrfsck
> --repair, hoping that would fix it.  If that didn't fix it, I'd probably
> simply blow it away and restore from backup.  Since I have things splitup
> into multiple independent filesystems, the biggest is only double-digit
> gigs, and being on SSD, doing a mkfs.btrfs on the partition automatically
> does a trim/discard on the entire partition, zeroing it out, and copying
> over the tens of gigs from the backup will only take a few minutes.  It's
> not like the multiple TB btrfs filesystems on spinning rust I see people
> reporting as taking a good fraction of a day or longer.
>
> ---
> [1] Almost: Barring something like selinux or the like, where root is
> /not/ necessarily all powerful!  I also once had problems getting
> something to execute, even tho execute permissions were set... until I
> remembered that partition was mounted noexec!  Of course the equivalent
> here would be a read-only mount, but that can't be it or you'd not have
> been able to rename/move the directory, either.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
