Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45896 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbbHOGan (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 02:30:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZQUzI-0005KC-KO
	for linux-btrfs@vger.kernel.org; Sat, 15 Aug 2015 08:30:40 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 08:30:40 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 08:30:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: The performance is not as expected when used several disks on
 raid0.
Date: Sat, 15 Aug 2015 06:30:32 +0000 (UTC)
Message-ID: <pan$82931$bcf5ef1b$88d8d18$c8aa5770@cox.net>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
	<CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
	<55CE4682.3080106@gmail.com>
	<CAJCQCtTTgiuNA7+bqd31CG1OHeDiZ=TwQEnVbUF2jNU7qBRRnA@mail.gmail.com>
	<55CE4866.6060207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Fri, 14 Aug 2015 15:58:30 -0400 as
excerpted:

> FWIW, running BTRFS on top of MDRAID actually works very well,
> especially for BTRFS raid1 on top of MD-RAID0 (I get an almost 50%
> performance increase for this usage over BTRFS raid10, although most of
> this is probably due to how btrfs dispatches I/O's to disks in
> multi-disk stetups).

Of course that's effectively a raid01, which is normally supposed to most 
often be a mistakenly reversed raid10 implementation, mistakenly, due to 
the IO cost of the rebuild should a device fail, since the whole raid0 of 
the one raid1 side would have to be rereplicated to the other, vs only 
having to rereplicate one device to the other locally, in a raid10 
arrangement.

However, in this case it's a very smart arrangement, actually, the only 
md-raid-under-btrfs-raid arrangement that makes real sense (well, other 
than raid00, raid0 at both levels, perhaps), in particular because the 
btrfs raid1 on top still gives you the full benefit of btrfs file 
integrity features as well as the usual raid1 redundancy, tho in this 
case it's only at the one raid0 against the other as the pair of btrfs 
raid1 copies.  And the mdraid0 is much better optimized than btrfs raid0, 
so there's that bonus, while at the same time the btrfs raid1 redundancy 
nicely balances the usual "Russian Roulette" quality of raid0.

Very nice configuration! =:^)

Thanks for mentioning it, as I guess I was effectively ruling it out as 
an option before even really considering it due to the usual raid10's 
better than raid01 thing, and thus was entirely blind to the 
possibility.  Which was bad, because as I alluded to, mdraid's lack of 
file integrity features and thus lack of any way to have btrfs scrub 
properly filter down to the mdraid level when there's mdraid level 
redundancy, kind of makes a mess of things, otherwise.  But btrfs raid1 
on mdraid0 effectively balances and eliminates the negatives at each 
level with the strengths of the other level, and is really a quite 
awesome solution, that until now I was entirely blinded to! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

