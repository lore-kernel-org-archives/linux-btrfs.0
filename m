Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:42976 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbaBFMbQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 07:31:16 -0500
Received: by mail-bk0-f50.google.com with SMTP id w16so615648bkz.9
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 04:31:14 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1391688149-2319-1-git-send-email-wangshilong1991@gmail.com>
References: <1391688149-2319-1-git-send-email-wangshilong1991@gmail.com>
Date: Thu, 6 Feb 2014 12:31:13 +0000
Message-ID: <CAL3q7H6RucFhxnHSywMyo0xpAjxwca6u5URT4wN4FunWV_i3dw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2 ] Btrfs: switch to btrfs_previous_extent_item()
From: Filipe David Manana <fdmanana@gmail.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 6, 2014 at 12:02 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> Since we have introduced btrfs_previous_extent_item() to search previous
> extent item, just switch into it.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Reviewed-by: Filipe Manana <fdmanana@gmail.com>

Thanks Shilong.

> ---
> Changelog:
> v1->v2:
>         set @found_key properly and fix return value(thanks to Filipe)
> ---
>  fs/btrfs/backref.c | 37 ++++++-------------------------------
>  1 file changed, 6 insertions(+), 31 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index c39891c..4dedb89 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1325,38 +1325,13 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
>         if (ret < 0)
>                 return ret;
>
> -       while (1) {
> -               u32 nritems;
> -               if (path->slots[0] == 0) {
> -                       btrfs_set_path_blocking(path);
> -                       ret = btrfs_prev_leaf(fs_info->extent_root, path);
> -                       if (ret != 0) {
> -                               if (ret > 0) {
> -                                       pr_debug("logical %llu is not within "
> -                                                "any extent\n", logical);
> -                                       ret = -ENOENT;
> -                               }
> -                               return ret;
> -                       }
> -               } else {
> -                       path->slots[0]--;
> -               }
> -               nritems = btrfs_header_nritems(path->nodes[0]);
> -               if (nritems == 0) {
> -                       pr_debug("logical %llu is not within any extent\n",
> -                                logical);
> -                       return -ENOENT;
> -               }
> -               if (path->slots[0] == nritems)
> -                       path->slots[0]--;
> -
> -               btrfs_item_key_to_cpu(path->nodes[0], found_key,
> -                                     path->slots[0]);
> -               if (found_key->type == BTRFS_EXTENT_ITEM_KEY ||
> -                   found_key->type == BTRFS_METADATA_ITEM_KEY)
> -                       break;
> +       ret = btrfs_previous_extent_item(fs_info->extent_root, path, 0);
> +       if (ret) {
> +               if (ret > 0)
> +                       ret = -ENOENT;
> +               return ret;
>         }
> -
> +       btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
>         if (found_key->type == BTRFS_METADATA_ITEM_KEY)
>                 size = fs_info->extent_root->leafsize;
>         else if (found_key->type == BTRFS_EXTENT_ITEM_KEY)
> --
> 1.8.4
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
