Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890142;
	b=UVJ09saFKog1AeYSdDNqNQYAl6trSt7VPC36zkMx7jxtDmT7LSuA9TkxPHxvzEv71ajc
	 qfT0OrJ4st0y9TAUOJZ3ihNZp1bgJ+XOJDAJCt01glbej3o5ieMtMKTWEMH/AjAyEagS1
	 5kYLrLma8AXBjmhp0cnp8nmASrDUV0SK6ED+I7T69d4shBUepmuD9m229ZoaFINs5Oijr
	 ZhuynHOrewIk1YG1mWR5SOaYZa70CgSxO49+iT/NmoklYAq+OFaCyrYYKusTL0U+UsEZd
	 vusw2EBtlScFZMcu9HuEFRD97BbeWHyCHTv7HTYetM/odtB3yn2/PqJKKS5GudimZgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890142;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=daroT/s6pgatD+xL/C1aynjiNgPs/2jftgYJiHOkg40=;
	b=sgJBsbEq6Vm1g+MHEgxH4n8UgtGJibK/fS+M2swyiSD8VA4LqzcpZz/Dg9O67FWg6M4e
	 fpZOa4nuscaIGYKiyL2KmWH3fqgoRxPr6TEF83N6YKDwYev/5/ILfK52WdexL2BoYBfYj
	 yp8GM8CGGtJeN60CCAbyJNcIqp0M9BBwBCBpMNl66bf/Ru6Bu+bu796zKaixGVrAjSLmR
	 A6q7KsGINc1n0mNsaV5+f57G9cWVK6imet6QK40iE1y0NW8H5sc9d98u9F0jmtkeBcyfl
	 /IfLEbIaoKj8nb+8DzwfaWIQjXZv7xQhhUMaOk4Leal6WyI+8//Uux7iCqZ/BMsehGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FZFX4T7A;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16674606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 04:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16674606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FZFX4T7A
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c468bd799ecso624105266b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794890140; x=1795494940; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=daroT/s6pgatD+xL/C1aynjiNgPs/2jftgYJiHOkg40=;
        b=FZFX4T7AHlUeo/Awpzyfn7kGCBDJnhrroj11f9bWGSnNN7/gR8KpNwsqHnvlC3LFBw
         vWjNl1xpx/15ye8Luw7sGKOeIJJSZJbQS9BtiE3jp7FCg31bk5bu2NKDdyTesigwQoLS
         9lBDASoZLuL0C6jBLhOe6ew8Hor5DzkzkbyhTjQYzNzDfGA1cvVgC9MtmvGsKv2lFaXd
         Kx92Eu9wpWJs6MSRELWhUsaSCC2kAdMQimgcYKaQaJD+oJE81aeyW5iRZE3odfYSlBAX
         4ewWyC0X0kmlbZEW7harZANz/jcUwiJyY/nbxikwqBQ9txbtmjKNkDqt0Wb5R3J64wws
         Xjyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890140; x=1795494940;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=daroT/s6pgatD+xL/C1aynjiNgPs/2jftgYJiHOkg40=;
        b=Vi962ZrnyJq8O4Bj6LogFQJtmoZRJczoe4v0KHk2h6ah7ktxnC4bDFXy0t8oF5hG9g
         4EKb7QcB2/tBvK4tY8XpEuQLwbFVNkrtdS5Dl1Rjj0VIoomlePTgZsqmTCbJWv0EaBAw
         3Xd7wDbyAe68ml3d7c2JmsuTcIOyHxrt5Ir1gIK7qCOKx7OxTe3RVczt4hAhf4V6Ob7x
         l9DgK7wajZfrY/heoDsTV52he6IHoj68oIa3GaJQEziZe4HBMOImqts96rq1Hlj3Gd2q
         g+dZvh+qyeLUI/SNXaueD7RB1FWcDpVa2F6NRTkmZISiA0lHg0szHQJ4wxOIJhuQCpEX
         Z/zg==
X-Forwarded-Encrypted: i=1; AL+hErHvT4eDNmUgHvfk7g8WR2vKvxFZJBFPMKpO0Wn+IuZYX1ppTOuzQ8WZBJTNwPK7ZKlOk0+fbfmQd32Zow==@vger.kernel.org
X-Gm-Message-State: APuU4Z8BNouS3m1nD9KtYtavbtEFwVK/Zd9I4d2E6hMmAL3Hm0AaYCcm
	2KP7GJAKPJaboHD7F5tMEQCgqqp9CyhG84HdGAOBN7qWLpneuOX3Un/Shwd7quFYLm0=
X-Gm-Gg: AYBFou0kY/yWuJdUg4fn6Emj1WXwEH94aBOQZ/FCaNSUicov6oeni8MoHzZbYZtpD6a
	0S2o9hfwgKBAaVnqBPbJdyzNaKdEtV2tumi4JZZZmnMs6r2lMHvSIep+lbLWS1tyKmhxUloYsiQ
	qBukXojCf2XCjG/DiXjaH0PgcYjy/llJu7Re5BuqSGwvI/NrbVq6B+0e5u2ubBwnTM/9GucgD5w
	DoMx0Fcv1Io2ORg/Lg8gQSum6l8EGCcjY5vLCTcgWe9oO6fnhkVHUfSRxOFc8P0BNAebX0cHZ4V
	dDPh2f00DICam8QI+ycDGt7Oi7PzCqPUOnggv4UhlHmAKKZUsRvVlcStRovMbPkQjoCjndsogNP
	4+Zl8y/YIxi7MnmqOfG3Em/fJr9k5XWsNQD7l0xn3nT2YOqLNzXmWqy9DBjqesrGzIM0fR3E0+N
	Bc+Ufydfm1+Eau6aeRT/d2P4Iz0gSg93A/XsPsImeB/ceUP8XlqwOtLbbaMhMJ+OHwAOOY0RbB6
	8IuRm+MrasKVtrCB4cxFKE9EeC7jeUMnBzOMjev5UDBqSKOR6aymdsR7nzsCJIsMNrpz+2yS4Qt
	sjRw29K3GzQ75SlB1n5H+1fqkWyoOgkJ7Jt0pil7zAE=
X-Received: by 2002:a17:907:d0a:b0:c2d:d408:5d9c with SMTP id a640c23a62f3a-c509684ba8emr947663266b.48.1794890140325;
        Mon, 16 Nov 2026 20:35:40 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a81e42sm6928845ad.55.2026.11.16.20.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 20:35:39 -0800 (PST)
Message-ID: <1d3c9236-89d0-40c6-adb9-31299a96b6c2@suse.com>
Date: Tue, 17 Nov 2026 15:05:33 +1030
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
Subject: Re: [PATCH] btrfs: tests: zoned: fix NULL check of the active bitmap
To: Yifan Feng <evanfengff@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261117035155.86323-1-evanfengff@gmail.com>
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
In-Reply-To: <20261117035155.86323-1-evanfengff@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/17 14:21, Yifan Feng 写道:
> test_load_zone_info() allocates the active bitmap with bitmap_zalloc()
> but then tests zone_info, which was already checked a few lines above.
> A failed allocation is not detected, and the NULL bitmap is then used
> by __set_bit() and by btrfs_load_block_group_by_raid_type().
> 
> Check the active bitmap instead.
> 
> Tested in QEMU with the bitmap size temporarily changed to UINT_MAX so
> that the allocation fails. Without this patch the kernel oopses in
> btrfs_test_zoned() with a NULL pointer dereference. With it the test
> prints "cannot allocate active bitmap" and fails cleanly.

Remove testing steps that no one cares.

> 
> Found by searching for a NULL check that tests a different pointer than
> the one just allocated, with the help of an AI coding assistant
> (Claude).

Also no one cares how you found this one, especially it's almost 100% 
generated by LLM.

> 
> Fixes: 1ba19a6ea9f2 ("btrfs: tests: zoned: add tests cases for zoned code")
> Signed-off-by: Yifan Feng <evanfengff@gmail.com>

Although the code looks good to me.

Reviewed-by: <wqu@suse.com>

I'll remove the unnecessary commit messages during merge, so you don't 
need to resend.

> ---
>   fs/btrfs/tests/zoned-tests.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
> index 2bc3b14baa41..bb9969210444 100644
> --- a/fs/btrfs/tests/zoned-tests.c
> +++ b/fs/btrfs/tests/zoned-tests.c
> @@ -65,7 +65,7 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
>   	}
>   
>   	active = bitmap_zalloc(test->num_stripes, GFP_KERNEL);
> -	if (!zone_info) {
> +	if (!active) {
>   		test_err("cannot allocate active bitmap");
>   		return -ENOMEM;
>   	}
> 
> base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3

