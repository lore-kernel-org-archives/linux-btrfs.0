Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36329 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbbH1JsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 05:48:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZVGGE-0007Yu-GD
	for linux-btrfs@vger.kernel.org; Fri, 28 Aug 2015 11:47:50 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 11:47:50 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 11:47:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding BTRFS storage
Date: Fri, 28 Aug 2015 09:47:44 +0000 (UTC)
Message-ID: <pan$9606c$9f08381a$d5df543d$2943921@cox.net>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
	<20150826165024.05af044f@natsu> <55DDAB1C.90406@gmail.com>
	<pan$7fd63$2b2fd6ee$53e6fc05$7a0aab72@cox.net>
	<55DEFC36.5000608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 27 Aug 2015 08:01:58 -0400 as
excerpted:

>> Someone (IIRC it was Austin H) posted what I thought was an extremely
>> good setup, a few weeks ago.  Create two (or more) mdraid0s, and put
>> btrfs raid1 (or raid5/6 when it's a bit more mature, I've been
>> recommending waiting until 4.4 and see what the on-list reports for it
>> look like then) on top.  The btrfs raid on top lets you use btrfs' data
>> integrity features, while the mdraid0s beneath help counteract the fact
>> that btrfs isn't well optimized for speed yet, the way mdraid has been.
>> And the btrfs raid on top means all is not lost with a device going bad
>> in the mdraid0, as would normally be the case, since the other
>> raid0(s),
>> functioning as the remaining btrfs devices, let you rebuild the missing
>> btrfs device, by recreating the missing raid0.
>>
>> Normally, that sort of raid01 is discouraged in favor of raid10, with
>> raid1 at the lower level and raid0 on top, for more efficient rebuilds,
>> but btrfs' data integrity features change that story entirely. =:^)
>>
> Two additional things:
> 1. If you use MD RAID1 instead of RAID0, it's just as fast for reads, no
> slower than on top of single disks for writes, and get's you better data
> safety guarantees than even raid6 (if you do 2 MD RAID 1 devices with
> BTRFS raid1 on top, you can lose all but one disk and still have all
> your data).

My hesitation for btrfs raid1 on top of mdraid1, is that a btrfs scrub 
doesn't scrub all the mdraid component devices.

Of course if btrfs scrub finds an error, it will try to rewrite the bad 
copy from the (hopefully good) other btrfs raid1 copy, and that will 
trigger a rewrite of both/all copies on that underlying mdraid1, which 
should catch the bad one in the process no matter which one it was.

But if one of the lower level mdraid1 component devices is bad while the 
other(s) are good, and mdraid happens to pick the good device, it won't 
even see and thus can't scrub the bad lower-level copy.

To avoid that problem, one can of course do an mdraid level scrub 
followed by a btrfs scrub.  The mdraid level scrub won't tell bad from 
good but will simply ensure they match, and if it happens to pick the bad 
one at that level, the followon btrfs level scrub will detect that and 
trigger a rewrite from its other copy, which again, will rewrite both/all 
the underlying mdraid1 component devices on that btrfs raid1 side, but 
that still wouldn't ensure that the rewrite actually happened properly, 
so then you're left redoing both levels yet again, to ensure that.

Which in theory can work, but in practice, particularly on spinning rust, 
you pretty quickly reach a point when you're running 24/7 scrubs, which, 
again particularly on spinning rust, is going to kill throughput for 
pretty much any other IO going on at the same time.


Which is one of the reasons I found btrfs raid1 on mdraid0 so appealing 
in comparison -- raid0 has only the single copy, which is either correct 
or incorrect, and if the btrfs scrub turns up a problem, it does the 
rewrite, and a single second pass of that btrfs scrub can verify that the 
rewrite happened correctly, because there's no hidden copies being picked 
more or less randomly at the mdraid level, only the single copy, which is 
either correct or incorrect.  I like that determinism! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

