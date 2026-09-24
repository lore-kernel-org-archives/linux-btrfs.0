Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E96A3AC0C8
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 22:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288277; cv=none; b=gCh82aH8f13IMG7LOWvvtvGR8uIxb41z5jcPNAEgPEESaciann1uWfu1OdVWsRi/jefI7WgpOCP5pfSu/8RRtgSBlHRXvVEwICXhjaodu9M3VeiXxe9F42NUZN2GMxcu7u5BzgcSiSrm+QdecYI+fAZFK3Ug25vU7Ug3J6Q5TiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288277; c=relaxed/simple;
	bh=TVeYl3lfjyeYZ6Ai1IRdDDGhqsgBOOoq8b4KJVB7hTw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ze3lDruCQBUM9d/Noj2N5ai5bmROXReANnumlAnVa2+o+Ps2YUTD/dGT5y0xr8jmwVcLQZWl9f2XX33S1/5PVMwtQISRjomJv+Ywn5885C59Ztfbz3I1pU1mrVUkhZS1TFn23/3AVJfZ4w2uigvOHmW9AEiGcSuDzPf4AGAxHew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E+kukQyh; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E+kukQyh"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c254f55efe7so37439766b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 15:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790288274; x=1790893074; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BcDkR9C4XLSztQOsEkSz9I898v48ijY37nZ0JuKK+/8=;
        b=E+kukQyhUa4cByYa4gU2AEEBcTiB7DBOo4x0rv2T/ST1I80TWUOEyBHeu3H20sLtvE
         SYYwHgfMdoQdRTI9iBS9tJoUV4e33EAFb8KU4qqCDZc1wJAq+7FPhJr7+m9/pmyyIr4w
         uD0qE8QsPb4dSUtT2ctiNWpCJdDNbe6i3b6LXnKw3LmWChutjct/d/a8x40MtrZYqxjN
         nFX+vuY6YVO9PVzLLRoBxqQkNkbk+50pP5vajeVS8JRl7HIrBgBib9ncg00bYBLbfjEe
         Y3ZPqDMsO3ugB0vSKx/j7/rbP1Lpm/PwIpj1Ss6WlzAx8Dq/oHSqiAhQutgAtMzyotf+
         MTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288274; x=1790893074;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BcDkR9C4XLSztQOsEkSz9I898v48ijY37nZ0JuKK+/8=;
        b=WVTBJvZ7GSCx49jG9RW8Fhf6fBAQhWQ4hCK61Xkm8F3iOh1/2PKbrZlHR1ltjXC7uV
         UNjXOYGN33E0u/m3gCjVIsBTX5AxTRdu/K0EP39RvV4pdHqC6xRHovdzhXvqPI7IkEwz
         2A3A2/6nnmAISrk9Ydib+R0ZTAshB/Y1u1gNbYoFMCUpnp3X6ROvMA7jdXlI8Z3Im9TP
         g9aBEELt0FtkHIbSYjCEKIcQvVJUwIZH77sdW8X84ObHmhFV8T1q2DDQmzyUFjziQGHB
         ARWA/ykqlLiM/tI7nIyhRr00k1pU8LxKPx41y4qpANEftmeYUG+/EHxtsZi26moE967h
         LLLg==
X-Gm-Message-State: AFuF++mincGQb0/6U4rFREyfCSAm02c1Bsyh5WNBVi2m/isN9gdzAx14
	7QCGzMFwWE8hYPyJdYIqD+x+bvOpGaKZ+2VXLVyH17ShKfpYEd9pbfI7S3LI1rC5pCiMnDoJtgx
	RYzEZMUAqvw==
X-Gm-Gg: AYBFou2vykKrGh6VuQSsv32H4vOUDQ77VLf/wOw6P2U4Xgnp+4q5SwbeAZYLFPDsqHW
	ub3jR9CaAuBb5ZqcM3RdVvOv3Yl4TucsV6MAjfpKFGwbeJsRpxIeshwKCkH1g0LCnC8fLoxntKD
	t1InUH7zdGUvddxW2k/yB0B0KRlX1/I5w+gSPiT6z8NH9gm2xUQTpOvaCwaswpuNk3VjK0ZkTyz
	YWBYNzHG+5axHUXTdU+Y0x1N32uVxV7OHo9MCYHUphBdEh8VGrCTiGRYXZ4MCA1HsCg0wlUmRxL
	b+bjF3jS5wyZ5SQR0YGSSzls9pnyXS/Yi4ykWjbA4iywDUDyFtzjxds/Y/AKcYoqR314/spzjMp
	EXsQCuQrLUlN7KX/BD4z0dBiILRB3ZA8FldzcS/wvyOtgaHmMMeHVRItMV/RIb5Bi0okjg28CR1
	8AnyGCLePnZ3tMD7I+NpTETCdOBbb6sMA8kuw2EsTrPZLG/WdqejIou2UmrgPaPu0=
X-Received: by 2002:a17:906:dc95:b0:c1c:3b06:ed03 with SMTP id a640c23a62f3a-c2ac24d3548mr337495866b.23.1790288273595;
        Thu, 24 Sep 2026 15:17:53 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc78796cf39sm300993a12.32.2026.09.24.15.17.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 15:17:52 -0700 (PDT)
Message-ID: <4a62c3e8-9b8e-465e-836f-75012992143c@suse.com>
Date: Fri, 25 Sep 2026 07:47:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] btrfs: implement uncompressed fallback for delayed
 bbio
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1789687750.git.wqu@suse.com>
 <bc25ff663342a8edfc1b9b40e6e4e1ed9f0f75ec.1789687750.git.wqu@suse.com>
 <20260924173641.GC2146908@zen.localdomain>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <20260924173641.GC2146908@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/25 03:06, Boris Burkov 写道:
> On Fri, Sep 18, 2026 at 09:00:30AM +0930, Qu Wenruo wrote:
>> When compression fails (either bad ratio, fragmented free space, or
>> writeback path chooses to submit the bio early), we have to fall back to
>> uncompressed writes.
>>
>> The uncompressed fallback is mostly the same as cow_file_range() but
>> with some changes:
>>
>> - Endio function is slightly different from the compressed path
>>    Only in the folio freeing handling.
>>
>> - Uncompressed fallback error handling
>>    Since at this stage, the folios already have WRITEBACK flag set, we do
>>    not need to do the usual page unlock/end writeback, but just free the
>>    reserved space and call it a day.
> 
> Continuing the reserved space issue from patch 4, here, both finishing
> that bug and showing a second very similar one.
> 
[...]
>> +	btrfs_lock_extent(&inode->io_tree, file_offset, cur_end, cached);
>> +	em = btrfs_create_io_em(inode, file_offset, &file_extent, BTRFS_ORDERED_REGULAR);
>> +	if (IS_ERR(em)) {
>> +		ret = PTR_ERR(em);
>> +		btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
>> +		goto free_reserved;
>> +	}
>> +	btrfs_free_extent_map(em);
>> +	ordered = btrfs_alloc_ordered_extent(inode, file_offset, &file_extent,
>> +					     1U << BTRFS_ORDERED_REGULAR);
>> +	if (IS_ERR(ordered)) {
>> +		btrfs_drop_extent_map_range(inode, file_offset, cur_end, false);
>> +		btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
>> +		ret = PTR_ERR(ordered);
>> +		goto free_reserved;
> 
> Now suppose this fails. We will have a missing OE range in the parent,
> so when we finish the parent, we will free its reservation (patch 1)

That's indeed another problem, and the layered OE is making the error 
handling much more complex.

I think for this double freeing between the child and parent cleanup, 
the child should clear the bitmap after doing the cleanup.

Thanks again for exposing this one,
Qu

> 
>> +	}
>> +	btrfs_dec_block_group_reservations(fs_info, ins->objectid);
>> +	btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
>> +
>> +	child->ordered = ordered;
>> +	child->private = parent->private;
>> +	child->end_io = end_bbio_delayed_uncompressed;
>> +	child->bio.bi_iter.bi_sector = ins->objectid >> SECTOR_SHIFT;
>> +	atomic_inc(&parent->pending_ios);
>> +	btrfs_submit_bbio(child, 0);
>> +	*ret_alloc_size = cur_len;
>> +	return 0;
>> +
>> +free_reserved:
>> +	if (child) {
>> +		struct folio_iter fi;
>> +
>> +		bio_for_each_folio_all(fi, &child->bio)
>> +			folio_put(fi.folio);
>> +		bio_put(&child->bio);
>> +	}
>> +	btrfs_qgroup_free_data(inode, NULL, file_offset, cur_len, NULL);
>> +	btrfs_dec_block_group_reservations(fs_info, ins->objectid);
> 
> But we have already freed it here, so it is a double free.
> 
>> +	btrfs_free_reserved_extent(fs_info, ins->objectid, ins->offset, true);
>> +	ASSERT(ret != -EAGAIN);
>> +	return ret;
>> +}
>> +
>>   static void run_delayed_bbio(struct work_struct *work)
>>   {
>>   	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
>>   	struct btrfs_bio *parent = dbp->delayed_bbio;
>> +	struct btrfs_key ins;
>> +	struct extent_state *cached = NULL;
>> +	const u32 uncompressed_size = bio_get_size(&parent->bio);
>> +	const u64 start = parent->file_offset;
>> +	const u64 end = start + uncompressed_size - 1;
>> +	u64 cur = start;
>> +	u64 alloc_hint;
>> +	int ret = 0;
>>   
>>   	if (try_submit_compressed(parent))
>>   		goto finish;
>>   
>> -	/* Uncompressed fallback is not yet implemented. */
>> -	ASSERT(0);
>> +	alloc_hint = btrfs_get_extent_allocation_hint(parent->inode, start,
>> +						      uncompressed_size);
>> +	while (cur < end) {
>> +		u32 cur_len;
>> +
> 
> (re patch 4: this is the missing second reserving call)
> 
>> +		ret = submit_one_uncompressed_range(parent, &ins, &cached,
>> +						    cur, end + 1 - cur,
>> +						    alloc_hint, &cur_len);
>> +		if (ret < 0) {
>> +			cmpxchg(&parent->status, BLK_STS_OK, errno_to_blk_status(ret));
>> +			goto finish;
>> +		}
>> +		cur += cur_len;
>> +		alloc_hint = ins.objectid + ins.offset;
>> +	}
>>   
>>   finish:
>>   	/*
>> -- 
>> 2.55.0
>>

