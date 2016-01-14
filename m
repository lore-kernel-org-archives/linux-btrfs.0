Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33693 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbcANJ5r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 04:57:47 -0500
Received: by mail-io0-f196.google.com with SMTP id f81so17143089iof.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 01:57:46 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1452761698-17301-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452761698-17301-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Thu, 14 Jan 2016 09:57:46 +0000
Message-ID: <CAL3q7H7XNrdrxKWfTmUGog3Oyunbwx3GTLxRBQKxnDYAUmkMuw@mail.gmail.com>
Subject: Re: [PATCH v4.1 12/18] btrfs: dedup: Add support for on-disk hash search
From: Filipe Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 8:54 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Now on-disk backend should be able to search hash now.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v4.1:
>    Fix a stupid typo where info->hash_type should be info->backend.
>    This makes on-disk backend almost unable to dedup.

Having test cases (xfstests) would avoid such simple errors... wouldn't it?
As in the reply I just sent for another patch:

"Take a look at the good example of xfs development. For example when
all the recent patches for their reflink implementation was posted
(and before getting merged), a comprehensive set of test cases for
xfstests was also posted..."

Test cases are a good thing :)

>
> ---
>  fs/btrfs/dedup.c | 145 +++++++++++++++++++++++++++++++++++++++++++++++--------
>  fs/btrfs/dedup.h |   3 ++
>  2 files changed, 127 insertions(+), 21 deletions(-)
>
> diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
> index c97823f..bee9589 100644
> --- a/fs/btrfs/dedup.c
> +++ b/fs/btrfs/dedup.c
> @@ -482,6 +482,79 @@ int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
>  }
>
>  /*
> + * Return 0 for not found
> + * Return >0 for found and set bytenr_ret
> + * Return <0 for error
> + */
> +static int ondisk_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash,
> +                             u64 *bytenr_ret, u32 *num_bytes_ret)
> +{
> +       struct btrfs_path *path;
> +       struct btrfs_key key;
> +       struct btrfs_root *dedup_root = dedup_info->dedup_root;
> +       u8 *buf = NULL;
> +       u64 hash_key;
> +       int hash_len = btrfs_dedup_sizes[dedup_info->hash_type];
> +       int ret;
> +
> +       path = btrfs_alloc_path();
> +       if (!path)
> +               return -ENOMEM;
> +
> +       buf = kmalloc(hash_len, GFP_NOFS);
> +       if (!buf) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       memcpy(&hash_key, hash + hash_len - 8, 8);
> +       key.objectid = hash_key;
> +       key.type = BTRFS_DEDUP_HASH_ITEM_KEY;
> +       key.offset = (u64)-1;
> +
> +       ret = btrfs_search_slot(NULL, dedup_root, &key, path, 0, 0);
> +       if (ret < 0)
> +               goto out;
> +       WARN_ON(ret == 0);
> +       while (1) {
> +               struct extent_buffer *node;
> +               struct btrfs_dedup_hash_item *hash_item;
> +               int slot;
> +
> +               ret = btrfs_previous_item(dedup_root, path, hash_key,
> +                                         BTRFS_DEDUP_HASH_ITEM_KEY);
> +               if (ret < 0)
> +                       goto out;
> +               if (ret > 0) {
> +                       ret = 0;
> +                       goto out;
> +               }
> +
> +               node = path->nodes[0];
> +               slot = path->slots[0];
> +               btrfs_item_key_to_cpu(node, &key, slot);
> +
> +               if (key.type != BTRFS_DEDUP_HASH_ITEM_KEY ||
> +                   memcmp(&key.objectid, hash + hash_len - 8, 8))
> +                       break;
> +               hash_item = btrfs_item_ptr(node, slot,
> +                               struct btrfs_dedup_hash_item);
> +               read_extent_buffer(node, buf, (unsigned long)(hash_item + 1),
> +                                  hash_len);
> +               if (!memcmp(buf, hash, hash_len)) {
> +                       ret = 1;
> +                       *bytenr_ret = key.offset;
> +                       *num_bytes_ret = btrfs_dedup_hash_len(node, hash_item);
> +                       break;
> +               }
> +       }
> +out:
> +       kfree(buf);
> +       btrfs_free_path(path);
> +       return ret;
> +}
> +
> +/*
>   * Caller must ensure the corresponding ref head is not being run.
>   */
>  static struct inmem_hash *
> @@ -511,7 +584,34 @@ inmem_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash)
>         return NULL;
>  }
>
> -static int inmem_search(struct inode *inode, u64 file_pos,
> +/* Wrapper for different backends, caller needs to hold dedup_info->lock */
> +static inline int generic_search_hash(struct btrfs_dedup_info *dedup_info,
> +                                     u8 *hash, u64 *bytenr_ret,
> +                                     u32 *num_bytes_ret)
> +{
> +       if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY) {
> +               struct inmem_hash *found_hash;
> +               int ret;
> +
> +               found_hash = inmem_search_hash(dedup_info, hash);
> +               if (found_hash) {
> +                       ret = 1;
> +                       *bytenr_ret = found_hash->bytenr;
> +                       *num_bytes_ret = found_hash->num_bytes;
> +               } else {
> +                       ret = 0;
> +                       *bytenr_ret = 0;
> +                       *num_bytes_ret = 0;
> +               }
> +               return ret;
> +       } else if (dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK) {
> +               return ondisk_search_hash(dedup_info, hash, bytenr_ret,
> +                                         num_bytes_ret);
> +       }
> +       return -EINVAL;
> +}
> +
> +static int generic_search(struct inode *inode, u64 file_pos,
>                         struct btrfs_dedup_hash *hash)
>  {
>         int ret;
> @@ -520,9 +620,9 @@ static int inmem_search(struct inode *inode, u64 file_pos,
>         struct btrfs_trans_handle *trans;
>         struct btrfs_delayed_ref_root *delayed_refs;
>         struct btrfs_delayed_ref_head *head;
> -       struct inmem_hash *found_hash;
>         struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
>         u64 bytenr;
> +       u64 tmp_bytenr;
>         u32 num_bytes;
>
>         trans = btrfs_join_transaction(root);
> @@ -531,14 +631,9 @@ static int inmem_search(struct inode *inode, u64 file_pos,
>
>  again:
>         mutex_lock(&dedup_info->lock);
> -       found_hash = inmem_search_hash(dedup_info, hash->hash);
> -       /* If we don't find a duplicated extent, just return. */
> -       if (!found_hash) {
> -               ret = 0;
> +       ret = generic_search_hash(dedup_info, hash->hash, &bytenr, &num_bytes);
> +       if (ret <= 0)
>                 goto out;
> -       }
> -       bytenr = found_hash->bytenr;
> -       num_bytes = found_hash->num_bytes;
>
>         delayed_refs = &trans->transaction->delayed_refs;
>
> @@ -574,13 +669,21 @@ again:
>                 goto again;
>
>         mutex_lock(&dedup_info->lock);
> -       /* Search again to ensure the hash is still here */
> -       found_hash = inmem_search_hash(dedup_info, hash->hash);
> -       if (!found_hash) {
> -               ret = 0;
> +       /*
> +        * Search again to ensure the hash is still here and bytenr didn't
> +        * change
> +        */
> +       ret = generic_search_hash(dedup_info, hash->hash, &tmp_bytenr,
> +                                 &num_bytes);
> +       if (ret <= 0) {
>                 mutex_unlock(&head->mutex);
>                 goto out;
>         }
> +       if (tmp_bytenr != bytenr) {
> +               mutex_unlock(&head->mutex);
> +               mutex_unlock(&dedup_info->lock);
> +               goto again;
> +       }
>         hash->bytenr = bytenr;
>         hash->num_bytes = num_bytes;
>
> @@ -609,15 +712,15 @@ int btrfs_dedup_search(struct inode *inode, u64 file_pos,
>         if (WARN_ON(!dedup_info || !hash))
>                 return 0;
>
> -       if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
> -               ret = inmem_search(inode, file_pos, hash);
> -
> -       /* It's possible hash->bytenr/num_bytenr already changed */
> -       if (ret == 0) {
> -               hash->num_bytes = 0;
> -               hash->bytenr = 0;
> +       if (dedup_info->backend < BTRFS_DEDUP_BACKEND_LAST) {
> +               ret = generic_search(inode, file_pos, hash);
> +               if (ret == 0) {
> +                       hash->num_bytes = 0;
> +                       hash->bytenr = 0;
> +               }
> +               return ret;
>         }
> -       return ret;
> +       return -EINVAL;
>  }
>
>  static int hash_data(struct btrfs_dedup_info *dedup_info, const char *data,
> diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
> index f23053c..3c08b86 100644
> --- a/fs/btrfs/dedup.h
> +++ b/fs/btrfs/dedup.h
> @@ -137,6 +137,9 @@ int btrfs_dedup_calc_hash(struct btrfs_root *root, struct inode *inode,
>   * *INCREASED*, and hash->bytenr/num_bytes will record the existing
>   * extent data.
>   * Return 0 for a hash miss. Nothing is done
> + * Return <0 for error.
> + *
> + * Only on-disk backedn may return error though.
>   */
>  int btrfs_dedup_search(struct inode *inode, u64 file_pos,
>                        struct btrfs_dedup_hash *hash);
> --
> 2.7.0
>
>
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
