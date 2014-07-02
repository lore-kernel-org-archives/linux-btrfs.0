Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:38515 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaGBPLc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 11:11:32 -0400
Received: by mail-lb0-f176.google.com with SMTP id w7so8151629lbi.35
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 08:11:30 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1403519147-19520-1-git-send-email-fdmanana@gmail.com>
References: <1403519147-19520-1-git-send-email-fdmanana@gmail.com>
Date: Wed, 2 Jul 2014 16:11:29 +0100
Message-ID: <CAL3q7H7c99ATFA90w6AmF=1hEwyEPSr16UKs_1-MxnfB0uPi3g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: implement support for fallocate collapse range
From: Filipe David Manana <fdmanana@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 23, 2014 at 11:25 AM, Filipe David Borba Manana
<fdmanana@gmail.com> wrote:
> This implements fallocate's FALLOC_FL_COLLAPSE_RANGE operation for
> BTRFS. This fallocate operation was introduced in the linux kernel
> version 3.15.
>
> Existing tests in xfstests already test this operation explicitly
> and implicitly via fsstress.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/ctree.c       |  42 ++++-
>  fs/btrfs/ctree.h       |   2 +
>  fs/btrfs/extent-tree.c |  30 +--
>  fs/btrfs/file.c        | 486 +++++++++++++++++++++++++++++++++++++++++--------
>  4 files changed, 453 insertions(+), 107 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index aeab453..8f1a371 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2825,12 +2825,12 @@ cow_done:
>                  * It is safe to drop the lock on our parent before we
>                  * go through the expensive btree search on b.
>                  *
> -                * If we're inserting or deleting (ins_len != 0), then we might
> -                * be changing slot zero, which may require changing the parent.
> -                * So, we can't drop the lock until after we know which slot
> -                * we're operating on.
> +                * If we're inserting, deleting or updating a key (cow != 0),
> +                * then we might be changing slot zero, which may require
> +                * changing the parent. So, we can't drop the lock until after
> +                * we know which slot we're operating on.
>                  */
> -               if (!ins_len && !p->keep_locks) {
> +               if (!cow && !p->keep_locks) {
>                         int u = level + 1;
>
>                         if (u < BTRFS_MAX_LEVEL && p->locks[u]) {
> @@ -2865,7 +2865,7 @@ cow_done:
>                          * which means we must have a write lock
>                          * on the parent
>                          */
> -                       if (slot == 0 && ins_len &&
> +                       if (slot == 0 && cow &&
>                             write_lock_level < level + 1) {
>                                 write_lock_level = level + 1;
>                                 btrfs_release_path(p);
> @@ -5660,6 +5660,36 @@ next:
>  }
>
>  /*
> + * This differs from btrfs_find_next_key in that it ignores leaf/node
> + * generations and it doesn't unlock and re-lock nodes/leaves nor does
> + * any subsequent searches (calls to btrfs_search_slot), preserving the
> + * locks in the given path.
> + *
> + * Returns 0 if a next key exists, 1 otherwise.
> + */
> +int btrfs_find_next_current_key(struct btrfs_path *path, int level,
> +                               struct btrfs_key *key)
> +
> +{
> +       for (; level < BTRFS_MAX_LEVEL; level++) {
> +               if (!path->nodes[level])
> +                       break;
> +               if (path->slots[level] + 1 >=
> +                   btrfs_header_nritems(path->nodes[level]))
> +                       continue;
> +               if (level == 0)
> +                       btrfs_item_key_to_cpu(path->nodes[level], key,
> +                                             path->slots[level] + 1);
> +               else
> +                       btrfs_node_key_to_cpu(path->nodes[level], key,
> +                                             path->slots[level] + 1);
> +               return 0;
> +       }
> +       return 1;
> +}
> +
> +
> +/*
>   * search the tree again to find a leaf with greater keys
>   * returns 0 if it found something or 1 if there are no greater leaves.
>   * returns < 0 on io errors.
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index b7e2c1c..166a35f 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3446,6 +3446,8 @@ struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
>  int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
>                         struct btrfs_key *key, int lowest_level,
>                         u64 min_trans);
> +int btrfs_find_next_current_key(struct btrfs_path *path, int level,
> +                               struct btrfs_key *key);
>  int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
>                          struct btrfs_path *path,
>                          u64 min_trans);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index fafb3e5..a6d0ec7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -100,8 +100,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
>  static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>                           struct btrfs_root *extent_root, u64 flags,
>                           int force);
> -static int find_next_key(struct btrfs_path *path, int level,
> -                        struct btrfs_key *key);
>  static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
>                             int dump_block_groups);
>  static int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
> @@ -440,7 +438,7 @@ next:
>                 if (path->slots[0] < nritems) {
>                         btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
>                 } else {
> -                       ret = find_next_key(path, 0, &key);
> +                       ret = btrfs_find_next_current_key(path, 0, &key);
>                         if (ret)
>                                 break;
>
> @@ -1443,27 +1441,6 @@ static inline int extent_ref_type(u64 parent, u64 owner)
>         return type;
>  }
>
> -static int find_next_key(struct btrfs_path *path, int level,
> -                        struct btrfs_key *key)
> -
> -{
> -       for (; level < BTRFS_MAX_LEVEL; level++) {
> -               if (!path->nodes[level])
> -                       break;
> -               if (path->slots[level] + 1 >=
> -                   btrfs_header_nritems(path->nodes[level]))
> -                       continue;
> -               if (level == 0)
> -                       btrfs_item_key_to_cpu(path->nodes[level], key,
> -                                             path->slots[level] + 1);
> -               else
> -                       btrfs_node_key_to_cpu(path->nodes[level], key,
> -                                             path->slots[level] + 1);
> -               return 0;
> -       }
> -       return 1;
> -}
> -
>  /*
>   * look for inline back ref. if back ref is found, *ref_ret is set
>   * to the address of inline back ref, and 0 is returned.
> @@ -1651,7 +1628,7 @@ again:
>                  * For simplicity, we just do not add new inline back
>                  * ref if there is any kind of item for this block
>                  */
> -               if (find_next_key(path, 0, &key) == 0 &&
> +               if (btrfs_find_next_current_key(path, 0, &key) == 0 &&
>                     key.objectid == bytenr &&
>                     key.type < BTRFS_BLOCK_GROUP_ITEM_KEY) {
>                         err = -EAGAIN;
> @@ -7649,7 +7626,8 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
>                 if (level < wc->shared_level)
>                         goto out;
>
> -               ret = find_next_key(path, level + 1, &wc->update_progress);
> +               ret = btrfs_find_next_current_key(path, level + 1,
> +                                                 &wc->update_progress);
>                 if (ret > 0)
>                         wc->update_ref = 0;
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index ad7c059..c306ce4 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2087,6 +2087,44 @@ static int hole_mergeable(struct inode *inode, struct extent_buffer *leaf,
>         return 0;
>  }
>
> +static void fill_hole_em(struct extent_map *em,
> +                        struct btrfs_trans_handle *trans,
> +                        struct inode *inode,
> +                        const u64 start,
> +                        const u64 len)
> +{
> +       em->start = start;
> +       em->len = len;
> +       em->ram_bytes = em->len;
> +       em->orig_start = start;
> +       em->block_start = EXTENT_MAP_HOLE;
> +       em->block_len = 0;
> +       em->orig_block_len = 0;
> +       em->bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
> +       em->compress_type = BTRFS_COMPRESS_NONE;
> +       em->generation = trans->transid;
> +}
> +
> +static void replace_inode_em(struct extent_map *em, struct inode *inode)
> +{
> +       struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
> +       int ret;
> +
> +       while (1) {
> +               write_lock(&em_tree->lock);
> +               ret = add_extent_mapping(em_tree, em, 1);
> +               write_unlock(&em_tree->lock);
> +               if (ret != -EEXIST)
> +                       break;
> +               btrfs_drop_extent_cache(inode, em->start,
> +                                       em->start + em->len - 1, 0);
> +       };
> +       free_extent_map(em);
> +       if (ret)
> +               set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> +                       &BTRFS_I(inode)->runtime_flags);
> +}
> +
>  static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
>                       struct btrfs_path *path, u64 offset, u64 end)
>  {
> @@ -2094,7 +2132,6 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
>         struct extent_buffer *leaf;
>         struct btrfs_file_extent_item *fi;
>         struct extent_map *hole_em;
> -       struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>         struct btrfs_key key;
>         int ret;
>
> @@ -2159,28 +2196,8 @@ out:
>                 set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>                         &BTRFS_I(inode)->runtime_flags);
>         } else {
> -               hole_em->start = offset;
> -               hole_em->len = end - offset;
> -               hole_em->ram_bytes = hole_em->len;
> -               hole_em->orig_start = offset;
> -
> -               hole_em->block_start = EXTENT_MAP_HOLE;
> -               hole_em->block_len = 0;
> -               hole_em->orig_block_len = 0;
> -               hole_em->bdev = root->fs_info->fs_devices->latest_bdev;
> -               hole_em->compress_type = BTRFS_COMPRESS_NONE;
> -               hole_em->generation = trans->transid;
> -
> -               do {
> -                       btrfs_drop_extent_cache(inode, offset, end - 1, 0);
> -                       write_lock(&em_tree->lock);
> -                       ret = add_extent_mapping(em_tree, hole_em, 1);
> -                       write_unlock(&em_tree->lock);
> -               } while (ret == -EEXIST);
> -               free_extent_map(hole_em);
> -               if (ret)
> -                       set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> -                               &BTRFS_I(inode)->runtime_flags);
> +               fill_hole_em(hole_em, trans, inode, offset, end - offset);
> +               replace_inode_em(hole_em, inode);
>         }
>
>         return 0;
> @@ -2217,6 +2234,80 @@ static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
>         return ret;
>  }
>
> +static int wait_lock_ordered_range(struct inode *inode,
> +                                  const u64 lockstart,
> +                                  const u64 lockend,
> +                                  struct extent_state **cached_state)
> +{
> +       while (1) {
> +               struct btrfs_ordered_extent *ordered;
> +               int ret;
> +
> +               truncate_pagecache_range(inode, lockstart, lockend);
> +
> +               lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
> +                                0, cached_state);
> +               ordered = btrfs_lookup_first_ordered_extent(inode, lockend);
> +
> +               /*
> +                * We need to make sure we have no ordered extents in this range
> +                * and nobody raced in and read a page in this range, if we did
> +                * we need to try again.
> +                */
> +               if ((!ordered ||
> +                   (ordered->file_offset + ordered->len <= lockstart ||
> +                    ordered->file_offset > lockend)) &&
> +                    !btrfs_page_exists_in_range(inode, lockstart, lockend)) {
> +                       if (ordered)
> +                               btrfs_put_ordered_extent(ordered);
> +                       break;
> +               }
> +               if (ordered)
> +                       btrfs_put_ordered_extent(ordered);
> +               unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
> +                                    lockend, cached_state, GFP_NOFS);
> +               ret = btrfs_wait_ordered_range(inode, lockstart,
> +                                              lockend - lockstart + 1);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int fallocate_restart_transaction(struct btrfs_trans_handle **trans,
> +                                        struct inode *inode,
> +                                        const int trans_units,
> +                                        const int min_size)
> +{
> +       struct btrfs_root *root = BTRFS_I(inode)->root;
> +       struct btrfs_block_rsv *rsv = (*trans)->block_rsv;
> +       int ret;
> +
> +       (*trans)->block_rsv = &root->fs_info->trans_block_rsv;
> +       ret = btrfs_update_inode(*trans, root, inode);
> +       if (ret)
> +               return ret;
> +
> +       btrfs_end_transaction(*trans, root);
> +       btrfs_btree_balance_dirty(root);
> +
> +       *trans = btrfs_start_transaction(root, trans_units);
> +       if (IS_ERR(*trans)) {
> +               ret = PTR_ERR(*trans);
> +               *trans = NULL;
> +               return ret;
> +       }
> +
> +       ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv,
> +                                     rsv, min_size);
> +       if (unlikely(ret))
> +               return ret;
> +       (*trans)->block_rsv = rsv;
> +
> +       return 0;
> +}
> +
>  static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  {
>         struct btrfs_root *root = BTRFS_I(inode)->root;
> @@ -2324,38 +2415,10 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>                 return 0;
>         }
>
> -       while (1) {
> -               struct btrfs_ordered_extent *ordered;
> -
> -               truncate_pagecache_range(inode, lockstart, lockend);
> -
> -               lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
> -                                0, &cached_state);
> -               ordered = btrfs_lookup_first_ordered_extent(inode, lockend);
> -
> -               /*
> -                * We need to make sure we have no ordered extents in this range
> -                * and nobody raced in and read a page in this range, if we did
> -                * we need to try again.
> -                */
> -               if ((!ordered ||
> -                   (ordered->file_offset + ordered->len <= lockstart ||
> -                    ordered->file_offset > lockend)) &&
> -                    !btrfs_page_exists_in_range(inode, lockstart, lockend)) {
> -                       if (ordered)
> -                               btrfs_put_ordered_extent(ordered);
> -                       break;
> -               }
> -               if (ordered)
> -                       btrfs_put_ordered_extent(ordered);
> -               unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
> -                                    lockend, &cached_state, GFP_NOFS);
> -               ret = btrfs_wait_ordered_range(inode, lockstart,
> -                                              lockend - lockstart + 1);
> -               if (ret) {
> -                       mutex_unlock(&inode->i_mutex);
> -                       return ret;
> -               }
> +       ret = wait_lock_ordered_range(inode, lockstart, lockend, &cached_state);
> +       if (ret) {
> +               mutex_unlock(&inode->i_mutex);
> +               return ret;
>         }
>
>         path = btrfs_alloc_path();
> @@ -2411,26 +2474,11 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>
>                 cur_offset = drop_end;
>
> -               ret = btrfs_update_inode(trans, root, inode);
> -               if (ret) {
> -                       err = ret;
> -                       break;
> -               }
> -
> -               btrfs_end_transaction(trans, root);
> -               btrfs_btree_balance_dirty(root);
> -
> -               trans = btrfs_start_transaction(root, rsv_count);
> -               if (IS_ERR(trans)) {
> -                       ret = PTR_ERR(trans);
> -                       trans = NULL;
> -                       break;
> -               }
> -
> -               ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv,
> -                                             rsv, min_size);
> -               BUG_ON(ret);    /* shouldn't happen */
>                 trans->block_rsv = rsv;
> +               ret = fallocate_restart_transaction(&trans, inode, rsv_count,
> +                                                   min_size);
> +               if (ret)
> +                       break;
>
>                 ret = find_first_non_hole(inode, &cur_offset, &len);
>                 if (unlikely(ret < 0))
> @@ -2484,6 +2532,291 @@ out_only_mutex:
>         return err;
>  }
>
> +static int collapse_file_extents(struct inode *inode,
> +                                struct btrfs_trans_handle **trans,
> +                                struct btrfs_path *path,
> +                                const u64 start,
> +                                const u64 len)
> +{
> +       struct btrfs_root *root = BTRFS_I(inode)->root;
> +       struct btrfs_key key;
> +       struct extent_buffer *leaf;
> +       struct btrfs_file_extent_item *fi;
> +       struct extent_map *em;
> +       const u64 ino = btrfs_ino(inode);
> +       bool last_leaf = false;
> +       bool retry_on_enospc = true;
> +       u64 last_extent_end = start - len;
> +       int slot;
> +       int ret;
> +       const u64 new_file_size = i_size_read(inode) - len;
> +       const u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
> +
> +       /*
> +        * Start tree search from left (lower file offsets) to right (higher
> +        * file offsets), to avoid leaving duplicated keys in the tree at
> +        * any time.
> +        */
> +       key.objectid = ino;
> +       key.type = BTRFS_EXTENT_DATA_KEY;
> +       key.offset = start;
> +again:
> +       if (key.objectid > ino || key.type != BTRFS_EXTENT_DATA_KEY)
> +               goto done;
> +       path->keep_locks = 1;
> +       ret = btrfs_search_slot(*trans, root, &key, path, 0, 1);
> +       if (ret == -ENOSPC && retry_on_enospc) {
> +               ret = fallocate_restart_transaction(trans, inode, 2, min_size);
> +               if (ret)
> +                       goto out;
> +               retry_on_enospc = false;
> +               goto again;
> +       } else if (ret < 0) {
> +               goto out;
> +       }
> +
> +       leaf = path->nodes[0];
> +       slot = path->slots[0];
> +       path->slots[0] = btrfs_header_nritems(leaf);
> +       /*
> +        * Get smallest key of the next leaf to use to get into the next leaf.
> +        * This is to avoid ending up in the same leaf again and over again
> +        * after processing a full leaf, which is more likely to happen in
> +        * the case of implicit holes (NO_HOLES feature).
> +        */
> +       ret = btrfs_find_next_current_key(path, 0, &key);
> +       if (ret > 0)
> +               last_leaf = true;
> +       path->slots[0] = slot;
> +       retry_on_enospc = true;
> +
> +       while (1) {
> +               u64 extent_len, disk_bytenr, num_bytes, extent_offset;
> +               int extent_type;
> +               struct btrfs_key found_key, new_key;
> +
> +               if (path->slots[0] >= btrfs_header_nritems(leaf)) {
> +                       btrfs_release_path(path);
> +                       if (last_leaf)
> +                               break;
> +                       else
> +                               goto again;
> +               }
> +
> +               if (path->slots[0] > 0) {
> +                       path->keep_locks = 0;
> +                       btrfs_unlock_up_safe(path, 1);
> +               }
> +
> +               btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
> +               if (found_key.objectid != ino)
> +                       break;
> +               if (found_key.type != BTRFS_EXTENT_DATA_KEY)
> +                       break;
> +               ASSERT(found_key.offset >= start);
> +
> +               fi = btrfs_item_ptr(leaf, path->slots[0],
> +                                   struct btrfs_file_extent_item);
> +               extent_type = btrfs_file_extent_type(leaf, fi);
> +               /* Inline extents are always at file offset 0. */
> +               ASSERT(extent_type != BTRFS_FILE_EXTENT_INLINE);
> +
> +               extent_len = btrfs_file_extent_num_bytes(leaf, fi);
> +               disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
> +               num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
> +               extent_offset = btrfs_file_extent_offset(leaf, fi);
> +
> +               memcpy(&new_key, &found_key, sizeof(new_key));
> +               new_key.offset -= len;
> +               btrfs_set_item_key_safe(root, path, &new_key);
> +
> +               if (disk_bytenr == 0)
> +                       goto setup_ems;
> +
> +               ret = btrfs_inc_extent_ref(*trans, root, disk_bytenr, num_bytes,
> +                                          0, root->root_key.objectid, ino,
> +                                          new_key.offset - extent_offset, 1);

Note to self and nack.

Due to the left shifting of file extent offsets, new_key.offset -
extent_offset can now often be negative, resulting in data backrefs
with a wrong offset value (a very large u64 value) that causes
confusion in the backref walking and management code.

Need some more thought and work around this.

Thanks


> +               if (ret)
> +                       goto out;
> +               ret = btrfs_free_extent(*trans, root, disk_bytenr, num_bytes, 0,
> +                                       root->root_key.objectid, ino,
> +                                       found_key.offset - extent_offset, 1);
> +               if (ret)
> +                       goto out;
> +setup_ems:
> +               em = alloc_extent_map();
> +               if (!em) {
> +                       set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> +                               &BTRFS_I(inode)->runtime_flags);
> +                       goto next;
> +               }
> +
> +               /* Implicit hole, NO_HOLES feature. */
> +               if (new_key.offset != last_extent_end) {
> +                       ASSERT(new_key.offset > last_extent_end);
> +                       fill_hole_em(em, *trans, inode, last_extent_end,
> +                                    new_key.offset - last_extent_end);
> +                       replace_inode_em(em, inode);
> +                       em = alloc_extent_map();
> +                       if (!em) {
> +                               set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> +                                       &BTRFS_I(inode)->runtime_flags);
> +                               goto next;
> +                       }
> +               }
> +
> +               btrfs_extent_item_to_extent_map(inode, path, fi, false, em);
> +               replace_inode_em(em, inode);
> +next:
> +               last_extent_end = new_key.offset + extent_len;
> +               path->slots[0]++;
> +       }
> +
> +done:
> +       ret = 0;
> +
> +       /* Implicit trailing hole, NO_HOLES feature. */
> +       if (last_extent_end < new_file_size) {
> +               em = alloc_extent_map();
> +               if (!em) {
> +                       set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
> +                               &BTRFS_I(inode)->runtime_flags);
> +               } else {
> +                       fill_hole_em(em, *trans, inode, last_extent_end,
> +                                    new_file_size - last_extent_end);
> +                       replace_inode_em(em, inode);
> +               }
> +       }
> +
> +out:
> +       path->keep_locks = 0;
> +       btrfs_release_path(path);
> +       if (ret)
> +               btrfs_abort_transaction(*trans, root, ret);
> +
> +       return ret;
> +}
> +
> +static int btrfs_collapse_range(struct inode *inode,
> +                               const loff_t offset,
> +                               const loff_t len)
> +{
> +       struct btrfs_root *root = BTRFS_I(inode)->root;
> +       struct extent_state *cached_state = NULL;
> +       struct btrfs_path *path = NULL;
> +       struct btrfs_block_rsv *rsv = NULL;
> +       struct btrfs_trans_handle *trans = NULL;
> +       const u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
> +       const u64 lockstart = round_up(offset, root->sectorsize);
> +       const u64 lockend = OFFSET_MAX;
> +       u64 cur_offset = lockstart;
> +       const u64 drop_end = round_down(offset + len, root->sectorsize) - 1;
> +       loff_t new_size;
> +       int ret = 0;
> +
> +       if (!S_ISREG(inode->i_mode))
> +               return -EINVAL;
> +
> +       if (offset & (root->sectorsize - 1) || len & (root->sectorsize - 1))
> +               return -EINVAL;
> +
> +       if (!len)
> +               return 0;
> +
> +       ret = btrfs_wait_ordered_range(inode, offset, lockend);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&inode->i_mutex);
> +
> +       if (offset + len >= i_size_read(inode)) {
> +               ret = -EINVAL;
> +               goto out_only_mutex;
> +       }
> +       new_size = i_size_read(inode) - len;
> +
> +       /* Lock the range we're modifying and remove data from page cache. */
> +       ret = wait_lock_ordered_range(inode, lockstart, lockend, &cached_state);
> +       if (ret)
> +               goto out_only_mutex;
> +       btrfs_drop_extent_cache(inode, lockstart, lockend, 0);
> +
> +       path = btrfs_alloc_path();
> +       if (!path) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       rsv = btrfs_alloc_block_rsv(root, BTRFS_BLOCK_RSV_TEMP);
> +       if (!rsv) {
> +               ret = -ENOMEM;
> +               goto out_free;
> +       }
> +       rsv->size = min_size;
> +       rsv->failfast = 1;
> +
> +       /*
> +        * 1 - update the inode
> +        * 1 - removing the extents in the range
> +        */
> +       trans = btrfs_start_transaction(root, 2);
> +       if (IS_ERR(trans)) {
> +               ret = PTR_ERR(trans);
> +               goto out_free;
> +       }
> +
> +       ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv, rsv,
> +                                     min_size);
> +       if (ret) {
> +               btrfs_end_transaction(trans, root);
> +               goto out_free;
> +       }
> +       trans->block_rsv = rsv;
> +
> +       while (cur_offset < drop_end) {
> +               ret = __btrfs_drop_extents(trans, root, inode, path,
> +                                          cur_offset, drop_end + 1,
> +                                          &cur_offset, 1, 0, 0, NULL);
> +               if (!ret)
> +                       break;
> +               else if (ret != -ENOSPC)
> +                       goto out_trans;
> +
> +               ret = fallocate_restart_transaction(&trans, inode, 2, min_size);
> +               if (ret)
> +                       goto out_trans;
> +       }
> +
> +       ret = collapse_file_extents(inode, &trans, path, drop_end + 1, len);
> +       if (ret)
> +               goto out_trans;
> +       btrfs_i_size_write(inode, new_size);
> +
> +out_trans:
> +       set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
> +       if (!trans)
> +               goto out_free;
> +       inode_inc_iversion(inode);
> +       inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +       trans->block_rsv = &root->fs_info->trans_block_rsv;
> +       if (!ret)
> +               ret = btrfs_update_inode(trans, root, inode);
> +       else
> +               btrfs_update_inode(trans, root, inode);
> +       btrfs_end_transaction(trans, root);
> +       btrfs_btree_balance_dirty(root);
> +out_free:
> +       btrfs_free_path(path);
> +       btrfs_free_block_rsv(root, rsv);
> +out:
> +       unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
> +                            &cached_state, GFP_NOFS);
> +out_only_mutex:
> +       mutex_unlock(&inode->i_mutex);
> +
> +       return ret;
> +}
> +
>  static long btrfs_fallocate(struct file *file, int mode,
>                             loff_t offset, loff_t len)
>  {
> @@ -2504,11 +2837,14 @@ static long btrfs_fallocate(struct file *file, int mode,
>         alloc_end = round_up(offset + len, blocksize);
>
>         /* Make sure we aren't being give some crap mode */
> -       if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +       if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
> +                    FALLOC_FL_COLLAPSE_RANGE))
>                 return -EOPNOTSUPP;
>
>         if (mode & FALLOC_FL_PUNCH_HOLE)
>                 return btrfs_punch_hole(inode, offset, len);
> +       if (mode & FALLOC_FL_COLLAPSE_RANGE)
> +               return btrfs_collapse_range(inode, offset, len);
>
>         /*
>          * Make sure we have enough space before we do the
> --
> 1.9.1
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
