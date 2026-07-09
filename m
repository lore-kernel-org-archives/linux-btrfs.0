Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A6A3A784A
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 05:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783575540; cv=none; b=XD9ixn8RxxhRL1fwAqrazsnyetGmFDtYWWDkpJcVHQ4EUHYyjVDbEzyufLyVZ39k8ARrd/QReF9DavcX0oN6w6r1Mmj2R4rh/q5gZPuD5JvS5MBgOkloyZ0p5wO+5K/mDI6xu4HWG6Ce/WrNNlGsQj539S8aoD1Yzmh7PrgV0NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783575540; c=relaxed/simple;
	bh=CnDVkOfjf2wSY2JmSRnPaO+PRzyuFN1NvBYk/JLqrdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scUcUpGZEs6XffJBE3i/FxdWW+KmP6fLHLnbmoeOzBzh46PwULdzdxYMcsD8ZDYRv+xJ51/NFgA88vOnQHVHXOOloN4yxnHpoijxJDwiKXfPWFQiHa5LxKXEE5zTchZFWHKC/uKr9iz6A8I8M1EsUa07P20lzrGh+jaylXfywME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fpbfn1fK; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fpbfn1fK"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-698c0ff45b5so867046a12.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2026 22:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783575537; x=1784180337; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/p4Wz54iZoS6hQdbEsP79fj38piO2TxHnCIvSD5ku1Q=;
        b=fpbfn1fKFXLdzVY4F/WfaMQNCmVbJ30jcJtGCoD02bEParxI7F2eg8LsmafQ+6SOYS
         DqPEG4R6bLEzmHQ1+bbu3OL+9Ku3xpK7e03i09v8fff4j8HRcRAduzLjv6ETNSjYXEqp
         sCzXGTwFeZ9k7J9wI5oQNyHzWpQb40hXiYMGDeZ3iR25N/ZO4G9iBIkTz457ohnkPcau
         WBBjvwh6LhSvOBFjM6MRXL37+KVZcfMtfqwtKZ/+q2zveeVCPZhre0/FdqLBW+hlQ86v
         vnIX2x1okOyucUtnH//TNbfmPikeY6N9ndteqaK7X+IWTL5a9bPDaDGhRQ4i45Ck5De6
         Liag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783575537; x=1784180337;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/p4Wz54iZoS6hQdbEsP79fj38piO2TxHnCIvSD5ku1Q=;
        b=Fwg82N/ApRySplP5f9kgIGjaryAuAx84vMhefbgjN5r9pOgil0mu573mkSm9v6XTKT
         9zWaD3fam9fSKNQ9KWWBlI/d83Bqpv4zMMsmWGxoSNumG3K5NOtOBKJwnyLxRecABf3+
         65hf6vY19+iacGZ9ZhkFMo2QZfEQkkID9DMLqrwQtYrLBRaOYehkPC79tLom9ekpKs3D
         ndp90PbohrVwgZdYGP09/ocgNiHe9BDSxYzSTXcmb+S6HgQaAeUXakFI6QKcLKmKH5EL
         5aJGw+qavBguqpA/gNsZLmGWcH1E3h98sqCyjGXigZq2HluhHRct1+DNCnCZ20NrWZ8S
         b2ww==
X-Forwarded-Encrypted: i=1; AHgh+RrBKeFIk9/mT9Riow7kGNjdz4RPTUEExoWH29aRjUquiUM1yKEgp7WDLQTfV7z+GprtR189vF/1fMHQYg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHxQpHYbTinb4ALN0OcSVGsxgbkTiK7uE2vG/H17OIPE5ojusV
	lOr1MwE3TNDYGTLmFYb1EzpAXdXJVXfN7le1sUSA5o5fM2Bnz5GwolGCmX4xWEIHDVHW2pGdZvZ
	8lWECvQsNYQ==
X-Gm-Gg: AfdE7cm10lccnRt/KUhdMjA4NXxa+V1HNLL77p1gUDoj9siQHYgpuwRSxInmDFIDNmr
	QvlNNAejjKSiGySi19G1KBmsXskB61/UocVteZ+JobGMgYox3MR27sEciq40zeZpWX9HB6LriJJ
	/RXkR4Dfxfz4YYAyZwfn0gMCSWibR2/YJmM8Rb/Ab9t+eJftWksntQAWhlVoo/79gx6ocIR+jPE
	dJy+07AK3VbD/iq2kxryDLOLaHSRhwGAmrP+acv/hlGhZjsnxId3dCiXa0+oAyCS3d7XJ6VFeSx
	iW54zr/uxR7Bgfgq7kp+pou9Z8fXteuphqXuqouHGqyM3WGbGTgb9oDXfTwhX92BNbSuxyx0SY1
	vYU2b0i47wkEW7jMyjhea/4/8/MhukA7df6S1OhAd3oD74bQupF76+SCk64MFDMVejoU9I9fofY
	T/orfOsQ==
X-Received: by 2002:a17:907:c30e:b0:c12:a169:989e with SMTP id a640c23a62f3a-c15e784a1dcmr50555466b.19.1783575537345;
        Wed, 08 Jul 2026 22:38:57 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb6e2sm38391405ad.3.2026.07.08.22.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 22:38:56 -0700 (PDT)
Message-ID: <27264cb6-3172-4cb5-819a-705a3d607cb9@suse.com>
Date: Thu, 9 Jul 2026 15:08:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: willy@infradead.org
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
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
In-Reply-To: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/9 14:01, Boris Burkov 写道:
> Commit 095be159f3eb ("btrfs: unify folio dirty flag clearing") replaced
> the folio_clear_dirty_for_io() call in extent_write_cache_pages() with a
> plain folio_test_dirty() check. Besides clearing the dirty flag,
> folio_clear_dirty_for_io() also calls folio_mkclean(), which write-protects
> the shared mmap PTEs mapping the folio.
> 
> Without the write-protection, a process with the file mmap'd can modify
> a sector while it is being used by writeback in a way that expects a
> stable folio (checksumming, compressing, copying, etc...) which
> manifests as a handful of concrete bugs.
> 
> For large folios or subpage sectorsize, this will result in an invalid
> checksum and later corruption reports on read (if sectorsize ==
> folio_size() then we will always be in the case where we call
> folio_mkclean() when we clear the dirty on the sector, which is the
> whole folio).
> 
> For zoned submissions which are done in batch separate from the main
> extent_writepage() loop, we also risk csum violations for those
> submissions.
> 
> For inline extents this will subtly risk losing writes that happen
> after/while we copy the inline extent but before we clear dirty on
> the folio.
> 
> For folios spanning EOF, mmap could tamper with the zeroed bytes past
> EOF and cause them to be persisted where future faults would impoperly
> see them instead of zeros.
> 
> Finally, for compressed extents, we risk modifying the folios while we
> work on compressing them which will result in corrupted compressed data.
> This particular gap was introduced by a second patch in the same series:
> Commit a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")
> 
> We cannot simply restore the call to folio_clear_dirty_for_io() because
> that also drops the dirty flag off the folio which violates invariants
> introduced for large folios by
> commit 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
> and results in failing to invalidate clean folios past i_size, resulting
> in deadlocks.

Just to mention, we can workaround the problem, by extracting the real 
work of btrfs_invalidate_folio() into a helper, with a bool parameter to 
indicate if we're called from the writeback path.

Then we would have a better chance to rever to 
folio_clear_dirty_for_io(), but there could be other things involved.
So I'm totally fine with the current hot fix, but eventually we will 
still revert back to folio_clear_dirty_for_io(), to align the code to iomap.

[...]
>   
> +#ifdef CONFIG_BTRFS_DEBUG
> +/*
> + * Writeback must write-protect a folio when locking it for IO, before
> + * anything consumes its data (zeroing, inline copy, compression,
> + * checksumming). If this fails, then an mmap writer would be able to
> + * modify the data concurrently while we need it to be stable.
> + */
> +void btrfs_check_folio_write_protected(struct folio *folio)
> +{
> +	if (folio_mkclean(folio)) {
> +		const struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
> +
> +		DEBUG_WARN("writable mmap PTEs, root %llu ino %llu pos %llu order %u",
> +			   btrfs_root_id(inode->root), btrfs_ino(inode), folio_pos(folio),
> +			   folio_order(folio));
> +	}
> +}
> +#endif
> +
>   static noinline int lock_delalloc_folios(struct inode *inode,
>   					 struct folio *locked_folio,
>   					 u64 start, u64 end)
> @@ -332,6 +352,8 @@ static noinline int lock_delalloc_folios(struct inode *inode,
>   				folio_unlock(folio);
>   				goto out;
>   			}
> +			/* Locked for writeback; revoke writable mmap PTEs before using the data. */
> +			folio_mkclean(folio);

My question is, why we need the call here?

Isn't folio_mkclean() called during extent_write_cache_pages() when 
we're writing back the folio?
Calling it here looks a little too early, as the folio may not even go 
through writeback later (e.g. being truncated).

Otherwise looks good to me.

Thanks,
Qu
