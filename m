Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbeGMLQW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 07:16:22 -0400
Subject: Re: [PATCH 1/3] btrfs: warn for num_devices below 0
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180710182241.23754-1-anand.jain@oracle.com>
 <8a7b78aa-1a7f-9edd-e30b-d97d15a35331@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5fd2a33f-f9a0-00a6-ebc1-9cf8cb7dec8d@oracle.com>
Date: Fri, 13 Jul 2018 19:05:27 +0800
MIME-Version: 1.0
In-Reply-To: <8a7b78aa-1a7f-9edd-e30b-d97d15a35331@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/12/2018 03:13 PM, Nikolay Borisov wrote:
> 
> 
> On 10.07.2018 21:22, Anand Jain wrote:
>> In preparation to de-duplicate a section of code where we deduce the
>> num_devices, use warn instead of bug.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index eb78bb8d1108..ce6faeb8bcf8 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -3813,7 +3813,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>   	num_devices = fs_info->fs_devices->num_devices;
>>   	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
>>   	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>> -		BUG_ON(num_devices < 1);
>> +		WARN_ON(num_devices < 1);


> Isn't dev_replace_is_ongoing && num_devices < 1 indeed a logical bug
> situation? Under what condition can it happen that you deem "non
> critical" ?

  In all conditions needs least one device for the FS to be mounted.
  In fact we can just remove it.

Thanks, Anand

>>   		num_devices--;
>>   	}
>>   	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
