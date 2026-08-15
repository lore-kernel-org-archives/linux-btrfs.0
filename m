Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757EE1ADC83
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786832037; cv=none; b=FTKpE9OgKOuETSvrhl2r/cylOICAc5x24rp8Pnx5VCCKgy1w0DkSaQC8UJ+8EZEzvEzZ0fE5SsCawRfOL7T/GOZhxPSElymZlURDXaRjO70utTnlGjoLGcH9Gf5G/CeOffzwtjJtS8JspBpliKnzzl7+kh8GOPqMt+FE9JqQk4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786832037; c=relaxed/simple;
	bh=yC+9t54aOBgqC4lyPncd6+8EBeBgBj9Ovh+FFUbLu0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nzxphqlgoSuFniCF/cb3Xzb04nKfRpkFRnOhBbADiYpC18JYJxUfFD97gK2KcWQB7dOtu1IyG2cB8o3ph7+572Wd+Q+b6bR6Z1KPcL8rUu/gs0NOsxkEf2sxBvurk549iZMH6BG7Dg/8E+V2YGXLCwZwNbpD1Q/QtdNXlVH6sek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BCGfSTnd; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BCGfSTnd"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4998590d392so22841535e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2026 15:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786832034; x=1787436834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SQH9rwnwKtQzw9S7J/FfJN6Cna39wQTz9LRJ8N51dGs=;
        b=BCGfSTndJZkjg+8djlqd7D3JOI04vXZq6wysWij7Lh4sHol/U964iInVH9DhVvFh0T
         Q0VXb65r1cqfTR6b+CCo3jv+GzH5KrPiGfdrMfGUeeF+zS5+SX7/S87OIcQ6UqYtUS0c
         KT//WU/XTzytAThTRf/YflG0oVMCBcXdDbAf8muklWWs7cTZ5v4AvUOZwg23dPYaj9yX
         sE9rAdQDtsNQiHdFDQw2wQ1D/Tn9vai5dxFp/EgM+3xkqiOk1KQgrkqF0V3BkahMKlC7
         TrUrj0+UWPc9nUP8XaoCVIu2e5WvjQVXE3UolmPc0+8nKYU1aMC6GSAA+dmY0kDdy5Tz
         qFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786832034; x=1787436834;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SQH9rwnwKtQzw9S7J/FfJN6Cna39wQTz9LRJ8N51dGs=;
        b=cdbSUFDi6lRBO2xX8e8IpO6UoCe/Qrl4VC6aBZlucR7KeNtlsLH4fiEy6e1LOIAsjI
         M05PKT499tXJmUnZbiP/xa3ye5xDCzU7Xm0oVYxIdBMUGPGhIL1Dw89u/IUf7zkdxMIy
         xulm706H5tvvqp+/SQqSnn8tckpesN13G9/iWR7jjq7a++pLn4wn1bOrfFghNf42ecyR
         iTdtkxuEXUlvU2Fqz3NNix397zfDwvXRY3wLMp7G8sCKyRH6kHgJw0ZhaYtZQcZ/m+jH
         5l7wnw/PIivfaHyyNshLZlST/BcmBWCaC1n38Y5SXhq4D6umHowoZ8B+av+0g1kdEpwk
         Dl8w==
X-Forwarded-Encrypted: i=1; AHgh+Rr8r6p4RDdiHiIlU+xqtpULIwgI+sKi0tSeIE9DTYHmP4hyl7SQZpsevjI2bW8J9HjmQ5d2BSzEhQpm/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzP+EBv8bOk8by/DZG0/h6LO7FH20UgQ6DMWtvcNRZk0dPmoK9m
	r/JLfdR2Q43k4ZsNTvyY5ThnYyFX0hWAIga1oWfAOiKbPbv5UkNW+jfV6hUli5an+nI=
X-Gm-Gg: AR+sD12mKS7UKnU0lYWW3E3FKRoCxPz9Ik4l7Wpny1BbkTuWzF0TpDBIyjSXa1vaHWR
	3ZP7vySEkmKD07HV3VDKu2FQRCHqGCS6SA9ZHDVmdpv9f4eQKqVR1gFGD3A5aQpEZ1b9vW6Bki+
	UVbOrKb6y1Vum5H+i320GrQwZ/vanHL5JOEafUi5MZzgGZDL3XhdUvVXZ6m8e5sEFaK+uG/MxPb
	mcecpdtKVzGByV+8pkfBPOVkoJun05Y91qveKpGRguZzgcpVPse74wE1p64umMD7BdlHRWgTlRD
	T696eAFJ0U9bQmG3d2DDjUOa3b+nwzDvsGO0VugBWm67vJ8CuPiYey+Ojjo79hdYOsbAfxBHlkQ
	DJiUuLLWD/XHcunmWf9Ypawg5uCxthiRr2kxu18TxT+slJVRTqL85YytBlO94mEE1HUwv7MuX4x
	WUZ8svRclyY7Qq0ivTmk7fS3MZ4YxNxg3BnrrMO6EcP2gMIYm05PS5PQ==
X-Received: by 2002:a05:600c:1385:b0:499:5220:db3d with SMTP id 5b1f17b1804b1-499879a50afmr180316475e9.16.1786832033696;
        Sat, 15 Aug 2026 15:13:53 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320d66e52d2sm19387670eec.13.2026.08.15.15.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 15:13:52 -0700 (PDT)
Message-ID: <d0cbcb52-5f28-49c6-98f0-85ccce33d845@suse.com>
Date: Sun, 16 Aug 2026 07:43:47 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: scrub: report the failing sector's address, not
 the stripe base
To: "James C. Owens" <jamesowens@optonline.net>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260814162405.1434693-1-jamesowens@optonline.net>
 <20260815153416.138869-1-jamesowens@optonline.net>
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
In-Reply-To: <20260815153416.138869-1-jamesowens@optonline.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/16 01:04, James C. Owens 写道:
> scrub_stripe_report_errors() iterates over the sectors of a stripe, but
> every message it emits passes stripe->logical, the address of the first
> sector of the 64KiB stripe, rather than the address of the sector being
> reported. The physical address is likewise computed once, before the
> loop, from stripe->logical.
> 
> This matters because scrub_print_common_warning() uses that logical
> address for the backref walk which produces the "root %llu inode %llu
> offset %llu ... (path: ...)" part of the message. As the address is
> always the stripe base, the reported root/inode/offset/path can identify
> a different file from the one whose sector actually failed.
> 
> A 64KiB stripe routinely spans several extents belonging to unrelated
> files. On the machine where this was found, the stripe at logical
> 0x17D9380000 holds four sectors of /usr/share/plasma/emoji/bg.dict, then
> a file inside a docker volume, then sectors referenced only by
> snapshots. Every error anywhere in that stripe is attributed to bg.dict.
> 
> The effect is visible statistically: across ten months and four kernel
> series that machine logged 81 distinct flagged logical addresses, and
> every one of them is exactly 64KiB aligned. Since BTRFS_STRIPE_LEN is
> 64KiB and stripe->logical is stripe aligned by construction, real
> failures distributed across sectors could not produce that.
> 
> Report the address of the sector actually being examined. Adding the
> sector offset to the physical address is valid because BTRFS_STRIPE_LEN
> is the unit contiguous on a single device for every profile, so a stripe
> never crosses a device boundary.
> 
> Fixes: 0096580713ff ("btrfs: scrub: introduce error reporting functionality for scrub_stripe")
> Signed-off-by: James C. Owens <jamesowens@optonline.net>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> ---
> v2:
>   - Regenerate the patch with git format-patch. v1 was produced with plain
>     diff(1) and so lacked the diffstat, the "diff --git" header, the index
>     line and the function context in the hunk headers. Thanks Qu for catching
>     it; no code change.

Great that the mystery got solved!

The v1 version is already pushed to for-next with involved tags added.
So nothing to worry about.

Thanks,
Qu

>   - Add the Fixes: tag Qu supplied.
>   - Carry Qu's Reviewed-by.
> 
>   fs/btrfs/scrub.c | 24 ++++++++++++++----------
>   1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index d2f7ac5b6e96..09b6003d3019 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1041,6 +1041,10 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
>   
>   skip:
>   	for_each_set_bit(sector_nr, &extent_bitmap, stripe->nr_sectors) {
> +		const u64 sector_logical = stripe->logical +
> +			((u64)sector_nr << fs_info->sectorsize_bits);
> +		const u64 sector_physical = physical +
> +			((u64)sector_nr << fs_info->sectorsize_bits);
>   		bool repaired = false;
>   
>   		if (scrub_bitmap_test_bit_is_metadata(stripe, sector_nr)) {
> @@ -1069,12 +1073,12 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
>   			if (dev) {
>   				btrfs_err_rl(fs_info,
>   		"scrub: fixed up error at logical %llu on dev %s physical %llu",
> -					    stripe->logical, btrfs_dev_name(dev),
> -					    physical);
> +					    sector_logical, btrfs_dev_name(dev),
> +					    sector_physical);
>   			} else {
>   				btrfs_err_rl(fs_info,
>   			   "scrub: fixed up error at logical %llu on mirror %u",
> -					    stripe->logical, stripe->mirror_num);
> +					    sector_logical, stripe->mirror_num);
>   			}
>   			continue;
>   		}
> @@ -1083,30 +1087,30 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
>   		if (dev) {
>   			btrfs_err_rl(fs_info,
>   "scrub: unable to fixup (regular) error at logical %llu on dev %s physical %llu",
> -					    stripe->logical, btrfs_dev_name(dev),
> -					    physical);
> +					    sector_logical, btrfs_dev_name(dev),
> +					    sector_physical);
>   		} else {
>   			btrfs_err_rl(fs_info,
>   	  "scrub: unable to fixup (regular) error at logical %llu on mirror %u",
> -					    stripe->logical, stripe->mirror_num);
> +					    sector_logical, stripe->mirror_num);
>   		}
>   
>   		if (scrub_bitmap_test_bit_io_error(stripe, sector_nr))
>   			if (__ratelimit(&rs) && dev)
>   				scrub_print_common_warning("i/o error", dev, false,
> -						     stripe->logical, physical);
> +						     sector_logical, sector_physical);
>   		if (scrub_bitmap_test_bit_csum_error(stripe, sector_nr))
>   			if (__ratelimit(&rs) && dev)
>   				scrub_print_common_warning("checksum error", dev, false,
> -						     stripe->logical, physical);
> +						     sector_logical, sector_physical);
>   		if (scrub_bitmap_test_bit_meta_error(stripe, sector_nr))
>   			if (__ratelimit(&rs) && dev)
>   				scrub_print_common_warning("header error", dev, false,
> -						     stripe->logical, physical);
> +						     sector_logical, sector_physical);
>   		if (scrub_bitmap_test_bit_meta_gen_error(stripe, sector_nr))
>   			if (__ratelimit(&rs) && dev)
>   				scrub_print_common_warning("generation error", dev, false,
> -						     stripe->logical, physical);
> +						     sector_logical, sector_physical);
>   	}
>   
>   	/* Update the device stats. */
> 
> base-commit: 15ef2f78c49d20d53ec7c0f1c9b40b02e089f2d6

