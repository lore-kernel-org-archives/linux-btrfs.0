Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44404 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaCIPrH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Mar 2014 11:47:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WMfwP-0008Hx-Ft
	for linux-btrfs@vger.kernel.org; Sun, 09 Mar 2014 16:47:05 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 16:47:05 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 16:47:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding btrfs and backups
Date: Sun, 9 Mar 2014 15:46:40 +0000 (UTC)
Message-ID: <pan$1e12f$ca5e5ff5$fd1a1ba8$e7032015@cox.net>
References: <loom.20140306T191655-366@post.gmane.org>
	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net> <2875521.9HaU3OuHLy@discus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wolfgang Mader posted on Fri, 07 Mar 2014 11:13:51 +0100 as excerpted:

> Duncan, thank you for this comprehensive post. Really helpful as always!
> 
> [...]
> 
>> As for restoring, since a snapshot is a copy of the filesystem as it
>> existed at that point, and the method btrfs exposes for accessing them
>> is to mount that specific snapshot, to restore an individual file from
>> a snapshot, you simply mount the snapshot you want somewhere and copy
>> the file as it existed in that snapshot over top of your current
>> version
> 
> Please, how do I list mounted snapshots only?
> 
> [...]

I personally don't use snapshots a whole lot (tho I like the concept) as 
they don't really fit my use-case.  So in general I won't try to answer 
usage-detail questions such as that.

That said, see the "Managing snapshots" section on the sysadmin guide 
page on the wiki, for some general snapshot management hints.

https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Managing_snapshots

The main point from there is to leave the top level of the filesystem 
empty but for the subvolumes/snapshots (see the tree diagrams) and to set 
a default subvolume that will be your normal subvolume-mount if you don't 
specify one.  Then you can mount the root subvolume (subvolid=0, see the 
fstab line for /media/btrfs) when you want to manage snapshots.

But the example there is full snapshot rollback.  To restore an 
individual file instead of that, you'd just mount the root subvolume and 
the snapshots would all appear as subdirs, such that you could browse 
them as you would a normal filesystem, diving into the snapshot and its 
subdirs until you find the file you want to restore, and then copying it 
over to the working copy/snapshot.

That doesn't directly answer how to list mounted snapshots only, but 
given the above tree layout, I don't really see that you'd /need/ to list 
mounted snapshots only, since presumably you'd have only the default 
mounted, plus the root subvolume, where you could browse into all the 
snapshots just as if they were normal directories.

Also see the subvolumes and snapshots section of the FAQ:

https://btrfs.wiki.kernel.org/index.php/FAQ#Subvolumes

>> Since a snapshot is an image of the filesystem as it was at that
>> particular point in time, and btrfs by nature copies blocks elsewhere
>> when they are modified, all (well, not "all" as there's metadata like
>> file owner, permissions and group, too, but that's handled the same
>> way) the snapshot does is map what blocks composed each file at the
>> time the snapshot was taken.
> 
> Is it correct, that e.g. ownership is recorded separately from the data
> itself, so if I would change the owner of all my files, the respective
> snapshot would only store the old owner information?

Yes.  If you change the owner of the files in your "current" subvolume, 
the previous snapshots will retain their old ownership.  Owner/
permissions/etc are metadata, stored separately from the actual data, 
with both data and metadata being snapshotted.


[ on btrfs send/receive ]
> 
> Is the receiving side a complete file system in its own right?

Normally, yes.

However, send normally serializes its output to STDOUT and that output 
can be sent to a specific file on some other filesystem (like ext4), or 
to tape or whatever, instead.  In this case you can read back from that 
file using cat (or netcat if it's over the network, or whatever), 
directing its output to btrfs receive, to turn that data back into a 
filesystem.  Used like this, you can think of the original send as a full 
backup (to tape or whatever), and child sends as incremental backups.  
Obviously, if stored in this form, in ordered to restore the incrementals 
you'd need the full backup they were based upon, just as you would if 
doing the same thing using conventional backup to tape or whatever.

> If so, I only need to maintain one common reference in order to apply
> the received snapshot, right. If I would in any way get the send and
> receive side out of sync, such that they do not share a common
> reference any more, only the send/receive would fail, but I still would
> have the complete filesystem on the receiving side, and could copy it
> all over (cp, rscync) to the send side in case of a disaster on the
> send side. Is this correct?

In the normal case (not stored as a file or serialized data stream as 
described above), yes.

Meanwhile, given that we're talking of btrfs send/receive in the context 
of backups, it's worth explicitly making note of the current on-list 
reports and bugfixes in area of send/receive.  In general, we're talking 
about an in-principle feature that should eventually be reliable enough 
to use as backup in the way discussed.  However, at present, if it's data 
you'd really miss were it to disappear, please back it up using another 
method (say rsync or conventional backups) as well.  To my knowledge, if 
the send and receive both occur without error, it should be a faithful 
copy of the data just as reliable as the original, but there are still 
corner-cases that are erroring out, and I'd definitely hate to actually 
need a current backup some bit after my send/receive started triggering 
errors due to some corner-case but before I had setup an alternative, 
such that I didn't have a current backup available!

IOW, yes, set it up and test it, but if we're talking about backups that 
you're actually going to be relying on right now, not something you're 
testing now in ordered to have the setup and experience for when you 
might rely on it say a year from now, I strongly recommend that you 
choose something with a bit more proven reliability than btrfs
send/receive at this point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

