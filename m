Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12460 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752001AbcE0KGZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 06:06:25 -0400
Subject: Re: [PATCH v2] btrfs: Add debug warning for new block group
 reservations
To: Filipe Manana <fdmanana@kernel.org>
References: <20160526070608.10837-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H7fkgx92gBp+q0uk=Ds_OQFt=P9D1zHy+W0i2sf43X0fg@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4af52138-556d-2073-26ea-dea7a3e12449@cn.fujitsu.com>
Date: Fri, 27 May 2016 18:06:06 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7fkgx92gBp+q0uk=Ds_OQFt=P9D1zHy+W0i2sf43X0fg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Filipe Manana wrote on 2016/05/27 10:51 +0100:
> On Thu, May 26, 2016 at 8:06 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Since the we are using atomic and wait queue for block group
>> reservations and it's not controlled by lockdep, we need pay much more
>> attention to any modification to write path.
>>
>> Or it's very easy to under flow block group reservations and cause lock
>> balance.
>
> Ok, have you observed this happening in practice?

Yes, when rebasing dedupe patchset.

Git rebasing(to for-linus-4.7) without extra modification, will cause 
balance to be blocked with dedupe test case btrfs/203.

For dedupe, cow_file_range() may call dec_block_group_reserverations() 
while the data extent is not newly allocated, but reusing existing one.

So there dev_block_group_reservations() will under flow reservations.

And blocked backtrace leads to block group reservations.

With this patch, it takes much less time to fix dedupe patchset.
And I assume later modification to run_delalloc can easily cause such 
problem, so added this patch.
>
> There's nothing wrong with adding this warning, but it makes me
> curious why you do it only here, specially if you haven't experienced
> a bug. That is, there are other places (some recent others not so
> recent) where we use an atomic for waiting and waking up.
>
> Also the patch subject "btrfs: Add debug warning for new block group
> reservations" is very confusing. You meant to say something like "Add
> warning when decrementing a block group's reservations counter".

Right, I'll update it.

Thanks,
Qu

>
> thanks
>
>>
>> Add warning on for dec_block_group_reservations() if the reservations is
>> already minus.
>>
>> Although such warning doesn't always catch the directly caller, but should
>> provides good enough clue for later debug.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2:
>>    Fix compile error
>>    Change to WARN_ON_ONCE(), as when it underflows, it will always under
>>    flow
>> ---
>>  fs/btrfs/extent-tree.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 9424864..47ce96b 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -6243,6 +6243,7 @@ void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
>>         ASSERT(bg);
>>         if (atomic_dec_and_test(&bg->reservations))
>>                 wake_up_atomic_t(&bg->reservations);
>> +       WARN_ON_ONCE(atomic_read(&bg->reservations) < 0);
>>         btrfs_put_block_group(bg);
>>  }
>>
>> --
>> 2.8.3
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


