Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43033 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752261AbeEOIs2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 04:48:28 -0400
Subject: Re: [PATCH 1/2] btrfs: inode: Don't compress if NODATASUM or
 NODATACOW set
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180515073622.18732-1-wqu@suse.com>
 <20180515073622.18732-2-wqu@suse.com>
 <9c4e5071-d83b-01db-2c2f-518ee1650713@suse.com>
 <d49bc96a-2a15-b64e-eaa0-47e62ee57fa3@gmx.com>
 <9ff17ff6-2b1e-6207-ffdb-67b0fde56368@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8d6a71d1-e134-7e9c-d81e-006f5c318e58@gmx.com>
Date: Tue, 15 May 2018 16:48:17 +0800
MIME-Version: 1.0
In-Reply-To: <9ff17ff6-2b1e-6207-ffdb-67b0fde56368@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年05月15日 16:35, Nikolay Borisov wrote:
> 
> 
> On 15.05.2018 11:30, Qu Wenruo wrote:
>>
>>
>> On 2018年05月15日 16:21, Nikolay Borisov wrote:
>>>
>>>
>>> On 15.05.2018 10:36, Qu Wenruo wrote:
>>>> As btrfs(5) specified:
>>>>
>>>> 	Note
>>>> 	If nodatacow or nodatasum are enabled, compression is disabled.
>>>>
>>>> If NODATASUM or NODATACOW set, we should not compress the extent.
>>>>
>>>> Normally NODATACOW is detected properly in run_delalloc_range() so
>>>> compression won't happen for NODATACOW.
>>>>
>>>> However for NODATASUM we don't have any check, and it can cause
>>>> compressed extent without csum pretty easily, just by:
>>>> ------
>>>> mkfs.btrfs -f $dev
>>>> mount $dev $mnt -o nodatasum
>>>> touch $mnt/foobar
>>>> mount -o remount,datasum,compress $mnt
>>>> xfs_io -f -c "pwrite 0 128K" $mnt/foobar
>>>> ------
>>>>
>>>> And in fact, we have bug report about corrupted compressed extent
>>>> without proper data checksum so even RAID1 can't recover the corruption.
>>>> (https://bugzilla.kernel.org/show_bug.cgi?id9707)
>>>>
>>>> Running compression without proper checksum could cause more damage when
>>>> corruption happens, so there is no need to allow compression for
>>>> NODATACSUM.
>>>>
>>>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/btrfs/inode.c | 8 ++++++++
>>>>  1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>> index d241285a0d2a..dbef3f404559 100644
>>>> --- a/fs/btrfs/inode.c
>>>> +++ b/fs/btrfs/inode.c
>>>> @@ -396,6 +396,14 @@ static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)
>>>>  {
>>>>  	struct btrfs_fs_info *fs_info =trfs_sb(inode->i_sb);
>>>>  
>>>> +	/*
>>>> +	 * Btrfs doesn't support compression without csum or CoW.
>>>> +	 * This should have the highest priority.
>>>> +	 */
>>>> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
>>>> +	    BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
>>>> +		return 0;
>>>> +
>>>
>>> How is this not buggy, given that if inode_need_compress as called from 
>>> compress_file_range will return zero, meaning we jump to cont: label. 
>>> Then in the case of an inline extent we can execute : 
>>
>> In that case, you won't go into compress_file_range() at all.
>>
>> As the only caller of compress_file_range() is async_cow_start(), which
>> get queued in cow_file_range_async().
>>
>> And cow_file_range_async() traces back to run_delalloc_range().
>> Here we determine (basically) where some dirty range goes.
>>
>> The modification in inode_need_compress() mostly affects the decision in
>> run_delalloc_range(), so we won't go cow_file_range_async(), thus we
>> won't hit the problem you described.
> 
> So you have re-iterated what I've described further below. This means it
> should be possible to remove the invocation of inode_need_compress in
> compress_file_range and simplify the code there, no?

Yep, that's true.

> Perhaps
> will_compress can also be removed etc?  As it stands currently it's
> spaghetti code.

Nice idea to further clean this code up.

I'll update both patch after receiving enough feedback.

Thanks,
Qu

> 
>>>
>>> ret =ow_file_range_inline(inode, start, end,          
>>>                            total_compressed,           
>>>                            compress_type, pages);   
>>>
>>> where compress_type would have been set at the beginning of the 
>>> function unconditionally to fs_info->compress_type. 
>>>
>>> For non-inline extents I guess we are ok, given that will_compress 
>>> will not be set. However, this code is rather messy and I'm not sure 
>>> it's well defined what's going to happen in this case with inline extents. 
>>>
>>> OTOH, I think there is something fundamentally wrong in calling 
>>> inode_need_compress in compress_file_range. I.e they work at different 
>>> abstractions. IMO compress_file_range should only be called if we know 
>>> we have to compress the range. 
>>>
>>> So looking around the code in run_delalloc_range (the only function 
>>> which calls cow_file_range_async) we already have : 
>>>
>>>  } else if (!inode_need_compress(inode, start, end)) {                   
>>>                 ret =ow_file_range(inode, locked_page, start, end, end,       
>>>                                       page_started, nr_written, 1, NULL);   
>>>
>>> and in the else branch we have the cow_file_range_async. So the code 
>>> is sort of half-way there to actually decoupling compression checking from 
>>> performing the actual compression. 
>>>
>>>
>>>>  	/* force compress */
>>>>  	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
>>>>  		return 1;
>>>
>>> One more thing, in inode_need_compress shouldn't the inode specific
>>> checks come first something like :
>>>
>>>
>>> static inline int inode_need_compress(struct inode *inode, u64 start, u64 end)  
>>> {                                                                               
>>>         struct btrfs_fs_info *fs_info =trfs_sb(inode->i_sb);                  
>>>                                                                                 
>>>         /* defrag ioctl */                                                      
>>>         if (BTRFS_I(inode)->defrag_compress)                                    
>>>                 return 1;                                                       
>>>         /* bad compression ratios */                                            
>>>         if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)                     
>>>                 return 0;                                                       
>>
>> Not exactly.
>> Force-compress should less us bypass bad compression ratio, so it should
>> be at least before ratio check.
>>
>> Thanks,
>> Qu
>>
>>>         /* force compress */                                                    
>>>         if (btrfs_test_opt(fs_info, FORCE_COMPRESS))                            
>>>                 return 1;                                                       
>>>         if (btrfs_test_opt(fs_info, COMPRESS) ||                                
>>>             BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||                     
>>>             BTRFS_I(inode)->prop_compress)                                      
>>>                 return btrfs_compress_heuristic(inode, start, end);             
>>>         return 0;                                                               
>>> }             
>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
