Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D1823C8A0
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 06:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780812792; cv=none; b=dL2Z2yXeDI+qtAU1JRm8Gk/xn1/+wCTCGpB3FgvfcolB6fJh+WBvceqZjpyeM4Wp2wG9Gz5tdvkmoJIiUzagd6X22XWkC+8TC1ggoF8UpYG0OlPdhAjntuNxM9zKRyrgWa9dgdvJbk68fXYbnvsTkoBXqaTPpuywfxfSkd6Ac6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780812792; c=relaxed/simple;
	bh=jvMXJaUCY1lhUfm+lj7odC2dcaHZliPvX+MnctoTqzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tn8boJ2VsZsk293YN6BOCEk2M9/LVtqayjPty32hyJsSCKd1WRn6PVtojMSQOZKDLOC0IGcEsgxE6BUydgI/IQJB9uDpPNu2Do96oAi+qRq+GD1uVXraCiVyOqTncWj1HWvtboGmOSdRCiTe3XEaqdSq81rfd8sUJlVAdt4hRbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PNyv3enB; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PNyv3enB"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bec49f7e35eso429146966b.2
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jun 2026 23:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780812789; x=1781417589; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mS+/QNmpV1dtPFXbbW7XLL/rLwGB5ryRDONzWsMOPYs=;
        b=PNyv3enBSRkHCuuzieOOZ4aH5URpIejGlKiEK3Q88Gr2rJ0oqpjeifeBuOBUZhhVYs
         q4Q2WSjF1JJATMdEE5B3PMn0+TCYLUYssEInze1TVfbe/HHdGoX/jkj8CLSm9XJ01HeI
         JBa2v5WyoVlQelXiSY+3IWFklarAHf3GfcwdXl/Vpf+zt3l5G/9o0ETaY+WU4GLPCAjY
         A806FrdQYK3+Gr2kj/JElTE7CJCRwhkWnvOPQuoSsHeJ732pT7CtV1EDTOskZNSbURc3
         LPOUpYXEXULJGIvXYvm1SZGHa6/tWDtTb7WiOCIlzr/v83/J13qpoMfoZYmo+bCv+hPb
         MAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780812789; x=1781417589;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mS+/QNmpV1dtPFXbbW7XLL/rLwGB5ryRDONzWsMOPYs=;
        b=UnxDEQI0C+J1jyCwl7ZuIzzuFHoZNXmJ1YepN34RZNZ0eTRoVpLO2qKRQKRlmrtmWN
         sPF4X37o67RCgP6a8VMrWxkJYXtrMUGi1+1JRxQuffDSbATRIsoPZ78RMTZ7wkyAS2Q8
         SeyRsIIGMdV30ZEuymrGy2hQ6v3xIgJWPx00qvAs9v3VgJg3zCAkh8CqDvsW08dwvnYc
         eqotgHhlcEnaHr6b3WFYeqd3qTuCVAcni9aE9uKcnKfDSJ10xuo0CJX9Ir6TVg9w/jAz
         viHrpmU3MhxTjmrQpqFDU7A21lI30zW/2KnwNJpty/wSOv45KT9fxtEFm4zhw3O5gd2O
         3kLQ==
X-Forwarded-Encrypted: i=1; AFNElJ+2nqeyrsf9FsiG8F+o7fqPEDjwrTZ9j98Ixfpip8jcXN9PPJxwr/s0f+BbvW1Kqhcm1tqFitgega4xgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRE9+haIroz8EZKp8qxDj6TQ1bANnfTlE5zCRa34Qbo+E79hdN
	8CkJys0UtuN7cM515ja/JFU5kr4w7KK18pSYFXwT2kEkGCDHZg7jrKyNqK3lORmFO6Q=
X-Gm-Gg: Acq92OEblPTHcjM/3VXM+qwWIHyZtmwPNjSseAQhAe0KE2DYI29HiCe3BQHMu+sV/8b
	jQy+ACVY2GNEtJQAdVuLuM467Ylqo/V4/QanPIV+w7twrM0UYbzXui5w2h7to0ax4zSYBKmRKtH
	Evf1WOKhlXbTwLbC199UlhgLj0QCxcQtnbYTQjXTFuSr4FxTmMhIFHZ1DGHlqKvDZujHrqPvBZ3
	n1SZmrwVza/DkdN3Ezsm3cVYYyenWu0RvyBA7iQTVsrN88CtVIuX6T5w32qt+hKGk95Ao/ocmT/
	HN3YX1bcWtUxOGrIIbkk9YFcleT5KV8fLu8fRCuAZgh0zZ/qXedPe1dnWSBgo9a84mJJUbeqL2C
	1y49FWEJFc7nWhMT4ny5OYvA0pi4pbi0t8rkOsb2KyPFbZxqa0sS/U7yZ3Z/CRAmTOXRFnG61LT
	YBrmv2eX4fMHlYO6QxukePLpbnk4QE4aebmMHwBI2RRjPHOsVsvshCgwVd2TzWU+G6IHtaGIQHB
	5uDXqfNdmnCishElSbml0HtuZ6WCNd/R7ZBP+7dwCu5NVwZcTbmux3uzQ==
X-Received: by 2002:a17:907:986:b0:bed:5774:7c17 with SMTP id a640c23a62f3a-bf3701806abmr491817566b.5.1780812789067;
        Sat, 06 Jun 2026 23:13:09 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf8284dsm14033699a91.4.2026.06.06.23.12.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Jun 2026 23:13:08 -0700 (PDT)
Message-ID: <e8cf9678-f746-4184-9f0c-cb3415845537@suse.com>
Date: Sun, 7 Jun 2026 15:42:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: lzo: reject compressed segment that overflows
 the compressed input
To: Weiming Shi <bestswngs@gmail.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <clm@fb.com>
Cc: Xiang Mei <xmei5@asu.edu>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260607052511.4131138-3-bestswngs@gmail.com>
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
In-Reply-To: <20260607052511.4131138-3-bestswngs@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/7 14:55, Weiming Shi 写道:
> lzo_decompress_bio() validates each on-disk segment length seg_len only
> against the workspace cbuf size, not against the compressed input size
> (compressed_len, the total folio bytes of the bio).  A crafted extent can
> carry a segment whose seg_len passes the cbuf check but runs past the end
> of the bio, so copy_compressed_segment() walks off the last folio:
> get_current_folio() then returns the NULL folio from bio_next_folio(), and
> with CONFIG_BTRFS_ASSERT disabled (default) folio_size(NULL) faults.
> 
>   BUG: KASAN: null-ptr-deref in lzo_decompress_bio (fs/btrfs/lzo.c:383)
>   Read of size 8 at addr 0000000000000000 by task kworker/u8:1/29
>   Workqueue: btrfs-endio simple_end_io_work
>    kasan_report (mm/kasan/report.c:590)
>    lzo_decompress_bio (fs/btrfs/lzo.c:383)
>    end_bbio_compressed_read (fs/btrfs/compression.c:1065)
>    btrfs_bio_end_io (fs/btrfs/bio.c:135)
>    btrfs_check_read_bio (fs/btrfs/bio.c:180 fs/btrfs/bio.c:285)
>    simple_end_io_work
>    process_one_work
>    worker_thread
> 
> Reject any segment whose payload would extend beyond compressed_len before
> copying it, treating it as corruption like the other on-disk validation
> failures in this function.
> 
> Fixes: a6e66e6f8c1b ("btrfs: rework lzo_decompress_bio() to make it subpage compatible")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And pushed to for-next.

Thanks,
Qu

> ---
> v2:
>    - Return -EUCLEAN instead of -EIO to match lzo_decompress() (Qu Wenruo).
>    - Emit a btrfs_err() message when rejecting the segment (Qu Wenruo).
> 
>   fs/btrfs/lzo.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 2de18c7b5..6e4aa2285 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -491,6 +491,17 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
>   			return -EIO;
>   		}
>   
> +		/* The segment must not extend beyond the compressed input. */
> +		if (unlikely(cur_in + seg_len > compressed_len)) {
> +			struct btrfs_inode *inode = cb->bbio.inode;
> +
> +			btrfs_err(fs_info,
> +			"lzo segment overflows compressed input, root %llu inode %llu offset %llu cur_in %u len %u compressed len %u",
> +				  btrfs_root_id(inode->root), btrfs_ino(inode),
> +				  cb->start, cur_in, seg_len, compressed_len);
> +			return -EUCLEAN;
> +		}
> +
>   		/* Copy the compressed segment payload into workspace */
>   		copy_compressed_segment(cb, &fi, &cur_folio_index, workspace->cbuf,
>   					seg_len, &cur_in);

