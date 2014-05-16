Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24141 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaEPPPV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 11:15:21 -0400
Message-ID: <53762AFC.6050102@oracle.com>
Date: Fri, 16 May 2014 23:13:00 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Shilong Wang <wangshilong1991@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO
 miss-matched with slots
References: <1400249160-23186-1-git-send-email-anand.jain@oracle.com> <CAP9B-Q=rxYAtoyKp899+8w+8u-OighEm2KRjuvKPyn3uXWWuwA@mail.gmail.com>
In-Reply-To: <CAP9B-Q=rxYAtoyKp899+8w+8u-OighEm2KRjuvKPyn3uXWWuwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16/05/14 22:40, Shilong Wang wrote:
> 2014-05-16 22:06 GMT+08:00 Anand Jain <anand.jain@oracle.com>:
>> BTRFS_IOC_FS_INFO return num_devices which does not include seed disks,
>> BTRFS_IOC_DEV_INFO fetches seed disk when probed. So in this case hits
>> the btrfs-progs bug:
>>              get_fs_info()
>>              ::
>>                      BUG_ON(ndevs >= fi_args->num_devices);
>> which is very easy to hit by using btrfs filesystem show.
>>
>> This patch will make BTRFS_IOC_DEV_INFO ioctl to provide disks only
>> of the FSID being probed (seed disks are under different FSID).
>>
>> which means when seed is still not deleted from the sprout the btrfs
>> filesystem show command will show disks them under their
>> respective FSIDs
>
> Just a quick comment:
>
> Newly created filesystem is based on existed seeding filesystem.
> Though they have different fsid, newly created filesystem devices
> should include seed devices, from seed device filesytem, they can not
> see newly created filesystem devices! No?
>
> Will the follow patch change the above behavior?

  Yes, as the dev info list does not contain the seed disk
  so is the btrfs fi show output. Do you think its better
  to show seed and sprout "disks together" ? other way is
  indicate the seed fsid against the added disk until
  seed is deleted.

Thanks. Anand

> Thanks,
> Wang
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/ioctl.c |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index ff27c08..902d279 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2584,7 +2584,8 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
>>                  s_uuid = di_args->uuid;
>>
>>          mutex_lock(&fs_devices->device_list_mutex);
>> -       dev = btrfs_find_device(root->fs_info, di_args->devid, s_uuid, NULL);
>> +       dev = btrfs_find_device(root->fs_info, di_args->devid, s_uuid,
>> +                               fs_devices->fsid);
>>
>>          if (!dev) {
>>                  ret = -ENODEV;
>> --
>> 1.7.1
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
