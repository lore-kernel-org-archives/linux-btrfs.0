Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92119397AE4
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 22:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784241110; cv=none; b=EprKFeJWdlVZIebT1Ejh61m6xIcFBN4grqRG6fzHUQDi2ka2jV8hrHB/q62GmZ18aK9jf5mZJYpkWbjE3bKehHoxD9hXoEyHKJU2iDpOpQgi6ee37pzI0/VYGvF2QuQYvllgLS1FmweyxMafeA9Ygx1w23VMBexlvZoG7QuIj9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784241110; c=relaxed/simple;
	bh=3JcfUviPBCvSoo73amaShgM1dt2fVi1EVzVbR3tyHEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RIZ4BKhTNOpPlj/R+kY/P/LBaegt9YV0en9/xPrJVox4YbncNxXemfjq3q3dWiI0HRA14OemBHEZ9j+uDmF8qcOG4SEHZunZVu5uij50ktZejCvBTT5Szlo/imN83TMe1vMaDfJAAISQQIpfexa0HNbhSmZ/qTpxaCFxyF+MDFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DtvAWf98; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DtvAWf98"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15f020a223so951589166b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 15:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784241107; x=1784845907; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dbIPuto2HqbcynDkvpV6AphmlmAKdXj/5/We7KPO0U8=;
        b=DtvAWf98HQPHfsjtXaiA/zpsB6C8zpf4nE5sxQXLgR33xvlr6Ubv5b3nh1U3F93N6a
         FmaOVeTeq8wSS6RaYists/0Rg+J6RGh4szQLkO5Yo1fYl4epTQubdgWYJkkNA2aTFM16
         WegeCAJVDL545bqU99yYrijROjiPtMRKyDBm89R2XCmYaONJ4J1wGO4qHdINOMcgdJo4
         VfCUyNhJLKx1z1frr/clpMcInUyLEdc2XH3lc9qmveUxovVqfZwfUgDXWBNB62qu9xph
         2U3DyysiZ/C+JBCz8DGFMq0sGlRAqU6awrJi7EISiTj2jCO5GnkSxHCTLyq7n/jMIflh
         XfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784241107; x=1784845907;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dbIPuto2HqbcynDkvpV6AphmlmAKdXj/5/We7KPO0U8=;
        b=OL0YCmny39xqbCf9TXkiySOmiFR8nKvYF4gn2rZmvsDRu8VVwxeOW6llY5hLNyOXbV
         AqgIVV8hhvycx/tQD9yiJ6U5wy1QPZBFErWQP8ARTb1ycVOA8C7liiduWxHO2S2K/o5x
         kX6gH4oLJQN1qgtaNGDkOLhAQh+RDy5FQ5eWXInn9O29Kt5ikXxKaOPcOgArHDbrMXl5
         Cbqu9/HPmy1V0I78cisTKxQ/1hQGLr4fPy122hc3WI+baFFYbIJsjil7KSlgOZ7g+/fs
         wr4kxpv8sJIuKQ6unxljE2/AHY0WcTb0UHp14mlACgUKQhQgVqaB25j2z3yLSADt0F1x
         d98g==
X-Forwarded-Encrypted: i=1; AHgh+Rr0LoFUh9wdEt+nl5qyOaz2r49NTJanYvqGMfoydNoPxD5ellP+dQFBj+R7QSBmRbJA97UByHvelIpo7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzldJqPDwQcn3kQWHmjJNJaD1lXh/5YBIdoySd4pBIDBYoRSc/5
	oVrr+QqqtfhBCY1kbbHeDnUlhsorlWXNhcR+/rMA/9+MelQoNcHzdc9SVG3/G4t4XoY=
X-Gm-Gg: AfdE7cmUYYVUNVJRWCcydXyQzdlKkKUHPnR/dXGhHSGdpflIMB7Ftm23W39jWzqVLOY
	lnn0/3kYH/+nL9MV8b1ruhpQk9acDD4SQZpEguybc9+svIcCRcVwRqyK7GiuodNQwBcfPCoulNh
	NmxD4FEmYytCzBTIh5vIw6E+bGrA/PKoEWC+0JtBhwKauDmhZCqPbSiOB49EqF1mn8GkjTO0Rh6
	7jNX9CCPNfL58zjAkx53k93d6XtRLJFk9PR9ak2ZqkGjXGEoWMp4lSZQ8lWcpbpI3gdzpQL+9ZV
	rcvY+D6cL8S5clLLEqAmPeEDD6X9zOyK00tQYLFPhRx9Qp0VfvjnksCUJj6hjbzR/LgGChLJPYW
	+qCVNV9CJyaG1YuecgaRkjhHHf3vcgwoUAa0a5+195EmfMvLHk2Guj1SYHyPQrJzlTNLFqkE=
X-Received: by 2002:a17:907:9628:b0:c15:e8c8:340 with SMTP id a640c23a62f3a-c16679ffcc7mr656388466b.23.1784241106707;
        Thu, 16 Jul 2026 15:31:46 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3471557bsm30925ad.58.2026.07.16.15.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 15:31:45 -0700 (PDT)
Message-ID: <8c6979b0-8ff9-480c-9027-29986bafa71c@suse.com>
Date: Fri, 17 Jul 2026 08:01:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] btrfs: factor out dirty-clearing part of
 btrfs_clear_buffer_dirty
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260716115656.1319295-1-johannes.thumshirn@wdc.com>
 <20260716115656.1319295-2-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20260716115656.1319295-2-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/16 21:26, Johannes Thumshirn 写道:
> Split the dirty-clearing part of btrfs_clear_buffer_dirty() into a helper so
> a later caller can reuse it while bypassing the zoned zero-out deferral.
> No functional change.

I'd prefer fold this patch into the user.

> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   fs/btrfs/extent_io.c | 47 +++++++++++++++++++++++++-------------------
>   1 file changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 647b109ef61b..4dd8fc5ad247 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3788,6 +3788,32 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
>   	release_extent_buffer(eb);
>   }
>   
> +static void __btrfs_clear_buffer_dirty(struct extent_buffer *eb)

Not sure if we still allow double underline function names.

Thanks,
Qu

> +{
> +	struct btrfs_fs_info *fs_info = eb->fs_info;
> +
> +	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
> +		return;
> +
> +	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
> +	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
> +				 fs_info->dirty_metadata_batch);
> +
> +	for (int i = 0; i < num_extent_folios(eb); i++) {
> +		struct folio *folio = eb->folios[i];
> +		bool last;
> +
> +		if (!folio_test_dirty(folio))
> +			continue;
> +		folio_lock(folio);
> +		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
> +		if (last)
> +			btrfs_clear_folio_dirty_tag(folio);
> +		folio_unlock(folio);
> +	}
> +	WARN_ON(refcount_read(&eb->refs) == 0);
> +}
> +
>   void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
>   			      struct extent_buffer *eb)
>   {
> @@ -3812,26 +3838,7 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
>   		return;
>   	}
>   
> -	if (!test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags))
> -		return;
> -
> -	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
> -	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
> -				 fs_info->dirty_metadata_batch);
> -
> -	for (int i = 0; i < num_extent_folios(eb); i++) {
> -		struct folio *folio = eb->folios[i];
> -		bool last;
> -
> -		if (!folio_test_dirty(folio))
> -			continue;
> -		folio_lock(folio);
> -		last = btrfs_meta_folio_clear_and_test_dirty(folio, eb);
> -		if (last)
> -			btrfs_clear_folio_dirty_tag(folio);
> -		folio_unlock(folio);
> -	}
> -	WARN_ON(refcount_read(&eb->refs) == 0);
> +	__btrfs_clear_buffer_dirty(eb);
>   }
>   
>   void set_extent_buffer_dirty(struct extent_buffer *eb)

