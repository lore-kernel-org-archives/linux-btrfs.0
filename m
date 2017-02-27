Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751461AbdB0SLQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 13:11:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 68206202F2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 18:09:37 +0000 (UTC)
Received: from mail-it0-f51.google.com (mail-it0-f51.google.com [209.85.214.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 142E8202EB
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 18:09:34 +0000 (UTC)
Received: by mail-it0-f51.google.com with SMTP id h10so63251955ith.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 10:09:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6mannv6_v28440G70KRTUHOQQU6QKsRirSOFQiqKNe0g@mail.gmail.com>
References: <20170224020646.12668-1-quwenruo@cn.fujitsu.com> <CAL3q7H6mannv6_v28440G70KRTUHOQQU6QKsRirSOFQiqKNe0g@mail.gmail.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 27 Feb 2017 18:09:32 +0000
Message-ID: <CAL3q7H7ZNHSM3-F4q=UkKdA3dFGbWfF0DwQHHKoBXAEr_Fa3=g@mail.gmail.com>
Subject: Re: [PATCH v4] btrfs: Handle delalloc error correctly to avoid
 ordered extent deadlock
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 27, 2017 at 4:14 PM, Filipe Manana <fdmanana@kernel.org> wrote:

Also, forgot to mention before, looking at the subject, the term
deadlock is not correct, as it's a hang.
A deadlock is when a task is trying to acquire a resource (typically a
lock) that is already held by some other task that in turn it's trying
to acquire the same resource as the former task.

> On Fri, Feb 24, 2017 at 2:06 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> If run btrfs/125 with nospace_cache or space_cache=v2 mount option,
>> btrfs will block with the following backtrace:
>
> Happens with btrfs/124 without any mount options too.
>
>>
>> Call Trace:
>>  __schedule+0x2d4/0xae0
>>  schedule+0x3d/0x90
>>  btrfs_start_ordered_extent+0x160/0x200 [btrfs]
>>  ? wake_atomic_t_function+0x60/0x60
>>  btrfs_run_ordered_extent_work+0x25/0x40 [btrfs]
>>  btrfs_scrubparity_helper+0x1c1/0x620 [btrfs]
>>  btrfs_flush_delalloc_helper+0xe/0x10 [btrfs]
>>  process_one_work+0x2af/0x720
>>  ? process_one_work+0x22b/0x720
>>  worker_thread+0x4b/0x4f0
>>  kthread+0x10f/0x150
>>  ? process_one_work+0x720/0x720
>>  ? kthread_create_on_node+0x40/0x40
>>  ret_from_fork+0x2e/0x40
>>
>> The direct cause is the error handler in run_delalloc_nocow() doesn't
>> handle error from btrfs_reloc_clone_csums() well.
>>
>> The error handler of run_delalloc_nocow() will clear dirty and finish IO
>> for the pages in that extent.
>> However we have already inserted one ordered extent.
>> And that ordered extent is relying on endio hooks to wait all its pages
>> to finish, while only the first page will finish.
>>
>> This makes that ordered extent never finish, so blocking the file
>> system.
>>
>> Although the root cause is still in RAID5/6, it won't hurt to fix the
>> error routine first.
>
> This is a higher level problem independent of the raid level being
> used. So this changelog gives the wrong idea that this happens only
> with raid5/6.
>
>>
>> This patch will slightly modify one existing function,
>> btrfs_endio_direct_write_update_ordered() to handle free space inode,
>> and skip releasing metadata, which will be handled by
>> extent_clear_unlock_delalloc().
>>
>> And use it as base to implement one inline function,
>> btrfs_cleanup_ordered_extents() to handle the error in
>> run_delalloc_nocow() and cow_file_range().
>>
>> Also, extent_clear_unlock_delalloc() will handle all the metadata
>> release, so btrfs_cleanup_ordered_extents() doesn't need to do it.
>>
>> For compression, it's calling writepage_end_io_hook() itself to handle
>> its error, and any submitted ordered extent will have its bio submitted,
>> so no need to worry about compression part.
>>
>> Suggested-by: Filipe Manana <fdmanana@suse.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2:
>>   Add BTRFS_ORDERED_SKIP_METADATA flag to avoid double reducing
>>   outstanding extents, which is already done by
>>   extent_clear_unlock_delalloc() with EXTENT_DO_ACCOUNT control bit
>> v3:
>>   Skip first page to avoid underflow ordered->bytes_left.
>>   Fix range passed in cow_file_range() which doesn't cover the whole
>>   extent.
>>   Expend extent_clear_unlock_delalloc() range to allow them to handle
>>   metadata release.
>> v4:
>>   Don't use extra bit to skip metadata freeing for ordered extent,
>>   but only handle btrfs_reloc_clone_csums() error just before processing
>>   next extent.
>>   This makes error handle much easier for run_delalloc_nocow().
>> ---
>>  fs/btrfs/extent_io.c |   1 -
>>  fs/btrfs/inode.c     | 112 +++++++++++++++++++++++++++++++++++++++++++--------
>>  2 files changed, 96 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 4ac383a3a649..a14d1b0840c5 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -3258,7 +3258,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>>                                                delalloc_end,
>>                                                &page_started,
>>                                                nr_written);
>> -               /* File system has been set read-only */
>
> This is unrelated to the problem you're solving. Should be an
> independent and unrelated patch.
>
>>                 if (ret) {
>>                         SetPageError(page);
>>                         /* fill_delalloc should be return < 0 for error
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 1e861a063721..b98a92807aa2 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -116,6 +116,34 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
>>
>>  static int btrfs_dirty_inode(struct inode *inode);
>>
>> +
>> +static void __endio_write_update_ordered(struct inode *inode,
>> +                                        const u64 offset, const u64 bytes,
>> +                                        bool uptodate, bool cleanup);
>
> Offset and bytes are const, why not the booleans as well? It's
> inconsistent and confusing.
> Also leaving a blank line before the declaration of next function
> would make the code easier to the eyes.
>
>> +static inline void btrfs_endio_direct_write_update_ordered(struct inode *inode,
>> +                                                          const u64 offset,
>> +                                                          const u64 bytes,
>> +                                                          const int uptodate)
>
> Now uptodate is an int and not bool as in the previous call that it
> ends up calling. At least within the same patch we should be
> consistent.
>
>> +{
>> +       return __endio_write_update_ordered(inode, offset, bytes, uptodate, false);
>> +}
>> +
>> +/*
>> + * Cleanup all submitted ordered extent in specified range to handle error
>
> extent -> extents
>
>> + * in cow_file_range() and run_delalloc_nocow().
>> + * Compression handles error and ordered extent submission all by themselves,
>
> all by themselves -> by itself
>
>> + * so no need to call this function.
>> + *
>> + * NOTE: caller must ensure extent_clear_unlock_delalloc() in error handler
>> + * doesn't cover any range of submitted ordered extent.
>> + * Or we will double free metadata for submitted ordered extent.
>> + */
>> +static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
>> +                                                u64 offset, u64 bytes)
>> +{
>> +       return __endio_write_update_ordered(inode, offset, bytes, false, true);
>> +}
>> +
>>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>>  void btrfs_test_inode_set_ops(struct inode *inode)
>>  {
>> @@ -950,6 +978,7 @@ static noinline int cow_file_range(struct inode *inode,
>>         u64 disk_num_bytes;
>>         u64 cur_alloc_size;
>>         u64 blocksize = fs_info->sectorsize;
>> +       u64 orig_start = start;
>>         struct btrfs_key ins;
>>         struct extent_map *em;
>>         struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>> @@ -1052,15 +1081,22 @@ static noinline int cow_file_range(struct inode *inode,
>>                     BTRFS_DATA_RELOC_TREE_OBJECTID) {
>>                         ret = btrfs_reloc_clone_csums(inode, start,
>>                                                       cur_alloc_size);
>> +                       /*
>> +                        * Only drop cache here, and process as normal.
>> +                        *
>> +                        * We must not allow extent_clear_unlock_delalloc()
>> +                        * to free meta of this ordered extent, as its
>> +                        * meta should be freed by btrfs_finish_ordered_io().
>> +                        *
>> +                        * So we must continue until processing next extent
>> +                        */
>>                         if (ret)
>> -                               goto out_drop_extent_cache;
>> +                               btrfs_drop_extent_cache(inode, start,
>> +                                               start + ram_size - 1, 0);
>>                 }
>>
>>                 btrfs_dec_block_group_reservations(fs_info, ins.objectid);
>>
>> -               if (disk_num_bytes < cur_alloc_size)
>> -                       break;
>> -
>
> If I understanding correctly you're removing this just to make sure we
> call extent_clear_unlock_delalloc() below.
> However later on, we should still break if this condition is true,
> otherwise this code is not equivalent to what we had before.
>
>>                 /* we're not doing compressed IO, don't unlock the first
>>                  * page (which the caller expects to stay locked), don't
>>                  * clear any dirty bits and don't set any writeback bits
>> @@ -1076,10 +1112,21 @@ static noinline int cow_file_range(struct inode *inode,
>>                                              delalloc_end, locked_page,
>>                                              EXTENT_LOCKED | EXTENT_DELALLOC,
>>                                              op);
>> -               disk_num_bytes -= cur_alloc_size;
>> +               if (disk_num_bytes < cur_alloc_size)
>> +                       disk_num_bytes = 0;
>> +               else
>> +                       disk_num_bytes -= cur_alloc_size;
>>                 num_bytes -= cur_alloc_size;
>>                 alloc_hint = ins.objectid + ins.offset;
>>                 start += cur_alloc_size;
>> +
>> +               /*
>> +                * btrfs_reloc_clone_csums() error, now
>> +                * extent_clear_unlock_delalloc() in out_unlock() won't
>> +                * double free metadata of current oredered extent.
>
> in out_unlock() -> at out_lock label
> (it's not a function, should not have the parenthesis following the name)
>
> oredered -> ordered
>
>> +                */
>> +               if (ret)
>> +                       goto out_reserve;
>
> Jumping to this label will make us decrement block group reservations
> twice - i.e. btrfs_dec_block_group_reservations() is now called twice
> instead of once, allowing for an underflow to happen.
>
> And btrfs_free_reserved_extent() will be called twice for the reserved
> extent, once at the "out_reserve" label and once when the ordered
> extent finishes (with the error bit set), at
> btrfs_finish_ordered_io(). This is particularly dangerous, as we are
> in a transaction-less context, so that means once the first free call
> happens, the same space can be allocated elsewhere by another task and
> then when the ordered extent finishes we incorrectly free that space
> again.
>
>>         }
>>  out:
>>         return ret;
>> @@ -1096,6 +1143,7 @@ static noinline int cow_file_range(struct inode *inode,
>>                                      EXTENT_DELALLOC | EXTENT_DEFRAG,
>>                                      PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
>>                                      PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
>> +       btrfs_cleanup_ordered_extents(inode, orig_start, end - orig_start + 1);
>>         goto out;
>>  }
>>
>> @@ -1496,15 +1544,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>                 BUG_ON(ret); /* -ENOMEM */
>>
>>                 if (root->root_key.objectid ==
>> -                   BTRFS_DATA_RELOC_TREE_OBJECTID) {
>> +                   BTRFS_DATA_RELOC_TREE_OBJECTID)
>> +                       /*
>> +                        * Error handled later, as we must prevent
>> +                        * extent_clear_unlock_delalloc() in error handler
>> +                        * from freeing metadata of submitted ordered extent.
>> +                        */
>>                         ret = btrfs_reloc_clone_csums(inode, cur_offset,
>>                                                       num_bytes);
>> -                       if (ret) {
>> -                               if (!nolock && nocow)
>> -                                       btrfs_end_write_no_snapshoting(root);
>> -                               goto error;
>> -                       }
>> -               }
>>
>>                 extent_clear_unlock_delalloc(inode, cur_offset,
>>                                              cur_offset + num_bytes - 1, end,
>> @@ -1516,6 +1563,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>                 if (!nolock && nocow)
>>                         btrfs_end_write_no_snapshoting(root);
>>                 cur_offset = extent_end;
>> +
>> +               /*
>> +                * btrfs_reloc_clone_csums() error, now we're OK to call error
>> +                * handler, as metadata for submitted ordered extent will only
>> +                * be freed by btrfs_finish_ordered_io().
>> +                */
>> +               if (ret)
>> +                       goto error;
>>                 if (cur_offset > end)
>>                         break;
>>         }
>> @@ -1546,6 +1601,12 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>                                              PAGE_CLEAR_DIRTY |
>>                                              PAGE_SET_WRITEBACK |
>>                                              PAGE_END_WRITEBACK);
>> +       /*
>> +        * It's possible that last ordered extent covered the last part
>> +        * but failed. In that case we still need to clean them up.
>> +        */
>
> Confusing comment. You mention ordered extent (singular) but then
> later mention "clean them up" (plural). Also saying that an ordered
> extent failed gives the idea that the IO failed (i.e. bio finished
> with an error), while what you want to say is that we created one or
> more ordered extents but failed somewhere before submitting bios for
> them. I would just remove the comment, or the very least make it
> understandable.
>
>> +       if (ret)
>> +               btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
>>         btrfs_free_path(path);
>>         return ret;
>>  }
>> @@ -8185,17 +8246,36 @@ static void btrfs_endio_direct_read(struct bio *bio)
>>         bio_put(bio);
>>  }
>>
>> -static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
>> -                                                   const u64 offset,
>> -                                                   const u64 bytes,
>> -                                                   const int uptodate)
>> +static void __endio_write_update_ordered(struct inode *inode,
>> +                                        const u64 offset, const u64 bytes,
>> +                                        bool uptodate, bool cleanup)
>>  {
>>         struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>         struct btrfs_ordered_extent *ordered = NULL;
>> +       struct btrfs_workqueue *wq;
>> +       btrfs_work_func_t func;
>>         u64 ordered_offset = offset;
>>         u64 ordered_bytes = bytes;
>>         int ret;
>>
>> +       if (btrfs_is_free_space_inode(inode)) {
>> +               wq = fs_info->endio_freespace_worker;
>> +               func = btrfs_freespace_write_helper;
>> +       } else {
>> +               wq = fs_info->endio_write_workers;
>> +               func = btrfs_endio_write_helper;
>> +       }
>
> What is going on here? wq and func are set but not used anywhere.
>
>> +
>> +       /*
>> +        * In cleanup case, the first page of the range will be handled
>> +        * by end_extent_writepage() under done tag of __extent_writepage().
>
> This sentence is confusing, "under done tag"?
> Just say:
>
> In cleanup case, the first page of the range will be handled by
> end_extent_writepage() when called from __extent_writepage().
>
> thanks
>
>> +        *
>> +        * So we must skip first page, or we will underflow ordered->bytes_left
>> +        */
>> +       if (cleanup) {
>> +               ordered_offset += PAGE_SIZE;
>> +               ordered_bytes -= PAGE_SIZE;
>> +       }
>>  again:
>>         ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
>>                                                    &ordered_offset,
>> --
>> 2.11.1
>>
>>
>>
