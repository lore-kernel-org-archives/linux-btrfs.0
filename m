Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28334 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaHLIAL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 04:00:11 -0400
Message-ID: <53E9C985.2040007@oracle.com>
Date: Tue, 12 Aug 2014 16:00:05 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: fix rw_devices miss match after seed replace
References: <1407750176-15853-1-git-send-email-anand.jain@oracle.com> <1407750176-15853-3-git-send-email-anand.jain@oracle.com> <53E9C267.4020902@cn.fujitsu.com>
In-Reply-To: <53E9C267.4020902@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/08/2014 15:29, Miao Xie wrote:
> On Mon, 11 Aug 2014 17:42:55 +0800, Anand Jain wrote:
>> reproducer:
>>      reproducer:
>>      mount /dev/sdb /btrfs
>>      btrfs dev add /dev/sdc /btrfs
>>      btrfs rep start -B /dev/sdb /dev/sdd /btrfs
>>      umount /btrfs
>>
>> WARNING: CPU: 0 PID: 3882 at fs/btrfs/volumes.c:892 __btrfs_close_devices+0x1c8/0x200 [btrfs]()
>>
>> which is
>>
>>          WARN_ON(fs_devices->rw_devices);
>>
>>     The problem here is that we did not add one to the rw_devices when
>>     we replace the seed device with a writable device.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/dev-replace.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index eea26e1..fb0a7fa 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -562,6 +562,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>   	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
>>   		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
>>   	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
>> +	if (src_device->fs_devices->seeding)
>> +		fs_info->fs_devices->rw_devices++;
>
> As I said in the previous version of this patch, we might increase ->rw_devices twice if
> the source device is a missing device in the seed filesystem. Once is here, the other is
> in btrfs_rm_dev_replace_srcdev().

   Yes that should be fixed. I think a separate patch will do since
   btrfs_rm_dev_replace_srcdev() is invariably incrementing the
   ->rw_devices without checking if the fs is a seed fs.

Anand

> Thanks
> Miao
>
>>
>>   	/* replace the sysfs entry */
>>   	btrfs_kobj_rm_device(fs_info, src_device);
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
