Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28899 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbaENI22 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 04:28:28 -0400
Message-ID: <537329B9.6010605@oracle.com>
Date: Wed, 14 May 2014 16:30:49 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3 RFC] btrfs: total_devices should count replacing devices
References: <1394207319-13252-1-git-send-email-Anand.Jain@oracle.com> <1394207319-13252-2-git-send-email-Anand.Jain@oracle.com> <5371E346.3000704@cn.fujitsu.com>
In-Reply-To: <5371E346.3000704@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello Wang,

  sure will do. Thanks for the comments.

Anand

On 13/05/14 17:17, Wang Shilong wrote:
> Hello Anand,
>
> I agree we can export @total_devices to fix 'btrfs file show' problem.
> This patch addressed two problem, it is better to split it into two
> patches.
>
> Could you please resend the patch, at least we should fix 'btrfs file show'
> problem firstly.
>
> Thanks,
> Wang
>
> On 03/07/2014 11:48 PM, Anand Jain wrote:
>> ioctl(BTRFS_IOC_FS_INFO) returns num_devices which does not
>> count seed device. num_devices is used to calculate
>> the number of slots during the ioctl(BTRFS_IOC_DEV_INFO)
>> but ioctl(BTRFS_IOC_DEV_INFO) would count seed devices as well.
>> Due to this miss match btrfs_progs get_fs_info() hits the bug..
>>              get_fs_info()
>>              ::
>>                      BUG_ON(ndevs >= fi_args->num_devices);
>>
>> what I notice is total_devices should be returned by the
>> ioctl(BTRFS_IOC_FS_INFO)), however total_devices does not
>> count (transient) replacing device but num_devices does.
>>
>> first, num_devices which appears to be a subset of
>> total_devices helps to count the number of devices
>> under a FSID which excludes the seed devices but
>> includes the transient replacing device.
>>
>> total_devices which includes seed devices is as of
>> now does not count the tansient replacing device,
>> which IMO is a bug or the implementation details
>> are not clear enough to state the role of num_devices
>> and total_devices.
>>
>> The user land on the otherhand would want to know
>> all the devices that would come out of probe
>> against a FSID
>>
>> As of now in this patch I am making the ioctl.c local
>> changes (instead of asking replace thread to update
>> total_devices) to  include replacing device.
>>
>> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
>> ---
>>   fs/btrfs/ioctl.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 5036f9d..ec7d5c6 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2510,6 +2510,7 @@ static long btrfs_ioctl_fs_info(struct
>> btrfs_root *root, void __user *arg)
>>       struct btrfs_device *next;
>>       struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
>>       int ret = 0;
>> +    int dev_replace_running = 0;
>>       if (!capable(CAP_SYS_ADMIN))
>>           return -EPERM;
>> @@ -2518,8 +2519,18 @@ static long btrfs_ioctl_fs_info(struct
>> btrfs_root *root, void __user *arg)
>>       if (!fi_args)
>>           return -ENOMEM;
>> +    btrfs_dev_replace_lock(&root->fs_info->dev_replace);
>> +    if (btrfs_dev_replace_is_ongoing(&root->fs_info->dev_replace))
>> +        dev_replace_running = 1;
>> +
>> +    btrfs_dev_replace_unlock(&root->fs_info->dev_replace);
>> +
>>       mutex_lock(&fs_devices->device_list_mutex);
>> -    fi_args->num_devices = fs_devices->num_devices;
>> +    if (dev_replace_running)
>> +        fi_args->num_devices = fs_devices->total_devices + 1;
>> +    else
>> +        fi_args->num_devices = fs_devices->total_devices;
>> +
>>       memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));
>>       list_for_each_entry_safe(device, next, &fs_devices->devices,
>> dev_list) {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
