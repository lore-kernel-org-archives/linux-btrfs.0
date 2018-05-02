Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52120 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbeEBBtp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 May 2018 21:49:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fDgrk-0000Lh-FK
        for linux-btrfs@vger.kernel.org; Wed, 02 May 2018 03:47:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID56 - 6 parity raid
Date: Wed, 2 May 2018 01:47:25 +0000 (UTC)
Message-ID: <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gandalf Corvotempesta posted on Tue, 01 May 2018 21:57:59 +0000 as
excerpted:

> Hi to all I've found some patches from Andrea Mazzoleni that adds
> support up to 6 parity raid.
> Why these are wasn't merged ?
> With modern disk size, having something greater than 2 parity, would be
> great.

1) Btrfs parity-raid was known to be seriously broken until quite 
recently (and still has the common parity-raid write-hole, which is more 
serious on btrfs because btrfs otherwise goes to some lengths to ensure 
data/metadata integrity via checksumming and verification, and the parity 
isn't checksummed, risking even old data due to the write hole, but there 
are a number of proposals to fix that), and piling even more not well 
tested patches on top was _not_ the way toward a solution.

2) Btrfs features in general have taken longer to merge and stabilize 
than one might expect, and parity-raid has been a prime example, with the 
original roadmap calling for parity-raid merge back in the 3.5 timeframe 
or so... partial/runtime (not full recovery) code was finally merged ~3 
years later in (IIRC) 3.19, took several development cycles for the 
initial critical bugs to be worked out but by 4.2 or so was starting to 
look good, then more bugs were found and reported, that took several more 
years to fix, tho IIRC LTS-4.14 has them.

Meanwhile, consider that N-way-mirroring was fast-path roadmapped for 
"right after raid56 mode, because some of its code depends on that), so 
was originally expected in 3.6 or so...  As someone who had been wanting 
to use /that/, I personally know the pain of "still waiting".

And that was "fast-pathed".

So even if the multi-way-parity patches were on the "fast" path, it's 
only "now" (for relative values of now, for argument say by 4.20/5.0 or 
whatever it ends up being called) that such a thing could be reasonably 
considered.


3) AFAIK none of the btrfs devs have flat rejected the idea, but btrfs 
remains development opportunity rich and implementing dev poor... there's 
likely 20 years or more of "good" ideas out there.  And the N-way-parity-
raid patches haven't hit any of the current devs' (or their employers') 
"personal itch that needs to be scratched" interest points, so while it 
certainly does remain a "nice idea", given the implementation timeline 
history for even 'fast-pathed" ideas, realistically we're looking at at 
least a decade out.  But with the practical projection horizon no more 
than 5-7 years out (beyond that other, unpredicted, developments, are 
likely to change things so much that projection is effectively 
impossible), in practice, a decade out is "bluesky", aka "it'd be nice to 
have someday, but it's not a priority, and with current developer 
manpower, it's unlikely to happen any time in the practically projectable 
future.

4) Of course all that's subject to no major new btrfs developer (or 
sponsor) making it a high priority, but even should such a developer (and/
or sponsor) appear, they'd probably need to spend at least two years 
coming up to speed with the code first, fixing normal bugs and improving 
the existing code quality, then post the updated and rebased N-way-parity 
patches for discussion, and get them roadmapped for merge probably some 
years later due to other then-current project feature dependencies.

So even if the N-way-parity patches became some new developer's (or 
sponsor's) personal itch to scratch, by the time they came up to speed 
and the code was actually merged, there's no realistic projection that it 
would be in under 5 years, plus another couple to stabilize, so at least 
7 years to properly usable stability.  So even then, we're already at the 
5-7 years practical projectability limit.


Meanwhile, have you looked at zfs?  Perhaps they have something like 
that?  And there's also a new(?) one, stratis, AFAIK commercially 
sponsored and device-mapper based, that I saw an article on recently, tho 
I've seen/heard no kernel-community discussion on it (there's a good 
chance followup here will change that if it's worth discussing, as 
there's several folks here for whom knowing about such things is part of 
their job) and no other articles (besides the pt 1 of the series 
mentioned below), so for all I know it's pie-in-the-sky or still new 
enough it'd be 5-7 years before it can be used in practice, as well.  But 
assuming it's a viable project, presumably it would get support if device-
mapper did/has.

The stratis article I saw (apparently part 2 in a series):
https://opensource.com/article/18/4/stratis-lessons-learned

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

