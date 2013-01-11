Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34798 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3AKIrZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 03:47:25 -0500
Date: Fri, 11 Jan 2013 16:45:06 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: add leak debug for extent map
Message-ID: <20130111084504.GA2008@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1357656561-24604-1-git-send-email-bo.li.liu@oracle.com>
 <20130108200734.GD12288@lenny.home.zabbo.net>
 <20130110020517.GA4456@liubo>
 <20130110170634.GF12288@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130110170634.GF12288@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 09:06:34AM -0800, Zach Brown wrote:
> > > Hmm, I guess it's cool to get the allocation-specific decoding which you
> > > don't get from the generic kernel leak tracking?
> 
> I mean that by doing this in btrfs, instead of doing it generically in
> the allocator, you get specific knowledge that btrfs knows about the
> allocated objects:
> 
> > > > +		printk(KERN_ERR "btrfs ext map leak: start %llu len %llu block %llu flags %llu refs %d in tree %d compress %d\n",
> > > > +			em->start, em->len, em->block_start, em->flags, atomic_read(&em->refs), em->in_tree, em->compress_type);
> 
> That's valuable.  I understand that it's quick and easy to implement
> this in btrfs.  It's hard to argue with working code.
> 
> But the right way to do this would be to add a callback that
> kmem_cache_destroy() can use to generate debugging output for the
> allocated objects.  Maybe you have a registration function that sets the
> callback on the slab?  Slab already has tracking of allocated objects so
> you could always have this leak output on without runtime overhead.
> 
> And, of course, other callers can easy also get this functionality
> instead of having to mess around with all the stuff btrfs did: ifdefs,
> locks, and lists.
> 
> - z

Yeah, adding a callback here is really a more graceful way!

But after flipping slab code, I find that another callback will disable
merging slabs when allocating a slab, so I'm not sure if it worth doing so...

What do you think about it?

thanks,
liubo
