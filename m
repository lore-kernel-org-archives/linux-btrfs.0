Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42952 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbbK1GJF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 01:09:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a2Ygt-00058E-Gu
	for linux-btrfs@vger.kernel.org; Sat, 28 Nov 2015 07:08:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 07:08:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 07:08:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: implications of mixed mode
Date: Sat, 28 Nov 2015 06:08:54 +0000 (UTC)
Message-ID: <pan$c4f12$68229b85$998fe036$ec46a899@cox.net>
References: <56579BD1.4030401@lukas-pirl.de>
	<pan$d7271$6dfb6246$70339bd2$f62a4d8@cox.net>
	<565830AD.3000805@lukas-pirl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lukas Pirl posted on Fri, 27 Nov 2015 23:30:05 +1300 as excerpted:

> On 11/27/2015 04:11 PM, Duncan wrote as excerpted:
>> My big hesitancy would be over that fact that very few will run or test
>> mixed-mode at TB scale filesystem level [s]o you're relatively more
>> likely to run into rarely seen scaling issues and perhaps bugs

>> It's worth noting that rsync... seems to stress btrfs more than pretty
>> much any other common single application.  It's extremely heavy access
>> pattern just seems to trigger bugs that nothing else does, and while
>> they do tend to get fixed, it really does seem to push btrfs to the
>> limits, and there have been a /lot/ of rsync triggered btrfs bugs
>> reported over the years.
> 
> Well, IMHO btrfs /has/ to deal with rsync workloads if it wants to be an
> alternative for larger storages but that is another story.

Yes; that's why they get fixed. =:^)  I'm simply saying it's a strong 
stressor, and on top of running the less tested setup that TB-scale mixed-
mode is, you're looking at an ideal test case for generating bugs.  If 
that's your intent...

But it seems not...

> I do run btrfs (non-mixed) with rsync workloads for quite a while now
> and it is doing well (except for the deadlock that has been around a
> while ago). Maybe my network is just slow enough to not trigger any
> unfixed weird issues with the intense access patterns of rsync. Anyways,
> thanks for the hint!

That's good to read.  Actually, given the number of rsync-triggered bugs 
fixed over the years, rsync should be reasonably solid now in the default 
case, so it's not entirely surprising that it's working well for you.  
But it's _still_ good to read, as rsync really has triggered quite a 
number of bugs over the years, so if it's now working well, that really 
does indicate btrfs is maturing and getting more solidly stable, now. =:^)

But of course if you do a less tested setup, rsyncing half a TB a day to 
it, you're putting yourself in line to find a whole /new/ set of bugs.  
That's primarily what I was saying.

> I think I sadly do not have the resources to be that guinea pig…

Makes sense.

It'd be nice to have that corner-case well tested, but because it /is/ a 
reasonably rare corner-case, it's not like millions of users are going to 
be stumbling over bugs if testing waits awhile or even never really 
happens at all.

>> Meanwhile, assuming you're /not/ deliberately setting out to test,
>> [w]hy are you considering mixed-mode here?  At that size the ENOSPC
>> hassles of unmixed-mode btrfs on single-digit GiB [small btrfs] really
>> should be dwarfed into insignificance, particularly since btrfs since
>> [autoo-empty-chunk-deletion] so what possible reason [...] could
>> justify mixed-mode at that sort of scale?

> I just came to the consideration because I wondered why mixed-mode
> is not generally preferred when data and metadata have the
> same replication level.

The most direct answer is that mixed-mode is less efficient, and that it 
really was designed for severely size constrained (under double-digit 
GiB) btrfs, where the hassles of data vs. metadata chunks really are an 
administration headache.  It was never designed for even 100 GiB btrfs, 
where the data vs. metadata hassles tend to be much less of a headache, 
such that the inefficiency of mixed-mode tends to matter more than the 
much more minor data vs. metadata hassles.

Compounding that are two additional factors, the first being that unlike 
when mixed-mode was introduced, btrfs now deletes empty chunks, as well 
as being a bit better at allocating smaller chunks as size gets tight, so 
data vs. metadata hassles are at least an order of magnitude lower than 
they were (many will never see ENOSPC due to poor data/metadata balance 
at all now, while previously, it was generally only a matter of time if 
people weren't routinely rebalancing to prevent it).

The second additional factor is that mixed-mode gets /much/ less testing 
at 100 GiB and above, because it simply wasn't designed for that and the 
devs just don't test it, which means you're probably at least doubling 
your chance of bugs.  For that factor alone, many would actively negative-
recommend it, except for people who are really prepared to be guinea 
pigs, and indeed, that's exactly what you've seen here.

But it's a reasonable question, and now you have reasonable answers. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

