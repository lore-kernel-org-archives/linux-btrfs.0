Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33026 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752137AbdJKNp7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 09:45:59 -0400
Subject: Re: [PATCH] Btrfs-progs: do not add stale device into fs_devices
To: Nikolay Borisov <nborisov@orcl-no-reply_suse.com>,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux_lkml_grp@oracle.com
References: <20171011002852.2926-1-bo.li.liu@oracle.com>
 <f56dc49b-817b-6655-2215-5bf1552c9d3d@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <a05cf9b5-6995-b446-b076-6ad4bf4864f1@oracle.com>
Date: Wed, 11 Oct 2017 21:45:38 +0800
MIME-Version: 1.0
In-Reply-To: <f56dc49b-817b-6655-2215-5bf1552c9d3d@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/11/2017 05:33 PM, Nikolay Borisov wrote:
> 
> 
> On 11.10.2017 03:28, Liu Bo wrote:
>> If one of btrfs's devices was pulled out and we've replaced it with a
>> new one, then they have the same uuid.
>>
>> If that device gets reconnected, 'btrfs filesystem show' will show the
>> stale one instead of the new one, but on kernel side btrfs has a fix
>> to not include the stale one, this could confuse users as people may
>> monitor btrfs by running that cli.
>>
>> This does the similar thing to what kernel side has done.
>>
>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>> ---
>>   volumes.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/volumes.c b/volumes.c
>> index 2f3943d..c7b7a41 100644
>> --- a/volumes.c
>> +++ b/volumes.c
>> @@ -138,7 +138,20 @@ static int device_list_add(const char *path,
>>   		list_add(&device->dev_list, &fs_devices->devices);
>>   		device->fs_devices = fs_devices;
>>   	} else if (!device->name || strcmp(device->name, path)) {
>> -		char *name = strdup(path);
>> +		char *name;
>> +
>> +		/*
>> +		 * The existing device has newer generation, so this
>> +		 * one could be a stale one, don't add it.
>> +		 */
>> +		if (found_transid < device->generation) {
>> +			warning("adding device %s gen %llu but found a existing device %s gen %llu\n",
>> +				path, found_transid, device->name,
>> +				device->generation, found_transid);
> 
> You pass in 5 parameters but have only 4 formatting strings. I don't see
> the same happening on other warning() invocations? Perhaps the last
> found_transid is not necessary?

  I missed that. Sorry.

Thanks, Anand


>> +			return -EEXIST;
>> +		}
>> +
>> +		name = strdup(path);
>>                   if (!name)
>>                           return -ENOMEM;
>>                   kfree(device->name);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
