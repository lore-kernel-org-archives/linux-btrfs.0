Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53376 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbbL1CvL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 21:51:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDNts-0007o1-Jw
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 03:51:08 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 03:51:08 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 03:51:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] improve documentation of snapshot unaware defrag
Date: Mon, 28 Dec 2015 02:51:01 +0000 (UTC)
Message-ID: <pan$9c20a$2f693c09$f337c417$3719992c@cox.net>
References: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
	<1451185407-11422-1-git-send-email-mail@christoph.anton.mitterer.name>
	<pan$3bca9$74a60ba5$bf56792f$3c0040ca@cox.net>
	<1451263809.6320.9.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 28 Dec 2015 01:50:09 +0100 as
excerpted:

> On Sun, 2015-12-27 at 07:09 +0000, Duncan wrote:

>> raid1 mode

> I wonder when that reaches my pain threshold... and I submit a patch
> that renames it "notreallyraid1" in all places ;-)

I've seen two responses to that, both correct, AFAIK.

1) Btrfs very specifically and deliberately uses *lowercase* raidN in 
part to make that distinction, as the btrfs variants are chunk-level (and 
designed so that at some point in the future they can be subvolume and/or 
file level), not device-level (and at that future point, not necessarily 
filesystem level either).

As we've seen in discussion in other threads, for raid10 in particular, 
that makes a profound difference in robustness in the multi-device 
failure case.

2) Regarding btrfs raid1 and raid10's current very specific two-way-
mirroring in particular, limiting to two-way-mirroring in the 3+ devices 
case is well within established definitions and historic usage.  
Apparently, the N-devices = N-way-mirroring usage is relatively new, 
arguably first popularized by Linux mdraid, after which various hardware 
raid suppliers also implemented it due to competitive pressure.  But only 
two-way-mirroring is required by the RAID-1 definition.

Even were that not the case, point #1, btrfs' very specific use of 
*lowercase* raid1, still covers the two-way-limitation case just as well 
as it covers the chunk-level case.


That said, that the limited pair-mirroring btrfs implements even in the 
3+ device case still meets formal RAID-1 definitions was originally news 
to me as well, however well I might now accept the fact.  But once my 
earlier naive assumptions were corrected, the remaining clarification 
issues fell below my pain threshold.


But for those for whom it's still very close to their pain threshold, due 
to the above a patch effectively doing s/raid1/notreallyraid1/g is 
unlikely to be accepted.  Much more likely to be accepted would be a 
patch to the btrfs-balance and mkfs.btrfs manpages adding note, 
preferably accounting for the raid10 situation as well, explaining that 
btrfs raid (lowercase) isn't RAID (uppercase) in the the traditional 
sense, that it's chunk-scope not device-scope and that this has 
implications in for instance robustness in the raid10 multi-device 
failure case, and that both raid1 and raid10 are (currently) limited to 
two-way-mirroring.

Meanwhile, for anyone considering writing that patch, I'd also strongly 
recommend that the two-way-mirroring wording is separated out, at least 
onto its own lines if not a separate paragraph, so it can be cleanly 
deleted and/or modified once N-way-mirroring is introduced as a feature, 
without having to rewrite the chunk-level and raid10 bit as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

