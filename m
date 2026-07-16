Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA6241611B
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 10:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784198040; cv=none; b=oLp3msumbPE0VIYBrFD8qI3tOT5nle8UgUKUMktdSNunuQeTTWkL5sN2ll7cLnb29fW740O+eC2AVEiBojKIIULCfi7gzU3y4h4AgetNyYh5ge4w3+MJNVPjH0iSWFj9JUMCBTK3YQyjDN+UQphoWTW9QbbeKvik7fmZdnDNm0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784198040; c=relaxed/simple;
	bh=uVwtOY4LyPRDwDRjVP2jEwnkONUtC+1vO9eN/h7arEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oqOwGr9efJoJSu05uQYD0ducDiLaXfmCyIxdUOUE2wY25LD5z9R0B70BadzfivLHUsyLuu3De+69qzXEprTHiFmrnTJUNT+opOl4Ulfjz9qmZjoGVv9o6uzHUYCgvUgdmH8eBtH9De5RxPf4LOQaYbh1j8W/nOd0NzEa7J+jpuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Z5nw4uVk; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Z5nw4uVk"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493bb510ce4so44008855e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 03:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784198037; x=1784802837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q0lyTLjDFtPqzyFRClnkK6YVonHAGoYT0L6wJQZyeAA=;
        b=Z5nw4uVkAjqSmSlkSL3gRN56MGq5IIgAxCblPEfWzCzwXblJJrYD84kY42ZxfLHSDi
         WRQ5v81cTbKwKwntLMJUhlVaA2ZTBIXGTHyZXNY0OKtTb40PNcd1WOAjXp2myu6EJrmO
         3yFenqc0uEM9eqGe6gMmxTn4IM/rLDXXK2CFe9p08K7x0oegOZH6YbM88QPZhLMlcQvG
         5XaK5PyjiuoT4hwifrWYRXKI8Jc4IacKJUJ11WUONLccnjYXXvsKIedHA9JVLUHWMkGB
         S42QIu/P36WZrTgrKqnez6x+O2QXHwhhF0+32OXBdDE9tW6FpPdj4hXeLzAXhJzXU+Fi
         ghEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784198037; x=1784802837;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q0lyTLjDFtPqzyFRClnkK6YVonHAGoYT0L6wJQZyeAA=;
        b=r+n732dtG5I/U6uztB760sBXA5GvwToB6ROuRGQAmd9pyYPPucb7Nyk51pr1ATe1sG
         93WO9/z/kA4vF1oRu8kRcZFlxF3eKUlzGl/EjnklJICxM7UT99Cdf0s4mu+TqEqH7rUX
         GF2AhGIO4MhGhjqeaKNXzU1FqEODzLYZQFnkWRUN0RZeUDLruoXAILdYxrsjrRPm3b1y
         Eni5KIB8PPKW5pRhZDkxp1nbh4QbkHrc3c1j0FS53ciWXNDDN2V0AXJm10ClT3hzUU0b
         nUMRdDxET93U952QU1OMMs23+tmLgxILYxKF7yuUeL+PV1eRDrfHUPcCEG5VKNwe9E9A
         f2MA==
X-Forwarded-Encrypted: i=1; AHgh+RrRs6jVmOHiNembUVZehH2JeCAPG4nInyX7naSRewMwh8ezeXAJ+qf/pI52pveN5bvB3Y4VFskbXQGDVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlh9BEDuwFPB9vqeJivsJPX2IX1teCtz9m0c3JopJVHYJk3tuA
	0SmEsS1qzSzotT6sBwWTrCPhoIXdvvr8bJjDELgIpvyUTs0tReTUOpuBCwBUZv/B4wI=
X-Gm-Gg: AfdE7ckQXyhOSwQcIunw9tKTiPRYe5haOiltb9/lG9x5gG8LPuApq8YZRZmidwVAbNV
	umrloo2FLHNhQwkKuPJ/cUu2lgIPN6760cPNX/FbIXmoXrAdq/oq8fb37Nh9uyNp0lFhsl4BpOf
	/289yv+8J6JwnM75EsM6cCNU93NM2KXXymCE9wLD8fbUrE848dvlvD88KEQry5K+qGiw4XSyHtl
	4HNzm+Tgm/EN7KerZCJ1LRz55WWqL6y+iA68x97O8joWGIcAgxWrUKVvNnL94mkF9XO39/6hO+T
	NgAXK8GzAxBxxLn/2BBbFNz1kwfiT7+NeRDiegW6h4Law7+qmEQ4dEoLPiaqfcPr8KaSkKnU6ig
	bmTrzmIbXwL//tZ15E5skKz9LvMr6Gpw0UTwjU+D2dChHpCJt/9OCeSDiC1ejrt0cBVAjqDlfJ8
	oktlKwGQ==
X-Received: by 2002:a05:600c:e548:10b0:493:bc31:b2ae with SMTP id 5b1f17b1804b1-495389957a1mr81293605e9.10.1784198036689;
        Thu, 16 Jul 2026 03:33:56 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd432e848sm10929654c88.9.2026.07.16.03.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 03:33:55 -0700 (PDT)
Message-ID: <a1910189-1413-4434-b8b3-9d1725728ac4@suse.com>
Date: Thu, 16 Jul 2026 20:03:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: skip fully truncated ordered extents at
 zone finish
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
References: <20260716082312.1252174-1-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20260716082312.1252174-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/16 17:53, Johannes Thumshirn 写道:
> A fully truncated ordered extent (truncated_len == 0) wrote no data, so its
> ->csum_list is empty and btrfs_finish_ordered_zoned() trips:
> 
>    assertion failed: !list_empty(&ordered->csum_list), in fs/btrfs/zoned.c:2141
> 
> Since commit 66ff4d366e7e a short or cancelled direct IO write finishes the
> unsubmitted ordered extent as truncated with uptodate = true instead of
> setting BTRFS_ORDERED_IOERR, so it now reaches btrfs_finish_ordered_zoned()
> rather than being skipped by the IOERR check in btrfs_finish_ordered_io().
> generic/208 hits this on a zoned filesystem.
> 
> Return early for these, like the BTRFS_ORDERED_PREALLOC case; there is no
> zone append result to record and btrfs_finish_one_ordered() skips them too.
> 
> Fixes: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to buffered write")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/zoned.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index bff209b552c3..9668a5928735 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2138,6 +2138,16 @@ void btrfs_finish_ordered_zoned(struct btrfs_ordered_extent *ordered)
>   	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags))
>   		return;
>   
> +	/*
> +	 * A fully truncated ordered extent wrote no data and so has
> +	 * no zone append result to record.
> +	 */
> +	if (test_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags) &&
> +	    ordered->truncated_len == 0) {
> +		ASSERT(list_empty(&ordered->csum_list));
> +		return;
> +	}
> +
>   	ASSERT(!list_empty(&ordered->csum_list));
>   	sum = list_first_entry(&ordered->csum_list, struct btrfs_ordered_sum, list);
>   	logical = sum->logical;

