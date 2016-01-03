Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53070 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbcACPAk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Jan 2016 10:00:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aFk98-0002R3-5j
	for linux-btrfs@vger.kernel.org; Sun, 03 Jan 2016 16:00:38 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 16:00:38 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 16:00:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unrecoverable fs corruption?
Date: Sun, 3 Jan 2016 15:00:33 +0000 (UTC)
Message-ID: <pan$e83b6$5156a07d$651aae24$9dda2c0a@cox.net>
References: <4bfedb90694d34a9a311d532715560d1@mail.mended-drum.net>
	<CAJCQCtSDpGnXpFpHxO9eyb7pLWKQis6+yOBznFkJO85e0NLyyw@mail.gmail.com>
	<pan$775e4$fad1d9d7$a69e525a$ff4dac1a@cox.net>
	<1451709141.8761.16.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sat, 02 Jan 2016 05:32:21 +0100 as
excerpted:

> On Fri, 2016-01-01 at 08:13 +0000, Duncan wrote:
>> you can also try a read-only scrub
> OT: I just wondered, would a balance include everything a scrub includes
> (i.e. read+verify all data and rebuild an errors on different devices /
> block copies)... of course in addition to also copying all "good"
> data... and perhaps with the difference, that you don't get that
> detailed information as in scrub but only the kernel log messages about
> errors?

AFAIK, no, at least not by design, as balance works at the chunk level, 
while scrub works inside chunks, verifying the checksums on each block.

But now that I think about it, balance does read the chunk in ordered to 
rewrite its contents, and that read, like all reads, should normally be 
checksum verified (except of course in the case of nodatasum, which nocow 
of course implies).  So a balance completed without error /may/ 
effectively indicate a scrub would complete without error as well.  But 
it wasn't specifically designed for that, and if it does so, it's only 
doing it because all reads are checksum verified, not because it's 
actually purposely doing a scrub.

And even if balance works to verify no checksum errors, I don't believe 
it would correct them or give you the detail on them that a scrub would.  
And if there is an error, it'd be a balance error, which might or might 
not actually be a scrub error.

>> In this case,
>> you'll need to recover from the degraded-mount working device as if the
>> second one had entirely failed.
>> 
>> What I'd do in this case, if you haven't done so already, is that read-
>> only btrfs scrub, just to see where you are in terms of corruption on
>> the remaining device.
> I don't think that this is the best order of the steps - at least not
> when it's about precious data.
> 
> Doing a scrub at this phase, would just read all data, telling you the
> status,... but first you should try to copy as much as possible (just in
> case the remaining good drive fails as well) and *then* do the scrub to
> see what's actually good or not.

Good point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

