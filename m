Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:64840 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaFFMLT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 08:11:19 -0400
Received: by mail-la0-f51.google.com with SMTP id gf5so1449537lab.38
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 05:11:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1402035958-30013-1-git-send-email-bo.li.liu@oracle.com>
References: <1402035958-30013-1-git-send-email-bo.li.liu@oracle.com>
Date: Fri, 6 Jun 2014 13:11:17 +0100
Message-ID: <CAL3q7H7pYVLzaoLM6Je6dnDoHiACBAA0r_n1DGAWDuQJzJ7n3Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix leaf corruption after __btrfs_drop_extents
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, levin.front@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 6, 2014 at 7:25 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Several reports about leaf corruption has been floating on the list, one of them
> points to __btrfs_drop_extents(), and we find that the leaf becomes corrupted
> after __btrfs_drop_extents(), it's really a rare case but it does exist.
>
> The problem turns out to be btrfs_next_leaf() called in __btrfs_drop_extents().
>
> So in btrfs_next_leaf(), we release the current path to re-search the last key of
> the leaf for locating next leaf, and we've taken it into account that there might
> be balance operations between leafs during this 'unlock and re-lock' dance, so
> we check the path again and advance it if there are now more items available.
> But things are a bit different if that last key happens to be removed and balance
> gets a bigger key as the last one, and btrfs_search_slot will return it with
> ret > 0,

Hi Liu,

That makes a lot of sense outside the context of btrfs_drop_extents().

If I understand you correctly, you're saying that we have a file
extent item that gets deleted after we release the path in
btrfs_next_leaf and before btrfs_search_slot finishes for doing a
lookup for that item.

But who calls btrfs_drop_extents(), is supposed to have locked the
file range in the inode's io tree, right? Isn't the goal of locking
ranges in the io tree to serialize manipulation of file extent items
within a certain range? Unless there's some caller of _drop_extents()
that isn't locking the range in the io tree, I'm not seeing how we can
get the file extent item deleted or updated by another task.

Thanks

> IOW, nothing change in this leaf except the new last key, then we think
> we're okay because there is no more item balanced in, fine, we thinks we can
> go to the next leaf.
>
> However, we should return that bigger key, otherwise we deserve leaf corruption,
> for example, in endio, skipping that key means that __btrfs_drop_extents() thinks
> it has dropped all extent matched the required range and finish_ordered_io can
> safely insert a new extent, but it actually doesn't and ends up a leaf
> corruption.
>
> This takes the special case into account.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/ctree.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 1bcfcdb..bbb256c 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -5736,6 +5736,24 @@ again:
>                 ret = 0;
>                 goto done;
>         }
> +       /*
> +        * So the above check misses one case:
> +        * - after releasing the path above, someone has removed the item that
> +        *   used to be at the very end of the block, and balance between leafs
> +        *   gets another one with bigger key.offset to replace it.
> +        *
> +        * This one should be returned as well, or we can get leaf corruption
> +        * later(esp. in __btrfs_drop_extents()).
> +        *
> +        * And a bit more explanation about this check,
> +        * with ret > 0, the key isn't found, the path points to the slot
> +        * where it should be inserted, so the path->slots[0] item must be the
> +        * bigger one.
> +        */
> +       if (nritems > 0 && ret > 0 && path->slots[0] == nritems - 1) {
> +               ret = 0;
> +               goto done;
> +       }
>
>         while (level < BTRFS_MAX_LEVEL) {
>                 if (!path->nodes[level]) {
> --
> 1.8.1.4
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
