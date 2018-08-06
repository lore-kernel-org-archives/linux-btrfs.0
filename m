Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbeHFLCU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Aug 2018 07:02:20 -0400
Subject: Re: [PATCH] btrfs: handle the BUG_ON in btrfs_num_devices()
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180803124526.18497-1-anand.jain@oracle.com>
 <20180803124526.18497-2-anand.jain@oracle.com>
 <9f7d4969-6496-ad5a-a0f9-71bade56e3a6@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <6b4efd17-d04f-6b3b-32c6-28d7ecba4510@oracle.com>
Date: Mon, 6 Aug 2018 16:57:45 +0800
MIME-Version: 1.0
In-Reply-To: <9f7d4969-6496-ad5a-a0f9-71bade56e3a6@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/03/2018 09:33 PM, Nikolay Borisov wrote:
> 
> 
> On  3.08.2018 15:45, Anand Jain wrote:
>> Its a logical bug if we hit fs_devices::num_devices == 1 and if the
>> replace is running because, as fs_devices::num_devices counts the in memory
>> devices, so it should include the replace target which is running as
>> indicated by the flag. If this happens return the -EINVAL back.
>>
>> Suggested-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> Hi,
>>   As it fixes the BUG_ON I have spun a new patch for this.
>>   Instead of -EINVAL should we use ASSERT?
>>
>>   fs/btrfs/volumes.c | 27 ++++++++++++++++++++-------
>>   1 file changed, 20 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 7359596ac8eb..ed2399caff80 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1855,9 +1855,11 @@ void btrfs_assign_next_active_device(struct btrfs_device *device,
>>   }
>>   
>>   /* Returns btrfs_fs_devices::num_devices minus replace device if any */
>> -static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
>> +static int btrfs_num_devices(struct btrfs_fs_info *fs_info, u64 *num_devices)
> 
> Why do you resort to this travesty of returning the value in an input
> parameter? Having the function return int, assuming that we will always
> have a positive device num and in case of an error return a negative
> value. In the worst case when we get to see a btrfs fs consisting of 2
> billion devices then we can start worrying that an int here won't do it.

  Its theoretically wrong. I wonder if David is OK with this? Will wait
  for his comments.

>>   {
>> -	u64 num_devices = fs_info->fs_devices->num_devices;
>> +	int ret = 0;
>> +
>> +	*num_devices = fs_info->fs_devices->num_devices;
>>   
>>   	/*
>>   	 * balance and replace co-exists in a scenario as below..
>> @@ -1867,12 +1869,13 @@ static u64 btrfs_num_devices(struct btrfs_fs_info *fs_info)
>>   	 */
>>   	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>   	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>> -		BUG_ON(num_devices < 1);
>> -		num_devices--;
>> +		if (*num_devices < 1)
>> +			ret = -EINVAL;
>> +		(*num_devices)--;
>>   	}
>>   	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>>   
>> -	return num_devices;
>> +	return ret;
>>   }
>>   
>>   int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>> @@ -1886,7 +1889,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
>>   
>>   	mutex_lock(&uuid_mutex);
>>   
>> -	num_devices = btrfs_num_devices(fs_info);
>> +	ret = btrfs_num_devices(fs_info, &num_devices);
>> +	if (ret) {
> 
> The canonical form, used across the whole code base of btrfs, for
> checking for an error is 'if (ret <0)' as such please stick to it in
> this and all future patches.

  Not a big deal will fix.

> (I have a vague recollection this is not the first time I have given you
> this feedback)


>> +		btrfs_err(fs_info, "logical bug num_devices %llu < 0",
>> +			  num_devices);
>> +		return ret;
>> +	}
>>   
>>   	ret = btrfs_check_raid_min_devices(fs_info, num_devices - 1);
>>   	if (ret)
>> @@ -3755,7 +3763,12 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>   		}
>>   	}
>>   
>> -	num_devices = btrfs_num_devices(fs_info);
>> +	ret = btrfs_num_devices(fs_info, &num_devices);
>> +	if (ret) {
> ditto

  ok.

Thanks, Anand

>> +		btrfs_err(fs_info, "hits a logical bug num_devices %llu < 0",
>> +			  num_devices);
>> +		return ret;
>> +	}
>>   
>>   	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
>>   	if (num_devices > 1)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
