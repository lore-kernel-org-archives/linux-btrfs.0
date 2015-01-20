Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:53074 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbATIQO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 03:16:14 -0500
Message-ID: <54BE0EC6.8060707@huawei.com>
Date: Tue, 20 Jan 2015 16:16:06 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
 fs to avoid deadlock.
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com> <20150119140640.GB13289@twin.jikos.cz> <54BDC2C8.2090509@cn.fujitsu.com> <54BDC311.1050004@cn.fujitsu.com> <54BDC643.9070801@huawei.com> <54BDC8B3.2030602@cn.fujitsu.com>
In-Reply-To: <54BDC8B3.2030602@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 20 Jan 2015 11:17:07 +0800, Qu Wenruo wrote:
>>>>>> --- a/fs/btrfs/super.c
>>>>>> +++ b/fs/btrfs/super.c
>>>>>> @@ -1000,6 +1000,14 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>>>>>>                 */
>>>>>>                if (fs_info->pending_changes == 0)
>>>>>>                    return 0;
>>>>>> +            /*
>>>>>> +             * Test if the fs is frozen, or start_trasaction
>>>>>> +             * will deadlock on itself.
>>>>>> +             */
>>>>>> +            if (__sb_start_write(sb, SB_FREEZE_FS, false))
>>>>>> +                __sb_end_write(sb, SB_FREEZE_FS);
>>>>>> +            else
>>>>>> +                return 0;
>>>>> I'm not sure this is the right fix. We should use either
>>>>> mnt_want_write_file or sb_start_write around the start/commit functions.
>>>>> The fs may be frozen already, but we also have to catch transition to
>>>>> that state, or RO remount.
>>>> But the deadlock between s_umount and frozen level is a larger problem...
>>>>
>>>> Even Miao mentioned that we can start a transaction in btrfs_freeze(), but
>>>> there is still possibility that
>>>> we try to change the feature of the frozen btrfs and do sync, again the
>>>> deadlock will happen.
>>>> Although handling in btrfs_freeze() is also needed, but can't resolve all the
>>>> problem.
>>>>
>>>> IMHO the fix is still needed, or at least as a workaround until we find a real
>>>> root solution for it
>>>> (If nobody want to revert the patchset)
>>>>
>>>> BTW, what about put the pending changes to a workqueue? If we don't start
>>>> transaction under
>>>> s_umount context like sync_fs()
>> I don't like this fix.
>> I think we should deal with those pending changes when we freeze a filesystem.
>> or we break the rule of fs freeze.
> I am afraid handling it in btrfs_freeze() won't help.
> Case like freeze() -> change_feature -> sync() -> unfreeze() will still deadlock
> in sync().

We should not change feature after the fs is freezed.

> Even cleared the pending changes in freeze(), it can still be set through sysfs
> interface even the fs is frozen.
> 
> And in fact, if we put the things like attach/create a transaction into a
> workqueue, we will not break
> the freeze rule.
> Since if the fs is frozen, there is no running transaction and we need to create
> a new one,
> that will call sb_start_intwrite(), which will sleep until the fs is unfreeze.

I read the pending change code just now, and I found the pending change is just
used for changing the mount option now, so I think as a work-around fix we
needn't start a new transaction to handle the pending flags which are set after
the current transaction is committed, because the data on the disk is
integrated.

Thanks
Miao


> 
> Thanks,
> Qu
>>
>> Thanks
>> Miao
>>
>>>> Thanks,
>>>> Qu
>>>>> Also, returning 0 is not right, the ioctl actually skipped the expected
>>>>> work.
>>>>>
>>>>>>                trans = btrfs_start_transaction(root, 0);
>>>>>>            } else {
>>>>>>                return PTR_ERR(trans);
>>> .
>>>
> 
> .
> 

