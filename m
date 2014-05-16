Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:56352 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbaEPOpx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 10:45:53 -0400
Received: by mail-qc0-f182.google.com with SMTP id e16so4506747qcx.13
        for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 07:45:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53761D30.6080207@oracle.com>
References: <1399971906-1237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<1399971906-1237-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<53761D30.6080207@oracle.com>
Date: Fri, 16 May 2014 22:45:52 +0800
Message-ID: <CAP9B-QmvvOnRTYKjEyx4yHR=TW_eZVT4YqvQU-23u_V2yUrqPA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: set right total device count for seeding support
From: Shilong Wang <wangshilong1991@gmail.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-05-16 22:14 GMT+08:00 Anand Jain <Anand.Jain@oracle.com>:
>
> Wang,
>
>  There seems to be a problem - after we delete the seed
>  disk, the total_devices didn't decrement back to 1.
>  reproducer as in the below test case. (I used btrfs-devlist
>  (posted) to check fs_devices).

There should be other problems flighting or i missed something ,
i'll take a look at this. Thanks Anand for finding this.

>
>
>  > # mkfs.btrfs -f /dev/sdb
>  > # btrfstune -S 1 /dev/sdb
>  > # mount /dev/sdb /mnt
>  > # btrfs device add -f /dev/sdc /mnt --->fs_devices->total_devices = 1
>  mount -o rw,remount /mnt
>  btrfs dev del /dev/sdb /mnt --> fs_devices->total_devices is still 2
>
> Thanks, Anand
>
>
>
> On 13/05/14 17:05, Wang Shilong wrote:
>>
>> Seeding device support allows us to create a new filesystem
>> based on existed filesystem.
>>
>> However newly created filesystem's @total_devices should include seed
>> devices. This patch fix the following problem:
>>
>>   # mkfs.btrfs -f /dev/sdb
>>   # btrfstune -S 1 /dev/sdb
>>   # mount /dev/sdb /mnt
>>   # btrfs device add -f /dev/sdc /mnt --->fs_devices->total_devices = 1
>>   # umount /mnt
>>   # mount /dev/sdc /mnt               --->fs_devices->total_devices = 2
>>
>> This is because we record right @total_devices in superblock, but
>> @fs_devices->total_devices is reset to be 0 in btrfs_prepare_sprout().
>>
>> Fix this problem by not resetting @fs_devices->total_devices.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/volumes.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 6fd7fe6..19b2d32 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1883,7 +1883,6 @@ static int btrfs_prepare_sprout(struct btrfs_root
>> *root)
>>         fs_devices->seeding = 0;
>>         fs_devices->num_devices = 0;
>>         fs_devices->open_devices = 0;
>> -       fs_devices->total_devices = 0;
>>         fs_devices->seed = seed_devices;
>>
>>         generate_random_uuid(fs_devices->fsid);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
