Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36716 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbcEUDOh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 23:14:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b3xN5-0008HL-8t
	for linux-btrfs@vger.kernel.org; Sat, 21 May 2016 05:14:35 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 May 2016 05:14:35 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 May 2016 05:14:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs restore fails because of NO SPACE
Date: Sat, 21 May 2016 03:14:29 +0000 (UTC)
Message-ID: <pan$b35ce$da195d1e$651148ec$9ea8b2cf@cox.net>
References: <6BBAAABC-616F-48A6-BDF2-70B23B8E0D72@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wolf Bublitz posted on Fri, 20 May 2016 19:38:55 +0200 as excerpted:

> Hallo,
> 
> I have a confusing problem with my btrfs raid. Currently I am using the
> following setup:
> 
> btrfs fi show
> Label: none  uuid: 93000933-e46d-403b-80d7-60475855e3f3
> 	Total devices 2 FS bytes used 2.56TiB
>       devid    1 size 2.73TiB used 2.71TiB path /dev/sda
>       devid    4 size 2.73TiB used 2.71TiB path /dev/sdb
> 
> As you can see both disks are full.
> 
> Actually I cannot mount my raid, even with recovery options enabled:
> 
> mount /dev/sda /mnt/Data -t btrfs
> -onospace_cache,clear_cache,enospc_debug,nodatacow

[generic mount error]

> dmesg shows:
> 
> [ 1066.243813] BTRFS error (device sda): parent transid verify
> failed on 9676657786880 wanted 242139 found 0
[...]
> [ 1066.273234] BTRFS: failed to read chunk root on sda

None of those options are likely to help, there.

What /might/ help is the "usebackuproot" mount option, if your kernel is 
reasonably current, or the "recovery" mount option, if it's a bit older.  
Btrfs mount options are documented in the btrfs (5) manpage (not the 
btrfs (8) manpage, specify the 5), tho again, usebackuproot will only 
appear in the manpage if you're running a reasonably current btrfs-progs 
version (recovery should be listed in both new and old, but it's listed 
as deprecated in new, referring readers to the usebackuproot entry).  Or 
alternatively to the manpage, you can check the mount options listing on 
the wiki.

> After spending some time with Google I found a possible solution for my
> problem by running:
> 
> btrfs restore -v /dev/sda /mnt/Data
> 
> Actually this operation fails silently (computer freezes). After examine
> the kernel logs I have found out that the operations fails because of
> „NO SPACE LEFT ON DEVICE“. Can anybody please give me a solution for
> this problem?

You don't explicitly say what you expect btrfs restore to do, but given 
the specific command you use, I suspect that you misunderstand what it 
does, and it's actually working, but you are running out of space as a 
result of using restore incorrectly, because of that misunderstanding.

What btrfs restore does is provide you a read-only method to try to 
restore your files from a filesystem that won't mount, by rewriting what 
it can recover to an entirely different location on an entirely 
different, mounted, filesystem, which of course must contain enough space 
to hold a new copy of all those restored files.

And if the filesystem in question isn't mounted to its usual mountpoint,
/mnt/Data, that means you're trying to write all the recovered files to 
whatever filesystem actually contains the mountpoint itself, almost 
certainly the root filesystem (/), in this case.

And I'll place money on a bet that whatever your root filesystem is, it 
doesn't have the terabytes of free space that are likely to be necessary 
to restore all of that multi-device multi-TB per device btrfs!  
Otherwise, you /likely/ wouldn't be running the separate btrfs in the 
first place, but storing it on your main filesystem, instead.  So when 
btrfs restore runs out of room on / ... everything freezes.


IOW, in ordered to successfully use btrfs restore, you have to have a 
filesystem with enough free space available mounted somewhere in ordered 
to write the files to that btrfs restore is restoring!  If you don't, 
yes, you /will/ run into problems! =:^)

That said, it is possible to use pattern matching to tell btrfs restore 
to only restore say one directory at a time, and by using that if you 
don't have enough space for everything but are willing to give up some of 
what was stored, you can tell btrfs restore to only restore the vitally 
important stuff that will fit, and not bother trying to restore the less 
important stuff that won't fit.  Again, see the btrfs-restore manpage, 
for that and other details.

And, unless you want those restored files all written as root, you'll 
probably want to use the restore metadata option as well, to restore 
timestamps and owner/perms information.  Similarly, there's an option to 
restore symlinks as well, without which they'll be missing.  So you 
probably do want to check that manpage.  Just sayin'. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

