Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D462C367F3F
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 07:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774682046; cv=none; b=BPL0ro9y5GBkNnlvV86X+7AIXISWjV+2kE7Udux15m30BuPpFFz2cV7b2DsqZnzjvX9NR4wAd124g4JHDOcj622puKuxIX6nEIF6K9SAOkPJOBosg0id48O65JWG5UidH8HI78/Zt9joCnsTyV5LzSvAdSQy7fNUz6WJSXeDEgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774682046; c=relaxed/simple;
	bh=1YVZZ4EG6PH9mBmv/7GNQAbm+6cJRWBtRTqsvNgY/Nw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AEbGmo2/GCuDSf2k4zFGK9/xDpr/9fp6dcqb8xhiGP67LjEeVB/ya+gfKD1CWuwn+XUOtIF7nObyYoN4+UaHrpS2EYQUPMNIQDcaGKC1rksONhN9vJboeZSP4Hp8mGOiCCGciPvp6p29ioucV0Ke8z5t4Ih1gjg58hrqie2xsH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BBsgXhJf; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BBsgXhJf"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48540d21f7dso31610445e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 00:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774682043; x=1775286843; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jJyWnSp+txUJQm5U1zdamqZGK5YIdYjiV4dBV0XCBns=;
        b=BBsgXhJfo9ERRXLZdve7mi15qyZfVglzueTU7ddRUDYx2ItFchgi5CerLspuiHy1U+
         KrFr3Hbgyk9olDfLfX74lDXJ0kZ74OrGY2zu7X16HS2RMx6SdNfWA6k8fs/CUrkNvh5v
         ktXy55IoL+9RwWy5t0fRbPCGwrelwE8wLguVAR9R5mLWlcIgcTezI72oYUa5JaJNZHIH
         Rwak/0IC1P8BCwjLqkCdyPT+1NblB6NDziuMJwBo7+nWeKrn06CmvajmzgXkyaL/z7qH
         2VmG67SVQtqYlyMYEdsKaHwZulVegObdO1BdsKxRctzIZ8TJjrn5wkVh55GAX/Kd5x3c
         /qEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774682043; x=1775286843;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJyWnSp+txUJQm5U1zdamqZGK5YIdYjiV4dBV0XCBns=;
        b=FbaduHqXPmP8O/8ZGA2XDMv5Ee8bGhyGcVbxjVHn03+v++xmeW4Y7mLn+jjXjP2IUA
         2cKzp/+F981A2c6bIlHKg8rxPm4i4FdD4/OdtHzP6LNZhTnsWNi93s7shaukA7p+mOzD
         e5WDY7qC98u+ZodmMzZChFjxqS7yjwLN6ayoqPr0PijhQhfvGrM9Z+0I1t/Bb0SxPNFN
         fRyrhxjhxVvF1oC1rrxYLFcnT9bZQfH7WRvHmqnkEToyoiCn/xAR3TN3UfLIv7xhT/sM
         R3FVOYwwYf8gRuQN9b33Z96ysDTzOX4shbaObp2rJ2CKKKKi+oHZKAezIrg0SnNxzBRw
         Kx/g==
X-Forwarded-Encrypted: i=1; AJvYcCUyS5S6G7BZejt3y92bJ9Z7fG+Pchq39Mi3laOWJfFiphzVLzkVvkdSfVPxSWY0pefUl09YoN/nxhPOKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwW5L86bMrY697Q5alnsTuPb6CddpGGB5D0+fmW/iheodGgNyJf
	OQyKBHVLt9XMSLZt23p1YcMPvQBRJRtAMrkaDlBWUFVfdZns7p+axXt2V6sAGJdJC84=
X-Gm-Gg: ATEYQzxakmkhzV0a/GrGwED/Re6O83UGt+EFrq7Wb/l5v18j1nzhCnepdeaspwMY+gu
	KnKP9IWa+6LX2kFXAjiDJH6JoK52DASRJ4my1eU11MtMIx0+muHk4EMzcXArHvFLiy3+D+1t9Nb
	0qvqLLlz289f0YGwxSyaveRDLCII7gjpcu0kkyDrf4AnYTxfgyMNuIx8v8pwLyYMZkXFFQwc6v/
	YlBmgC6MNjyVU0or97a/kj5S08jz4TtP7QOx9FfTgRFixE5yC5Q5JQ/jGhyBae62GejizmPjNVP
	uBlES24CSSpNW5fMDO8irM8tnglAymuP5gOPBHaA/YE5F7G0UV0WhSZuS9DL6tZr20Sc4SohbP2
	02UGozmI5/MrdKYdwrplHCk9r3v8Zit1xTIl5JMYDItHW0N6RRZOn+ygpdg8rQgRwJFnQHa2Jwk
	5UbQWIGrTUBWX+c8YLo2FPNGkzUU+sePHcdYDlobto1hXH2BH3g7Q=
X-Received: by 2002:a05:600c:8b51:b0:485:40c6:f507 with SMTP id 5b1f17b1804b1-48727f1f47cmr102144545e9.30.1774682043057;
        Sat, 28 Mar 2026 00:14:03 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242795195sm14786595ad.61.2026.03.28.00.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Mar 2026 00:14:02 -0700 (PDT)
Message-ID: <a9569d3b-f4d0-4077-a517-24c0f0c5fd4a@suse.com>
Date: Sat, 28 Mar 2026 17:43:57 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: replace BUG_ON() with error return in
 cache_save_setup()
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org
References: <20260328064306.2854437-1-27rabbitlt@gmail.com>
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
In-Reply-To: <20260328064306.2854437-1-27rabbitlt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/28 17:10, Teng Liu 写道:
> In cache_save_setup(), if create_free_space_inode() succeeds but the
> subsequent lookup_free_space_inode() still fails on retry, the
> BUG_ON(retries) will crash the kernel. This can happen due to I/O
> errors or transient failures, not just programming bugs.
> 
> Replace the BUG_ON with proper error handling that returns the original
> error code through the existing cleanup path. The callers already handle
> this gracefully: disk_cache_state defaults to BTRFS_DC_ERROR, so the
> space cache simply won't be written for that block group.
> 
> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And pushed to for-next.

> ---
> Changes in v2:
>    - Use btrfs_err() instead of btrfs_debug() (Qu Wenruo)
>    - Use PTR_ERR(inode) instead of hardcoded -EIO (Qu Wenruo)
>    - Include error code in the log message (Qu Wenruo)
> 
>   fs/btrfs/block-group.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ebf507909..89bfc9db0 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -3343,7 +3343,13 @@ static int cache_save_setup(struct btrfs_block_group *block_group,
>   	}
>   
>   	if (IS_ERR(inode)) {
> -		BUG_ON(retries);
> +		if (retries) {
> +			ret = PTR_ERR(inode);
> +			btrfs_err(fs_info,
> +				  "failed to lookup free space inode after creation for block group %llu: %d",
> +				  block_group->start, ret);
> +			goto out_free;
> +		}
>   		retries++;
>   
>   		if (block_group->ro)

