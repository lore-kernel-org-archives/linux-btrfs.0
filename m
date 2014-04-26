Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60884 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaDZEBs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 00:01:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wdto7-0006Jr-QZ
	for linux-btrfs@vger.kernel.org; Sat, 26 Apr 2014 06:01:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 06:01:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Apr 2014 06:01:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: safe/necessary to balance system chunks?
Date: Sat, 26 Apr 2014 04:01:32 +0000 (UTC)
Message-ID: <pan$dd651$bbf57e6c$5d375e9c$5e894ab7@cox.net>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
	<75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
	<535AA581.1080301@gmail.com> <535AACC0.2000600@shaw.ca>
	<535AB27C.6070205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Fri, 25 Apr 2014 15:07:40 -0400 as
excerpted:

> I actually have a similar situation with how I have my desktop system
> set up, when I go about recreating the filesystem (which I do every
> time I upgrade either the tools or the kernel),

Wow.  Given that I run a git kernel and btrfs-tools, I'd be spending a 
*LOT* of time on redoing my filesystems if I did that!  Tho see my just-
previous reply for what I do (a fresh mkfs.btrfs every few kernel cycles, 
to take advantage of new on-device-format feature options and to clean 
out any possibly remaining cruft from bugs now fixed, given that btrfs 
isn't fully stable yet).

Anyway, why I'm replying here:

[in the context of btrfs raid1 mode]

> I use the following approach:
> 
> 1. Delete one of the devices from the filesystem
> 2. Create a new btrfs file system on the device just removed from the
> filesystem
> 3. Copy the data from the old filesystem to the new one
> 4. one at a time, delete the remaining devices from the old filesystem
> and add them to the new one, re-balancing the new filesystem after
> adding each device.
> 
> This seems to work relatively well for me, and prevents the possibility
> that there is ever just one copy of the data.  It does, however, require
> that the amount of data that you are storing on the filesystem is less
> than the size of one of the devices (although you can kind of work
> around this limitation by setting compress-force=zlib on the new file
> system when you mount it, then using defrag to decompress everything
> after the conversion is done), and that you have to drop to single user
> mode for the conversion (unless it's something that isn't needed all the
> time, like the home directories or /usr/src, in which case you just log
> everyone out and log in as root on the console to do it).


I believe you're laboring under an unfortunate but understandable 
misconception of the nature of btrfs raid1.  Since in the event of device-
loss it's a critical misconception, I decided to deal with it in a reply 
separate from the other one (which I then made as a sibling post to yours 
in reply to the same parent, instead of as a reply to you).

Unlike for instance mdraid raid1 mode, which is N mirror-copies of the 
data across N devices (so 3 devices = 3 copies, 5 devices = 5 copies, 
etc)...

**BTRFS RAID1 MODE IS CURRENTLY PAIR-MIRROR ONLY!**

No matter the number of devices in the btrfs so-called "raid1", btrfs 
only pair-mirrors each chunk, so it's only two copies of the data per 
filesystem.  To have more than two-copy redundancy, you must use multiple 
filesystems and make one a copy of the other using either conventional 
backup methods or the btrfs-specific send/receive.

This is actually my biggest annoyance/feature-request with current btrfs, 
as my own sweet-spot ideal is triplet-mirroring, and N-way-mirroring is 
indeed on the roadmap and has been for years, but the devs plan to use 
some of the code from btrfs raid5/6 to implement it, and of course while 
incomplete raid5/6 mode was introduced in 3.9, as of 3.14 at least, 
that's exactly what raid5/6 mode is, incomplete, and while I saw patches 
to properly support raid5/6 scrub recently, I believe it's still 
incomplete in 3.15 as well.  And of course N-way-mirroring remains 
roadmapped for after that... So not being a dev, I continue to wait, as 
patiently as I can manage since I'd rather a good implementation later 
than a buggy one now, for that still coming N-way-mirroring.  Tho at this 
point I admit to having some sympathy for the donkey forever following 
that apple held on the end of a stick just out of reach... even if I 
/would/ rather wait another five years for it and have it done /right/, 
than be dealing with a bad implementation available right now.

Anyway, given that we /are/ dealing with pair-mirror-only raid1 mode 
currently... as well as your pre-condition that for your method to work, 
the data to store on the filesystem must fit on a single device...

If you have a 3-device-plus btrfs raid1 and you're using btrfs device 
delete to remove the device you're going to create the new filesystem on, 
you do still have two-way-redundancy at all times, since the the btrfs 
device delete will ensure the two copies are on the remaining devices, 
but that's unnecessary work compared to simply leaving it a device down 
in the first place, and starting with the last device of the previous 
(grandparent generation) filesystem as the first of a new (child 
generation) filesystem, leaving it unused between.

If OTOH you're hard-removing a device from the raid1, without a btrfs 
device delete first, then at the moment you do so, you only have a single 
copy of any chunk where one of the pair was on that device, and it 
remains that way until you do the mkfs and finish populating the new 
filesystem with the contents of the old one.

So you're either doing extra work (if you're using btrfs device delete), 
or leaving yourself with a single copy of anything on the removed device, 
until it is back up and running as the new filesystem! =:^(

I'd suggest not bothering with more than two (or possibly three) devices 
per filesystem, since by btrfs raid1, you only get pair-mirroring, so 
more devices is a waste for that, and by your own pre-condition, you 
limit the amount of data to the capacity of one device, so you can't take 
advantage of the extra storage capacity of more devices with >2 devices 
on a two-way-mirroring-limited raid1 either, making it a waste for that 
as well.  Save the extra devices for when you do the transfer.

If you have only three devices, setup the btrfs raid1 with two, and leave 
the third as a spare.  Then for the transfer, create and populate the new 
filesystem on the third, remove a device from the btrfs raid1 pair, add 
it to the new btrfs and convert to raid1.  At that point you can drop the 
old filesystem and leave its remaining device as your first device when 
you repeat the process later, making the last device of the grandparent 
into the first device of the child.

This way you'll have two copies of the data at all times and/or will save 
the work of the third device add and rebalance, and later the device 
delete, bringing it to two devices again.

And as a bonus, except for the time you're actually doing the mkfs and 
repopulating the new filesystem, you'll have a third copy, albeit a bit 
outdated, as a backup, that being the spare that you're not including in 
the current filesystem, since it still has a complete copy of the old 
filesystem from before it was removed, and that old copy can still be 
mounted using the degraded option (since it's the single device remaining 
of what was previously a multi-device raid1).

Alternatively, do the three-device raid1 thing and btrfs device delete 
when you're taking a device out and btrfs balance after adding the third 
device.  This will be more hassle, but dropping a device from a two-
device raid1 forces it read-only as writes can no longer be made in raid1 
mode, while a three-device raid1 doesn't give you more redundancy since 
btrfs raid1 remains pair-mirror-only, but DOES give you the ability to 
continue writing in raid1 mode with a missing device, since you still 
have two devices and can do raid1 pair-mirror writing.

So in view of the pair-mirror restriction, three devices won't give you 
additional redundancy, but it WILL give you a continued writable raid1 if 
a device drops out.  Whether that's worth the hassle of the additional 
steps needed to btrfs device delete to create the new filesystem and 
btrfs balance on adding the third device, is up to you, but it does give 
you that choice. =:^)

Similarly if you have four devices, only in that case you can actually do 
two independent two-device btrfs raid1 filesystems, one working and one 
backup, taking the backup down to recreate as the new primary/working 
filesystem when necessary, thus avoiding the whole device-add and 
rebalance thing entirely.  And your backup is then a full pair-redundant 
backup as well, tho of course you lose the backup for the period you're 
doing the mkfs and repopulating the new version.

This is actually pretty much what I'm doing here, except that my physical 
devices are more than twice the size of my data and I only have two 
physical devices.  But I use partitioning and create the dual-device 
btrfs raid1 pair-mirror across two partitions, one on each physical 
device, with the backup set being two different partitions, one each on 
the same pair of physical devices.

If you have five devices, I'd recommend doing about the same thing, only 
with the fifth device as a normally physically disconnected (and possibly 
stored separately, perhaps even off-site) backup of the two separate 
btrfs pair-mirror raid1s.  Actually, you can remove a device from one of 
the raid1s (presumably the backup/secondary) to create the new btrfs 
raid1, still leaving the one (presumably the working/primary) as a 
complete two-device raid1 pair, leaving the other device as a backup that 
can still be mounted using degraded, should that be necessary.

Or simply use the fifth device for something else. =:^)

With six devices you have a multi-way choice:

1) Btrfs raid1 pairs as with four devices but with two levels of backup.

This would be the same as the 5-device scenario, but completing the pair 
for the secondary backup.

2) Btrfs raid1 pairs with an addition device in primary and backup.

2a) This gives you a bit more flexibility in terms of size, since you now 
get 1.5 times the capacity of a single device, for both primary/working 
and secondary/backup.

2b) You also get the device-dropped write-flexibility described under the 
three-device case, but now for both primary and backup. =:^)

3) Six-device raid10.  In "simple" configuration, this would give you 3-
way-striping and 3X capacity of a single device, still pair mirroring, 
but you'd lose the independent backups.  However, if you used 
partitioning to split each physical device in half and made each set of 
six partitions an independent btrfs raid10, you'd still have half the 3X 
capacity, so 1.5X the capacity of a single device, still have the three-
way-striping and 2-way-mirroring for 3X the speed with pair-mirroring 
redundancy, *AND* have independent primary and backup sets, each its own 
6-way set of partitions across the 6 devices, giving you simple tear-down 
and recreate of the backup raid10 as the new working raid10.

That would be a very nice setup; something I'd like for myself. =:^)

Actually, once N-way-mirroring hits I'm going to want to setup pretty 
close to just this, except using triplet mirroring and two-way-striping 
instead of the reverse.  Keeping the two-way-partitioning as well, that'd 
give me 2X speed and 3X redundancy, at 1X capacity, with a primary and 
backup raid10 on different 6-way partition sets of the same six physical 
devices.

Ideally, the selectable-way mirroring/striping code will be flexible 
enough by that time to let me temporarily reduce striping (and speed/
capacity) to 1-way while keeping 3-way-mirroring, should I lose a device 
or two, thus avoiding the force-to-read-only that dropping below two-
devices in a raid1 or four devices in a raid10 currently does.  Upon 
replacing the bad devices, I could rebalance the 1-way-striped bits and 
get full 2-way-striping once again, while the triplet mirroring would 
have never been compromised.

That's my ideal. =:^)

But to do that I still need triplet-mirroring, and triplet-mirroring 
isn't available yet. =:^(

But it'll sure be nice when I CAN do it! =:^)

4) Do something else with the last pair of devices. =:^)


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

