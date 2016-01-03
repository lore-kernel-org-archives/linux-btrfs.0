Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55307 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbcACPyG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Jan 2016 10:54:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aFkyn-0004ke-3u
	for linux-btrfs@vger.kernel.org; Sun, 03 Jan 2016 16:54:01 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 16:54:01 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 16:54:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unrecoverable fs corruption?
Date: Sun, 3 Jan 2016 15:53:56 +0000 (UTC)
Message-ID: <pan$11cfd$9e78008a$67e09cd4$7017ff54@cox.net>
References: <pan$775e4$fad1d9d7$a69e525a$ff4dac1a@cox.net>
	<20160102115318.4e76f773@hydra>
	<CAPmG0jb1HF6Mnfi3ObqUfPHs4RNLCDvsnuncvX-=LGZazDHnYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Sat, 02 Jan 2016 22:19:18 +0100 as excerpted:


> If you think btrfs raid (I/O)fault handling etc is not good enough yet,
> instead of raid1, you might consider 2x single (dup for metadata), with
> 1 the main/master fs and the other one the slave fs, created by send |
> receive (incremental). If you scrub both on regular basis, email or so
> the error cases, you can act if something is wrong.
> And every now and then do a brute-force diff to verify that contents of
> both filesystems (snapshots) are still the same.

Given the OP's situation, that he was running btrfs in raid1 mode, and 
that a third device of similar capacity is simply out of the question due 
to cost at this point, this approach, possibly generalized, is what I'd 
recommend as well.

RAID-1 is not a backup.  And I'd strongly recommend a backup take 
priority over a raid1 if there's simply not enough money for more 
devices.  There's simply too many ways a raid1 can go wrong when there's 
no actual backup, including fat-fingering a deletion[1].

Now if the device capacity is sufficiently large, I'd actually recommend 
partitioning both devices up with two identically sized partitions on 
each.  Then the first partition on each can be made into a raid1 forming 
the working copy, while the second partition on each can be a separate 
raid1 that's the backup.  That way, there's both a backup and raid1 
protection.  That's actually what I'm doing here, pretty much.[2]

Of course, the partitioned raid1 working and backup solution does require 
that the data actually fit in half the space of a single device, and it 
may not, in which case this isn't an option.

Which would bring us back to a working copy on one device and its backup 
on the other.

But I'd actually consider making either the backup not btrfs.  What I use 
here for my second backups is the old reiserfs I was using before btrfs.  
That way, if it's a btrfs bug that takes out the one copy, you don't have 
to worry about the same btrfs bug taking out the backup when you try to 
fall back to it.  It may not be particularly likely, and it does kill the 
chance of using btrfs send/receive to update the backup, but it 
significantly eases my mind when I'm in recovery mode, knowing my backup 
isn't subject to whatever btrfs bug I had that put me in recovery mode in 
the first place.  

(In the partitioned raid case, I'd consider making the backup mdraid1, 
with whatever filesystem on top, since other than btrfs and zfs, 
filesystems basically don't do raid so it must be implemented below 
them.  Or don't raid the backup and simply make a primary backup on one 
device and a secondary backup on the other.)

---
[1] Fat-fingering a deletion:  My own brown-bag "I became an admin that 
day" case was running a script, unfortunately as root, that I was 
debugging, where I did an rm -rf $somevar/*, with $somevar assigned 
earlier, only either the somevar in the assignment or the somevar in the 
rm line was typoed, so the var ended up empty and the command ended up as 
rm -rf /*. ...

I was *SO* glad I had a backup, not just a raid1, that day!

Needless to say, I also learned the lesson, the hard way, that either you 
don't debug your scripts as root, or if you are going to do so, you 
comment out rm lines and replace them with ls, the first time thru!  Or 
do a confirm-prompt with the command line printed, first, and then copy/
paste the confirmation version to the operational line, so there's no 
chance of typoing something different than the confirmed version.

[2] Dual raid1 working and backup copies on a pair of partitioned 
devices:  My setup is actually rather somewhat more complex than that, 
but the details are not apropos to this discussion.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

