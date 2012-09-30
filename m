Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43129 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2I3L2Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 07:28:24 -0400
Received: by oagh16 with SMTP id h16so4240021oag.19
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Sep 2012 04:28:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
References: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
Date: Sun, 30 Sep 2012 13:28:23 +0200
Message-ID: <CAHf9xvbZTizo6nbDbX8vjbT2RrwzPm=JMm-ms2MB-SVVcDKRhQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
I guess I am missing something, but I thought btrfs_next_leaf() should
just jump to the next leaf (or item, if it was added meanwhile)
irrespective of the key that is in the last slot of the current leaf.
The change you added is effective when there is a next leaf, but you
refuse to go there unless its first key has the same objectid. (I
think you use the ctree property that the key in the first node/leaf
of a tree block is equal to its parent's key).
Can you pls explain why you insist on the same objectid?

Thanks,
Alex.


On Mon, Sep 24, 2012 at 10:02 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> Things like btrfs_drop_extents call btrfs_next_leaf to see if there is
> anything else they need on the next leaf.  This will result in a re-search,
> but if we are already at the last leaf in the tree or if the first item in
> the next leaf doesn't match the objectid of the one we want we can just
> return without doing the search at all.  This helps in things like fsync()
> where our tree is pretty shallow and we're likely to be on the last leaf
> often.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/ctree.c |   27 +++++++++++++++++++++++++++
>  fs/btrfs/ctree.h |    1 +
>  2 files changed, 28 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 6d183f6..64ea61c 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2441,6 +2441,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
>         lowest_level = p->lowest_level;
>         WARN_ON(lowest_level && ins_len > 0);
>         WARN_ON(p->nodes[0] != NULL);
> +       p->shecantgoanyfarthercapt = 1;
>
>         if (ins_len < 0) {
>                 lowest_unlock = 2;
> @@ -2568,6 +2569,13 @@ cow_done:
>
>                 if (level != 0) {
>                         int dec = 0;
> +
> +                       /*
> +                        * Slot is not the last in the node, we can go farther
> +                        * capt.
> +                        */
> +                       if (slot < btrfs_header_nritems(b))
> +                               p->shecantgoanyfarthercapt = 0;
>                         if (ret && slot > 0) {
>                                 dec = 1;
>                                 slot -= 1;
> @@ -5612,8 +5620,27 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>         nritems = btrfs_header_nritems(path->nodes[0]);
>         if (nritems == 0)
>                 return 1;
> +       if (path->shecantgoanyfarthercapt)
> +               return 1;
> +       if (!path->nodes[1])
> +               return 1;
>
>         btrfs_item_key_to_cpu(path->nodes[0], &key, nritems - 1);
> +
> +       /*
> +        * If we have the level above us locked already just check and see if
> +        * the key in the next leaf even has the same objectid, and if not
> +        * return 1 and avoid the search.
> +        */
> +       if (path->locks[1] &&
> +           path->slots[1] + 1 < btrfs_header_nritems(path->nodes[1])) {
> +               struct btrfs_key tmp;
> +
> +               btrfs_node_key_to_cpu(path->nodes[1], &tmp,
> +                                     path->slots[1] + 1);
> +               if (key.objectid != tmp.objectid)
> +                       return 1;
> +       }
>  again:
>         level = 1;
>         next = NULL;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 6f2e7e6..2e5c6c5 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -571,6 +571,7 @@ struct btrfs_path {
>         unsigned int skip_locking:1;
>         unsigned int leave_spinning:1;
>         unsigned int search_commit_root:1;
> +       unsigned int shecantgoanyfarthercapt:1;
>  };
>
>  /*
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
