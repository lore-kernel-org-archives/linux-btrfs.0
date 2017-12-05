Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29559 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdLECxA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 21:53:00 -0500
Subject: Re: [PATCH] btrfs: fix inconsistency during missing device rejoin
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20171204071939.22878-1-anand.jain@oracle.com>
 <730b01da-a293-1309-e22c-ebfe996c0628@jp.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3aeb59b8-3ccf-6657-fcf4-167e9c977230@oracle.com>
Date: Tue, 5 Dec 2017 10:53:28 +0800
MIME-Version: 1.0
In-Reply-To: <730b01da-a293-1309-e22c-ebfe996c0628@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/05/2017 10:18 AM, Misono, Tomohiro wrote:
> 
> 
> On 2017/12/04 16:19, Anand Jain wrote:
>> When device is missing its not necessary that btrfs_device::name is null
>> or the path is different when it reappears. Its possible that device can
>> go missing after its been scanned where neither of
>> btrfs_device::name == NULL OR btrfs_device::name != reappear_dev_path,
>> is true. So just check for btrfs_device::dev_state.missing. Thanks.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 59a8785a2e9e..ac0c4eb5107f 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -715,7 +715,8 @@ static noinline int device_list_add(const char *path,
>>   
>>   		ret = 1;
>>   		device->fs_devices = fs_devices;
>> -	} else if (!device->name || strcmp(device->name->str, path)) {
>> +	} else if (!device->name || strcmp(device->name->str, path) ||
>> +			test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)) {
>>   		/*
>>   		 * When FS is already mounted.
>>   		 * 1. If you are here and if the device->name is NULL that
>>
> 
> I read the comments below this and wonder if BTRFS_DEV_STATE_MISSING is set
> when device->name is null and therefore the first condition can be removed.

  device->name is null only when missing is set.

  Will do this optimize in a new patch, as its about clean up and
  is not about fixing inconsistency as in here.

Thanks, Anand


> Thanks,
> Tomohiro
> 
