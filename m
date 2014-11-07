Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36485 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaKGNBe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Nov 2014 08:01:34 -0500
Received: by mail-lb0-f173.google.com with SMTP id n15so2606763lbi.4
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 05:01:32 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1415362515-4118-1-git-send-email-fdmanana@suse.com>
References: <1415362515-4118-1-git-send-email-fdmanana@suse.com>
Date: Fri, 7 Nov 2014 13:01:32 +0000
Message-ID: <CAL3q7H7h-3BA5Li9RE-Qi3gkdB3U_Vzx7a_vt9EtNidSb5NGyg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: avoid crash when overflowing a dir_item
From: Filipe David Manana <fdmanana@gmail.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 7, 2014 at 12:15 PM, Filipe Manana <fdmanana@suse.com> wrote:
> When attempting to insert a new dir_item, we were calling btrfs_extent_item()
> without checking if the leaf has enough space to extend the item. This made
> btrfs_extent_item() crash through a BUG() call.
> Therefore do the check and return ENOSPC if the leaf doesn't have enough space.

Please ignore, this isn't needed, because btrfs_insert_empty_item /
btrfs_search_slot gives us a leaf with enough space when they return
-eexist / 0 and -eoverflow otherwise.

>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/dir-item.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index fc8df86..65bf60e 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -53,6 +53,8 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
>                 di = btrfs_match_dir_item_name(root, path, name, name_len);
>                 if (di)
>                         return ERR_PTR(-EEXIST);
> +               if (btrfs_leaf_free_space(root, path->nodes[0]) < data_size)
> +                       return ERR_PTR(-ENOSPC);
>                 btrfs_extend_item(root, path, data_size);
>         } else if (ret < 0)
>                 return ERR_PTR(ret);
> --
> 1.9.1
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
