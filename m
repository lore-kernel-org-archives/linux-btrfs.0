Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64219 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaCHQsO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Mar 2014 11:48:14 -0500
Received: by mail-wg0-f52.google.com with SMTP id k14so6659541wgh.23
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Mar 2014 08:48:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <53156CEE.5060308@cn.fujitsu.com>
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
	<1389787258-10865-5-git-send-email-miaox@cn.fujitsu.com>
	<CAOcd+r0UPMbxMzfa=Mpj96zYo1pO2C6NB3HrR6bipYbFmLVFdw@mail.gmail.com>
	<53156CEE.5060308@cn.fujitsu.com>
Date: Sat, 8 Mar 2014 18:48:12 +0200
Message-ID: <CAOcd+r0O1C-CmQqY_yX+fOhp+tb3UHfQr5k8p54w3yVPsJR9cQ@mail.gmail.com>
Subject: Re: [RFC PATCH 5/5] Btrfs: fix broken free space cache after the
 system crashed
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, Miao,
so the problem is that cow_file_range() joins transaction, allocates
space through btrfs_reserve_extent(), then detaches from transaction.
And then btrfs_finish_ordered_io() joins transaction again, adds a
delayed ref and detaches from transaction. So if between these two,
the transaction commits and we crash, then yes, the allocation is
lost.

Alex.


On Tue, Mar 4, 2014 at 8:04 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> On      sat, 1 Mar 2014 20:05:01 +0200, Alex Lyakas wrote:
>> Hi Miao,
>>
>> On Wed, Jan 15, 2014 at 2:00 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>> When we mounted the filesystem after the crash, we got the following
>>> message:
>>>   BTRFS error (device xxx): block group 4315938816 has wrong amount of free space
>>>   BTRFS error (device xxx): failed to load free space cache for block group 4315938816
>>>
>>> It is because we didn't update the metadata of the allocated space until
>>> the file data was written into the disk. During this time, there was no
>>> information about the allocated spaces in either the extent tree nor the
>>> free space cache. when we wrote out the free space cache at this time, those
>>> spaces were lost.
>> Can you please clarify more about the problem?
>> So I understand that we allocate something from the free space cache.
>> So after that, the free space cache does not account for this extent
>> anymore. On the other hand the extent tree also does not account for
>> it (yet). We need to add a delayed reference, which will be run at
>> transaction commit and update the extent tree. But free-space cache is
>> also written out during transaction commit. So how the issue happens?
>> Can you perhaps post a flow of events?
>
>         Task1                           Task2
>         btrfs_writepages()
>           alloc data space
>             (The allocated space was
>              removed from the free
>              space cache)
>           submit_bio()
>                                         btrfs_commit_transaction()
>                                           write out space cache
>                                           ...
>                                           commit transaction completed
>                                         system crash
>          (end_io() wasn't executed)
>
> The system crashed before end_io was executed, so no file references to the
> allocated space, and the extent tree also does not account for it. That space
> was lost.
>
> Thanks
> Miao
>>
>> Thanks.
>> Alex.
>>
>>
>>>
>>> In ordered to fix this problem, I use a state tree for every block group
>>> to record those allocated spaces. We record the information when they are
>>> allocated, and clean up the information after the metadata update. Besides
>>> that, we also introduce a read-write semaphore to avoid the race between
>>> the allocation and the free space cache write out.
>>>
>>> Only data block groups had this problem, so the above change is just
>>> for data space allocation.
>>>
>>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/ctree.h            | 15 ++++++++++++++-
>>>  fs/btrfs/disk-io.c          |  2 +-
>>>  fs/btrfs/extent-tree.c      | 24 ++++++++++++++++++++----
>>>  fs/btrfs/free-space-cache.c | 42 ++++++++++++++++++++++++++++++++++++++----
>>>  fs/btrfs/inode.c            | 42 +++++++++++++++++++++++++++++++++++-------
>>>  5 files changed, 108 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index 1667c9a..f58e1f7 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -1244,6 +1244,12 @@ struct btrfs_block_group_cache {
>>>         /* free space cache stuff */
>>>         struct btrfs_free_space_ctl *free_space_ctl;
>>>
>>> +       /*
>>> +        * It is used to record the extents that are allocated for
>>> +        * the data, but don/t update its metadata.
>>> +        */
>>> +       struct extent_io_tree pinned_extents;
>>> +
>>>         /* block group cache stuff */
>>>         struct rb_node cache_node;
>>>
>>> @@ -1540,6 +1546,13 @@ struct btrfs_fs_info {
>>>          */
>>>         struct list_head space_info;
>>>
>>> +       /*
>>> +        * It is just used for the delayed data space allocation
>>> +        * because only the data space allocation can be done during
>>> +        * we write out the free space cache.
>>> +        */
>>> +       struct rw_semaphore data_rwsem;
>>> +
>>>         struct btrfs_space_info *data_sinfo;
>>>
>>>         struct reloc_control *reloc_ctl;
>>> @@ -3183,7 +3196,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
>>>                                    struct btrfs_key *ins);
>>>  int btrfs_reserve_extent(struct btrfs_root *root, u64 num_bytes,
>>>                          u64 min_alloc_size, u64 empty_size, u64 hint_byte,
>>> -                        struct btrfs_key *ins, int is_data);
>>> +                        struct btrfs_key *ins, int is_data, bool need_pin);
>>>  int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>                   struct extent_buffer *buf, int full_backref, int for_cow);
>>>  int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 8072cfa..426b558 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -2276,7 +2276,6 @@ int open_ctree(struct super_block *sb,
>>>         fs_info->pinned_extents = &fs_info->freed_extents[0];
>>>         fs_info->do_barriers = 1;
>>>
>>> -
>>>         mutex_init(&fs_info->ordered_operations_mutex);
>>>         mutex_init(&fs_info->ordered_extent_flush_mutex);
>>>         mutex_init(&fs_info->tree_log_mutex);
>>> @@ -2287,6 +2286,7 @@ int open_ctree(struct super_block *sb,
>>>         init_rwsem(&fs_info->extent_commit_sem);
>>>         init_rwsem(&fs_info->cleanup_work_sem);
>>>         init_rwsem(&fs_info->subvol_sem);
>>> +       init_rwsem(&fs_info->data_rwsem);
>>>         sema_init(&fs_info->uuid_tree_rescan_sem, 1);
>>>         fs_info->dev_replace.lock_owner = 0;
>>>         atomic_set(&fs_info->dev_replace.nesting_level, 0);
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 3664cfb..7b07876 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -6173,7 +6173,7 @@ enum btrfs_loop_type {
>>>  static noinline int find_free_extent(struct btrfs_root *orig_root,
>>>                                      u64 num_bytes, u64 empty_size,
>>>                                      u64 hint_byte, struct btrfs_key *ins,
>>> -                                    u64 flags)
>>> +                                    u64 flags, bool need_pin)
>>>  {
>>>         int ret = 0;
>>>         struct btrfs_root *root = orig_root->fs_info->extent_root;
>>> @@ -6502,6 +6502,16 @@ checks:
>>>                 ins->objectid = search_start;
>>>                 ins->offset = num_bytes;
>>>
>>> +               if (need_pin) {
>>> +                       ASSERT(search_start >= block_group->key.objectid &&
>>> +                              search_start < block_group->key.objectid +
>>> +                                             block_group->key.offset);
>>> +                       set_extent_dirty(&block_group->pinned_extents,
>>> +                                        search_start,
>>> +                                        search_start + num_bytes - 1,
>>> +                                        GFP_NOFS);
>>> +               }
>>> +
>>>                 trace_btrfs_reserve_extent(orig_root, block_group,
>>>                                            search_start, num_bytes);
>>>                 btrfs_put_block_group(block_group);
>>> @@ -6614,17 +6624,20 @@ again:
>>>  int btrfs_reserve_extent(struct btrfs_root *root,
>>>                          u64 num_bytes, u64 min_alloc_size,
>>>                          u64 empty_size, u64 hint_byte,
>>> -                        struct btrfs_key *ins, int is_data)
>>> +                        struct btrfs_key *ins, int is_data, bool need_pin)
>>>  {
>>>         bool final_tried = false;
>>>         u64 flags;
>>>         int ret;
>>>
>>>         flags = btrfs_get_alloc_profile(root, is_data);
>>> +
>>> +       if (need_pin)
>>> +               down_read(&root->fs_info->data_rwsem);
>>>  again:
>>>         WARN_ON(num_bytes < root->sectorsize);
>>>         ret = find_free_extent(root, num_bytes, empty_size, hint_byte, ins,
>>> -                              flags);
>>> +                              flags, need_pin);
>>>
>>>         if (ret == -ENOSPC) {
>>>                 if (!final_tried && ins->offset) {
>>> @@ -6645,6 +6658,8 @@ again:
>>>                 }
>>>         }
>>>
>>> +       if (need_pin)
>>> +               up_read(&root->fs_info->data_rwsem);
>>>         return ret;
>>>  }
>>>
>>> @@ -7016,7 +7031,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
>>>                 return ERR_CAST(block_rsv);
>>>
>>>         ret = btrfs_reserve_extent(root, blocksize, blocksize,
>>> -                                  empty_size, hint, &ins, 0);
>>> +                                  empty_size, hint, &ins, 0, false);
>>>         if (ret) {
>>>                 unuse_block_rsv(root->fs_info, block_rsv, blocksize);
>>>                 return ERR_PTR(ret);
>>> @@ -8387,6 +8402,7 @@ btrfs_create_block_group_cache(struct btrfs_root *root, u64 start, u64 size)
>>>         INIT_LIST_HEAD(&cache->cluster_list);
>>>         INIT_LIST_HEAD(&cache->new_bg_list);
>>>         btrfs_init_free_space_ctl(cache);
>>> +       extent_io_tree_init(&cache->pinned_extents, NULL);
>>>
>>>         return cache;
>>>  }
>>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>>> index 057be95..486e12a3 100644
>>> --- a/fs/btrfs/free-space-cache.c
>>> +++ b/fs/btrfs/free-space-cache.c
>>> @@ -875,6 +875,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>>>         struct rb_node *node;
>>>         struct list_head *pos, *n;
>>>         struct extent_state *cached_state = NULL;
>>> +       struct extent_state *pinned_extent = NULL;
>>>         struct btrfs_free_cluster *cluster = NULL;
>>>         struct extent_io_tree *unpin = NULL;
>>>         struct io_ctl io_ctl;
>>> @@ -948,17 +949,17 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>>>          * so we don't leak the space
>>>          */
>>>
>>> +       if (!block_group)
>>> +               goto bitmap;
>>>         /*
>>>          * We shouldn't have switched the pinned extents yet so this is the
>>>          * right one
>>>          */
>>>         unpin = root->fs_info->pinned_extents;
>>>
>>> -       if (block_group)
>>> -               start = block_group->key.objectid;
>>> +       start = block_group->key.objectid;
>>>
>>> -       while (block_group && (start < block_group->key.objectid +
>>> -                              block_group->key.offset)) {
>>> +       while (start < block_group->key.objectid + block_group->key.offset) {
>>>                 ret = find_first_extent_bit(unpin, start,
>>>                                             &extent_start, &extent_end,
>>>                                             EXTENT_DIRTY, NULL);
>>> @@ -985,6 +986,33 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
>>>                 start = extent_end;
>>>         }
>>>
>>> +       if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA))
>>> +               goto bitmap;
>>> +
>>> +       start = block_group->key.objectid;
>>> +       unpin = &block_group->pinned_extents;
>>> +       while (1) {
>>> +               ret = find_first_extent_bit(unpin, start,
>>> +                                           &extent_start, &extent_end,
>>> +                                           EXTENT_DIRTY, &pinned_extent);
>>> +               if (ret) {
>>> +                       ret = 0;
>>> +                       break;
>>> +               }
>>> +
>>> +               len = extent_end - extent_start + 1;
>>> +
>>> +               entries++;
>>> +               ret = io_ctl_add_entry(&io_ctl, extent_start, len, NULL);
>>> +               if (ret) {
>>> +                       free_extent_state(pinned_extent);
>>> +                       goto out_nospc;
>>> +               }
>>> +
>>> +               start = extent_end + 1;
>>> +       }
>>> +       free_extent_state(pinned_extent);
>>> +bitmap:
>>>         /* Write out the bitmaps */
>>>         list_for_each_safe(pos, n, &bitmap_list) {
>>>                 struct btrfs_free_space *entry =
>>> @@ -1097,6 +1125,9 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>>>         if (IS_ERR(inode))
>>>                 return 0;
>>>
>>> +       if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
>>> +               down_write(&root->fs_info->data_rwsem);
>>> +
>>>         ret = __btrfs_write_out_cache(root, inode, ctl, block_group, trans,
>>>                                       path, block_group->key.objectid);
>>>         if (ret) {
>>> @@ -1111,6 +1142,9 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>>>  #endif
>>>         }
>>>
>>> +       if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
>>> +               up_write(&root->fs_info->data_rwsem);
>>> +
>>>         iput(inode);
>>>         return ret;
>>>  }
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index f1a7744..8172ca6 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -592,6 +592,28 @@ free_pages_out:
>>>         goto out;
>>>  }
>>>
>>> +static void btrfs_unpin_data_extent(struct btrfs_root *root, u64 start,
>>> +                                   u64 len)
>>> +{
>>> +       struct btrfs_block_group_cache *cache;
>>> +
>>> +       cache = btrfs_lookup_block_group(root->fs_info, start);
>>> +       BUG_ON(!cache);
>>> +       clear_extent_dirty(&cache->pinned_extents, start, start + len - 1,
>>> +                          GFP_NOFS);
>>> +       btrfs_put_block_group(cache);
>>> +}
>>> +
>>> +/* it is not used for free space cache file */
>>> +static void btrfs_free_reserved_data_extent(struct btrfs_root *root, u64 start,
>>> +                                           u64 len)
>>> +{
>>> +       down_read(&root->fs_info->data_rwsem);
>>> +       btrfs_unpin_data_extent(root, start, len);
>>> +       btrfs_free_reserved_extent(root, start, len);
>>> +       up_read(&root->fs_info->data_rwsem);
>>> +}
>>> +
>>>  /*
>>>   * phase two of compressed writeback.  This is the ordered portion
>>>   * of the code, which only gets called in the order the work was
>>> @@ -666,7 +688,7 @@ retry:
>>>                 ret = btrfs_reserve_extent(root,
>>>                                            async_extent->compressed_size,
>>>                                            async_extent->compressed_size,
>>> -                                          0, alloc_hint, &ins, 1);
>>> +                                          0, alloc_hint, &ins, 1, true);
>>>                 if (ret) {
>>>                         int i;
>>>
>>> @@ -767,7 +789,7 @@ retry:
>>>  out:
>>>         return ret;
>>>  out_free_reserve:
>>> -       btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
>>> +       btrfs_free_reserved_data_extent(root, ins.objectid, ins.offset);
>>>  out_free:
>>>         extent_clear_unlock_delalloc(inode, async_extent->start,
>>>                                      async_extent->start +
>>> @@ -889,7 +911,7 @@ static noinline int cow_file_range(struct inode *inode,
>>>                 cur_alloc_size = disk_num_bytes;
>>>                 ret = btrfs_reserve_extent(root, cur_alloc_size,
>>>                                            root->sectorsize, 0, alloc_hint,
>>> -                                          &ins, 1);
>>> +                                          &ins, 1, true);
>>>                 if (ret < 0)
>>>                         goto out_unlock;
>>>
>>> @@ -967,6 +989,7 @@ out:
>>>         return ret;
>>>
>>>  out_reserve:
>>> +       btrfs_unpin_data_extent(root, ins.objectid, ins.offset);
>>>         btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
>>>  out_unlock:
>>>         extent_clear_unlock_delalloc(inode, start, end, locked_page,
>>> @@ -2647,6 +2670,9 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
>>>                                                 logical_len, logical_len,
>>>                                                 compress_type, 0, 0,
>>>                                                 BTRFS_FILE_EXTENT_REG);
>>> +               BUG_ON(nolock);
>>> +               btrfs_unpin_data_extent(root, ordered_extent->start,
>>> +                                       ordered_extent->disk_len);
>>>         }
>>>         unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
>>>                            ordered_extent->file_offset, ordered_extent->len,
>>> @@ -2698,8 +2724,9 @@ out:
>>>                 if ((ret || !logical_len) &&
>>>                     !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
>>>                     !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
>>> -                       btrfs_free_reserved_extent(root, ordered_extent->start,
>>> -                                                  ordered_extent->disk_len);
>>> +                       btrfs_free_reserved_data_extent(root,
>>> +                                                       ordered_extent->start,
>>> +                                                       ordered_extent->disk_len);
>>>         }
>>>
>>>
>>> @@ -6342,7 +6369,7 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
>>>
>>>         alloc_hint = get_extent_allocation_hint(inode, start, len);
>>>         ret = btrfs_reserve_extent(root, len, root->sectorsize, 0,
>>> -                                  alloc_hint, &ins, 1);
>>> +                                  alloc_hint, &ins, 1, true);
>>>         if (ret)
>>>                 return ERR_PTR(ret);
>>>
>>> @@ -6356,6 +6383,7 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
>>>         ret = btrfs_add_ordered_extent_dio(inode, start, ins.objectid,
>>>                                            ins.offset, ins.offset, 0);
>>>         if (ret) {
>>> +               btrfs_unpin_data_extent(root, ins.objectid, ins.offset);
>>>                 btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
>>>                 free_extent_map(em);
>>>                 return ERR_PTR(ret);
>>> @@ -8507,7 +8535,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
>>>                 cur_bytes = min(num_bytes, 256ULL * 1024 * 1024);
>>>                 cur_bytes = max(cur_bytes, min_size);
>>>                 ret = btrfs_reserve_extent(root, cur_bytes, min_size, 0,
>>> -                                          *alloc_hint, &ins, 1);
>>> +                                          *alloc_hint, &ins, 1, false);
>>>                 if (ret) {
>>>                         if (own_trans)
>>>                                 btrfs_end_transaction(trans, root);
>>> --
>>> 1.8.3.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
