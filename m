Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38204 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbdHUND1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:03:27 -0400
Received: by mail-oi0-f65.google.com with SMTP id j144so3471156oib.5
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 06:03:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503308630-6652-2-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com> <1503308630-6652-2-git-send-email-nborisov@suse.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 21 Aug 2017 16:02:46 +0300
Message-ID: <CAGqmi77R=sx+GR9MyNoD047+VEAb8KM-ZEC=C1sHfDXJRtV8xA@mail.gmail.com>
Subject: Re: [PATCH 01/10] btrfs: Remove chunk_objectid parameter of btrfs_alloc_dev_extent
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>

2017-08-21 12:43 GMT+03:00 Nikolay Borisov <nborisov@suse.com>:
> THe function is always called with chunk_objectid set to
> BTRFS_FIRST_CHUNK_TREE_OBJECTID. Let's collapse the parameter in the function
> itself. No functional changes
>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a37a31ba6843..63608c5f4487 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1571,8 +1571,8 @@ static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
>
>  static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>                                   struct btrfs_device *device,
> -                                 u64 chunk_tree, u64 chunk_objectid,
> -                                 u64 chunk_offset, u64 start, u64 num_bytes)
> +                                 u64 chunk_tree, u64 chunk_offset, u64 start,
> +                                 u64 num_bytes)
>  {
>         int ret;
>         struct btrfs_path *path;
> @@ -1600,7 +1600,8 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
>         extent = btrfs_item_ptr(leaf, path->slots[0],
>                                 struct btrfs_dev_extent);
>         btrfs_set_dev_extent_chunk_tree(leaf, extent, chunk_tree);
> -       btrfs_set_dev_extent_chunk_objectid(leaf, extent, chunk_objectid);
> +       btrfs_set_dev_extent_chunk_objectid(leaf, extent,
> +                                           BTRFS_FIRST_CHUNK_TREE_OBJECTID);
>         btrfs_set_dev_extent_chunk_offset(leaf, extent, chunk_offset);
>
>         btrfs_set_dev_extent_length(leaf, extent, num_bytes);
> @@ -4904,7 +4905,6 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>                         break;
>                 ret = btrfs_alloc_dev_extent(trans, device,
>                                              chunk_root->root_key.objectid,
> -                                            BTRFS_FIRST_CHUNK_TREE_OBJECTID,
>                                              chunk_offset, dev_offset,
>                                              stripe_size);
>                 if (ret)
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
