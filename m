Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21355 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaFJBpx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jun 2014 21:45:53 -0400
Message-ID: <539663E1.8050405@oracle.com>
Date: Tue, 10 Jun 2014 09:48:17 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, wangsl.fnst@cn.fujitsu.com, clm@fb.com, jbacik@fb.com
Subject: Re: [PATCH V3] Btrfs: device_list_add() should not update list when
 mounted
References: <1402025201-17140-1-git-send-email-anand.jain@oracle.com> <53965E8C.6050106@cn.fujitsu.com>
In-Reply-To: <53965E8C.6050106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/06/14 09:25, Qu Wenruo wrote:
>
> -------- Original Message --------
> Subject: [PATCH V3] Btrfs: device_list_add() should not update list when
> mounted
> From: Anand Jain <anand.jain@oracle.com>
> To: linux-btrfs@vger.kernel.org
> Date: 2014年06月06日 11:26
>> (looks like there was some sendmail problem I don't see this in the
>> btrfs list,
>> sending again. sorry for multiple copies if any).
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
>>   fs/btrfs/volumes.c | 33 ++++++++++++++++++++++++++++++++-
>>   1 file changed, 32 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index bb2cd66..605d9ef 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -472,9 +472,12 @@ static noinline int device_list_add(const char
>> *path,
>>           device = __find_device(&fs_devices->devices, devid,
>>                          disk_super->dev_item.uuid);
>>       }
>> +
>>       if (!device) {
>> -        if (fs_devices->opened)
>> +        if (fs_devices->opened) {
>> +            printk(KERN_INFO "BTRFS: device list add failed, FS is
>> open");
>>               return -EBUSY;
>> +        }
>>           device = btrfs_alloc_device(NULL, &devid,
>>                           disk_super->dev_item.uuid);
>> @@ -497,6 +500,34 @@ static noinline int device_list_add(const char
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
>> +        if (fs_devices->opened) {
>> +            printk(KERN_INFO "BTRFS: device list update failed, FS is
>> open");
>> +            return -EBUSY;
>> +        }
>> +
> The 'if(fs_devices->opened)' block is in both branch of the
> 'if(!device)' judgement,
> it would be better to extract the code block out of the 'if(!device)'
> block.

  thanks for the comments Qu.

   we have else if. that is when device is found and path is NOT new
   (matches with the old) then we shall return success.

Anand

> Thanks,
> Qu
>>           name = rcu_string_strdup(path, GFP_NOFS);
>>           if (!name)
>>               return -ENOMEM;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
