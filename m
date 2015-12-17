Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48921 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbbLQFHV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Dec 2015 00:07:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9Qmb-00012k-WA
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 06:07:18 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 06:07:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 06:07:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Thu, 17 Dec 2015 05:07:12 +0000 (UTC)
Message-ID: <pan$b0077$783b4f16$83d44d74$9f275abe@cox.net>
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

> In kinda curios, what free space fragmentation actually means here.
> 
> Ist simply like this:
> +----------+-----+---+--------+
> |     F    |  D  | F |    D   |
> +----------+-----+---+--------+
> Where D is data (i.e. files/metadata) and F is free space.
> In other words, (F)ree space itself is not further subdivided and only
> fragmented by the (D)ata extents in between.
> 
> Or is it more complex like this:
> +-----+----+-----+---+--------+
> |  F  |  F |  D  | F |    D   |
> +-----+----+-----+---+--------+
> Where the (F)ree space itself is subdivided into "extents" (not
> necessarily of the same size), and btrfs couldn't use e.g. the first two
> F's as one contiguous amount of free space for a larger (D)ata extent

[still breaking into smaller points for reply]

At the one level, I had the simpler f/d/f/d scheme in mind, but that 
would be the case inside a single data chunk.  At the higher file level, 
with files significant fractions of the size of a single data chunk to 
much larger than a single data chunk, the more complex and second
f/f/d/f/d case would apply, with the chunk boundary as the separation 
between the f/f.

IOW, files larger than data chunk size will always be fragmented into 
data chunk size fragments/extents, at the largest, because chunks are 
designed to be movable using balance, device remove, replace, etc.

So (using the size numbers from a recent comment from Qu in a different 
thread), on a filesystem with under 100 GiB total space-effective (space-
effective, space available, accounting for the replication type, raid1, 
etc, and I'm simplifying here...), data chunks should be 1 GiB, while 
above that, with striping, they might be upto 10 GiB.

Using the 1 GiB nominal figure, files over 1 GiB would always be broken 
into 1 GiB maximum size extents, corresponding to 1 extent per chunk.

But while 4 KiB extents are clearly tiny and inefficient at today's 
scale, in practice, efficiency gains break down at well under GiB scale, 
with AFAIK 128 MiB being the upper bound at which any efficiency gains 
could really be expected, and 1 MiB arguably being a reasonable point at 
which further increases in extent size likely won't have a whole lot of 
effect even on SSD erase-block (where 1 MiB is a nominal max), but that's 
that's still 256X the usual 4 KiB minimum data block size, 8X the 128 KiB 
btrfs compression-block size, and 4X the 256 KiB defrag default "don't 
bother with extents larger than this" size.

Basically, the 256 KiB btrfs defrag "don't bother with anything larger 
than this" default is quite reasonable, tho for massive multi-gig VM 
images, the number of 256 KiB fragments will still look pretty big, so 
while technically a very reasonable choice, the "eye appeal" still isn't 
that great.

But based on real reports posting before and after numbers from filefrag 
(on uncompressed btrfs), we do have cases where defrag can't find 256 KiB 
free-space blocks and thus can actually fragment a file worse than it was 
before, so free-space fragmentation is indeed a very real problem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

