Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33055 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761313Ab3DBTNe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2013 15:13:34 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so815944wgg.0
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2013 12:13:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363787388-25411-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1363787388-25411-1-git-send-email-list.btrfs@jan-o-sch.net>
Date: Tue, 2 Apr 2013 22:13:32 +0300
Message-ID: <CAOcd+r14d450twY1z6wOFQDBp=krqfhT-gQ0vyMQPn_oGghnuw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix locking on ROOT_REPLACE operations in tree
 mod log
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,
I have manually applied this patch and also your previous patch onto
kernel 3.8.2, but, unfortunately, I am still hitting the issue:(
I will check further whether I can be more helpful in debugging this
issue, than just reporting it:(

Thank for your help,
Alex.



On Wed, Mar 20, 2013 at 3:49 PM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> To resolve backrefs, ROOT_REPLACE operations in the tree mod log are
> required to be tied to at least one KEY_REMOVE_WHILE_FREEING operation.
> Therefore, those operations must be enclosed by tree_mod_log_write_lock()
> and tree_mod_log_write_unlock() calls.
>
> Those calls are private to the tree_mod_log_* functions, which means that
> removal of the elements of an old root node must be logged from
> tree_mod_log_insert_root. This partly reverts and corrects commit ba1bfbd5
> (Btrfs: fix a tree mod logging issue for root replacement operations).
>
> This fixes the brand-new version of xfstest 276 as of commit cfe73f71.
>
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
> Has probably been Reported-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
> (unconfirmed).
>
> Chages for v2:
> - use the correct base (current cmason/for-linus)
>
>  fs/btrfs/ctree.c |   30 ++++++++++++++++++++----------
>  1 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index ecd25a1..ca9d8f1 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -651,6 +651,8 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>         if (tree_mod_dont_log(fs_info, NULL))
>                 return 0;
>
> +       __tree_mod_log_free_eb(fs_info, old_root);
> +
>         ret = tree_mod_alloc(fs_info, flags, &tm);
>         if (ret < 0)
>                 goto out;
> @@ -736,7 +738,7 @@ tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq)
>  static noinline void
>  tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
>                      struct extent_buffer *src, unsigned long dst_offset,
> -                    unsigned long src_offset, int nr_items)
> +                    unsigned long src_offset, int nr_items, int log_removal)
>  {
>         int ret;
>         int i;
> @@ -750,10 +752,12 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
>         }
>
>         for (i = 0; i < nr_items; i++) {
> -               ret = tree_mod_log_insert_key_locked(fs_info, src,
> -                                                    i + src_offset,
> -                                                    MOD_LOG_KEY_REMOVE);
> -               BUG_ON(ret < 0);
> +               if (log_removal) {
> +                       ret = tree_mod_log_insert_key_locked(fs_info, src,
> +                                                       i + src_offset,
> +                                                       MOD_LOG_KEY_REMOVE);
> +                       BUG_ON(ret < 0);
> +               }
>                 ret = tree_mod_log_insert_key_locked(fs_info, dst,
>                                                      i + dst_offset,
>                                                      MOD_LOG_KEY_ADD);
> @@ -927,7 +931,6 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
>                         ret = btrfs_dec_ref(trans, root, buf, 1, 1);
>                         BUG_ON(ret); /* -ENOMEM */
>                 }
> -               tree_mod_log_free_eb(root->fs_info, buf);
>                 clean_tree_block(trans, root, buf);
>                 *last_ref = 1;
>         }
> @@ -1046,6 +1049,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
>                 btrfs_set_node_ptr_generation(parent, parent_slot,
>                                               trans->transid);
>                 btrfs_mark_buffer_dirty(parent);
> +               tree_mod_log_free_eb(root->fs_info, buf);
>                 btrfs_free_tree_block(trans, root, buf, parent_start,
>                                       last_ref);
>         }
> @@ -1750,7 +1754,6 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>                         goto enospc;
>                 }
>
> -               tree_mod_log_free_eb(root->fs_info, root->node);
>                 tree_mod_log_set_root_pointer(root, child);
>                 rcu_assign_pointer(root->node, child);
>
> @@ -2995,7 +2998,7 @@ static int push_node_left(struct btrfs_trans_handle *trans,
>                 push_items = min(src_nritems - 8, push_items);
>
>         tree_mod_log_eb_copy(root->fs_info, dst, src, dst_nritems, 0,
> -                            push_items);
> +                            push_items, 1);
>         copy_extent_buffer(dst, src,
>                            btrfs_node_key_ptr_offset(dst_nritems),
>                            btrfs_node_key_ptr_offset(0),
> @@ -3066,7 +3069,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
>                                       sizeof(struct btrfs_key_ptr));
>
>         tree_mod_log_eb_copy(root->fs_info, dst, src, 0,
> -                            src_nritems - push_items, push_items);
> +                            src_nritems - push_items, push_items, 1);
>         copy_extent_buffer(dst, src,
>                            btrfs_node_key_ptr_offset(0),
>                            btrfs_node_key_ptr_offset(src_nritems - push_items),
> @@ -3218,12 +3221,18 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
>         int mid;
>         int ret;
>         u32 c_nritems;
> +       int tree_mod_log_removal = 1;
>
>         c = path->nodes[level];
>         WARN_ON(btrfs_header_generation(c) != trans->transid);
>         if (c == root->node) {
>                 /* trying to split the root, lets make a new one */
>                 ret = insert_new_root(trans, root, path, level + 1);
> +               /*
> +                * removal of root nodes has been logged by
> +                * tree_mod_log_set_root_pointer due to locking
> +                */
> +               tree_mod_log_removal = 0;
>                 if (ret)
>                         return ret;
>         } else {
> @@ -3261,7 +3270,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
>                             (unsigned long)btrfs_header_chunk_tree_uuid(split),
>                             BTRFS_UUID_SIZE);
>
> -       tree_mod_log_eb_copy(root->fs_info, split, c, 0, mid, c_nritems - mid);
> +       tree_mod_log_eb_copy(root->fs_info, split, c, 0, mid, c_nritems - mid,
> +                            tree_mod_log_removal);
>         copy_extent_buffer(split, c,
>                            btrfs_node_key_ptr_offset(0),
>                            btrfs_node_key_ptr_offset(mid),
> --
> 1.7.1
>
