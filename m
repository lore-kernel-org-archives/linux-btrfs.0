Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933019AbcI0OEx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Sep 2016 10:04:53 -0400
Subject: Re: [PATCH] qgroup: Prevent qgroup->reserved from going subzero
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1474570050-4715-1-git-send-email-rgoldwyn@suse.de>
 <a5707357-38d1-f2c3-41cf-b9d76bd992a3@cn.fujitsu.com>
 <628e1dcd-ddc3-3f37-8a47-c01c912db970@suse.com>
 <65e6515c-a9f3-d5f9-db6b-3ffd8d97f90e@cn.fujitsu.com>
 <0e892f0a-22b3-0fd7-ac8f-d52b76b4d4af@suse.de>
 <1274b3b2-d196-ee9e-2261-d2f5cb906477@cn.fujitsu.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <2a9a3890-3f32-f175-b4aa-becf7caabb7f@suse.de>
Date: Tue, 27 Sep 2016 09:04:42 -0500
MIME-Version: 1.0
In-Reply-To: <1274b3b2-d196-ee9e-2261-d2f5cb906477@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/26/2016 10:10 PM, Qu Wenruo wrote:
> 
> 
> At 09/26/2016 10:31 PM, Goldwyn Rodrigues wrote:
>>
>>
>> On 09/25/2016 09:33 PM, Qu Wenruo wrote:
>>>
>>>
>>> At 09/23/2016 09:43 PM, Goldwyn Rodrigues wrote:
>>>>
>>>>
> [snipped]
>>>
>>> Sorry I still don't get the point.
>>> Would you please give a call flow of the timing dirtying page and
>>> calling btrfs_qgroup_reserve/free/release_data()?
>>>
>>> Like:
>>> __btrfs_buffered_write()
>>> |- btrfs_check_data_free_space()
>>> |  |- btrfs_qgroup_reserve_data() <- Mark QGROUP_RESERVED bit
>>> |- btrfs_dirty_pages()            <- Mark page dirty
>>>
>>>
>>> [[Timing of btrfs_invalidatepage()]]
>>> About your commit message "once while invalidating the page, and the
>>> next time while free'ing delalloc."
>>> "Free'ing delalloc" did you mean btrfs_qgroup_free_delayed_ref().
>>>
>>> If so, it means one extent goes through full write back, and long before
>>> calling btrfs_qgroup_free_delayed_ref(), it will call
>>> btrfs_qgroup_release_data() to clear QGROUP_RESERVED.
>>>
>>> So the call will be:
>>> __btrfs_buffered_write()
>>> |- btrfs_check_data_free_space()
>>> |  |- btrfs_qgroup_reserve_data() <- Mark QGROUP_RESERVED bit
>>> |- btrfs_dirty_pages()            <- Mark page dirty
>>>
>>> <data write back happens>
>>> run_delalloc_range()
>>> |- cow_file_range()
>>>    |- extent_clear_unlock_delalloc() <- Clear page dirty
>>>
>>> <modifying metadata>
>>>
>>> btrfs_finish_ordered_io()
>>> |- insert_reserved_file_extent()
>>>    |- btrfs_qgroup_release_data() <- Clear QGROUP_RESERVED bit
>>>                                      but not decrease reserved space
>>>
>>> <run delayed refs, normally happens in commit_trans>
>>> run_one_delyaed_refs()
>>> |- btrfs_qgroup_free_delayed_ref() <- Directly decrease reserved space
>>>
>>>
>>> So the problem seems to be, btrfs_invalidatepage() is called after
>>> run_delalloc_range() but before btrfs_finish_ordered_io().
>>>
>>> Did you mean that?
>>
>> This happens event before a writeback happens. So, here is what is
>> happening. This is in reference, and specific to the test case in the
>> description.
> 
> The flowchart helps a lot, thanks.
> 
> But still some flow is still strange.
>>
>> Process: dd - first time
>> __btrfs_buffered_write()
>> |- btrfs_check_data_free_space()
>> |  |- btrfs_qgroup_reserve_data() <- Mark QGROUP_RESERVED bit
>> |- btrfs_dirty_pages()            <- Mark page dirty
>>
>> Please note data writeback does _not_ happen/complete.
> 
> This part is completely fine.
> 
>>
>> Process: dd - next time, new process
>> sys_open O_TRUNC
>> .
>>  |-btrfs_setattr()
>>    |-truncate_pagecache()
>>      |-truncate_inode_pages_range()
>>         |-truncate_inode_page() - Page is cleared of Dirty flag.
>>           |-btrfs_invalidatepage(page)
>>             |-__btrfs_qgroup_release_data()
>>               |-btrfs_qgroup_free_refroot() - qgroup->reserved is
>> reduced by PAGESIZE.
> 
> That's OK too. No problem.
> Although the __btrfs_qgroup_release_data() is called by
> btrfs_qgroup_free_data().
> Which cleared QGROUP_RESERVED flag.
> 
> 
> So the call flow should be
> 
>   |-btrfs_setattr()
>     |-truncate_pagecache()
>       |-truncate_inode_pages_range()
>          |-truncate_inode_page()        <- Clear page dirty
>            |-btrfs_invalidatepage(page)
>              |-btrfs_qgroup_free_data() <- reduce qgroup->reserved
>                                            and clear QGROUP_RESERVED
> 
> After btrfs_setattr(), the new dd write data.
> So __btrfs_buffered_write() happens again,
> dirtying pages and mark QGROUP_RESERVED and increase qgroup->reserved.
> 
> So here I don't see any problem
> buffered_write:
>   Mark dirty
>   Mark QGROUP_RESERVED
>   Increase qgroup->reserved
> 
> btrfs_setattr:
>   Clear dirty
>   Clear QGROUP_RESERVED
>   Decrease qgroup->reserved
> 
> All pairs with each other, no leak no underflow.

Yes, but the problem is
run_one_delayed_ref()
 |-btrfs_qgroup_free_delayed_ref
uses delayed_ref_head->qgroup_reserved to reduce the count. Which
function is responsible for decreasing delayed_ref_head->qgroup_reserved
when btrfs_invalidatepage() is reducing the count?


> 
> Until the last buffered_write(), which doesn't got truncated.
> 
>>
>>
>> Process: sync
>> btrfs_sync_fs()
>> |-btrfs_commit_transaction()
>>   |-btrfs_run_delayed_refs()
>>     |- qgroup_free_refroot() - Reduces reserved by the size of the
>> extent (in this case, the filesize of dd (first time)), even though some
>> of the PAGESIZEs have been reduced while performing the truncate on the
>> file.
> 
> The delayed_ref belongs to the last extent, which doesn't got truncated.
> 
> And in that case, that last extent got into disk.
> run_dealloc_range() <- Write data into disk
> finish_ordered_io() <- Update metadata
>   |- insert_reserved_file_extents()
>      |- btrfs_alloc_reserved_file_extent()
>      |  |- btrfs_add_delayed_data_ref
>      |     <This will cause a new delayed_data_ref>
>      |- btrfs_qgroup_release_data()
>         <This will clear QGROURP_RESERVED>
> 
> Then goes to your btrfs_sync_fs() => qgroup_free_refroot()
> 
> 
> 
> [[I think I find the problem now]]
> 
> Between btrfs_alloc_reserved_file_extent() and
> btrfs_qgroup_release_data(), there is a window that delayed_refs can be
> executed.
> Since that d*mn delayed_refs can be run at any time asynchronously.
> 
> In that case, it will call qgroup_free_refroot() first at another
> process context, and later btrfs_qgroup_release_data() get schedualed,
> which will clear QGROUP_RESERVED again, causing the underflow.
> 
> Although it's not the original cause you reported, would you mind to try
> the following quick-dirty fix without your fix, to see if it fixes the
> problem?
> 
> -------
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e6811c4..70efa14 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2168,15 +2168,15 @@ static int insert_reserved_file_extent(struct
> btrfs_trans_handle *trans,
>         ins.objectid = disk_bytenr;
>         ins.offset = disk_num_bytes;
>         ins.type = BTRFS_EXTENT_ITEM_KEY;
> -       ret = btrfs_alloc_reserved_file_extent(trans, root,
> -                                       root->root_key.objectid,
> -                                       btrfs_ino(inode), file_pos,
> -                                       ram_bytes, &ins);
>         /*
>          * Release the reserved range from inode dirty range map, as it is
>          * already moved into delayed_ref_head
>          */
>         btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
> +       ret = btrfs_alloc_reserved_file_extent(trans, root,
> +                                       root->root_key.objectid,
> +                                       btrfs_ino(inode), file_pos,
> +                                       ram_bytes, &ins);
>  out:
>         btrfs_free_path(path);
> 
> -------

No, it does not work.

> 
>>
>> I hope that makes it clear.
>>
>>>
>>> [[About test case]]
>>> And for the test case, I can't reproduce the problem no matter if I
>>> apply the fix or not.
>>>
>>> Either way it just fails after 3 loops of dd, and later dd will all
>>> fail.
>>> But I can still remove the file and write new data into the fs.
>>>
>>
>> Strange? I can reproduce at every instance of running it. Even on
>> 4.8.0-rc7
> 
> Maybe related to the memory size.
> 
> Since you're also using VM, maybe your VM RAM is too small, so dirty
> pages pressure triggers a commit halfway and cause the race?

Not quite, this problem happens on a physical machine as well. Besides,
this VM is not in memory pressure. I tried it again on 4.8.0-rc8.

-- 
Goldwyn
