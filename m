Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47746 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcC0MKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 08:10:12 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe doesnt work
Date: Sun, 27 Mar 2016 14:10:07 +0200
Message-ID: <1476912.bqJXGglCVP@merkaba>
In-Reply-To: <pan$a7a0b$d1f1da3$f3b73157$2f7e8e17@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de> <CAOE4rSw_+PQEjAiHJkk03ec=J3ti9t9VCOD-zJSi=rP4dPnsjQ@mail.gmail.com> <pan$a7a0b$d1f1da3$f3b73157$2f7e8e17@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Freitag, 4. März 2016 12:31:44 CEST Duncan wrote:
> Dāvis Mosāns posted on Thu, 03 Mar 2016 17:39:12 +0200 as excerpted:
> > 2016-03-03 6:57 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
> >> You're issue isn't the same, because all your space was allocated,
> >> leaving only 1 MiB unallocated, which isn't normally enough to allocate
> >> a new chunk to rewrite the data or metadata from the old chunks into.
> >> 
> >> That's a known issue, with known workarounds as dealt with in the FAQ.
> > 
> > Ah, thanks, well it was surprising for me that balance failed with out
> > of space when both data and metadata had not all been used and I thought
> > it could just use space from those...
> > 
> > especially as from FAQ:
> >> If there is a lot of allocated but unused data or metadata chunks,
> >> a balance may reclaim some of that allocated space. This is the main
> >> reason for running a balance on a single-device filesystem.
> > 
> > so I think regular balance should be smart enough that it could solve
> > this on own and wouldn't need to specify any options.
> 
> Well it does solve the problem on its own... to the extent that it 
> eliminates empty chunks (kernel 3.17+, it didn't before that).  But if 
> there's even a single 4 KiB file block used in the (nominal 1 GiB sized 
> data) chunk, it's no longer empty and thus not eliminated by the empty 
> chunk cleanup routines.

It could theoretically copy part of one almost empty chunk into another chunk 
to free it up, couldn´t it? This way it can free some chunks completely and 
then start the regular balance?

In either case, its unintuitive for the user to fail this. The filesystem 
tools should allow a balance in *any* case without needing special treatment 
by the user.

Thanks,
-- 
Martin
