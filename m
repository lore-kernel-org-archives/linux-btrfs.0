Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39113 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab3EXGNX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 02:13:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UflFg-0006Rr-5h
	for linux-btrfs@vger.kernel.org; Fri, 24 May 2013 08:13:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 May 2013 08:13:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 May 2013 08:13:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Virtual Device Support ("N-way mirror code")
Date: Fri, 24 May 2013 06:13:04 +0000 (UTC)
Message-ID: <pan$d29fc$4ed9f39b$c95e9df6$a135bf3e@cox.net>
References: <518CFE3A.3080900@chinilu.com>
	<pan$9855$81c2d2df$c9aa1ca3$2451cc46@cox.net> <knfoof$u08$1@ger.gmane.org>
	<1823670.hMFQUu2mCu@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Thu, 23 May 2013 18:08:35 +0200 as excerpted:

> Am Dienstag, 21. Mai 2013, 13:19:31 schrieb Martin:
>> Yep, ReiserFS has stood the test of time very well and I'm still using
>> and abusing it still on various servers all the way from something like
>> a decade ago!
> 
> Very interesting. I only used it for a short time and it worked.
> 
> But co-workers lost several ReiserFS filesystems completely.

Do you know if that was before (Chris's) ordered-mode patches?  I never 
lost complete FSs (even once when my AC went out and the disks overheated 
resulting in a head-crash... the disks worked again once temps returned 
to normal, tho I did lose some data where the platters were very likely 
physically damaged due to the head-crash), but before the ordered-mode 
patches, I did lose data a number of times due to simple loss of power or 
system lockup.

So I learned to keep tested backups, tho they weren't always current.  
But a few hours of repeated work on a not-current backup copy, sure beats 
days of recreation from scratch, and when that head-crash happened, I was 
glad I had 'em!

But after data=ordered, the only data loss was due to that physical head 
crash, and even then it was whatever files were in the physically damaged 
area, not the entire filesystem.  And with that and various other 
hardware problems I've had including wonky memory in various forms and a 
mobo that popped a few capacitors in the sata bus area that I was still 
able to run if I kept it cold enough (when it started timing out 
operations I'd know it was too warm), that notably, btrfs could NOT 
handle... yes, I have some pretty deep respect for reiserfs, now.  It 
survived hardware issues that nobody could /sanely/ expect /any/ 
filesystem to survive, yet reiserfs did.

> Well, if you search for the terms corrupt and your favorite filesystem,
> you will always find hits.

True.

> Anyway, I won´t use ReiserFS 3 today for several reasons:
> 
> 1) It is not yet actively developed anymore, but more in a maintenance.
> I know for some that might be a reason to use it, but I think this
> basically increases the risk of breakages instead of reducing it. That
> said, I didn´t hear of any, and also JFS is in maintenance, but appears
> to work as well.

Well, there's a difference between being left to rot, which I'm beginning 
to be concerned might be where reiserfs is likely to be headed at this 
point, and simply mature and feature complete, so the only real 
maintenance needed is to keep up with the ever-changing kernel api, which 
people changing that api must do for anything in-kernel.  That's where 
reiserfs has been for some time, now.

And as I believe I mentioned earlier, being simply mature is definitely 
better than the ext4, and for some time altho not so much any longer, 
ext3, were, where every kernel hacker and their brother seems to consider 
it worth changing, including even Linus himself when he took the ext3 
writeback-by-default commit, which lasted for several kernel cycles, that 
proved a bad decision for data safety in a number of cases I know about 
personally.

You mentioned jfs is in a similar position, what I'd call mature but 
maintained.

FWIW, I'd consider XFS to be a pretty good example of a somewhat more 
assertive middle ground, still being actively developed, new features 
being added, but generally by a core xfs group, not everybody and their 
brother, and arguably with a cautious enough approach that (as reiserfs 
with ordered mode, extended attributes and quotas being added after it 
was declared feature complete and more or less abandoned by its previous 
upstream developer), it's actually much more stable and broadly usable 
these days than it was in its heyday, when it had a reputation of being 
great for UPS-backed enterprise systems, but for eating data on joe-user 
line-only-powered systems should that line power disappear.

> 2) As to my knowledge a fsck.reiserfs cannot tell the filesystem I check
> and possible ReiserFS3 filesystems in virtual machine image files on it
> appart, happily mixing them together in a huge big mess.

AFAIK that's limited to the --rebuild-tree option, which comes with 
pretty scary warnings and requires not just a y/n, but actually a fully 
typed out yes, to proceed.  So it's not something that people should 
normally run -- they should be going to the backups if they have them 
before they run --rebuild-tree.  But it's there for those who didn't HAVE 
backups, and who are prepared to gamble with SOME data loss in ordered to 
have the chance at SOME recovery.  And even then, the instructions in the 
warning say to ddrescue or the like to create a backup image before 
trying to recover, just in case.

However, yes, with those caveats AFAIK that's still an issue.  Had such 
usage been foreseen all those years ago, I'm sure the implementation 
would have been rather different.

> 3) As to my knowledge mount times of large partitions can be quite long
> with ReiserFS 3.

Hmmm... Never seen that except in the case where it's replaying a 
journal, and in that case the mount time is limited by the size of the 
journal to replay.

However, it's quite likely that I simply don't run large enough 
filesystems for it to be an issue here, since I tend to use partitions 
far more heavily than most, so I've never actually run a reiserfs of more 
than a few hundred GB, let alone the multiple TBs common on unpartitioned 
multi-TB disks today.

And multiple partitions will continue to be the case here with btrfs, as 
well.  I'll use snapshots for the convenience of rollback, but probably 
won't be using the general case subvolume support, preferring entirely 
separate partitions instead.

Because a strong multi-partition policy as saved my *** more than once!  
The case that really iron-clad it for me was actually before I switched 
to Linux, when I was still running MS servantware (see my sig for 
context).  I was beta-testing the IE4 previews, and MS changed the way it 
handled the IE cache index file for performance reasons, maintaining its 
absolute disk addresses in memory instead of grabbing the info from the 
disk each time.

Then some of the testers started having horrible cross-linked files 
problems with a number of them losing valuable data.  Turns out that (MS' 
own) defrag was moving the files out from under IE, which in IE4 was now 
the desktop shell so it was now running all the time, including when the 
defrag was running, and when IE later wrote back the index to the 
absolute disk addresses that the file had been at before, it was 
overwriting other files that the defragger had moved into that spot in 
the mean time.

Eventually, MS fixed the problem by simply marking the cache files as 
system, read-only, so the defragger wouldn't touch them.

But in the mean time, a bunch of people running the affected IE4 pre-
releases lost data!

However, all I lost was a few unimportant temp files, because I had 
Internet Temporary Files located on my TEMP partition, and the only files 
on that partition besides IE's cache were other temporary files -- no big 
deal if they got overwritten with IE-cache-index!

And actually, I never even bothered reconfiguring defrag to avoid the 
problem, even after the problem was known and before it was fixed.  The 
only files possibly affected were temporary anyway.  No big deal.

But that reinforced what before that had been simply gut instinct into a 
hard-clad rule that I continue to observe to this day, of course on 
freedomware Linux now -- THOU SHALT KEEP THY FILE DATA TYPES SEPARATE!  
That means separate partitions if not separate physical drives, not some 
weird new-fangled subvolume thing where if the filesystem metadata gets 
screwed up it's a potential loss of everything on all the subvolumes 
despite the subvolume separation.

And it has saved some trouble at least once and I believe at least twice 
on Linux as well (tho unlike that first MS experience that left such an 
impression and created that hard-clad rule, I don't remember much about 
the details of these, as they just weren't that big a deal anyway, since 
my existing partitioning policy prevented them from becoming one)... and 
that's just the stuff I *KNOW* about!

So other than for the convenience of snapshots (which as the wiki says do 
NOT replace backups), I have no plans for btrfs subvolumes at all.  From 
my perspective, either it's the same general type of data and simply 
keeping it in ordinary directory trees is separation enough, or it NEEDS 
its own separate partition; there's no namby-pamby subvolume middle 
ground to be had.

(FWIW, I have similar philosophical issues with LVM, tho I realize 
there's a LOT of people using it by default, since that's what a lot of 
distros install by default, basically everything on LVM.)

> That said, I am using BTRFS on my main laptop even for /home now after
> having used it on several other machines for more than a year. Despite
> from that wierd scrub issue that I "fixed" by redoing the filesystem,
> rsync backup appeared t be okay, I am ready to trust my data to BTRFS.
> Also my backup harddisks are BTRFS.
> 
> I like BTRFS for some reasons, two that immediately come to my mind:
> 
> 1) It can prove to me that the data is intact. I find this rather
> valuable.

Indeed.

> 2) Due to snapshots I know have well snapshots for my backup. And even
> on SSD for my /home. I am not yet creating those in an automated way,
> but well I do use them.

As I already mentioned the warning on the wiki, do be aware of the 
limitations of snapshots.  They're NOT the same as separate backups.  I 
believe you know that already and just didn't mention it, but I'm worried 
about others who might come across your comment.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

