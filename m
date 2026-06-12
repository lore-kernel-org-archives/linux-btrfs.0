Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57903314B66
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 21:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781298948; cv=none; b=A89b41THPeF5vCkxAWLxxb/cSHZannF/5Q6O/FVkaPpiHiFVF3swMhztkmvFFc6IVm413vRfl/0UuOgCm+Y9iC9eG9eC7Agl1CKfuXrkYveY/wVXwHRL9armrTtldvFEsb10xHge8My5vhvWnB1SB5vU0vS5Uv+u9OWKXWIfoVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781298948; c=relaxed/simple;
	bh=JKyg/iPoN8zNpNrYmuWCQo6roxGbJLUtNlqrJc2K/o4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=bAK4McOledMDEoA881d1IHvHRsfoCRUMlh6z1HcP5NtCn3d3ZJ5pf6KV+miiwOd9PUlFCCci1Gg46KlzoXJt4LufYh8dROghIojyMAAPJBCU3p1vjGgimaQRFfkQTEvS0vt4MK4+Xe0wtM4MxhqX5JIHhxiVKwePWSOs73GSY+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F4N5Jkho; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F4N5Jkho"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so14677935e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 14:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781298946; x=1781903746; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fnndAo8F7J7xuJt7KqUJ2PKVDe/F2y4/r7RH6iwgE/c=;
        b=F4N5JkhocRp54lmTgLIQSz6u6aKkzY01357wb93EDiNyextzJD54RHDPz0D4P3CWvr
         6yVxbkJDEAL8d2wcdA9vgRD2vNvmUf9kP4dJa1P+s/XaSNw84Rn3Bx/OYyImALM8AMTV
         iDbiN+WpvsdJdg0At8s1xamc4QpIur2TQXHb53POU5fxALvzJ0kXqUYf6Shz3KvPRSC0
         gCG6ZoG6xpzoM2hiHPxeb5+sqQUjVjJw5fW6g4HiEFADgIUDtkUcBS0wQSxBiFMXygne
         gacF8d+kE716qmpP/6yJb00LS5PSsW7RLr+CTVTNbk+J2du5FJFN4OJi/KvbRSBKYJmE
         Tg2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781298946; x=1781903746;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fnndAo8F7J7xuJt7KqUJ2PKVDe/F2y4/r7RH6iwgE/c=;
        b=R1qHgCyVVUl6yYx/x8H5WqAQH+PqCg2Jlhwz+zBBssjGSvA+G2uxyoToFLeqiGN3p3
         WjK8/3zqoWENcD8tS2lP4Ye8ctDGAvb4L2gQfCxWooZJPXfFN0ZhJT+B2oes30qMtBsZ
         ZLNs3c4NRbJyvN1Wh56izE8vXDG/aWaVsVLO0eedtSYE79+aQWE/qUQgrWe45HZI0E38
         vgUAHXKru8+FJUvkiK/tr/7VP2Fv4LG/D4OtFPQMFP64xznhbudPWvCjIVbK2cwszlzQ
         TW4Tsbe9jln7Tp3pWr7cORY8KhR0BWRXtvkwqVDL0N7EtYpjCkQPhKOoNdwitxCan1Be
         2DsA==
X-Forwarded-Encrypted: i=1; AFNElJ8PzWFGkXOqL4wkW9TQJDCCzFBLsuG3TRBqqYDFtef92lCBw9XlVrfZWJv8TNLKoW3imJytQYgLLLW4eg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/h28kSurFnivvsMDOh/TI+r2tlDyFUYHr8UMLL5YjOiTg1BqE
	LcsNO34enp3f2nCEHeYEB/0ePSLU8glilEPNwcS6I5abIfdHVs1rVafZumTzBlllTunTzWAZYpX
	PdNiF
X-Gm-Gg: Acq92OHeNcCuj118zliJTMWYLr7lUxm3tTXvgJZmF9/xQIXih8kerxdN/8Rsn+CLnpt
	ilnIIUQANWlfOorqN5KxqPXbKptxurrU1HrO9kZokqIidK6wx6rwPWJMy/RhAWpp7oFHIhqmJdN
	ZxvMWMReNcGht04/gjCftgzZyOMtV4IVuUFaxTgtJrdGsUvwL+OTt7StpeFt97e17IXXtF/CMF+
	BXx3CIHkIs6xmStA0Wr8Ls8yp7MNgSJRo8QUTJut42t2cepj2DJijdHlFCXspSfcYwC3fDgyXnr
	IF7dvrKefKMvVAizsU3bZcZy79KV7DyAk9ICzi//FAr3NjYojh5pzV6+BZ6LLsI63ECGt1adfpa
	wVN/evHUx4mgfZ9bxrKO/phpvuxs+5nkWZgU11t80qY/cFwHBftX86LU23VGnJbSM6q7Yhm8Eno
	v7ZkzCU1EO326K5iaOI+2aBQqW+SMDI6KN0dqHc1WXmqQhBRc07dbj18tI/BnExrKQGeu+JXREf
	WQCcJKdScGduj2YhkYxa23tXhYFUkr1OC3kr5reJlFF8g==
X-Received: by 2002:a05:600d:84ca:10b0:490:7dfd:f7c2 with SMTP id 5b1f17b1804b1-490ec4dd936mr39180555e9.11.1781298945582;
        Fri, 12 Jun 2026 14:15:45 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e59e1sm31209625ad.17.2026.06.12.14.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 14:15:44 -0700 (PDT)
Message-ID: <11c68d61-5add-4d7b-b51e-747a212f6133@suse.com>
Date: Sat, 13 Jun 2026 06:45:39 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: release extent lock per folio in readahead
From: Qu Wenruo <wqu@suse.com>
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <1c59582ab8eba7fabda0422856514019be95dfac.1781282522.git.boris@bur.io>
 <e5732981-02ff-45c7-a3de-db5ca519a47f@suse.com>
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
In-Reply-To: <e5732981-02ff-45c7-a3de-db5ca519a47f@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/13 06:38, Qu Wenruo 写道:
> 
> 
> 在 2026/6/13 02:12, Boris Burkov 写道:
>> In Meta production, we have observed a large number of hosts running
>> kernels newer than 6.13 which hit hung tasks on
>> btrfs_read_folio()->lock_extents_for_read(). Looking through the history
>> in this codepath reveals an interesting history.
>>
>> in 6.12, we merged
>> commit ac325fc2aad5 ("btrfs: do not hold the extent lock for entire 
>> read")
>> which holds the extent lock very narrowly while looking up the
>> extent_map. However, this proved to introduce a serious race with DIO
>> writes which was fixed in 6.14 with
>> commit acc18e1c1d8c0 ("btrfs: fix stale page cache after race between 
>> readahead and direct IO write")
>>
>> That latter fix subtly changed the extent unlock point from the pre-6.12
>> regime. In 6.11, each read endio unlocked the extent it finished
>> reading, but in 6.14, the extent is locked/unlocked as a unit around the
>> entire readahead loop, while the individual folios are still unlocked as
>> the endios finish. This is mostly the same behavior, as all successful
>> reads will populate the page cache, so subsequent reads won't enter
>> btrfs and hit the extent lock. But in the case where the readahead
>> fails, perhaps because of a memory allocation failure doing compressed
>> reads, the page will not be brought up to date and a later read of an
>> overlapping range *will* block on the extent lock.
>>
>> To bring this behavior back to the old model, we should unlock the
>> extent at each loop of the readahead loop rather than in one shot at the
>> end. This allows such overlapping reads to proceed as they should.
>> Writes are fine because either the page has already been read and has an
>> appropriate state in the page cache to be invalidated (or not uptodate)
>> or it is still-to-be-read and the extent lock is still held protecting
>> it.
>>
>> Signed-off-by: Boris Burkov <boris@bur.io>
> 
> Looks good to me.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> 
> Just to mention that Sashiko gave a review with level high, which 
> doesn't seem to be caused by this patch itself, and seems to be a false 
> alert.
> 
> Btrfs compressed readahead can expand the RA range, resulting folios 
> that has no extent lock at all.
> Thus in theory we still can have some folios without extent lock for 
> compressed readahead.

Wait, this is still problematic, that we can clear the EXTENT_LOCK for 
ranges that is held by other threads.

The read itself is protected by folio lock so we won't race, but some 
other readers may got their extent lock unlocked still seems problematic.

Can we do an extra check on the folio range and only unlock if it's 
inside the original RA range?

Thanks,
Qu

> 
> But thankfully direct read on compressed extent will always fallback to 
> buffered read, thus there is no window to race with direct reads.
> 
> Thanks,
> Qu
>> ---
>>   fs/btrfs/extent_io.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 7d604524e83c3..a9517b8cdd601 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2745,12 +2745,21 @@ void btrfs_readahead(struct readahead_control 
>> *rac)
>>       struct fsverity_info *vi = NULL;
>>       lock_extents_for_read(inode, start, end, &cached_state);
>> +    /* We don't use cached state for a bulk unlock, just free it. */
>> +    btrfs_free_extent_state(cached_state);
>>       if (start < i_size_read(vfs_inode))
>>           vi = fsverity_get_info(vfs_inode);
>> -    while ((folio = readahead_folio(rac)) != NULL)
>> -        btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
>> +    while ((folio = readahead_folio(rac)) != NULL) {
>> +        /*
>> +         * Read start and end before btrfs_do_readpage(). It unlocks the
>> +         * folio, so our reference might not be valid after.
>> +         */
>> +        const u64 folio_start = folio_pos(folio);
>> +        const u64 folio_end = folio_start + folio_size(folio) - 1;
>> -    btrfs_unlock_extent(&inode->io_tree, start, end, &cached_state);
>> +        btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
>> +        btrfs_unlock_extent(&inode->io_tree, folio_start, folio_end, 
>> NULL);
>> +    }
>>       if (em_cached)
>>           btrfs_free_extent_map(em_cached);
> 
> 

