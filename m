Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FBB3803E9
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 22:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788562217; cv=none; b=J/BWSYHDz3Pf9ZW6jYcRxz/YiqNKfQ/VDk0bY/LkJ9YeEIH6dmt7OeSVVooQOUQTc4WeX6NPiBQwiXAYKDI9eEKwbBCwM4gzya38aQ2W4kSUF7X9w0KJgyjevmsTMK/4ohMB3xHpU40ynzPIZAPNXAUUeq+myQqY+qf2HsaUVCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788562217; c=relaxed/simple;
	bh=vRbjUMymsexqITmrj1kcTpPwEFPpKKz2s2RG6RQ8pis=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=R2Xr1UIR1yPVA7MehIcOsUD5c4BPAWuDfCrQ1EJi+XdlCAHSZyYRoYHyneQZ/z9QdW/YMwMSgJEyUZLR1TZZyFrBfaNLxbRGd/YYRQK2fL2EaL/iQadM3w31Qu59eENmpKwUTne/Q86CD1AMGG+xWpvaFDfuoIIyCG3D+zzZA8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y5CyuBzn; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y5CyuBzn"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49a97714f5dso13354385e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2026 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788562214; x=1789167014; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zGGp9MjsZFduK5gFatXrpyP3IeJYYzktpdDKJrnnINk=;
        b=Y5CyuBzng9Uc24VAK8A86+iBqiY+IR4Lrvq/rg4khcVrOcCjSbnMtb8TtN4Bv1TCcT
         +463Vt2H2bsV4W41oWEsgbkqmy3+9GE64M8CxYL8oCNDWaXhx8Y5eEElZWIZ5kjNWks8
         f+9ca57W+KS2cfHfztvEUnN0vRpzmXBrcHM0PUmSM46mRQIDV3Z7bIC6qNhjMUCru4y8
         A0WLgtSwZJ+vo/6Lzks9NMnVi8Y/TYx4vCxuwhVR26AgENTnbyaeumUNKnVJT0gt5eld
         JuhLt2c5pNMMUSqcejyoHclLXtpgHr36i4TKYVkgqVSCN+Me3wx+YHj2y1NumE2uDuCN
         Q5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788562214; x=1789167014;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zGGp9MjsZFduK5gFatXrpyP3IeJYYzktpdDKJrnnINk=;
        b=ixerZ+TTvQ0NS1S/7IbasH1IFecg37Q6jHWsPv1qCn7suGamIZkSG61Mzqbhd4FYa2
         FVrCt7y6zGSvTw5pugLoClLg4Rhpuy8v7vU81IO4Q2nWQ4MuPGBx8YDQsGTlTk+YbXwW
         WMzrP29aZyk4CGgecDBDccYziNeUn3B8CIMXNdb4+AMDOl+l0g7ShRCr60HJl2QGQ78/
         OerVd//mYPvnL6YNVSBs/810VQIGImoKGfK/bZBWu6ZDPKmSaIrMLKIp55F+FMizSkxf
         9nRcCYDr61vKGClTlIMfP8Dpgq99USb1r63fzsb6/RhzDwzWO3dWSgPnvSJlNVvW0laY
         3y1Q==
X-Gm-Message-State: AFuF++kXdYTjx1bF7TEI1MVBAU2jGlXiFIGN3rROtgYldF0qxzOC0PTa
	y47hpbcgtp50zaIYosNCf+XQUX5wvk0LEdhRo7+q5SL6OjyG7S+n4uSfyHm/6Q/ItqxQncpiC7c
	gtnCe7HzN/w==
X-Gm-Gg: AYBFou2OqzYO0wJJYBnCIcAXVaPOrtjrkaQ4qOx+bIv019OpIKkHbeXQb+JiW8S495V
	W0s8B5IFuG4pNBbuVVYyj/2BFdZAwCFzzvKDyseQXZdmuxjPx42R7ooSCFVRe5B+8BSyLNwfs9M
	Ehdhs4IF+1G4/jUWme824xaKjH/fQsaSSO4r0zKpNxUvTrLw1uxDhSxwFDpT42L8BUb8YnoH0Co
	uCjSa51tSgdquaeHUWWQKi8mzLpFFxQwdVG4qHHChR1enQukefLs20KbI7V/kd+OF5RAiwjyuoX
	rFV1SjQftwZA2q9nqlJZN7i6jcoC20cyKoiCsqzObiWHGcVjfcNrkvHn6XsTtHaOPa7ptJC+KIY
	kOopeT35Kr/0ALHma0f8of/UrBfay8QK4NoP+/SCr4eI8Bp7frOAePC4D2mTrNeYR4mMgQD1wRF
	RQ4AijkbVr5rAv7BrIB3yv0J8VNUmQdDd1wFKEKJ74sf9aYRiP9jis
X-Received: by 2002:a05:600c:8715:b0:49c:fa20:cc06 with SMTP id 5b1f17b1804b1-49cfe7a30demr42668645e9.29.1788562214229;
        Fri, 04 Sep 2026 15:50:14 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b06cea473sm3904884a91.2.2026.09.04.15.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 15:50:13 -0700 (PDT)
Message-ID: <91465187-a892-4b59-857b-e5f5addc0c88@suse.com>
Date: Sat, 5 Sep 2026 08:20:06 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] btrfs: use bio::remaining for async checksumming
 synchronization
From: Qu Wenruo <wqu@suse.com>
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260903062317.3928665-1-neelx@suse.com>
 <20260903062317.3928665-3-neelx@suse.com>
 <5c08f2f3-cf49-41ef-84b5-dced3ce6da90@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <5c08f2f3-cf49-41ef-84b5-dced3ce6da90@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/5 08:11, Qu Wenruo 写道:
> 
> 
> 在 2026/9/3 15:53, Daniel Vacek 写道:
>> We can use bio::remaining counter to sync the offloaded checksuming.
>> As a result we can slim down the btrfs_bio structure by 24 bytes
>> and simplify the code a bit.
>>
>> $ pahole | diff
>> -    /* size: 328, cachelines: 6, members: 15 */
>> +    /* size: 304, cachelines: 5, members: 14 */
>>
>> Moreover this will allow us enabling async checksumming with encryption
>> where we need to checksum the bounce bio instead of our regular one
>> embedded in btrfs_bio. And so we need to extend it's lifetime. This is
>> the preffered way to do so.
>>
>> Signed-off-by: Daniel Vacek <neelx@suse.com>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>> ---
>>
>> No change since v1
>> ---
>>   fs/btrfs/bio.c       | 4 ----
>>   fs/btrfs/bio.h       | 4 ----
>>   fs/btrfs/file-item.c | 6 ++----
>>   3 files changed, 2 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
>> index 19b4855969f5..771b7d598aee 100644
>> --- a/fs/btrfs/bio.c
>> +++ b/fs/btrfs/bio.c
>> @@ -103,7 +103,6 @@ static struct btrfs_bio *btrfs_split_bio(struct 
>> btrfs_fs_info *fs_info,
>>       bbio->can_use_append = orig_bbio->can_use_append;
>>       bbio->is_scrub = orig_bbio->is_scrub;
>>       bbio->is_remap = orig_bbio->is_remap;
>> -    bbio->async_csum = orig_bbio->async_csum;
>>       atomic_inc(&orig_bbio->pending_ios);
>>       return bbio;
>> @@ -114,9 +113,6 @@ void btrfs_bio_end_io(struct btrfs_bio *bbio, 
>> blk_status_t status)
>>       /* Make sure we're already in task context. */
>>       ASSERT(in_task());
>> -    if (bbio->async_csum)
>> -        wait_for_completion(&bbio->csum_done);
>> -
>>       bbio->bio.bi_status = status;
>>       if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
>>           struct btrfs_bio *orig_bbio = bbio->private;
>> diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
>> index b7bd377a0162..bbf362b8668b 100644
>> --- a/fs/btrfs/bio.h
>> +++ b/fs/btrfs/bio.h
>> @@ -58,7 +58,6 @@ struct btrfs_bio {
>>               struct btrfs_ordered_extent *ordered;
>>               struct btrfs_ordered_sum *sums;
>>               struct work_struct csum_work;
>> -            struct completion csum_done;
>>               struct bvec_iter csum_saved_iter;
>>               u64 orig_physical;
>>               u64 orig_logical;
>> @@ -93,9 +92,6 @@ struct btrfs_bio {
>>       /* Whether the bio is coming from copy_remapped_data_io(). */
>>       bool is_remap:1;
>> -    /* Whether the csum generation for data write is async. */
>> -    bool async_csum:1;
>> -
>>       /* Whether the bio is written using zone append. */
>>       bool can_use_append:1;
>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
>> index 4a7681557ec1..0fed4e0d32d5 100644
>> --- a/fs/btrfs/file-item.c
>> +++ b/fs/btrfs/file-item.c
>> @@ -818,9 +818,8 @@ static void csum_one_bio_work(struct work_struct 
>> *work)
>>       struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, 
>> csum_work);
>>       ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
>> -    ASSERT(bbio->async_csum == true);
>>       csum_one_bio(bbio);
>> -    complete(&bbio->csum_done);
>> +    bio_endio(&bbio->bio);
>>   }
>>   /*
>> @@ -854,8 +853,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, 
>> bool async)
>>           csum_one_bio(bbio);
>>           return 0;
>>       }
>> -    init_completion(&bbio->csum_done);
>> -    bbio->async_csum = true;
>> +    bio_inc_remaining(bio);
> 
> There seems to be a window where the bio can be finished before submission.
> 
> Firstly at btrfs_csum_one_bio() time, bio->bi_endio is not yet 
> initialized, it's only properly assigned at btrfs_submit_bio().
> 
> Then we queue the csum generation work.
> 
> But by some bad timing, the bio submission is delayed, we can have the 
> following sequence:
> 
>          Submission               |       Csum generation
> ---------------------------------+------------------------------------
> btrfs_submit_chunk()             |
> |- btrfs_csum_one_bio()          |
> |  |- bio_inc_remaining()        |
> |  |- schedule_work()            | csum_one_bio_work()
> |                                | |- bio_endio()
> |                                | Now the bio is finished, although
> |                                | bi_end_io is NULL, nothing real
> |                                | happened.

Damn it, I really need some tea before reviewing patches in the morning.

A bio has bi_remaining initialized to 1, so bio_inc_remaining() will 
change it to 2.

After bio_inc_remaining(), the next bio_endio() will not call 
bi_end_io(), but only decrease the bi_remaining back to 1.

So it won't call bi_end_io() in this case.

Please discard the above analysis.
> |- btrfs_submit_bio()
> 
> 
> This can be even worse, if the bio_endio() is called when 
> btrfs_submit_bio() has only partially setup the bio (e.g. bi_end_io() is 
> set, but bi_bdev is not set)
> 
> Not mention now it changed the context where the endio function is called.
> 
> Previously csum_one_bio_work() will never call bi_end_io() function, but 
> now it can.
> 
> The change has a much larger impact than I initially thought.
>>       INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>>       schedule_work(&bbio->csum_work);
>>       return 0;
> 

