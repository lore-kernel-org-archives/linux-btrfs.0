Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43669 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbbFQNvp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 09:51:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z5Dkf-00071k-IV
	for linux-btrfs@vger.kernel.org; Wed, 17 Jun 2015 15:51:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 15:51:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 15:51:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS: read error corrected: ino 1 off 226840576 (dev
 /dev/mapper/dshelf1 sector 459432)
Date: Wed, 17 Jun 2015 13:51:26 +0000 (UTC)
Message-ID: <pan$d7e40$f0fd83dc$6357f1e5$a552946e@cox.net>
References: <20150617071654.GI16468@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Wed, 17 Jun 2015 00:16:54 -0700 as excerpted:

> I had a few power offs due to a faulty power supply, and my mdadm raid5
> got into fail mode after 2 drives got kicked out since their sequence
> numbers didn't match due to the abrupt power offs.
> 
> I brought the swraid5 back up by force assembling it with 4 drives (one
> was really only a few sequence numbers behind), and it's doing a full
> parity rebuild on the 5th drive that was farther behind.
> 
> So I can understand how I may have had a few blocks that are in a bad
> state.
> I'm getting a few (not many) of those messages in syslog.
> BTRFS: read error corrected: ino 1 off 226840576 (dev
> /dev/mapper/dshelf1 sector 459432)
> 
> Filesystem looks like this:
> Label: 'btrfs_pool1'  uuid: 6358304a-2234-4243-b02d-4944c9af47d7
>         Total devices 1 FS bytes used 8.29TiB devid    1 size 14.55TiB
>         used 8.32TiB path /dev/mapper/dshelf1
> 
> gargamel:~# btrfs fi df /mnt/btrfs_pool1 Data, single: total=8.29TiB,
> used=8.28TiB System, DUP: total=8.00MiB, used=920.00KiB System, single:
> total=4.00MiB, used=0.00B Metadata, DUP: total=14.00GiB, used=10.58GiB
> Metadata, single: total=8.00MiB, used=0.00B GlobalReserve, single:
> total=512.00MiB, used=0.00B
> 
> Kernel 3.19.8.
> 
> Just to make sure I understand, do those messages in syslog mean that my
> metadata got corrupted a bit, but because I have 2 copies, btrfs can fix
> the bad copy by using the good one?

Yes.  Despite the confusion between btrfs raid5 and mdraid5, Hugo was 
correct there.  It's just the 3.19 kernel bit that he got wrong, since he 
was thinking btrfs raid.  Btrfs dup mode should be good going back many 
kernels.

> Also, if my actual data got corrupted, am I correct that btrfs will
> detect the checksum failure and give me a different error message of a
> read error that cannot be corrected?
> 
> I'll do a scrub later, for now I have to wait 20 hours for the raid
> rebuild first.

Yes again.

As I mentioned in a different thread a few hours ago, I have an SSD that 
is slowly going bad, relocating sectors, etc (200-some relocated at this 
point, by raw value, that attribute dropped to 100 "cooked" value on the 
first relocation and is now at 98, with a threshold of 36, so I figure it 
should be good for a few thousand relocations if I let it go that far).  
But it's in a btrfs raid1 with a reliable (no relocations yet) paired-ssd 
and I've been able to scrub-fix the errors so far, plus I have things 
backed up and a replacement ready to insert when I decide it's time, so 
I'm able to watch in more or less morbid fascination as the thing slowly 
dies, a sector at a time.  

The interesting thing is that with btrfs' checksumming and data integrity 
feature, I can continue to use the drive in raid1 even tho it's 
definitely bad enough to be all but unusable with ordinary filesystems.

Anyway, as a result of that, I'm getting lots of experience with scrubs 
and corrected errors.

One thing I'd strongly recommend.  Once the rebuild is complete and you 
do the scrub, there may well be both read/corrected errors, and 
unverified errors.  AFAIK, the unverified errors are a result of bad 
metadata blocks, so missing checksums for what they covered.  So once you 
finish the first scrub and have corrected most of the metadata block 
errors, do another scrub.  The idea is to repeat until you have no more 
unverified errors, they're either all corrected (if dup metadata) or all 
uncorrectable (the single data).  That's what I'm doing here, with both 
data and metadata as raid1 and thus correctable, tho in some instances 
the device is triggering a new relocation on the second and occasionally 
(once?) third scrub, so that's causing me to have to do more scrubs than 
I would if the problem were entirely in the past, as it sounds like yours 
is, or will-be once the mdraid rebuild is done, anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

