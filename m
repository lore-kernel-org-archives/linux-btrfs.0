Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36133 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbeHVBlC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 21:41:02 -0400
Received: by mail-io0-f194.google.com with SMTP id m4-v6so16732329iop.3
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 15:19:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1534453645-17714-3-git-send-email-bo.liu@linux.alibaba.com>
References: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com> <1534453645-17714-3-git-send-email-bo.liu@linux.alibaba.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 21 Aug 2018 15:19:00 -0700
Message-ID: <CANQeFDDwkQNQTBDXEr8SfU08_pMgOLDDdt+0-wdwFF8QScsMNA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: kill leave_spinning
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please kindly ignore this patch as it did introduce soft lockup when
btrfs_search_slot() returns a spinning path and its callers goes to
sleep before releasing the path.

thanks,
liubo


On Thu, Aug 16, 2018 at 2:07 PM, Liu Bo <bo.liu@linux.alibaba.com> wrote:
> As btrfs_clear_path_blocking() turns out to be a major source of lock
> contention, we've kill it and without it btrfs_search_slot() and
> btrfs_search_old_slot() are not able to return a path in spinning
> mode, lets kill leave_spinning, too.
>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/backref.c            |  3 ---
>  fs/btrfs/ctree.c              | 16 +++-------------
>  fs/btrfs/ctree.h              |  1 -
>  fs/btrfs/delayed-inode.c      |  4 ----
>  fs/btrfs/dir-item.c           |  1 -
>  fs/btrfs/export.c             |  1 -
>  fs/btrfs/extent-tree.c        |  7 -------
>  fs/btrfs/extent_io.c          |  1 -
>  fs/btrfs/file-item.c          |  4 ----
>  fs/btrfs/free-space-tree.c    |  2 --
>  fs/btrfs/inode-item.c         |  6 ------
>  fs/btrfs/inode.c              |  8 --------
>  fs/btrfs/ioctl.c              |  3 ---
>  fs/btrfs/qgroup.c             |  2 --
>  fs/btrfs/super.c              |  2 --
>  fs/btrfs/tests/qgroup-tests.c |  4 ----
>  16 files changed, 3 insertions(+), 62 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index ae750b1574a2..70c629b90710 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1613,13 +1613,11 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
>         s64 bytes_left = ((s64)size) - 1;
>         struct extent_buffer *eb = eb_in;
>         struct btrfs_key found_key;
> -       int leave_spinning = path->leave_spinning;
>         struct btrfs_inode_ref *iref;
>
>         if (bytes_left >= 0)
>                 dest[bytes_left] = '\0';
>
> -       path->leave_spinning = 1;
>         while (1) {
>                 bytes_left -= name_len;
>                 if (bytes_left >= 0)
> @@ -1665,7 +1663,6 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
>         }
>
>         btrfs_release_path(path);
> -       path->leave_spinning = leave_spinning;
>
>         if (ret)
>                 return ERR_PTR(ret);
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 8b31caa60b0a..d2df7cfbec06 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2875,14 +2875,10 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>         }
>         ret = 1;
>  done:
> -       /*
> -        * we don't really know what they plan on doing with the path
> -        * from here on, so for now just mark it as blocking
> -        */
> -       if (!p->leave_spinning)
> -               btrfs_set_path_blocking(p);
>         if (ret < 0 && !p->skip_release_on_error)
>                 btrfs_release_path(p);
> +
> +       /* path is supposed to be in blocking mode from now on. */
>         return ret;
>  }
>
> @@ -2987,11 +2983,10 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
>         }
>         ret = 1;
>  done:
> -       if (!p->leave_spinning)
> -               btrfs_set_path_blocking(p);
>         if (ret < 0)
>                 btrfs_release_path(p);
>
> +       /* path is supposed to be in blocking mode from now on.*/
>         return ret;
>  }
>
> @@ -5628,7 +5623,6 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>         struct btrfs_key key;
>         u32 nritems;
>         int ret;
> -       int old_spinning = path->leave_spinning;
>         int next_rw_lock = 0;
>
>         nritems = btrfs_header_nritems(path->nodes[0]);
> @@ -5643,7 +5637,6 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>         btrfs_release_path(path);
>
>         path->keep_locks = 1;
> -       path->leave_spinning = 1;
>
>         if (time_seq)
>                 ret = btrfs_search_old_slot(root, &key, path, time_seq);
> @@ -5780,9 +5773,6 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>         ret = 0;
>  done:
>         unlock_up(path, 0, 1, 0, NULL);
> -       path->leave_spinning = old_spinning;
> -       if (!old_spinning)
> -               btrfs_set_path_blocking(path);
>
>         return ret;
>  }
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 1aeed3c0e949..e8bddf21b7f7 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -339,7 +339,6 @@ struct btrfs_path {
>         unsigned int search_for_split:1;
>         unsigned int keep_locks:1;
>         unsigned int skip_locking:1;
> -       unsigned int leave_spinning:1;
>         unsigned int search_commit_root:1;
>         unsigned int need_commit_sem:1;
>         unsigned int skip_release_on_error:1;
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index db9f45082c61..e6fbcdbc313e 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1138,7 +1138,6 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans, int nr)
>         path = btrfs_alloc_path();
>         if (!path)
>                 return -ENOMEM;
> -       path->leave_spinning = 1;
>
>         block_rsv = trans->block_rsv;
>         trans->block_rsv = &fs_info->delayed_block_rsv;
> @@ -1203,7 +1202,6 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
>                 btrfs_release_delayed_node(delayed_node);
>                 return -ENOMEM;
>         }
> -       path->leave_spinning = 1;
>
>         block_rsv = trans->block_rsv;
>         trans->block_rsv = &delayed_node->root->fs_info->delayed_block_rsv;
> @@ -1248,7 +1246,6 @@ int btrfs_commit_inode_delayed_inode(struct btrfs_inode *inode)
>                 ret = -ENOMEM;
>                 goto trans_out;
>         }
> -       path->leave_spinning = 1;
>
>         block_rsv = trans->block_rsv;
>         trans->block_rsv = &fs_info->delayed_block_rsv;
> @@ -1317,7 +1314,6 @@ static void btrfs_async_run_delayed_root(struct btrfs_work *work)
>                 if (!delayed_node)
>                         break;
>
> -               path->leave_spinning = 1;
>                 root = delayed_node->root;
>
>                 trans = btrfs_join_transaction(root);
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index a678b07fcf01..4f27d6ba2f1e 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -127,7 +127,6 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
>         path = btrfs_alloc_path();
>         if (!path)
>                 return -ENOMEM;
> -       path->leave_spinning = 1;
>
>         btrfs_cpu_key_to_disk(&disk_key, location);
>
> diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
> index 1f3755b3a37a..7f410edd92e4 100644
> --- a/fs/btrfs/export.c
> +++ b/fs/btrfs/export.c
> @@ -245,7 +245,6 @@ static int btrfs_get_name(struct dentry *parent, char *name,
>         path = btrfs_alloc_path();
>         if (!path)
>                 return -ENOMEM;
> -       path->leave_spinning = 1;
>
>         if (ino == BTRFS_FIRST_FREE_OBJECTID) {
>                 key.objectid = BTRFS_I(inode)->root->root_key.objectid;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index de6f75f5547b..8d9ca923db93 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2116,7 +2116,6 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>                 return -ENOMEM;
>
>         path->reada = READA_FORWARD;
> -       path->leave_spinning = 1;
>         /* this will setup the path even if it fails to insert the back ref */
>         ret = insert_inline_extent_backref(trans, path, bytenr, num_bytes,
>                                            parent, root_objectid, owner,
> @@ -2141,7 +2140,6 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>         btrfs_release_path(path);
>
>         path->reada = READA_FORWARD;
> -       path->leave_spinning = 1;
>         /* now insert the actual backref */
>         ret = insert_extent_backref(trans, path, bytenr, parent, root_objectid,
>                                     owner, offset, refs_to_add);
> @@ -2251,7 +2249,6 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
>
>  again:
>         path->reada = READA_FORWARD;
> -       path->leave_spinning = 1;
>         ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 1);
>         if (ret < 0) {
>                 err = ret;
> @@ -6700,7 +6697,6 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>                 return -ENOMEM;
>
>         path->reada = READA_FORWARD;
> -       path->leave_spinning = 1;
>
>         is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
>         BUG_ON(!is_data && refs_to_drop != 1);
> @@ -6743,7 +6739,6 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>                                 goto out;
>                         }
>                         btrfs_release_path(path);
> -                       path->leave_spinning = 1;
>
>                         key.objectid = bytenr;
>                         key.type = BTRFS_EXTENT_ITEM_KEY;
> @@ -7896,7 +7891,6 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
>         if (!path)
>                 return -ENOMEM;
>
> -       path->leave_spinning = 1;
>         ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
>                                       ins, size);
>         if (ret) {
> @@ -7985,7 +7979,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
>                 return -ENOMEM;
>         }
>
> -       path->leave_spinning = 1;
>         ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
>                                       &extent_key, size);
>         if (ret) {
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 628f1aef34b0..481a4bbc49fd 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4444,7 +4444,6 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>         path = btrfs_alloc_path();
>         if (!path)
>                 return -ENOMEM;
> -       path->leave_spinning = 1;
>
>         start = round_down(start, btrfs_inode_sectorsize(inode));
>         len = round_up(max, btrfs_inode_sectorsize(inode)) - start;
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index ba74827beb32..8e25953ed901 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -45,7 +45,6 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
>         file_key.offset = pos;
>         file_key.type = BTRFS_EXTENT_DATA_KEY;
>
> -       path->leave_spinning = 1;
>         ret = btrfs_insert_empty_item(trans, root, path, &file_key,
>                                       sizeof(*item));
>         if (ret < 0)
> @@ -598,7 +597,6 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
>                 key.offset = end_byte - 1;
>                 key.type = BTRFS_EXTENT_CSUM_KEY;
>
> -               path->leave_spinning = 1;
>                 ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>                 if (ret > 0) {
>                         if (path->slots[0] == 0)
> @@ -874,10 +872,8 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
>         } else {
>                 ins_size = csum_size;
>         }
> -       path->leave_spinning = 1;
>         ret = btrfs_insert_empty_item(trans, root, path, &file_key,
>                                       ins_size);
> -       path->leave_spinning = 0;
>         if (ret < 0)
>                 goto fail_unlock;
>         if (WARN_ON(ret != 0))
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index d6736595ec57..bccc33bb453c 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1188,8 +1188,6 @@ static int clear_free_space_tree(struct btrfs_trans_handle *trans,
>         if (!path)
>                 return -ENOMEM;
>
> -       path->leave_spinning = 1;
> -
>         key.objectid = 0;
>         key.type = 0;
>         key.offset = 0;
> diff --git a/fs/btrfs/inode-item.c b/fs/btrfs/inode-item.c
> index a8956a3c9e05..97a7b4de1033 100644
> --- a/fs/btrfs/inode-item.c
> +++ b/fs/btrfs/inode-item.c
> @@ -129,8 +129,6 @@ static int btrfs_del_inode_extref(struct btrfs_trans_handle *trans,
>         if (!path)
>                 return -ENOMEM;
>
> -       path->leave_spinning = 1;
> -
>         ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>         if (ret > 0)
>                 ret = -ENOENT;
> @@ -203,8 +201,6 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
>         if (!path)
>                 return -ENOMEM;
>
> -       path->leave_spinning = 1;
> -
>         ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>         if (ret > 0) {
>                 ret = -ENOENT;
> @@ -278,7 +274,6 @@ static int btrfs_insert_inode_extref(struct btrfs_trans_handle *trans,
>         if (!path)
>                 return -ENOMEM;
>
> -       path->leave_spinning = 1;
>         ret = btrfs_insert_empty_item(trans, root, path, &key,
>                                       ins_len);
>         if (ret == -EEXIST) {
> @@ -335,7 +330,6 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
>         if (!path)
>                 return -ENOMEM;
>
> -       path->leave_spinning = 1;
>         path->skip_release_on_error = 1;
>         ret = btrfs_insert_empty_item(trans, root, path, &key,
>                                       ins_len);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9357a19d2bff..8b135a46835f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -191,7 +191,6 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
>                 key.type = BTRFS_EXTENT_DATA_KEY;
>
>                 datasize = btrfs_file_extent_calc_inline_size(cur_size);
> -               path->leave_spinning = 1;
>                 ret = btrfs_insert_empty_item(trans, root, path, &key,
>                                               datasize);
>                 if (ret)
> @@ -2236,7 +2235,6 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>                 ins.offset = file_pos;
>                 ins.type = BTRFS_EXTENT_DATA_KEY;
>
> -               path->leave_spinning = 1;
>                 ret = btrfs_insert_empty_item(trans, root, path, &ins,
>                                               sizeof(*fi));
>                 if (ret)
> @@ -2668,7 +2666,6 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
>         key.type = BTRFS_EXTENT_DATA_KEY;
>         key.offset = start;
>
> -       path->leave_spinning = 1;
>         if (merge) {
>                 struct btrfs_file_extent_item *fi;
>                 u64 extent_len;
> @@ -2739,7 +2736,6 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
>         ret = 1;
>  out_free_path:
>         btrfs_release_path(path);
> -       path->leave_spinning = 0;
>         btrfs_end_transaction(trans);
>  out_unlock:
>         unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, lock_end,
> @@ -3833,7 +3829,6 @@ static noinline int btrfs_update_inode_item(struct btrfs_trans_handle *trans,
>         if (!path)
>                 return -ENOMEM;
>
> -       path->leave_spinning = 1;
>         ret = btrfs_lookup_inode(trans, root, path, &BTRFS_I(inode)->location,
>                                  1);
>         if (ret) {
> @@ -3924,7 +3919,6 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>                 goto out;
>         }
>
> -       path->leave_spinning = 1;
>         di = btrfs_lookup_dir_item(trans, root, path, dir_ino,
>                                     name, name_len, -1);
>         if (IS_ERR(di)) {
> @@ -4584,7 +4578,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>                 goto out;
>         }
>
> -       path->leave_spinning = 1;
>         ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>         if (ret < 0)
>                 goto out;
> @@ -6300,7 +6293,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>                 goto fail;
>         }
>
> -       path->leave_spinning = 1;
>         ret = btrfs_insert_empty_items(trans, root, path, key, sizes, nitems);
>         if (ret != 0)
>                 goto fail_unlock;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d3a5d2a41e5f..1de051f529f9 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3899,7 +3899,6 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                  * note the key will change type as we walk through the
>                  * tree.
>                  */
> -               path->leave_spinning = 1;
>                 ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path,
>                                 0, 0);
>                 if (ret < 0)
> @@ -3981,7 +3980,6 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
>                                            size);
>
>                         btrfs_release_path(path);
> -                       path->leave_spinning = 0;
>
>                         memcpy(&new_key, &key, sizeof(new_key));
>                         new_key.objectid = btrfs_ino(BTRFS_I(inode));
> @@ -4371,7 +4369,6 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
>                 ret = -ENOMEM;
>                 goto out;
>         }
> -       path->leave_spinning = 1;
>
>         trans = btrfs_start_transaction(root, 1);
>         if (IS_ERR(trans)) {
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 4353bb69bb86..58e859593bbb 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -844,8 +844,6 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
>         if (!path)
>                 return -ENOMEM;
>
> -       path->leave_spinning = 1;
> -
>         key.objectid = 0;
>         key.offset = 0;
>         key.type = 0;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 6601c9aa5e35..4aa0b4f61ffd 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1015,7 +1015,6 @@ static char *get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
>                 ret = -ENOMEM;
>                 goto err;
>         }
> -       path->leave_spinning = 1;
>
>         name = kmalloc(PATH_MAX, GFP_KERNEL);
>         if (!name) {
> @@ -1143,7 +1142,6 @@ static int get_default_subvol_objectid(struct btrfs_fs_info *fs_info, u64 *objec
>         path = btrfs_alloc_path();
>         if (!path)
>                 return -ENOMEM;
> -       path->leave_spinning = 1;
>
>         /*
>          * Find the "default" dir item which points to the root item that we
> diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
> index 412b910b04cc..91233a0d4d62 100644
> --- a/fs/btrfs/tests/qgroup-tests.c
> +++ b/fs/btrfs/tests/qgroup-tests.c
> @@ -36,7 +36,6 @@ static int insert_normal_tree_ref(struct btrfs_root *root, u64 bytenr,
>                 return -ENOMEM;
>         }
>
> -       path->leave_spinning = 1;
>         ret = btrfs_insert_empty_item(&trans, root, path, &ins, size);
>         if (ret) {
>                 test_err("couldn't insert ref %d", ret);
> @@ -86,7 +85,6 @@ static int add_tree_ref(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
>                 return -ENOMEM;
>         }
>
> -       path->leave_spinning = 1;
>         ret = btrfs_search_slot(&trans, root, &key, path, 0, 1);
>         if (ret) {
>                 test_err("couldn't find extent ref");
> @@ -135,7 +133,6 @@ static int remove_extent_item(struct btrfs_root *root, u64 bytenr,
>                 test_err("couldn't allocate path");
>                 return -ENOMEM;
>         }
> -       path->leave_spinning = 1;
>
>         ret = btrfs_search_slot(&trans, root, &key, path, -1, 1);
>         if (ret) {
> @@ -170,7 +167,6 @@ static int remove_extent_ref(struct btrfs_root *root, u64 bytenr,
>                 return -ENOMEM;
>         }
>
> -       path->leave_spinning = 1;
>         ret = btrfs_search_slot(&trans, root, &key, path, 0, 1);
>         if (ret) {
>                 test_err("couldn't find extent ref");
> --
> 1.8.3.1
>
