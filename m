From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at extent_map.c:275!
Date: Tue, 22 Jul 2008 13:03:55 -0400
Message-ID: <1216746235.6932.129.camel@think.oraclecorp.com>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
	 <1216697801.18980.40.camel@shinybook.infradead.org>
	 <1216722065.6932.125.camel@think.oraclecorp.com>
	 <1216737343.18980.98.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216737343.18980.98.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-07-22 at 10:35 -0400, David Woodhouse wrote:
> On Tue, 2008-07-22 at 06:21 -0400, Chris Mason wrote:
> > What kind of box is this?  The current code should be fine on big
> > endian, but that hasn't been tested recently.
> 
> It's a PowerBook (ppc32).
> 
> The bug is a BUG_ON(spin_trylock(&tree->lock)) in
> lookup_extent_mapping() -- I didn't think endianness was a likely factor
> in that.

I think the caller is doing this:

        spin_lock(&map_tree->map_tree.lock);
        em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
        spin_unlock(&map_tree->map_tree.lock);

> Being uniprocessor might be though -- don't we hard-code spin_trylock()
> to _always_ succeed on UP, unless spinlock debugging is enabled?
> 
> I think that test needs to happen only if spinlocks aren't no-ops. Or
> have you moved past the point where you need it now, so can we just
> remove it?
> 

Well, the test is there to make sure the caller is doing the right
thing.  Before we remove it, I'd like to understand why it is failing.

-chris


