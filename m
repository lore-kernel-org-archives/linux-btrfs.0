Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61605 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab3DOC5A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Apr 2013 22:57:00 -0400
Message-ID: <516B6CC6.3050705@cn.fujitsu.com>
Date: Mon, 15 Apr 2013 10:58:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>, Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 2/2] Btrfs: introduce noextiref mount option
References: <51669144.20107@cn.fujitsu.com> <516691F0.4080204@cn.fujitsu.com> <5166C8DC.8030105@jan-o-sch.net> <516789E3.6070309@cn.fujitsu.com> <5167B18A.3000308@jan-o-sch.net>
In-Reply-To: <5167B18A.3000308@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12 Apr 2013 09:02:34 +0200, Jan Schmidt wrote:
>>>> +static int btrfs_close_extend_iref(struct btrfs_fs_info *fs_info,
>>>> +				   unsigned long old_opts)
>>>
>>> The name irritated me, it's more like "unset" instead of "close", isn't it?
>>
>> Maybe "btrfs_set_no_extend_iref()" is better, the other developers might think
>> we will clear BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF.
> 
> I think we should use the exact name of the mount option, so
> btrfs_set_noextiref is probably least ambiguous. Or even
> btrfs_set_mntflag_noextiref.

Much better than mine.

>>>
>>>> +{
>>>> +	struct btrfs_trans_handle *trans;
>>>> +	int ret;
>>>> +
>>>> +	if (btrfs_raw_test_opt(old_opts, NOEXTIREF) ||
>>>> +	    !btrfs_raw_test_opt(fs_info->mount_opt, NOEXTIREF))
>>>> +		return 0;
>>>> +
>>>> +	trans = btrfs_attach_transaction(fs_info->tree_root);
>>>> +	if (IS_ERR(trans)) {
>>>> +		if (PTR_ERR(trans) != -ENOENT)
>>>> +			return PTR_ERR(trans);
>>>> +	} else {
>>>> +		ret = btrfs_commit_transaction(trans, fs_info->tree_root);
>>>> +		if (ret)
>>>> +			return ret;
>>>> +	}
>>>
>>> Huh? I don't see why we need to commit the transaction here. Can you please explain?
>>
>> We need avoid the case that we check incompat flag is set or not between the
>> extended iref insertion and incompat flag set.
>> 	Task1			Task2
>> 				start_transaction()
>> 				insert extended iref
>> 	set NOEXTIREF
>> 	check incompat flag
>> 				set incompat flag
>>
>> checking incompat flag after transaction commit can make sure our check happens
>> after the flag is set.
> 
> Understood.
> 
> However, in my understanding of transaction.c, btrfs_join_transaction,
> btrfs_attach_transaction and btrfs_commit_transaction are special and need
> justification. If you only need the transaction for synchronization purposes,
> which seems to be the case here, btrfs_start_transaction and
> btrfs_end_transaction are the right choice.

btrfs_end_transaction() does not wait for/force the other tasks to end their
transaction, so it is not right here.

Thanks
Miao 

> 
> Thanks,
> -Jan
> 
>> Thanks
>> Miao
>>
>>>
>>> Thanks,
>>> -Jan
>>>
>>>> +
>>>> +	if (btrfs_super_incompat_flags(fs_info->super_copy) &
>>>> +	    BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF) {
>>>> +		printk(KERN_ERR "BTRFS: could not close extend iref.\n");
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static inline void btrfs_remount_prepare(struct btrfs_fs_info *fs_info)
>>>>  {
>>>>  	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
>>>> @@ -1259,6 +1293,11 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
>>>>  	}
>>>>  
>>>>  	btrfs_remount_begin(fs_info, old_opts, *flags);
>>>> +
>>>> +	ret = btrfs_close_extend_iref(fs_info, old_opts);
>>>> +	if (ret)
>>>> +		goto restore;
>>>> +
>>>>  	btrfs_resize_thread_pool(fs_info,
>>>>  		fs_info->thread_pool_size, old_thread_pool_size);
>>>>  
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 

