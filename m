Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28900 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758671Ab3HBKHE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 06:07:04 -0400
Message-ID: <51FB8501.80605@cn.fujitsu.com>
Date: Fri, 02 Aug 2013 18:08:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix what bits we clear when erroring out from
 delalloc
References: <1375118662-29718-1-git-send-email-jbacik@fusionio.com> <51F75CDC.505@cn.fujitsu.com>
In-Reply-To: <51F75CDC.505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Josef

On Tue, 30 Jul 2013 14:27:40 +0800, Miao Xie wrote:
>>  			extent_clear_unlock_delalloc(inode, start, end, NULL,
>> -						     EXTENT_DIRTY |
>> -						     EXTENT_DELALLOC,
>> +						     EXTENT_DELALLOC |
>> +						     EXTENT_DO_ACCOUNTING |
>> +						     EXTENT_DEFRAG,
>>  						     PAGE_UNLOCK |
>>  						     PAGE_CLEAR_DIRTY |
>>  						     PAGE_SET_WRITEBACK |
> 
> I found we released the reserved space in cow_file_range_inline(), but at that time,
> we didn't drop the outstanding_extents counter by the number of the delalloc extents,
> so it might leave some reserved space which was not released. So I think we should remove
> the release function in cow_file_range_inline().
> 
> (This bug is not introduced by your patch. but if we don't fix the above problem before
>  applying your patch, the double release would happen because we have released the space
>  in cow_file_range_inline())

I'm sorry that I made a mistake, the problem I said above doesn't exist because the block
size is equal to the page size, and we can only inline the file extent which is <= the page size,
so it is unlikely that one inline extent has two extent state objects.

But the double release of the reserved space exists actually. We can fix by removing the release
function in cow_file_range_inline() and passing EXTENT_DO_ACCOUNTING to the clear function.

Thanks
Miao

>> @@ -593,9 +594,10 @@ free_pages_out:
>>  
>>  cleanup_and_out:
>>  	extent_clear_unlock_delalloc(inode, start, end, NULL,
>> -				     EXTENT_DIRTY | EXTENT_DELALLOC,
>> -				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
>> -				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
>> +				     EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
>> +				     EXTENT_DEFRAG, PAGE_UNLOCK |
>> +				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
>> +				     PAGE_END_WRITEBACK);
>>  	if (!trans || IS_ERR(trans))
>>  		btrfs_error(root->fs_info, ret, "Failed to join transaction");
>>  	else
>> @@ -770,8 +772,8 @@ retry:
>>  		extent_clear_unlock_delalloc(inode, async_extent->start,
>>  				async_extent->start +
>>  				async_extent->ram_size - 1,
>> -				NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
>> -				EXTENT_DIRTY, PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
>> +				NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
>> +				PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
>>  				PAGE_SET_WRITEBACK);
>>  		ret = btrfs_submit_compressed_write(inode,
>>  				    async_extent->start,
>> @@ -795,9 +797,9 @@ out_free:
>>  				     async_extent->start +
>>  				     async_extent->ram_size - 1,
>>  				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |
>> -				     EXTENT_DIRTY, PAGE_UNLOCK |
>> -				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
>> -				     PAGE_END_WRITEBACK);
>> +				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
>> +				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
>> +				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
>>  	kfree(async_extent);
>>  	goto again;
>>  }
>> @@ -884,7 +886,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
>>  		if (ret == 0) {
>>  			extent_clear_unlock_delalloc(inode, start, end, NULL,
>>  				     EXTENT_LOCKED | EXTENT_DELALLOC |
>> -				     EXTENT_DIRTY, PAGE_UNLOCK |
>> +				     EXTENT_DEFRAG, PAGE_UNLOCK |
>>  				     PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
>>  				     PAGE_END_WRITEBACK);
> 
> If we remove the reserved space release function in cow_file_range_inline() as I said above,
> we should add EXTENT_DO_ACCOUNTING here.
> 
> I will send a patch to fix the problem I said above soon, please wait a moment
> 
> The other code is OK.
> 
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> 

