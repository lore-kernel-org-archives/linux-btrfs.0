Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161404AbcBQPLV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 10:11:21 -0500
Date: Wed, 17 Feb 2016 16:11:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Avoid BUG_ON()s because of ENOMEM caused by
 kmalloc() failure
Message-ID: <20160217151113.GT4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56C16441.5030000@jp.fujitsu.com>
 <20160215175333.GO4374@twin.jikos.cz>
 <56C40B0F.3090209@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C40B0F.3090209@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 17, 2016 at 02:54:23PM +0900, Satoru Takeuchi wrote:
> On 2016/02/16 2:53, David Sterba wrote:
> > On Mon, Feb 15, 2016 at 02:38:09PM +0900, Satoru Takeuchi wrote:
> >> There are some BUG_ON()'s after kmalloc() as follows.
> >>
> >> =====
> >> foo = kmalloc();
> >> BUG_ON(!foo);	/* -ENOMEM case */
> >> =====
> >>
> >> A Docker + memory cgroup user hit these BUG_ON()s.
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=112101
> >>
> >> Since it's very hard to handle these ENOMEMs properly,
> >> preventing these kmalloc() failures to avoid these
> >> BUG_ON()s for now, are a bit better than the current
> >> implementation anyway.
> >
> > Beware that the NOFAIL semantics is can cause deadlocks if it's on the
> > critical writeback path or and can be reentered from itself through the
> > reclaim. Unless you're sure that this is not the case, please do not add
> > them just because it would seemingly fix the allocation failures.
> 
> About the all cases I changed, kmalloc()s can block
> since gfp_flags_allow_blocking() are true. Then no locks
> are acquired here and deadlocks don't happen.
> 
> Am I missing something?

Waiting as in GFP_WAIT is not the same as GFP_NOFAIL that can wait
indefinetelly. The locking of NOFAIL is implied. The kmalloc callsite
will block until there's memory available. If another thread of btrfs
waits for this code to progress, it will block as well.

> > In the docker example, the memory is limited by cgroups so the NOFAIL
> > mode can exhaust all reserves and just loop endlessly waiting for the
> > OOM killer to get some memory or just waiting without any chance to
> > progress.
> 
> I consider triggering OOM killer and killing processes
> in a cgroup are better than killing whole system.

The action of OOM killer is not a problem. The cgroup memory limit can
be low or all the memory is unreclaimable. At this point btrfs code will
block.


> About the possibility of endless loop, there are many
> such problems in the whole kernel. Of course it can be
> said to Btrfs.

Many? Examples? In this context we're talking about endless loops caused
by non-failing allocations.

> ==========================================
> $ grep -rnH __GFP_NOFAIL fs/btrfs/
> fs/btrfs/extent-tree.c:5970: GFP_NOFS | __GFP_NOFAIL);
> fs/btrfs/extent-tree.c:6043: bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
> fs/btrfs/extent_io.c:4643: eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS|__GFP_NOFAIL);
> fs/btrfs/extent_io.c:4909: p = find_or_create_page(mapping, index, GFP_NOFS|__GFP_NOFAIL);
> ==========================================

I'm aware of the existing NOFAIL allocations. There are two at
extent_buffer allocation time, added recently and provoked by the
intended changes to memory allocator that would fail the GFP_NOFS
allocations.

The other two are from year 2010, set_extent_bit, IMHO added so the
error handling does not get complicated and expressing "we don't want to
fail here". But there are many other calls to set_extent_bit that could
fail. This is inconsistent and should be unified. In a way that we're
sure that we're not introducing potential hangs.

> I understand fixing these problems cooperate with
> memory cgroup guys is the best in the long run.

It's not about cgroups, btrfs needs to ideally handle all memory
allocation failures in a way that uses some sort of fallbacks but still
can lead to a transaction abort if there's simply no memory left.

> However, I consider bypassing this problem for now
> is better than the current implementation.

It's more like replacing one problem with another. With every new
NOFAIL, one has to think about the runtime interactions with the others.
I'd rather see this fixed with a particular call path in mind or class,
eg. the extent_map bit settings, than throwing NOFAIL at places that
somebody accidentally hit.

As a temporary fix we can add __GFP_HIGH to the interesting sites so we
can get access to the emergency reserves, and this is on my list of
things to do after the NOFS -> KERNEL updates are done.
