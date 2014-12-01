Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbaLAShh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 13:37:37 -0500
Date: Mon, 1 Dec 2014 19:37:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>, dsterba@suse.cz,
        Chris Mason <clm@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141201183729.GM12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <1416859665.3019.6@mail.thefacebook.com>
 <20141125164717.GK26471@twin.jikos.cz>
 <5475D7F3.4040408@swiftspirit.co.za>
 <5475DC9A.3060003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5475DC9A.3060003@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 26, 2014 at 08:58:50AM -0500, Austin S Hemmelgarn wrote:
> On 2014-11-26 08:38, Brendan Hide wrote:
> > On 2014/11/25 18:47, David Sterba wrote:
> >> We could provide an interface for external applications that would make
> >> use of the strong checksums. Eg. external dedup, integrity db. The
> >> benefit here is that the checksum is always up to date, so there's no
> >> need to compute the checksums again. At the obvious cost.
> >
> > I can imagine some use-cases where you might even want more than one
> > algorithm to be used and stored. Not sure if that makes me a madman,
> > though. ;)
> >
> Not crazy at all, I would love to have the ability to store multiple 
> different weak but fast hash values.  For example, on my laptop, it is 
> actually faster to compute crc32c, adler32, and md5 hashes together than 
> it is to compute pretty much any 256-bit hash I've tried.

Well, this is doable :) there's space for 256 bits in general, the order of
checksum bytes in one "checksum word" would be given by fixed order the
algorighms are defined. The code complexity would increase, but not that
much I think.

> This then brings up the issue of what to do when we try to mount such a 
> fs on a system that doesn't support some or all of the hashes used.

I see two modes: first fail if all not present, or relaxed by a mount
option to accept at least one.

But let's keep this open, I'm not yet convinced that combining more weak
algos makes sense from the crypto POV. If this should protect against
random bitflips, would one fast-but-weak be comparable to a combination?
Or other expectations.
