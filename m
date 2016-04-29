Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbcD2Lqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 07:46:34 -0400
Date: Fri, 29 Apr 2016 13:46:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 13/16] btrfs: __set_extent_bit, try preallocation out of
 locked section with lighter gfp flags
Message-ID: <20160429114618.GZ29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1461920675.git.dsterba@suse.com>
 <06663d10e04cd3016ec41987c2e7275ca21ce80c.1461920675.git.dsterba@suse.com>
 <CAL3q7H6aeH7TcDmFo9tpcV-uKAUQv3AiEkL0bRsXXRUQ_CwGUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6aeH7TcDmFo9tpcV-uKAUQv3AiEkL0bRsXXRUQ_CwGUQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2016 at 11:00:34AM +0100, Filipe Manana wrote:
> On Fri, Apr 29, 2016 at 10:20 AM, David Sterba <dsterba@suse.com> wrote:
> > In __set_extent_bit we allocate with GFP_ATOMIC with the tree lock
> > held, this takes away allocator opportunities to satisfy the allocation.
> > In some cases we leave the locked section and we could repeat the
> > preallocation with less strict flags. It could lead to unnecessary
> > allocation, but we won't fail until we really need it.
> >
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/extent_io.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 8707bcc615ff..06ad442f6c03 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -1049,6 +1049,13 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >         spin_unlock(&tree->lock);
> >         if (gfpflags_allow_blocking(mask))
> >                 cond_resched();
> > +       /*
> > +        * If we used the preallocated state, try again here out of the
> > +        * locked section so we can avoid GFP_ATOMIC. No error checking
> > +        * as we might not need it in the end.
> > +        */
> > +       if (!prealloc)
> > +               prealloc = alloc_extent_state(mask);
> 
> Under the again label we already try to allocate in non atomic mode
> (gfpflags_allow_blocking() returns us true for GFP_NOFS), and some
> other patch in the series removes the BUG_ON() there.
> So this extra allocation attempt seems unnecessary to me. Or did I
> miss something?

No, you're right, I've duplicated the preallocation, the
gfpflags_allow_blocking check gets dropped in the last patch.

> At least I'm seeing the following in 4.5's gfp.h:
> 
> #define __GFP_DIRECT_RECLAIM ((__force gfp_t)___GFP_DIRECT_RECLAIM) /*
> Caller can reclaim */
> #define __GFP_RECLAIM ((__force
> gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
> #define GFP_NOFS (__GFP_RECLAIM | __GFP_IO)
> 
> static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
> {
>      return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
> }
> 
> So:
> 
> GFP_NOFS == ___GFP_DIRECT_RECLAIM | ___GFP_KSWAPD_RECLAIM | __GFP_IO
> __GFP_DIRECT_RECLAIM == ___GFP_DIRECT_RECLAIM
> 
> So, as we always use GFP_NOFS for the gfp flags value...
> 
> Some comment goes for the other similar patches.

I'll drop the patches, thanks for spotting it.
