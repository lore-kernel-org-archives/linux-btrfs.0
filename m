Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361432D8385
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 22:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786746060; cv=none; b=YOli5F/OXrkScoCpxF4iDI97nUrDRTNbk/T9OJIkOHC9NnXJFYaOtfbJLNaPV2fm3Mzt4NDT5ZAltysSxb42CWoCE3DJpiUYfmlZgb1ERgq00MiYgBK5mpD2Gho6n4lzb+W3NfcNmayVIvqpyBLJiu6DzSGmPFuoHjafaz7N+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786746060; c=relaxed/simple;
	bh=EcY9eMp2l9swC2XXLBhKkg37CfVEKoNH8tPLezu1zRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qmbvaj84Ys6Nqb2FGIhMuXIiGN6zwzdZoRNFKP11IiMGkLFmwjFwxi9HIJDZsmWDKgenLs5JSCRIWi/A/RlZ4KCGMCI7jXbleGML7ncp5A+jAMg4MdDDpo6SQ0EOESxuYIY9VM8FN/7J80D2DP1+Ya4Nc8k91mO7mVVg+kBoyOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ahaqH3sc; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ahaqH3sc"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495590dde14so20283185e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 15:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786746057; x=1787350857; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9rH3bp69slXb8jLJ0NgtIg1Y4c+emW9+Bm+Di8skZaY=;
        b=ahaqH3sc8gsRL0wbCuyEyGINe7jibQLWyN2b5wl1342cwNq13HH6A9ifAhL81yZDDJ
         5tPmQyn2QBMV8Z7GxxGhSq4E1uc81O2aPDiXApI1kx5MsvY4IjFXNJlgO6xl3q7/XytQ
         Hw7+3Vx22I2S/af1S049ArblMDQVdzOSjtD7YoXGNO6GJ+drGMyL0axkun5zdGrDTpr6
         yG+aOp0HZNJd1fbhjLVUkb0C9QyK4n4Y0CjqNvL7M911JUTtYb8wdVEDCjM1UwbiQ60t
         MhKFwyaHxpR4PXonprbcHmxiOKuk85DTYCOuWOHSVXtweSln2wFWJ/hhQQ4F8lUEkvpI
         fYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786746057; x=1787350857;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9rH3bp69slXb8jLJ0NgtIg1Y4c+emW9+Bm+Di8skZaY=;
        b=pb3S+4vrjdN/AK/CJ/P4k+5ORithwH8DrGUeazDJhfq911CItFxivBM09mswcr+2YG
         0oSL545itOT7OelTl8W7xUUh+U7bP9SwpJnLZDyG5fssDRwaQWk2XqiITC4eawmI1CQU
         lNO0SzTr+0q0qyCMkXVkxeP1BGJIo9cUTdHvAhQRv/4GgLssFYGqOpdlqMH2Rw6p7eB1
         EVchcpaq888mZT5ssVkEEILZ8ZmsEEe5KV2fFh15Z8zGQNBFUBHGh5060CwwiBpzfZl1
         8ECpKJjQ63nXH79I7/Qj9z9yTMml0O49jqfjrQ7HrdbVrNzcM67wM3ELWJWXfC61uA4x
         nXFg==
X-Forwarded-Encrypted: i=1; AHgh+RqKu4ZJX9Ajq1mT4g9xQwtH0EF9sEo2weH9ymSr0HsRqxLaHwFuyaXfDFLEo1Av144WN97dQCmW4QhZig==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuPSYYvpI5H4wXvnzyjGgTEDfFi6n8UO95mWY2KIPudS4TEK6D
	nQ1M5J2XTliveqbI31abcggWE+qE/tPekJuJPi8c+6O2EcjiuSIzlUqU2x7XS0qWjb0=
X-Gm-Gg: AR+sD12S7NCRu7dECZL/PnrnM0cJDYnGdzRKUe5Vwkh/KxD33wnYxdUHH/NwwsZdJhI
	bi0iOoP24Z1SKGg6brM1iHXuJnyd4QyrxfnSC0HxIBoiJ8++Dzr0H0oEUZ8j5fiNgNflO5Flvl5
	fl+7z24oO9/RFzzJS5+Rl35R0bnovwUcWV8qu+r0UySYC7jpm8kxgp0wHzYb0uuWzzzFZMDn5F+
	/LQIwCBxSaRZ7Ne5R+wwXVqmS+8sEXqYgOUymaCTl72G7MeEptAHu936RwejabpAW4ppeINksB/
	ffsY0av5Pc5c2+LyYmfPMWc0hWamvV/o+tbBdtBhKVzs8pyy2XYkQVXv4J6Og132mbS40lW6ASI
	FIY6OS0JPr6VeqYptu1WrdXmxKinvtyEODD8MaTxoFpvooBlnzE6ZFXxabdEaeuPAUdIfJ6qoP+
	yOYV2g2FjaIsb9xMx7fhlYZmVKUSZteT0d9Ew2kI94e/2WCEUgEnN14w==
X-Received: by 2002:a05:600c:3788:b0:493:e365:7630 with SMTP id 5b1f17b1804b1-4998798b5afmr86870205e9.14.1786746057369;
        Fri, 14 Aug 2026 15:20:57 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141387ac9b1sm14390655c88.2.2026.08.14.15.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 15:20:56 -0700 (PDT)
Message-ID: <6e0c2009-04ff-4e64-a56f-6f0394da9686@suse.com>
Date: Sat, 15 Aug 2026 07:50:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: scrub: report the failing sector's address, not
 the stripe base
To: "James C. Owens" <jamesowens@optonline.net>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260814162405.1434693-1-jamesowens@optonline.net>
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
In-Reply-To: <20260814162405.1434693-1-jamesowens@optonline.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/15 01:54, James C. Owens 写道:
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
> Signed-off-by: James C. Owens <jamesowens@optonline.net>

Fixes: 0096580713ff ("btrfs: scrub: introduce error reporting 
functionality for scrub_stripe")

> ---
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1045,6 +1045,10 @@

The patch format doesn't looks correct.
How did you generate the patch?

Normally the lines should look like:

---
  fs/btrfs/dir-item.c | 3 ---
  1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 30ddafaf8d3d..a6bd69be522b 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -149,8 +149,6 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle 
*trans,

Which should include a summary of modified files, the hash, a simple 
context.

Otherwise the patch looks good to me, and still applies.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

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
> @@ -1073,12 +1077,12 @@
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
> @@ -1087,30 +1091,30 @@
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

