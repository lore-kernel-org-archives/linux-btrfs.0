Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933145AbeGJNl4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 09:41:56 -0400
Subject: Re: [PATCH 1/2] btrfs: code reorder in btrfs_prepare_sprout
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180709083353.14517-1-anand.jain@oracle.com>
 <20180710104144.GP3126@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f2a82ecf-4fb4-6eab-bc55-4bab0cebc12c@oracle.com>
Date: Tue, 10 Jul 2018 21:45:10 +0800
MIME-Version: 1.0
In-Reply-To: <20180710104144.GP3126@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/10/2018 06:41 PM, David Sterba wrote:
> On Mon, Jul 09, 2018 at 04:33:52PM +0800, Anand Jain wrote:
>> No functional change, bring the clone of fs_devices and its
>> operations closer, so that it indicates its purpose.
>>
>> Also add a comment to indicate why we clone the fs_devices.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index b63aae267ebe..0e92969b1adc 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2276,18 +2276,21 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
>>   	if (!fs_devices->seeding)
>>   		return -EINVAL;
>>   
>> -	seed_devices = alloc_fs_devices(NULL);
>> -	if (IS_ERR(seed_devices))
>> -		return PTR_ERR(seed_devices);
>> -
>> +	/*
>> +	 * This step ensures the scanned seed device remains scanned,
>> +	 * its not a must for the sprout operation though.
>> +	 */
>>   	old_devices = clone_fs_devices(fs_devices);
>>   	if (IS_ERR(old_devices)) {
>>   		kfree(seed_devices);
> 
> seed_devices is uninitialized here.

Right. It also provides compile warning. I have fixed it in my WS ready
  to send, its been tested with other patches.

> 
>>   		return PTR_ERR(old_devices);
>>   	}
>> -
>>   	list_add(&old_devices->fs_list, &fs_uuids);
>>   
>> +	seed_devices = alloc_fs_devices(NULL);
>> +	if (IS_ERR(seed_devices))
>> +		return PTR_ERR(seed_devices);
> 
> If this fails, is it ok to leave the old_devices in the list? I think it
> would be better to do all the allocations first and then do the rest so
> the error handling is a bit simpler.

  Err my bad. I have better way to fix this using the
  scan_one_device will send it with a new tile pls ignore this patch.

Thanks, Anand

>> +
>>   	memcpy(seed_devices, fs_devices, sizeof(*seed_devices));
>>   	seed_devices->opened = 1;
>>   	INIT_LIST_HEAD(&seed_devices->devices);
>> -- 
>> 2.7.0
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
