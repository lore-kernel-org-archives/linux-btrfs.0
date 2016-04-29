Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34950 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbcD2KAf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 06:00:35 -0400
Received: by mail-io0-f196.google.com with SMTP id u185so16848181iod.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 03:00:35 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <06663d10e04cd3016ec41987c2e7275ca21ce80c.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
	<06663d10e04cd3016ec41987c2e7275ca21ce80c.1461920675.git.dsterba@suse.com>
Date: Fri, 29 Apr 2016 11:00:34 +0100
Message-ID: <CAL3q7H6aeH7TcDmFo9tpcV-uKAUQv3AiEkL0bRsXXRUQ_CwGUQ@mail.gmail.com>
Subject: Re: [PATCH 13/16] btrfs: __set_extent_bit, try preallocation out of
 locked section with lighter gfp flags
From: Filipe Manana <fdmanana@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 29, 2016 at 10:20 AM, David Sterba <dsterba@suse.com> wrote:
> In __set_extent_bit we allocate with GFP_ATOMIC with the tree lock
> held, this takes away allocator opportunities to satisfy the allocation.
> In some cases we leave the locked section and we could repeat the
> preallocation with less strict flags. It could lead to unnecessary
> allocation, but we won't fail until we really need it.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8707bcc615ff..06ad442f6c03 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1049,6 +1049,13 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
>         spin_unlock(&tree->lock);
>         if (gfpflags_allow_blocking(mask))
>                 cond_resched();
> +       /*
> +        * If we used the preallocated state, try again here out of the
> +        * locked section so we can avoid GFP_ATOMIC. No error checking
> +        * as we might not need it in the end.
> +        */
> +       if (!prealloc)
> +               prealloc = alloc_extent_state(mask);

Under the again label we already try to allocate in non atomic mode
(gfpflags_allow_blocking() returns us true for GFP_NOFS), and some
other patch in the series removes the BUG_ON() there.
So this extra allocation attempt seems unnecessary to me. Or did I
miss something?

At least I'm seeing the following in 4.5's gfp.h:

#define __GFP_DIRECT_RECLAIM ((__force gfp_t)___GFP_DIRECT_RECLAIM) /*
Caller can reclaim */
#define __GFP_RECLAIM ((__force
gfp_t)(___GFP_DIRECT_RECLAIM|___GFP_KSWAPD_RECLAIM))
#define GFP_NOFS (__GFP_RECLAIM | __GFP_IO)

static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
{
     return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
}

So:

GFP_NOFS == ___GFP_DIRECT_RECLAIM | ___GFP_KSWAPD_RECLAIM | __GFP_IO
__GFP_DIRECT_RECLAIM == ___GFP_DIRECT_RECLAIM

So, as we always use GFP_NOFS for the gfp flags value...

Some comment goes for the other similar patches.



>         goto again;
>
>  out:
> --
> 2.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
