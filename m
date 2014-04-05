Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:54724 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaDESWc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 14:22:32 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so4926763wes.15
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 11:22:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1392930925-5348-1-git-send-email-fdmanana@gmail.com>
References: <1392930925-5348-1-git-send-email-fdmanana@gmail.com>
Date: Sat, 5 Apr 2014 21:22:30 +0300
Message-ID: <CAOcd+r0hKE9chaLdT59PrHDvsrjhs7JXJN+h8BYmtvaJ+0A5gg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: correctly determine if blocks are shared in btrfs_compare_trees
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,
Can you please explain more what is the scenario you are worried about.

Let's say we have two FS trees (subvolumes) subv1 and subv2, subv2
being a RO snapshot of subv1. And they have a shared subtree at
logical==X. Now we change subv1, so its subtree is COW'ed and some
other logical address (Y) is being allocated for subtree root. But X
still cannot be reused as long as subv2 exists. That's the essence of
the extent tree providing refcount for each tree/data block in the FS,
no?

Now finally we delete subv2 and block X is freed. So it can be
reallocated as a root of another subtree. And then it might be
snapshotted again and shared as before.
So where do you see a problem?

If we have two FS-tree subtrees starting at the same logical=X, how
can they be different? This means we allocated logical=X again, while
it was still in use, which is very very bad.

Am I missing something here?

Thanks,
Alex.

P.S.: by "logical" I (and hopefully you) mean the extent-tree level
addresses, i.e., if we have a tree block with logical=X, then we also
have an EXTENT_ITEM with key (X, EXTENT_ITEM, nodesize/leafsize).


On Fri, Feb 21, 2014 at 12:15 AM, Filipe David Borba Manana
<fdmanana@gmail.com> wrote:
> Just comparing the pointers (logical disk addresses) of the btree nodes is
> not completely bullet proof, we have to check if their generation numbers
> match too.
>
> It is guaranteed that a COW operation will result in a block with a different
> logical disk address than the original block's address, but over time we can
> reuse that former logical disk address.
>
> For example, creating a 2Gb filesystem on a loop device, and having a script
> running in a loop always updating the access timestamp of a file, resulted in
> the same logical disk address being reused for the same fs btree block in about
> only 4 minutes.
>
> This could make us skip entire subtrees when doing an incremental send (which
> is currently the only user of btrfs_compare_trees). However the odds of getting
> 2 blocks at the same tree level, with the same logical disk address, equal first
> slot keys and different generations, should hopefully be very low.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/ctree.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index cbd3a7d..88d1b1e 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -5376,6 +5376,8 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
>         int advance_right;
>         u64 left_blockptr;
>         u64 right_blockptr;
> +       u64 left_gen;
> +       u64 right_gen;
>         u64 left_start_ctransid;
>         u64 right_start_ctransid;
>         u64 ctransid;
> @@ -5640,7 +5642,14 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
>                                 right_blockptr = btrfs_node_blockptr(
>                                                 right_path->nodes[right_level],
>                                                 right_path->slots[right_level]);
> -                               if (left_blockptr == right_blockptr) {
> +                               left_gen = btrfs_node_ptr_generation(
> +                                               left_path->nodes[left_level],
> +                                               left_path->slots[left_level]);
> +                               right_gen = btrfs_node_ptr_generation(
> +                                               right_path->nodes[right_level],
> +                                               right_path->slots[right_level]);
> +                               if (left_blockptr == right_blockptr &&
> +                                   left_gen == right_gen) {
>                                         /*
>                                          * As we're on a shared block, don't
>                                          * allow to go deeper.
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
