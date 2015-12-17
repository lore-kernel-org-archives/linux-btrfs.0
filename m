Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50443 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbbLQGAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Dec 2015 01:00:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9RcM-0006Ta-2a
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 07:00:46 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 07:00:46 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 07:00:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Thu, 17 Dec 2015 06:00:34 +0000 (UTC)
Message-ID: <pan$d0842$69c32fed$b2002dde$886faec7@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	<pan$3c463$5dc6ffa1$704b2ca2$141e65cc@cox.net>
	<5667C00B.4010100@scientia.net>
	<pan$7e682$345fe6d2$de13162d$f5ac4118@cox.net>
	<1450303141.6242.50.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 16 Dec 2015 22:59:01 +0100 as
excerpted:

> I'm a bit unsure how to read filefrag's output... (even in the
> uncompressed case).
> What would it show me if there was fragmentation

/path/to/file:	18 extents found

It tells you the number of extents found.  Nominally, each extent should 
be a fragment, but as has been discussed elsewhere, on btrfs compressed 
files it will interpret each 128 KiB btrfs compression block as its own 
extent, even if (as seen in verbose mode) the next one begins where the 
previous one ends so it's really just a single extent.

Apparently on ext3/4, it's possible to have multi-gig files as a single 
extent, thus unfragmented, but as explained in an earlier reply to a 
point earlier in your post, on btrfs, extents of a GiB are nominally the 
best you can do as that's the nominal data chunk size, tho in limited 
circumstances larger extents are still possible on btrfs.

In the case above, where I took the 18 extents result from a real file 
(tho obviously the posted path isn't real), it was 4 MiB in size (I think 
exactly, it's a 4 MiB BIOS image =:^), so doing the math, extents average 
227 KiB.  That's on a filesystem that is always mounted with autodefrag, 
but it's also always mounted with compress, so it's possible some of the 
reported extents are compressed.

Actually, looking at filefrag -v output (which I've never used before but 
which someone noted could be used to check fragmentation on compressed 
files, tho it's not as straightforward as you might think), it looks like 
all but two of the listed extents are 32 blocks long (with 4096 byte 
blocks), which equates to 128 KiB, the btrfs compression-block size, and 
the two remaining extents are 224 blocks long or 896 KiB, an exact 7 
multiple of 128 KiB, so this file would indeed appear to be compressed 
except for those two uncompressed extents.  (As for figuring out how to 
interpret the full -v output to know whether the compressed blocks are 
actually single extents or not, as I said this is my first time trying
-v, and I didn't bother going that far with it.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

