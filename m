Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:29732 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbbAUIrO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Jan 2015 03:47:14 -0500
Message-ID: <54BF6783.4000603@huawei.com>
Date: Wed, 21 Jan 2015 16:46:59 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
 fs to avoid deadlock.
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>	<20150120171344.GH13289@twin.jikos.cz> <54BEF99D.7090104@cn.fujitsu.com>	<1421802329.27917.8@mail.thefacebook.com>	<54BEFC56.3000403@cn.fujitsu.com> <1421802656.27917.9@mail.thefacebook.com> <54BF189C.4070201@huawei.com> <54BF19DD.8060600@cn.fujitsu.com> <54BF1C5B.509@huawei.com> <54BF22BE.3080606@cn.fujitsu.com> <54BF4F62.3010805@huawei.com> <54BF59AA.9070408@cn.fujitsu.com>
In-Reply-To: <54BF59AA.9070408@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 21 Jan 2015 15:47:54 +0800, Qu Wenruo wrote:
>> On Wed, 21 Jan 2015 11:53:34 +0800, Qu Wenruo wrote:
>>>>> [snipped]
>>>>> This will cause another problem, nobody can ensure there will be next
>>>>> transaction and the change may
>>>>> never to written into disk.
>>>> First, the pending changes is mount option, that is in-memory data.
>>>> Second, the same problem would happen after you freeze fs.
>>> Pending changes are *not* only mount options. Feature change and label change
>>> are also pending changes if using sysfs.
>> My miss, I don't notice feature and label change by sysfs.
>>
>> But the implementation of feature and label change by sysfs is wrong, we can
>> not change them without write permission.
>>
>>> Normal ioctl label changing is not affected.
>>>
>>> For freeze, it's not the same problem since the fs will be unfreeze sooner or
>>> later and transaction will be initiated.
>> You can not assume the operations of the users, they might freeze the fs and
>> then shutdown the machine.
>>
>>>>> For example, if we change the features/label through sysfs, and then umount
>>>>> the fs,
>>>> It is different from pending change.
>>> No, now features/label changing using sysfs both use pending changes to do the
>>> commit.
>>> See BTRFS_PENDING_COMMIT bit.
>>> So freeze -> change features/label -> sync will still cause the deadlock in the
>>> same way,
>>> and you can try it yourself.
>> As I said above, the implementation of sysfs feature and label change is wrong,
>> it is better to separate them from the pending mount option change, make the
>> sysfs feature and label change be done in the context of transaction after
>> getting the write permission. If so, we needn't do anything special when sync
>> the fs.
>>
>> In short, changing the sysfs feature and label change implementation and
>> removing the unnecessary btrfs_start_transaction in sync_fs can fix the
>> deadlock.
> Your method will only fix the deadlock, but will introduce the risk like pending
> inode_cache will never
> be written to disk as I already explained. (If still using the
> fs_info->pending_changes mechanism)
> To ensure pending changes written to disk sync_fs() should start a transaction
> if needed,
> or there will be chance that no transaction can handle it.

We are sure that writting down the inode cache need transaction. But INODE_CACHE
is not a forcible flag. Sometimes though you set it, it is very likely that the
inode cache files are not created and the data is not written down because the
fs might still be reading inode usage information, and this operation might span
several transactions. So I think what you worried is not a problem.

Thanks
Miao

> 
> But I don't see the necessity to pending current work(inode_cache, feature/label
> changes) to next transaction.
> 
> To David:
> I'm a little curious about why inode_cache needs to be delayed to next transaction.
> In btrfs_remount() we have s_umount mutex, and we synced the whole filesystem
> already,
> so there should be no running transaction and we can just set any mount option
> into fs_info.
> 
> Or even in worst case, there is a racing window, we can still start a
> transaction and do the commit,
> a little overhead in such minor case won't impact the overall performance.
> 
> For sysfs change, I prefer attach or start transaction method, and for mount
> option change, and
> such sysfs tuning is also minor case for a filesystem.
> 
> What do you think about reverting the whole patchset and rework the sysfs
> interface?
> 
> Thanks,
> Qu
>>
>> Thanks
>> Miao
>>
>>> Thanks,
>>> Qu
>>>
>>>> If you want to change features/label,  you should get write permission and make
>>>> sure the fs is not be freezed because those are on-disk data. So the problem
>>>> doesn't exist, or there is a bug.
>>>>
>>>> Thanks
>>>> Miao
>>>>
>>>>> since there is no write, there is no running transaction and if we don't
>>>>> start a
>>>>> new transaction,
>>>>> it won't be flushed to disk.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>> the reason is:
>>>>>> - Make the behavior of the fs be consistent(both freezed fs and unfreezed fs)
>>>>>> - Data on the disk is right and integrated
>>>>>>
>>>>>>
>>>>>> Thanks
>>>>>> Miao
>>>>> .
>>>>>
>>> .
>>>
> 
> .
> 

