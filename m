Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36374 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdEQSzb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 14:55:31 -0400
Received: by mail-wr0-f193.google.com with SMTP id v42so3181454wrc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 11:55:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1495033663-15610-2-git-send-email-nborisov@suse.com>
References: <1495033663-15610-1-git-send-email-nborisov@suse.com> <1495033663-15610-2-git-send-email-nborisov@suse.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Wed, 17 May 2017 14:54:49 -0400
Message-ID: <CADfjVrg4jRCHEUHsYkFFFozDOK=XzoW1Qd0ghZNrGugrvQ1cCA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] btrfs: Refactor update_space_info
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        jeffm@suse.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

minor nitpicks in the comment

On Wed, May 17, 2017 at 11:07 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> Following the factoring out of the creation code udpate_space_info can only

" code, update_space_info "

> be called for already-existing space_info structs.

", which always succeeds"?

> Remove superfulous error
> handling and use the return value to return a pointer to the found space_info.
>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Reviewed-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 68 ++++++++++++++++++--------------------------------
>  1 file changed, 24 insertions(+), 44 deletions(-)
>
> Change since v1
>  - Incorporated Jeff Mahoney's feedback and added his reviewed-by tag
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 28848e45b018..3d5bf0b7f719 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3959,10 +3959,10 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags,
>         return ret;
>  }
>
> -static int update_space_info(struct btrfs_fs_info *info, u64 flags,
> -                            u64 total_bytes, u64 bytes_used,
> -                            u64 bytes_readonly,
> -                            struct btrfs_space_info **space_info)
> +static struct btrfs_space_info *update_space_info(struct btrfs_fs_info *info,
> +                                                                                                u64 flags, u64 total_bytes,
> +                                                                                                u64 bytes_used,
> +                                                                                                u64 bytes_readonly)
>  {
>         struct btrfs_space_info *found;
>         int factor;
> @@ -3974,21 +3974,21 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>                 factor = 1;
>
>         found = __find_space_info(info, flags);
> -       if (found) {
> -               spin_lock(&found->lock);
> -               found->total_bytes += total_bytes;
> -               found->disk_total += total_bytes * factor;
> -               found->bytes_used += bytes_used;
> -               found->disk_used += bytes_used * factor;
> -               found->bytes_readonly += bytes_readonly;
> -               if (total_bytes > 0)
> -                       found->full = 0;
> -               space_info_add_new_bytes(info, found, total_bytes -
> -                                        bytes_used - bytes_readonly);
> -               spin_unlock(&found->lock);
> -               *space_info = found;
> -               return 0;
> -       }
> +       BUG_ON(!found);
> +
> +       spin_lock(&found->lock);
> +       found->total_bytes += total_bytes;
> +       found->disk_total += total_bytes * factor;
> +       found->bytes_used += bytes_used;
> +       found->disk_used += bytes_used * factor;
> +       found->bytes_readonly += bytes_readonly;
> +       if (total_bytes > 0)
> +               found->full = 0;
> +       space_info_add_new_bytes(info, found, total_bytes -
> +                                bytes_used - bytes_readonly);
> +       spin_unlock(&found->lock);
> +
> +       return found;
>  }
>
>  static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
> @@ -10042,19 +10042,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>                 }
>
>                 trace_btrfs_add_block_group(info, cache, 0);
> -               ret = update_space_info(info, cache->flags, found_key.offset,
> -                                       btrfs_block_group_used(&cache->item),
> -                                       cache->bytes_super, &space_info);
> -               if (ret) {
> -                       btrfs_remove_free_space_cache(cache);
> -                       spin_lock(&info->block_group_cache_lock);
> -                       rb_erase(&cache->cache_node,
> -                                &info->block_group_cache_tree);
> -                       RB_CLEAR_NODE(&cache->cache_node);
> -                       spin_unlock(&info->block_group_cache_lock);
> -                       btrfs_put_block_group(cache);
> -                       goto error;
> -               }
> +               space_info = update_space_info(info, cache->flags, found_key.offset,
> +                                                                         btrfs_block_group_used(&cache->item),
> +                                                                         cache->bytes_super);
>
>                 cache->space_info = space_info;
>
> @@ -10212,18 +10202,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>          * the rbtree, update the space info's counters.
>          */
>         trace_btrfs_add_block_group(fs_info, cache, 1);
> -       ret = update_space_info(fs_info, cache->flags, size, bytes_used,
> -                               cache->bytes_super, &cache->space_info);
> -       if (ret) {
> -               btrfs_remove_free_space_cache(cache);
> -               spin_lock(&fs_info->block_group_cache_lock);
> -               rb_erase(&cache->cache_node,
> -                        &fs_info->block_group_cache_tree);
> -               RB_CLEAR_NODE(&cache->cache_node);
> -               spin_unlock(&fs_info->block_group_cache_lock);
> -               btrfs_put_block_group(cache);
> -               return ret;
> -       }
> +       cache->space_info = update_space_info(fs_info, cache->flags, size,
> +                                                                                bytes_used, cache->bytes_super);
>         update_global_block_rsv(fs_info);
>
>         __link_block_group(cache->space_info, cache);
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
