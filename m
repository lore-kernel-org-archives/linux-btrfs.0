Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF616357D17
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 21:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781298507; cv=none; b=GFuyBb1/lHO/8tld/gGSIDYymVKQo/+srzN2biz0ABX4XWXLc/47IlaXH9ZP7rn12GKfQuA1JPNJ64QV3SrJ3Al1FuYOri3YQ91DNjOVSDLjHX/WPTAn4F5+U9kSAjKhACQkCkJMAfhanP98GrESaZFLFkdqyGIu6cMYlUn7dJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781298507; c=relaxed/simple;
	bh=VY164YO0mzD+ob9yK0oK3XLEIS+FCaqiaHBp6bitwc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=scQPwWfUKjdCWaiQoQhjJepby+7OrUPBo0AJyqmWlQCdLm6aLyLUYLcYjOrtV517NGvvwiGHbrzoDQBwmzeIiIqVGvegHKFZdpmjzGr5M3agqgDOx72WoQBUIU1c+PNB9DJewZKcU8mK9y7bi2tD9y0lcfV1m4Nm4C71XM2p0Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WCrkHTup; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WCrkHTup"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4905529b933so14277095e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 14:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781298504; x=1781903304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kO5vZH7BsbWzeaWSO3t8N9r2Ie80oCi8Vi91wyiOJ2I=;
        b=WCrkHTupR0I+PKqBpuwWVQmPAeyuubYNpMMaLEEJMT3X2E9Vk63ieiyoMgt+WgQTnH
         kHWxEu8U2ByuuXyDpiEzDCJxLmoSenMKh5AhdIghpoHx1FEDg4g2b+VsIVSHIcnREHM8
         KSp6j9jW95PyL5hHr+XVG5CLgogxvN6I72i+lxp3iBUSxNVFrV9RWshP2LgZ98E0renn
         MF2basymJ7o64U0kV5BonWtRQ908eQUvHXY/HRxWOmUEK8l/+MThjRBRjw7n2ePZfyt+
         JhtvndmllLRyUIWt2vO3SVLZbxIs5khPVG5fpPI4PVQKc7iDVn5LGqIacmM/+nVR2u4k
         St5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781298504; x=1781903304;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kO5vZH7BsbWzeaWSO3t8N9r2Ie80oCi8Vi91wyiOJ2I=;
        b=nSNXa05ZQIedt0Ss44RyFsD9pljy2K0lWqjuMyJ75lGFr93Z6uYrBt2uYW/Ve1rwdY
         Xq9Xg6B2UfyXx5Iiqtt5mfCICDskR2kJUfXKSiO5OJvx7w5a/114O0N8OnNo/t3LvQ1/
         /8fv8RnEH0Uul9H7sB1iGKnFyrcp+oB4s/FANB/gGP6LNpBsjkCQ/SYFozcYM7i7cQz4
         uM0bPLnPJrY9NYf70B3joRY1AkfbuYlPQGCX29mB189LBNJou2JNIgcbuLM+jT9MrCDV
         UXtLP5QhID6B9b0siXsQ6n9XTgG5/W7ih1Xr56T4YbdWQezgf5+wQCUpsytbOUFu38uW
         F/2g==
X-Forwarded-Encrypted: i=1; AFNElJ/TeHv1dUEjcZzlCmeUXlmvD/ZjMT0gSyJ86ErRPVIVMnMPRCgOYNhTBz8pt3EmCeGLJPGTAhmbm6wFgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHKCUPmnsd02xKnrfyMOhUMIjLm/R+THAYFdVW2vLf3IaUkKi7
	BXBV16MO840saWAV+eCCrmOKHnuvuU0O+1RKihkNhWHuo82+3vd8SrxywiL0UDW6/is=
X-Gm-Gg: Acq92OEuAN85gsdo24drAjDl5G1Hf00PCo1TFBtylpYtoiadC10Xd2/Uhoy1bKzV1bL
	sXw7oZmj5ytOWaCmTx1x6usnMwOOJAyyaExFWKsRJqBeWbeHa6ErkvorOdoZma1BauPd3yAaEXM
	xhBwgWS2gWLJuNulPCmJ0tvSllRHBkx+Lxa6xKiReIyerR/a+vdhqtffiWiJtkSSzNc3TAdCCSY
	+Q+MW3jWfem+CPS1msn/oRELSja4rYeJ9uWlKxmaLDeZJJ/1uOQLthMqMyi2EaoKJoKvC5qqqRs
	sc3UNuUMKcRdfSl7BsYegyREHxbpN6ag0XeoMaWQWnr5eSAX7A7TDv+7kM86lNtxWOt3OMXh+DN
	dtg+f1hGSxLX5J9hejeGYSv16p513OO3d30TbFQ8NKg5wXIr5ZDuXeWs1/qeliAg4EDFP5kGpbO
	CWHvuPGBiicONmEdeWiRxmZzgKiE/WwlG5f8Dm7I9GXYVtSD6TJ7JtYB2WlEjkWU9lKqPsEnt1O
	gAcd1zaroXZbfrd3a4WNtdMEaQ1DX3Ewq8JdFG5OwT9ow==
X-Received: by 2002:a05:600c:5296:b0:492:1e7f:d426 with SMTP id 5b1f17b1804b1-4921e7fd54bmr23449195e9.2.1781298504026;
        Fri, 12 Jun 2026 14:08:24 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37a2668cce5sm4709350a91.16.2026.06.12.14.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 14:08:23 -0700 (PDT)
Message-ID: <e5732981-02ff-45c7-a3de-db5ca519a47f@suse.com>
Date: Sat, 13 Jun 2026 06:38:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: release extent lock per folio in readahead
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <1c59582ab8eba7fabda0422856514019be95dfac.1781282522.git.boris@bur.io>
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
In-Reply-To: <1c59582ab8eba7fabda0422856514019be95dfac.1781282522.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/13 02:12, Boris Burkov 写道:
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
> To bring this behavior back to the old model, we should unlock the
> extent at each loop of the readahead loop rather than in one shot at the
> end. This allows such overlapping reads to proceed as they should.
> Writes are fine because either the page has already been read and has an
> appropriate state in the page cache to be invalidated (or not uptodate)
> or it is still-to-be-read and the extent lock is still held protecting
> it.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>


Just to mention that Sashiko gave a review with level high, which 
doesn't seem to be caused by this patch itself, and seems to be a false 
alert.

Btrfs compressed readahead can expand the RA range, resulting folios 
that has no extent lock at all.
Thus in theory we still can have some folios without extent lock for 
compressed readahead.

But thankfully direct read on compressed extent will always fallback to 
buffered read, thus there is no window to race with direct reads.

Thanks,
Qu
> ---
>   fs/btrfs/extent_io.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 7d604524e83c3..a9517b8cdd601 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2745,12 +2745,21 @@ void btrfs_readahead(struct readahead_control *rac)
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
> +		btrfs_unlock_extent(&inode->io_tree, folio_start, folio_end, NULL);
> +	}
>   
>   	if (em_cached)
>   		btrfs_free_extent_map(em_cached);

