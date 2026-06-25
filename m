Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7062F8E9F
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 23:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782430867; cv=none; b=SaN4VuNK/74kRD3vI3Ni2PVXwoBV3i5b0WoOTBP1t75iye8w56ExEleHv14LSvGnGqKe9+Oham8NGFV/UtSdlW+ChMreQ50jC6A4+Df3ZGYBTr759JkqE9z4obfq68Yi24OSJgjbC/C0bME9PzLgwVl8hT1cb8WCFVkDSmUAxoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782430867; c=relaxed/simple;
	bh=XfbZbU4hnyAc5+KdGNxe2ruPtG8EqMmSWSCqT62Y0S8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozU80Bx0xCdON0bgLT09c7qDRZRgdLF+9F/BgXmZBDQwLrWkT0bMcdtfvQ/0C+CzPrnPydybHjekJEq1ocMoNrQ/uA2P7mpn9Y27ZlHZN5IrsZQMU5TikboA+c9FR0wacU0Ocbbnp+BT5NrT3gFZguaXeAaVmDktqUG+gPclABs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CLMekx8v; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CLMekx8v"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49249072f03so2000495e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 16:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782430864; x=1783035664; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JzRXNZAIz+cFbURiea9LciZT93qfxVdXq7/EPTmkpVo=;
        b=CLMekx8vQrjs5DHVdatqcoa6gVCtR8TtNy4butuSdeBLnrqn0Fi9/d+dC+AYQUi+Xz
         5f1gTT9pLZEkTGuQD+KeYJbpxphhEDaxZPN/04Ayk3M/Zrd99M/p7DdDlMgBwCmIq+VF
         qEgM5P8FkF4Kh72V6AGTyaATSSzTebNKrVPU8l43Qtn7un0/+XCeYnCHdT/e3/UHbqOP
         oR+zT8iSnDY/dXNtGCexJZdRm0vQIhVBjROEEFBR2fZPonIzEBJAZx/OFZRE7GhraPXa
         4oXmpSq7tGEoqQnCiYQqtHEJrhCxcvWMN7BQNgGZJ6Q+lUjxAdGG1y8l9ySLrTWVXMUa
         cHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782430864; x=1783035664;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzRXNZAIz+cFbURiea9LciZT93qfxVdXq7/EPTmkpVo=;
        b=m8cIZUpSIav5Y5DQOJjxdxxI2BW8+RvEqM2e9kLiyAhp6LM7kC/IKO8dOFsxPlygxz
         QkwKKbqg+p5Hul+Lxfn745QNNVfOusXlGGgU/euiQXcTKBSOnEtLV7TIaGmeoTds/+HK
         ZZJR4XWxWnlk8BB7yds4fQq8R3gmmIDmtu45cq48nQZqgHuw3Zy+5imdtakbVWVPcreS
         WjZC4ntNnXd2HyjSrGXJekyW/Fiw1vD4ALyL6pkqN0h2NevHnhMlDTLIaoVYmoWA4Q+f
         s/j/02Ub0O0QIWi7MFuPa9VygeVFZdGFZCdQbUWef6TICLL0ghXj4phhfUVNvR8Ji9V8
         yTgA==
X-Forwarded-Encrypted: i=1; AFNElJ8XkHgn+cETsKyds7EvnSCO9CgYPkz1T0dctWXzFtqxsY/QM6cuEKGpDkG5y/S9LWM9qHlrIrYKvzL2lQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yza0yvgJWHMalYzAF3L/aazXaCggDVBHkWch0Ft5T97V7efAEwC
	Ai1b5cQnd0Emo/Avgpz01pgB1S+q5qwBMjCzV6o/LOaIzgN8FRbr2YKoFpPdYvd/gPE=
X-Gm-Gg: AfdE7cm5frRpUbVIZlGO4bvoyomdsufn3oM8XBVgUZl4hSGhkNMs/WWAXLWS0mnF0t+
	xv1rsJriwsySm5ek5h8a1KGBWJKiMT3VRp6j8MLtZMQRwKbc58GXfbxi9ELV1lXNoO/IY14Mlvh
	7szX3Q3CBhpHMkHYI0KuQOwcJNMhun+aBAeCWlcNTjD4bjmDuqE1QjQOPHrQXvs+A9mWfO1V7LG
	v1F1ZZQjaPklVm+9kc2QjmCj3vmVCkM8TaUngl7DVLB9mfsEqdAs9TxCc5UH/tyd0FhEXBp0EAd
	aRj0PPf/ROa3u7KgwtdXkctqzRtghZunLH7oAjf04NXWfsLoETpulBmc4rHg53BbhXGhrXhLar3
	50NaUBc4YuLH0VI5p1sDhc+pyNoHTuM1igAw8xqkpK/VrRa7/I68mQOvD5yr7dpMcoTDK7sZNv8
	Qn3FqxBI1CQikD+h0zcvMORdABXdo2ieZFYxeLdn+n
X-Received: by 2002:a05:600c:a12:b0:492:5e22:ef18 with SMTP id 5b1f17b1804b1-4926685a81emr70142705e9.9.1782430863872;
        Thu, 25 Jun 2026 16:41:03 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d912197bsm18914891c88.15.2026.06.25.16.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 16:41:02 -0700 (PDT)
Message-ID: <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com>
Date: Fri, 26 Jun 2026 09:10:57 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] btrfs-progs: check: fix max inline extent size
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-2-neelx@suse.com>
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
In-Reply-To: <20260624165144.556908-2-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/25 02:21, Daniel Vacek 写道:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Fscrypt will use our entire inline extent range for symlinks, which
> uncovered a bug in btrfs check where we set the maximum inline extent
> size to
> 
> min(sectorsize - 1, BTRFS_MAX_INLINE_DATA_SIZE)
> 
> which isn't correct, we have always allowed sectorsize sized inline
> extents, so fix check to use the correct maximum inline extent size.

No, we only allow sector sized inline extent when it is compressed.
The de-compressed size can be sector sized, but the compressed size 
still can not reach sector size.

So this doesn't seems correct to me.

> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>   check/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 5e29e2c5..dedb4db4 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1720,7 +1720,7 @@ static int process_file_extent(struct btrfs_root *root,
>   	u64 disk_bytenr = 0;
>   	u64 extent_offset = 0;
>   	u64 mask = gfs_info->sectorsize - 1;
> -	u32 max_inline_size = min_t(u32, mask,
> +	u32 max_inline_size = min_t(u32, gfs_info->sectorsize,
>   				BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
>   	u8 compression;
>   	int extent_type;

