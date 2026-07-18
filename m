Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685B8377ED4
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jul 2026 23:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784418228; cv=none; b=iCrPFLUrg78DnafCy+4h/XbhgkKH9Br6WpDn4L8wlWIrpa9nQets3KTOUs1jeoeTnC19KZvmy6knHL5VLX684wKXBtgizuYJZFrZ3h0BPaYDMvPLTm3c7SQW8zIOHLnTekH6jvETEVhPGHypzfUJwGnOX2VYvetUm0Eg+s6EvVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784418228; c=relaxed/simple;
	bh=aCWuo4ztA8U5az1+qqgZSny899Q2Wv86b7SuvY+fdqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rnVLg1rBY9PR8wjGo6rkVYEPHZxd0M8jZWuDOwvL6c9rUluGzsQnzT6HX+Z6WnvvN5LQx5sIIt+62grbu/11IhFzuQURsvgn3zYR29azTlm3KPfvf9U/dhwU4MAZaXZsbAKJ9cChCLJotJD3n44ST2e6BijvxHfBB5QyxYFsdxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GwEs9CBE; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GwEs9CBE"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493c19bad03so66219605e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Jul 2026 16:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784418223; x=1785023023; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h5Y99LzlmWcB/aRdYatPYwMGyrI5r994FwWm3x1wOqM=;
        b=GwEs9CBEQYI3S69Q5NlQYLMHiFmjd+UQVT/SqndX3our8fROTOTmtZqNyrcaiVDRh7
         f2vXV+8URZQwtMO/eicUuN//aY5s+GemZLQ1zoH8tJL6ZD0R3XcLnK7wWCXo8CbMY1av
         glRIjaBMiUHyGcxnl8i6Us2a0CGAmkPs0lEiz0g4EG5U72BOaD4tTNAea/1qWRzesu1e
         MpREeEbnXNWeiKu2kVIqUB5ssmu5yaLnidoIfhXHBavvfZlZ/VeoI+yhW2ok5c/3QcDH
         x6jzSN/q1PGXMVj7+gI5xRd0WZcfKWKAh5eRjltDOzP0spvVr/DfALD4tD0lAu9AFXZk
         Ga7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784418223; x=1785023023;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h5Y99LzlmWcB/aRdYatPYwMGyrI5r994FwWm3x1wOqM=;
        b=bezuTi2h00tfLIUWAm79uqzatExF1GIpJRBNx1f4J+l/3/z7Gmd9ZXscO9erfKCCP0
         eJ5Zjzhike8MKnJTGDBpnMspIKKWxVA0uvmtSzNLJRV3W1XBHzvtMua88y3FMfCgOEsV
         Jo5lBTNtSvDxMkLUQsHcSEV1X1Jjug/BKFFpNcwhGU+1FRfbGyis4CHv00Ld9y8hvMvc
         WUS1wmxrXD98fhGp+p47A6N6EJKfAjTEjcMhnYXQu+LDCK966Ns11gMNnFwB4BjaIRs4
         CyrwW/PYNq0fpLLsH/lUXeb3eaXuD/qwHycqUUvcZj3h5HgVIFGJB3WOAwThiQeFnWNS
         TyCw==
X-Forwarded-Encrypted: i=1; AHgh+RrIX5sjDE3Q/XVZXvo0RIH67YgZAs0FTdiS0CjuXc7g3py35/O2HSS+eONHuA7cdiYyBiCiUv/LARe/uQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt7rNUWUgUVNRdOa28h+gnTdHoBacm2yXttifI+8z/Iz2v0tD4
	p1Qrw8N2LO994IGPpFnVasKEARdjOUAXimusu8yUe/F9KY5aNHHxc9f0sZZjArKLFrNQkdariw7
	/XbvHYsE=
X-Gm-Gg: AfdE7cmykOZhwZ+Y2cozyLNfR2XOJgVrSl+CCQGDM6i4Kn5zsVBM6pzkgjDcFTK+jcA
	7hAfemPWXCc+6s9/qYYSIf706w2NBKCAtq6zUf/VQvAjnvUj64bXBv+RblWx549FPz+YS2ambKA
	MsyVhWJFrP1aP08er3LkLom7bWNGhm4jz02Um5pahBeLmJJtTVTAYKUaxzqe2xKWbTK1/t9mxkz
	p1fhqJxaJQ9G3VgJj5Ha1MRnLC83NjDcoIL0VWpOxYot0GF5BOITSdKkrZ205xFY6voEmF4GcE7
	LgDpiLQ0oa48krayOUuaSUOUvEoKT+pkuSKoNEGOZRMbEGMcdtkxRJQwan/tpgMsGbVkqSWdAwW
	vJaceOBfzlhIZKZyvDAY3sUIHmV0kvSzfVMySmJTMqVoV+aMcpiGUonvX5yQbcwj7BHAW4nw=
X-Received: by 2002:a05:600c:4ed4:b0:493:aa0a:45ad with SMTP id 5b1f17b1804b1-4954a3ec5f7mr86951455e9.2.1784418223490;
        Sat, 18 Jul 2026 16:43:43 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af9f477sm3380040b3a.58.2026.07.18.16.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2026 16:43:42 -0700 (PDT)
Message-ID: <41772a0a-7ad7-4ec1-b88c-b616d740c00f@suse.com>
Date: Sun, 19 Jul 2026 09:13:37 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: raid56: fix scrub read assembly submitting no
 reads
To: Mykola Lysenko <nickolay.lysenko@gmail.com>, linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com, clm@fb.com, josef@toxicpanda.com,
 dsterba@suse.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260718233710.176782-1-nickolay.lysenko@gmail.com>
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
In-Reply-To: <20260718233710.176782-1-nickolay.lysenko@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/19 09:07, Mykola Lysenko 写道:
> Commit 5387bd958180 ("btrfs: raid56: remove sector_ptr structure")
> converted the bio-list membership checks from sector pointers to
> physical addresses. The two conversions in rmw_assemble_write_bios()
> kept their polarity (skip the sector when it is NOT in the bio list,
> i.e. when there is nothing to write), but scrub_assemble_read_bios()
> has the opposite polarity -- skip the sector when it IS in the bio
> list, because then there is nothing to read -- and the conversion
> flipped it:
> 
> 	-	sector = sector_in_rbio(rbio, stripe, sectornr, 1);
> 	-	if (sector)
> 	+	paddr = sector_paddr_in_rbio(rbio, stripe, sectornr, 1);
> 	+	if (paddr == INVALID_PADDR)
> 		continue;
> 
> Since a parity-scrub rbio's bio list only holds the empty completion
> bio, the result is that scrub_assemble_read_bios() submits no reads at
> all. finish_parity_scrub() then compares the parity it computes from
> the (cached, correct) data stripes against whatever happens to be in
> the freshly allocated, uninitialized stripe pages:
> 
>    - if the garbage differs from the computed parity, the sector is
>      "repaired" and written back -- accidentally producing the correct
>      on-disk result;
>    - if a recycled page happens to still hold the old (correct) parity
>      content, the sector is deemed clean, dropped from dbitmap, and the
>      actually-corrupt on-disk parity is left in place. (Scrub reports
>      no errors either way: there is no counter for P/Q corruption by
>      design, so the bug here is purely the failure to read and repair.)
> 
> The second case is intermittent because it depends on page-allocator
> recycling. Observed with fstests btrfs/297 (raid5, 2 devices): the
> corrupted P stripe intermittently stays corrupt after a scrub --
> roughly 1/10 runs on x86-64 KVM and up to 7/8 on a UML build whose
> timing favors page reuse.
> 
> Since the bio-list check can never be true for a parity-scrub rbio --
> raid56_parity_alloc_scrub_rbio() adds a single empty completion bio
> (asserting bi_size == 0), bio_paddrs[] is only populated by
> index_rbio_pages() which is never called for BTRFS_RBIO_PARITY_SCRUB,
> and rbio_can_merge() refuses to merge rbios of different operations --
> remove the dead check entirely and assert the invariant instead, as
> suggested by Qu Wenruo.
> 
> After this fix the injected corruption is read, detected and repaired
> in every run (8/8 UML, 10/10 KVM), and the new assertion never fires
> across the full fstests raid group.
> 
> Fixes: 5387bd958180 ("btrfs: raid56: remove sector_ptr structure")
> CC: stable@vger.kernel.org # 7.1+
> Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Mykola Lysenko <nickolay.lysenko@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And pushed into for-next branch.

Thanks,
Qu
> ---
> v2: per Qu Wenruo's review -- the membership check is dead code in
> either polarity for a scrub rbio, so remove it and ASSERT the
> invariant instead of restoring the original polarity; clarify in the
> message that the absence of P/Q error reporting is by design; move the
> AI-usage disclosure to an Assisted-by tag per
> Documentation/process/coding-assistants.rst.
> 
> v1: https://lore.kernel.org/linux-btrfs/20260716174511.8738-1-nickolay.lysenko@gmail.com/
> 
> Note: UML (User-Mode Linux) results above come from
> https://github.com/mykola-lysenko/btrfs-uml-fstests/ -- for reference
> only.
> 
>   fs/btrfs/raid56.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> 
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2909,13 +2909,12 @@ static int scrub_assemble_read_bios(struct btrfs_raid_bio *rbio)
>   			continue;
> 
>   		/*
> -		 * We want to find all the sectors missing from the rbio and
> -		 * read them from the disk. If sector_paddr_in_rbio() finds a sector
> -		 * in the bio list we don't need to read it off the stripe.
> +		 * A parity-scrub rbio carries no data in its bio list: the
> +		 * only bio there is the empty completion bio added by
> +		 * raid56_parity_alloc_scrub_rbio().  Every sector is read
> +		 * from the stripe, so only assert that invariant here.
>   		 */
> -		paddrs = sector_paddrs_in_rbio(rbio, stripe, sectornr, 1);
> -		if (paddrs == NULL)
> -			continue;
> +		ASSERT(!sector_paddrs_in_rbio(rbio, stripe, sectornr, 1));
> 
>   		paddrs = rbio_stripe_paddrs(rbio, stripe, sectornr);
>   		/*
> --
> 2.43.0

