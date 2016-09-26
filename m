Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38275 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034983AbcIZObt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 10:31:49 -0400
Subject: Re: [PATCH] qgroup: Prevent qgroup->reserved from going subzero
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1474570050-4715-1-git-send-email-rgoldwyn@suse.de>
 <a5707357-38d1-f2c3-41cf-b9d76bd992a3@cn.fujitsu.com>
 <628e1dcd-ddc3-3f37-8a47-c01c912db970@suse.com>
 <65e6515c-a9f3-d5f9-db6b-3ffd8d97f90e@cn.fujitsu.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <0e892f0a-22b3-0fd7-ac8f-d52b76b4d4af@suse.de>
Date: Mon, 26 Sep 2016 09:31:42 -0500
MIME-Version: 1.0
In-Reply-To: <65e6515c-a9f3-d5f9-db6b-3ffd8d97f90e@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/25/2016 09:33 PM, Qu Wenruo wrote:
> 
> 
> At 09/23/2016 09:43 PM, Goldwyn Rodrigues wrote:
>>
>>
>> On 09/22/2016 08:06 PM, Qu Wenruo wrote:
>>>
>>>
>>> At 09/23/2016 02:47 AM, Goldwyn Rodrigues wrote:
>>>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>>
>>>> While free'ing qgroup->reserved resources, we must check
>>>> if the page is already commmitted to disk or still in memory.
>>>> If not, the reserve free is doubly accounted, once while
>>>> invalidating the page, and the next time while free'ing
>>>> delalloc. This results is qgroup->reserved(u64) going subzero,
>>>> thus very large value. So, no further I/O can be performed.
>>>>
>>>> This is also expressed in the comments, but not performed.

This statement crept in error.

>>>>
>>>> Testcase:
>>>> SCRATCH_DEV=/dev/vdb
>>>> SCRATCH_MNT=/mnt
>>>> mkfs.btrfs -f $SCRATCH_DEV
>>>> mount -t btrfs $SCRATCH_DEV $SCRATCH_MNT
>>>> cd $SCRATCH_MNT
>>>> btrfs quota enable $SCRATCH_MNT
>>>> btrfs subvolume create a
>>>> btrfs qgroup limit 50m a $SCRATCH_MNT
>>>> sync
>>>> for c in {1..15}; do
>>>> dd if=/dev/zero  bs=1M count=40 of=$SCRATCH_MNT/a/file;
>>>> done
>>>>
>>>> sleep 10
>>>> sync
>>>> sleep 5
>>>>
>>>> touch $SCRATCH_MNT/a/newfile
>>>>
>>>> echo "Removing file"
>>>> rm $SCRATCH_MNT/a/file
>>>>
>>>> Fixes: b9d0b38928 ("btrfs: Add handler for invalidate page")
>>>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>>> ---
>>>>  fs/btrfs/inode.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>> index e6811c4..2e2a026 100644
>>>> --- a/fs/btrfs/inode.c
>>>> +++ b/fs/btrfs/inode.c
>>>> @@ -8917,7 +8917,8 @@ again:
>>>>       * 2) Not written to disk
>>>>       *    This means the reserved space should be freed here.
>>>>       */
>>>> -    btrfs_qgroup_free_data(inode, page_start, PAGE_SIZE);
>>>> +    if (PageDirty(page))
>>>> +        btrfs_qgroup_free_data(inode, page_start, PAGE_SIZE);
>>>>      if (!inode_evicting) {
>>>>          clear_extent_bit(tree, page_start, page_end,
>>>>                   EXTENT_LOCKED | EXTENT_DIRTY |
>>>>
>>> Thanks for the test case.
>>>
>>> However for the fix, I'm afraid it may not be the root cause.
>>>
>>> Here, if the pages are dirty, then corresponding range is marked
>>> EXTENT_QGROUP_RESERVED.
>>> Then btrfs_qgroup_free_data() will clear that bit and reduce the number.
>>>
>>> If the pages are already committed, then corresponding range won't be
>>> marked EXTENT_QGROUP_RESERVED.
>>> Later btrfs_qgroup_free_data() won't reduce any bytes, since it will
>>> only reduce the bytes if it cleared EXTENT_QGROUP_RESERVED bit.
>>>
>>> If everything goes well there is no need to check PageDirty() here, as
>>> we have EXTENT_QGROUP_RESERVED bit for that accounting.
>>>
>>> So there is some other thing causing EXTENT_QGROUP_RESERVED bit out of
>>> sync with dirty pages.
>>> Considering you did it 15 times to reproduce the problem, maybe there is
>>> some race causing the problem?
>>>
>>
>> You can have pages marked as not dirty with EXTENT_QGROUP_RESERVED set
>> for a truncate operation. Performing dd on the same file, truncates the
>> file before overwriting, while the pages of the previous writes are
>> still in memory and not committed to disk.
>>
>> truncate_inode_page() -> truncate_complete_page() clears the dirty flag.
>> So, you can have a case where the EXTENT_QGROUP_RESERVED bit is set
>> while the page is not listed as dirty because the truncate "cleared" all
>> the dirty pages.
>>
> 
> Sorry I still don't get the point.
> Would you please give a call flow of the timing dirtying page and
> calling btrfs_qgroup_reserve/free/release_data()?
> 
> Like:
> __btrfs_buffered_write()
> |- btrfs_check_data_free_space()
> |  |- btrfs_qgroup_reserve_data() <- Mark QGROUP_RESERVED bit
> |- btrfs_dirty_pages()            <- Mark page dirty
> 
> 
> [[Timing of btrfs_invalidatepage()]]
> About your commit message "once while invalidating the page, and the
> next time while free'ing delalloc."
> "Free'ing delalloc" did you mean btrfs_qgroup_free_delayed_ref().
> 
> If so, it means one extent goes through full write back, and long before
> calling btrfs_qgroup_free_delayed_ref(), it will call
> btrfs_qgroup_release_data() to clear QGROUP_RESERVED.
> 
> So the call will be:
> __btrfs_buffered_write()
> |- btrfs_check_data_free_space()
> |  |- btrfs_qgroup_reserve_data() <- Mark QGROUP_RESERVED bit
> |- btrfs_dirty_pages()            <- Mark page dirty
> 
> <data write back happens>
> run_delalloc_range()
> |- cow_file_range()
>    |- extent_clear_unlock_delalloc() <- Clear page dirty
> 
> <modifying metadata>
> 
> btrfs_finish_ordered_io()
> |- insert_reserved_file_extent()
>    |- btrfs_qgroup_release_data() <- Clear QGROUP_RESERVED bit
>                                      but not decrease reserved space
> 
> <run delayed refs, normally happens in commit_trans>
> run_one_delyaed_refs()
> |- btrfs_qgroup_free_delayed_ref() <- Directly decrease reserved space
> 
> 
> So the problem seems to be, btrfs_invalidatepage() is called after
> run_delalloc_range() but before btrfs_finish_ordered_io().
> 
> Did you mean that?

This happens event before a writeback happens. So, here is what is
happening. This is in reference, and specific to the test case in the
description.

Process: dd - first time
__btrfs_buffered_write()
|- btrfs_check_data_free_space()
|  |- btrfs_qgroup_reserve_data() <- Mark QGROUP_RESERVED bit
|- btrfs_dirty_pages()            <- Mark page dirty

Please note data writeback does _not_ happen/complete.

Process: dd - next time, new process
sys_open O_TRUNC
.
 |-btrfs_setattr()
   |-truncate_pagecache()
     |-truncate_inode_pages_range()
        |-truncate_inode_page() - Page is cleared of Dirty flag.
          |-btrfs_invalidatepage(page)
            |-__btrfs_qgroup_release_data()
              |-btrfs_qgroup_free_refroot() - qgroup->reserved is
reduced by PAGESIZE.


Process: sync
btrfs_sync_fs()
|-btrfs_commit_transaction()
  |-btrfs_run_delayed_refs()
    |- qgroup_free_refroot() - Reduces reserved by the size of the
extent (in this case, the filesize of dd (first time)), even though some
of the PAGESIZEs have been reduced while performing the truncate on the
file.

I hope that makes it clear.

> 
> [[About test case]]
> And for the test case, I can't reproduce the problem no matter if I
> apply the fix or not.
> 
> Either way it just fails after 3 loops of dd, and later dd will all fail.
> But I can still remove the file and write new data into the fs.
> 

Strange? I can reproduce at every instance of running it. Even on 4.8.0-rc7

> 
> [[Extra protect about qgroup->reserved]]
> And for the underflowed qgroup reserve space, would you mind to add
> warning for that case?
> Just like what we did in qgroup excl/rfer values, so at least it won't
> make qgroup blocking any write.
> 

Oh yes, I wonder why that is not placed there when it is placed in all
other location where qgroup->reserved is reduced.

Also, this has nothing to do with the comment of two ways of free'ing
the qgroups, as suggested in the commit statement. Thats my bad.

-- 
Goldwyn
