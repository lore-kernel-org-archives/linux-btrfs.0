Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59834 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaHQMb4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Aug 2014 08:31:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XIzcn-0002VK-Q5
	for linux-btrfs@vger.kernel.org; Sun, 17 Aug 2014 14:31:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Aug 2014 14:31:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Aug 2014 14:31:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Putting very big and small files in one subvolume?
Date: Sun, 17 Aug 2014 12:31:42 +0000 (UTC)
Message-ID: <pan$df1ba$a20420a2$2ac33113$90ec0a1@cox.net>
References: <CAH-HCWVDtPv9gYxpcA4drK=FDes_0z8QTxqOBcocWf9T_b4tyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shriramana Sharma posted on Sun, 17 Aug 2014 14:26:06 +0530 as excerpted:

> Hello. One more Q re generic BTRFS behaviour.
> https://btrfs.wiki.kernel.org/index.php/Main_Page specifically
> advertises BTRFS's "Space-efficient packing of small files".
> 
> So far (on ext3/4) I have been using two partitions for small/regular
> files (like my source code repos, home directory with its hidden config
> subdirectories etc) and big files (like downloaded Linux ISOs,
> VMs etc) under some sort of understanding that this will help curb
> fragmentation -- frankly I'm not a professional sysadmin in some company
> or such so my assumption may not be valid.
> 
> In any case, since BTRFS effectively discourages usage of separate
> partitions to take advantage of subvolumes etc, and given the above
> claim to the FS automatically handling small files efficiently, I wonder
> if it makes sense any longer to create separate subvolumes for such
> big/small files as I describe in my use case?

It's worth noting that btrfs subvolumes are a reasonably lightweight 
construct, comparable enough to ordinary subdirectories that they're 
presented that way when browsing a parent subvolume, and there was 
actually discussion of making subvolumes and subdirs the exact same 
thing, effectively turning all subdirs into subvolumes.

As it turns out that wasn't feasible due not to btrfs limitations, but 
(as I understand it) to assumptions about subdirectories vs. mountable 
entities (subvolumes) built into the Linux POSIX and VFS levels.  Tho I 
admit to not really understanding the details, either because that 
discussion mostly happened before I became a regular or because it's 
above my head, or both, I'm not sure which.

But the point is, there really /is/ little overhead in creating a 
subvolume in btrfs.  It's basically a subdir that happens to be directly 
mountable on its own, tho if you're doing snapshotting there's also the 
bit about snapshots stopping at subvolume boundaries, while they don't 
stop at subdirs, to consider.

Based on that, there's really nothing stopping you from creating as many 
subvolumes as you want on btrfs.

OTOH, I tend to be rather more of an independent partition booster than 
many.  The biggest reason for that is the too many eggs in one basket 
problem.  Fully separate filesystems on separate partitions separate 
those data "eggs" into separate baskets, so if the metaphorical bottom 
drops out of one of those filesystem baskets, only the data eggs in that 
filesystem basket are lost, while the eggs in the separate filesystem 
baskets are still safe and sound, not affected at all. =:^)

The thing that troubles me about replacing a bunch of independent 
partitions and filesystems with a bunch of subvolumes on a single btrfs 
filesystem is thus just that, you've nicely divided that big basket into 
little subvolume compartments, but it's still one big basket, and if the 
bottom falls out, you potentially lose EVERYTHING in that filesystem 
basket!

Particularly while btrfs remains not entirely mature and stable, that 
doesn't seem to me to be a particularly wise move.  Both out of caution 
and because over the years I've evolved a partitioning scheme that works 
well for me, I'll probably keep even after I'm satisfied with btrfs 
stability, but certainly until then, I personally shudder at the 
additional risk every time I see someone mention replacing partitions 
with subvolumes.  (Of course as I said about something else in a previous 
reply, given that btrfs isn't fully stable, by definition all data that's 
important to you is backed up, and if it's on btrfs and not backed up, by 
definition it's not that important to you.  By that argument, there's 
really nothing for me to be shuddering /about/, but the fact remains, I 
do.)

I actually learned that lesson back on MS before the turn of the 
century.  This was before IE4 came out and I along with many others was 
running the public betas.  As it happened, in ordered to speed up IE the 
devs changed it to keep the temporary-internet-files cache index file 
location in RAM and to direct-write index changes to the appropriate file 
block locations without going thru the normal filesystem layers.  What 
they forgot about was the critical fact that they had combined the 
previously separate Windows Explorer shell with IE, and that as a 
consequence it was now running all the time.  Fine most of the time, but 
what happens when defrag comes along and decides the index file needs to 
be moved out from where the still running combined IE/WE shell things it 
is?

Most people running that beta that also had defrag scheduled to run 
automatically, as many did since it was a beta and they were power users, 
ended up with cross-linked files and an otherwise badly mangled 
filesystem that chkdisk couldn't completely sort out, because IE ended up 
simply overwriting whatever files defrag decided to stick where that 
index file had been, with index file data that would have been routed to 
the new index file location had MSIE not bypassed the normal filesystem 
access routines.  A number of those testers lost important files they 
didn't have backups for as a result.

Eventually MS "solved" the problem by simply marking the index file with 
the system attribute, which caused defrag to skip it, leaving it where it 
was regardless of what else it wanted to put there or how many fragments 
it might be in.

But while I did get a bit of temporary internet file cache corruption, 
that was all.  Why?  Because I had a separate partition for my temporary 
stuff, including both $TEMP/TMP and temporary internet files.  Defrag 
still moved the index file out from under IE, and IE still overwrote 
whatever else defrag put in its place, but since I had the temporary 
internet files cache configured to be on the tempfiles partition, the 
only thing there to overwrite was temporary files anyway, so none of my 
valuable files were ever in danger.

Talk about a lesson reinforcing a choice to put my tempfiles on a 
separate partition!  That's ONE thing I've *ALWAYS* been sure I did ever 
since, and indeed, these days my $TMP, /tmp and /var/tmp is actually on 
tmpfs, a memory-based filesystem so it's all in memory and erased when I 
reboot, kept as far away from permanent on-drive files as I can keep it. 
=:^)

The second reason for separate partitions is that they take less time to 
fsck, backup/restore, and on btrfs, balance/scrub, than big huge 
monolithic partitions.  Especially since it's likely some partitions 
aren't mounted and / is read-only mounted (see below), that means less 
time spent in recovery, and btrfs scrubbed and balanced more frequently 
since it's a matter of minutes (especially on ssd), not hours.


FWIW, while I've evolved my partitioning scheme over the years, here's 
what I use now:

/	8 GB, on ssd, read-only mounted by default.

/ includes most of /usr and /var as well as /etc.  It's mounted read-only 
unless I'm actively updating, thus dramatically increasing its robustness 
in the event of a crash, since it's nearly always mounted read-only and 
thus isn't likely to be corrupted.

/home	20 GB, on ssd.

/home includes my normal user stuff of course, but not my big media 
files, etc.  I also symlink some state dirs from /var to /home/var/, so 
they can be written while /var itself, on /, remains read-only mounted.

/var/log	Half a GB, ssd.

/var/log is very small.  I keep a tight logrotate schedule. =:^)  It's a 
dedicated partition for two reasons.  First, if something starts run-away 
logging, it can fill up the log partition but can't otherwise affect the 
system.  Second, logs being what they are, in the event of a crash, it's 
very likely some log entry will have been in the process of being 
written, and thus this partition will see some potential corruption.  
Limiting that corruption risk to a dedicated log partition seems wise. 
=:^)

/mnt/packages	24 GB, not mounted by default, ssd.

This contains my distro's package tree and various overlays.  I'm running 
gentoo, so the package tree is simply build scripts and configuration, 
but I also keep all the source tarballs here, along with my kernel tree 
(git), binpkgs for quick reinstallation without rebuilding from sources, 
and ccache.  Additionally, I build for my 32-bit netbook on this machine 
and keep the binpkgs and ccache for it here too.  That's why it's a full 
24 GB.

This isn't mounted at all unless I'm updating, thus keeping it out of 
harm's way in the event of a crash.

/mm		100 GB+, not mounted by default, spinning rust.

/mm is my media partition, mostly long term storage for pretty big files, 
doesn't need mounted by default but often mounted to access the media 
files.  While not ideal for large files this one's reiserfs, since that's 
what I standardized on before switching to ssd and btrfs.  From my 
experience, reiserfs is in fact more stable than ext3/4, since relatively 
fewer kernel devs dare mess with it, and it has proven stable for me even 
thru hardware issues such as bad memory.

That's also why I keep a reiserfs backup of all the SSD/btrfs partitions 
too, since I know it is long-term stable and isn't likely to suddenly bug 
out on me.

/tmp, /var/tmp, /run...  tmpfs.

Additionally I have primary backup partitions of all the btrfs/SSD 
partitions (except /var/log) on (separate) btrfs/SSD, and as mentioned 
secondary backups of all partitions on reiserfs/spinning-rust.



-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

