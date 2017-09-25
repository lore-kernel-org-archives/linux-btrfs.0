Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52998 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934132AbdIYNXF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 09:23:05 -0400
Subject: Re: [PATCH 08/10] btrfs: remove unused parameter in cow_file_range
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
 <1503308630-6652-9-git-send-email-nborisov@suse.com>
 <13b784de-e906-7334-8aae-39cb7ce8c85e@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <18baf854-ef55-66d0-cc4d-d7d6bc90b5d8@gmx.com>
Date: Mon, 25 Sep 2017 21:22:49 +0800
MIME-Version: 1.0
In-Reply-To: <13b784de-e906-7334-8aae-39cb7ce8c85e@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月25日 20:18, Nikolay Borisov wrote:
> 
> 
> On 21.08.2017 12:43, Nikolay Borisov wrote:
>> The delalloc_end parameter was only passed to extent_clear_unlock_delalloc, but
>> since its usage was removed form that function let's also remove it from the
>> caller's parameter list.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> ping, since most of the series has been merged but this one has been
> left out I assume it could have been missed.

Commit 897a41b1167955bd543bb252fd3f06f5844f2177
btrfs: extend btrfs_set_extent_delalloc and its friends to support 
in-band dedupe and subpage size patchset

That line is added to support subpage sized sectorsize.
(BTW, inband dedupe is not really using it IIRC)

It's my fault since at that time I believed subpage size patchset would 
be merged before inband dedupe, but the truth is neither is going to be 
merged soon.

I think it's better to revert that commit until we really have a 
schedule for sub page size patchset.
(BTW, according to the update internal of patchset "Allow I/O on blocks 
whose size is less than page size", it may be updated in recent month if 
it gets updated)

Thanks,
Qu
> 
>> ---
>>   fs/btrfs/inode.c | 20 +++++++++-----------
>>   1 file changed, 9 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 98b56aca0a6f..156be9face5b 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -105,9 +105,9 @@ static int btrfs_truncate(struct inode *inode);
>>   static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
>>   static noinline int cow_file_range(struct inode *inode,
>>   				   struct page *locked_page,
>> -				   u64 start, u64 end, u64 delalloc_end,
>> -				   int *page_started, unsigned long *nr_written,
>> -				   int unlock, struct btrfs_dedupe_hash *hash);
>> +				   u64 start, u64 end, int *page_started,
>> +				   unsigned long *nr_written, int unlock,
>> +				   struct btrfs_dedupe_hash *hash);
>>   static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
>>   				       u64 orig_start, u64 block_start,
>>   				       u64 block_len, u64 orig_block_len,
>> @@ -739,8 +739,6 @@ static noinline void submit_compressed_extents(struct inode *inode,
>>   					     async_extent->start,
>>   					     async_extent->start +
>>   					     async_extent->ram_size - 1,
>> -					     async_extent->start +
>> -					     async_extent->ram_size - 1,
>>   					     &page_started, &nr_written, 0,
>>   					     NULL);
>>   
>> @@ -930,9 +928,9 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
>>    */
>>   static noinline int cow_file_range(struct inode *inode,
>>   				   struct page *locked_page,
>> -				   u64 start, u64 end, u64 delalloc_end,
>> -				   int *page_started, unsigned long *nr_written,
>> -				   int unlock, struct btrfs_dedupe_hash *hash)
>> +				   u64 start, u64 end, int *page_started,
>> +				   unsigned long *nr_written, int unlock,
>> +				   struct btrfs_dedupe_hash *hash)
>>   {
>>   	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>   	struct btrfs_root *root = BTRFS_I(inode)->root;
>> @@ -1431,7 +1429,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>   		if (cow_start != (u64)-1) {
>>   			ret = cow_file_range(inode, locked_page,
>>   					     cow_start, found_key.offset - 1,
>> -					     end, page_started, nr_written, 1,
>> +					     page_started, nr_written, 1,
>>   					     NULL);
>>   			if (ret) {
>>   				if (!nolock && nocow)
>> @@ -1517,7 +1515,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
>>   	}
>>   
>>   	if (cow_start != (u64)-1) {
>> -		ret = cow_file_range(inode, locked_page, cow_start, end, end,
>> +		ret = cow_file_range(inode, locked_page, cow_start, end,
>>   				     page_started, nr_written, 1, NULL);
>>   		if (ret)
>>   			goto error;
>> @@ -1574,7 +1572,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
>>   		ret = run_delalloc_nocow(inode, locked_page, start, end,
>>   					 page_started, 0, nr_written);
>>   	} else if (!inode_need_compress(inode, start, end)) {
>> -		ret = cow_file_range(inode, locked_page, start, end, end,
>> +		ret = cow_file_range(inode, locked_page, start, end,
>>   				      page_started, nr_written, 1, NULL);
>>   	} else {
>>   		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
