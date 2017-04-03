Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30275 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750992AbdDCAsR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Apr 2017 20:48:17 -0400
Subject: Re: [PATCH v4 1/5] btrfs: scrub: Introduce full stripe lock for
 RAID56
To: <bo.li.liu@oracle.com>
References: <20170330063251.16872-1-quwenruo@cn.fujitsu.com>
 <20170330063251.16872-2-quwenruo@cn.fujitsu.com>
 <20170330164920.GA8963@lim.localdomain>
 <07d4e7f2-875f-54e9-05b6-27f74822bee5@cn.fujitsu.com>
 <20170331173409.GA30413@lim.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <aa2a9b31-670d-4d7f-630f-85d9845d1faa@cn.fujitsu.com>
Date: Mon, 3 Apr 2017 08:48:13 +0800
MIME-Version: 1.0
In-Reply-To: <20170331173409.GA30413@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/01/2017 01:34 AM, Liu Bo wrote:
> On Fri, Mar 31, 2017 at 09:29:20AM +0800, Qu Wenruo wrote:
>>
>>
>> At 03/31/2017 12:49 AM, Liu Bo wrote:
>>> On Thu, Mar 30, 2017 at 02:32:47PM +0800, Qu Wenruo wrote:
>>>> Unlike mirror based profiles, RAID5/6 recovery needs to read out the
>>>> whole full stripe.
>>>>
>>>> And if we don't do proper protect, it can easily cause race condition.
>>>>
>>>> Introduce 2 new functions: lock_full_stripe() and unlock_full_stripe()
>>>> for RAID5/6.
>>>> Which stores a rb_tree of mutex for full stripes, so scrub callers can
>>>> use them to lock a full stripe to avoid race.
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
>>>> ---
>>>>  fs/btrfs/ctree.h       |  17 ++++
>>>>  fs/btrfs/extent-tree.c |  11 +++
>>>>  fs/btrfs/scrub.c       | 217 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 245 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>>> index 29b7fc28c607..9fe56da21fed 100644
>>>> --- a/fs/btrfs/ctree.h
>>>> +++ b/fs/btrfs/ctree.h
> [...]
>>>> +/*
>>>> + * Helper to get full stripe logical from a normal bytenr.
>>>> + *
>>>> + * Caller must ensure @cache is a RAID56 block group.
>>>> + */
>>>> +static u64 get_full_stripe_logical(struct btrfs_block_group_cache *cache,
>>>> +				   u64 bytenr)
>>>> +{
>>>> +	u64 ret;
>>>> +
>>>> +	/*
>>>> +	 * round_down() can only handle power of 2, while RAID56 full
>>>> +	 * stripe len can be 64KiB * n, so need manual round down.
>>>> +	 */
>>>> +	ret = (bytenr - cache->key.objectid) / cache->full_stripe_len *
>>>> +	      cache->full_stripe_len + cache->key.objectid;
>>>
>>> Can you please use div_u64 instead?  '/' would cause building errors.
>>
>> No problem, but I'm still curious about under which arch/compiler it would
>> cause build error?
>>
>
> Sorry, it should be div64_u64 since cache->full_stripe_len is (unsigend long).

In theory, yes we should use div64_u64.

But I strongly doubt if we can overflow u32 in full_stripe_len context.

For current fixed 64K stripe len, we need 65536 data stripes, which 
should make chunk_item larger than any node size.
IIRC years ago, we have introduced extra chunk item and super array size 
check to avoid such case.

So we should be safe to use div_u64.

Anyway, I'll add extra check before calling div, and still use div64_u64 
just in case.

Thanks for pointing this out,
Qu

>
> Building errors might not be true, it's from my memory.
> But in runtime, it could end up with 'divide error'.
>
> Thanks,
>
> -liubo
>
>> Thanks,
>> Qu
>>>
>>> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
>>>
>>> Thanks,
>>>
>>> -liubo
>>>
>>>
>>
>>
>
>


