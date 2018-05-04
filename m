Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:38988 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbeEDBxN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 May 2018 21:53:13 -0400
Received: by mail-vk0-f67.google.com with SMTP id g83-v6so12488493vkc.6
        for <linux-btrfs@vger.kernel.org>; Thu, 03 May 2018 18:53:12 -0700 (PDT)
MIME-Version: 1.0
References: <1525261974-844-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1525261974-844-1-git-send-email-nborisov@suse.com>
From: Su Yue <damenly.su@gmail.com>
Date: Fri, 04 May 2018 01:53:01 +0000
Message-ID: <CABnRu55xed2wK+GtroAkTb0e4XQ5_jdcG0Gnddw9LwQBO62Tvg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Use exclude_super_stripes instead of account_super_bytes
To: nborisov@suse.com
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, osandov@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 2, 2018 at 7:55 PM Nikolay Borisov <nborisov@suse.com> wrote:

> Originally commit 2681e00f00fe ("btrfs-progs: check for matchingi
> free space in cache") added the account_super_bytes function to prevent
> false negative when running btrfs check. Turns out this function is
> really copied exclude_super_stripes, excluding the calls to
> exclude_super_stripes. Later commit e4797df6a9fa ("btrfs-progs: check
> the free space tree in btrfsck") introduced proper version of
> exclude_super_stripes. Instead of duplicating the function, just remove
> account_super_bytes and use exclude_super_stripes instead of the former.
> This also has the benefit of bringing the userspace code a bit closer
> to the kernel counterpart.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   extent-tree.c | 52 ++--------------------------------------------------
>   1 file changed, 2 insertions(+), 50 deletions(-)

> diff --git a/extent-tree.c b/extent-tree.c
> index ea205ccf4c30..391f0a784710 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -3164,54 +3164,6 @@ static int find_first_block_group(struct
btrfs_root *root,
>          return ret;
>   }

> -static void account_super_bytes(struct btrfs_fs_info *fs_info,
> -                               struct btrfs_block_group_cache *cache)
> -{
> -       u64 bytenr;
> -       u64 *logical;
> -       int stripe_len;
> -       int i, nr, ret;
> -
> -       if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
> -               stripe_len = BTRFS_SUPER_INFO_OFFSET -
cache->key.objectid;
> -               cache->bytes_super += stripe_len;
> -       }
> -
> -       for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> -               bytenr = btrfs_sb_offset(i);
> -               ret = btrfs_rmap_block(fs_info,
> -                                      cache->key.objectid, bytenr,
> -                                      0, &logical, &nr, &stripe_len);
> -               if (ret)
> -                       return;
> -
> -               while (nr--) {
> -                       u64 start, len;
> -
> -                       if (logical[nr] > cache->key.objectid +
> -                           cache->key.offset)
> -                               continue;
> -
> -                       if (logical[nr] + stripe_len <=
cache->key.objectid)
> -                               continue;
> -
> -                       start = logical[nr];
> -                       if (start < cache->key.objectid) {
> -                               start = cache->key.objectid;
> -                               len = (logical[nr] + stripe_len) - start;
> -                       } else {
> -                               len = min_t(u64, stripe_len,
> -                                           cache->key.objectid +
> -                                           cache->key.offset - start);
> -                       }
> -
> -                       cache->bytes_super += len;
> -               }
> -
> -               kfree(logical);
> -       }
> -}
> -
>   int btrfs_read_block_groups(struct btrfs_root *root)
>   {
>          struct btrfs_path *path;
> @@ -3287,7 +3239,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
>                  if (btrfs_chunk_readonly(info, cache->key.objectid))
>                          cache->ro = 1;

> -               account_super_bytes(info, cache);
> +               exclude_super_stripes(root, cache);

>                  ret = update_space_info(info, cache->flags,
found_key.offset,

btrfs_block_group_used(&cache->item),
> @@ -3331,7 +3283,7 @@ btrfs_add_block_group(struct btrfs_fs_info
*fs_info, u64 bytes_used, u64 type,
>          cache->flags = type;
>          btrfs_set_block_group_flags(&cache->item, type);

> -       account_super_bytes(fs_info, cache);
> +       exclude_super_stripes(fs_info->extent_root, cache);
>          ret = update_space_info(fs_info, cache->flags, size, bytes_used,
>                                  &cache->space_info);
>          BUG_ON(ret);
> --
> 2.7.4

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
