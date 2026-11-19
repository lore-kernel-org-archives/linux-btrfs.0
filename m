Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795122591;
	b=Tm1nHXT9J+uwslKZHran1aKQKRh6fe+BnZvVWTgcPYd0LrDcM+xi71Itf4QDlbYetxMa
	 iEPM8CZMsQ9Pul4jBOWDbjsz9eZp5dSFOtAQ1NH5Le0H+nwoEX1HnCXvYQZHkj6TvuRuw
	 eCEVVwckLG+ozr+OVKDKDqWeffTt1TWN8Xv1pFVUi22N8VxHdnnT8EHy38LVT6I2W579P
	 jwviyKSPF244O2BomhF6hPR26/tQTrANYQOOG5n1+ysv1NxODDaPh5JXJpc+/veHYB6jn
	 IztlvRp+34Y9m8Jr451Ta/j6fdCJx2/NEc6ycdi/Bk0XKoPlUtIcBzEF4Ta84woDjQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795122591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=roqSHSzdUDayurwIkbNFiAI9uAL3AQ8Yt//YtKCuZCA=;
	b=O0IUHkqzLR3V0oWTmulmShqciAHuMOV+i0fu+6HzL2pR0jghAGzifDfUYJ9iuEZdBas+
	 qrYJytjre+jZBcnkdOLa3xXLJ8ndwqlIfaKuMz1C6vm/TOFbYHQTd0MghNq43uYKA10ui
	 4JLJxcpsjMMCNOgL2nXEAQ5d8tf5MGUp2w9vmdK28hZBmb6Y9QkWVEFOrX2Ola6lEhquF
	 tklYf1mZjK63t7rXdiSdWecJlYR9Kv8JzFt/neOtj9oeqCYvrquhb3dkkc/E+EL3tnwR/
	 mdw1V4+ygBiupwuah0t+9gqHff24kGaQueLBZN6szr/T2VqT6cXV13jX6ezz3ecuooQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=BkXpLT2h;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9225D606A325
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 21:09:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9225D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=BkXpLT2h
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c5123794038so43822966b.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 13:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795122589; x=1795727389; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=roqSHSzdUDayurwIkbNFiAI9uAL3AQ8Yt//YtKCuZCA=;
        b=BkXpLT2hDO4taA3D9eKt2jv6ULJbtuBgc0f0JzLzom0RVGeS6yxuMY/f1gn7d/ITpc
         Z1OIqqoda+wfV8C1QQPtms6x0o0dX/j4TKhUBkS9gD4zoTX0xvAfZUHG8qRJm8vctX4X
         271GY6rvBOgD+uFv1yVNR0Ji9VyHx/QDPFW3yox1I4wCirtyM2oAPYuMxtHbEwYIW2TL
         eeXa6cqEyxk1B5V3nSqZMQTx+QMf5t1fK3B7Le1+w2JNgGPXIiPYZd9AgavKDqUaG2PZ
         XChChbRekxuubxywiIyklzhu8/IzlesqOPIprHsdBF2XNjW66QZFeenue8hUOQhKBXkb
         jr4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795122589; x=1795727389;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=roqSHSzdUDayurwIkbNFiAI9uAL3AQ8Yt//YtKCuZCA=;
        b=HQyBXy8tsLjfMXcmpMbJOQ6pt1b1In7DWZvBs6KhVfdkZSrDM2O+nuaa0WZwvtdnws
         D4nzl9gtUq7rwZrqCGBcxNwNCFQtJi8H/zZxQrbTaUf5T2S8ks5L06qT0tzUZlKOiFUr
         2HWqxEnR31adQWGgr8fq9Am1ujVp4rTFFHinlJJf4ffo+znAoqS5LOz7VJDVpfwNnnV5
         b5xazBgl8pEVwguF7E/eFXGH6W2FwIJCuj3/vb3S9PMDiGwcXVzs0poXgykFk+cCZNrH
         HJEtlw8/TrAbFbvCa3BVq8bTV1JBDRa3Kh6Ucybx0407uGg0edNgZB3zUMjTqHh0Uai8
         GU7g==
X-Forwarded-Encrypted: i=1; AL+hErH+Yel/d6QQBzXeXBoJi4PmQUMizE/juU/grZWy3c7l3k5IRTszoOR3WgL4vpPkIEjnj4LGBYeY9JnDLA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8g1R05blPeu89PKB4K1UvUrM08ENfeC+l90V9Er8VCVZBkX2JV
	Ik9cdD4pl6zbLadI7rSUFpRdoD0SCtzufLd25rGETnyyw+dsxnEGOfDlJRRnwPJ4x9PKIctXvVP
	x9Alf1k8=
X-Gm-Gg: AYBFou0rIbFh7obrvCm3c2uE74/xVVFthw/pg/2jTFDpqpJDGHIlj/CNq9OmELbsypL
	Ylgpj5G3DeJc73bx+kJD7XeYeMNIIPMOjt0/KthgnPfeD2OrS4QBZuOS38S69cM2fCGWAYkPx7x
	TPG1+5opp5Sb4465ikayjkPVu0u/uUR1hiMIZo95xHOtcfB/hc7oIWEJkim4TC4Go2UtniGx7RN
	49+3Nw36da3iRH3Kxh4lvAR+WNFTrJCxGW6ZB99TMWZHT9YxJmJbKjpWUdKOUak3xpCn4mie23/
	hlR3mjRkRYY+vO/MN1Rf55S2lff3SmGfG/htdrP5ctPwra3HcF2vqEzfZIaPhQ/cCyFQMGUHKOh
	/Ys1UvQNdAp14OIeLaTQeStpVlZwZmrxaq7mf0kCqcKbWCAasXGlDge6SK9B1b/NcrboQ5gIMNi
	upDU3rHR6CrFCcDd5bHBxgZHSRdP86+JVJdhq7FedkWMx5mm1Y9vBsFTFpTXHJTyMVrrNzugWLo
	tgZo6K2v2/wVwJF+MSM/UNPnJpa5CS4K2RO/bq7ebvHPuH+1flTEjv7baSIE0x5XRyOrKmxKp4+
	FLhccyp+2gQ8xgp22vkVbbQ=
X-Received: by 2002:a17:907:1301:b0:c50:5005:8ed0 with SMTP id a640c23a62f3a-c513a9997acmr77105566b.13.1795122588765;
        Thu, 19 Nov 2026 13:09:48 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm1017804a91.6.2026.11.19.13.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 13:09:47 -0800 (PST)
Message-ID: <a37811dc-80fb-4003-a46b-80614e517314@suse.com>
Date: Fri, 20 Nov 2026 07:39:43 +1030
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
Subject: Re: [PATCH] btrfs: fix zeroing tail of copied inline extent when
 reflinking
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <29d76fabcc56ab13b66b7149638348c9914221c5.1795121636.git.fdmanana@suse.com>
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
In-Reply-To: <29d76fabcc56ab13b66b7149638348c9914221c5.1795121636.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/20 07:24, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When the fs block size is smaller than the page size or we are using large
> folios, we are zeroing the tail part of a block in the wrong range of the
> folio because we are not taking into account that the folio can contain
> multiple blocks. That is, we are ignoring the offset in the folio for
> the end offset of the inline extent's data.
> 
> Fix this by computing the correct folio offset.
> 
> Link: https://sashiko.dev/#/bug/linux-7e417e9c-465a-41aa-884e-d1c65fc614cb
> Fixes: 3115deb381e9 ("btrfs: reflink: make copy_inline_to_page() to be subpage compatible")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/reflink.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index ecef21773027..618556cf1ba4 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -150,8 +150,12 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
>   	 *
>   	 * So what's in the range [500, 4095] corresponds to zeroes.
>   	 */
> -	if (datal < block_size)
> -		folio_zero_range(folio, datal, block_size - datal);
> +	if (datal < block_size) {
> +		const size_t foffset = offset_in_folio(folio, file_offset) + datal;
> +		const size_t zero_len = round_up(foffset, block_size) - foffset;
> +
> +		folio_zero_range(folio, foffset, zero_len);
> +	}
>   
>   	btrfs_folio_set_uptodate(fs_info, folio, file_offset, block_size);
>   	btrfs_folio_set_dirty(fs_info, folio, file_offset, block_size);

