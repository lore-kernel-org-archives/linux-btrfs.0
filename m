Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49574 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaKWVRO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 16:17:14 -0500
Date: Sun, 23 Nov 2014 13:16:50 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Message-ID: <20141123211650.GU8916@merlins.org>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
 <20141122222606.GO8916@merlins.org>
 <CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
 <20141123000503.GQ32735@carfax.org.uk>
 <20141123010742.GA16599@merlins.org>
 <pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 23, 2014 at 07:52:29AM +0000, Duncan wrote:
> > Right. So, why would you rebalance empty chunks or near empty chunks?
> > Don't you want to rebalance almost full chunks first, and work you way
> > to less and less full as needed?
> 
> No, the closer to empty a chunk is, the more effect you can get in 
> rebalancing it along with others of the same fullness.
 
Ok, now I see what I was thinking the wrong way around:
Rebalancing is not rebalancing data within a chunk, optimizing some tree 
data structure.

Rebalancing is taking a nearly empty chunk and merging it with other
chunks to free up that chunkspace.

So, -dusage=10 only picks chunks that are 10% used or less, and tries
to free them up by putting their data elsewhere.

Did I get it right this time? :)

> IOW, rewriting 20 95% usage chunks to 19, freeing just one, is going to 
> take you nearly 20 times as long as rewriting 20 5% usage chunks, freeing 
> 19 of them, since in the latter case you're actually only rewriting one 
> full chunk's worth of data or metadata.

Right, that makes sense.
 
> OK, so what /is/ the effect of a fuller filesystem?  Simply this.  As the 
> filesystem fills up, there's less and less fully free unallocated space 
> available even after a full balance, meaning that free space can be used 
> up with fewer and fewer chunk allocations, so you have to rebalance more 
> and more often to keep what's left from getting out of balance and 
> running into ENOSPC conditions.

Yes, been there, done that :)
 
> But, beware!  Just because your filesystem is say 55% full (number from 
> your example earlier), does **NOT** mean usage=55 is the best number to 
> use.  That may well be the case, or it may not.  There's simply no 
> necessarily direct correlation in that regard, and a recommended N for 
> usage=N cannot be determined without a LOT more use-case information than 
> simply knowing the filesystem is at 55% capacity.

Yeah, I remember that. I'm ok with using the same number but I
understand it's not a given that it's the perfect number.
 
> So the 55% filesystem capacity would probably inform my choice of jumps, 
> say 20% at a time, but I'd still start much lower and jump at that 20% or 
> so at a time.

That makes sense. I'll try to synthetize all this and rewrite my blog
post and the wiki to make this clearer.
 
Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
