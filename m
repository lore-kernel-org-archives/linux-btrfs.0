Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36612 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbbLVDzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 22:55:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBE2b-0005U6-Iu
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 04:55:13 +0100
Received: from ip5f5ae08a.dynamic.kabel-deutschland.de ([95.90.224.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 04:55:13 +0100
Received: from hurikhan77 by ip5f5ae08a.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 04:55:13 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: compression disk space saving - what are your results?
Date: Tue, 22 Dec 2015 04:55:07 +0100
Message-ID: <20151222045507.24886af5@jupiter.sol.kaishome.de>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
	<565EEC1F.7070600@gmail.com>
	<18fb40ae4411f31353e06bf99ee12c8a@admin.virtall.com>
	<565F04E1.6000003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 2 Dec 2015 09:49:05 -0500
schrieb Austin S Hemmelgarn <ahferroin7@gmail.com>:

> > So, 138 GB files use just 24 GB on disk - nice!
> >
> > However, I would still expect that compress=zlib has almost the same
> > effect as compress-force=zlib, for 100% text files/logs.
> >  
> That's better than 80% space savings (it works out to about 83.6%),
> so I doubt that you'd manage to get anything better than that even
> with only plain text files.  It's interesting that there's such a big
> discrepancy though, that indicates that BTRFS really needs some work
> WRT deciding what to compress.

As far as I understood from reading here, btrfs fairly quickly opts out
of compressing further extents if it stumbles across the first block
with a bad compression ratio for file.

So, what I do is compress-force=zlib for my backup drive which holds
several months of snapshots, new backups go to a scratch area which is
snapshotted after rsync finishes (important: use --no-whole-file and
--inplace).

On my system drive I use compress=lzo and hope the heuristics work.
>From time to time I use find and btrfs-defrag to selectively recompress
files (using mtime and name filters) and defrag directory nodes (which
according to docs should defrag metadata).

A 3x TB btrfs mraid1 draid0 (1.6TB used) fits onto a 2TB backup drive
with backlog worth around 4 months (daily backups). It looks pretty
effective. Forcing zlib manages to compress file additions quite well
although I didn't measure it lately. It was far from 80% but it was not
far below 40-50%.

I wish one could use per-subvolume compression option already.

-- 
Regards,
Kai

Replies to list-only preferred.


