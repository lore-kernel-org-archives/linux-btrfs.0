Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46572 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdJFHVI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Oct 2017 03:21:08 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e0MwJ-0005Gm-Ma
        for linux-btrfs@vger.kernel.org; Fri, 06 Oct 2017 09:20:55 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mounting bad btrfs img file
Date: Fri, 6 Oct 2017 07:20:48 +0000 (UTC)
Message-ID: <pan$bd753$f3b30edf$786c7da8$c1119d4c@cox.net>
References: <CAJ_hD5D4CUHW1eUour5HJKx2Zk69nm2ypFRiN2UXGt9ah7us6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric Wolf posted on Thu, 05 Oct 2017 09:38:18 -0400 as excerpted:

> My OS drive had issues with metadata (disk full even though it wasn't
> etc), and so I reinstalled my OS and now I'm learning that my backup img
> is bad. What steps should I go through to fix it?

Ugh...  Looks like you just got hit by the second sysadmin's rule of 
backups:  A backup isn't a backup until it's tested.  A would-be backup 
that's not tested isn't a backup, only a potential backup, because a 
backup isn't complete until you've verified that you can restore from it.

> $ sudo mount -o
> offset=8999927808,loop,recovery,ro,nospace_cache,nospace_cache
> /data/Backup/Nephele.img /mnt
> 
> mount: wrong fs type, bad option, bad superblock on /dev/loop0,

> nephele@Nephele:/data/Backup$ dmesg | tail
> 
> [48539.443711] BTRFS error (device loop0): parent transid verify failed
> on 98021605376 wanted 85976 found 85978

Those transids aren't too far apart, good. =:^)

You're already trying ro,recovery (which BTW is deprecated, replaced by 
usebackuproot), the first suggestion.

While various repair options can be tried, that's best done with a 
(tested) backup available.  Since this /is/ your backup and you don't 
have a working copy...

I'd suggest trying btrfs restore.  This command will attempt to restore 
files from the unmounted filesystem, writing them to a suitable 
location.  Obviously that means you need another operational filesystem 
available to write to, with a suitable amount of space available.  The 
nice thing about restore is that unlike check with the repair option or 
similar fix-or-make-worse options, while restore /does/ need space to 
restore the files to, it doesn't actually write anything to the 
filesystem it's restoring from, so it won't damage it further. =:^)

With luck restore will work in "simple" mode, and the fact that your 
wanted transids are close to those found gives you a pretty good chance 
simple mode will work just fine.  If it doesn't, then you have to try 
manual mode, giving restore more information, found via btrfs-find-root 
and fed to restore using -r.  There's a page on the wiki describing 
restore usage in this mode, tho it may not be entirely current so some 
additional translation of terms, etc, may be necessary.

https://btrfs.wiki.kernel.org/index.php/Restore

Note that in either mode you'll probably want the options to restore user 
permissions, symlinks, etc, not just the raw files.  Without these 
options you'll get the files, but written using normal user (root in this 
case) and umask settings, and symlinks won't be restored.  My own last 
usage was before these options were available, and I had to restore user/
group and perms metadata manually, as well as symlinks.  Also, note the 
dry-run option.  You can use this to see if it looks like restore will 
work (if it looks like it's going to be able to get most of your files) 
before actually trying it live.

Once you have your files restored if possible, or have given up on btrfs 
restore, you can try other stuff on the broken filesystem, or simply give 
up and wipe it to start over.  Since I have (tested) backups (altho they 
may not always be as current as I'd like, the reason I've had to try 
restore here, generally with good luck), I may try a couple fairly simple 
things like btrfs check --repair, but if that doesn't work, I generally 
wipe and restore from backups, so I don't have experience with the real 
complicated stuff.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

