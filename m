Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55330 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbbHGK0r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Aug 2015 06:26:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZNerL-00075v-9w
	for linux-btrfs@vger.kernel.org; Fri, 07 Aug 2015 12:26:43 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 12:26:43 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 12:26:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid1 metadata, single data
Date: Fri, 7 Aug 2015 10:26:37 +0000 (UTC)
Message-ID: <pan$610e$21180714$e5abeff4$d02dfebb@cox.net>
References: <55C47136.2080402@render-wahnsinn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert Krig posted on Fri, 07 Aug 2015 10:49:58 +0200 as excerpted:

> Hi, I was wondering.
> 
> What exactly is contained in btrfs metadata?
> 
> I've read about some users setting up their btrfs volumes as
> data=single, but metadata=raid1
> 
> Is there any actual benefit to that? I mean, if you keep your data as
> single, but have multiple copies of metadata, does that still allow you
> to recover from data corruption? Or is metadata redundancy a benefit to
> ensure that your btrfs volume remains mountable/readable?

The latter.

Metadata includes information /about/ the files, the names and file 
permissions, what extents the data is actually saved in on the device(s), 
etc.  In btrfs, really small files (under a few KiB, depending on the 
size of your metadata nodes, which are typically 16 KiB) are normally 
stored directly in metadata, instead of mapping to a data extent, as 
well.  Critically, the checksum data for btrfs' file integrity features 
are stored in metadata as well.

Because the metadata for a file is typically much smaller than a file, 
and also much smaller than the default 16 KiB metadata node size, the 
metadata for many files is stored in a single metadata node.  As such, 
damage to a metadata node risks making many files irretrievable.

Additionally, that extent mapping is critical.  If it points to the wrong 
place, a file may contain chunks of other files, perhaps not owned by the 
same user/group so potentially a security/privacy leak as well as file 
corruption.

Of course btrfs metadata is itself checksummed so damage to it should be 
detected, and when there's another copy of that metadata, btrfs will 
verify it and if it's good, use it instead.

And of course, on btrfs, various btrfs specific features such as 
snapshotting (which basically locks in place a reference to the current 
file extents, so any changes, written elsewhere due to COW, will change 
that version, but not the snapshotted version, so now there's two 
mappings of the file in the metadata, one for the snapshot, another for 
the changed, current version), etc, depend on good metadata as well.

All that is why metadata is so critical, so much so that on single-device 
btrfs, the default is dup for metadata, still two copies of it, instead 
of just one, the default for data.  If one metadata node copy is bad 
(fails checksum validation or can't be read at all), by default, there's 
a second copy to read from, even on a single-device filesystem.  (Do 
note, however, that this doesn't apply to ssd, where for various reasons 
having to do with how SSD FTLs work, the metadata default for single-
device is single, not dup.)

On a multi-device filesystem, the metadata default changes to raid1, 
ensuring that the two copies are kept on different devices.  (Note that 
currently, there's never more than two copies, no matter how many devices 
there are in the filesystem.)  That does help ensure metadata integrity 
even if a device is lost, which should indeed help recover any still 
single-mode files that weren't partly on that device, but that's not the 
real reason it's the metadata default, since for various reasons it's 
still reasonably likely part of any particular file will be on the failed 
device, if the data default single-mode is used.  The real reason it's 
the metadata default is the same reason the metadata default on a single-
device btrfs is dup, so there's always two copies.  And with at least two 
devices available, it simply makes sense to ensure the two copies are on 
different devices, even if the benefit is only incremental over allowing 
the two copies to be on whatever device, even the same one for both.

But if one can afford double the dataspace usage, raid1 (or raid10 for 4+ 
devices, raid5 and 6 are still immature) for both data and metadata is 
quite appealing on btrfs, particularly with the checksumming and data 
integrity features, since having both data and metadata raid1 means data 
or metadata, there's always a second copy to fall back on, should the one 
copy fail checksum verification.  That's actually what I use here, and 
it's one of the big reasons I'm using btrfs in the first place, since few 
other solutions provide that level of both redundancy and verified 
integrity.  mdraid1, for instance, allows multiple copies, but doesn't 
checksum or verify the validity.  mdraid5 and mdraid6 have parity 
checking and could in theory verify in normal operation as well as repair 
after replacement of a lost device, but they don't -- parity is only 
checked on rebuild after replacement of a lost device, not in normal 
operation.

FWIW what I'd LIKE to use in btrfs, but while it's on the roadmap and 
scheduled as the next raid feature for implementation after raid5/6, 
which is now complete but still immature, is N-way-mirroring, so I could 
have for instance three copies of the data and metadata, instead of just 
two.  Three copies is really my sweet spot, tho with N-way-mirroring four 
or more would be possible, as every time a btrfs scrub corrects a bad 
copy of something by overwriting it with the good copy, I worry about 
what would happen if that only remaining good copy had gone bad at the 
same time as well.  The chances of three bad copies at the same time vs 
two bad copies, is enough better that I find it worth it, while the 
incremental risk level improvement of adding a forth copy, vs the 
management time and cost of that forth copy, isn't worth it to me.  So 
I've been waiting for that n-way-mirroring implementation to get my three 
copies, tho even when it's implemented, it'll take awhile to stabilize 
(I've been recommending a year of stabilization for raid56, and that 
people continue with raid1 or raid10 in the mean time), so I have not 
only to wait for the feature to be introduced, but then I have to either 
wait even longer for stabilization, or expect to be the guinea pig 
finding and reporting bugs in the implementation the first few kernel 
cycles.

HTH explain things! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

