Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51406 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586AbbLBKBc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 05:01:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a44E1-0007H0-S9
	for linux-btrfs@vger.kernel.org; Wed, 02 Dec 2015 11:01:26 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 11:01:25 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 11:01:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: utils version and convert crash
Date: Wed, 2 Dec 2015 10:01:16 +0000 (UTC)
Message-ID: <pan$c5c73$162474d7$f06e12fa$496fb5f@cox.net>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
	<pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
	<CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
	<565E0356.9030006@gmail.com>
	<CA+WRLO-VSOH1QUHTXFGzCSUKW=mRoufmUpYG8xRB4N80+rHmjg@mail.gmail.com>
	<CA+WRLO_1bLpve50YkuGD4wDxyO_e=4u9xev8y4XxZT9L01KxDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Wed, 02 Dec 2015 18:07:48 +1100 as excerpted:

> Output from scrub:
> sudo btrfs scrub start -Bd /data

[Omitted no-error device reports.]

> scrub device /dev/sdh (id 6) done
>    scrub started at Wed Dec  2 07:04:08 2015 and finished after 06:47:22
>    total bytes scrubbed: 1.09TiB with 2 errors
>    error details: read=2
>    corrected errors: 2, uncorrectable errors: 0, unverified errors: 30

Also note those unverified errors...

I have quite a bit of experience with btrfs scrub as I ran with a failing 
ssd for awhile, using btrfs scrub on the multiple btrfs raid1 filesystems 
on parallel partitions on the failing ssd and another good one to correct 
the errors and continue operations.

Unverified errors are, I believe[1], errors where a metadata block 
holding checksums itself has an error, so the blocks its checksums in 
turn covered are not checksum-verified.

What that means in practice is that once the first metadata block error 
has been corrected in a first scrub run, a second scrub run can now check 
the blocks that were recorded as unverified errors in the first run, 
potentially finding and hopefully fixing additional errors, tho unless 
the problem's extreme, most of the unverifieds should end up being 
correct once they can be verified, with only a few possible further 
errors found.

Of course if some of these previously unverified blocks are themselves 
metadata blocks with further checksums, yet another run may be required.

Fortunately, these trees are quite wide (121 items according to an old 
post from Hugo I found myself rereading a few hours ago) and thus don't 
tend to be very deep -- I think I ended up rerunning scrub four times at 
one point, before both read and unverified errors went to zero, tho 
that's on relatively small partitioned-up ssd filesystems of under 50 gig 
usable capacity (pair-raid1, 50 gig per device), so I could see terabyte-
scale filesystems going to 6-7 levels.

And, again on a btrfs raid1 with a known failing device -- several 
thousand redirected sectors by the time I gave up and btrfs replaced -- 
generally each successive scrub run would return an order of magnitude or 
so fewer errors (corrected and unverified both) than the previous run, 
tho occasionally I'd hit a bad spot and the number would go up a bit in 
one run, before dropping an order of magnitude or so again on the next 
run.

So with only two corrected read-errors and 30 unverified, I'd expect 
maybe another one or two corrected read-errors on a second run, and 
probably no unverifieds, in which case a third run shouldn't be necessary 
unless you just want the peace of mind of seeing that no errors found 
message.  Tho of course if you're unlucky, one of those 30 will turn out 
to be a a read error on a full 121-item metadata block, so your 
unverifieds will go up for that run, before going down again in 
subsequent runs.

Of course with filesystems of under 50 gig capacity on fast ssds, a 
typical scrub ran in under a minute, so repeated scrubs to find and 
correct all errors wasn't a big deal, generally under 10 minutes 
including human response time.  On terabyte-scale spinning rust with 
scrubs taking hours, multiple scrubs could easily take a full 24-hour day 
or more! =:^(

So now that you did one scrub and did find errors, you do probably want 
to trace them down and correct the problem if possible, before running 
further scrubs to find and exterminate any errors still hiding behind 
unverified in the first run.  But once you're reasonably confident you're 
running a reliable system again, you probably do want to run further 
scrubs until that unverified count goes to zero (assuming no 
uncorrectable errors in the mean time).

---
[1] I'm not a dev and am not absolutely sure of the technical accuracy of 
this description, but from an admin's viewpoint it seems to be correct at 
least in practice, based on the fact that further scrubs as long as there 
were unverified errors often did find additional errors, while once the 
unverified count dropped to zero and the last read errors were corrected, 
further scrubs turned up no further errors.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

