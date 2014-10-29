Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44284 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbaJ2DC3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 23:02:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XjJWl-0008W0-Eh
	for linux-btrfs@vger.kernel.org; Wed, 29 Oct 2014 04:02:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Oct 2014 04:02:27 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Oct 2014 04:02:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unable to fixup (regular) error in RAID1 fs
Date: Wed, 29 Oct 2014 03:02:14 +0000 (UTC)
Message-ID: <pan$926c2$2d969c3e$ebb0bb58$d02b674@cox.net>
References: <a3d3305c6149a1aa5e2b3f29d76fff93@miceliux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Juan Orti posted on Tue, 28 Oct 2014 16:54:19 +0100 as excerpted:

> [ 3713.086292] BTRFS: unable to fixup (regular) error at logical 
> 483011874816 on dev /dev/sdb2
> [ 3713.092577] BTRFS: checksum error at logical 483011948544 on dev 
> /dev/sdb2, sector 628793528, root 2500, inode 1436631, offset 
> 4059963392, length 4096, links 1 (path: 
> juan/.local/share/gnome-boxes/images/boxes-unknown)
> [ 3713.092584] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt 
> 38, gen 0
> [ 3713.093035] BTRFS: unable to fixup (regular) error at logical 
> 483011948544 on dev /dev/sdb2
> 
> Why can't it fix the errors? a bad device? smartctl says the disk is ok. 
> I'm currently running a full scrub to see if it finds more errors. What 
> should I do?

Btrfs raid1, and I see you have it for both data and metadata.

During normal operation, when btrfs comes across a block that doesn't
match its checksum, it will look to see if there's another copy (which
there is with raid1, which has exactly two copies) of that block and will
try to use it instead if so.  If the second copy matches the checksum,
all is fine and btrfs will in fact attempt to rewrite the bad copy using
the good copy, as well as returning the good copy to whatever was
reading it.

Those corruption errors seem to indicate that it can't find a good
copy to update the bad copy with -- both copies ended up bad.  Either
that or it found the good copy and returned it to whatever was reading,
but couldn't rewrite the bad copy, for some reason.

I'm not sure which of those interpretations is correct, but given
that you didn't see anything else bad happening, no apps returning
errors due to read error, etc, I'd guess the second.  Because
otherwise whatever was doing the read should have returned an
error.

Doing a scrub, as you already did, is the first thing I'd try here,
since normal operation won't catch all the errors.

BUT, you report that the scrub found no errors, which is weird.
You have the log saying there's corruption errors, but scrub
saying there's not.

The easiest explanation for something like that, is that the errors
were temporary.  If it happens again or regularly, consider running
memcheck or the like, as it could be bad memory.  Do you have ECC RAM?

Another question.  Do you have skinny metadata on that btrfs?  If you
do, btrfs should mention "skinny extents" when mounting the filesystem.

The reason I'm asking this is that if I'm reading the patch descriptions
correctly, a recently posted patch deals with a specific skinny-metadata
bug where wrong results would occasionally be returned, resulting in
errors.  Not being a dev I don't have the technical ability to know for
sure whether this could be connected to that or not, but it sounds like
the sort of thing I might expect from a bug that intermittently returned
bad data -- odd apparent corruption errors in normal use that scrub
can't see, even tho it's designed to catch and fix if possible exactly
that sort of corruption error.

Anyway, if scrub says no corruption, for a potential corruption error
I'd be inclined to trust scrub, so I think the filesystem is fine.
But if so, I'm worried about what might be triggering these
intermittent errors.  Certainly watch for more of them, and if you're
running skinny-metadata, consider finding and applying that patch.
If not or in general, also be on the lookout for more possible hints
of failing memory and/or run a good memory checker for a few hours
and see if it reports all is well.

But as they say about some kinds of potential cancer reports at times,
sometimes watchful waiting is the best you can do, hoping no further
symptoms show up, but being alert in case they do, to try something
more drastic, that isn't warranted /unless/ they do.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

