From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix oops while writing data to SSD partitions
Date: Thu, 28 Jul 2011 09:11:56 +0800
Message-ID: <4E30B75C.3070509@cn.fujitsu.com>
References: <4E2FDF1E.8080206@cn.fujitsu.com> <4E302004.2030007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E302004.2030007@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/27/2011 10:26 PM, Josef Bacik wrote:
> On 07/27/2011 05:49 AM, liubo wrote:
>> Here I have a two SSD-partitions btrfs, and they are defaultly set to
>> "data=raid0, metadata=raid1", then I try to fill my btrfs partition
>> till "No space left on device", via "dd if=/dev/zero of=/mnt/btrfs/tmp".
>>
>> I get an oops panic from kernel BUG at fs/btrfs/extent-tree.c:5199!, which
>> refers to find_free_extent's
>> BUG_ON(index != get_block_group_index(block_group));
>>
>> In SSD mode, in order to find enough space to alloc, we may check the
>> block_group cache which has been checked sometime before, but the index is not
>> updated, where it hits the BUG_ON.
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  fs/btrfs/extent-tree.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 71cd456..3213c39 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -5065,7 +5065,9 @@ have_block_group:
>>  			 * group is does point to and try again
>>  			 */
>>  			if (!last_ptr_loop && last_ptr->block_group &&
>> -			    last_ptr->block_group != block_group) {
>> +			    last_ptr->block_group != block_group &&
>> +			    index <=
>> +				 get_block_group_index(last_ptr->block_group)) {
>>  
>>  				btrfs_put_block_group(block_group);
>>  				block_group = last_ptr->block_group;
> 
> Ugh I wish we could make this prettier but
> 
> Acked-by: Josef Bacik <josef@redhat.com>
> 

I wish that, too. ;)

But lots of goto really make life harder...we can somehow improve it later.

thanks,
liubo

> Thanks,
> 
> Josef
> 

