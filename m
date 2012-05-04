From: David Sterba <dave@jikos.cz>
Subject: Re: [BUG] sleeping function called from atomic context
Date: Fri, 4 May 2012 15:36:16 +0200
Message-ID: <20120504133615.GC19331@twin.jikos.cz>
References: <4FA3AD0B.7040500@giantdisaster.de>
 <20120504132536.GA25477@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Stefan Behrens <sbehrens@giantdisaster.de>,
	Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120504132536.GA25477@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 04, 2012 at 09:25:36AM -0400, Chris Mason wrote:
> I'm having a hard time reproducing this here.  Do you have lockdep on?
> It might tell us which lock we're leaving around.

He's using SLUB and it does not like waiting allocations when
CONFIG_SLUB_DEBUG is on:

 445 #ifdef CONFIG_SLUB_DEBUG
...
 935 /*
 936  * Hooks for other subsystems that check memory allocations. In a typical
 937  * production configuration these hooks all should produce no code at all.
 938  */
 939 static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 940 {
 941         flags &= gfp_allowed_mask;
 942         lockdep_trace_alloc(flags);
 943         might_sleep_if(flags & __GFP_WAIT);
 944
 945         return should_failslab(s->objsize, flags, s->flags);
 946 }
...
1223 #else
...
1259 static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
1260                                                         { return 0; }

where slab_pre_alloc_hook is called down the chain from kmem_cache_alloc.


david
