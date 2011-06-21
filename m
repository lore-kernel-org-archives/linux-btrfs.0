From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Btrfs: save preloaded extent_state's in a percpu cache V2
Date: Tue, 21 Jun 2011 13:20:39 -0700
Message-ID: <m2sjr32ay0.fsf@firstfloor.org>
References: <1308670095-15480-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308670095-15480-1-git-send-email-josef@redhat.com> (Josef
	Bacik's message of "Tue, 21 Jun 2011 11:28:15 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <josef@redhat.com> writes:

> When doing DIO tracing I noticed we were doing a ton of allocations, a lot of
> the time for extent_states.  Some of the time we don't even use the prealloc'ed
> extent_state, it just get's free'd up.  So instead create a per-cpu cache like
> the radix tree stuff.  So we will check to see if our per-cpu cache has a
> prealloc'ed extent_state in it and if so we just continue, else we alloc a new
> one and fill the cache.  Then if we need to use a prealloc'ed extent_state we
> can just take it out of our per-cpu cache.  We will also refill the cache on
> free to try and limit the number of times we have to ask the allocator for
> caches.  With this patch dbench 50 goes from ~210 mb/s to ~260 mb/s.  Thanks,

You're just reimplementing a poor man's custom slab cache -- all of this is already
done in slab.

If the difference is really that big better fix slab and have everyone 
benefit?

Did you use slub or slab?
Did you analyze where the cycles are spent?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
