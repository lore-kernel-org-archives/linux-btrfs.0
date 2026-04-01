Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1471E5018
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 04:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775018101; cv=none; b=kJpS3Y6X/d9vE5YG6Cns4GclC7okkeQCPlXBZSnWQQ5U8X3QaY1IepEad11x5Tck6vxoM+4rH9WuWrSx3+Dc0Z6SYL8nz/0i7d4J8o8rGFVVC7D8b8kGDGWgUqZgakKbUE+KE9b/hHbeQEe0JWpOW+2pknr50opgwo/W2ppUps8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775018101; c=relaxed/simple;
	bh=gGArl+OWi5bRo1wZjsmfIeBOk/PIFMQ+nEP0MzLOfVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E+WH45NS8aPWu8n3rv/LmkSnKowa3UcLPmO4hqlWDhH+5mOsFpPjPyPrVd4P5sYCQjy+4IhabmOGGhh1GyoL50YGzXqqdaF/Otz1hgUkUP6XrH12rttyvyWUb6Br5b/H/kv+acTuJshtuEGU/sgvGXBjQWkQr1FsS/ktPJ9rZxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YOtl5H8z; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YOtl5H8z"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so78784305e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 21:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775018098; x=1775622898; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3ste4twH4nOZjf7OunKnA1bdkxEaxky6ugD6JTYixWs=;
        b=YOtl5H8zchDoZ12KXj6WVOvaaMp89UfOyZjYv63RUwQRA1lnnxtlkL7LQwJfQ4nzEJ
         6RsItAzdkTRiIA5hxN5tPSt71TOzWgirTFgX1oFOrP82nlwGfA2fGGy7/ZsjGLhIxo8A
         fAkSC/50OWx+DROwMSh89m7iWAQn1w7eSgXkhB8cXuvw11ATIFwM37+m2riqAc4sOs1V
         Z3JgDQtOi/TyUhd2QRjkXcb5UqwPCp2YuNJvazPB7j2xyTHZnMYKnB7VuPCRepGiqeRb
         fMG2hakO1jngfXLjE/S3x7uljbXMf9qJrubnQmZ/6WU+KofjfY7Vjf9MSAU992x83Eyu
         dTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775018098; x=1775622898;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ste4twH4nOZjf7OunKnA1bdkxEaxky6ugD6JTYixWs=;
        b=h3y4AxmYpXJ1VTbWoaNigxaV1/qcWGuj2WFUzqLKRXkGvm6SWYQiCeNe/jLdg/j4Ic
         dInIqJdBHN/ZDMkB496QIZgWtx/mcYXYq0QQYhSZroHxfFmrTLi2m7xtx7wBKKbF7Tzd
         R4sGGnOTrs6ljOvobuViRZOxkwjD1AMrX+QNi3+6g6P9kJAPCBpOWHMUMhQDj7KaWMkk
         DRD68imzF4rC5Mtq8ArAQr/hvb90CWLjI6E1OoiYVQjMN19wZehaRjOkDS176tuEu4M3
         lUkfNhapRPLETFNHTqGE4fzV8oGhD3iqLJ8SKkngHInJ7/nTu+/mFTslO12AP73ST7iS
         iB5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXw69OaynG3IBA3m0Yc2taLk8u9ni3TSqCvthZNVQBDkTyHVwFvKEWqKOut9y7XdeorLlTgF0pJIgxxDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQNL+qmJgZzAOHCrViFdGddqJz/n/8rwJkwEi5XnvQDmLB5gbr
	oY1G2THYWKvR/rjuKDcVJHzmgn+vTjZNoEsT6nupz4vRsO7rzJYGG/2twPKachIolTY=
X-Gm-Gg: ATEYQzwOXJBgjZ6+WN5J6aL7m6VK+j7qehiJ7qqylK/NrZhn8qCp+oF2C2Gqulp2H42
	fv6ZTPmPWcIQotLjdF6GaBF3zcNnVjvyUJnLJbMUiG8ArgSUgvQTqastTP5PACRlzSNMC3Zo0CX
	+P9Z9Y7Rk4NglP+qR0wKFvcgoOvuV6Ac+TCvVDiGEI365IjmhkzWP9YoA83+HO21dr1cAtCbTBR
	JH5/lQeuDKEKcK1pLV/fC4TMbb5BBzsuaPyl2tBtXWrlSbxTenmWLsEtpyjfH/tORvqKfS/Ltbb
	ofcjclqKRmzAXQE47FTQhcoFaYcUShatKoPmkNQxO5h0D5AhhO+/Y9zcijBibc/6Aj38hr3kybU
	/vI/x5rTHlALyljZxfMTqWeki+KUdeaKfKCNxRQboGo9vv1N2quDvOKiYH+B3EhJAZNeOmJz+zf
	Za2BrAc0P4TBIzSI4YQ4s/cOdxI2Cp55Cw7QZADajhw/SPFtEVDn3dcdwK/4kU8A==
X-Received: by 2002:a05:600c:6211:b0:488:7ca1:1a18 with SMTP id 5b1f17b1804b1-48883562e0dmr30870005e9.8.1775018098041;
        Tue, 31 Mar 2026 21:34:58 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe60bdf4sm3298521a91.1.2026.03.31.21.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 21:34:56 -0700 (PDT)
Message-ID: <aa8c074d-fdce-460f-a9b7-8644880eebb5@suse.com>
Date: Wed, 1 Apr 2026 15:04:41 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix double free in create_space_info() error path
To: Guangshuo Li <lgs201920130244@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Jiasheng Jiang
 <jiashengjiangcool@gmail.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260401031339.1418417-1-lgs201920130244@gmail.com>
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
In-Reply-To: <20260401031339.1418417-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 13:43, Guangshuo Li 写道:
> When kobject_init_and_add() fails, btrfs_sysfs_add_space_info_type()
> calls kobject_put(&space_info->kobj).
> 
> The kobject release callback space_info_release() frees space_info,
> but the current error path in create_space_info() then calls
> kfree(space_info) again, causing a double free.

Can you give an example call chain of where such space_info_release() is 
triggered?

> 
> Keep the direct kfree(space_info) for the earlier failure path, but
> after btrfs_sysfs_add_space_info_type() has called kobject_put(), let
> the kobject release callback handle the cleanup.
> 
> Fixes: a11224a016d6d ("btrfs: fix memory leaks in create_space_info() error paths")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>   fs/btrfs/space-info.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 3f08e450f796..d7176eb2fcbf 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -311,7 +311,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
>   
>   	ret = btrfs_sysfs_add_space_info_type(space_info);
>   	if (ret)
> -		goto out_free;
> +		return ret;
>   
>   	list_add(&space_info->list, &info->space_info);
>   	if (flags & BTRFS_BLOCK_GROUP_DATA)

