Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44381 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdBFE1H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 23:27:07 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1caatH-0002Kp-3K
        for linux-btrfs@vger.kernel.org; Mon, 06 Feb 2017 05:26:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it possible to have metadata-only device with no data?
Date: Mon, 6 Feb 2017 04:26:52 +0000 (UTC)
Message-ID: <pan$76944$e15dabff$cb6ce271$3ab68bb5@cox.net>
References: <14453691486330921@web21h.yandex.ru>
        <0dbbe15a-59f7-ef0e-1ed6-83fec7ef165a@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Sun, 05 Feb 2017 22:55:42 +0100 as
excerpted:

> On 02/05/2017 10:42 PM, Alexander Tomokhov wrote:
>> Is it possible, having two drives to do raid1 for metadata but keep
>> data on a single drive only?
> 
> Nope.
> 
> Would be a really nice feature though... Putting metadata on SSD and
> bulk data on HDD...

FWIW, it's on the list to be implemented in the future, but there's a lot 
more things on that list than devs working on btrfs, and the feature 
development and stabilization trend is that features often take much 
longer than anticipated, particularly to properly stabilize (to the level 
of the rest of btrfs, which is in general stabilizing but not yet fully 
stable, so stabilization is relative, here), which has slowed down the 
pipeline of new features due to the devs having their hands full 
stabilizing currently done but not yet properly stabilized features.

So if they're not working on it yet, chances are it's going to be at 
/least/ three years to usably stable, and realistically, they may not 
even start working on it until perhaps 5-7 years out, so it could easily 
be another decade out for such a feature to properly stabilize.

And given that the practical forecast horizon for free software is around 
five years, because enough unexpected happens in that time to make trying 
to predict in any worthwhile detail further out pretty much a fool's 
errand, effectively, it's at or outside the prediction horizon, so in 
practice, there's no telling /when/ it might be implemented and then 
stabilized enough to use, only that it /is/ on the list for "someday".

Meanwhile, FWIW, my feature of choice, N-way-mirroring, has long been 
scheduled for "right after raid56 mode".  Well, raid56 mode first wasn't 
introduced until long after originally scheduled (3.6 or earlier), then 
when it was it was runtime-only, the maintenance and recovery tools 
weren't there yet, then something like two years later they were ready so 
it was in theory feature-complete (in 3.19) but not yet stabilized, then 
in the stabilization process, some serious implementation bugs were found 
such that it can't yet be recommended and may yet require a full 
rewrite... so I'm still waiting for N-way-mirroring, which was supposed 
to follow shortly after raid56 mode.

And given that raid56 mode might now take another couple years to 
stabilize (and it could be longer than that), I'm not expecting N-way-
mirroring for another three years or so, so even it could well be five 
years out to usable stability.  And it has long been at least in the 
known queue for after raid56 mode, and hasn't really been even started 
yet, so features on the list, but not yet actually on the queue, again, 
who knows, but five years out at least is a reasonable bet, and that's 
prediction horizon, so indeed, there's no way to really even predict, at 
this point.

But I do know all about waiting, by now.  I've learned, and am continuing 
to learn, all about patience! =:^]

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

