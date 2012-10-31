Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42449 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935506Ab2JaMzp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 08:55:45 -0400
Message-ID: <50911FC0.4080104@oracle.com>
Date: Wed, 31 Oct 2012 20:55:28 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v4] Btrfs: snapshot-aware defrag
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com> <CANW9uyu0NyFj57AVp2X-Hc=AjXdwyP=wieOcteEbj2_Mx_F95w@mail.gmail.com>
In-Reply-To: <CANW9uyu0NyFj57AVp2X-Hc=AjXdwyP=wieOcteEbj2_Mx_F95w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 08:13 PM, Itaru Kitayama wrote:
> Hi LiuBo:
> 
> I am seeing another warning with your patch applied btrfs-next.
> 

Hi Itaru,

Thanks for testing, you seems to be using an old version, since in the new version
record_extent_backrefs() does not own a WARN_ON().

Could you please test it again with the new patches applied?

thanks,
liubo


> [ 5224.531560] ------------[ cut here ]------------
> [ 5224.531565] WARNING: at fs/btrfs/inode.c:2054
> record_extent_backrefs+0x87/0xe0()
> [ 5224.531567] Hardware name: Bochs
> [ 5224.531568] Modules linked in: microcode ppdev psmouse nfsd nfs_acl
> auth_rpcgss serio_raw nfs fscache lockd binfmt_misc sunrpc cirrus
> parport_pc ttm drm_kms_helper drm sysimgblt i2c_piix4 sysfillrect
> syscopyarea i2c_core lp parport floppy
> [ 5224.531591] Pid: 2485, comm: btrfs-endio-wri Tainted: G        W
> 3.7.0-rc1-v11+ #53
> [ 5224.531592] Call Trace:
> [ 5224.531598]  [<ffffffff81061c63>] warn_slowpath_common+0x93/0xc0
> [ 5224.531600]  [<ffffffff81061caa>] warn_slowpath_null+0x1a/0x20
> [ 5224.531603]  [<ffffffff81322287>] record_extent_backrefs+0x87/0xe0
> [ 5224.531606]  [<ffffffff8132d10b>] btrfs_finish_ordered_io+0x8bb/0xa80
> [ 5224.531611]  [<ffffffff810ce300>] ? trace_hardirqs_off_caller+0xb0/0x140
> [ 5224.531614]  [<ffffffff8132d2e5>] finish_ordered_fn+0x15/0x20
> [ 5224.531617]  [<ffffffff8134beb7>] worker_loop+0x157/0x580
> [ 5224.531620]  [<ffffffff8134bd60>] ? btrfs_queue_worker+0x2f0/0x2f0
> [ 5224.531624]  [<ffffffff81090aa8>] kthread+0xe8/0xf0
> [ 5224.531627]  [<ffffffff810ce3c2>] ? get_lock_stats+0x22/0x70
> [ 5224.531630]  [<ffffffff810909c0>] ? kthread_create_on_node+0x160/0x160
> [ 5224.531634]  [<ffffffff817c1c6c>] ret_from_fork+0x7c/0xb0
> [ 5224.531636]  [<ffffffff810909c0>] ? kthread_create_on_node+0x160/0x160
> [ 5224.531638] ---[ end trace 0256d2b5a195208c ]---
> 
> I've compared some of the old extents logical addresses with the corresponding
> object ids and offsets from the extent tree; some are just 8k off from
> the found extents
> and some keys are totally off.
> 
> Itaru
> 
> On Sat, Oct 27, 2012 at 7:28 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
>> This comes from one of btrfs's project ideas,
>> As we defragment files, we break any sharing from other snapshots.
>> The balancing code will preserve the sharing, and defrag needs to grow this
>> as well.
>>
>> Now we're able to fill the blank with this patch, in which we make full use of
>> backref walking stuff.
>>
>> Here is the basic idea,
>> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
>> o  at endio, after we finish updating fs tree, we use backref walking to find
>>    all parents of the ranges and re-link them with the new COWed file layout by
>>    adding corresponding backrefs.
>>
>> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>> v3->v4:
>>       - fix duplicated refs bugs detected by mounting with autodefrag, thanks
>>         for the bug report from Mitch and Chris.
>>
>>  fs/btrfs/inode.c |  609 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 609 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 85a1e50..35e6993 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -54,6 +54,7 @@
>>  #include "locking.h"
>>  #include "free-space-cache.h"
>>  #include "inode-map.h"
>> +#include "backref.h"
>>
>>  struct btrfs_iget_args {
>>         u64 ino;
>> @@ -1839,6 +1840,600 @@ out:
>>         return ret;
>>  }
>>
>> +/* snapshot-aware defrag */
>> +struct sa_defrag_extent_backref {
>> +       struct rb_node node;
>> +       struct old_sa_defrag_extent *old;
>> +       u64 root_id;
>> +       u64 inum;
>> +       u64 file_pos;
>> +       u64 extent_offset;
>> +       u64 num_bytes;
>> +       u64 generation;
>> +};
>> +
>> +struct old_sa_defrag_extent {
>> +       struct list_head list;
>> +       struct new_sa_defrag_extent *new;
>> +
>> +       u64 extent_offset;
>> +       u64 bytenr;
>> +       u64 offset;
>> +       u64 len;
>> +       int count;
>> +};
>> +
>> +struct new_sa_defrag_extent {
>> +       struct rb_root root;
>> +       struct list_head head;
>> +       struct btrfs_path *path;
>> +       struct inode *inode;
>> +       u64 file_pos;
>> +       u64 len;
>> +       u64 bytenr;
>> +       u64 disk_len;
>> +       u8 compress_type;
>> +};
>> +
>> +static int backref_comp(struct sa_defrag_extent_backref *b1,
>> +                       struct sa_defrag_extent_backref *b2)
>> +{
>> +       if (b1->root_id < b2->root_id)
>> +               return -1;
>> +       else if (b1->root_id > b2->root_id)
>> +               return 1;
>> +
>> +       if (b1->inum < b2->inum)
>> +               return -1;
>> +       else if (b1->inum > b2->inum)
>> +               return 1;
>> +
>> +       if (b1->file_pos < b2->file_pos)
>> +               return -1;
>> +       else if (b1->file_pos > b2->file_pos)
>> +               return 1;
>> +
>> +       return 0;
>> +}
>> +
>> +static void backref_insert(struct rb_root *root,
>> +                          struct sa_defrag_extent_backref *backref)
>> +{
>> +       struct rb_node **p = &root->rb_node;
>> +       struct rb_node *parent = NULL;
>> +       struct sa_defrag_extent_backref *entry;
>> +       int ret;
>> +
>> +       while (*p) {
>> +               parent = *p;
>> +               entry = rb_entry(parent, struct sa_defrag_extent_backref, node);
>> +
>> +               ret = backref_comp(backref, entry);
>> +               if (ret < 0)
>> +                       p = &(*p)->rb_left;
>> +               else
>> +                       /*
>> +                        * Since space can be shared, so there can be
>> +                        * some backrefs(extent tree to fs/file tree)
>> +                        * whoes fs/file extents map to the same address.
>> +                        * If so, we just put it after what we've found.
>> +                        */
>> +                       p = &(*p)->rb_right;
>> +       }
>> +
>> +       rb_link_node(&backref->node, parent, p);
>> +       rb_insert_color(&backref->node, root);
>> +}
>> +
>> +/*
>> + * Note the backref might has changed, and in this case we just return 0.
>> + */
>> +static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
>> +                                      void *ctx)
>> +{
>> +       struct btrfs_file_extent_item *extent;
>> +       struct btrfs_fs_info *fs_info;
>> +       struct old_sa_defrag_extent *old = ctx;
>> +       struct new_sa_defrag_extent *new = old->new;
>> +       struct btrfs_path *path = new->path;
>> +       struct btrfs_key key;
>> +       struct btrfs_root *root;
>> +       struct sa_defrag_extent_backref *backref;
>> +       struct extent_buffer *leaf;
>> +       struct inode *inode = new->inode;
>> +       int slot;
>> +       int ret;
>> +       u64 extent_offset;
>> +       u64 num_bytes;
>> +
>> +       if (BTRFS_I(inode)->root->root_key.objectid == root_id &&
>> +           inum == btrfs_ino(inode))
>> +               return 0;
>> +
>> +       key.objectid = root_id;
>> +       key.type = BTRFS_ROOT_ITEM_KEY;
>> +       key.offset = (u64)-1;
>> +
>> +       fs_info = BTRFS_I(inode)->root->fs_info;
>> +       root = btrfs_read_fs_root_no_name(fs_info, &key);
>> +       if (IS_ERR(root)) {
>> +               if (PTR_ERR(root) == -ENOENT)
>> +                       return 0;
>> +               WARN_ON(1);
>> +               pr_debug("inum=%llu, offset=%llu, root_id=%llu\n",
>> +                        inum, offset, root_id);
>> +               return PTR_ERR(root);
>> +       }
>> +
>> +       key.objectid = inum;
>> +       key.type = BTRFS_EXTENT_DATA_KEY;
>> +       if (offset > (u64)-1 << 32)
>> +               key.offset = 0;
>> +       else
>> +               key.offset = offset;
>> +
>> +       ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +       if (ret < 0) {
>> +               WARN_ON(1);
>> +               return ret;
>> +       }
>> +
>> +       while (1) {
>> +               cond_resched();
>> +
>> +               leaf = path->nodes[0];
>> +               slot = path->slots[0];
>> +
>> +               if (slot >= btrfs_header_nritems(leaf)) {
>> +                       ret = btrfs_next_leaf(root, path);
>> +                       if (ret < 0) {
>> +                               goto out;
>> +                       } else if (ret > 0) {
>> +                               ret = 0;
>> +                               goto out;
>> +                       }
>> +                       continue;
>> +               }
>> +
>> +               path->slots[0]++;
>> +
>> +               btrfs_item_key_to_cpu(leaf, &key, slot);
>> +
>> +               if (key.objectid > inum)
>> +                       goto out;
>> +
>> +               if (key.objectid < inum || key.type != BTRFS_EXTENT_DATA_KEY)
>> +                       continue;
>> +
>> +               extent = btrfs_item_ptr(leaf, slot,
>> +                                       struct btrfs_file_extent_item);
>> +
>> +               if (btrfs_file_extent_disk_bytenr(leaf, extent) != old->bytenr)
>> +                       continue;
>> +
>> +               extent_offset = btrfs_file_extent_offset(leaf, extent);
>> +               if (key.offset - extent_offset != offset)
>> +                       continue;
>> +
>> +               num_bytes = btrfs_file_extent_num_bytes(leaf, extent);
>> +               if (extent_offset >= old->extent_offset + old->offset +
>> +                   old->len || extent_offset + num_bytes <=
>> +                   old->extent_offset + old->offset)
>> +                       continue;
>> +
>> +               break;
>> +       }
>> +
>> +       backref = kmalloc(sizeof(*backref), GFP_NOFS);
>> +       if (!backref) {
>> +               ret = -ENOENT;
>> +               goto out;
>> +       }
>> +
>> +       backref->root_id = root_id;
>> +       backref->inum = inum;
>> +       backref->file_pos = offset + extent_offset;
>> +       backref->num_bytes = num_bytes;
>> +       backref->extent_offset = extent_offset;
>> +       backref->generation = btrfs_file_extent_generation(leaf, extent);
>> +       backref->old = old;
>> +       backref_insert(&new->root, backref);
>> +       old->count++;
>> +out:
>> +       btrfs_release_path(path);
>> +       WARN_ON(ret);
>> +       return ret;
>> +}
>> +
>> +static noinline bool record_extent_backrefs(struct btrfs_path *path,
>> +                                  struct new_sa_defrag_extent *new)
>> +{
>> +       struct btrfs_fs_info *fs_info = BTRFS_I(new->inode)->root->fs_info;
>> +       struct old_sa_defrag_extent *old, *tmp;
>> +       int ret;
>> +
>> +       new->path = path;
>> +
>> +       list_for_each_entry_safe(old, tmp, &new->head, list) {
>> +               ret = iterate_inodes_from_logical(old->bytenr, fs_info,
>> +                                                 path, record_one_backref,
>> +                                                 old);
>> +               BUG_ON(ret < 0 && ret != -ENOENT);
>> +
>> +               /* no backref to be processed for this extent */
>> +               if (!old->count) {
>> +                       list_del(&old->list);
>> +                       kfree(old);
>> +               }
>> +       }
>> +
>> +       if (list_empty(&new->head))
>> +               return false;
>> +
>> +       return true;
>> +}
>> +
>> +/*
>> + * Note the backref might has changed, and in this case we just return 0.
>> + */
>> +static noinline int relink_extent_backref(struct btrfs_path *path,
>> +                                struct sa_defrag_extent_backref *prev,
>> +                                struct sa_defrag_extent_backref *backref)
>> +{
>> +       struct btrfs_file_extent_item *extent;
>> +       struct btrfs_file_extent_item *item;
>> +       struct btrfs_ordered_extent *ordered;
>> +       struct btrfs_trans_handle *trans;
>> +       struct btrfs_fs_info *fs_info;
>> +       struct btrfs_root *root;
>> +       struct btrfs_key key;
>> +       struct extent_buffer *leaf;
>> +       struct old_sa_defrag_extent *old = backref->old;
>> +       struct new_sa_defrag_extent *new = old->new;
>> +       struct inode *src_inode = new->inode;
>> +       struct inode *inode;
>> +       struct extent_state *cached = NULL;
>> +       int ret = 0;
>> +       u64 start;
>> +       u64 len;
>> +       u64 lock_start;
>> +       u64 lock_end;
>> +       bool merge = false;
>> +
>> +       if (prev && prev->root_id == backref->root_id &&
>> +           prev->inum == backref->inum &&
>> +           prev->file_pos + prev->num_bytes == backref->file_pos)
>> +               merge = true;
>> +
>> +       key.objectid = backref->root_id;
>> +       key.type = BTRFS_ROOT_ITEM_KEY;
>> +       key.offset = (u64)-1;
>> +
>> +       fs_info = BTRFS_I(src_inode)->root->fs_info;
>> +       root = btrfs_read_fs_root_no_name(fs_info, &key);
>> +       if (IS_ERR(root)) {
>> +               if (PTR_ERR(root) == -ENOENT)
>> +                       return 0;
>> +               return PTR_ERR(root);
>> +       }
>> +
>> +       key.objectid = backref->inum;
>> +       key.type = BTRFS_INODE_ITEM_KEY;
>> +       key.offset = 0;
>> +
>> +       inode = btrfs_iget(fs_info->sb, &key, root, NULL);
>> +       if (IS_ERR_OR_NULL(inode) || is_bad_inode(inode)) {
>> +               if (inode && !IS_ERR(inode))
>> +                       iput(inode);
>> +               return 0;
>> +       }
>> +
>> +       lock_start = backref->file_pos;
>> +       lock_end = backref->file_pos + backref->num_bytes - 1;
>> +       lock_extent_bits(&BTRFS_I(inode)->io_tree, lock_start, lock_end,
>> +                        0, &cached);
>> +
>> +       ordered = btrfs_lookup_first_ordered_extent(inode, lock_end);
>> +       if (ordered) {
>> +               btrfs_put_ordered_extent(ordered);
>> +               goto out_unlock;
>> +       }
>> +
>> +       trans = btrfs_join_transaction(root);
>> +       if (IS_ERR(trans)) {
>> +               ret = PTR_ERR(trans);
>> +               goto out_unlock;
>> +       }
>> +
>> +       key.objectid = backref->inum;
>> +       key.type = BTRFS_EXTENT_DATA_KEY;
>> +       key.offset = backref->file_pos;
>> +
>> +       ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +       if (ret < 0) {
>> +               goto out_free_path;
>> +       } else if (ret > 0) {
>> +               ret = 0;
>> +               goto out_free_path;
>> +       }
>> +
>> +       extent = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> +                               struct btrfs_file_extent_item);
>> +
>> +       if (btrfs_file_extent_generation(path->nodes[0], extent) !=
>> +           backref->generation)
>> +               goto out_free_path;
>> +
>> +       btrfs_release_path(path);
>> +
>> +       start = backref->file_pos;
>> +       if (backref->extent_offset < old->extent_offset + old->offset)
>> +               start += old->extent_offset + old->offset -
>> +                        backref->extent_offset;
>> +
>> +       len = min(backref->extent_offset + backref->num_bytes,
>> +                 old->extent_offset + old->offset + old->len);
>> +       len -= max(backref->extent_offset, old->extent_offset + old->offset);
>> +
>> +       ret = btrfs_drop_extents(trans, root, inode, start,
>> +                                start + len, 1);
>> +       if (ret)
>> +               goto out_free_path;
>> +again:
>> +       key.objectid = btrfs_ino(inode);
>> +       key.type = BTRFS_EXTENT_DATA_KEY;
>> +       key.offset = start;
>> +
>> +       if (merge) {
>> +               struct btrfs_file_extent_item *fi;
>> +               u64 extent_len;
>> +               struct btrfs_key found_key;
>> +
>> +               ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
>> +               if (ret < 0)
>> +                       goto out_free_path;
>> +
>> +               path->slots[0]--;
>> +               leaf = path->nodes[0];
>> +               btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
>> +
>> +               fi = btrfs_item_ptr(leaf, path->slots[0],
>> +                                   struct btrfs_file_extent_item);
>> +               extent_len = btrfs_file_extent_num_bytes(leaf, fi);
>> +
>> +               if (btrfs_file_extent_disk_bytenr(leaf, fi) == new->bytenr &&
>> +                   btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_REG &&
>> +                   !btrfs_file_extent_compression(leaf, fi) &&
>> +                   !btrfs_file_extent_encryption(leaf, fi) &&
>> +                   !btrfs_file_extent_other_encoding(leaf, fi) &&
>> +                   extent_len + found_key.offset == start) {
>> +                       btrfs_set_file_extent_num_bytes(leaf, fi,
>> +                                                       extent_len + len);
>> +                       btrfs_mark_buffer_dirty(leaf);
>> +                       inode_add_bytes(inode, len);
>> +
>> +                       ret = 1;
>> +                       goto out_free_path;
>> +               } else {
>> +                       merge = false;
>> +                       btrfs_release_path(path);
>> +                       goto again;
>> +               }
>> +       }
>> +
>> +       ret = btrfs_insert_empty_item(trans, root, path, &key,
>> +                                       sizeof(*extent));
>> +       if (ret) {
>> +               btrfs_abort_transaction(trans, root, ret);
>> +               goto out_free_path;
>> +       }
>> +
>> +       leaf = path->nodes[0];
>> +       item = btrfs_item_ptr(leaf, path->slots[0],
>> +                               struct btrfs_file_extent_item);
>> +       btrfs_set_file_extent_disk_bytenr(leaf, item, new->bytenr);
>> +       btrfs_set_file_extent_disk_num_bytes(leaf, item, new->disk_len);
>> +       btrfs_set_file_extent_offset(leaf, item, start - new->file_pos);
>> +       btrfs_set_file_extent_num_bytes(leaf, item, len);
>> +       btrfs_set_file_extent_ram_bytes(leaf, item, new->len);
>> +       btrfs_set_file_extent_generation(leaf, item, trans->transid);
>> +       btrfs_set_file_extent_type(leaf, item, BTRFS_FILE_EXTENT_REG);
>> +       btrfs_set_file_extent_compression(leaf, item, new->compress_type);
>> +       btrfs_set_file_extent_encryption(leaf, item, 0);
>> +       btrfs_set_file_extent_other_encoding(leaf, item, 0);
>> +
>> +       btrfs_mark_buffer_dirty(leaf);
>> +       inode_add_bytes(inode, len);
>> +
>> +       ret = btrfs_inc_extent_ref(trans, root, new->bytenr,
>> +                       new->disk_len, 0,
>> +                       backref->root_id, backref->inum,
>> +                       new->file_pos, 0);      /* start - extent_offset */
>> +       if (ret) {
>> +               btrfs_abort_transaction(trans, root, ret);
>> +               goto out_free_path;
>> +       }
>> +
>> +       ret = 1;
>> +out_free_path:
>> +       btrfs_release_path(path);
>> +       btrfs_end_transaction(trans, root);
>> +out_unlock:
>> +       unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, lock_end,
>> +                            &cached, GFP_NOFS);
>> +       iput(inode);
>> +       return ret;
>> +}
>> +
>> +static void relink_file_extents(struct new_sa_defrag_extent *new)
>> +{
>> +       struct btrfs_path *path;
>> +       struct old_sa_defrag_extent *old, *tmp;
>> +       struct sa_defrag_extent_backref *backref;
>> +       struct sa_defrag_extent_backref *prev = NULL;
>> +       struct inode *inode;
>> +       struct btrfs_root *root;
>> +       struct rb_node *node;
>> +       int ret;
>> +
>> +       inode = new->inode;
>> +       root = BTRFS_I(inode)->root;
>> +
>> +       path = btrfs_alloc_path();
>> +       if (!path)
>> +               return;
>> +
>> +       if (!record_extent_backrefs(path, new)) {
>> +               btrfs_free_path(path);
>> +               goto out;
>> +       }
>> +       btrfs_release_path(path);
>> +
>> +       while (1) {
>> +               node = rb_first(&new->root);
>> +               if (!node)
>> +                       break;
>> +               rb_erase(node, &new->root);
>> +
>> +               backref = rb_entry(node, struct sa_defrag_extent_backref, node);
>> +
>> +               ret = relink_extent_backref(path, prev, backref);
>> +               WARN_ON(ret < 0);
>> +
>> +               kfree(prev);
>> +
>> +               if (ret == 1)
>> +                       prev = backref;
>> +               else
>> +                       prev = NULL;
>> +               cond_resched();
>> +       }
>> +       kfree(prev);
>> +
>> +       btrfs_free_path(path);
>> +
>> +       list_for_each_entry_safe(old, tmp, &new->head, list) {
>> +               list_del(&old->list);
>> +               kfree(old);
>> +       }
>> +out:
>> +       atomic_dec(&root->fs_info->defrag_running);
>> +       wake_up(&root->fs_info->transaction_wait);
>> +
>> +       kfree(new);
>> +}
>> +
>> +static struct new_sa_defrag_extent *
>> +record_old_file_extents(struct inode *inode,
>> +                       struct btrfs_ordered_extent *ordered)
>> +{
>> +       struct btrfs_root *root = BTRFS_I(inode)->root;
>> +       struct btrfs_path *path;
>> +       struct btrfs_key key;
>> +       struct old_sa_defrag_extent *old, *tmp;
>> +       struct new_sa_defrag_extent *new;
>> +       int ret;
>> +
>> +       new = kmalloc(sizeof(*new), GFP_NOFS);
>> +       if (!new)
>> +               return NULL;
>> +
>> +       new->inode = inode;
>> +       new->file_pos = ordered->file_offset;
>> +       new->len = ordered->len;
>> +       new->bytenr = ordered->start;
>> +       new->disk_len = ordered->disk_len;
>> +       new->compress_type = ordered->compress_type;
>> +       new->root = RB_ROOT;
>> +       INIT_LIST_HEAD(&new->head);
>> +
>> +       path = btrfs_alloc_path();
>> +       if (!path)
>> +               goto out_kfree;
>> +
>> +       key.objectid = btrfs_ino(inode);
>> +       key.type = BTRFS_EXTENT_DATA_KEY;
>> +       key.offset = new->file_pos;
>> +
>> +       ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +       if (ret < 0)
>> +               goto out_free_path;
>> +       if (ret > 0 && path->slots[0] > 0)
>> +               path->slots[0]--;
>> +
>> +       /* find out all the old extents for the file range */
>> +       while (1) {
>> +               struct btrfs_file_extent_item *extent;
>> +               struct extent_buffer *l;
>> +               int slot;
>> +               u64 num_bytes;
>> +               u64 offset;
>> +               u64 end;
>> +
>> +               l = path->nodes[0];
>> +               slot = path->slots[0];
>> +
>> +               if (slot >= btrfs_header_nritems(l)) {
>> +                       ret = btrfs_next_leaf(root, path);
>> +                       if (ret < 0)
>> +                               goto out_free_list;
>> +                       else if (ret > 0)
>> +                               break;
>> +                       continue;
>> +               }
>> +
>> +               btrfs_item_key_to_cpu(l, &key, slot);
>> +
>> +               if (key.objectid != btrfs_ino(inode))
>> +                       break;
>> +               if (key.type != BTRFS_EXTENT_DATA_KEY)
>> +                       break;
>> +               if (key.offset >= new->file_pos + new->len)
>> +                       break;
>> +
>> +               extent = btrfs_item_ptr(l, slot, struct btrfs_file_extent_item);
>> +
>> +               num_bytes = btrfs_file_extent_num_bytes(l, extent);
>> +               if (key.offset + num_bytes < new->file_pos)
>> +                       goto next;
>> +
>> +               old = kmalloc(sizeof(*old), GFP_NOFS);
>> +               if (!old)
>> +                       goto out_free_list;
>> +
>> +               offset = max(new->file_pos, key.offset);
>> +               end = min(new->file_pos + new->len, key.offset + num_bytes);
>> +
>> +               old->bytenr = btrfs_file_extent_disk_bytenr(l, extent);
>> +               BUG_ON(!old->bytenr);
>> +               old->extent_offset = btrfs_file_extent_offset(l, extent);
>> +               old->offset = offset - key.offset;
>> +               old->len = end - offset;
>> +               old->new = new;
>> +               old->count = 0;
>> +               list_add_tail(&old->list, &new->head);
>> +next:
>> +               path->slots[0]++;
>> +               cond_resched();
>> +       }
>> +
>> +       btrfs_free_path(path);
>> +       atomic_inc(&root->fs_info->defrag_running);
>> +
>> +       return new;
>> +
>> +out_free_list:
>> +       list_for_each_entry_safe(old, tmp, &new->head, list) {
>> +               list_del(&old->list);
>> +               kfree(old);
>> +       }
>> +out_free_path:
>> +       btrfs_free_path(path);
>> +out_kfree:
>> +       kfree(new);
>> +       return NULL;
>> +}
>> +
>>  /*
>>   * helper function for btrfs_finish_ordered_io, this
>>   * just reads in some of the csum leaves to prime them into ram
>> @@ -1856,6 +2451,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>>         struct btrfs_trans_handle *trans = NULL;
>>         struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
>>         struct extent_state *cached_state = NULL;
>> +       struct new_sa_defrag_extent *new = NULL;
>>         int compress_type = 0;
>>         int ret;
>>         bool nolock;
>> @@ -1892,6 +2488,15 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>>                          ordered_extent->file_offset + ordered_extent->len - 1,
>>                          0, &cached_state);
>>
>> +       ret = test_range_bit(io_tree, ordered_extent->file_offset,
>> +                       ordered_extent->file_offset + ordered_extent->len - 1,
>> +                       EXTENT_DEFRAG, 1, cached_state);
>> +       if (ret && btrfs_root_last_snapshot(&root->root_item) >=
>> +                                               BTRFS_I(inode)->generation) {
>> +               /* the inode is shared */
>> +               new = record_old_file_extents(inode, ordered_extent);
>> +       }
>> +
>>         if (nolock)
>>                 trans = btrfs_join_transaction_nolock(root);
>>         else
>> @@ -1965,6 +2570,10 @@ out:
>>          */
>>         btrfs_remove_ordered_extent(inode, ordered_extent);
>>
>> +       /* for snapshot-aware defrag */
>> +       if (new)
>> +               relink_file_extents(new);
>> +
>>         /* once for us */
>>         btrfs_put_ordered_extent(ordered_extent);
>>         /* once for the tree */
>> --
>> 1.7.7.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

