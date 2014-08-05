Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41643 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaHEMUg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 08:20:36 -0400
From: Russell Coker <russell@coker.com.au>
To: Duncan <1i5t5.duncan@cox.net>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with mkdir and rename
Date: Tue, 05 Aug 2014 22:20:33 +1000
Message-ID: <5484676.xyTNESz9qN@xev>
In-Reply-To: <pan$dbb9d$e1133995$a123d619$8316b9ab@cox.net>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <1875052.8GFlAMfPzL@quad> <pan$dbb9d$e1133995$a123d619$8316b9ab@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 Aug 2014 08:06:12 Duncan wrote:
> Which is why I'm not particularly happy with seeing all the "btrfs is 
> still not stable, use at your own risk" warnings disappearing.  With them 
> there, people who chose to run btrfs /could/ be expected to have done 
> their research and have btrfs specific knowledge such as this, because 
> btrfs was clearly marked as /not/ ready for "ordinary users" not prepared 
> to do such research on their own.
> 
> But now that those warnings are all being removed, btrfs should "just 
> work" for all those "ordinary users".
> 
> But it doesn't.  Btrfs is still special and requires btrfs-domain 
> specific knowledge to properly administer, as the fixes that would remove 
> that requirement, in this case perhaps a background thread that would 
> check for data/metadata imbalance and at least log a warning suggesting a 
> rebalance, if not triggering that rebalance on its own, simply aren't 
> there yet.

Currently the Debian/Jessie freeze is approaching.  The Debian kernel team 
have chosen 3.16 and don't have any plans for significant back-ports from 
later kernels.

Based on what I've read on this list it seems that BTRFS is less stable in 
3.15 than in 3.14.  Even 3.14 isn't something I'd recommend to random people 
who want something to just work.

The Debian installer has BTRFS in a list of filesystems to choose with no 
special notice about it.  I'm thinking of filing a Debian bug requesting that 
they put a warning against it.

What do people here think?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

