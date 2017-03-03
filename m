Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38704 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751137AbdCCApb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 19:45:31 -0500
Subject: Re: [PATCH v5] btrfs: Handle delalloc error correctly to avoid
 ordered extent hang
To: Filipe Manana <fdmanana@kernel.org>
References: <20170228022838.19817-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H59bBARnGcXnBWWL_dVCzBJa6OhpOeRtGgA19TyBPaSxw@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <91ab27c3-5a49-848c-13c2-f7f1f6c306c3@cn.fujitsu.com>
Date: Fri, 3 Mar 2017 08:45:19 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H59bBARnGcXnBWWL_dVCzBJa6OhpOeRtGgA19TyBPaSxw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/03/2017 01:28 AM, Filipe Manana wrote:
> On Tue, Feb 28, 2017 at 2:28 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> [BUG]
>> Reports about btrfs hang running btrfs/124 with default mount option and
>> btrfs/125 with nospace_cache or space_cache=v2 mount options, with
>> following backtrace.
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
>> [CAUSE]
>> The problem is caused by error handler in run_delalloc_nocow() doesn't
>> handle error from btrfs_reloc_clone_csums() well.
>
> The cause is bad error handling in general, not specific to
> btrfs_reloc_clone_csums().
> Keep in mind that you're giving a cause for specific failure scenario
> while providing a solution to a more broader problem.

Right, I'll update the commit message in next update.

>
>>
>> Error handlers in run_dealloc_nocow() and cow_file_range() will clear
>> dirty flags and finish writeback for remaining pages like the following:
>
> They don't finish writeback because writeback isn't even started.
> Writeback is started when a bio is about to be submitted, at
> __extent_writepage_io().
>
>>
>> |<------------------ delalloc range --------------------------->|
>> | Ordered extent 1 | Ordered extent 2          |
>> |    Submitted OK  | recloc_clone_csum() error |
>> |<>|               |<----------- cleanup range ---------------->|
>>  ||
>>  \_=> First page handled by end_extent_writepage() in __extent_writepage()
>>
>> This behavior has two problems:
>> 1) Ordered extent 2 will never finish
>
> Neither will ordered extent 1.

Not always.
If ordered extent 1 is only 1 page large, then it can finish.

So here I introduced ordered extent 2 for this corner case.

>
>>    Ordered extent 2 is already submitted, which relies endio hooks to
>>    wait for all its pages to finish.
>
> submitted -> created
>
> endio hooks don't wait for pages to finish. What you want to say is
> that the ordered extent is marked as complete by the endio hooks.
>
>
>>
>>    However since we finish writeback in error handler, ordered extent 2
>>    will never finish.
>
> finish -> complete
>
> Again, we don't even reach the point of starting writeback. And
> neither ordered extent 2 nor ordered extent 1 complete.
>
>>
>> 2) Metadata underflow
>>    btrfs_finish_ordered_io() for ordered extent will free its reserved
>>    metadata space, while error handlers will also free metadata space of
>>    the remaining range, which covers ordered extent 2.
>>
>>    So even if problem 1) is solved, we can still under flow metadata
>>    reservation, which will leads to deadly btrfs assertion.
>>
>> [FIX]
>> This patch will resolve the problem in two steps:
>> 1) Introduce btrfs_cleanup_ordered_extents() to cleanup ordered extents
>>    Slightly modify one existing function,
>>    btrfs_endio_direct_write_update_ordered() to handle free space inode
>>    just like btrfs_writepage_endio_hook() and skip first page to
>>    co-operate with end_extent_writepage().
>>
>>    So btrfs_cleanup_ordered_extents() will search all submitted ordered
>>    extent in specified range, and clean them up except the first page.
>>
>> 2) Make error handlers skip any range covered by ordered extent
>>    For run_delalloc_nocow() and cow_file_range(), only allow error
>>    handlers to clean up pages/extents not covered by submitted ordered
>>    extent.
>>
>>    For compression, it's calling writepage_end_io_hook() itself to handle
>>    its error, and any submitted ordered extent will have its bio
>>    submitted, so no need to worry about compression part.
>>
>> After the fix, the clean up will happen like:
>>
>> |<--------------------------- delalloc range --------------------------->|
>> | Ordered extent 1 | Ordered extent 2          |
>> |    Submitted OK  | recloc_clone_csum() error |
>> |<>|<- Cleaned up by cleanup_ordered_extents ->|<-- old error handler--->|
>>  ||
>>  \_=> First page handled by end_extent_writepage() in __extent_writepage()
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
>> v5:
>>   Variant gramma and comment fixes suggested by Filipe Manana
>>   Enhanced commit message to focus on the generic error handler bug,
>>   pointed out by Filipe Manana
>>   Adding missing wq/func user in __endio_write_update_ordered(), pointed
>>   out by Filipe Manana.
>>   Enhanced commit message with ascii art to explain the bug more easily.
>>   Fix a bug which can leads to corrupted extent allocation, exposed by
>>   Filipe Manana.
>> ---
>>  fs/btrfs/inode.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 97 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 1e861a063721..410041f3b70a 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -116,6 +116,35 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
>>
>>  static int btrfs_dirty_inode(struct inode *inode);
>>
>> +
>> +static void __endio_write_update_ordered(struct inode *inode,
>> +                                        u64 offset, u64 bytes,
>> +                                        bool uptodate, bool cleanup)
>> +
>> +static inline void btrfs_endio_direct_write_update_ordered(struct inode *inode,
>> +                                                          u64 offset,
>> +                                                          u64 bytes,
>> +                                                          bool uptodate)
>> +{
>> +       return __endio_write_update_ordered(inode, offset, bytes, uptodate, false);
>> +}
>> +
>> +/*
>> + * Cleanup all submitted ordered extents in specified range to handle error
>> + * in cow_file_range() and run_delalloc_nocow().
>> + * Compression handles error and ordered extent submission by itself,
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
>> @@ -950,6 +979,7 @@ static noinline int cow_file_range(struct inode *inode,
>>         u64 disk_num_bytes;
>>         u64 cur_alloc_size;
>>         u64 blocksize = fs_info->sectorsize;
>> +       u64 orig_start = start;
>>         struct btrfs_key ins;
>>         struct extent_map *em;
>>         struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>> @@ -1052,15 +1082,24 @@ static noinline int cow_file_range(struct inode *inode,
>>                     BTRFS_DATA_RELOC_TREE_OBJECTID) {
>>                         ret = btrfs_reloc_clone_csums(inode, start,
>>                                                       cur_alloc_size);
>> +                       /*
>> +                        * Only drop cache here, and process as normal.
>> +                        *
>> +                        * We must not allow extent_clear_unlock_delalloc()
>> +                        * at out_unlock label to free meta of this ordered
>> +                        * extent, as its meta should be freed by
>> +                        * btrfs_finish_ordered_io().
>> +                        *
>> +                        * So we must continue until @start is increased to
>> +                        * skip current ordered extent.
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
>>                 /* we're not doing compressed IO, don't unlock the first
>>                  * page (which the caller expects to stay locked), don't
>>                  * clear any dirty bits and don't set any writeback bits
>> @@ -1076,10 +1115,21 @@ static noinline int cow_file_range(struct inode *inode,
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
>> +                * btrfs_reloc_clone_csums() error, since start is increased
>> +                * extent_clear_unlock_delalloc() at out_unlock label won't
>> +                * free metadata of current ordered extent, we're OK to exit.
>> +                */
>> +               if (ret)
>> +                       goto out_unlock;
>>         }
>>  out:
>>         return ret;
>> @@ -1096,6 +1146,7 @@ static noinline int cow_file_range(struct inode *inode,
>>                                      EXTENT_DELALLOC | EXTENT_DEFRAG,
>>                                      PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
>>                                      PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
>> +       btrfs_cleanup_ordered_extents(inode, orig_start, end - orig_start + 1);
>>         goto out;
>>  }
>>
>> @@ -1496,15 +1547,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
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
>> @@ -1516,6 +1566,14 @@ static noinline int run_delalloc_nocow(struct inode *inode,
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
>> @@ -1546,6 +1604,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>                                              PAGE_CLEAR_DIRTY |
>>                                              PAGE_SET_WRITEBACK |
>>                                              PAGE_END_WRITEBACK);
>> +       if (ret)
>> +               btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
>
>
> run_delalloc_nocow() can call cow_file_range() which also calls
> btrfs_cleanup_ordered_extents() when an error happens, and if it gets
> called twice you get an assertion failure and trace like this:

Any idea how did you encounter such bug?
By adding special error return? Or fstests cases? (Btrfs/124 can't even 
reproduce the hang in my VM without the patch)
>
> [ 1114.449798] BTRFS critical (device sdc): bad ordered accounting
> left 4096 size 8384512
> [ 1191.272363] systemd-journald[583]: Sent WATCHDOG=1 notification.
> [ 1259.781262] clocksource: timekeeping watchdog on CPU0: Marking
> clocksource 'tsc' as unstable because the skew is too large:
> [ 1259.783917] clocksource:                       'hpet' wd_now:
> 6102107a wd_last: 3526a762 mask: ffffffff
> [ 1259.799434] clocksource:                       'tsc' cs_now:
> 3ee67b46de2 cs_last: 3e9b619e26e mask: ffffffffffffffff
> [ 1259.932608] clocksource: Switched to clocksource hpet
> [ 1311.270968] systemd-journald[583]: Sent WATCHDOG=1 notification.
> [ 1332.188193] INFO: task kworker/u32:6:494 blocked for more than 120 seconds.
> [ 1332.189092]       Not tainted 4.10.0-rc8-btrfs-next-37+ #1
> [ 1332.189648] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 1332.190484] kworker/u32:6   D    0   494      2 0x00000000
> [ 1332.191072] Workqueue: writeback wb_workfn (flush-btrfs-1)
> [ 1332.191633] Call Trace:
> [ 1332.191940]  __schedule+0x4a8/0x70d
> [ 1332.209169]  schedule+0x8c/0xa0
> [ 1332.210022]  schedule_timeout+0x43/0xff
> [ 1332.210900]  ? trace_hardirqs_on_caller+0x17b/0x197
> [ 1332.211912]  ? trace_hardirqs_on+0xd/0xf
> [ 1332.212651]  ? timekeeping_get_ns+0x1e/0x32
> [ 1332.213780]  ? ktime_get+0x41/0x52
> [ 1332.214476]  io_schedule_timeout+0xa0/0x102
> [ 1332.215149]  ? io_schedule_timeout+0xa0/0x102
> [ 1332.215853]  wait_on_page_bit_common+0xe2/0x14b
> [ 1332.216845]  ? unlock_page+0x25/0x25
> [ 1332.217840]  __lock_page+0x40/0x42
> [ 1332.218664]  lock_page+0x2f/0x32 [btrfs]
> [ 1332.219763]  extent_write_cache_pages.constprop.33+0x209/0x36c [btrfs]
> [ 1332.226378]  extent_writepages+0x4b/0x5c [btrfs]
> [ 1332.226378]  extent_writepages+0x4b/0x5c [btrfs]
> [ 1332.227648]  ? btrfs_submit_direct+0x46d/0x46d [btrfs]
> [ 1332.235042]  btrfs_writepages+0x28/0x2a [btrfs]
> [ 1332.236286]  do_writepages+0x23/0x2c
> [ 1332.237272]  __writeback_single_inode+0x105/0x6d2
> [ 1332.238524]  writeback_sb_inodes+0x292/0x4a1
> [ 1332.239669]  __writeback_inodes_wb+0x76/0xae
> [ 1332.240803]  wb_writeback+0x1cc/0x4ca
> [ 1332.241813]  wb_workfn+0x22e/0x37d
> [ 1332.242729]  ? wb_workfn+0x22e/0x37d
> [ 1332.243731]  process_one_work+0x273/0x4e4
> [ 1332.244793]  worker_thread+0x1eb/0x2ca
> [ 1332.245801]  ? rescuer_thread+0x2b6/0x2b6
> [ 1332.246877]  kthread+0x100/0x108
> [ 1332.247771]  ? __list_del_entry+0x22/0x22
> [ 1332.248873]  ret_from_fork+0x2e/0x40
>
> So I suggest calling btrfs_cleanup_ordered_extents() directly from
> run_delalloc_range() whenever an error happens, which is safe for the
> compression case too (it simply does nothing, but keeps the code
> smaller and simpler).

Thanks for this, modifying the error label is always a plain.
Moving to run_delalloc_range() is much better and less bug-prone.

>
> The following path on top of yours does this, was tested and has a few
> other changes, like making a comment more clear (fixed grammar and
> make it more clear), and adjusting the offset and number of bytes in
> the cleanup function itself.
>
> Feel free to incorporate verbatim where appropriate. Also at
> https://friendpaste.com/4zct2A5XQoSVJyMFBU2UkA in case gmail screws up
> the patch.

Great thank for the patch.

Did you mind to add your signed-off-by tag in next update?

Thanks,
Qu
>
> Thanks
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index fc6401a..6016500 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -120,30 +120,26 @@ static int btrfs_dirty_inode(struct inode *inode);
>
>  static void __endio_write_update_ordered(struct inode *inode,
>   u64 offset, u64 bytes,
> - bool uptodate, bool cleanup);
> -
> -static inline void btrfs_endio_direct_write_update_ordered(struct inode *inode,
> -   u64 offset,
> -   u64 bytes,
> -   bool uptodate)
> -{
> - return __endio_write_update_ordered(inode, offset, bytes, uptodate, false);
> -}
> + bool uptodate);
>
>  /*
> - * Cleanup all submitted ordered extents in specified range to handle error
> - * in cow_file_range() and run_delalloc_nocow().
> - * Compression handles error and ordered extent submission by itself,
> - * so no need to call this function.
> + * Cleanup all submitted ordered extents in specified range to handle errors
> + * from the fill_dellaloc() callback.
>   *
> - * NOTE: caller must ensure extent_clear_unlock_delalloc() in error handler
> - * doesn't cover any range of submitted ordered extent.
> - * Or we will double free metadata for submitted ordered extent.
> + * NOTE: caller must ensure that when an error happens, it can not call
> + * extent_clear_unlock_delalloc() to clear both the bits EXTENT_DO_ACCOUNTING
> + * and EXTENT_DELALLOC simultaneously, because that causes the
> reserved metadata
> + * to be released, which we want to happen only when finishing the ordered
> + * extent (btrfs_finish_ordered_io()). Also note that the caller of the
> + * fill_dealloc() callback already does proper cleanup for the first page of
> + * the range, that is, it invokes the callback writepage_end_io_hook() for the
> + * range of the first page.
>   */
>  static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
>   u64 offset, u64 bytes)
>  {
> - return __endio_write_update_ordered(inode, offset, bytes, false, true);
> + return __endio_write_update_ordered(inode, offset + PAGE_SIZE,
> +    bytes - PAGE_SIZE, false);
>  }
>
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> @@ -958,7 +954,6 @@ static noinline int cow_file_range(struct inode *inode,
>   u64 disk_num_bytes;
>   u64 cur_alloc_size;
>   u64 blocksize = fs_info->sectorsize;
> - u64 orig_start = start;
>   struct btrfs_key ins;
>   struct extent_map *em;
>   int ret = 0;
> @@ -1100,7 +1095,6 @@ static noinline int cow_file_range(struct inode *inode,
>       EXTENT_DELALLOC | EXTENT_DEFRAG,
>       PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
>       PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
> - btrfs_cleanup_ordered_extents(inode, orig_start, end - orig_start + 1);
>   goto out;
>  }
>
> @@ -1526,8 +1520,6 @@ static noinline int run_delalloc_nocow(struct
> inode *inode,
>       PAGE_CLEAR_DIRTY |
>       PAGE_SET_WRITEBACK |
>       PAGE_END_WRITEBACK);
> - if (ret)
> - btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
>   btrfs_free_path(path);
>   return ret;
>  }
> @@ -1577,6 +1569,8 @@ static int run_delalloc_range(struct inode
> *inode, struct page *locked_page,
>   ret = cow_file_range_async(inode, locked_page, start, end,
>     page_started, nr_written);
>   }
> + if (ret)
> + btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
>   return ret;
>  }
>
> @@ -8176,7 +8170,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
>
>  static void __endio_write_update_ordered(struct inode *inode,
>   u64 offset, u64 bytes,
> - bool uptodate, bool cleanup)
> + bool uptodate)
>  {
>   struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>   struct btrfs_ordered_extent *ordered = NULL;
> @@ -8194,16 +8188,6 @@ static void __endio_write_update_ordered(struct
> inode *inode,
>   func = btrfs_endio_write_helper;
>   }
>
> - /*
> - * In cleanup case, the first page of the range will be handled
> - * by end_extent_writepage() when called from __extent_writepage()
> - *
> - * So we must skip first page, or we will underflow ordered->bytes_left
> - */
> - if (cleanup) {
> - ordered_offset += PAGE_SIZE;
> - ordered_bytes -= PAGE_SIZE;
> - }
>  again:
>   ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
>     &ordered_offset,
> @@ -8231,10 +8215,10 @@ static void btrfs_endio_direct_write(struct bio *bio)
>   struct btrfs_dio_private *dip = bio->bi_private;
>   struct bio *dio_bio = dip->dio_bio;
>
> - btrfs_endio_direct_write_update_ordered(dip->inode,
> - dip->logical_offset,
> - dip->bytes,
> - !bio->bi_error);
> + __endio_write_update_ordered(dip->inode,
> +     dip->logical_offset,
> +     dip->bytes,
> +     !bio->bi_error);
>
>   kfree(dip);
>
> @@ -8595,10 +8579,10 @@ static void btrfs_submit_direct(struct bio
> *dio_bio, struct inode *inode,
>   io_bio = NULL;
>   } else {
>   if (write)
> - btrfs_endio_direct_write_update_ordered(inode,
> + __endio_write_update_ordered(inode,
>   file_offset,
>   dio_bio->bi_iter.bi_size,
> - 0);
> + false);
>   else
>   unlock_extent(&BTRFS_I(inode)->io_tree, file_offset,
>        file_offset + dio_bio->bi_iter.bi_size - 1);
> @@ -8733,11 +8717,11 @@ static ssize_t btrfs_direct_IO(struct kiocb
> *iocb, struct iov_iter *iter)
>   */
>   if (dio_data.unsubmitted_oe_range_start <
>      dio_data.unsubmitted_oe_range_end)
> - btrfs_endio_direct_write_update_ordered(inode,
> + __endio_write_update_ordered(inode,
>   dio_data.unsubmitted_oe_range_start,
>   dio_data.unsubmitted_oe_range_end -
>   dio_data.unsubmitted_oe_range_start,
> - 0);
> + false);
>   } else if (ret >= 0 && (size_t)ret < count)
>   btrfs_delalloc_release_space(inode, offset,
>       count - (size_t)ret);
>
>
>>         btrfs_free_path(path);
>>         return ret;
>>  }
>> @@ -8185,17 +8245,36 @@ static void btrfs_endio_direct_read(struct bio *bio)
>>         bio_put(bio);
>>  }
>>
>> -static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
>> -                                                   const u64 offset,
>> -                                                   const u64 bytes,
>> -                                                   const int uptodate)
>> +static void __endio_write_update_ordered(struct inode *inode,
>> +                                        u64 offset, u64 bytes,
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
>> +
>> +       /*
>> +        * In cleanup case, the first page of the range will be handled
>> +        * by end_extent_writepage() when called from __extent_writepage()
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
>> @@ -8204,9 +8283,8 @@ static void btrfs_endio_direct_write_update_ordered(struct inode *inode,
>>         if (!ret)
>>                 goto out_test;
>>
>> -       btrfs_init_work(&ordered->work, btrfs_endio_write_helper,
>> -                       finish_ordered_fn, NULL, NULL);
>> -       btrfs_queue_work(fs_info->endio_write_workers, &ordered->work);
>> +       btrfs_init_work(&ordered->work, func, finish_ordered_fn, NULL, NULL);
>> +       btrfs_queue_work(wq, &ordered->work);
>>  out_test:
>>         /*
>>          * our bio might span multiple ordered extents.  If we haven't
>> --
>> 2.11.1
>>
>>
>>
>
>


