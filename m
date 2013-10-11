Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:51224 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3JKJ3Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 05:29:25 -0400
Received: by mail-wg0-f54.google.com with SMTP id m15so3972499wgh.9
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 02:29:24 -0700 (PDT)
Message-ID: <5257C4C8.2010205@yerf-it.nl>
Date: Fri, 11 Oct 2013 11:28:40 +0200
From: Remco Hosman - Yerf-IT <remco@yerf-it.nl>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH] Btrfs: disallow 'btrfs {balance,replace} cancel' on ro
 mounts
References: <1381426821-31981-1-git-send-email-idryomov@gmail.com> <525750B4.4090009@cn.fujitsu.com> <5257C378.1060507@giantdisaster.de>
In-Reply-To: <5257C378.1060507@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op 11-10-2013 11:23, Stefan Behrens schreef:
> On Fri, 11 Oct 2013 09:13:24 +0800, Wang Shilong wrote:
>> On 10/11/2013 01:40 AM, Ilya Dryomov wrote:
>>
>> I have a question in my mind.
>>
>> Can we reach a state that there is operation in progress when filesystem
>> has been readonly?If we do cancel operations on a ro filesystem, we should
>> get "No operations in progress" .
> Well, it's arguable what ro means. No write to the devices at all? Or
> replay log on mount (which means to write to the filesystem), but no
> write access in addition to that? Or allow filesystem internal things to
> be modified and written to disk, like it was done when the balance or
> replace control items were modified on disk when the cancelling was
> requested?
>
> In any case, don't make it more complicated then necessary IMO, and
> return EROFS if someone calls cancel on a ro filesystem regardless of
> the state of the operation. It only adds errors to try to distuingish
> such things and is of no benefit for anybody IMHO.
>
just my 2 cents:

I once had to recover a ext3 filesystem from a device that would crash 
if you write anything beyond 2T. The problem is that there was an entry 
in the journal telling the OS to do just that. so the device would just 
crash every time out mount the filesystem. even in RO mode.

The manual speaks about a 'skip journal replay' option, but it was never 
implemented.
kernel source was something like:
case: SKIP_JOURNAL_REPLAY:
     return error;


The result: there was no way to mount the filesystem, even in RO mode. i 
endedup dd'ing the whole thing to another device, and then mounting the 
resulting image. it took a very long time!

i would expect a RO mount never to write anything to a filesystem. not 
even replay a journal (or a seperate option for that).
Its possible that the device is not writable at all, if its a snapshot 
or a RO iscsi device of some kind.

Remco

>>> For both balance and replace, cancelling involves changing the on-disk
>>> state and committing a transaction, which is not a good thing to do on
>>> read-only filesystems.
>>>
>>> Cc: Stefan Behrens <sbehrens@giantdisaster.de>
>>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>>> ---
>>>    fs/btrfs/dev-replace.c |    3 +++
>>>    fs/btrfs/volumes.c     |    3 +++
>>>    2 files changed, 6 insertions(+)
>>>
>>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>>> index 9efb94e..98df261 100644
>>> --- a/fs/btrfs/dev-replace.c
>>> +++ b/fs/btrfs/dev-replace.c
>>> @@ -650,6 +650,9 @@ static u64 __btrfs_dev_replace_cancel(struct
>>> btrfs_fs_info *fs_info)
>>>        u64 result;
>>>        int ret;
>>>    +    if (fs_info->sb->s_flags & MS_RDONLY)
>>> +        return -EROFS;
>>> +
>>>        mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
>>>        btrfs_dev_replace_lock(dev_replace);
>>>        switch (dev_replace->replace_state) {
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index a306db9..2630f38 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -3424,6 +3424,9 @@ int btrfs_pause_balance(struct btrfs_fs_info
>>> *fs_info)
>>>      int btrfs_cancel_balance(struct btrfs_fs_info *fs_info)
>>>    {
>>> +    if (fs_info->sb->s_flags & MS_RDONLY)
>>> +        return -EROFS;
>>> +
>>>        mutex_lock(&fs_info->balance_mutex);
>>>        if (!fs_info->balance_ctl) {
>>>            mutex_unlock(&fs_info->balance_mutex);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

