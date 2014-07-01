Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34186 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbaGAQcW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 12:32:22 -0400
Message-ID: <53B2E27D.2030609@oracle.com>
Date: Wed, 02 Jul 2014 00:31:57 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/2 v3 RESEND] Btrfs: device_list_add() should not update
 list when mounted
References: <1402633581-19265-1-git-send-email-Anand.Jain@oracle.com> <53B26066.1060505@cn.fujitsu.com>
In-Reply-To: <53B26066.1060505@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks for the commenting Wang.
inline below.


On 01/07/2014 15:16, Wang Shilong wrote:
> Hi Anand,
>
> Sorry for delay reply, more comments below:
>
> On 06/13/2014 12:26 PM, Anand Jain wrote:
>> From: Anand Jain <anand.jain@oracle.com>
>>
>> device_list_add() is called when user runs btrfs dev scan, which would
>> add
>> any btrfs device into the btrfs_fs_devices list.
>>
>> Now think of a mounted btrfs. And a new device which contains the a SB
>> from the mounted btrfs devices.
>>
>> In this situation when user runs btrfs dev scan, the current code would
>> just replace existing device with the new device.
>>
>> Which is to note that old device is neither closed nor gracefully
>> removed from the btrfs.
>>
>> The FS is still operational with the old bdev however the device name
>> is the btrfs_device is new which is provided by the btrfs dev scan.
>>
>> reproducer:
>>
>> devmgt[1] detach /dev/sdc
>>
>> replace the missing disk /dev/sdc
>>
>> btrfs rep start -f 1 /dev/sde /btrfs
>> Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120
>>          Total devices 2 FS bytes used 32.00KiB
>>          devid    1 size 958.94MiB used 115.88MiB path /dev/sde
>>          devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
>>
>> make /dev/sdc to reappear
>>
>> devmgt attach host2
>>
>> btrfs dev scan
>>
>> btrfs fi show -m
>> Label: none  uuid: 5dc0aaf4-4683-4050-b2d6-5ebe5f5cd120^M
>>          Total devices 2 FS bytes used 32.00KiB^M
>>          devid    1 size 958.94MiB used 115.88MiB path /dev/sdc <- Wrong.
>>          devid    2 size 958.94MiB used 103.88MiB path /dev/sdd
>>
>> since /dev/sdc has been replaced with /dev/sde, the /dev/sdc shouldn't be
>> part of the btrfs-fsid when it reappears. If user want it to be part
>> of it
>> then sys admin should be using btrfs device add instead.
>>
>> [1] github.com/anajain/devmgt.git
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v2->v3: simpler commit and comment message
>> v1->v2: remove '---' in commit messages which conflict with git am
>>
>>   fs/btrfs/volumes.c | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index bb2cd66..56822f0 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -472,6 +472,7 @@ static noinline int device_list_add(const char *path,
>>           device = __find_device(&fs_devices->devices, devid,
>>                          disk_super->dev_item.uuid);
>>       }
>> +
> You add an extra line here.
>>       if (!device) {
>>           if (fs_devices->opened)
>>               return -EBUSY;
>> @@ -497,6 +498,32 @@ static noinline int device_list_add(const char
>> *path,
>>           device->fs_devices = fs_devices;
>>       } else if (!device->name || strcmp(device->name->str, path)) {
>> +        /*
>> +         * When FS is already mounted.
>> +         * 1. If you are here and if the device->name is NULL that means
>> +         *    this device was missing at time of FS mount.
>> +         * 2. If you are here and if the device->name is different
>> from 'path'
>> +         *    that means either
>> +         *      a. The same device disappeared and reappeared with
>> different
>> +         *         name. or
>> +         *      b. The missing-disk-which-was-replaced, has
>> reappeared now.
>> +         *
>> +         *  We must allow 1 and 2a above. But 2b would be a spurious and
>> +         *  unintentional.
>> +         *  Further in case of 1 and 2a above, the disk at 'path'
>> would have
>> +         *  missed some transaction when it was away and in case of 2a
>> +         *  the stale bdev has to be updated as well.
>> +         *  2b must not be allowed at all time.
>> +         */
>> +
>> +        /*
>> +         * As of now don't allow update to btrfs_fs_device through the
>> +         * btrfs dev scan cli, after FS has been mounted.
>> +         */
>> +
>> +        if (fs_devices->opened)
>> +            return -EBUSY;
>> +
> I agree we don't allow to update device list when mounted, i tested this
> patch, it worked but

Thanks for testing this patch set.

> it will output the following message:
>
> Scanning for Btrfs filesystems in '/dev/sdc'
> ERROR: unable to scan the device '/dev/sdc' - Device or resource busy
>
> I think this is a little confusing for common users. Maybe don't return
> error but output
> some log message into kernel buffer, better?


  the Other choices are:

  display the error only when specific device is used
  by the user like 'btrfs dev scan /dev/sdc' And don't print busy /
  invalid error when a system wide scan is used like 'btrfs dev scan'.
  To achieve this we have to tweak btrfs-progs.

  or put the error under the verbose option in the btrfs-progs.




> Thanks,
> Wang
>>           name = rcu_string_strdup(path, GFP_NOFS);
>>           if (!name)
>>               return -ENOMEM;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
