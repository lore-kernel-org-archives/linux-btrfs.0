Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48436 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab3GVKjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 06:39:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V1DWo-0000nS-7u
	for linux-btrfs@vger.kernel.org; Mon, 22 Jul 2013 12:39:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 12:39:42 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 12:39:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: abysmal rm performance?
Date: Mon, 22 Jul 2013 10:39:25 +0000 (UTC)
Message-ID: <pan$e8fb1$a4cde2ce$20a617b6$10f5d98a@cox.net>
References: <827cf884b1a6e12db95beea6912d946b@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Mon, 22 Jul 2013 12:22:11 +0700 as excerpted:

>> You /really/ need to read up on the btrfs wiki.
>> 
>> The short answer is yes, btrfs does a LOT more metadata processing due
>> to the checksumming it does by default.
> 
> According to the wiki, checksumming has barely any influence, so I guess
> the above advice is not really helpful?
> 
> https://btrfs.wiki.kernel.org/index.php/Mount_options
> 
> 	nodatasum (...)
> 	On most modern CPUs this option does not result in any reasonable
> 	performance improvement.

It's worth noting that in the context of the full description, that's 
referencing data write performance as that's where the checksumming would 
be done and the CPU performance would matter, not really delete 
performance, where the bottleneck is likely to be the storage device seek 
times.

However, being a user not a btrfs dev, and not having actually tested it, 
what I do NOT know is whether that option disables just the calculation, 
so the same seeks would be done and the same "unmetadata" (given the file 
was written with nodatasum) would be erased in any case, or if it short 
circuits the entire process.

It might be worth some benchmarks to see...

> btrfs:
> 
> Data, RAID1: total=1.73TB, used=1.36TB System, RAID1: total=32.00MB,
> used=264.00KB System: total=4.00MB, used=0.00 Metadata, RAID1:
> total=79.00GB, used=70.23GB
> 
> 
> Quite high metadata usage here.

Yes.  It's worth noting, however, that btrfs does store small files 
directly in the inode metadata itself, rather than in separate data 
extents.  So that can be considered too and may be part of it.

> The filesystems on ext4 and btrfs are copies; there are >30 milion
> inodes on ext4; most of the files have multiple hardlinks.

Hardlinks:  Until recently btrfs has problems if there were too many 
hardlinks in a directory.  They fixed that, but if you're doing a LOT of 
hardlinking, it may well be that is playing some part, as I don't know 
how performant the new code is.  It may be worth reading the list 
archives on that topic.

> So paraphrasing my question: is there anything to improve "rm"
> performance with btrfs?
> 
> "nodatacow" might help a bit, but then, it disabled the compression,
> which is a major drawback.

I have a strong suspicion nobarrier may help quite a bit with high-number 
delete loads, tho of course it DOES come with data corruption risks in 
the event of a power failure.

It's also likely that as the actual number of bugs go down as they are 
beginning to now, and the devs focus more on performance tuning, that 
this will get better.

Other than that, and of course the hardware/ssd option (I'm using btrfs 
in btrfs raid1 mode on a pair of ssds here and the zero-seek-time DOES 
make a difference, but I'm not doing terabytes of data either; that's 
still on reiserfs on spinning rust, here), it may simply be that btrfs 
isn't a filesystem choice well matched to your needs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

