Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3744322F1
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 10:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789381289; cv=none; b=eS1v6zcrDv33waICM5+xbL7flBQx4AR9oXFzBtjytDqUVffiH8YvkaNw4tw0Op0NUNIYmG0bHzDOijQLgrjIq4LI++mKXUJgMz0nkuP+2ARPzVLEZdigjAIWTqREoE/ElPIhDydG5fOXWX1OYpvOOInfCbqN5BTtZdIalknmnfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789381289; c=relaxed/simple;
	bh=VXpebVg7Nldh5Ep1tWZVhxBQDrVdUqDA7c+yyDSAqpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DCtHSDy/uakQR+jVziFevZL1vRTZ1zagz16k2eYBKXOO17fsG6sl01CzU+J9UqA2MbDHfL303PT5a79/ZPwLDPnQpdpav8RZGQ4RHxW5w7vMzVxkuO3qn5ooWNqMzUjVuJ+NdchB+i3+2dRq21cpOuMiBfF0lcwzEwCBJU7hfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eo+o13Ft; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eo+o13Ft"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c294183384fso494477766b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 03:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789381286; x=1789986086; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OO5pmXKOT9/i4mss78wiYzQWJEasfIGqq/r4oOGiH8I=;
        b=eo+o13Ftq46zYl7f+RMlklZfmmBTSocZOeRafSTzap0NlBAVAZ8ASy2yf/Q4Ec8r4F
         cjcXtsqUSX9t1Oa1HUXi9u5QArWhyqg3aWRQS0CHtKzC0gqVcJI4iBSAqziFQGjTS4y9
         7Rwj0cjcbhOmAnhMb4ChhORR+KqFZ5kwmlZ5oAs5j/0hAmhTwUYe17WoICasZQcB2yYX
         enWYAq+DQUtgh/8l3zlzWSnvt+ZHXMuxuxlk+mq9/G5dltsCsr+i04OpDB5iTzVLlaJZ
         tLsM1/rRtQAn8fyDoPf5ruIrKZ4FvazCVoVFcgZLy5gZfdGo5ME8T8DSmp5EQcqwrF8M
         XTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789381286; x=1789986086;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OO5pmXKOT9/i4mss78wiYzQWJEasfIGqq/r4oOGiH8I=;
        b=qc+bkET0GaupxVmrNdqzw6iwZHyZXHOEGStUMj7NB/UMATsr/f3tmZlYjRO2lf2j8f
         HMqUgJcm8BSeL1WSyMPblpLNBS3D+C1SsxQXHJJ+S+aI4/MTf2evF7q3I9yGxA9TxNvc
         tvhnZisFmS2FNm2yKD/MEVa5S4MbcU6r5jSNRbNNUIROPMqtFfzEJ+sMe39/5KNT9Jt5
         AT3482xZdFKvhkgL+V023MqofmmsEeh3WweOXfPRP6GwP1G0Wo2en8lgQMvrpnhZkn+M
         ANKjAm1cZosN2CVeervbj19trz2fLrTvwmeeRrWAS+KHxkzWP/zeEkoRmxqTx1ZSTksK
         b75Q==
X-Gm-Message-State: AFuF++nSKcOV5yAe9f9hp2vWvFjzsIA9J7gN0O7f6p59wgukBlPzhKmV
	0rOPKGeGTEOmNlh2FP8wbl9RT4eUCRi4MmtHIWtcLzOPfPVl0yLZZ2H2L7Vp2F8+KXc=
X-Gm-Gg: AYBFou31Qob5efsvNEv1P2ymnH9TM7rBiooRY2pzs11/aKI/+5NRsevAtfPuwQ0wlYd
	h5Qsbn9pKoU11vSp5kC6JL3Wg5y5zWaESM2y0VYtup1536bQcX2X9PdXbbf6ddrJHOvvXab4R4j
	vsrXHHkDcdinGSvfjUk6bjbtAN3rnJMl9ReeXQrWhGY2Xi5+tvolRQlniNtKfh/Lhf2013rCuBq
	pzYqM/A9Avvc0bo7ChiJo3WAHm2BkdU414T4jbWbKty+MsMMth+GUjG2NtXw82tqQLM1LcUA1YI
	+Q6wYPaP4uln5W2xrM1zsHi8v3mQjGqEblGMWrJBKd0Wampjx9/kI25mqY1FBy3Gr1WwmXibL57
	ulDJHQV0N57EfJ+25wXY0rosYvkWnb4T2uALAj35fivCC1iZek/FbM3rkzoEr4z/hZHB4CuVL1h
	o/eK4LQ5LDeTw+J0KLlcy8XKrVomHGqEXUR27BSK8ZcLzwFCURHu6+nXrA5oL34Ro=
X-Received: by 2002:a17:906:eec8:b0:c26:19e3:e981 with SMTP id a640c23a62f3a-c29b875e5b6mr121146566b.33.1789381285743;
        Mon, 14 Sep 2026 03:21:25 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9959ac65sm19856927a91.16.2026.09.14.03.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 03:21:24 -0700 (PDT)
Message-ID: <3f3209ea-44bf-4dc4-9567-d936703435d2@suse.com>
Date: Mon, 14 Sep 2026 19:51:16 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] btrfs: discard: fix warning for discard_state
To: Jiahao Li <lijiahao202609@163.com>, dsterba@suse.com, mason@kernel.org
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jiahao Li <lijiahao1@kylinos.cn>
References: <20260914092222.1465563-1-lijiahao202609@163.com>
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
In-Reply-To: <20260914092222.1465563-1-lijiahao202609@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/14 18:52, Jiahao Li 写道:
> From: Jiahao Li <lijiahao1@kylinos.cn>
> 
> Building with -Werror=mabe-uninitialized fails:
> fs/btrfs/discard.c:553:9: error: 'discard_state' may be used
> uninitialized [-Werror=maybe-uninitialized]
> 
> The compiler cannot prove that discard_state is assigned on every path
> before it is read.

Compiler and its version, a lot of times such false alerts are just 
compiler version dependent.

In my case, gcc 16.2.1 failed to reproduced this false alert.

  Initialize it to BTRFS_DISCARD_EXTENTS, which is the
> state the variable holds when the loop is first entered, this does not
> change runtime behavior, so the warning is gone and the value is always
> well defined.

It's a false alert.

Firstly if peek_discard_list() didn't find a bg, btrfs_discard_workfn() 
returned immediately.

Secondly if a bg is found in peek_discard_list(), *discard_state is 
fetched from bg's discard_state.

So all paths should be fine.

> 
> Signed-off-by: Jiahao Li <lijiahao1@kylinos.cn>
> ---
>   fs/btrfs/discard.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
> index 1c304bf473e5..413a804ff46b 100644
> --- a/fs/btrfs/discard.c
> +++ b/fs/btrfs/discard.c
> @@ -519,7 +519,7 @@ static void btrfs_discard_workfn(struct work_struct *work)
>   {
>   	struct btrfs_discard_ctl *discard_ctl;
>   	struct btrfs_block_group *block_group;
> -	enum btrfs_discard_state discard_state;
> +	enum btrfs_discard_state discard_state = BTRFS_DISCARD_EXTENTS;
>   	int discard_index = 0;
>   	u64 trimmed = 0;
>   	u64 minlen = 0;

