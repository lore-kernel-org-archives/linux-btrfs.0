Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26308 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S935068AbdCaBku (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 21:40:50 -0400
Subject: Re: [PATCH v4 2/5] btrfs: scrub: Fix RAID56 recovery race condition
To: <bo.li.liu@oracle.com>
References: <20170330063251.16872-1-quwenruo@cn.fujitsu.com>
 <20170330063251.16872-3-quwenruo@cn.fujitsu.com>
 <20170330170558.GB8963@lim.localdomain>
 <0173d7aa-d89f-0d01-4239-8178f2a97300@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <15c66b09-8313-3db8-830e-8902eb39bece@cn.fujitsu.com>
Date: Fri, 31 Mar 2017 09:40:44 +0800
MIME-Version: 1.0
In-Reply-To: <0173d7aa-d89f-0d01-4239-8178f2a97300@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/31/2017 08:25 AM, Qu Wenruo wrote:
>
>
> At 03/31/2017 01:05 AM, Liu Bo wrote:
>> On Thu, Mar 30, 2017 at 02:32:48PM +0800, Qu Wenruo wrote:
>>> When scrubbing a RAID5 which has recoverable data corruption (only one
>>> data stripe is corrupted), sometimes scrub will report more csum errors
>>> than expected. Sometimes even unrecoverable error will be reported.
>>>
>>> The problem can be easily reproduced by the following steps:
>>> 1) Create a btrfs with RAID5 data profile with 3 devs
>>> 2) Mount it with nospace_cache or space_cache=v2
>>>    To avoid extra data space usage.
>>> 3) Create a 128K file and sync the fs, unmount it
>>>    Now the 128K file lies at the beginning of the data chunk
>>> 4) Locate the physical bytenr of data chunk on dev3
>>>    Dev3 is the 1st data stripe.
>>> 5) Corrupt the first 64K of the data chunk stripe on dev3
>>> 6) Mount the fs and scrub it
>>>
>>> The correct csum error number should be 16(assuming using x86_64).
>>> Larger csum error number can be reported in a 1/3 chance.
>>> And unrecoverable error can also be reported in a 1/10 chance.
>>>
>>> The root cause of the problem is RAID5/6 recover code has race
>>> condition, due to the fact that full scrub is initiated per device.
>>>
>>> While for other mirror based profiles, each mirror is independent with
>>> each other, so race won't cause any big problem.
>>>
>>> For example:
>>>         Corrupted       |       Correct          |      Correct        |
>>> |   Scrub dev3 (D1)     |    Scrub dev2 (D2)     |    Scrub dev1(P)    |
>>> ------------------------------------------------------------------------
>>> Read out D1             |Read out D2             |Read full stripe     |
>>> Check csum              |Check csum              |Check parity         |
>>> Csum mismatch           |Csum match, continue    |Parity mismatch      |
>>> handle_errored_block    |                        |handle_errored_block |
>>>  Read out full stripe   |                        | Read out full stripe|
>>>  D1 csum error(err++)   |                        | D1 csum error(err++)|
>>>  Recover D1             |                        | Recover D1          |
>>>
>>> So D1's csum error is accounted twice, just because
>>> handle_errored_block() doesn't have enough protect, and race can happen.
>>>
>>> On even worse case, for example D1's recovery code is re-writing
>>> D1/D2/P, and P's recovery code is just reading out full stripe, then we
>>> can cause unrecoverable error.
>>>
>>> This patch will use previously introduced lock_full_stripe() and
>>> unlock_full_stripe() to protect the whole scrub_handle_errored_block()
>>> function for RAID56 recovery.
>>> So no extra csum error nor unrecoverable error.
>>>
>>> Reported-by: Goffredo Baroncelli <kreijack@libero.it>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>  fs/btrfs/scrub.c | 23 +++++++++++++++++++++++
>>>  1 file changed, 23 insertions(+)
>>>
>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>> index 5fc99a92b4ff..4bbefc96485d 100644
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -1109,6 +1109,7 @@ static int scrub_handle_errored_block(struct
>>> scrub_block *sblock_to_check)
>>>      int mirror_index;
>>>      int page_num;
>>>      int success;
>>> +    bool full_stripe_locked;
>>>      static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
>>>                        DEFAULT_RATELIMIT_BURST);
>>>
>>> @@ -1134,6 +1135,25 @@ static int scrub_handle_errored_block(struct
>>> scrub_block *sblock_to_check)
>>>      have_csum = sblock_to_check->pagev[0]->have_csum;
>>>      dev = sblock_to_check->pagev[0]->dev;
>>>
>>> +    /*
>>> +     * For RAID5/6 race can happen for different dev scrub thread.
>>> +     * For data corruption, Parity and Data thread will both try
>>> +     * to recovery the data.
>>> +     * Race can lead to double added csum error, or even unrecoverable
>>> +     * error.
>>> +     */
>>> +    ret = lock_full_stripe(fs_info, logical, &full_stripe_locked);
>>> +    if (ret < 0) {
>>> +        spin_lock(&sctx->stat_lock);
>>> +        /* Either malloc failure or bg_cache not found */
>>> +        if (ret == -ENOMEM)
>>> +            sctx->stat.malloc_errors++;
>>> +        else
>>> +            sctx->stat.uncorrectable_errors++;
>>
>> Other places in scrub_handle_errored_block() also set read_errors and
>> uncorrectable_errors, why the above is an exception?
>
> Because we didn't even read out anything, so I don't think we need to
> update read_errors here.
>
> Even uncorrectable_errors here doesn't even look good to me.
> Such -ENOENT error is unrelated to on-disk data, but runtime error which
> freed the block group cache (maybe block group itself).
>
> It is more like an assert for -ENOENT case.
>
> However we don't have good enough states for this, I use
> uncorrectable_error as fallback.
>
> It would very nice if we have more appropriate member for this case.

Please ignore this comment.

I foudn that sctx->stat treats any error prevents us from continue 
reading as "read" error.

As long as we didn't do a successful read, then "read" error should be 
increased, so in this case "read" error should also be increased.

So is "uncorrectable" errors.

I'll update them.

Thanks for pointing this out.
Qu

>
>>
>> I'm fine with putting a bool into lock_full_stripe(), but it's easier
>> to tell whether locking is successful by setting the flag after
>> locking.
>
> In fact, I prefer to make such bool internal, hidden from callers but
> only affects the behavior of lock/unlock_full_stripe().
>
> Caller should only care that lock must be paired with unlock, and block
> group must exist, and don't forget to handle error.
>
> Other than that, everything else should be handled by
> lock/unlock_full_stripe() internally, user won't need to bother.
>
> Thanks,
> Qu
>
>>
>> Thanks,
>>
>> -liubo
>>
>>> +        spin_unlock(&sctx->stat_lock);
>>> +        return ret;
>>> +    }
>>> +
>>>      if (sctx->is_dev_replace && !is_metadata && !have_csum) {
>>>          sblocks_for_recheck = NULL;
>>>          goto nodatasum_case;
>>> @@ -1468,6 +1488,9 @@ static int scrub_handle_errored_block(struct
>>> scrub_block *sblock_to_check)
>>>          kfree(sblocks_for_recheck);
>>>      }
>>>
>>> +    ret = unlock_full_stripe(fs_info, logical, full_stripe_locked);
>>> +    if (ret < 0)
>>> +        return ret;
>>>      return 0;
>>>  }
>>>
>>> --
>>> 2.12.1
>>>
>>>
>>>
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


