Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B552DF13B
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 06:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776839032; cv=none; b=XFT3CuYaRJKyVkEFUXsc6VM/jlLKQtuId2sFkUzTdni+/Ozm7rTyM38ECasJ75G+FSt4u3fkcUEWK0MHIH/qkD/f4nX2gWj3kAdEvi3Yokoqr2krS6MMPm4dOqN8lPZIRNg10HaXcPRz8sfIoqHXe2Mr+jfcD3RL214OmtofqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776839032; c=relaxed/simple;
	bh=ea85Bu3QxlESdBOLoyrB3WU+hq11lNeqWGKWZt9izyg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Vgj+nat0YH/UNW2iBVVc+FHEk4zddn1xqOHQK0UwnY6aZ5mpamjwCTD2Pk0E4MgXQxEdWAGOmMaAUvwMNLFf3GzRV1GUoN9EBXZB0ir9Y7JAuQpUVA8C8B+pZph/2Mr1/os8RNM1xm9ddB2wtO3L/98jgoi4RTZC0BsZVum4/a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ds04fYrO; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ds04fYrO"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso29233795e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 23:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776839029; x=1777443829; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PxX3V5WWJlSnRembBDjckKcFDb62qXPASZMMjLWh1kY=;
        b=ds04fYrO8LeqXNCZDWDW07Zwd2lI3LNaPXIkzhcbujDYRjA02kyMheYpuFEIpR1FMs
         ibo5kcyzH0Z433vaMr+kHorjM1IyIFQObgEsvlXIifldrZ8zSccEP7l3YL18DU6LINS7
         2+PyRrw3Te0kl5Vqts4V0uGwaJYQilzrQZkBj2Kdz1RIhy0bm3QI8my2eZtOVjXiIC6l
         J8Rxq/wHCf59oZehRl/ayJBIXjF3DXOTF5sn2fodW2CAaTTEjyXnYYvv23DSIvckSElB
         aKDVKMljrdLk0DeKIBHQillpOQW6jq17uheX+xk1iGAW3FMmjsKhW+sSmWD1tVb6wnlX
         84tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776839029; x=1777443829;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxX3V5WWJlSnRembBDjckKcFDb62qXPASZMMjLWh1kY=;
        b=S6cIxKon2RjTGcqs3qMLWoCT47ki6mF9MCu/j8Y2F8urewvjKPSUvew9xyaMKU622M
         wK8CE2qw2h7g99Q6mxY04xUyB5xBK/4auggGcmJCfE+JIlM1Ot8uH4Vq7HfudoPy9jRE
         uvM2DEcsHCwh5oT4QFlxq+lK4de29jaZcvo75tUZS3qN6dAWkE5KiYmc796Sp3uz0QvY
         ayBLTqZPTPytZowALErrk4Yyljnh38mYelLB43JukZUDl4NRWhU5MmZ2RnQtAXVeRyl5
         QC0VVclYN140nIMfn/tRNBBIpy8Ul41t9wloZwQk/skmBrR01kDG0yQCAyidiAky/Jcy
         7dgA==
X-Gm-Message-State: AOJu0YwMAX/ChvG7GElE65eW126a+VQoHe5f9lOHAU9P9aLI3jzDM+v/
	1XWe3v7Rh3cgw1GBFCStPhR/NLscGPSOdLiWQIdzClCfxXnAwrOFGWw1HuO0remzcu5vDt+YsRT
	UEDPEGTo=
X-Gm-Gg: AeBDiev+MGeGON2/bK8T/uPmmDyhvPfzsplLRb36BLhvu7F956rcF+ucTVBEwyKmJgb
	LGTGtznQhTSg3xPN7y9nrxp00JH2h+YdlBS/B6eAZ9Z8C9atKWhVGnTWDXuW1R1WT7ZWvrIXQI3
	ihxR4eSeqfgW2Rl5NR5/ka1PCVCDzhwnAGxFi7m7WNoH/QoLIURfCvTncgHdiNnvwz/meDMCKSQ
	gxdt/GOnXqgSjEpmau2JTA/aELKI82n5b8rFxZoLOak1Hvtezu91uf8v0hah1bapMkcw2ys+MPE
	2kawAeq9kZ1klIkYDh6wy5X6b79jyARzqG8UEazl7nb9i4jouQPO5QHAEwnw2oBlFseGpJPlYFW
	HWTCUinS+e6llCaGo0A8+PZ7v+j+ZPd+NDprfD/2B0VXEEVLQKVb2Y9XbnfxUgZg5Iq1yySgZLZ
	Ucy6Ffrp4Wr5KDm3QCJ/0DU4hGENPNl3uHZY4G+xpeGYJiFE6okQZDODDla2XpbA==
X-Received: by 2002:a05:600c:a30a:b0:48a:581c:ead with SMTP id 5b1f17b1804b1-48a581c113cmr46801595e9.10.1776839028767;
        Tue, 21 Apr 2026 23:23:48 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0cd18sm163948795ad.45.2026.04.21.23.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 23:23:47 -0700 (PDT)
Message-ID: <5b309e88-dfff-484c-a920-5505911ed41e@suse.com>
Date: Wed, 22 Apr 2026 15:53:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 0/6] btrfs: delay compression to bbio submission time
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1773953307.git.wqu@suse.com>
 <20260401225257.GA826348@zen.localdomain>
Content-Language: en-US
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
In-Reply-To: <20260401225257.GA826348@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/2 09:22, Boris Burkov 写道:
> On Fri, Mar 20, 2026 at 07:34:44AM +1030, Qu Wenruo wrote:
[...]
> 
> I think one thing I still don't understand is the desire for the layered
> bios/OEs instead of creating the same delayed OE, but then as we do the real
> allocation/compression and discover the actual ranges doing
> btrfs_split_ordered_extent() like short DIO writes, which seems quite
> similar. Splitting/joining feels like a much more natural model for
> ranges like OEs than layering into a tree. As we discover the sub ranges
> we actually use, we split off the real OE.

After some coding, it really looks like the split idea is going to break 
the existing OE code more.

1) The new real OE in the middle of the existing one

    |<--------------- The existing OE ------------------>|
    |<---- Head ---->|<- The new real OE ->|<--- Tail -->|

    This is in fact the corner case, and TBH pretty easy to handle.

    This will split the OE into 3 parts.

    It's heading part is simple, we can shrink the existing one.
    The middle one can just use the new OE.

    But we need to allocate a new one for the tail part.
    The allocation has two solutions:

    a) GFP_ATOMIC
       Since it's a very corner case, we can afford to go ATOMIC with
       ordered_tree_lock hold.

    b) Pre-allocation
       At the cost of searching the ordered_tree twice, one to find out
       there is a delayed OE, and needs to unlock and allocate a new OE.

    Then we need to insert the new and tail OEs into the per-root
    ordered_extent_list, which must unlock the ordered_tree_lock.

    This can be solved, but I'm afraid it may not be elegant at all.

2) The new real OE covers the full delayed OE range

    |<--------------- The existing OE ------------------>|
    |<--------------- The new real OE ------------------>|

    This is in fact the most common case, and pretty hard to find a good
    way to workaround.

    There are two solutions, neither is less destructive on the existing
    OE codes:

    a) Remove the existing OE
       However we're holding the ordered_tree_lock, the existing
       btrfs_remove_ordered_extent() can not be utilized.

       We need to remove the existing from the tree, and delay the extra
       handling (outstanding_extents/ordered_bytes/root_extent_list)
       after we have unlocked the ordered_tree_lock.

       And how do we end the existing delayed OE? Just remove it and
       call it a day? Or go through btrfs_finish_one_ordered()?

       Furthermore, I'm not sure what we should do if there is a
       transaction waiting on the existing delayed OE.
       Transfer to use the new OE?

       This seems to be the most complex way.

    b) Using the existing OE
       So we replace the existing OE with parameters from the new one.
       At least the transaction waiting is no longer a problem.

       But now we have space reservation problem.
       Originally we have reserved no space for the initial delayed OE,
       but now we have space properly reserved for the new real OE.

       This will need a full implementation and full tests to be sure.

3) The new OE covers the tail/head of the existing one

    |<--------------- The existing OE ------------------>|
    |<--- New --->|

    This is again a very common case, e.g. the compression failed and
    we fallback to uncompressed writes.

    For the split it's pretty easy, shrink the existing one to the right,
    and insert the new one.

    Now the problem is related to the transaction waiting. The original
    transaction is waiting on the whole range, now it will only wait
    for the remaining part.

    This may lead to fsync data corruptions, and we will need extra
    handling to make the new OE on the transaction waiting list.

    This makes the OE insert path to have extra things to consider.


In the end, I think it's better not to mix delayed OEs with regular ones.
Unlike the existing OE splitting, the delayed OEs are really having too 
many differences with regular ones.

Thanks,
Qu
