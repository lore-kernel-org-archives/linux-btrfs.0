Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58045 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932230AbeAQQOC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 11:14:02 -0500
Subject: Re: [PATCH] btrfs: Add chunk allocation ENOSPC debug message for
 enospc_debug mount option
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180115061352.13799-1-wqu@suse.com>
 <6d5b67be-4aa5-9383-3d30-5756bc1cdc15@suse.com>
 <dfd58ecb-0e95-36c8-7aeb-52924a81b685@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a9b6974c-1969-6da6-2dd5-bd024ba9d0ac@suse.com>
Date: Wed, 17 Jan 2018 18:13:59 +0200
MIME-Version: 1.0
In-Reply-To: <dfd58ecb-0e95-36c8-7aeb-52924a81b685@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.01.2018 02:52, Qu Wenruo wrote:
> 
> 
> On 2018年01月16日 21:47, Nikolay Borisov wrote:
>>
>>
>> On 15.01.2018 08:13, Qu Wenruo wrote:
>>> Enospc_debug makes extent allocator to print more debug messages,
>>> however for chunk allocation, there is no debug message for enospc_debug
>>> at all.
>>>
>>> This patch will add message for the following parts of chunk allocator:
>>>
>>> 1) No rw device at all
>>>    Quite rare, but at least output one message for this case.
>>>
>>> 2) No enough space for some device
>>>    This debug message is quite handy for unbalanced disks with stripe
>>>    based profiles (RAID0/10/5/6).
>>>
>>> 3) Not enough free devices
>>>    This debug message should tell us if current chunk allocator is
>>>    working correctly on minimal device requirement.
>>>
>>> Although under most case, we will hit other ENOSPC before we even hit a
>>> chunk allocator ENOSPC, but such debug info won't help.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/volumes.c | 19 +++++++++++++++++--
>>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index a25684287501..664d8a1b90b3 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -4622,8 +4622,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>>>  
>>>  	BUG_ON(!alloc_profile_is_valid(type, 0));
>>>  
>>> -	if (list_empty(&fs_devices->alloc_list))
>>> +	if (list_empty(&fs_devices->alloc_list)) {
>>> +		if (btrfs_test_opt(info, ENOSPC_DEBUG))
>>> +			btrfs_warn(info, "%s: No writable device", __func__);
>>
>> perhaps this shouldn't be gated on ENOSPC_DEBUG if it's a warning, or if
>> it's to be gated then make it a DEBUG.
> 
> Because the case of no writeable device is rare.
> 
> But change it to debug seems good.
> 
>>
>>>  		return -ENOSPC;
>>> +	}
>>>  
>>>  	index = __get_raid_index(type);
>>>  
>>> @@ -4705,8 +4708,14 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>>>  		if (ret == 0)
>>>  			max_avail = max_stripe_size * dev_stripes;
>>>  
>>> -		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes)
>>> +		if (max_avail < BTRFS_STRIPE_LEN * dev_stripes) {
>>> +			if (btrfs_test_opt(info, ENOSPC_DEBUG))
>>> +				btrfs_debug(info,
>>> +			"%s: devid %llu has no free space, have=%llu want=%u",
>>> +					    __func__, device->devid, max_avail,
>>> +					    BTRFS_STRIPE_LEN * dev_stripes);
>>
>> Here we have a debug output gated on ENOSCP_DEBUG so let's be consistent
>> (hence my previous comment)
>>>  			continue;
>>> +		}
>>>  
>>>  		if (ndevs == fs_devices->rw_devices) {
>>>  			WARN(1, "%s: found more than %llu devices\n",
>>> @@ -4731,6 +4740,12 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>>>  
>>>  	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
>>>  		ret = -ENOSPC;
>>> +		if (btrfs_test_opt(info, ENOSPC_DEBUG)) {
>>> +			btrfs_debug(info,
>>> +		"%s: not enough devices with free space: have=%d minimal=%d increment=%d",
>>> +				    __func__, ndevs, devs_min,
>>> +				    devs_increment * sub_stripes);
>>
>> Without looking at the code it's not really obvious what increment is.
>> Perhaps you can use a more descriptive word?
> 
> "increment" is indeed less meaningful.
> 
> I'll change it to only output "minimal" just min(minimal, devs_min).

I think that 'minimal' should be 'minimal required'

> 
> Thanks,
> Qu
> 
>>
>>> +		}
>>>  		goto error;
>>>  	}
>>>  
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
