Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45895 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaEZISA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 04:18:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Woq6W-0005uq-Jh
	for linux-btrfs@vger.kernel.org; Mon, 26 May 2014 10:17:56 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 10:17:56 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 10:17:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount fails with "double free or corruption" after failed
Date: Mon, 26 May 2014 08:17:41 +0000 (UTC)
Message-ID: <pan$60c96$7b46daa$8c03839e$52c41f85@cox.net>
References: <20140525182601.GA7642@dmt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrei Volt posted on Sun, 25 May 2014 20:26:01 +0200 as excerpted:

[FWIW, your mail seems to have scrambled a bit in spots.  The last bit of 
the subject ended up in the body, along with a blank reply-to header, and 
the btrfs filesystem df and btrfs filesystem show output seemed a bit 
scrambled as well.]

> I finally managed to mount the filesystem after a btrfs-zero-log and
> reboot.

btrfs-zero-log is a reasonable choice. Btrfs, being copy-on-write (COW), 
is designed to be self-consistent at each tree-root commit (every 30 
seconds by default altho there's now a mount option to change it), with 
the log only containing transactions between commits.  So doing a zero-
log is effectively trading a few seconds worth of additional transaction 
data for the increased stability of an atomic tree-root commit-point. =:^)

> I've run an additional backup, a bit more up to date then my previous
> one, but obviously the error message worries me a bit.

Good.  Of course btrfs isn't yet fully stable and keeping current backups 
is strongly recommended for anything you value on btrfs, but there's 
"current" (the hassle of more frequent backups outweighs the benefit) and 
there's "current" (I know there's problems and I want as much backed up 
as I can possibly get)...

> How can I make sure the data is intact?

A scrub verifies data integrity in terms of lack of corruption, but of 
course in the presence of a bug, it's possible the original data was 
invalid.  Since we're talking about a filesystem, that means scrubed data 
should be correct as written, but the metadata could still be incorrect 
(there might still be logic errors in the mapping of that data, perhaps 
making some of it inaccessible).

> What kind of corruption could occur? (what's the worse that could
> happen? so far I'm not seeing anything unusual). I didn't do anything
> else apart from the resize operation, a few btrfsck(s) which failed
> immediately, and the btrfs-zero-log operation.

btrfsck!  Hopefully those btrfscks were without the --repair option, 
making them read-only.  As the btrfs wiki now notes, btrfsck aka btrfs 
check is still experimental and only knows how to fix certain errors.  In 
some cases it can actually make problems worse, so running it with the
--repair option is only recommended (a) if you know exactly what you are 
doing or a dev tells you to, or (b) if you've exhausted all other options 
and the btrfs check --repair is your last ditch effort before blowing the 
filesystem away with a new mkfs.

Never-the-less, given that you can still mount, if you /did/ use
--repair, apparently it didn't screw things up /too/ much.

> I should mention that on the second to last reboot the mount failed
> again, and it only mounted again correctly after zero-log + reboot.
> (same error, "double free or corruption", after a bunch of output that
> got cleared from the scrollback buffer.
> 
> I've made a backup via rsync but when I try to du -sc the backup and the
> original, the original reports "infinity" (although this is not new),

That suggests metadata damage, such that one or more files are reporting 
infinite size.  You could run without the -s/--summarize option, then ls -
l as appropriate, and see if you can pin down what file it is.  Deleting 
and/or restoring that file from backup would be the fix there.

> and the backup errors out on some files (which is why I'd rather not go
> from the restore from backup option, until I'm sure the backup is
> correct)

What files?  Are they the same files where the originals seem to have 
problems?  If not and if the other copy of the files checks out, 
restoring one way or the other to make both the original and the backup 
more complete would be what I'd try to do.  What did rsync say about 
those files when syncing them?  If the files are the same as is likely, 
then you may have to eat the bad files or restore from older backup.

> What should I do to:
> 
> 1. (ideally) repair the FS. Right now it _seems_ to be failing on every
> other boot, and I have to run btrfs-zero-log to mount, and even then it
> only mounts successfully on reboot.

I'd consider that filesystem suspect and would try recovery and backup as 
best I could using the other techniques discussed here (and in any other 
replies if others answer), then would blow away the filesystem and start 
over, thus avoiding any lingering issues.

> 2. check for data integrity

Looks from the below like you've already run a scrub, which verifies 
integrity at the filesystem level.  Using the info from the non-
summarized du and list, and other information as available, you can also 
try md5sum and the like on individual files.  Of course how far you go to 
try to recover individual files depends on what those files actually 
are.  If they're simply cache or parts of distro packages that can simply 
be reinstalled, blowing them away or reinstalling should take care of it 
so no big deal.  If they're part of some project you've spent days/weeks/
months on, then one would /hope/ you have several levels of backup, and 
you might lose a few hours or days worth of work, but not the whole 
thing.  If you don't have backups, particularly given that you had the 
files on a still not entirely stable and mature btrfs, well, I guess your 
actions put the lie to any claims that you really considered that data 
valuable, don't they?

> 3. check that my backup is correct?
> 
> Here's the output of the commands suggested on the wiki:
> 
> Linux 3.13.9-1-ck #1 SMP PREEMPT Fri Apr 18 23:21:44 CEST 2014 x86_64
> GNU/Linux

Of course the 3.13 kernel series is outdated, with 3.14 being current and 
3.15 getting close to release now.  Given that btrfs /is/ under heavy 
development and that there /are/ bugfixes every release, before giving up 
hope I'd try with the latest 3.15-rc or current git-build.  Often enough, 
the current kernel has a bug-fix, and you'll be back in business.  (But 
personally, even if 3.15 seems to address the current bug, I'd still 
consider that filesystem suspect, and take the opportunity to do the best 
backup possible, then blow the existing filesystem away and start with a 
fresh mkfs and restore from backup.)

> Btrfs v3.14.1

That's current.

> Data, single: total=188.99GiB, used=143.17GiB
> System, single: total=4.00MiB, used=28.00KiB
> Metadata, single: total=4.01GiB, used=2.79GiB

[Here again, your mail seemed a bit scrambled, with the below btrfs 
filesystem show output in the middle of the above btrfs filesystem df 
output.  I /think/ I reconstructed it correctly.]

> Label: 'root'  uuid: 0c2bfb0a-a549-4170-92a5-c4f218c023eb
> 	Total devices 1 FS bytes used 25.20GiB
>  	devid    1 size 37.97GiB used 37.97GiB path /dev/sda3
> 
> Label: 'home'  uuid: ea64435d-b24f-453b-8f0a-af7e18726c86
> 	Total devices 1 FS bytes used 145.96GiB
> 	devid    1 size 200.00GiB used 193.00GiB path /dev/sda2

You don't say which one of those had the problems, but judging from the 
size reported in the df, I'd say it must be the home filesystem.

Assuming that's correct you probably don't want to deal with this ATM, 
but put it on your list for later or you'll soon be having problems with 
root:  Your root is 100% chunk-allocated according to the above show, 
with no room for new chunk allocations, so data or metadata, whichever 
runs out first, you won't be able to allocate more.  You'll want to do a 
btrfs filesystem df and see whether it's data or metadata that has the 
furthest spread between used and total, and rebalance it using balance 
filters in ordered to return some of that space to the unallocated pool.  
Assuming it's data that's unbalanced, try something like this first:  
btrfs balance start -dusage=0, then up the usage= number (maximum 
percentage chunk used) in increments toward 100 until you have several 
gigs free (difference between size and used on the devid line) in btrfs 
filesystem show.  (To do metadata, make it -m instead of -d.)  There's 
more on the btrfs wiki, which you mentioned so I guess you have the link. 
=:^)

> I've also ran a btrfs scrub which reported 4 uncorrectable errors.

But you don't mention what they were?  Try btrfs device stats -z to reset 
the statistics, then run the scrub again and see if it still reports the 
problem.  If it does, dmesg should tell you a bit more about where it 
was.  Unfortunately, it appears you're using single mode for both data 
and metadata, so scrub won't be able to use the second (hopefully good) 
copy to correct any errors it finds, but if the uncorrectable errors are 
in the data, you should be able to delete the file and correct the 
problem that way.  If it's in metadata, correcting the problem may be a 
bit harder and it's likely more critical, the reason btrfs normally 
defaults to dup mode for metadata on single-device filesystems (tho ssd 
is an exception).

FWIW, that's why I run btrfs raid1 mode here, on a pair of SSDs (the 
single device parallel would be dup mode, but it will only do that for 
metadata unless you use the mixed-bg option, and of course going mixed 
and doing dup for data/metadata both means you have only half the room on 
the filesystem, since everything has two copies).  I really like the fact 
that btrfs does checksum-verified data/metadata integrity checking, and 
having the second raid1-mode copy available in case one goes bad seems to 
me to be the sensible policy reaction to that.  I only wish btrfs had N-
way mirroring instead of only two-way, so I could have three copies of 
everything in case two copies go bad.  That would be my ideal balance 
between reliability and capacity.  It's on the roadmap, but not 
implemented yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

