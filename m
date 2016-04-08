Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20165 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbcDHD7N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Apr 2016 23:59:13 -0400
Subject: Re: [PATCH 10/13] btrfs: introduce helper functions to perform hot
 replace
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
 <1459560651-14809-11-git-send-email-anand.jain@oracle.com>
 <20160407200024.GA12278@jeknote.loshitsa1.net>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57072C79.6010904@oracle.com>
Date: Fri, 8 Apr 2016 11:58:49 +0800
MIME-Version: 1.0
In-Reply-To: <20160407200024.GA12278@jeknote.loshitsa1.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/08/2016 04:00 AM, Yauhen Kharuzhy wrote:
> On Sat, Apr 02, 2016 at 09:30:48AM +0800, Anand Jain wrote:
>> Hot replace / auto replace is important volume manager feature
>> and is critical to the data center operations, so that the degraded
>> volume can be brought back to a healthy state at the earliest and
>> without manual intervention.
>>
>> This modifies the existing replace code to suite the need of auto
>> replace, in the long run I hope both the codes to be merged.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>> ---
>>   fs/btrfs/dev-replace.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/dev-replace.h |  1 +
>>   2 files changed, 44 insertions(+)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 2b926867d136..ceab4c51db32 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -957,3 +957,46 @@ void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
>>   				     &fs_info->fs_state));
>>   	}
>>   }
>> +
>> +int btrfs_auto_replace_start(struct btrfs_root *root,
>> +				struct btrfs_device *src_device)
>> +{
>> +	int ret;
>> +	char *tgt_path;
>> +	char *src_path;
>> +	struct btrfs_fs_info *fs_info = root->fs_info;
>> +
>> +	if (fs_info->sb->s_flags & MS_RDONLY)
>> +		return -EROFS;
>> +
>> +	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
>> +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
>> +		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
>> +		return -EBUSY;
>> +	}
>> +	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
>> +
>> +	if (btrfs_get_spare_device(&tgt_path)) {
>> +		btrfs_err(root->fs_info,
>> +			"No spare device found/configured in the kernel");
>> +		return -EINVAL;
>> +	}
>> +
>> +	rcu_read_lock();
>> +	src_path = kstrdup(rcu_str_deref(src_device->name), GFP_ATOMIC);
>> +	rcu_read_unlock();
>> +	if (!src_path) {
>
> btrfs_put_spare_device(tgt_path) is needed here to put spare device
> back in list.

  Right. Got that changed locally. Thanks.

Anand

>> +		kfree(tgt_path);
>> +		return -ENOMEM;
>> +	}
>> +	ret = btrfs_dev_replace_start(root, tgt_path,
>> +					src_device->devid, src_path,
>> +		BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID);
>> +	if (ret)
>> +		btrfs_put_spare_device(tgt_path);
>> +
>> +	kfree(tgt_path);
>> +	kfree(src_path);
>> +
>> +	return 0;
>> +}
>> diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
>> index e922b42d91df..b918b9d6e5df 100644
>> --- a/fs/btrfs/dev-replace.h
>> +++ b/fs/btrfs/dev-replace.h
>> @@ -46,4 +46,5 @@ static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
>>   {
>>   	atomic64_inc(stat_value);
>>   }
>> +int btrfs_auto_replace_start(struct btrfs_root *root, struct btrfs_device *src_device);
>>   #endif
>> --
>> 2.7.0
>
