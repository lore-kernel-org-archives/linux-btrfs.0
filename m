Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57691 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbbJVDfI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 23:35:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zp6ef-0004ww-Dv
	for linux-btrfs@vger.kernel.org; Thu, 22 Oct 2015 05:35:05 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 05:35:05 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 05:35:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-balance causes system-freeze on full disk
Date: Thu, 22 Oct 2015 03:34:57 +0000 (UTC)
Message-ID: <pan$af772$909eacb5$9a019d0d$f4538f63@cox.net>
References: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
	<CAM9fjH4vQki-0UjdMTGZgKEbDy1pRBZNRqro8TtqzLbDPwfsvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kyle Manna posted on Wed, 21 Oct 2015 13:51:22 -0700 as excerpted:

> The issue I encountered is described @
> https://bugzilla.kernel.org/show_bug.cgi?id=105681

FWIW...

I won't try to deal with the issue reported there, but I can help clear 
something up that's mentioned on the bug[1].

The question (comment 5 and 6) refers to btrfs device usage output, for a 
three-device btrfs raid1, both data/metadata.  The question was why only 
two of the three devices listed a system chunk.

Btrfs raid1, unlike say mdraid1, is strictly pair-mirror, exactly two 
copies of the chunk, one each on two different devices.  More devices 
adds to the space available, not to the number of redundant copies.

As it happens, the two devices that got a copy of the system chunk were 
sdb and sdd, sdc didn't get a copy, as there are only two copies to 
distribute, no matter the number of devices in the raid1.


And as it happens, I've been personally interested in and thus following 
the roadmapped btrfs N-way-mirroring, the feature that would put a copy 
on all three devices, this being my most hotly anticipated btrfs feature 
since 3-way-mirroring is about the perfect balance between cost and 
reliability due to device redundancy, for me.

For quite some time now, a new N-way-mirroring feature has been on the 
roadmap, to be worked on after raid56 mode, as the planned implementation 
was to use some of the same code.  Raid56 mode is complete now, tho it 
took far longer than initially expected, so hopefully n-way-mirroring is 
already in development.  However, given the time raid56 took, 2-3 years 
of development, it's likely to be some time before n-way-mirroring 
actually appears.  And again, if it follows the pattern of other btrfs 
features, it'll take a couple kernel cycles after initial release to 
stabilize to actual usability, and a full year (five cycles) to stabilize 
to approximately the same maturity/stability as the rest of btrfs in 
general.

For raid56, nominally code-complete in 3.19, the last critical bug was in 
the early 4.1 code, fixed by 4.1 release.  But my recommendation has been 
to wait another couple cycles just to be sure nothing else "interesting" 
comes up, basically a full year, five kernel cycles, after nominal code-
complete release.  That would be 4.4...

Back to N-way-mirroring, assuming the work doesn't get delayed by 
something else, I'd EWAG (educated WAG) an 18 month to 2 year development 
time to nominally complete.  That would put initial release around 
4.7-4.9, actual usability at 4.9-4.11, and year-on stability at 4.12-4.14.

So altho we're nearing a year since raid56 nominal-completion, I don't 
expect N-way-mirroring code release for another year or so yet, don't 
expect it to be really usable for another five months (two kernel cycles) 
after that, and even then, wouldn't expect it to be as stable as the rest 
of btrfs for another further three kernels or so, thus putting actual 
reasonable stability (compared to the already stable 2-way raid1 code) 
two years out...

So it's coming, and at least now it's close enough there's /some/ 
estimate of when it might be available, but it's going to be some time 
yet before I'd expect even nominal code-completion release, and some time 
after that before it reaches the stability benefit that I'm actually 
hotly anticipating the feature for.  Very roughly two years from now, tho 
I'd not be surprised at all to see that slide another six months to a 
year, and that's assuming nothing else shoves it out of the way, priority-
wise.

---
[1] I do have a kernel-bugs login but didn't want to bother logging in 
just to add the comment there, when I had just clicked a link here to get 
there, and could simply reply here instead.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

