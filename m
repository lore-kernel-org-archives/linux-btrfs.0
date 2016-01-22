Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46573 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbcAVTne (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 14:43:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aMhcK-0007nt-Pp
	for linux-btrfs@vger.kernel.org; Fri, 22 Jan 2016 20:43:32 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 20:43:32 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 20:43:32 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Interjection: autodefrag mount option aye, nae?
Date: Fri, 22 Jan 2016 20:43:25 +0100
Message-ID: <20160122204325.19ff0805@jupiter.sol.kaishome.de>
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
	<5697D0E9.3080007@gmail.com>
	<20160114192647.GB24567@localhost.localdomain>
	<5697F9E7.1020004@gmail.com>
	<loom.20160120T163054-326@post.gmane.org>
	<569FAA4E.1040204@gmail.com>
	<20160121215932.3e6654af@jupiter.sol.kaishome.de>
	<56A21D41.3020004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Fri, 22 Jan 2016 07:14:57 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> On 2016-01-21 15:59, Kai Krakow wrote:
> > Am Wed, 20 Jan 2016 10:39:58 -0500
> > schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
> >
> >> On 2016-01-20 10:33, Al wrote:
> >>> [very quietly] I've had autodefrag out of my mount options for a
> >>> long while now. Is that still the recommended position?
> >> I think it really depends on what you're doing.  In my case, I
> >> usually have it on, and the only issue I've ever seen is that
> >> Chrome sometimes loads pages from local cache slower than it
> >> should be.  I also don't use ridiculous numbers of snapshots
> >> either (I use them only to get a stable view of the filesystem
> >> when generating a backup), so I don't have much experience with
> >> how they interact with autodefrag.
> >
> > I'd recommend to set chrome caching to simple http cache in
> > chrome://flags as this is more suitable for btrfs (as for most Unix
> > file systems which deal with many small files better than with
> > random updates in a big fat files).
> >
> > I experienced much improved performance and responsiveness with it.
> > May be worth a try for you. I'd be interested in your results.
> >
> > chrome://flags/#enable-simple-cache-backend
> >
> Thanks for the suggestion, it does in fact appear to improve things
> on BTRFS.

The original Chrome cache manages HTTP files in big, database-like
files. This design is better for Windows machines as NTFS (or probably
an almost non-existing IO scheduler) is not good at handling many small
files. Unix is traditionally much more optimized at that and
outperforms Windows here. Adding the fact that COW file systems are not
good at database-like workloads, it explains why it works much better.

But it was also more responsive when I used it back in my XFS days
(spanning multiple devices using LVM JBOD). So I stayed with it. The
multi-second freezes once in a while of Chrome drove me crazy. This
fixed it.

-- 
Regards,
Kai

Replies to list-only preferred.

