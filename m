From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: check if there is enough space for balancing smarter
Date: Fri, 19 Aug 2011 11:07:36 +0800
Message-ID: <4E4DD378.1030404@cn.fujitsu.com>
References: <1312366525-19677-1-git-send-email-liubo2009@cn.fujitsu.com> <20110819024615.GH20461@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, josef@redhat.com,
	chris.mason@oracle.com
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110819024615.GH20461@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2011 10:46 AM, David Sterba wrote:
> Hi,
> 
> too late, already pulled
> 
> On Wed, Aug 03, 2011 at 06:15:25PM +0800, Liu Bo wrote:
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -6682,6 +6682,10 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>>  	struct btrfs_space_info *space_info;
>>  	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
>>  	struct btrfs_device *device;
>> +	u64 min_free;
>         ^^^
> 
>> +	int index;
>> +	int dev_nr = 0;
>> +	int dev_min = 1;
>>  	int full = 0;
>>  	int ret = 0;
>>  
>> @@ -6728,9 +6733,29 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>>  	if (full)
>>  		goto out;
>>  
>> +	/*
>> +	 * index:
>> +	 *      0: raid10
>> +	 *      1: raid1
>> +	 *      2: dup
>> +	 *      3: raid0
>> +	 *      4: single
>> +	 */
>> +	index = get_block_group_index(block_group);
>> +	if (index == 0) {
>> +		dev_min = 4;
>> +		min_free /= 2;
>> +	} else if (index == 1) {
>> +		dev_min = 2;
>> +	} else if (index == 2) {
>> +		min_free *= 2;
>> +	} else if (index == 3) {
>> +		dev_min = fs_devices->rw_devices;
>> +		min_free /= dev_min;
>                 ^^^^^^^^^^^^^^^^^^^
> 
> 64bit division will break 32bit builds, can you please convert it to
> do_div ? the other is 'div-by-power-of-2' which will most probably be
> converted to shifts.
> 

This is my fault, sorry.  Will fix it soon.


thanks,
liubo

> 
> david
> 
>> +	}
>> +
>>  	mutex_lock(&root->fs_info->chunk_mutex);
>>  	list_for_each_entry(device, &fs_devices->alloc_list, dev_alloc_list) {
>> -		u64 min_free = btrfs_block_group_used(&block_group->item);
>>  		u64 dev_offset;
>>  
>>  		/*
>> @@ -6741,7 +6766,11 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>>  			ret = find_free_dev_extent(NULL, device, min_free,
>>  						   &dev_offset, NULL);
>>  			if (!ret)
>> +				dev_nr++;
>> +
>> +			if (dev_nr >= dev_min)
>>  				break;
>> +
>>  			ret = -1;
>>  		}
>>  	}
>> -- 
>> 1.6.5.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

