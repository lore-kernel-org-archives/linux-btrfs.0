Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36517 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932884AbcKXJ4V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 04:56:21 -0500
Received: by mail-io0-f193.google.com with SMTP id k19so4467001iod.3
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Nov 2016 01:56:20 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1479938294-3282-1-git-send-email-bo.li.liu@oracle.com>
References: <1479938294-3282-1-git-send-email-bo.li.liu@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 24 Nov 2016 09:56:19 +0000
Message-ID: <CAL3q7H7ideJggLC_q1ODGYRQx8A3k5DHW+b0cQBHPkAGaaApfA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Filipe Manana <fdmanana@suse.com>,
        Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2016 at 9:58 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> This can only happen with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y.
>
> Commit 1ba98d0 ("Btrfs: detect corruption when non-root leaf has zero item")
> assumes that a leaf is its root when leaf->bytenr == btrfs_root_bytenr(root),
> however, we should not use btrfs_root_bytenr(root) since it's mainly got
> updated during committing transaction.  So the check can fail when doing
> COW on this leaf while it is a root.
>
> This changes to use "if (leaf == btrfs_root_node(root))" instead, just like
> how we check whether leaf is a root in __btrfs_cow_block().
>
> Fixes: 1ba98d086fe3 (Btrfs: detect corruption when non-root leaf has zero item)
> Cc: stable@vger.kernel.org  # 4.8+
> Reported-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks Bo!

> ---
> v2: Tag itself for stable.
>
>  fs/btrfs/disk-io.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 9367c31..b401e6d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -572,13 +572,17 @@ static noinline int check_leaf(struct btrfs_root *root,
>                  * open_ctree() some roots has not yet been set up.
>                  */
>                 if (!IS_ERR_OR_NULL(check_root)) {
> +                       struct extent_buffer *eb;
> +
> +                       eb = btrfs_root_node(check_root);
>                         /* if leaf is the root, then it's fine */
> -                       if (leaf->start !=
> -                           btrfs_root_bytenr(&check_root->root_item)) {
> +                       if (leaf != eb) {
>                                 CORRUPT("non-root leaf's nritems is 0",
> -                                       leaf, root, 0);
> +                                       leaf, check_root, 0);
> +                               free_extent_buffer(eb);
>                                 return -EIO;
>                         }
> +                       free_extent_buffer(eb);
>                 }
>                 return 0;
>         }
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
