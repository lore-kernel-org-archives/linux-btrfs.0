Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26786 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933096AbbGHJLV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 05:11:21 -0400
Subject: Re: [PATCH] btrfs: Fix a lockdep warning when running xfstest.
To: <bo.li.liu@oracle.com>, Miao Xie <miaoxie@huawei.com>
References: <1414659151-24777-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150708090348.GA17043@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <559CE934.1080804@cn.fujitsu.com>
Date: Wed, 8 Jul 2015 17:11:16 +0800
MIME-Version: 1.0
In-Reply-To: <20150708090348.GA17043@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Liu Bo wrote on 2015/07/08 17:03 +0800:
> On Thu, Oct 30, 2014 at 04:52:31PM +0800, Qu Wenruo wrote:
>> The following lockdep warning is triggered during xfstests:
>>
>> [ 1702.980872] =========================================================
>> [ 1702.981181] [ INFO: possible irq lock inversion dependency detected ]
>> [ 1702.981482] 3.18.0-rc1 #27 Not tainted
>> [ 1702.981781] ---------------------------------------------------------
>> [ 1702.982095] kswapd0/77 just changed the state of lock:
>> [ 1702.982415]  (&delayed_node->mutex){+.+.-.}, at: [<ffffffffa03b0b51>] __btrfs_release_delayed_node+0x41/0x1f0 [btrfs]
>> [ 1702.982794] but this lock took another, RECLAIM_FS-unsafe lock in the past:
>> [ 1702.983160]  (&fs_info->dev_replace.lock){+.+.+.}
>>
>> and interrupts could create inverse lock ordering between them.
>>
>> [ 1702.984675]
>> other info that might help us debug this:
>> [ 1702.985524] Chain exists of:
>>    &delayed_node->mutex --> &found->groups_sem --> &fs_info->dev_replace.lock
>>
>> [ 1702.986799]  Possible interrupt unsafe locking scenario:
>>
>> [ 1702.987681]        CPU0                    CPU1
>> [ 1702.988137]        ----                    ----
>> [ 1702.988598]   lock(&fs_info->dev_replace.lock);
>> [ 1702.989069]                                local_irq_disable();
>> [ 1702.989534]                                lock(&delayed_node->mutex);
>> [ 1702.990038]                                lock(&found->groups_sem);
>> [ 1702.990494]   <Interrupt>
>> [ 1702.990938]     lock(&delayed_node->mutex);
>> [ 1702.991407]
>>   *** DEADLOCK ***
>>
>> It is because the btrfs_kobj_{add/rm}_device() will call memory
>> allocation with GFP_KERNEL,
>> which may flush fs page cache to free space, waiting for it self to do
>> the commit, causing the deadlock.
>
> I've seen the same one recently, but I'm not sure I understand this
> commig log correctly, do you mean that memory allocation forces kswapd
> thread to deadlock?
Yes IIRC.

> Can you elaborate upon this deadlock?

I'll check it later and try to explain, but the patch is somewhat old,
it may takes some time to recall.
But Miao Xie is the one behind the fix and may have a good explain.

Added his Cc.

Thanks,
Qu
>
> Thanks,
>
> -liubo
>>
>> To solve the problem, move btrfs_kobj_{add/rm}_device() out of the
>> dev_replace lock range, also involing split the
>> btrfs_rm_dev_replace_srcdev() function into remove and free parts.
>>
>> Now only btrfs_rm_dev_replace_remove_srcdev() is called in dev_replace
>> lock range, and kobj_{add/rm} and btrfs_rm_dev_replace_free_srcdev() are
>> called out of the lock range.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   fs/btrfs/dev-replace.c | 11 ++++++-----
>>   fs/btrfs/volumes.c     | 10 ++++++++--
>>   fs/btrfs/volumes.h     |  6 ++++--
>>   3 files changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 6f662b3..6e3e885 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -571,15 +571,11 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>   	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
>>   	fs_info->fs_devices->rw_devices++;
>>
>> -	/* replace the sysfs entry */
>> -	btrfs_kobj_rm_device(fs_info, src_device);
>> -	btrfs_kobj_add_device(fs_info, tgt_device);
>> -
>>   	btrfs_dev_replace_unlock(dev_replace);
>>
>>   	btrfs_rm_dev_replace_blocked(fs_info);
>>
>> -	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
>> +	btrfs_rm_dev_replace_remove_srcdev(fs_info, src_device);
>>
>>   	btrfs_rm_dev_replace_unblocked(fs_info);
>>
>> @@ -594,6 +590,11 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>   	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>>   	mutex_unlock(&uuid_mutex);
>>
>> +	/* replace the sysfs entry */
>> +	btrfs_kobj_rm_device(fs_info, src_device);
>> +	btrfs_kobj_add_device(fs_info, tgt_device);
>> +	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
>> +
>>   	/* write back the superblocks */
>>   	trans = btrfs_start_transaction(root, 0);
>>   	if (!IS_ERR(trans))
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index d47289c..0192051 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1800,8 +1800,8 @@ error_undo:
>>   	goto error_brelse;
>>   }
>>
>> -void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
>> -				 struct btrfs_device *srcdev)
>> +void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
>> +					struct btrfs_device *srcdev)
>>   {
>>   	struct btrfs_fs_devices *fs_devices;
>>
>> @@ -1829,6 +1829,12 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
>>
>>   	if (srcdev->bdev)
>>   		fs_devices->open_devices--;
>> +}
>> +
>> +void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
>> +				      struct btrfs_device *srcdev)
>> +{
>> +	struct btrfs_fs_devices *fs_devices = srcdev->fs_devices;
>>
>>   	call_rcu(&srcdev->rcu, free_device);
>>
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 08980fa..4cc00e6 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -448,8 +448,10 @@ void btrfs_init_devices_late(struct btrfs_fs_info *fs_info);
>>   int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
>>   int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
>>   			struct btrfs_fs_info *fs_info);
>> -void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
>> -				 struct btrfs_device *srcdev);
>> +void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_fs_info *fs_info,
>> +					struct btrfs_device *srcdev);
>> +void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
>> +				      struct btrfs_device *srcdev);
>>   void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>>   				      struct btrfs_device *tgtdev);
>>   void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
>> --
>> 2.1.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
