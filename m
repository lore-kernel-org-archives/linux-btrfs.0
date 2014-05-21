Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49589 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751648AbaEUEP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 00:15:27 -0400
Message-ID: <537C285F.7080101@cn.fujitsu.com>
Date: Wed, 21 May 2014 12:15:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] btrfs: Add missing device check in dev_info/rm_dev
 ioctl
References: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com> <1399357993-9254-2-git-send-email-quwenruo@cn.fujitsu.com> <5369E818.7000606@oracle.com> <537C19B9.8080203@cn.fujitsu.com> <537C235F.5030303@oracle.com>
In-Reply-To: <537C235F.5030303@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC PATCH 1/2] btrfs: Add missing device check in 
dev_info/rm_dev ioctl
From: Anand Jain <Anand.Jain@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年05月21日 11:54
>
> Hi Qu,
>
>  Thanks for checking with me. sorry for the delay. The
>  preliminary RFC patch which was sent and mentioned in
>  the other emails took time more than expected.
>
Thanks for the commenting, it seems that my RFC patches can only deal with
btrfs fi show but not sysfs things.
>  Further on top of your check_missing patch I am writing
>  code to to handle disk reappear. I should be sending them
>  all soon.
Disk reappear problem is also reproduce here.

I am intersting about how will your patch to deal with.
Is your patch going to check super genertion to determing previously 
missing device and
wipe reappeared superblock?(Wang mentioned it in the mail in Jan.)

IMO the reappear disk problem can also be resolved by not swap 
tgtdev->uuid and srcdev->uuid,
which means tgtdev will not use the same uuid of srcdev.

Thanks,
Qu
>
> Thanks, Anand
>

>
> On 21/05/14 11:12, Qu Wenruo wrote:
>>
>> I'm sorry to bother your but it has been about 2 weeks after your last
>> reply.
>>
>> Is there any problem?
>>
>> Thanks,
>> Qu
>> -------- Original Message --------
>> Subject: Re: [RFC PATCH 1/2] btrfs: Add missing device check in
>> dev_info/rm_dev ioctl
>> From: Anand Jain <Anand.Jain@oracle.com>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date: 2014年05月07日 16:00
>>>
>>>
>>> Thanks for working on this.
>>> I am running some tests will let you know.
>>>
>>> Anand
>>>
>>>
>>> On 05/06/2014 02:33 PM, Qu Wenruo wrote:
>>>> Old btrfs can't find a missing btrfs device since there is no
>>>> mechanism for block layer to inform fs layer.
>>>>
>>>> But we can use a workaround that only check status(by using
>>>> request_queue->queue_flags) of every device in a btrfs
>>>> filesystem when calling dev_info/rm_dev ioctl, since other ioctls
>>>> do not really cares about missing device.
>>>>
>>>> Cc: Anand Jain <Anand.Jain@oracle.com>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>>   fs/btrfs/ioctl.c   |  1 +
>>>>   fs/btrfs/volumes.c | 25 ++++++++++++++++++++++++-
>>>>   fs/btrfs/volumes.h |  2 ++
>>>>   3 files changed, 27 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>>> index 0401397..7680a40 100644
>>>> --- a/fs/btrfs/ioctl.c
>>>> +++ b/fs/btrfs/ioctl.c
>>>> @@ -2606,6 +2606,7 @@ static long btrfs_ioctl_dev_info(struct
>>>> btrfs_root *root, void __user *arg)
>>>>           goto out;
>>>>       }
>>>>
>>>> +    btrfs_check_dev_missing(root, dev, 1);
>>>>       di_args->devid = dev->devid;
>>>>       di_args->bytes_used = dev->bytes_used;
>>>>       di_args->total_bytes = dev->total_bytes;
>>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>>> index d241130a..c7d7908 100644
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -1548,9 +1548,10 @@ int btrfs_rm_device(struct btrfs_root *root,
>>>> char *device_path)
>>>>            * is held.
>>>>            */
>>>>           list_for_each_entry(tmp, devices, dev_list) {
>>>> +            btrfs_check_dev_missing(root, tmp, 0);
>>>>               if (tmp->in_fs_metadata &&
>>>>                   !tmp->is_tgtdev_for_dev_replace &&
>>>> -                !tmp->bdev) {
>>>> +                (!tmp->bdev || tmp->missing)) {
>>>>                   device = tmp;
>>>>                   break;
>>>>               }
>>>> @@ -6300,3 +6301,25 @@ int btrfs_scratch_superblock(struct
>>>> btrfs_device *device)
>>>>
>>>>       return 0;
>>>>   }
>>>> +
>>>> +/* If need_lock is set, uuid_mutex will be used */
>>>> +int btrfs_check_dev_missing(struct btrfs_root *root, struct
>>>> btrfs_device *dev,
>>>> +                int need_lock)
>>>> +{
>>>> +    struct request_queue *q;
>>>> +
>>>> +    if (unlikely(!dev || !dev->bdev || !dev->bdev->bd_queue))
>>>> +        return -ENOENT;
>>>> +    q = dev->bdev->bd_queue;
>>>> +
>>>> +    if (need_lock)
>>>> +        mutex_lock(&uuid_mutex);
>>>> +    if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
>>>> +        test_bit(QUEUE_FLAG_DYING, &q->queue_flags)) {
>>>> +        dev->missing = 1;
>>>> + root->fs_info->fs_devices->missing_devices++;
>>>> +    }
>>>> +    if (need_lock)
>>>> +        mutex_unlock(&uuid_mutex);
>>>> +    return 0;
>>>> +}
>>>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>>>> index 80754f9..47a44af 100644
>>>> --- a/fs/btrfs/volumes.h
>>>> +++ b/fs/btrfs/volumes.h
>>>> @@ -356,6 +356,8 @@ unsigned long btrfs_full_stripe_len(struct
>>>> btrfs_root *root,
>>>>   int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>>>>                   struct btrfs_root *extent_root,
>>>>                   u64 chunk_offset, u64 chunk_size);
>>>> +int btrfs_check_dev_missing(struct btrfs_root *root, struct
>>>> btrfs_device *dev,
>>>> +                int need_lock);
>>>>   static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
>>>>                         int index)
>>>>   {
>>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html

