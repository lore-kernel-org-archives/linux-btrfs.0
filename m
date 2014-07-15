Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55009 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbaGOCpi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jul 2014 22:45:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X6skL-0000U2-C1
	for linux-btrfs@vger.kernel.org; Tue, 15 Jul 2014 04:45:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 04:45:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 04:45:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS hang with 3.16-rc5
Date: Tue, 15 Jul 2014 02:45:22 +0000 (UTC)
Message-ID: <pan$6de62$702a648$a15ab320$d959ae3d@cox.net>
References: <1502954.OtX3SzjMKZ@merkaba> <3226395.MP6iD3ZiSL@merkaba>
	<pan$10815$10a07b04$fff89252$8ecbdf83@cox.net>
	<2200430.lB6XKANyxs@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Tue, 15 Jul 2014 00:03:21 +0200 as excerpted:

> Am Montag, 14. Juli 2014, 17:51:37 schrieben Sie:
>> Martin Steigerwald posted on Mon, 14 Jul 2014 17:10:30 +0200 as
>> excerpted:
>> > Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
>> >> 
>> >> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several
>> >> days of usage, with 3-16-rc5 I had a hang again. Less than a hour
>> >> since booting it.
>> > 
>> > Probably good to add some basic information on the filesystem: [...]
>> > 
>> > I think I switched it to skinny extents, but I am not completely
>> > sure.

BTW, when I mount a btrfs with skinny extents, the kernel log says so.  I 
don't know if it has done that since skinny extents were introduced, but 
it certainly is now, and I think it did with 3.15 as well.

So if you look at dmesg after mount, it should say so if you have skinny 
extents.  Otherwise you don't (unless there's some sort of bug).

>> > Dual SSD BTRFS RAID 1
>> > 
>> > No snapshots at the moment. And plenty of space free.
>> 
>> FWIW, I've been updating every few days, running two different
>> snapshots between 3.16-rc4 and rc5, and now rc5 itself, and haven't
>> noticed this issue.  Dual SSDs btrfs raid1, but partitioned up so the
>> biggest partition is under 50 GB.
>> 
>> I've been doing some very heavy (gentoo) package building and shuffling
>> around the last few days trying out the kde-frameworks/workspaces-5
>> stuff, then deciding it's not yet ready for me, too, so I've been
>> working it a bit, too. I did have some nasty trouble a few weeks ago,
>> which triggered a btrfs restore and then a mkfs on a couple of the
>> filesystems.  But nothing at all strange with btrfs since then, or
>> really, for awhile before that either.
> 
> Do you have compression enabled?
> 
> I have:
> 
> /dev/mapper/msata-home /home btrfs
> rw,noatime,compress=lzo,ssd,space_cache 0 0

Yes.

But I am *NOT* doing anything with device-mapper.  I don't have it turned 
on in my kernel, either.

Also, I do run autodefrag too, so nothing should get seriously 
fragmented.  (Fragmentation isn't the big deal on SSD that it is on 
spinning rust, but I still don't want it, and I don't have any of the gig-
sized internal-write-pattern files to worry about on the SSDs, so...)

No snapshots for either of us, and I don't run quotas either.  I'm 
running skinny-metadata, 16-KiB nodes, extref (64 Ki hardlinks, default), 
and no-holes, features.  I do fresh mkfs-and-restores every few months to 
get the latest features and minimize the chance of any lingering effects 
from now-fixed bugs.

I don't particularly trust devmapper, particularly with something not 
entirely stable such as btrfs on top, so naturally that's what I'd 
suspect.  The relatively small filesystems might help, too, and I believe 
lack of quotas and snapshotting lowers the stress on the filesystem too, 
as does the fact that I don't have any of those big internal-write-
pattern files to worry about.  The combination of all of them may have a 
lot to do with my relative lack of problems compared to some of the other 
regulars.  The couple bad umounts and subsequent refusal to mounts 
necessitating a btrfs restore of two filesystems some weeks ago was the 
first actual experience with troubleshooting I had with btrfs; well, 
since I took it off the bad caps-mobo about 2.5 years ago and didn't try 
btrfs again until the SSDs I guess a year and a half ago, anyway.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

