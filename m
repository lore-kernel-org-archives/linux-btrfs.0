Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D5430CD3
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 23:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786491155; cv=none; b=Ri542RooXRABYPtAJcxfd/T8Fzk6vZJZOFuZoK6NPeIgx3pi7i2zTTuHgijSggQqsYLyIIgGFAuAN4edG2+3PZOU+fnb8TBwK7FZzwOd0Yj+WL88CZlYHsqtnRnOXPhHR+i5QS4C27012VpIFsom3V1cP36LDUvn2KX58+E2Wis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786491155; c=relaxed/simple;
	bh=CHqx7B2RZy7t6aKbUIiAOePlHAM+i9sdXAe0vI6Mj3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AVolz7OEN6IFg/CUhyGDrSET6MiyW7AI8E7kVytdVpGqIYO1+J+l/6uVN+V68AL0xtjqWfkUuqrLQL6JeCqxB5SJV+yGPaIM7ry0+wBjv9FjJUtlXw31NUyRGeoGHR/3n4zm8oaoXvqBgVIRJygsn1zQrCJic28+2EMYR2RbCDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YsHob7dJ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YsHob7dJ"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso2927075e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 16:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786491151; x=1787095951; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/V5PI9YTkKGoy8ZMx3SBOIHqnrdkD7ZE43OVzHx9AeQ=;
        b=YsHob7dJexBae6SWtpLm/hk4P9WJmAnCBVsMqfdXnW+8Z/sVb2YhzfrGXNeVjIAJ3f
         Pn7BXnmmJIP0IHBjcv2h9t3PNR+xGkWKHsHpC2ntrbd5FHX84yZN5KrXZoenk9G7UjNz
         2tttBgjN4SE80uxoKGNdGsgjJd5Ic/UZkOFcO9nbwmKGNxC4E8vhCfI7mM0yUxtIKk/2
         phykXnvA71rg/l17XlAQsvqLXz5M5Qrir1Gx4ZRNxIrnCg1WcEoJfJpOD/TXYCjW2Xv1
         UezL9bDg0aMIhfuRr53B9zldGYY5YbhDp7I43fj7xarCZxBTj+CDe8XZLs2yI1c2PnvH
         kZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786491151; x=1787095951;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/V5PI9YTkKGoy8ZMx3SBOIHqnrdkD7ZE43OVzHx9AeQ=;
        b=C0wsgMAClO4MDQW5Nx6qfpWoIFC6TO3A5vf0XaK4S9RdjedbNgDzs+QTM9vfzEw6qL
         UX6lRS1zkU/0dwqCsLF8L57MTMA5ssrO06WHoPeDq1Om3t4VdeceBfw9I8Vwbu5hz31V
         pAh8/8jS/fJ+yvuNwwOKe+K/S94LJ5zSBWsZWDDOHN48JtYA2ne9OurADsiGyjlBEciT
         fYDqyXhJm4uT1cgNrX5Pi7toFHqMVIp2j/btzp8MIOWl/Ki3Tr5l7JXUkZvl7+XAOK28
         3/ESKaCwmLJRbVxRVPXbPRnbbzI5K6JHDAVe+it7oSwdDDMSqfvowmXnipOOzUx3A/hc
         Mtyw==
X-Forwarded-Encrypted: i=1; AHgh+RrcsSkPO7W1xVyCltMmBDpzYfNZy1Vs6ebnfQpz9A6vO1PA0l0D1SVJeXy11qybtx9oKO9RaQZvyTFYWw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu1eeyCWqDxGiDq9YVdrGHtBMLeFbNH7RigH03zF+u4mD4XJbE
	EjC1YifnBEApDReMpW35Ny4ptYeNCyNFKRxxpTrQRtSPIiOttTk7tr3WQN1fPKPiBxnLcFNdy8L
	uwOcTniuSVw==
X-Gm-Gg: AR+sD10lMtC6CVKBkGZ0hItJmCCSw13bL/H4quNzzI5fwiReMxAmCgGfKEmWnnHNqBz
	iZO46d5Ha1n3QxaDL/OCmeHCKX17xOhaegtOpaLYwHUkRx6hfnWL5yIyu3fuuF5deEmY49+rjJJ
	mnOTRPySDrDYgUHAWo5ewPn/LSxW9MS+Yw+6I97yBVMnjFOS00jo0gzn1mneRL3z6UwpOLZrAzb
	uXMpT8lZgO6phlCDwP9OZA7Hkn9toobTZ6c6lty0L3BczmMW+CmthI1dqf+z5fjfwnnGzQNvbPO
	/RjDSqIgKwbMcd/rf+KeXLlOcy1EF/Z91MZrDEe9qslizXuRDf1bbPTj3bOoOct+TgTlhCT/iuI
	CbZT8Kylkq1CkZM/UimxCBNDlH5adJAJwEfaTpguzbnxOzmKOb81HWH9Uw9tLvIPScY6F1okclT
	u3PmlMhd2XxywZNExAmrh5w9evuchOsphDFGQUaSb1X4V+uEOAOOY3HA==
X-Received: by 2002:a05:600c:418b:b0:495:641a:bd3f with SMTP id 5b1f17b1804b1-4997c13abd2mr4365955e9.13.1786491151243;
        Tue, 11 Aug 2026 16:32:31 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf3d0b48fsm3619898eec.10.2026.08.11.16.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 16:32:30 -0700 (PDT)
Message-ID: <02b9630e-b575-4c45-ae87-d2faea53b72f@suse.com>
Date: Wed, 12 Aug 2026 09:02:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] btrfs: Write as many copies as possible if the
 current RAID1 profile is unreachable
To: Logan Finley <logan_finley@selinc.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com
References: <20260811230427.4059275-1-logan_finley@selinc.com>
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
In-Reply-To: <20260811230427.4059275-1-logan_finley@selinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/12 08:34, Logan Finley 写道:
> While testing a three-disk btrfs filesystem consisting of only RAID1C3
> block groups, I noticed that if I unmounted the filesystem, wiped one of
> the disks, and then remounted the filesystem from the remaining two disks
> with `-o degraded`, after a certain point new data begins to be written
> into a "single" block group.
> 
> It appears that some data is initially written into the existing RAID1C3
> chunks, but once enough data is written such that a new chunk needs to
> be allocated, the next chunk allocated uses the "single" profile.
> 
> I'm not sure of a good way to fill up the System and Metadata block groups
> enough to trigger a new chunk to be allocated, so I wasn't able to see
> whether they also allocate "single"-profile chunks.

For meta, go fill a subvolume with inlined data, that will easily bump 
up the metadata usage.

For system it's harder, but you can still use fallocate to take a lot of 
space, which will trigger new chunk allocation that will increase system 
usage.
But it's very hard if your fs has limited space.


> 
> This was unexpected, since, to me, one of the benefits of RAID1C3 was more
> time to keep operating safely (albeit in a degraded state) while an
> operator makes their way to a machine to physically replace the failed
> disk. With the current behavior, it seems that this isn't a valid use case
> because any further disk failure could lead to the loss of newly written
> data.
> 
> This (admittedly naive) patch modifies this behavior so that the RAID1
> family of profiles writes as many copies as possible in a degraded state
> when there are not enough disks present to write data in the configured
> RAID profile.
> 
> Signed-off-by: Logan Finley <logan_finley@selinc.com>
> ---
> What I'm looking for is feedback on whether this sort of patch is
> desired upstream, whether the approach is valid, and whether or not
> there are any gotchas I may have missed in the implementation.

I think this downgrade from RAID1C4 to C3/C2 and from C3 to C2 is safe, 
and it's a good middle ground solution.

Although it has the side effect that there will be new RAID1* profiles 
which will require balance to remove after the missing device is dealt with.



The root problem is in how we handle chunk allocation in degraded mode.
When a device is missing, it's very instinctive to assume we should not 
use that device for new chunks.

But that may not be the case, we may still want to allocate chunk on 
that missing device, and rely on the chunk's mirrors/duplications to 
handle it.

There will be extra problems involved for using such missing device, 
e.g. we should not use the missing device for profiles without 
duplication on other devices, like SINGLE/DUP on that missing device.

In the long run, that would allow us to still use whatever profile even 
if there is a missing device, and requires no extra balance after all 
devices are online again.


Now the question is, should we go the long-term solution directly (if 
some one is going to work on it), or go the middle ground first?

Thanks,
Qu
> 
> Testing was done on an x86_64 qemu vm at commit a13307e97d5c ("Merge tag
> 'bpf-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf")
> on the kdave/linux tree.
> ---
>   fs/btrfs/block-group.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 8def7abb728f..50a21a0d8765 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -176,6 +176,12 @@ u64 btrfs_get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags)
>   			flags |= fs_info->avail_metadata_alloc_bits;
>   	} while (read_seqretry(&fs_info->profiles_lock, seq));
>   
> +	/* Degrade to a less redundant, but still redundant, RAID1 profile if possible. */
> +	if (flags & BTRFS_BLOCK_GROUP_RAID1C4)
> +		flags |= BTRFS_BLOCK_GROUP_RAID1C3 | BTRFS_BLOCK_GROUP_RAID1;
> +	else if (flags & BTRFS_BLOCK_GROUP_RAID1C3)
> +		flags |= BTRFS_BLOCK_GROUP_RAID1;
> +
>   	return btrfs_reduce_alloc_profile(fs_info, flags);
>   }
>   

