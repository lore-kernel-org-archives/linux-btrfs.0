Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33800 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934066AbdBQPZa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 10:25:30 -0500
Received: by mail-it0-f66.google.com with SMTP id r141so3356544ita.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 07:25:29 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <6fa6ed2a-8d0c-682c-dda8-eefe20519264@cn.fujitsu.com>
References: <20170215084924.10587-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H4gTkwjRSNtexur6BMiKiU55CpeDnp45yScOn89dsw6_Q@mail.gmail.com>
 <74726a82-01ec-4501-acb3-133083904f7d@cn.fujitsu.com> <CAL3q7H65Zfj3cx3kYJBH3x_O+mJeAbvMrPLp3fZPhPsiz77gyg@mail.gmail.com>
 <6fa6ed2a-8d0c-682c-dda8-eefe20519264@cn.fujitsu.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 17 Feb 2017 15:25:28 +0000
Message-ID: <CAL3q7H444G-6V9wcG3E3dXY9Jw8WoSUyaQV7kGw_h0-7hQHh4g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Handle btrfs_reloc_clone_csums error correctly to
 avoid deadlock
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 17, 2017 at 12:37 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 02/16/2017 06:03 PM, Filipe Manana wrote:
>>
>> On Thu, Feb 16, 2017 at 12:39 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>>
>>>
>>> At 02/15/2017 11:59 PM, Filipe Manana wrote:
>>>>
>>>>
>>>> On Wed, Feb 15, 2017 at 8:49 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> wrote:
>>>>>
>>>>>
>>>>> If run btrfs/125 with nospace_cache or space_cache=v2 mount option,
>>>>> btrfs will block with the following backtrace:
>>>>>
>>>>> Call Trace:
>>>>>  __schedule+0x2d4/0xae0
>>>>>  schedule+0x3d/0x90
>>>>>  btrfs_start_ordered_extent+0x160/0x200 [btrfs]
>>>>>  ? wake_atomic_t_function+0x60/0x60
>>>>>  btrfs_run_ordered_extent_work+0x25/0x40 [btrfs]
>>>>>  btrfs_scrubparity_helper+0x1c1/0x620 [btrfs]
>>>>>  btrfs_flush_delalloc_helper+0xe/0x10 [btrfs]
>>>>>  process_one_work+0x2af/0x720
>>>>>  ? process_one_work+0x22b/0x720
>>>>>  worker_thread+0x4b/0x4f0
>>>>>  kthread+0x10f/0x150
>>>>>  ? process_one_work+0x720/0x720
>>>>>  ? kthread_create_on_node+0x40/0x40
>>>>>  ret_from_fork+0x2e/0x40
>>>>>
>>>>> The direct cause is the error handler in run_delalloc_nocow() doesn't
>>>>> handle error from btrfs_reloc_clone_csums() well.
>>>>>
>>>>> The related part call path will be:
>>>>> __extent_writepage
>>>>> |- writepage_delalloc()
>>>>> |  |- run_delalloc_range()
>>>>> |     |- run_delalloc_nocow()
>>>>> |        |- btrfs_add_ordered_extent()
>>>>> |        |  Now one ordered extent for file range, e.g [0, 1M) is
>>>>> inserted
>>>>> |        |
>>>>> |        |- btrfs_reloc_clone_csums()
>>>>> |        |  Fails with -EIO, as RAID5/6 doesn't repair some csum tree
>>>>> |        |  blocks
>>>>> |        |
>>>>> |        |- extent_clear_unlock_delalloc()
>>>>> |           Error routine, unlock and clear page DIRTY, end page
>>>>> writeback
>>>>> |           So the remaining 255 pages will not go through writeback
>>>>> |
>>>>> |- __extent_writepage_io()
>>>>>    |- writepage_end_io_hook()
>>>>>       |- btrfs_dev_test_ordered_pending()
>>>>>          Reduce ordered_extent->bytes_left by 4K.
>>>>>          Still have (1M - 4K) to finish.
>>>>>
>>>>> While the remaining 255 pages will not go through IO nor trigger
>>>>> writepage_end_io_hook(), the ordered extent for [0, 1M) will
>>>>> never finish, and blocking current transaction forever.
>>>>>
>>>>> Although the root cause is still in RAID5/6, it won't hurt to fix the
>>>>> error routine first.
>>>>>
>>>>> This patch will cleanup the ordered extent in error routine, so at
>>>>> least
>>>>> we won't cause deadlock.
>>>>>
>>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>> ---
>>>>>  fs/btrfs/extent_io.c    |  1 -
>>>>>  fs/btrfs/inode.c        | 10 ++++++++--
>>>>>  fs/btrfs/ordered-data.c | 25 +++++++++++++++++++++++++
>>>>>  fs/btrfs/ordered-data.h | 10 ++++++++++
>>>>>  4 files changed, 43 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>>>> index 4ac383a3a649..a14d1b0840c5 100644
>>>>> --- a/fs/btrfs/extent_io.c
>>>>> +++ b/fs/btrfs/extent_io.c
>>>>> @@ -3258,7 +3258,6 @@ static noinline_for_stack int
>>>>> writepage_delalloc(struct inode *inode,
>>>>>                                                delalloc_end,
>>>>>                                                &page_started,
>>>>>                                                nr_written);
>>>>> -               /* File system has been set read-only */
>>>>>                 if (ret) {
>>>>>                         SetPageError(page);
>>>>>                         /* fill_delalloc should be return < 0 for error
>>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>>> index 1e861a063721..3c3ade58afd7 100644
>>>>> --- a/fs/btrfs/inode.c
>>>>> +++ b/fs/btrfs/inode.c
>>>>> @@ -1052,8 +1052,11 @@ static noinline int cow_file_range(struct inode
>>>>> *inode,
>>>>>                     BTRFS_DATA_RELOC_TREE_OBJECTID) {
>>>>>                         ret = btrfs_reloc_clone_csums(inode, start,
>>>>>                                                       cur_alloc_size);
>>>>> -                       if (ret)
>>>>> +                       if (ret) {
>>>>> +                               btrfs_clean_ordered_extent(inode,
>>>>> start,
>>>>> +                                                          ram_size);
>>>>>                                 goto out_drop_extent_cache;
>>>>> +                       }
>>>>>                 }
>>>>>
>>>>>                 btrfs_dec_block_group_reservations(fs_info,
>>>>> ins.objectid);
>>>>> @@ -1538,7 +1541,7 @@ static noinline int run_delalloc_nocow(struct
>>>>> inode
>>>>> *inode,
>>>>>         if (!ret)
>>>>>                 ret = err;
>>>>>
>>>>> -       if (ret && cur_offset < end)
>>>>> +       if (ret && cur_offset < end) {
>>>>>                 extent_clear_unlock_delalloc(inode, cur_offset, end,
>>>>> end,
>>>>>                                              locked_page, EXTENT_LOCKED
>>>>> |
>>>>>                                              EXTENT_DELALLOC |
>>>>> EXTENT_DEFRAG |
>>>>> @@ -1546,6 +1549,9 @@ static noinline int run_delalloc_nocow(struct
>>>>> inode
>>>>> *inode,
>>>>>                                              PAGE_CLEAR_DIRTY |
>>>>>                                              PAGE_SET_WRITEBACK |
>>>>>                                              PAGE_END_WRITEBACK);
>>>>> +               btrfs_clean_ordered_extent(inode, cur_offset,
>>>>> +                                          end - cur_offset + 1);
>>>>
>>>>
>>>>
>>>> So this is partially correct only.
>>>> First here you can have 0, 1 or more ordered extents that were created
>>>> in the while loop. So your new function must find and process all
>>>> ordered extents within the delalloc range and not just the last one
>>>> that was created.
>>>
>>>
>>>
>>> OK, I found that only btrfs_reloc_clone_csums() will need to cleanup
>>> ordered
>>> extent, and there is no other case which can cause error after adding
>>> ordered extent.
>>>
>>> So what about moving the btrfs_clean_ordered_extent() call to just after
>>> btrfs_reloc_clone_csums() instead of putting it under error tag?
>>
>>
>> Unfortunately it's not as simple as that, because when it fails, past
>> iterations of the while loop have created other ordered extents.
>> Same goes for cow_file_range().
>>
>> So we really need something like what is done for the error path of
>> dio writes, which gets rid of all ordered extents and sets the IO
>> error bit on them as well.
>
>
> The IO error bit makes sense.
>
> While I'm still not sure the necessity to cleanup previously created ordered
> extent, since they could finish using endio functions.

In case of an error the endio handler is called only for the first
page, and not for whole range for which one or more ordered extents
were created. So the ordered extents will be around forever.

>
> Or is this a designed behavior for things like fsync?
> Success for all or failure if any fails?

This is unrelated to fsync. It's about leaving ordered extents which
can make any task get them and hang on them forever.

thanks

>
> Thanks,
> Qu
>
>>
>>>
>>> In that case, since we haven't unlock pages/extent, there will no race
>>> nor
>>> new ordered extent, and we are ensured to have only one ordered extent
>>> need
>>> cleanup.
>>>
>>>>
>>>> Also, for any created ordered extent, you want to set the bit
>>>> BTRFS_ORDERED_IOERR on it before removing it, since there might be
>>>> concurrent tasks waiting for it that do error handling (like an fsync,
>>>> since when running delalloc the inode isn't locked).
>>>
>>>
>>>
>>> Fsync is not affected IIRC, as btrfs_reloc_clone_csum() is only called
>>> for
>>> DATA_RELOC tree inode, which we don't call fsync on it.
>>>
>>>>
>>>> Look at the direct IO write path error handling and
>>>> btrfs_endio_direct_write_update_ordered() for a very similar scenario.
>>>> And the same problem happens in the cow case (inode.c:cow_file_range()).
>>>
>>>
>>>
>>> BTW, I have already done it in cow_file_range(), check the beginning
>>> lines
>>> of inode.c of this patch.
>>
>>
>> Indeed. I missed it.
>>
>> Thanks.
>>
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Thanks.
>>>>
>>>>> +       }
>>>>>         btrfs_free_path(path);
>>>>>         return ret;
>>>>>  }
>>>>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>>>>> index 041c3326d109..dba1cf3464a7 100644
>>>>> --- a/fs/btrfs/ordered-data.c
>>>>> +++ b/fs/btrfs/ordered-data.c
>>>>> @@ -650,6 +650,31 @@ void btrfs_remove_ordered_extent(struct inode
>>>>> *inode,
>>>>>         wake_up(&entry->wait);
>>>>>  }
>>>>>
>>>>> +void btrfs_clean_ordered_extent(struct inode *inode, u64 file_offset,
>>>>> +                               u64 ram_len)
>>>>> +{
>>>>> +       struct btrfs_ordered_extent *entry;
>>>>> +       struct btrfs_root *root = BTRFS_I(inode)->root;
>>>>> +
>>>>> +       entry = btrfs_lookup_ordered_range(inode, file_offset,
>>>>> ram_len);
>>>>> +       if (!entry || entry->file_offset != file_offset ||
>>>>> +           entry->len != ram_len)
>>>>> +               goto not_found;
>>>>> +
>>>>> +       /* Same as btrfs_finish_ordered_io() */
>>>>> +       btrfs_remove_ordered_extent(inode, entry);
>>>>> +       btrfs_put_ordered_extent(entry);
>>>>> +       btrfs_put_ordered_extent(entry);
>>>>> +       return;
>>>>> +
>>>>> +not_found:
>>>>> +       WARN_ON(1);
>>>>> +       btrfs_err(root->fs_info,
>>>>> +       "failed to find and clean ordered extent: root %llu ino %llu
>>>>> file_offset %llu len %llu",
>>>>> +                 root->objectid, btrfs_ino(inode), file_offset,
>>>>> ram_len);
>>>>> +       return;
>>>>> +}
>>>>> +
>>>>>  static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
>>>>>  {
>>>>>         struct btrfs_ordered_extent *ordered;
>>>>> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
>>>>> index 5f2b0ca28705..7a989778aa89 100644
>>>>> --- a/fs/btrfs/ordered-data.h
>>>>> +++ b/fs/btrfs/ordered-data.h
>>>>> @@ -163,6 +163,16 @@ btrfs_ordered_inode_tree_init(struct
>>>>> btrfs_ordered_inode_tree *t)
>>>>>  void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
>>>>>  void btrfs_remove_ordered_extent(struct inode *inode,
>>>>>                                 struct btrfs_ordered_extent *entry);
>>>>> +
>>>>> +/*
>>>>> + * Function to cleanup an allocated ordered extent in error routine.
>>>>> + *
>>>>> + * As error handler in run_delalloc_range() will clear all related
>>>>> pages
>>>>> + * and skip their IO, we have no method to finish inserted ordered
>>>>> extent.
>>>>> + * So we must use this function to clean it up.
>>>>> + */
>>>>> +void btrfs_clean_ordered_extent(struct inode *inode, u64 file_offset,
>>>>> +                               u64 ram_len);
>>>>>  int btrfs_dec_test_ordered_pending(struct inode *inode,
>>>>>                                    struct btrfs_ordered_extent
>>>>> **cached,
>>>>>                                    u64 file_offset, u64 io_size, int
>>>>> uptodate);
>>>>> --
>>>>> 2.11.1
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>>
>
>



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
