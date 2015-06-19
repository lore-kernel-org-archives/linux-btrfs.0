Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51767 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507AbbFSFXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 01:23:30 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5J5LqNr032199
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2015 13:21:52 +0800
Subject: Re: [PATCH v9 9/9] btrfs: Use sb_want_write() to protect sysfs
 feature change.
To: <linux-btrfs@vger.kernel.org>
References: <1424048525-26274-1-git-send-email-quwenruo@cn.fujitsu.com>
 <55559689.4090305@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5583A74F.7010906@cn.fujitsu.com>
Date: Fri, 19 Jun 2015 13:23:27 +0800
MIME-Version: 1.0
In-Reply-To: <55559689.4090305@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, it's 4.2 merge windows now...

But still no new comments?

Thanks,
Qu

Qu Wenruo wrote on 2015/05/15 14:47 +0800:
> Ping.
>
> Any comments?
> Other v7 patchset is reviewed by David.
>
> But I didn't find it in 4.1 merge windows.
> Is something wrong or we are waiting for the vfs patch merged first?
>
> Thanks,
> Qu
>
> -------- Original Message  --------
> Subject: [PATCH v9 9/9] btrfs: Use sb_want_write() to protect sysfs
> feature change.
> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
> To: <linux-btrfs@vger.kernel.org>
> Date: 2015年02月16日 09:02
>
>> Just like label change, use sb_want_write() to do a correct protection.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v4:
>>    Newly introduced.
>> v5:
>>    Change to sb_want_write().
>> v6:
>>    Move sb_want_write() to the beginning of the function.
>> v7:
>>    None
>> v8:
>>    Move sb_want_write() after get fs_info.
>> v9:
>>    Fix a unpaired sb_drop_write() in error handler.
>> ---
>>   fs/btrfs/sysfs.c | 25 +++++++++++++++++--------
>>   1 file changed, 17 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>> index 7e548f7..19876ba 100644
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -121,10 +121,14 @@ static ssize_t btrfs_feature_attr_store(struct
>> kobject *kobj,
>>       if (!fs_info)
>>           return -EPERM;
>>
>> -    ret = kstrtoul(skip_spaces(buf), 0, &val);
>> +    ret = sb_want_write(fs_info->sb);
>>       if (ret)
>>           return ret;
>>
>> +    ret = kstrtoul(skip_spaces(buf), 0, &val);
>> +    if (ret)
>> +        goto out;
>> +
>>       if (fa->feature_set == FEAT_COMPAT) {
>>           set = BTRFS_FEATURE_COMPAT_SAFE_SET;
>>           clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
>> @@ -141,22 +145,25 @@ static ssize_t btrfs_feature_attr_store(struct
>> kobject *kobj,
>>       /* Nothing to do */
>>       if ((val && (features & fa->feature_bit)) ||
>>           (!val && !(features & fa->feature_bit)))
>> -        return count;
>> +        goto out;
>>
>>       if ((val && !(set & fa->feature_bit)) ||
>>           (!val && !(clear & fa->feature_bit))) {
>>           btrfs_info(fs_info,
>>               "%sabling feature %s on mounted fs is not supported.",
>>               val ? "En" : "Dis", fa->kobj_attr.attr.name);
>> -        return -EPERM;
>> +        ret = -EPERM;
>> +        goto out;
>>       }
>>
>>       btrfs_info(fs_info, "%s %s feature flag",
>>              val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
>>
>>       trans = btrfs_start_transaction(fs_info->fs_root, 0);
>> -    if (IS_ERR(trans))
>> -        return PTR_ERR(trans);
>> +    if (IS_ERR(trans)) {
>> +        ret = PTR_ERR(trans);
>> +        goto out;
>> +    }
>>
>>       spin_lock(&fs_info->super_lock);
>>       features = get_features(fs_info, fa->feature_set);
>> @@ -168,10 +175,12 @@ static ssize_t btrfs_feature_attr_store(struct
>> kobject *kobj,
>>       spin_unlock(&fs_info->super_lock);
>>
>>       ret = btrfs_commit_transaction(trans, fs_info->fs_root);
>> -    if (ret)
>> -        return ret;
>>
>> -    return count;
>> +out:
>> +    sb_drop_write(fs_info->sb);
>> +    if (!ret)
>> +        return count;
>> +    return ret;
>>   }
>>
>>   static umode_t btrfs_feature_visible(struct kobject *kobj,
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
