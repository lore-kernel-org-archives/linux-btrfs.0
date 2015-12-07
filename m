Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56426 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbbLGNsz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 08:48:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a5w9t-0008Ni-2y
	for linux-btrfs@vger.kernel.org; Mon, 07 Dec 2015 14:48:53 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 14:48:53 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 14:48:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing recursive fault and parent transid verify failed
Date: Mon, 7 Dec 2015 13:48:47 +0000 (UTC)
Message-ID: <pan$cb93a$b4f560b9$2dfdbdbc$17d7a835@cox.net>
References: <20151207015715.GA13954@alistair-xps13>
	<pan$42653$68e1a3aa$3a4c1c2c$b0e89f8@cox.net>
	<20151207100256.GA6836@alistair-xps13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alistair Grant posted on Mon, 07 Dec 2015 21:02:56 +1100 as excerpted:

> I think I'll try the btrfs restore as a learning exercise, and to check
> the contents of my backup (I don't trust my memory, so something could
> have changed since the last backup).

Trying btrfs restore is an excellent idea.  It'll make things far easier 
if you have to use it for real some day.

Note that while I see your kernel is reasonably current (4.2 series), I 
don't know what btrfs-progs ubuntu ships.  There have been some marked 
improvements to restore somewhat recently, checking the wiki btrfs-progs 
release-changelog list says 4.0 brought optional metadata restore, 4.0.1 
added --symlinks, and 4.2.3 fixed a symlink path check off-by-one error.  
(And don't use 4.1.1 as its mkfs.btrfs is broken and produces invalid 
filesystems.)  So you'll want at least progs 4.0 to get the optional 
metadata restoration, and 4.2.3 to get full symlinks restoration support.

> Does btrfs restore require the path to be on a btrfs filesystem?  I've
> got an existing ext4 drive with enough free space to do the restore, so
> would prefer to use it than have to buy another drive.

Restoring to ext4 should be fine.

Btrfs restore writes files as would an ordinary application, the reason 
metadata restoration is optional (otherwise it uses normal file change 
and mod times, with files written as the running user, root, using umask-
based file perms, all exactly the same as if it were a normal file 
writing application), so it will restore to any normal filesystem.  The 
filesystem it's restoring /from/ of course must be btrfs... unmounted 
since it's designed to be used when mounting is broken, but it writes 
files normally, so can write them to any filesystem.

FWIW, I restored to my reiserfs based media partition (still on spinning 
rust, my btrfs are all on ssd) here, since that's where I had the room to 
work with.

> My plan is:
> 
> * btrfs restore /dev/sdX /path/to/ext4/restorepoint
> ** Where /dev/sdX is one of the two drives that were part of the raid1
>    fileystem
> * hashdeep audit the restored drive and backup
> * delete the existing corrupted btrfs filesystem and recreate
> * rsync the merge filesystem (from backup and restore)
>   on to the new filesystem
> 
> Any comments or suggestions are welcome.


Looks very reasonable, here.  There's a restore page on the wiki with 
more information than the btrfs-restore manpage, describing how to use it 
with btrfs-find-root if necessary, etc.

https://btrfs.wiki.kernel.org/index.php/Restore

Some details on the page are a bit dated; it doesn't cover the dryrun, 
list-roots, metadata and symlink options, for instance, and these can be 
very helpful, but the general idea remains the same.

The general idea is to use btrfs-find-root to get a listing of available 
root generations (if restore can't find a working root from the 
superblocks or you want to try restoring an earlier root), then feed the 
corresponding bytenr to restore's -t option.

Note that generation and transid refer to the same thing, a normally 
increasing number, so higher generations are newer.  The wiki page makes 
this much clearer than it used to, but the old wording anyway was 
confusing to me until I figured that out.

Where the wiki page talks about root object-ids, those are the various 
subtrees, low numbers are the base trees, 256+ are subvolumes/snapshots.  
Note that restore's list-roots option lists these for the given bytenr as 
well.

So you try restore with list-roots (-l) to see what it gives you, try 
btrfs-find-root if not satisfied, to find older generations and get their 
bytenrs to plug into restore with -t, and then confirm specific 
generation bytenrs with list-roots again.

Once you have a good generation/bytenr candidate, try a dry-run (-D) to 
see if you get a list of files it's trying to restore that looks 
reasonable.

If the dry-run goes well, you can try the full restore, not forgetting 
the metadata and symlinks options (-m, -S, respectively), if desired.

>From there you can continue with your plan as above.

One more bonus hint.  Since you'll be doing a new mkfs.btrfs, it's a good 
time to review active features and decide which ones you might wish to 
activate (or not, if you're concerned about old-kernel compatibility).  
Additionally, before repopulating your new filesystem, you may want to 
review mount options, particularly autodefrag if appropriate, and 
compression if desired, so they take effect from the very first file 
created on the new filesystem. =:^)

FWIW in the past I usually did an immediate post-mkfs.btrfs mount and 
balance with -dusage=0 -musage=0 to get rid of the single-mode chunk 
artifacts from the mkfs.btrfs as well, but with a new enough mkfs.btrfs 
you may be able to avoid that now, as -progs 4.2 was supposed to 
eliminate those single-mode mkfs.btrfs artifacts on multi-device 
filesystems.  I've just not done any fresh mkfs.btrfs since then so 
haven't had a chance to play with it and see it personally, just yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

