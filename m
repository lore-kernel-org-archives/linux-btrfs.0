Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F6F3515FB
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Sep 2026 04:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788929799; cv=none; b=fkJiPp8Eff7B33ByWMqTxiPnSULMQARTDaW6JY+maCswAfRtm3qiXvGr/m5qqXXIlBwVDjxDS4xheb5vRa/eciK146UL3PETkRpInQwvvUJ07S9p1PwASUCWUkVbtIZ28SCWf+l8qxzW2JqAzxhOOyB1VRmOzM/9yUdVGhBBxsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788929799; c=relaxed/simple;
	bh=I8x9Xab1quqd7JSPC5TH+cvtiOWpzpmg6wkMXgH4ue0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onGnUQAbz73xel/BtaaRGkeZ4lLzGuYzXFkD8iaH3g0n1rcFWCv6rnUdcMKnp8ggkchb3YjF+NoWwpl9YNqto4/IC0vSNKXoIB2d6chQ+To0qncDvx8TI0G4ofWCxhyNF5W8pLHxr6qaRsXfp3C7/DpVHPFT3sZI1GhD5vFnIcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bnj35BDr; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bnj35BDr"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48442ea8f59so4603840f8f.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 21:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788929795; x=1789534595; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sFc8bmCGj5QGO7oxyVLjDmklA5Lt1XayPFSYLp1KLIg=;
        b=bnj35BDr+8keklk6aXlW/Jo81SxjWgudtaRCaq94HL9+eiOflWwBnibCnHhb/0RoR7
         gzK1EWyXlk7Wia9mTCJ3cOCcyHwUduq5Ym/ZsxC8CWNo5jLRO6nfAudgyQ+WArdOmABo
         P9psVag4V746Y1OXBBrPdDh3to8r50ARDSVCmiSKgeGicJ7D5LBKT1QCPFKG2V4i08Eb
         WmY8mgKkHLAF8uA2dkhI68bAd5fppxF4W3szjhKtXO4sK9XjUZXR2L/L/EEzpmsqhF4g
         b1VENCWlfxyqMbAbCDuVbtapHPmNIVsZ0FE9hg0Q19JPQlMmseqaIp1GUN41xdUJk9ge
         welw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788929795; x=1789534595;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sFc8bmCGj5QGO7oxyVLjDmklA5Lt1XayPFSYLp1KLIg=;
        b=lC8UjNUufk4se0DdaqvlJpHot9HeV7XaXDykzW2+d9s9TU5XRbo3p+e1eIA702PpOP
         2PZpBlvfPSB40XvBLAkWgwrMoUz/pkf/fmVAGnsr1cHnz+UNrB9pVEetoQnmnC1GlnhN
         7TfX0QiGMtrmOwlhE2kUv7TY7yEsqcAJw8SqZ/qydpPcNlGiHfG8NccXLvhgsj8skkWC
         Z46vDK/UAeY1NvQkC5N2U5H2tYty+W7Yl25CGF21oycha3VzH7QSURR5tLo8dHFjG+9W
         g/2GeE1sbG46bYCpGK7tb10DGSLJOqqCW+xnXZCuNWCc7MPu353zQm2cJdCVLDUqLwfi
         TkxQ==
X-Forwarded-Encrypted: i=1; AKwUvBwcVNJN83Ut8dtDvyiH+SL6bJRffvNPvEMqD9AAWlV86ka9hPnZtbZKdLyjj2ndfvdzlMc4ZzXduyf91A==@vger.kernel.org
X-Gm-Message-State: AFuF++lwQ6KF5uu0K2uY75R24PICV8CofOb0eDnVboCIdwhQsMOpHIy8
	JzgWZd1roIxKk0EZDLkBuPWkh8Dc73GawPerUxxQQpmDcdAMw/8YlJMGLJCLV5WWbCM=
X-Gm-Gg: AYBFou3YEVz8n3ZgHFH0iUU+nPuOIavy094Ztkq+Ag23AoRfNNX9gF+m6mGwlLgQP9S
	uwY4sHDNqEKvIAGKVc3RqAEyKZS1K7VRIrCe9wflUEUII8v/4HfTi4ZV7Ld1SryqNWpA+HTMnyF
	pForEA3Jg1sKMwXg+PjhbdmJjjomw1lfxnqygP1cArp4xv8v4DexkzjE9xSYWczLrUp2f+nSI5G
	fIgBb4T//XAmgFUXbjvazuxaJ/5haMSx2wo3arMcYnrBefuoGFUwlGkJvTK2yQvbPa8K0BYhIGR
	3IJZWz6/R1tOhiHpSmrpQEtKYUEsTlNzDjdoyyOM9xZtJM65x8D1iiSx15myB+9lQOgERYNUV/g
	yuUCdbLBE0TfFG24+Y7Xc2Lg3SZzf5OxqHfAwRo1HQiPLoZ88Ijww+faMgf9mBap02Pa1Ya4s5A
	esxoSbLuYNZy/usl8DpIR+oQu1q3Ebx2sk9AQYfvH8kSNsc/vLZ2nDoY/tpK568p0=
X-Received: by 2002:a05:600d:849b:10b0:49c:f13d:ffe6 with SMTP id 5b1f17b1804b1-49cf13e05d9mr300132095e9.10.1788929795405;
        Tue, 08 Sep 2026 21:56:35 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d7e8sm37417273a91.16.2026.09.08.21.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 21:56:34 -0700 (PDT)
Message-ID: <5b72f456-4b62-490a-956b-9ca40ca1054c@suse.com>
Date: Wed, 9 Sep 2026 14:26:27 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] btrfs: tests: convert test_find_delalloc() to use
 folios
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
 <20260907-btrfs-folio-conversions-v2-2-b5fe79f7607b@columbia.edu>
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
In-Reply-To: <20260907-btrfs-folio-conversions-v2-2-b5fe79f7607b@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/8 05:49, Tal Zussman 写道:
> This removes the last btrfs callers of find_or_create_page(),
> find_lock_page(), SetPageDirty(), ClearPageDirty(), and get_page(), and
> 15 calls to compound_head(). The folio lookups return an ERR_PTR instead
> of NULL, so adjust the error handling.
> 
> Update the comments and test messages accordingly.
> 
> The test still works in PAGE_SIZE units, which relies on the test inode
> never getting large folios, so assert that the folios are order-0 where
> that matters.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu> ---
>   fs/btrfs/tests/extent-io-tests.c | 99 +++++++++++++++++++++-------------------
>   1 file changed, 51 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index 6eb55bfb2bd4..e7aa8bc04706 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -112,8 +112,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	struct btrfs_root *root = NULL;
>   	struct inode *inode = NULL;
>   	struct extent_io_tree *tmp;
> -	struct page *page;
> -	struct page *locked_page = NULL;
> +	struct folio *folio;
> +	struct folio *locked_folio = NULL;
>   	/* In this test we need at least 2 file extents at its maximum size */
>   	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
>   	u64 total_dirty = 2 * max_bytes;
> @@ -152,23 +152,26 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	btrfs_extent_io_tree_init(NULL, tmp, IO_TREE_SELFTEST);
>   
>   	/*
> -	 * First go through and create and mark all of our pages dirty, we pin
> -	 * everything to make sure our pages don't get evicted and screw up our
> +	 * First go through and create and mark all of our folios dirty, we pin
> +	 * everything to make sure our folios don't get evicted and screw up our
>   	 * test.
>   	 */
>   	for (pgoff_t index = 0; index < (total_dirty >> PAGE_SHIFT); index++) {
> -		page = find_or_create_page(inode->i_mapping, index, GFP_KERNEL);
> -		if (!page) {
> -			test_err("failed to allocate test page");
> -			ret = -ENOMEM;
> +		folio = __filemap_get_folio(inode->i_mapping, index,
> +				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
> +		if (IS_ERR(folio)) {
> +			test_err("failed to allocate test folio");
> +			ret = PTR_ERR(folio);
>   			goto out;
>   		}
> -		SetPageDirty(page);
> +		/* The ranges below assume page sized folios. */
> +		ASSERT(folio_order(folio) == 0);
> +		folio_set_dirty(folio);
>   		if (index) {
> -			unlock_page(page);
> +			folio_unlock(folio);
>   		} else {
> -			get_page(page);
> -			locked_page = page;
> +			folio_get(folio);
> +			locked_folio = folio;
>   		}
>   	}
>   
> @@ -179,8 +182,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	btrfs_set_extent_bit(tmp, 0, sectorsize - 1, EXTENT_DELALLOC, NULL);
>   	start = 0;
>   	end = start + PAGE_SIZE - 1;
> -	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
> -					 &end);
> +	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (!found) {
>   		test_err("should have found at least one delalloc");
>   		goto out_bits;
> @@ -191,8 +193,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   		goto out_bits;
>   	}
>   	btrfs_unlock_extent(tmp, start, end, NULL);
> -	unlock_page(locked_page);
> -	put_page(locked_page);
> +	folio_unlock(locked_folio);
> +	folio_put(locked_folio);
>   
>   	/*
>   	 * Test this scenario
> @@ -201,17 +203,18 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	 *           |--- search ---|
>   	 */
>   	test_start = SZ_64M;
> -	locked_page = find_lock_page(inode->i_mapping,
> -				     test_start >> PAGE_SHIFT);
> -	if (!locked_page) {
> -		test_err("couldn't find the locked page");
> +	locked_folio = filemap_lock_folio(inode->i_mapping,
> +					  test_start >> PAGE_SHIFT);
> +	if (IS_ERR(locked_folio)) {
> +		test_err("couldn't find the locked folio");
> +		locked_folio = NULL;
>   		goto out_bits;
>   	}
> +	ASSERT(folio_order(locked_folio) == 0);
>   	btrfs_set_extent_bit(tmp, sectorsize, max_bytes - 1, EXTENT_DELALLOC, NULL);
>   	start = test_start;
>   	end = start + PAGE_SIZE - 1;
> -	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
> -					 &end);
> +	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (!found) {
>   		test_err("couldn't find delalloc in our range");
>   		goto out_bits;
> @@ -223,12 +226,12 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	}
>   	if (process_folio_range(inode, start, end,
>   				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
> -		test_err("there were unlocked pages in the range");
> +		test_err("there were unlocked folios in the range");
>   		goto out_bits;
>   	}
>   	btrfs_unlock_extent(tmp, start, end, NULL);
> -	/* locked_page was unlocked above */
> -	put_page(locked_page);
> +	/* locked_folio was unlocked above */
> +	folio_put(locked_folio);
>   
>   	/*
>   	 * Test this scenario
> @@ -236,16 +239,17 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	 *                    |--- search ---|
>   	 */
>   	test_start = max_bytes + sectorsize;
> -	locked_page = find_lock_page(inode->i_mapping, test_start >>
> -				     PAGE_SHIFT);
> -	if (!locked_page) {
> -		test_err("couldn't find the locked page");
> +	locked_folio = filemap_lock_folio(inode->i_mapping,
> +					  test_start >> PAGE_SHIFT);
> +	if (IS_ERR(locked_folio)) {
> +		test_err("couldn't find the locked folio");
> +		locked_folio = NULL;
>   		goto out_bits;
>   	}
> +	ASSERT(folio_order(locked_folio) == 0);
>   	start = test_start;
>   	end = start + PAGE_SIZE - 1;
> -	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
> -					 &end);
> +	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (found) {
>   		test_err("found range when we shouldn't have");
>   		goto out_bits;
> @@ -265,8 +269,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	btrfs_set_extent_bit(tmp, max_bytes, total_dirty - 1, EXTENT_DELALLOC, NULL);
>   	start = test_start;
>   	end = start + PAGE_SIZE - 1;
> -	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
> -					 &end);
> +	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (!found) {
>   		test_err("didn't find our range");
>   		goto out_bits;
> @@ -278,36 +281,36 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	}
>   	if (process_folio_range(inode, start, end,
>   				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
> -		test_err("pages in range were not all locked");
> +		test_err("folios in range were not all locked");
>   		goto out_bits;
>   	}
>   	btrfs_unlock_extent(tmp, start, end, NULL);
>   
>   	/*
> -	 * Now to test where we run into a page that is no longer dirty in the
> +	 * Now to test where we run into a folio that is no longer dirty in the
>   	 * range we want to find.
>   	 */
> -	page = find_get_page(inode->i_mapping,
> -			     (max_bytes + SZ_1M) >> PAGE_SHIFT);
> -	if (!page) {
> -		test_err("couldn't find our page");
> +	folio = filemap_get_folio(inode->i_mapping,
> +				  (max_bytes + SZ_1M) >> PAGE_SHIFT);
> +	if (IS_ERR(folio)) {
> +		test_err("couldn't find our folio");
>   		goto out_bits;
>   	}
> -	ClearPageDirty(page);
> -	put_page(page);
> +	ASSERT(folio_order(folio) == 0);
> +	folio_clear_dirty(folio);
> +	folio_put(folio);
>   
>   	/* We unlocked it in the previous test */
> -	lock_page(locked_page);
> +	folio_lock(locked_folio);
>   	start = test_start;
>   	end = start + PAGE_SIZE - 1;
>   	/*
> -	 * Currently if we fail to find dirty pages in the delalloc range we
> +	 * Currently if we fail to find dirty folios in the delalloc range we
>   	 * will adjust max_bytes down to PAGE_SIZE and then re-search.  If
>   	 * this changes at any point in the future we will need to fix this
>   	 * tests expected behavior.
>   	 */
> -	found = find_lock_delalloc_range(inode, page_folio(locked_page), &start,
> -					 &end);
> +	found = find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (!found) {
>   		test_err("didn't find our range");
>   		goto out_bits;
> @@ -319,7 +322,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   	}
>   	if (process_folio_range(inode, start, end, PROCESS_TEST_LOCKED |
>   				PROCESS_UNLOCK)) {
> -		test_err("pages in range were not all locked");
> +		test_err("folios in range were not all locked");
>   		goto out_bits;
>   	}
>   	ret = 0;
> @@ -328,8 +331,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
>   		dump_extent_io_tree(tmp);
>   	btrfs_clear_extent_bit(tmp, 0, total_dirty - 1, (unsigned)-1, NULL);
>   out:
> -	if (locked_page)
> -		put_page(locked_page);
> +	if (locked_folio)
> +		folio_put(locked_folio);
>   	process_folio_range(inode, 0, total_dirty - 1,
>   			    PROCESS_UNLOCK | PROCESS_RELEASE);
>   	iput(inode);
> 

