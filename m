Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795127637;
	b=uEpei2BhiAIqS91XdKapw4Pj56s5uD22Ut9glke75u79SVLzNA6qpxPYk8GaGyTZwqdT
	 DwV3dURj60nzB2NnXYPFnFH0dezt/Aj4yrQhfJ1wZn9BnwO7wlDdw/uHzJ09EAgwOVkSb
	 r31fF+Jm7jzQmaQqRFoCJdAUjTsLlyrtBa7o1KqDgLzTnUtknarNmmgpVHd1wUjjSFMwG
	 ohav9R53Hy4YUi7QiTqlIdinfm9G83IOqaz7eFeIssag2Cfngq3gAlwbdXqv7SEqPsjqS
	 jVluwk+YLvOAVJT5pZl1zKq9AYm0M7JjUcyhYcCP8xccQcdL8gVZ4I05jhFXcSLEUgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795127637;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=TqtffM57zvX6UlLcj7lzeRGmatYnNlYBqbsaibjXQQ4=;
	b=AUn9hipRTiE+e/u2bR/BEU3hgzGHhoPxIiHq4i1m4Lv+0gCxDOOxnee0snYPmBXM93Mm
	 b9LPjdHsWtzaIVGDhYxjXpj/TcCGNR1Xlb4e/v2Xw4PrGD7Jm56rs7p4/gvCGSu3srR9t
	 L4CPpM4NgfTD4xbOY8dhPBaHahPfBB0D/9OtK2+U8FCXIjc9mNpzisuXyalYJN257DrG3
	 tJZSGBxRhDuSPBi/Bx2GKeV/hAJqtnKS42UFCKYGCWZLxoaeY2zcxOQbKWw7/LRK7iFwf
	 ff5gCapEVj1jOqnkAnLLZ8VLU3pfqo0tR6sVRjYBlH93VdSZpbPvlgaGDByZXKpycOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Krr+KBJq;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D584606A325
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 22:33:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D584606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Krr+KBJq
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6ba1e22ff4dso275393a12.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 14:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795127635; x=1795732435; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TqtffM57zvX6UlLcj7lzeRGmatYnNlYBqbsaibjXQQ4=;
        b=Krr+KBJqsMNJ0vQW1c9prsoB8VUi5WCBjtHLhdetjpIrVyDTS799eOCPPvwSftr/UZ
         1CBoMm25sVfjP7wYI7IwZY8WUMdlJz7p03t3gMP8NihJ4NdtQtMQ4Nn+HXdmbslDADmu
         rPJLOrAU40LKN/hBZ+9g9bVQ6KjYgtxEE4tagI+Eu3Awozf+3lEqoMZzX6yj27CXXGaY
         njqRlpEfZ2mh8hC7Ugy8BsBq6auGZxbvxjvMv9UBiDN1BHaLsx7xTSvBecT28wQ7OaY9
         dkdqOkJ0t8MRgTJD1IiZifD8qqeqLsEK2U/41kpseDsmrVkh/2wUcrgpzBAHnnd49v8p
         HnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795127635; x=1795732435;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TqtffM57zvX6UlLcj7lzeRGmatYnNlYBqbsaibjXQQ4=;
        b=c39AUMrgQFMYMNH/FXDOyOwe6C5ovpon30qSjkvO5qehq61qkSE/nJI7ORNyG0OTQy
         Sh6GrVGZMxuZ9NIZhQ2fg/bHJsO3NNiKuIWejItZrMTLjJcBCfX986MdSyeqwte9fXS3
         DmTtEiDaVI2jZy9ZfPq4GoYTF9Y3GzVfo2aFyczjKzRPHzDjN8avPedACZ6L3TLASSsa
         nloPcDq+akvhD/7qaDhmPVn7c/eTQF3KOlBFKsXntDQknJTQqhQ1owzyvZEGZd4qoY0s
         3ckaUAI5/Ai1/eTdK17s1QUsoZ1twhlpiBhWt2/4oBy7b7QexK2/6YBJu2MarJ+QEQmB
         mzfg==
X-Gm-Message-State: APuU4Z9W78AMnoQ4KiGC11XDkGG+iup9xTb0drPSdf7KJWsYEkXwLS3R
	Pc9oZKcPS9pLa4fTCkymeGMBJyL15uvqTmYkHsFmmVORDrcjzIiBn1XxAWzeNvgZQWo=
X-Gm-Gg: AZFdTZc3S0CuzHOjMM98jRfaP+OrxWdKHiDFNYI4gdZn6BO6GWYZ6S/yQjrZ8J2S5n5
	qNcbIwkpM4JtZhJw5haff2+/Q9IsoAQE11XaK2mPbcsqZixPL2/u3uNDvc1ZzVLPefdXkMT54Oj
	jK5HGc1CLOrMKjh8Gq2QcCqTQF1x1PfZJ7bSQJ3n7MrHt4ECWHiDlN5796kd91Y75A571hXgPkO
	2bNS+uDZoNyC6dwKm236dSgPYH+Tznn7TCpyVeoSypoy5WcFitHc/M2jpMALpDMr97kFiP9fAmL
	h+1oAVTV2sODqNaI8hWQc/NsOI7PfOwHNHZ6rJu7US5Ax3C4cbspsnYDw0HY2izeKkoDAp9iGvR
	AnBYQVuzhBWTHWWDIIj8KW9RkLdd3AgVihFSRS02/RQXM3IKCUtYD7NX+gAFgQsWt9ltJ1zHdNT
	Y6ore/3tSFkwX6tL6gv9Meyq+LQmssMRqUVabzZsQ1HEl73h5vpNSn79fQ8ljo9BkF92OcI0NfG
	IxqcNJ6uP2BZCiY/0rK8lHoLPXtbcAhgc5DVe4SSYUnjncxMKq+o49pXSiQn8Fo2qRhbOm6oWBx
	hlUeauUOqPPWKKCfl/SHPw==
X-Received: by 2002:a05:6402:4048:20b0:6b6:e857:19d8 with SMTP id 4fb4d7f45d1cf-6ba37e69801mr465617a12.10.1795127635298;
        Thu, 19 Nov 2026 14:33:55 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41d2253d0sm436064a91.3.2026.11.19.14.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 14:33:52 -0800 (PST)
Message-ID: <237c8b88-4ce9-4cbc-932b-dd1fdff3f66b@suse.com>
Date: Fri, 20 Nov 2026 09:03:45 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: scrub: don't count zoned repairs as corrected on a
 degraded mount
To: Miroslav Cimerman <mc@raidlab.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-kernel@vger.kernel.org
References: <20261118175637.60283-1-mc@raidlab.org>
 <ee3cc2d0-6991-4d7a-bbd6-a84972d44b37@suse.com>
 <HLy1GbxoNDmZhdhuxdyatdLIiWG6jabGJiSOxke3u7mRd-njBgBiRytg1IKO1S2E6xNXQw75eH4SPWLLXC6TC0BNXXcz0SV3FsdSOQUQLdg=@raidlab.org>
 <f944d77c-4c66-4dec-acb8-985d4288afc6@gmx.com>
 <RSMUZ1EIRwrw4g1uzc9_4FR9RoxzCzSBf9_b06-ovgxC7CsQ5GfC-E6b2vyTIE5l_FTRt-s8hlvskCD_gaf4UQePuf2tR6x011MGUO9nJO8=@raidlab.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <RSMUZ1EIRwrw4g1uzc9_4FR9RoxzCzSBf9_b06-ovgxC7CsQ5GfC-E6b2vyTIE5l_FTRt-s8hlvskCD_gaf4UQePuf2tR6x011MGUO9nJO8=@raidlab.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/20 08:19, Miroslav Cimerman 写道:
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> If it's a workaround for the well known new-SINGLE chunks during
>> degraded writes, it may be a little over-killed.
> 
> True, balance and block group reclaim already relocate block groups on
> degraded mounts with no such check.
> 
>> I'm more concerned if it's some extra requirement for zoned RAID
>> profiles, e.g. to keep the writer pointers in sync etc.
> 
> None that the repair would break: a regular mount needs equal write
> pointers, but a missing device falls behind on every degraded write
> anyway, not only on a repair. The problem is when that device comes
> back stale: two days ago my tester found that a degraded mount could
> then allocate over committed extents, which aborted the transaction or
> crashed. The series "btrfs: zoned: RAID1 block groups with missing or
> stale stripes" fixes that:
> https://lore.kernel.org/linux-btrfs/20261119213835.103131-1-mc@raidlab.org/
> 
> In testing with the skip removed, the relocation with a device really
> missing works: RAID1 on three devices stays RAID1, RAID1C3 on three
> devices gets single block groups, a second scrub is clean, and the
> missing device mounts normally when it comes back.
> 
> One thing it needs: without the skip, a degraded mount that reads a bad
> copy starts the relocation during mount. In testing, it raced with the
> mount, which failed and hit the uncommitted transaction ASSERT on its
> error path. "btrfs: zoned: wait for the relocating repair kthread
> during unmount" prevents that: with it, no repair starts before
> BTRFS_FS_OPEN is set:
> https://lore.kernel.org/linux-btrfs/20261118004808.201460-1-mc@raidlab.org/
> 
>> And I'd prefer if you can get some helper to know if this block group
>> can be repaired, so that no duplicated checks between repair and scrub.
> 
> With that repair kthread patch, the skip can be dropped completely,
> so no check is left to share, and scrub needs no change for degraded
> mounts. It still counts errors as corrected when a repair is not
> started, e.g. while another one runs, just as on a regular mount.
> 
> In testing, with the series and the repair kthread patch applied and
> the skip removed, a stale device came back. A few scrubs on the
> degraded mount relocated the block groups it was behind on, and then a
> regular mount worked again, without a balance. Only a block group where
> scrub finds no error still needs a balance, e.g. when the missed range
> holds only nodatasum data.
> 
> One downside: when fewer devices are left than the profile needs, the
> repair relocates the block group as single, without the missing
> device's copy. A RAID1C3 or RAID1C4 block group then keeps one copy
> until a balance. Without the repair, it would get its copies back when
> the device returns.
> 
> Are you OK with a v2 that drops the skip completely, on top of that
> repair kthread patch?

I'm fine dropping that check, but it would be better to be a dedicated 
patch for extra review from zoned experts.

Thanks,
Qu

> 
> Thanks,
> Miroslav

