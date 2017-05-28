Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60716 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdE1UvV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 16:51:21 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dF59d-00079F-N7
        for linux-btrfs@vger.kernel.org; Sun, 28 May 2017 22:51:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs mounts RO, kernel oops on RW
Date: Sun, 28 May 2017 20:51:07 +0000 (UTC)
Message-ID: <pan$2da74$5ca79c06$4ae1fa5f$5d80e969@cox.net>
References: <CAHPjZW7Af2KzRr_HTaCNGqRAM0SsV8+gJWSRis6eCjGeXNBK7Q@mail.gmail.com>
        <pan$3ce02$7e425613$62194897$37882c38@cox.net>
        <CAHPjZW5sRxns7CN8QmhB_HaQP5PGo7smFrf+q1QWHRRVnAToMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bill Williamson posted on Sun, 28 May 2017 17:27:47 +1000 as excerpted:

> I'm not asking for a specific endorsement, but should I be considering
> something like the seagate ironwolf or WD red drives?

There's a (well, at least one) guy here that knows much more about that 
than I do, and FWIW, my own usage is rather lower on the scale, sub-TB 
and generally SSD.  I just saw the trouble with the 8TB archive drives 
hit the list and while as I said the worst of it is now fixed, know they 
still have problems with btrfs due to its write pattern, so thought I'd 
warn you, just in case.  

Basically, the way these work is that to get their extreme storage 
density, other than for a relatively small fast-write area (perhaps a 
hundred gig or a half TB, I'm not sure), they interleaf sectors in 
"zones", overlapping like tiles on a tile roof, and to write or rewrite 
just a single sector means (re)writing the entire zone.  So they'll 
typically write to the fast-write area during the initial write, then 
when the drive isn't busy satisfying incoming requests, it'll rewrite 
that data into one of these zones.

So as long as you're either doing relatively slow archiving writes and 
there's time in between to do the zone rewrites (think security cam 
footage with motion-sensitivity so it doesn't actually write if the image 
is static), these things work great, and are a great deal for the money 
due to their generally lower per-TB cost.

But they'll do a lot of background rewriting from the fast write area 
when the disk is otherwise idle, and if you shut down in the middle of a 
rewrite, I believe it has to start that zone rewrite over.

And if the writes come in too fast or too steady and overwhelm that fast 
write area, things **DRAMATICALLY** slow down, and can appear to lock up 
the system at times because the zone rewrite is in progress and it can't 
just drop it to satisfy a read request unless it wants to scrap the zone 
rewrite and start it over later, which of course intensifies the problem 
even more if the writes are already coming in faster than the drive can 
rewrite the zones.

So these work best in large always-on installations with relatively slow 
archive-write patterns such that very little is rewritten where the drive 
has lots of otherwise inactive powered-on time to do its zone rewrites, 
uninterrupted by incoming requests or power-downs.  (I have a feeling 
Amazon Glacier may be a major if not their primary customer...)

Within that envelope, they tend to be very good value for the money, 
which makes them very tempting in general, but a lot of people simply 
aren't aware of the serious limits of the targeted usage envelope, and 
due to that low cost, want to use them for other things for which they're 
a very poor match.

And the btrfs write pattern, along with the fact that it's still 
stabilizing, not as stable and mature as for instance ext* or xfs, makes 
btrfs a very poor choice for use on these drives, unless the use-case 
really /does/ fall squarely within their target envelope.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

