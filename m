Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1E726FD97
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 03:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786935852; cv=none; b=auIx9dEpS5Be0vKAKsElUT4CqoLGuxw5XAgacwKTtETkP8m4mF0xQNHar8BP+KeaStBQym96NzCmn9DQ/yTL8ii3Wm0M4irrAdH5Mw3YaEq2FUj5elTrveKYkuOlZWwM78+ZquB87O3MLUyZxbTY8gRrCrezoz/ks+Np+o4LBF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786935852; c=relaxed/simple;
	bh=WFbg/a/KKA+uW1Y9AK+r2kaVMIMV7pA+QJIwlBZtW94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DsFM5KpXntCTUtMK3DCCFuFNwUUGbb2k5UXPPoNBCgjtI23AMFC+cd8JC7AjcqjoEEXmgfmtIwV5lL439FkmgZ5sAkENJzU+es+tsVQ6vWKtTlPJqb1UsESg0nQ1bb011P1bQ2PLcdnvQDLsC4GpLlBN6VuHD9lYFuy5mZgLXcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ui+76S9B; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ui+76S9B"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4954d29264cso13775005e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 20:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786935848; x=1787540648; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I8L2rqHrth6x5M2B5Wo/vHArDn7IEGRGHh/7DckSvQk=;
        b=Ui+76S9Bqw4p6qoOeObUZSvvtnlEvYx7OyESGvA0AtmLvt1oPeVPYipMKhPASWYUEA
         23IwDTPTpX5kNDj7vTU05oDUxPsK0Dw3x/881DLtcg6Eoy3bBGSw6EeOO8eWNe7aYqJO
         WUR1W6bmOwsGjX4hSvPFHcN+NdJXbIanCU4El4U1xklAeJdM/ZdY9iSnMLEEugariGKN
         +eIz3skqF5Gg5oF8fS6YtCpGHnzSXR3lviaiYOPtsIN0MxVYBXrGrFvNPpFvKjGjiBzs
         oYrGgWSD6q6lHjzEUFRZerL/Wdu0pndNEzP9vXe1r0GTtcBN1s0YeJDTDMMO3rNWiiyf
         /8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786935848; x=1787540648;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I8L2rqHrth6x5M2B5Wo/vHArDn7IEGRGHh/7DckSvQk=;
        b=pEWX7u+ixE3GtledOHIRs+9YnpXTLhUyItAgBa+MEMOlKwCdM8lItSjEm4rLNeyRE5
         yQgU8kCtCS/jHHbTAsZpq/JqxIB55kQuO5xnuip0pT6zkPoYlc0Pf5yEd5AvTM0bFrwp
         +mR1mTRHmjYxUT0DeF1fCtnudnkcR7H0NlyOkI77Fp2xLZTaBaCB0jxfYTJZj1Nwflek
         rPONg6cyS+sXF1P1CWymGNTec1Xrrue0yu55JGpXu0ezJRDytrGpGfu4wCxSmYp1qZ/N
         lfSiPnmrcEqaH3pUVtYyc6ZBPMsbLz14f8V8EoQoEz0mgayv1P3PVu9ZyRXBlh291VoN
         2Xhw==
X-Forwarded-Encrypted: i=1; AHgh+Rrw1jtgPjTz0l0O5AAi1PJ4mZAW5t8sok/gTrQG8GjUAIF3bzj6EqUH/sd4vcQs/vXCGN7lLkJwUStkPg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxms+SJ1c0XEn3y6uDsxMgYovBCgvvbRvgormm5FFAlenyoO+LR
	/OOwnEr6oDStAZXdzOIaxT7cnY5GeOqQGvz1CgcgOrsWYGb9olROTSJHahjwA/kXtylXxSa18FK
	HX3XeQ1BnfA==
X-Gm-Gg: AR+sD11bW0gcPtYsmmkBQ7y0eUphhRYte4zH8IhEsROMIQtBYSusBwp8QsbjVJFGol/
	DLrUJGF/AsGl8hwJBihUGPX8MJLZ5irrTF+qQzmL5U8LS6FOkPF2A2sMVz7fyDINyR4VWnrM3wm
	XUTA0qv/WV3I7KyFyPgNEyLee16AbEm+IvTokwU9vqeLf5UTmHaKcP5zJLZPT4QghYnRsE84XxT
	UZbIcnxnV/8/yIIpFLu8xzgF20w7go/U9c1VjXX2kYzl7GII5mZgb/lRNQFdLyhcT8QFFhvFg0H
	s02bByXR/87Jwzuc2AlZr6FXtr4G9w41vNTDKvgk205x+WWgcu6FASxrDmLWJygVLI7hGWyfT6m
	jHWpXxztVyjh3e1Awpvzersh5CA/xvghLQ4mq2B0u5X6XXCa92FKW68J+M8BrTb3F81yFQOXPBV
	n/3Y+bDnCMs+t/J6pWhM9Wahidd9+N/5cNevwqWUpza2Q6zxdqvhpb3Zkx1eIypZrn
X-Received: by 2002:a05:600c:1914:b0:499:5282:f8d1 with SMTP id 5b1f17b1804b1-49987973089mr330030705e9.12.1786935848513;
        Sun, 16 Aug 2026 20:04:08 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267c8972d2sm705081eec.29.2026.08.16.20.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 20:04:07 -0700 (PDT)
Message-ID: <8e48e984-4df3-4b4e-b812-4b7f20f013b7@suse.com>
Date: Mon, 17 Aug 2026 12:34:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix transaction use-after-free in raid stripe
 insertion
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
References: <20260817012733.2962781-1-shuangpeng.kernel@gmail.com>
 <20260817021512.3010812-1-shuangpeng.kernel@gmail.com>
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
In-Reply-To: <20260817021512.3010812-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/17 11:45, Shuangpeng Bai 写道:
> If allocation of a RAID stripe extent fails,
> btrfs_insert_one_raid_extent() aborts and ends the transaction before
> returning -ENOMEM.
> 
> btrfs_finish_one_ordered(), the production caller through
> btrfs_insert_raid_extent(), still owns the transaction handle. It handles
> the error by aborting the transaction and then reaches the common exit
> path, which ends the transaction again.
> 
> The premature end can free the handle and drop its transaction reference.
> Transaction cleanup can then free the transaction before the caller's
> second abort accesses the handle and transaction, resulting in
> use-after-free.
> 
> Keep the abort at the failure site, but let the caller's common exit path
> end the transaction once, after it has finished using both objects.
> 
> Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:GPT-5
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
> Changes in v2:
> - Add the Assisted-by tag to disclose LLM usage.
> 
> v1: https://lore.kernel.org/r/20260817012733.2962781-1-shuangpeng.kernel@gmail.com
> 
>   fs/btrfs/raid-stripe-tree.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
> index b210371ce91e..89e259a47d8d 100644
> --- a/fs/btrfs/raid-stripe-tree.c
> +++ b/fs/btrfs/raid-stripe-tree.c
> @@ -337,7 +337,6 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
>   	stripe_extent = kzalloc(item_size, GFP_NOFS);
>   	if (unlikely(!stripe_extent)) {
>   		btrfs_abort_transaction(trans, -ENOMEM);
> -		btrfs_end_transaction(trans);
>   		return -ENOMEM;
>   	}
>   

