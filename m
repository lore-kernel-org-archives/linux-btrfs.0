Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C992D77F7
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 01:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773277714; cv=none; b=ePwBf/cMHhpRon9isxFl97j6j7By8LAaar4UfRka6vXOq50HW7Fve9uPe4JWhUyrfLhOs/+B9wCiEjTULyIJfIWnC6WBNYC912OOH64IML3ZBCRVQcJabxVNdh0HG1bno4Z7XWl5WPOvUGElpXwnJG8YsUF26BtP09CdBJ0Up+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773277714; c=relaxed/simple;
	bh=rKNFDbTHc0lSF6fFOxYWab612YoZmGx6F8CEWObMIZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RUbjFzLUNx9NWKAKo7Ruo54WY6gB1Ch8btovWPkDN5yraw4/U3jLD6YdvtPD1+lpNArCWsQ1rkOoLGfjTE8BQoZIPVtRjODDQpRpXx0eUn7maTeXmFZJFxCQ8mh8vLBcbDcy0SXJ7j/oPQ9N8D6WXs0jB/pzKB/Sule53JrdBLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F9W9DKUv; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F9W9DKUv"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48541edecf9so4517555e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 18:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773277712; x=1773882512; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Atuimo6eGtOCZ8qpQceYBSNm8UYMwfwDH3yoSGc6EPM=;
        b=F9W9DKUv6a95QOoBae34b406u3MDuy9seWlEOw3ljc9x90p89Kw44yzY2Z7xwnd7Ct
         KNykesaxi9S0EPuLwT2ns8iru2CQic/icjqll2zTR8SSmReKO2QCT0TfQCL7TjMEm3FP
         +eMML9BufNg8zjPYuQY9EOaXdI7GCroPG2dGdFXXlHp/EC1EY0uJcWuVzYTAkra/5G85
         eXrEva4pRuSIOLUKlwzIlisNpXkSWOE9rF0AswUNDD7dTOPnhre7iZrlGlT9F9jJORRE
         8Lf76X3vNQmI97mnmUpG0fsBk8Q93wcJqqa441XcMfJhJYRKKAST26eTNo9wmFUyzEUR
         /uKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773277712; x=1773882512;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Atuimo6eGtOCZ8qpQceYBSNm8UYMwfwDH3yoSGc6EPM=;
        b=VZssj/N3wUHoqIEjfWMH6oBdDbpjSSNsZ2ZNF9MXpPEJEh7roChWp5JFmp+oMH3XpN
         k/kKiOkMkluS+yqm4q6587RMaTn9lj5xnFOqU9jXuUdD3gF4E/87SIyMf7mVprbPUKR3
         N3/v02rEERwITNXLSnGrsnI5lN5gsRTX2whtPu6ZNIM2ZVe6y+f3ipiLKHSY7LQckw2V
         ieXKSBYqo24GsyShqLSvL48rWT7RfE4TW91hC2bCemurNV3ADgek3DIhjVj78dMBbLeU
         /XoHyDccrlSXBjXlN2kAXxR7pYw0r20a99dW8jpdovTtu4Npyv0BBvo86Q0MoGqd9yS9
         1Jaw==
X-Gm-Message-State: AOJu0Yzc31Eqsr8D7Y1j+OCIjuopOVNlfOk2Us4Kl+3d5i8YsXwR00Q3
	m5N9zg+e5cxOjmyIWBkHZyN4DaOYEA9IfBJZaZEyO1UXjY2ilGCEDS8lRfscAFq0fR0=
X-Gm-Gg: ATEYQzx+/qX6azQdPDo13cLVXgzcm4ca1baXcq0G7UjLQE1Pwhwwh6erkW4W/iWdbCn
	yuJhltek/BB729Gg3zPUUnQudYLP9TaLls6we9hN++gAiC+cG+UXPkzmGU4O46bCJ6g1irNwdNf
	V9iSGhQiciWHtWlBo+8Oo2tvDVSS3L4GDS2lqS7EaxJsyp6adGN+KGIpBL9vW1rM0ZfcSJREqy2
	Z1+OM4w70XuBHFVM7oKuerFcwLSlFmbDka7uTuUN70LTXsO4syc0CPlVADWMY5yoMXbYeFDIPAP
	rYVqJ10TQAJ+QWps4LbGXK9BZKa/Lr01fOw4mjV3+/Jaxrk7vnkcmdurTk75dR7VV+mXjIWWxpP
	YcYpJWgcZGZweT9iBJuwrlPhwW96bJBHwTWw3TBTvFKo6gA0sQ3dp6jYrB/Qz01ptvVWj2kJs47
	vnNysZW3JJwoD2yJkCumYum0UuNpUJE01QE4tT7Y4zt6objK1H9uw=
X-Received: by 2002:a05:600c:8b6e:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-4854b0fec49mr77027195e9.16.1773277711666;
        Wed, 11 Mar 2026 18:08:31 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae222872sm35830655ad.18.2026.03.11.18.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 18:08:30 -0700 (PDT)
Message-ID: <fb3948bf-1000-4626-b27c-90cd011bc495@suse.com>
Date: Thu, 12 Mar 2026 11:38:25 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: tree-checker: fix misleading root drop_level
 error message
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260312003321.3019495-1-gality369@gmail.com>
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
In-Reply-To: <20260312003321.3019495-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/12 11:03, ZhengYuan Huang 写道:
> Fix tree-checker error message to report "invalid root drop_level"
> instead of the misleading "invalid root level".
> 
> Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> [CHANGELOG]
> v2:
> - Split out the error message fix from the previous patch, as requested
>    during review.
> ---
>   fs/btrfs/tree-checker.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 1e052c3303b3..a8c568b10432 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1256,7 +1256,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
>   	}
>   	if (unlikely(btrfs_root_drop_level(&ri) >= BTRFS_MAX_LEVEL)) {
>   		generic_err(leaf, slot,
> -			    "invalid root level, have %u expect [0, %u]",
> +			    "invalid root drop_level, have %u expect [0, %u]",
>   			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
>   		return -EUCLEAN;
>   	}

