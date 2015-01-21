Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11007 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338AbbAUDxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 22:53:37 -0500
Message-ID: <54BF22BE.3080606@cn.fujitsu.com>
Date: Wed, 21 Jan 2015 11:53:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Miao Xie <miaoxie@huawei.com>, Chris Mason <clm@fb.com>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
 fs to avoid deadlock.
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>	<20150120171344.GH13289@twin.jikos.cz> <54BEF99D.7090104@cn.fujitsu.com>	<1421802329.27917.8@mail.thefacebook.com>	<54BEFC56.3000403@cn.fujitsu.com> <1421802656.27917.9@mail.thefacebook.com> <54BF189C.4070201@huawei.com> <54BF19DD.8060600@cn.fujitsu.com> <54BF1C5B.509@huawei.com>
In-Reply-To: <54BF1C5B.509@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on 
frozen fs to avoid deadlock.
From: Miao Xie <miaoxie@huawei.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>
Date: 2015年01月21日 11:26
> On Wed, 21 Jan 2015 11:15:41 +0800, Qu Wenruo wrote:
>> -------- Original Message --------
>> Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen fs to
>> avoid deadlock.
>> From: Miao Xie <miaoxie@huawei.com>
>> To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date: 2015年01月21日 11:10
>>> On Tue, 20 Jan 2015 20:10:56 -0500, Chris Mason wrote:
>>>> On Tue, Jan 20, 2015 at 8:09 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>>> -------- Original Message --------
>>>>> Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen fs
>>>>> to avoid deadlock.
>>>>> From: Chris Mason <clm@fb.com>
>>>>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>> Date: 2015年01月21日 09:05
>>>>>> On Tue, Jan 20, 2015 at 7:58 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>>>>> -------- Original Message --------
>>>>>>> Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen
>>>>>>> fs to avoid deadlock.
>>>>>>> From: David Sterba <dsterba@suse.cz>
>>>>>>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>>>> Date: 2015年01月21日 01:13
>>>>>>>> On Mon, Jan 19, 2015 at 03:42:41PM +0800, Qu Wenruo wrote:
>>>>>>>>> --- a/fs/btrfs/super.c
>>>>>>>>> +++ b/fs/btrfs/super.c
>>>>>>>>> @@ -1000,6 +1000,14 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>>>>>>>>>                  */
>>>>>>>>>                 if (fs_info->pending_changes == 0)
>>>>>>>>>                     return 0;
>>>>>>>>> +            /*
>>>>>>>>> +             * Test if the fs is frozen, or start_trasaction
>>>>>>>>> +             * will deadlock on itself.
>>>>>>>>> +             */
>>>>>>>>> +            if (__sb_start_write(sb, SB_FREEZE_FS, false))
>>>>>>>>> +                __sb_end_write(sb, SB_FREEZE_FS);
>>>>>>>>> +            else
>>>>>>>>> +                return 0;
>>>>>> But what if someone freezes the FS after __sb_end_write() and before
>>>>>> btrfs_start_transaction()?   I don't see what keeps new freezers from
>>>>>> coming in.
>>>>>>
>>>>>> -chris
>>>>> Either VFS::freeze_super() and VFS::syncfs() will hold the s_umount mutex, so
>>>>> freeze will not happen
>>>>> during sync.
>>>> You're right.  I was worried about the sync ioctl, but the mutex won't be held
>>>> there to deadlock against.  We'll be fine.
>>> There is another problem which is introduced by pending change. That is we will
>>> start and commmit a transaction by changing pending mount option after we set
>>> the fs to be R/O.
>> Oh, I missed this problem.
>>> I think it is better that we don't start a new transaction for pending changes
>>> which are set after the transaction is committed, just make them be handled by
>>> the next transaction,
>> This will cause another problem, nobody can ensure there will be next
>> transaction and the change may
>> never to written into disk.
> First, the pending changes is mount option, that is in-memory data.
> Second, the same problem would happen after you freeze fs.
Pending changes are *not* only mount options. Feature change and label 
change are also pending changes if using sysfs.
Normal ioctl label changing is not affected.

For freeze, it's not the same problem since the fs will be unfreeze 
sooner or later and transaction will be initiated.
>
>> For example, if we change the features/label through sysfs, and then umount the fs,
> It is different from pending change.
No, now features/label changing using sysfs both use pending changes to 
do the commit.
See BTRFS_PENDING_COMMIT bit.
So freeze -> change features/label -> sync will still cause the deadlock 
in the same way,
and you can try it yourself.

Thanks,
Qu

> If you want to change features/label,  you should get write permission and make
> sure the fs is not be freezed because those are on-disk data. So the problem
> doesn't exist, or there is a bug.
>
> Thanks
> Miao
>
>> since there is no write, there is no running transaction and if we don't start a
>> new transaction,
>> it won't be flushed to disk.
>>
>> Thanks,
>> Qu
>>> the reason is:
>>> - Make the behavior of the fs be consistent(both freezed fs and unfreezed fs)
>>> - Data on the disk is right and integrated
>>>
>>>
>>> Thanks
>>> Miao
>> .
>>

