Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:36237 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbbJIGld (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Oct 2015 02:41:33 -0400
Received: by ioii196 with SMTP id i196so81723765ioi.3
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2015 23:41:33 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5617545C.2080303@cn.fujitsu.com>
References: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
	<5617445F.7030203@fb.com>
	<5617545C.2080303@cn.fujitsu.com>
Date: Fri, 9 Oct 2015 07:41:32 +0100
Message-ID: <CAL3q7H5HVA9osJ-rLmCas1SVDJbBWS=LvOoJHk8vHtf46HCvTQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/23] Rework btrfs qgroup reserved space framework
From: Filipe Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 9, 2015 at 6:45 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Josef Bacik wrote on 2015/10/08 21:36 -0700:
>>
>> On 10/08/2015 07:11 PM, Qu Wenruo wrote:
>>>
>>> In previous rework of qgroup, we succeeded in fixing qgroup accounting
>>> part, making the rfer/excl numbers accurate.
>>>
>>> But that's just part of qgroup work, another part of qgroup still has
>>> quite a lot problem, that's qgroup reserve space part which will lead to
>>> EQUOT even we are far from the limit.
>>>
>>> [[BUG]]
>>> The easiest way to trigger the bug is,
>>> 1) Enable quota
>>> 2) Limit excl of qgroup 5 to 16M
>>> 3) Write [0,2M) of a file inside subvol 5 10 times without sync
>>>
>>> EQUOT will be triggered at about the 8th write.
>>> But after remount, we can still write until about 15M.
>>>
>>> [[CAUSE]]
>>> The problem is caused by the fact that qgroup will reserve space even
>>> the data space is already reserved.
>>>
>>> In above reproducer, each time we buffered write [0,2M) qgroup will
>>> reserve 2M space, but in fact, at the 1st time, we have already reserved
>>> 2M and from then on, we don't need to reserved any data space as we are
>>> only writing [0,2M).
>>>
>>> Also, the reserved space will only be freed *ONCE* when its backref is
>>> run at commit_transaction() time.
>>>
>>> That's causing the reserved space leaking.
>>>
>>> [[FIX]]
>>> The fix is not a simple one, as currently btrfs_qgroup_reserve() will
>>> allocate whatever caller asked for.
>>>
>>> So for accurate qgroup reserve, we introduce a completely new framework
>>> for data and metadata.
>>> 1) Per-inode data reserve map
>>>     Now, each inode will have a data reserve map, recording which range
>>>     of data is already reserved.
>>>     If we are writing a range which is already reserved, we won't need to
>>>     reserve space again.
>>>
>>>     Also, for the fact that qgroup is only accounted at commit_trans(),
>>>     for data commit into disc and its metadata is also inserted into
>>>     current tree, we should free the data reserved range, but still keep
>>>     the reserved space until commit_trans().
>>>
>>>     So delayed_ref_head will have new members to record how much space is
>>>     reserved and free them at commit_trans() time.
>>
>>
>> This is already handled by setting DELALLOC in the io_tree, we do
>> similar sort of stuff for the normal enospc accounting, why not use
>> that?  Thanks,
>>
>> Josef
>
>
> Thanks for pointing this out.
>
> I was also searching for a existing facility, but didn't find one as I'm not
> familiar with io_tree.
>
> After a quick glance, it seems quite fit the need, but not completely sure.
>
> I'll keep investigating on it and try to use it.
>
> BTW, from what I understand, __btrfs_buffered_write() should cause the range
> to be DEALLOC, but I didn't find any call to set_extent_delalloc(),
> it that done in other place?

__btrfs_buffered_write() -> btrfs_dirty_pages() -> btrfs_set_extent_delalloc()

>
> Thanks,
> Qu
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
