Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293E438B135
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 22:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781563173; cv=none; b=e4NhIoi2f2Ovuf4yYQjfva0VVT/5laT/cjGsKE/Q6eVhphC7rq/nvH1kOg82u3ao2hijzuaWF2a7czqTWzWx2xFnAtfQWrdl5GeLY1ziyy4+Ub0V5dQ3btLklwNH79HzYfyqPloD181vIHs5lKPLSpgF2ttRuCk8MCwnteDQAMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781563173; c=relaxed/simple;
	bh=n4l3O9TGF1RT4mpbVeIkevCRv5aBRbiGDmkf0LzAIxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=quevmFyNh+OETnMcU7sDdml3pv9n7F2TYM56FZMHT4cUqEH2Pu0gy0TWHHjRUpkx1AraeFKaJ5xGulXZXzsJAWufnJ/Udbg+EM5HVKxtUD5g0Hcs/kqbRr2ufO+qdtSGYSAPYG7irYZ5c1JUY21EqYhNwebKXaPmLmPES8pbZjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HH+RbAZV; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HH+RbAZV"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so38847715e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 15:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781563170; x=1782167970; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=meO0TV1GQdxcvKDdioA55HfdLlzDFSIW+ckZ6EKtq5I=;
        b=HH+RbAZVUlaQMdijd3+IBbIb3RttQXa2ZhAcN+Xo+Mt9jmiDd7z2bWdXUEYM7jPtfD
         2vftukiMXEsWKwNXWXS9klyz4fvcsOkmCauZ+VttdVhTiL4SDsd1U86s+VTrJo/juUiT
         cPaR8r4uMRSIAjgLXhXgsBMF27/WrWU1xtI0J97tYf3Zm60SuMrwjnJwIowysezZqeI2
         afEgbDeyB3C8DlnL5zLSnxKQazTUVro3sDX+vENHnkd0U0NWeTylkk0EUhaH6fwEjU/2
         H5HaO0h8xmz2IYSKSO23yhvZZF/kWL3r9IUkBFJyEqIe5H76nB+WnEDeOf3KLLVtOSd6
         b1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781563170; x=1782167970;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=meO0TV1GQdxcvKDdioA55HfdLlzDFSIW+ckZ6EKtq5I=;
        b=pDrFTO+w17ORTeY5+nl9YAisYXciysFkAjAB1i8gFgVsIb780XFHLNF8vAqUTbokKx
         cffJ+nUy5wf4A0DVk9zGNxaQ9JW5LvGHwg/m9mSIvY8ug+h2CBVk+nviJyjEnh/pxFcz
         OBeAqK581pmfH7yvbJMZ26z9jVsUABt4UktBIXHBEFEE/gQsnz3rFpVzL+vUV6Fz+zhR
         r9yX7HK8kgQ4iGMJ35RAGYUnz46SN5za1DkWMCszdh/8ZgF0EO1MAU1Y6OrohGEWLIBN
         9QIWNcq1gGgLc3y6R0osujdc+q7V1G7ix1S30+X1qIIBVzD15BckNSzdnzOuzuIo4bab
         ZYyQ==
X-Forwarded-Encrypted: i=1; AFNElJ88xZnWf8XCQN54icLFPIXyrwrUcNE5fvdA4y2CfaOG5G4ohog3aL2/SYOPHlgvnbEJ55HYjyB2qJVR5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZQYTvpcvbj0eN/V1ok2IGcmgkVXBE0yTHLyI/vAppDmk6AWZp
	jAtVSssYw/UNIJYnonD7StQd7S5jw3XA0wO9Vcf9kkTnx469M7ydyWsjRXfOHuPRP+Q=
X-Gm-Gg: Acq92OGX3w1UTCyoXtO0gPnLW2C4MVpJqtZknXVa6UEcQ/qwFv5FrTvqwxfxV1NOFII
	nG6OoY0F0Kyn+uLeCBWRFkamhFe9N5S0nAvBJk1l55S8VjzqRzPQffl4lyILrtMq+W9c2j0M0tW
	6cU3EllQ62kdyWpUVZHKttAmKUmH/McGkqVF+BJHG6GJhJlaI6DwMmM/4+PC/LzjPRaOcmlIdPl
	PQqf+tW7DzdIUOL3p4TD7fg2+VBg1y2zIVaRxJqS9ijafrYU9sd3BUfE8z/JKObuOTeclCZ6iVS
	HNIpaIoo6ChVAnlU6bsg9wFFHIvuDkw8MkKScaBM5HggbhUoRN7bvMJfRdw4LM+drbOc55GLtr6
	L9RLhJzyCppHZhuUQuJbVG93gQPxzwfBaveIrmUdQzH7FEQcrz3ZhqcpkCHoAiLBXkfRzFBShhK
	h0wba2KzyBt1mNmNVpFGo1aV6neXO+S4amQRT4ggsVrnfkAf58lXirchJS1xMV6WLovy0rFY5bO
	Hi9r1WxC4yfNDbSqxLtJ/SjqSpADmfO4EEbO8ASC7t6dQ==
X-Received: by 2002:a05:600c:4a12:b0:490:bf3d:c7de with SMTP id 5b1f17b1804b1-4922faf9363mr12188025e9.10.1781563170433;
        Mon, 15 Jun 2026 15:39:30 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521ae039sm648501a91.1.2026.06.15.15.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 15:39:28 -0700 (PDT)
Message-ID: <3eed757c-d650-45fd-80a2-735399ff4f99@suse.com>
Date: Tue, 16 Jun 2026 08:09:18 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: release extent lock per folio in readahead
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <1cdab9f1329c31c69b3d9ef6ec19977004d1bc57.1781545249.git.boris@bur.io>
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
In-Reply-To: <1cdab9f1329c31c69b3d9ef6ec19977004d1bc57.1781545249.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/16 03:10, Boris Burkov 写道:
> In Meta production, we have observed a large number of hosts running
> kernels newer than 6.13 which hit hung tasks on
> btrfs_read_folio()->lock_extents_for_read(). Looking through the history
> in this codepath reveals an interesting history.
> 
> in 6.12, we merged
> commit ac325fc2aad5 ("btrfs: do not hold the extent lock for entire read")
> which holds the extent lock very narrowly while looking up the
> extent_map. However, this proved to introduce a serious race with DIO
> writes which was fixed in 6.14 with
> commit acc18e1c1d8c0 ("btrfs: fix stale page cache after race between readahead and direct IO write")
> 
> That latter fix subtly changed the extent unlock point from the pre-6.12
> regime. In 6.11, each read endio unlocked the extent it finished
> reading, but in 6.14, the extent is locked/unlocked as a unit around the
> entire readahead loop, while the individual folios are still unlocked as
> the endios finish. This is mostly the same behavior, as all successful
> reads will populate the page cache, so subsequent reads won't enter
> btrfs and hit the extent lock. But in the case where the readahead
> fails, perhaps because of a memory allocation failure doing compressed
> reads, the page will not be brought up to date and a later read of an
> overlapping range *will* block on the extent lock.
> 
> Why is this a problem?
> 
> On sufficiently large loaded systems, I have observed that direct
> reclaim can run for minutes. Given that, consider two tasks on such a
> system reading an overlapping range of a compressed file:
> 
>    Task 1 locks the whole range and starts to read. Some allocation for
>    the compressed read for folio F fails and we carry on while holding the
>    extent lock for the full range.
> 
>    Task 2 wants to read F, which is not uptodate and in page cache, so it
>    blocks on the extent lock held by Task 1.
> 
>    Task 1 keeps getting stuck in direct reclaim (likely, we already
>    supposed an allocation failure above)
> 
>    Task 2 stays blocked on the extent lock the whole time.
> 
> If you consider the effects of readahead_expand and imagine a file with
> a 128k compressed extent followed by many smaller compressed extents,
> you can imagine that the expanded window will result in subsequent reads
> hitting many extents (128k/4k = 32) per lock window in the worst case.
> 
> The system likeley wouldn't be all that healthy anyway, so this is
> likely not a critical improvement, but it does alleviate this one source
> of stress and one thread's slowdown escalating to others.
> 
> To bring this behavior back to the old model, we should unlock the
> extent at each loop of the readahead loop rather than in one shot at the
> end. This allows such overlapping reads to proceed as they should.
> Writes are fine because either the page has already been read and has an
> appropriate state in the page cache to be invalidated (or not uptodate)
> or it is still-to-be-read and the extent lock is still held protecting
> it.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   fs/btrfs/extent_io.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index ce9aa0f6bc35..e0d24e69441a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2745,12 +2745,23 @@ void btrfs_readahead(struct readahead_control *rac)
>   	struct fsverity_info *vi = NULL;
>   
>   	lock_extents_for_read(inode, start, end, &cached_state);
> +	/* We don't use cached state for a bulk unlock, just free it. */
> +	btrfs_free_extent_state(cached_state);
>   	if (start < i_size_read(vfs_inode))
>   		vi = fsverity_get_info(vfs_inode);
> -	while ((folio = readahead_folio(rac)) != NULL)
> -		btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
> +	while ((folio = readahead_folio(rac)) != NULL) {
> +		/*
> +		 * Read start and end before btrfs_do_readpage(). It unlocks the
> +		 * folio, so our reference might not be valid after.
> +		 */
> +		const u64 folio_start = folio_pos(folio);
> +		const u64 folio_end = folio_start + folio_size(folio) - 1;
>   
> -	btrfs_unlock_extent(&inode->io_tree, start, end, &cached_state);
> +		btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
> +		/* Only unlock the range we locked, even if readahead expands. */
> +		if (folio_start >= start && folio_end <= end)
> +			btrfs_unlock_extent(&inode->io_tree, folio_start, folio_end, NULL);
> +	}
>   
>   	if (em_cached)
>   		btrfs_free_extent_map(em_cached);

