Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59350 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731630AbeG0BGr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 21:06:47 -0400
Subject: Re: [PATCH] btrfs: introduce feature to forget a btrfs device
To: fdmanana@gmail.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180726113225.1745-1-anand.jain@oracle.com>
 <20180726113225.1745-2-anand.jain@oracle.com>
 <CAL3q7H4gNaiYtmX5qAAyvdgsNXVV5O1f1fND7XxYFavRjxx07g@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ccd8a002-fae3-c829-79d4-233cd21ea8e3@oracle.com>
Date: Fri, 27 Jul 2018 07:51:10 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4gNaiYtmX5qAAyvdgsNXVV5O1f1fND7XxYFavRjxx07g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/26/2018 11:25 PM, Filipe Manana wrote:
> On Thu, Jul 26, 2018 at 12:32 PM, Anand Jain <anand.jain@oracle.com> wrote:
>> Support for a new command 'btrfs dev forget [dev]' is proposed here,
>> to undo the effects of 'btrfs dev scan [dev]'. For this purpose,
>> this patch proposes to use ioctl #5 as it was empty.
>>          IOW(BTRFS_IOCTL_MAGIC, 5, ..)
>> This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
>> the /dev/btrfs-control to forget one or all devices, (devices which are
>> not mounted) from the btrfs kernel.
>>
>> The argument it takes is struct btrfs_ioctl_vol_args, and ::name can be
>> set to specify the device path. And all unmounted devices can be removed
>> from the kernel if no device path is provided.
>>
>> Again, the devices are removed only if the relevant fsid aren't mounted.
> 
> And why is the feature needed? What problems does it solve?
> That is missing from the changelog, no matter how obvious it is to you
> (or anyone else), it should be mentioned in the changelog.

  There are few reasons..
  . Release of unwanted btrfs_fs_devices and btrfs_devices memory if the
    device is not going to be mounted.
  . Ability to mount the device in degraded mode when one of the other
    device is corrupted (patch [1] in the ML explained this).
      [1] btrfs: handle volume split brain scenario
  . Running test cases which requires btrfs.ko-reload if the rootfs
    is btrfs.

Thanks, Anand


> Thanks.
> 
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/super.c           | 3 +++
>>   fs/btrfs/volumes.c         | 9 +++++++++
>>   fs/btrfs/volumes.h         | 1 +
>>   include/uapi/linux/btrfs.h | 2 ++
>>   4 files changed, 15 insertions(+)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 67de3c0fc85b..470a32af474e 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -2244,6 +2244,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>>                  ret = PTR_ERR_OR_ZERO(device);
>>                  mutex_unlock(&uuid_mutex);
>>                  break;
>> +       case BTRFS_IOC_FORGET_DEV:
>> +               ret = btrfs_forget_devices(vol->name);
>> +               break;
>>          case BTRFS_IOC_DEVICES_READY:
>>                  mutex_lock(&uuid_mutex);
>>                  device = btrfs_scan_one_device(vol->name, FMODE_READ,
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 8844904f9009..cd54a926141a 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1208,6 +1208,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>>          return 0;
>>   }
>>
>> +int btrfs_forget_devices(const char *path)
>> +{
>> +       mutex_lock(&uuid_mutex);
>> +       btrfs_free_stale_devices(strlen(path) ? path:NULL, NULL);
>> +       mutex_unlock(&uuid_mutex);
>> +
>> +       return 0;
>> +}
>> +
>>   /*
>>    * Look for a btrfs signature on a device. This may be called out of the mount path
>>    * and we are not allowed to call set_blocksize during the scan. The superblock
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 049619176831..1602b5faa7e7 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -405,6 +405,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>>                         fmode_t flags, void *holder);
>>   struct btrfs_device *btrfs_scan_one_device(const char *path,
>>                                             fmode_t flags, void *holder);
>> +int btrfs_forget_devices(const char *path);
>>   int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>>   void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
>>   void btrfs_assign_next_active_device(struct btrfs_device *device,
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index 5ca1d21fc4a7..b1be7f828cb4 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -836,6 +836,8 @@ enum btrfs_err_code {
>>                                     struct btrfs_ioctl_vol_args)
>>   #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>>                                     struct btrfs_ioctl_vol_args)
>> +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
>> +                                  struct btrfs_ioctl_vol_args)
>>   /* trans start and trans end are dangerous, and only for
>>    * use by applications that know how to avoid the
>>    * resulting deadlocks
>> --
>> 2.7.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
