Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C790F412C04
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Sep 2026 22:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788387627; cv=none; b=u4nmAWCWesNk+4nZGfF2/JrEOcuBxwf7BaF5kaNg22+vs594zKWSC8GVvjSoZ8mhfJbmzGvxL27itwcb0ANEtTqf10xrE46GFIIfWaN/yb5OPtJNBVBUl3I/83cMelIaS88awbr52A1LWoV9vvYCq12SNkGiaAbtmEepy3zRmHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788387627; c=relaxed/simple;
	bh=/C5ZwwcZDfKm6vqVr6NZjcpRrsJ/gd5orG3+Q9GIVyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ud9YL34cxN7Y3Lph9UP6tce1RirgQ89sQC1uvwELoxV7xnme2EWbgMoE8aBvXD/nDkO+ljNpVCrurAGGXdVNzWxoZx1lfb+kTDwPgetSfFoVxr1thmGABSf0kSnguf0hslXGx9/hZXePV+U23QgD9bSI/4b/4ZRP+XFBiqBH5II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GcBk1diC; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GcBk1diC"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so15388415e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2026 15:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788387621; x=1788992421; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5nU1P0PllgaqOdRVPyNJj2lA89FbCNDthmut5RZLbvw=;
        b=GcBk1diCUV3ZacY2fAVjoshafVWdxErPYBsakH5l+BWmatVvYabkMIE6p5ga2kEsU+
         +o3kFAiZHI0YDOPjcVQB9HfcPI7+SZZnzngmuCcsCGzaOVcew6/hK0Yi2KsXkHnlkHWO
         MFhunIMEAOHKrpo0s6BXtClzlU6CEOUUiapkrKBymDJ3i2mHyjEhmPvs38x9HB4HUfOb
         aOC6CGCc4roopn/+oq/emCmJNmbNoKKs/Pv2g0BimGH5Jp/QK+l89KqO2/YVH5MkoghB
         T9R+uZklX+ELSyHfFJus/Oqu5eutJBtEbPkBh73h1frdnGQcT2buONcuZ5iiopOOT0dA
         Jd0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788387621; x=1788992421;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5nU1P0PllgaqOdRVPyNJj2lA89FbCNDthmut5RZLbvw=;
        b=IWBltB70GWhvR5IVWBiQLOMKnHQOZNsN38LQUe8Y/NWPhzzNiwjlk57lZpellrYQZS
         XoGElUoje9a0eoM8/5xySmE+8ynCDu8ajl3ibezB+VG03uEU5t8qF7ENKjUpTx4jQ3kl
         q7R23PFYX90HgYnSNCL3bb4wnNf9oAcmS7w6WZKhFIWHDaQ47t82k9N9h8LF34841n4L
         o0HWvUwOzfw3BrsdpbLrCGKt13M7TvX/MYtOwuPDoqHlueI3vEjx8epzPuCZ5imPti85
         Zusr6UQfOK583p6zN4Loelj8HUtG2RBUkB2vugGEIwQ50zkRxbELomL874VmtXbM+ZiD
         WBLg==
X-Gm-Message-State: AFuF++nLrS7P1ZtMQ6J8QjTHXYXFJ8v6a69PUWjsU5YHxmbHu3KXx0kR
	OSw+342q5SI6KejwelLhxlfz3QLLs3fpEeptC9qQKVa9QYTwjy5kgZfIq51h4boqrW0=
X-Gm-Gg: AYBFou3IjP+hnxxE13fwKKvPfN95uAWrF79k3zhTUog4TUqCNbjZgVkJ/MCNtqzPwD/
	G7m59kf31lNo+clH6yWQzwQkUoXalzpv1coR3nn+fduTIs+cnQVvKwog0Acu2kyVPk1HHLlhUzO
	Loo7bwSIJ7S3osRQjmuW2tEIOClJ41RdKLlncNr9zO3GY+5OMUMcEOxVTuEps/pGRufzMFkSh6D
	rDHWcfv0wioh80rY0Z8k/iUHJ+vfPQIo3zzP/i3+0o1lK1KBYROgO4RrjhTdglEeyP0mrdIXP/V
	zNTxtNr8Og4JWy41+G6ojo3FtqiKk27AQA6Iu+/ZTTnEoioJ2UrPiYb71xGOIu7f1B9FKMeVpwS
	iGAyO8+ZmonySe5Ri2YDsHiRgbSMDm0bgeD050BEyU+5bIHdE/4nPmY72n3UmKUOc8SNmtFMZKP
	cR692rcc5c+li95NZ/prkLAUCGgdog9dp2naNFeLxxD3MUoG/VonoE
X-Received: by 2002:a05:600c:a086:b0:495:48d7:f178 with SMTP id 5b1f17b1804b1-49ce5815dddmr155922185e9.11.1788387620809;
        Wed, 02 Sep 2026 15:20:20 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae9065483sm1960455a91.4.2026.09.02.15.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 15:20:19 -0700 (PDT)
Message-ID: <4aa4fd04-e009-4585-bf65-9c628e3923d5@suse.com>
Date: Thu, 3 Sep 2026 07:50:13 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs: use bio::remaining for async checksumming
 synchronization
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Daniel Vacek <neelx@suse.com>,
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260902165137.3781696-1-neelx@suse.com>
 <20260902165137.3781696-3-neelx@suse.com>
 <b54b679d-18c7-492e-a4fa-ce797c0748fa@gmx.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
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
In-Reply-To: <b54b679d-18c7-492e-a4fa-ce797c0748fa@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/3 07:32, Qu Wenruo 写道:
> 
> 
> 在 2026/9/3 02:21, Daniel Vacek 写道:
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
> 
> But what if there is still a running csum calculation at this stage?
> 
> Without waiting for the completion, we are going to get incorrect csums.

Forget this. We no longer need to wait because we won't even reach the 
bio->bi_end_io() until all remaining works (including the csum 
calculation and mirrored writes) finished.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> 
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
>> index 5a5cffb18922..50dcd448d936 100644
>> --- a/fs/btrfs/file-item.c
>> +++ b/fs/btrfs/file-item.c
>> @@ -817,9 +817,8 @@ static void csum_one_bio_work(struct work_struct 
>> *work)
>>       struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, 
>> csum_work);
>>       ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
>> -    ASSERT(bbio->async_csum == true);
>>       csum_one_bio(bbio, &bbio->csum_saved_iter);
>> -    complete(&bbio->csum_done);
>> +    bio_endio(&bbio->bio);
>>   }
>>   /*
>> @@ -854,8 +853,7 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, 
>> bool async)
>>           csum_one_bio(bbio, &iter);
>>           return 0;
>>       }
>> -    init_completion(&bbio->csum_done);
>> -    bbio->async_csum = true;
>> +    bio_inc_remaining(bio);
>>       bbio->csum_saved_iter = bio->bi_iter;
>>       INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>>       schedule_work(&bbio->csum_work);
> 

