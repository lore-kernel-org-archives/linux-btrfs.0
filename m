Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:51289 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3KHOKu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 09:10:50 -0500
Received: by mail-bk0-f48.google.com with SMTP id u10so746130bkz.7
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 06:10:49 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1383072762-3286-1-git-send-email-jbacik@fusionio.com>
References: <1383072762-3286-1-git-send-email-jbacik@fusionio.com>
Date: Fri, 8 Nov 2013 14:10:48 +0000
Message-ID: <CAL3q7H7muFtjNtqiRLWi-y12e_L6ZQyyqMEoqAgdb3SNN99uag@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: incompatible format change to remove hole extents V3
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 29, 2013 at 6:52 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> Btrfs has always had these filler extent data items for holes in inodes.  This
> has made somethings very easy, like logging hole punches and sending hole
> punches.  However for large holey files these extent data items are pure
> overhead.  So add an incompatible feature to no longer add hole extents to
> reduce the amount of metadata used by these sort of files.  This has a few
> changes for logging and send obviously since they will need to detect holes and
> log/send the holes if there are any.  I've tested this thoroughly with xfstests
> and it doesn't cause any issues with and without the incompat format set.
> Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V2->V3: If we share the leaf with the extents then we will think there is a hole
> when there really isn't, so make us always look back at what the last extent was
> if we haven't set the last extent yet.
>
>  fs/btrfs/ctree.h    |   4 +-
>  fs/btrfs/file.c     |  13 +++--
>  fs/btrfs/inode.c    |  78 +++++++++++++++----------
>  fs/btrfs/send.c     | 162 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/tree-log.c |  56 ++++++++++++++++--
>  5 files changed, 263 insertions(+), 50 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9f5e1cf..0a008d8 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -521,6 +521,7 @@ struct btrfs_super_block {
>  #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF   (1ULL << 6)
>  #define BTRFS_FEATURE_INCOMPAT_RAID56          (1ULL << 7)
>  #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA (1ULL << 8)
> +#define BTRFS_FEATURE_INCOMPAT_NO_HOLES                (1ULL << 9)
>
>  #define BTRFS_FEATURE_COMPAT_SUPP              0ULL
>  #define BTRFS_FEATURE_COMPAT_RO_SUPP           0ULL
> @@ -532,7 +533,8 @@ struct btrfs_super_block {
>          BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |          \
>          BTRFS_FEATURE_INCOMPAT_RAID56 |                \
>          BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |         \
> -        BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
> +        BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |       \
> +        BTRFS_FEATURE_INCOMPAT_NO_HOLES)
>
>  /*
>   * A leaf is full of items. offset and size tell us where to find
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 728f56f..ec0a95a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1963,11 +1963,13 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
>         struct btrfs_key key;
>         int ret;
>
> +       if (btrfs_fs_incompat(root->fs_info, NO_HOLES))
> +               goto out;
> +
>         key.objectid = btrfs_ino(inode);
>         key.type = BTRFS_EXTENT_DATA_KEY;
>         key.offset = offset;
>
> -
>         ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
>         if (ret < 0)
>                 return ret;
> @@ -2064,8 +2066,10 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>         u64 drop_end;
>         int ret = 0;
>         int err = 0;
> +       int rsv_count;
>         bool same_page = ((offset >> PAGE_CACHE_SHIFT) ==
>                           ((offset + len - 1) >> PAGE_CACHE_SHIFT));
> +       bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
>
>         btrfs_wait_ordered_range(inode, offset, len);
>
> @@ -2157,9 +2161,10 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>         /*
>          * 1 - update the inode
>          * 1 - removing the extents in the range
> -        * 1 - adding the hole extent
> +        * 1 - adding the hole extent if no_holes isn't set
>          */
> -       trans = btrfs_start_transaction(root, 3);
> +       rsv_count = no_holes ? 2 : 3;
> +       trans = btrfs_start_transaction(root, rsv_count);
>         if (IS_ERR(trans)) {
>                 err = PTR_ERR(trans);
>                 goto out_free;
> @@ -2196,7 +2201,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>                 btrfs_end_transaction(trans, root);
>                 btrfs_btree_balance_dirty(root);
>
> -               trans = btrfs_start_transaction(root, 3);
> +               trans = btrfs_start_transaction(root, rsv_count);
>                 if (IS_ERR(trans)) {
>                         ret = PTR_ERR(trans);
>                         trans = NULL;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 30bdacd..38fa301 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4204,6 +4204,49 @@ out:
>         return ret;
>  }
>
> +static int maybe_insert_hole(struct btrfs_root *root, struct inode *inode,
> +                            u64 offset, u64 len)
> +{
> +       struct btrfs_trans_handle *trans;
> +       int ret;
> +
> +       /*
> +        * Still need to make sure the inode looks like it's been updated so
> +        * that any holes get logged if we fsync.
> +        */
> +       if (btrfs_fs_incompat(root->fs_info, NO_HOLES)) {
> +               BTRFS_I(inode)->last_trans = root->fs_info->generation;
> +               BTRFS_I(inode)->last_sub_trans = root->log_transid;
> +               BTRFS_I(inode)->last_log_commit = root->last_log_commit;
> +               return 0;
> +       }
> +
> +       /*
> +        * 1 - for the one we're dropping
> +        * 1 - for the one we're adding
> +        * 1 - for updating the inode.
> +        */
> +       trans = btrfs_start_transaction(root, 3);
> +       if (IS_ERR(trans))
> +               return PTR_ERR(trans);
> +
> +       ret = btrfs_drop_extents(trans, root, inode, offset, offset + len, 1);
> +       if (ret) {
> +               btrfs_abort_transaction(trans, root, ret);
> +               btrfs_end_transaction(trans, root);
> +               return ret;
> +       }
> +
> +       ret = btrfs_insert_file_extent(trans, root, btrfs_ino(inode), offset,
> +                                      0, 0, len, 0, len, 0, 0, 0);
> +       if (ret)
> +               btrfs_abort_transaction(trans, root, ret);
> +       else
> +               btrfs_update_inode(trans, root, inode);
> +       btrfs_end_transaction(trans, root);
> +       return ret;
> +}
> +
>  /*
>   * This function puts in dummy file extents for the area we're creating a hole
>   * for.  So if we are truncating this file to a larger size we need to insert
> @@ -4212,7 +4255,6 @@ out:
>   */
>  int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>  {
> -       struct btrfs_trans_handle *trans;
>         struct btrfs_root *root = BTRFS_I(inode)->root;
>         struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
>         struct extent_map *em = NULL;
> @@ -4267,31 +4309,10 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>                         struct extent_map *hole_em;
>                         hole_size = last_byte - cur_offset;
>
> -                       trans = btrfs_start_transaction(root, 3);
> -                       if (IS_ERR(trans)) {
> -                               err = PTR_ERR(trans);
> -                               break;
> -                       }
> -
> -                       err = btrfs_drop_extents(trans, root, inode,
> -                                                cur_offset,
> -                                                cur_offset + hole_size, 1);
> -                       if (err) {
> -                               btrfs_abort_transaction(trans, root, err);
> -                               btrfs_end_transaction(trans, root);
> -                               break;
> -                       }
> -
> -                       err = btrfs_insert_file_extent(trans, root,
> -                                       btrfs_ino(inode), cur_offset, 0,
> -                                       0, hole_size, 0, hole_size,
> -                                       0, 0, 0);
> -                       if (err) {
> -                               btrfs_abort_transaction(trans, root, err);
> -                               btrfs_end_transaction(trans, root);
> +                       err = maybe_insert_hole(root, inode, cur_offset,
> +                                               hole_size);
> +                       if (err)
>                                 break;
> -                       }
> -
>                         btrfs_drop_extent_cache(inode, cur_offset,
>                                                 cur_offset + hole_size - 1, 0);
>                         hole_em = alloc_extent_map();
> @@ -4310,7 +4331,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>                         hole_em->ram_bytes = hole_size;
>                         hole_em->bdev = root->fs_info->fs_devices->latest_bdev;
>                         hole_em->compress_type = BTRFS_COMPRESS_NONE;
> -                       hole_em->generation = trans->transid;
> +                       hole_em->generation = root->fs_info->generation;
>
>                         while (1) {
>                                 write_lock(&em_tree->lock);
> @@ -4323,17 +4344,14 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>                                                         hole_size - 1, 0);
>                         }
>                         free_extent_map(hole_em);
> -next:
> -                       btrfs_update_inode(trans, root, inode);
> -                       btrfs_end_transaction(trans, root);
>                 }
> +next:
>                 free_extent_map(em);
>                 em = NULL;
>                 cur_offset = last_byte;
>                 if (cur_offset >= block_end)
>                         break;
>         }
> -
>         free_extent_map(em);
>         unlock_extent_cached(io_tree, hole_start, block_end - 1, &cached_state,
>                              GFP_NOFS);
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5a3874c..9a1c480 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -111,6 +111,7 @@ struct send_ctx {
>         int cur_inode_deleted;
>         u64 cur_inode_size;
>         u64 cur_inode_mode;
> +       u64 cur_inode_last_extent;
>
>         u64 send_progress;
>
> @@ -146,6 +147,13 @@ struct name_cache_entry {
>         char name[];
>  };
>
> +static int need_send_hole(struct send_ctx *sctx)
> +{
> +       return (sctx->parent_root && !sctx->cur_inode_new &&
> +               !sctx->cur_inode_new_gen && !sctx->cur_inode_deleted &&
> +               S_ISREG(sctx->cur_inode_mode));
> +}
> +
>  static void fs_path_reset(struct fs_path *p)
>  {
>         if (p->reversed) {
> @@ -3776,6 +3784,43 @@ out:
>         return ret;
>  }
>
> +static int send_hole(struct send_ctx *sctx, u64 end)
> +{
> +       struct fs_path *p = NULL;
> +       u64 offset = sctx->cur_inode_last_extent;
> +       u64 len;
> +       int ret;
> +
> +       p = fs_path_alloc();
> +       if (!p)
> +               return -ENOMEM;
> +       ret = open_cur_inode_file(sctx);
> +       if (ret < 0)
> +               goto out;
> +       memset(sctx->read_buf, 0, BTRFS_SEND_READ_SIZE);
> +       while (offset < end) {
> +               len = min_t(u64, end - offset, BTRFS_SEND_READ_SIZE);
> +
> +               ret = begin_cmd(sctx, BTRFS_SEND_C_WRITE);
> +               if (ret < 0)
> +                       break;
> +               ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
> +               if (ret < 0)
> +                       break;
> +               TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
> +               TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
> +               TLV_PUT(sctx, BTRFS_SEND_A_DATA, sctx->read_buf, len);
> +               ret = send_cmd(sctx);
> +               if (ret < 0)
> +                       break;
> +               offset += len;
> +       }
> +tlv_put_failure:
> +out:
> +       fs_path_free(p);
> +       return ret;
> +}
> +
>  static int send_write_or_clone(struct send_ctx *sctx,
>                                struct btrfs_path *path,
>                                struct btrfs_key *key,
> @@ -4003,6 +4048,84 @@ out:
>         return ret;
>  }
>
> +static int get_last_extent(struct send_ctx *sctx, u64 offset)
> +{
> +       struct btrfs_path *path;
> +       struct btrfs_root *root = sctx->send_root;
> +       struct btrfs_file_extent_item *fi;
> +       struct btrfs_key key;
> +       u64 extent_end;
> +       u8 type;
> +       int ret;
> +
> +       path = alloc_path_for_send();
> +       if (!path)
> +               return -ENOMEM;
> +
> +       sctx->cur_inode_last_extent = 0;
> +
> +       key.objectid = sctx->cur_ino;
> +       key.type = BTRFS_EXTENT_DATA_KEY;
> +       key.offset = offset;
> +       ret = btrfs_search_slot_for_read(root, &key, path, 0, 1);
> +       if (ret < 0)
> +               goto out;
> +       ret = 0;
> +       btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +       if (key.objectid != sctx->cur_ino || key.type != BTRFS_EXTENT_DATA_KEY)
> +               goto out;
> +
> +       fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +                           struct btrfs_file_extent_item);
> +       type = btrfs_file_extent_type(path->nodes[0], fi);
> +       if (type == BTRFS_FILE_EXTENT_INLINE) {
> +               u64 size = btrfs_file_extent_inline_len(path->nodes[0], fi);
> +               extent_end = ALIGN(key.offset + size,
> +                                  sctx->send_root->sectorsize);
> +       } else {
> +               extent_end = key.offset +
> +                       btrfs_file_extent_num_bytes(path->nodes[0], fi);
> +       }
> +       sctx->cur_inode_last_extent = extent_end;
> +out:
> +       btrfs_free_path(path);
> +       return ret;
> +}
> +
> +static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
> +                          struct btrfs_key *key)
> +{
> +       struct btrfs_file_extent_item *fi;
> +       u64 extent_end;
> +       u8 type;
> +       int ret = 0;
> +
> +       if (sctx->cur_ino != key->objectid || !need_send_hole(sctx))
> +               return 0;
> +
> +       if (sctx->cur_inode_last_extent == (u64)-1) {
> +               ret = get_last_extent(sctx, key->offset - 1);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +                           struct btrfs_file_extent_item);
> +       type = btrfs_file_extent_type(path->nodes[0], fi);
> +       if (type == BTRFS_FILE_EXTENT_INLINE) {
> +               u64 size = btrfs_file_extent_inline_len(path->nodes[0], fi);
> +               extent_end = ALIGN(key->offset + size,
> +                                  sctx->send_root->sectorsize);
> +       } else {
> +               extent_end = key->offset +
> +                       btrfs_file_extent_num_bytes(path->nodes[0], fi);
> +       }
> +       if (sctx->cur_inode_last_extent < key->offset)
> +               ret = send_hole(sctx, key->offset);
> +       sctx->cur_inode_last_extent = extent_end;
> +       return ret;
> +}
> +
>  static int process_extent(struct send_ctx *sctx,
>                           struct btrfs_path *path,
>                           struct btrfs_key *key)
> @@ -4019,7 +4142,7 @@ static int process_extent(struct send_ctx *sctx,
>                         goto out;
>                 if (ret) {
>                         ret = 0;
> -                       goto out;
> +                       goto out_hole;
>                 }
>         } else {
>                 struct btrfs_file_extent_item *ei;
> @@ -4055,7 +4178,10 @@ static int process_extent(struct send_ctx *sctx,
>                 goto out;
>
>         ret = send_write_or_clone(sctx, path, key, found_clone);
> -
> +       if (ret)
> +               goto out;
> +out_hole:
> +       ret = maybe_send_hole(sctx, path, key);
>  out:
>         return ret;
>  }
> @@ -4181,6 +4307,19 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
>         }
>
>         if (S_ISREG(sctx->cur_inode_mode)) {
> +               if (need_send_hole(sctx)) {
> +                       if (sctx->cur_inode_last_extent == (u64)-1) {
> +                               ret = get_last_extent(sctx, (u64)-1);
> +                               if (ret)
> +                                       goto out;
> +                       }
> +                       if (sctx->cur_inode_last_extent <
> +                           sctx->cur_inode_size) {
> +                               ret = send_hole(sctx, sctx->cur_inode_size);
> +                               if (ret)
> +                                       goto out;
> +                       }
> +               }
>                 ret = send_truncate(sctx, sctx->cur_ino, sctx->cur_inode_gen,
>                                 sctx->cur_inode_size);
>                 if (ret < 0)
> @@ -4228,6 +4367,7 @@ static int changed_inode(struct send_ctx *sctx,
>
>         sctx->cur_ino = key->objectid;
>         sctx->cur_inode_new_gen = 0;
> +       sctx->cur_inode_last_extent = (u64)-1;
>
>         /*
>          * Set send_progress to current inode. This will tell all get_cur_xxx
> @@ -4508,14 +4648,18 @@ static int changed_cb(struct btrfs_root *left_root,
>         struct send_ctx *sctx = ctx;
>
>         if (result == BTRFS_COMPARE_TREE_SAME) {
> -               if (key->type != BTRFS_INODE_REF_KEY &&
> -                   key->type != BTRFS_INODE_EXTREF_KEY)
> -                       return 0;
> -               ret = compare_refs(sctx, left_path, key);
> -               if (!ret)
> +               if (key->type == BTRFS_INODE_REF_KEY ||
> +                   key->type == BTRFS_INODE_EXTREF_KEY) {
> +                       ret = compare_refs(sctx, left_path, key);
> +                       if (!ret)
> +                               return 0;
> +                       if (ret < 0)
> +                               return ret;
> +               } else if (key->type == BTRFS_EXTENT_DATA_KEY) {
> +                       return maybe_send_hole(sctx, left_path, key);
> +               } else {
>                         return 0;
> -               if (ret < 0)
> -                       return ret;
> +               }
>                 result = BTRFS_COMPARE_TREE_CHANGED;
>                 ret = 0;
>         }
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1134aa4..3c8564a 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3188,7 +3188,7 @@ static int log_inode_item(struct btrfs_trans_handle *trans,
>  static noinline int copy_items(struct btrfs_trans_handle *trans,
>                                struct inode *inode,
>                                struct btrfs_path *dst_path,
> -                              struct extent_buffer *src,
> +                              struct extent_buffer *src, u64 *last_extent,
>                                int start_slot, int nr, int inode_only)
>  {
>         unsigned long src_offset;
> @@ -3203,6 +3203,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
>         int i;
>         struct list_head ordered_sums;
>         int skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
> +       bool has_extents = false;
>
>         INIT_LIST_HEAD(&ordered_sums);
>
> @@ -3242,6 +3243,8 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
>                                            src_offset, ins_sizes[i]);
>                 }
>
> +               if (ins_keys[i].type == BTRFS_EXTENT_DATA_KEY)
> +                       has_extents = true;
>                 /* take a reference on file data extents so that truncates
>                  * or deletes of this inode don't have to relog the inode
>                  * again
> @@ -3306,6 +3309,46 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
>                 list_del(&sums->list);
>                 kfree(sums);
>         }
> +
> +       if (!has_extents)
> +               return ret;
> +
> +       /*
> +        * Ok so here we need to go through and fill in any holes we may have
> +        * to make sure that holes are punched for those areas in case they had
> +        * extents previously.
> +        */
> +       for (i = start_slot; i < start_slot + nr; i++) {
> +               struct btrfs_key key;
> +               u64 offset, len;
> +               u64 extent_end;
> +
> +               btrfs_item_key_to_cpu(src, &key, i);
> +               if (key.type != BTRFS_EXTENT_DATA_KEY)
> +                       continue;
> +               extent = btrfs_item_ptr(src, i, struct btrfs_file_extent_item);
> +               if (btrfs_file_extent_type(src, extent) ==
> +                   BTRFS_FILE_EXTENT_INLINE) {
> +                       len = btrfs_file_extent_inline_len(src, extent);
> +                       extent_end = ALIGN(key.offset + len, log->sectorsize);
> +               } else {
> +                       len = btrfs_file_extent_num_bytes(src, extent);
> +                       extent_end = key.offset + len;
> +               }
> +
> +               if (*last_extent == key.offset) {
> +                       *last_extent = extent_end;
> +                       continue;
> +               }
> +               offset = *last_extent;
> +               len = key.offset - *last_extent;
> +               ret = btrfs_insert_file_extent(trans, log, btrfs_ino(inode),
> +                                              offset, 0, 0, len, 0, len, 0,
> +                                              0, 0);
> +               if (ret)
> +                       break;
> +               *last_extent = extent_end;
> +       }
>         return ret;
>  }

Hi Josef,

This loop can lead to data corruption after an fsync, followed by a
power failure
that happens before the next transaction commit. Here follow some
steps to reproduce
such issue easily:

Test script:

$ cat fsync_issue.pl
#!/usr/bin/perl -w

use strict;
use File::Sync qw(fsync);
use constant FSYNC_FILE => 'foobar';
use constant FSYNC_FILE_SIZE => (20 * 1024 * 1024);

open(my $f, '>', FSYNC_FILE) or die "Error opening file!";
$f->autoflush(1);
for (my $i = 0; $i < FSYNC_FILE_SIZE; $i += 4096) {
    print $f ('\xff' x 4096) or die "Error writing to file!";
}
fsync($f) or die "Fsync error!";

seek($f, 15_396_864, 0) or die "File seek error!";
print $f 'A' or die "File write error!";
seek($f, (25 * 1024 * 1024), 0) or die "File seek error!"; # 26214400
print $f 'A' or die "File write error!";
seek($f, (27 * 1024 * 1024), 0) or die "File seek error!"; # 28311552
print $f 'A' or die "File write error!";
fsync($f) or die "Fsync error!";
close($f);


$ mkfs.btrfs -f /dev/sdb3
$ mount -o compress=lzo,commit=9999 /dev/sdb3 /mnt/btrfs
$ cd /mnt/btrfs
$ /tmp/fsync_issue.pl
$ md5sum foobar
4be661c79f33f6f8d2c9099a379be238  foobar

Power off the machine. Turn on the machine, and before mounting the device, use
btrfs-debug-tree to see the log root:

log tree key (TREE_LOG ROOT_ITEM 5)
node 29581312 level 1 items 3 free 118 generation 7 owner 18446744073709551610
fs uuid 021ec720-eed5-4d96-9c11-a198f5baabe5
chunk uuid 1d12bae2-4902-46de-83ff-e30ccd73cc0b
        key (257 EXTENT_DATA 0) block 29577216 (7221) gen 7
        key (257 EXTENT_DATA 18743296) block 29585408 (7223) gen 7
        key (257 EXTENT_DATA 27394048) block 29589504 (7224) gen 7
leaf 29577216 items 51 free space 17 generation 7 owner 18446744073709551610
fs uuid 021ec720-eed5-4d96-9c11-a198f5baabe5
chunk uuid 00000000-0000-0000-0000-000000000000
        item 0 key (257 EXTENT_DATA 0) itemoff 3942 itemsize 53
                extent data disk byte 0 nr 0
                extent data offset 0 nr 12451840 ram 12451840
                extent compression 0
        item 1 key (257 EXTENT_DATA 12451840) itemoff 3889 itemsize 53
                extent data disk byte 13037568 nr 4096
                extent data offset 0 nr 131072 ram 131072
                extent compression 2

The first EXTENT_DATA item was not supposed to be there, nor the
following one from
the second leaf:

        item 3 key (257 EXTENT_DATA 19136512) itemoff 3783 itemsize 53
                extent data disk byte 0 nr 0
                extent data offset 0 nr 6684672 ram 6684672
                extent compression 0

Now mount the device to trigger the log replay code:

$ mount -o compress=lzo,commit=600 /dev/sdb3 /mnt/btrfs
$ cd /mnt/btrfs
$ md5sum foobar
350dd4dfe323cb639fe35a067c29f4a9  foobar

This is different from the md5 we got before the power failure, those
(hole) extents
replaced data we wrote before.

The problem is that that loop inserts holes where they don't exist -
it fails to realize
we have file extents that are inside the areas it thinks they're
holes. This is because
the loop in btrfs_log_inode(), which calls copy_items(), uses
btrfs_search_forward() to
look for our file extents to log - but, it gives us only those that
are in btree leaves
touched by our current transaction, not those that were touched by
previous transactions,
therefore that loop in copy_items() thinks there are holes in the file
when they don't exist.

Is there another solution for this other than passing a transid of 0
to btrfs_search_forward() ?

thanks



>
> @@ -3624,6 +3667,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>         struct btrfs_key max_key;
>         struct btrfs_root *log = root->log_root;
>         struct extent_buffer *src = NULL;
> +       u64 last_extent = 0;
>         int err = 0;
>         int ret;
>         int nritems;
> @@ -3738,8 +3782,8 @@ again:
>                         goto next_slot;
>                 }
>
> -               ret = copy_items(trans, inode, dst_path, src, ins_start_slot,
> -                                ins_nr, inode_only);
> +               ret = copy_items(trans, inode, dst_path, src, &last_extent,
> +                                ins_start_slot, ins_nr, inode_only);
>                 if (ret) {
>                         err = ret;
>                         goto out_unlock;
> @@ -3757,7 +3801,7 @@ next_slot:
>                 }
>                 if (ins_nr) {
>                         ret = copy_items(trans, inode, dst_path, src,
> -                                        ins_start_slot,
> +                                        &last_extent, ins_start_slot,
>                                          ins_nr, inode_only);
>                         if (ret) {
>                                 err = ret;
> @@ -3777,8 +3821,8 @@ next_slot:
>                 }
>         }
>         if (ins_nr) {
> -               ret = copy_items(trans, inode, dst_path, src, ins_start_slot,
> -                                ins_nr, inode_only);
> +               ret = copy_items(trans, inode, dst_path, src, &last_extent,
> +                                ins_start_slot, ins_nr, inode_only);
>                 if (ret) {
>                         err = ret;
>                         goto out_unlock;
> --
> 1.8.3.1
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
