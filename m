From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: kernel BUG at extent_map.c:275!
Date: Tue, 22 Jul 2008 10:35:43 -0400
Message-ID: <1216737343.18980.98.camel@shinybook.infradead.org>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
	 <1216697801.18980.40.camel@shinybook.infradead.org>
	 <1216722065.6932.125.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216722065.6932.125.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-07-22 at 06:21 -0400, Chris Mason wrote:
> What kind of box is this?  The current code should be fine on big
> endian, but that hasn't been tested recently.

It's a PowerBook (ppc32).

The bug is a BUG_ON(spin_trylock(&tree->lock)) in
lookup_extent_mapping() -- I didn't think endianness was a likely factor
in that.

Being uniprocessor might be though -- don't we hard-code spin_trylock()
to _always_ succeed on UP, unless spinlock debugging is enabled?

I think that test needs to happen only if spinlocks aren't no-ops. Or
have you moved past the point where you need it now, so can we just
remove it?

T'would be nice if lockdep or sparse could handle this for us -- we
already have annotations which indicate that a function 'acquires' or
'releases' locks. I wonder if we could also do 'requires'?

-- 
dwmw2

