Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41883 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754495AbdC3DYt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 23:24:49 -0400
Subject: Re: [PATCH v3 2/5] btrfs: scrub: Fix RAID56 recovery race condition
To: <bo.li.liu@oracle.com>
References: <20170329013322.1323-1-quwenruo@cn.fujitsu.com>
 <20170329013322.1323-3-quwenruo@cn.fujitsu.com>
 <20170330005117.GB15452@lim.localdomain>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <51ccf118-fad4-26da-5a26-95c48bcf945c@cn.fujitsu.com>
Date: Thu, 30 Mar 2017 11:24:43 +0800
MIME-Version: 1.0
In-Reply-To: <20170330005117.GB15452@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/30/2017 08:51 AM, Liu Bo wrote:
> On Wed, Mar 29, 2017 at 09:33:19AM +0800, Qu Wenruo wrote:
> [...]
>>
>> Reported-by: Goffredo Baroncelli <kreijack@libero.it>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/scrub.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index ab33b9a8aac2..f92d2512f4f3 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -1129,6 +1129,17 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>>  	have_csum = sblock_to_check->pagev[0]->have_csum;
>>  	dev = sblock_to_check->pagev[0]->dev;
>>
>> +	/*
>> +	 * For RAID5/6 race can happen for different dev scrub thread.
>> +	 * For data corruption, Parity and Data thread will both try
>> +	 * to recovery the data.
>> +	 * Race can lead to double added csum error, or even unrecoverable
>> +	 * error.
>> +	 */
>> +	ret = lock_full_stripe(fs_info, logical);
>> +	if (ret < 0)
>> +		return ret;
>> +
>
> Firstly, sctx->stat needs to be set with errors before returning errors.

Right.

I'll update malloc_errors for ret == -ENOMEM case and 
uncorrectable_errors for ret == -ENOENT case.

>
> Secondly, I think the critical section starts right before re-checking the
> failed mirror, doesn't it?  If so, we could get the benefit from
> sblock_bad->page since the page->recover can tell if this is a raid56 profile so
> that we may save a searching for block group.

It's true we can save a block group search, but that's relying on 
bbio->flags.

I prefer to make lock/unlock_full_stripe() to be as independent as 
possible, so such modification is not favoured.


Although I'm looking forward better scrub structure which allow us to 
get block group cache easier.
If we can get bg_cache easier in such context, then 
lock/unlock_full_stripe() have no need to search bg_cache by themselves.

But for now, I prefer to trade a little performance for more independent 
code.

>
>>  	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
>>  		sblocks_for_recheck = NULL;
>>  		goto nodatasum_case;
>> @@ -1463,6 +1474,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>>  		kfree(sblocks_for_recheck);
>>  	}
>>
>> +	ret = unlock_full_stripe(fs_info, logical);
>> +	if (ret < 0)
>> +		return ret;
>
> Seems that the callers of scrub_handle_errored_block doesn't care about @ret.
>
> And could you please put a 'locked' flag after taking the lock succesfully?
> Otherwise every raid profile has to check block group for raid flag.

I'm OK to introduce a bool as new paramter for lock/unlock_full_stripe() 
as a shortcut to avoid bg search at unlock.

But the true fix would be scrub structure cleanup to make us accessing 
bg_cache without hassle.

Thanks for the review,
Qu

>
> Thanks,
>
> -liubo
>>  	return 0;
>>  }
>>
>> --
>> 2.12.1
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


