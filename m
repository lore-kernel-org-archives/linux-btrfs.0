Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37485 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeF3EBY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 00:01:24 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fZ72V-0002IH-LH
        for linux-btrfs@vger.kernel.org; Sat, 30 Jun 2018 05:59:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unsolvable technical issues?
Date: Sat, 30 Jun 2018 03:59:05 +0000 (UTC)
Message-ID: <pan$e0da5$f8a65b2e$33811aa8$414740f2@cox.net>
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
        <20180625133611.GC27958@twin.jikos.cz>
        <5d76bd89-a209-2197-5eec-9cd88774f1a2@dirtcellar.net>
        <20180625165436.GH28972@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 25 Jun 2018 16:54:36 +0000 as excerpted:

> On Mon, Jun 25, 2018 at 06:43:38PM +0200, waxhead wrote:
> [snip]
>> I hope I am not asking for too much (but I know I probably am), but I
>> suggest that having a small snippet of information on the status page
>> showing a little bit about what is either currently the development
>> focus , or what people are known for working at would be very valuable
>> for users and it may of course work both ways, such as exciting people
>> or calming them down. ;)
>> 
>> For example something simple like a "development focus" list...
>> 2018-Q4: (planned) Renaming the grotesque "RAID" terminology
>> 2018-Q3: (planned) Magical feature X
>> 2018-Q2: N-Way mirroring
>> 2018-Q1: Feature work "RAID"5/6
>> 
>> I think it would be good for people living their lives outside as it
>> would perhaps spark some attention from developers and perhaps even
>> media as well.
> 
> I started doing this a couple of years ago, but it turned out to be
> impossible to keep even vaguely accurate or up to date, without going
> round and bugging the developers individually on a per-release basis. I
> don't think it's going to happen.

In addition, anything like quarter, kernel cycle, etc, has been 
repeatedly demonstrated to be entirely broken beyond "current", because 
roadmapped tasks have rather consistently taken longer, sometimes /many/ 
/times/ longer (by a factor of 20+ in the case of raid56), than first 
predicted.

But in theory it might be double, with just a roughly ordered list, no 
dates beyond "current focus", and with suitably big disclaimers about 
other things (generally bugs in otherwise more stable features, but 
occasionally a quick sub-feature that is seen to be easier to introduce 
at the current state than it might be later, etc) possibly getting 
priority and temporarily displacing roadmapped items.

In fact, this last one is the big reason why raid56 has taken so long to 
even somewhat stabilize -- the devs kept finding bugs in already semi-
stable features that took priority... for kernel cycle after kernel 
cycle.  The quotas/qgroups feature, already introduced and intended to be 
at least semi-stable was one such culprit, requiring repeated rewrite and 
kernel cycles worth of bug squashing.  A few critical under the right 
circumstances compression bugs, where compression was supposed to be an 
already reasonably stable feature, were another, tho these took far less 
developer bandwidth than quotas.  Getting a reasonably usable fsck was a 
bunch of little patches.  AFAIK that one wasn't actually an original 
focus and was intended to be back-burnered for some time, but once btrfs 
hit mainline, users started demanding it, so the priority was bumped.  
And of course having it has been good for finding and ultimately fixing 
other bugs as well, so it wasn't a bad thing, but the hard fact is the 
repairing fsck has taken, all told, I'd guess about the same number of 
developer cycles as quotas, and those developer cycles had to come from 
stuff that had been roadmapped for earlier.

As a bit of an optimist I'd be inclined to argue that OK, we've gotten 
btrfs in far better shape general stability-wise now, and going forward, 
the focus can be back on the stuff that was roadmapped for earlier that 
this stuff displaced, so one might hope things will move faster again 
now, but really, who knows?  That's arguably what the devs thought when 
they mainlined btrfs, too, and yet it took all this much longer to mature 
and stabilize since then.  Still, it /has/ to happen at /some/ point, 
right?  And I know for a fact that btrfs is far more stable now than it 
was... because things like ungraceful shutdowns that used to at minimum 
trigger (raid1 mode) scrub fixes on remount and scrub, now... don't -- 
btrfs is now stable enough that the atomic COW is doing its job and 
things "just work", where before, they required scrub repair at best, and 
occasional blow away and restore from backups.  So I can at least /hope/ 
that the worst of the plague of bugs is behind us, and people can work on 
what they intended to do most (say 80%) of the time now, spending say a 
day's worth a week (20%) on bugs, instead of the reverse, 80% (4 days a 
week) on bugs and if they're lucky, a day a week on what they were 
supposed to be focused on, which is what we were seeing for awhile.

Plus the tools to do the debugging, etc, are far more mature now, another 
reason bugs should hopefully take less time now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

