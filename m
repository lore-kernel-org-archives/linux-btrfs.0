Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58351 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaHWF2U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 01:28:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XL3s2-0007Yu-TU
	for linux-btrfs@vger.kernel.org; Sat, 23 Aug 2014 07:28:10 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 07:28:10 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Aug 2014 07:28:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: superblock checksum mismatch after crash, cannot mount
Date: Sat, 23 Aug 2014 05:27:53 +0000 (UTC)
Message-ID: <pan$a4556$243aa48a$bd2898a8$c2006893@cox.net>
References: <53F7BD8E.10308@floga.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Florian Gamböck posted on Sat, 23 Aug 2014 00:00:46 +0200 as excerpted:

> I think i just crashed my btrfs partition, is someone willing to guide
> me through the recovery steps?

A month or so ago I had a similar problem, and got some experience with 
real recovery, that I hadn't had previous despite being on the list for 
some time.

First thing, afaik right now, the recovery mount option only tries the 
first superblock.  If it's corrupted, as your case reads like it might 
be, there's currently no fallback to the first and second backup 
superblocks.  There has been some discussion and a patch that would allow 
the recovery mount option to check the backup superblocks too, if the 
primary superblock fails checksum as yours did.

So the next thing is to inspect the primary superblock and see how bad it 
is, and compare it to the others, then select a good one and rewrite it 
over the bad one (semi-)manually.

btrfs-show-super is your tool for inspecting the superblocks.  See the 
manpage for the details.

Then use btrfs rescue super-recover to overwrite the bad superblock with 
one that checks out as good (csum match).  See the btrfs-rescue manpage 
for the details there.

FWIW, the first superblock is @ 64 KiB, the second @ 64 MiB, the third @ 
256 GiB.  I didn't see the size of your SD card, but I'd assume it's big 
enough to at least have the second one, but presumably not the third.  
(This is from the wiki @ btrfs.wiki.kernel.org, documentation, problem 
faq, how to cleanup the old superblock, what if I don't have wipefs.)


In my case it wasn't the superblock which was fine, but a different 
problem.  Hopefully the above will fix things for you, but if not or if 
you're simply interested in fixes for other problems, what I ended up 
using was btrfs restore.  That doesn't write to the bad filesystem, 
instead using the restore tool to search for and restore files off the 
unmounted filesystem, writing them to a presumably good mounted 
filesystem (they're written as ordinary files so the filesystem can be 
anything, it was reiserfs, here).

In addition to the manpage, the wiki has a nice page on using btrfs 
restore along with btrfs-find-root (which has a manpage as well) to try 
to find a better tree root (btrfs keeps a history of roots going back 
quite some way), if the one listed in the superblock is too damaged or 
gives you generation-doesn't-match errors.

https://btrfs.wiki.kernel.org/index.php/Restore

One thing that's /not/ entirely clear from the wiki page, that ended up 
confusing me at first when I was actually trying to use the information 
in a recovery, is that generation number and transaction ID (transid) are 
the same thing.  Assuming a good superblock (either primary or a backup), 
you can read what the current generation/transid should be with btrfs-
show-super.  That ends up being your target, and you try to get something 
as close to that as possible that has all your trees.  See the link above 
for more.

Another hint is that you can use the recently added btrfs restore -D
(--dry-run) option, to see how much it'll recover (it'll normally scroll 
off all the files it'd recover).  Using -D (dry run) with -l (list tree 
roots) and -t (root tree location) lets you see which tree roots can be 
restored from each location (the bytenr corresponding to a transid).

Finally, a couple things to keep in mind if you do end up restoring files 
this way:

* File user and permissions are lost.  Everything is restored as root 
using umasked permissions.

I had a backup but it was a bit dated, so I choose to use btrfs restore 
instead of simply restoring from the backup.  Then I hacked up a find 
script to check to see if the restored file was in the backup as well, 
and if so, chown/chmode the restored file to the same permissions as the 
backed up file.  That took care of about 98% of the files, with the 
others being new since the backup so I had to manually set those 
permissions.

* Symlinks aren't restored.

I ended up recreating them as I missed them in the course of my normal 
work.

Hopefully between the above, the wiki page and the manpages, you can use 
restore if you need to.  But with a bit of luck, all you need is btrfs-
show-super and btrfs rescue super-recover, and you'll be all set.  Of 
course you said you had backups too, giving you the freedom to experiment 
a bit and get some recovery practice without danger of further loss, 
which is always nice. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

