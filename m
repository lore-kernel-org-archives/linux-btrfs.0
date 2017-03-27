Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11872 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751510AbdC0Bhe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 21:37:34 -0400
Subject: Re: [PATCH v2 5/5] btrfs: raid56: Use bio_counter to protect scrub
To: <bo.li.liu@oracle.com>
References: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
 <20170324020027.21228-6-quwenruo@cn.fujitsu.com>
 <20170324232112.GB26987@lim.localdomain>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d721d939-6fe9-09ac-18ba-11a2a899b019@cn.fujitsu.com>
Date: Mon, 27 Mar 2017 09:37:27 +0800
MIME-Version: 1.0
In-Reply-To: <20170324232112.GB26987@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/25/2017 07:21 AM, Liu Bo wrote:
> On Fri, Mar 24, 2017 at 10:00:27AM +0800, Qu Wenruo wrote:
>> Unlike other place calling btrfs_map_block(), in raid56 scrub, we don't
>> use bio_counter to protect from race against dev replace.
>>
>> This patch will use bio_counter to protect from the beginning of calling
>> btrfs_map_sblock(), until rbio endio.
>>
>> Liu Bo <bo.li.liu@oracle.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  fs/btrfs/raid56.c | 2 ++
>>  fs/btrfs/scrub.c  | 5 +++++
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>> index 1571bf26dc07..3a083165400f 100644
>> --- a/fs/btrfs/raid56.c
>> +++ b/fs/btrfs/raid56.c
>> @@ -2642,6 +2642,7 @@ static void async_scrub_parity(struct btrfs_raid_bio *rbio)
>>
>>  void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio)
>>  {
>> +	rbio->generic_bio_cnt = 1;
>
> To keep consistent with other places, can you please do this setting when
> allocating rbio?

No problem.

>
>>  	if (!lock_stripe_add(rbio))
>>  		async_scrub_parity(rbio);
>>  }
>> @@ -2694,6 +2695,7 @@ static void async_missing_raid56(struct btrfs_raid_bio *rbio)
>>
>>  void raid56_submit_missing_rbio(struct btrfs_raid_bio *rbio)
>>  {
>> +	rbio->generic_bio_cnt = 1;
>>  	if (!lock_stripe_add(rbio))
>>  		async_missing_raid56(rbio);
>>  }
>
> Ditto.
>
>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>> index 2a5458004279..265387bf3af8 100644
>> --- a/fs/btrfs/scrub.c
>> +++ b/fs/btrfs/scrub.c
>> @@ -2379,6 +2379,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
>>  	int ret;
>>  	int i;
>>
>> +	btrfs_bio_counter_inc_blocked(fs_info);
>>  	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_GET_READ_MIRRORS, logical,
>>  			&length, &bbio, 0, 1);
>>  	if (ret || !bbio || !bbio->raid_map)
>> @@ -2423,6 +2424,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
>>  rbio_out:
>>  	bio_put(bio);
>>  bbio_out:
>> +	btrfs_bio_counter_dec(fs_info);
>>  	btrfs_put_bbio(bbio);
>>  	spin_lock(&sctx->stat_lock);
>>  	sctx->stat.malloc_errors++;
>> @@ -2966,6 +2968,8 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
>>  		goto out;
>>
>>  	length = sparity->logic_end - sparity->logic_start;
>> +
>> +	btrfs_bio_counter_inc_blocked(fs_info);
>>  	ret = btrfs_map_sblock(fs_info, BTRFS_MAP_WRITE, sparity->logic_start,
>>  			       &length, &bbio, 0, 1);
>>  	if (ret || !bbio || !bbio->raid_map)
>> @@ -2993,6 +2997,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
>>  rbio_out:
>>  	bio_put(bio);
>>  bbio_out:
>> +	btrfs_bio_counter_dec(fs_info);
>>  	btrfs_put_bbio(bbio);
>>  	bitmap_or(sparity->ebitmap, sparity->ebitmap, sparity->dbitmap,
>>  		  sparity->nsectors);
>> --
>> 2.12.1
>>
>>
>>
>
> If patch 4 and 5 are still supposed to fix the same problem, can you please
> merge them into one patch so that a future bisect could be precise?

Yes, they are still fixing the same problem, and tests have already show 
the test is working. (We found a physical machine which normal btrfs/069 
can easily trigger it)

I'll merge them into one patch in next version.

>
> And while I believe this fixes the crash described in patch 4,
> scrub_setup_recheck_block() also retrives all stripes, and if we scrub
> one device, and another device is being replaced so it could be freed
> during scrub, is it another potential race case?

Seems to be another race, and it can only be triggered when a corruption 
is detected, while current test case doesn't include such corruption 
scenario (unless using degraded mount), so we didn't encounter it yet.

Although I can fix it in next update, I'm afraid we won't have proper 
test case for it until we have good enough btrfs-corrupt-block.

Thanks,
Qu

>
> Thanks,
>
> -liubo
>
>


