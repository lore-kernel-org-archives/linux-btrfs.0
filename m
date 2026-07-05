Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7988F27057D
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 05:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783231087; cv=none; b=qil7QJtx0wT9bnnUuRY/jqk99SgjnUy81/byv/QxwGhi0MxWKPde3hzTMvQgk7TpoeUA7clfp5up+jgSpnuHW8h7TvNHyGFRvnNc/Pi7ELyKkCq3zgS3LmrdJ3vRrTTfecTRac6lOSeOZDT/XNi1GGTunwO49+TZ6oVv/3dhm48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783231087; c=relaxed/simple;
	bh=4z57w4guPA8HENc//begRYGGjs1tsGJtsiDpAgU2AJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o1RzwFxUq+YdnPhlQgmIImQecjcHKt8nYZErvAuqpTU5DeKloZyuZ9i+ygXhiA+X4JRBCXc5JSdgaJ+O9/HlPPYFphkwlZLeJilcgrljHHufkAKgrTLelLlGE6w6aGg5JZrUqzYzggoaM5vfrPAf3EfONyLBG/fDmVaDRKonXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EiWI0ye4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EiWI0ye4"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493b77b150aso17178405e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jul 2026 22:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783231084; x=1783835884; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gzcZsQB384JqNcf+JApIOFZ6eRs6bXFhNVWCwtsRQfI=;
        b=EiWI0ye4KesGusKs/W1fuYVYEoMayPSNQhdjR945P8f6PIoNAXEUGw/Dp7+HwycBb7
         URt6JzEIYWcj+ylV9xEFVaNoQ43prMXm2BsgOUZXy+/PbooI6Pu/b4xfBlY0B9RxnV8f
         lnRKJxxVEwt3bT+fuu+JNTbldUWJ8rj3mLB7KbLLe9pE78qFrCsN4mur30UH12JoE3Oo
         sbh4bu4+l4OWbN49yHDQtd+nMkBIBcHk8GAtFMzUC4ibAhH+UujOxzUClHxQA0wu8kjp
         VOoBUiYVgT9cAW7piS5pLEt2Dmzq/5nJoqohovXYu++umIDjIAaxmcs4eCqLqfmkjtlD
         rNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783231084; x=1783835884;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gzcZsQB384JqNcf+JApIOFZ6eRs6bXFhNVWCwtsRQfI=;
        b=TwQa+5jEYfUuaf8ecpc+jeait2HS6xWW3MLU2ZkWBeE//O55aFHiQCBIo+6yV0u9r8
         oOO6tyTKyAjY0egBuKLn3o00m4ZjSiB/OSqsU7CW9munu+Ar/6HHw/D4m0OyDCBNhBBu
         RqihDC8stohZaRPgX7rMeMM9utZ3C8cR9q0DyWfkIrC8UVwZ+m9DDdNBN+uFPfrX/ahG
         QPc7BkWB0smi36isqzQLrnROL5BtTdxRplHQNtUSC+FWPONC+J99Koy6yZS4svQc+Kgf
         ZC/QSCHgW/alDy9hCeBrC/2mTQEcL+Y8kJnkj2glJ47Md7QS/hvrMyhrA2oFDtkmBb6F
         i+XQ==
X-Forwarded-Encrypted: i=1; AFNElJ83mw6xW/6WrJBwJ4q1Vonml9Amnn1pEBIqEVROCn4k0lv6bWa20YiWO7ap9sjDXUKDg0hzUkurEjGlTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwnnQINJgOWe3FlSCrhlDrXmSXkn85aAfsg493XrdlD6exvOfb
	/LFCe9sirZPg8mLanb+LHpgfTADwGKg8jcIipFBbWFeRJXlYq748v88wiKv6jv+Qg2A=
X-Gm-Gg: AfdE7ckol2wpyuc9aCz5TUz3pJjAtfrJQxy4bddq3nD1+1+kQFCvFjGGW1lCLnRO1xM
	lvdqRyyWEeaN9aDPjuzdrsKCx0xKaFmuf/SeDnjJZM/T/TBI6cQrK0Gnj1ZKncBAmplSmfjiyat
	vWI+8E8JkLT2DSwNM7gtenbylCcjHjkZv9ekjdMVnnRyIbz7dTpOYrjyiRv8aEDiVhJ7QlAiNcR
	+P8CXtGf+y1Ft6A2DZRVGti18ovnyc6sUqBACyqwfeBiehUyzT7WdWT30zH+fnSAcocve6XmSXl
	B07ajSOL9Ut91b8kpFVklBAWY1kTKol2pgbV3wJgc7vvPuun9jyIv+5hHzUo3uJjMS9U1mlWaoH
	IpUlsovq9K24XD3XrJJi4oBf8PWiK4vr1MxwKd0l5RmA8e5vRrGV3PqJFNlss4wfuTUJNXAbAC1
	Al7H9oHql3PQg6JQFkKt89Q+cQE3hX8JFK3wNtYnpl
X-Received: by 2002:a05:600c:1912:b0:493:b720:ce11 with SMTP id 5b1f17b1804b1-493d11faad4mr60589345e9.31.1783231083680;
        Sat, 04 Jul 2026 22:58:03 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bbd2362sm42503849eec.20.2026.07.04.22.57.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2026 22:58:02 -0700 (PDT)
Message-ID: <7fd6b604-ca23-4881-8727-43a98aa0521a@suse.com>
Date: Sun, 5 Jul 2026 15:27:57 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix extent map leak in NOCOW direct I/O write
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, clm@fb.com, dsterba@suse.com,
 fdmanana@suse.com, jbacik@fb.com, stable@vger.kernel.org
References: <20260705054637.80584-1-shuangpeng.kernel@gmail.com>
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
In-Reply-To: <20260705054637.80584-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/5 15:16, Shuangpeng Bai 写道:
> btrfs_dio_iomap_begin() calls btrfs_get_extent(), which returns an
> extent map reference that must be dropped on all exit paths.
> 
> For direct writes into a NOCOW range, btrfs_get_blocks_direct_write()
> keeps using that extent map and asks btrfs_create_dio_extent() to
> allocate the ordered extent. If that fails, for example because
> btrfs_alloc_ordered_extent() fails, the function returns the error
> without dropping the input extent map. The PREALLOC path avoided this by
> dropping the input extent map before replacing it with the newly
> created one.
> 
> Check the error from btrfs_create_dio_extent() before replacing the
> map and drop the input extent map on failure.
> 
> Fixes: 5f9a8a51d8b9 ("Btrfs: add semaphore to synchronize direct IO writes with fsync")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changes since v1:
> - Add a comment explaining the returned @em2 pointer.
> - Use @em2 to decide whether to replace the old extent map and assert
>    that this only happens for PREALLOC writes.
> 
>   fs/btrfs/direct-io.c | 19 +++++++++++++------
>   1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 460326d34143..19a1259b3b2f 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -281,17 +281,24 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
>   		em2 = btrfs_create_dio_extent(BTRFS_I(inode), dio_data, start,
>   					      &file_extent, type);
>   		btrfs_dec_nocow_writers(bg);
> -		if (type == BTRFS_ORDERED_PREALLOC) {
> -			btrfs_free_extent_map(em);
> -			*map = em2;
> -			em = em2;
> -		}
> -
>   		if (IS_ERR(em2)) {
>   			ret = PTR_ERR(em2);
> +			btrfs_free_extent_map(em);
> +			*map = NULL;
>   			goto out;
>   		}
>   
> +		/*
> +		 * True NOCOW writes don't need to create a new extent map,
> +		 * while PREALLOC writes must replace the existing one.
> +		 */
> +		if (em2) {
> +			ASSERT(type == BTRFS_ORDERED_PREALLOC);
> +			btrfs_free_extent_map(em);
> +			*map = em2;
> +			em = em2;
> +		}
> +
>   		dio_data->nocow_done = true;
>   	} else {
>   		/* Our caller expects us to free the input extent map. */

