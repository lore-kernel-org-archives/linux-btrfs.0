Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C99C49E129
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 22:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789078894; cv=none; b=HWa853koTJGLN1/MiKgReDPcUquLZkSduGoK5XYQ+5HigbyZGkRR5GkwhWf6AybGAd8YleGz3MQPzSlVHQSjzfXMj2SpX1PZMNgDpnNs5eBspPt3X9Y9cW/D+eo372VBpGcaoS/NCp2p3pMfAKcJMSoUjbEHhCLd5deYnj8aLJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789078894; c=relaxed/simple;
	bh=xa4ng+05mNKnNeKuCUE5yiFJAjyvP2g8z0IfKzU8rvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hlh7LfVC21JKeZo5ggL925bAzcAgw4XqXHA1AyiWEXQGr+v97HzCpIt7cUz8E+FxziNWbaixh6tfQOYJIp96yE0CPjkhYSpT4Kho4II7fEf0itNdonoybTau2mP448oVmK1is1A1DLRFwYfV5FBN5yVOipbS/MpcJEkRvmogG1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EyZ+IOFQ; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EyZ+IOFQ"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a9b7b89514so182245a12.3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 15:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789078891; x=1789683691; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BPyu6SVSSY/lZ0kSKtHwj29Aj+MHmRzBkmpej4y7V/0=;
        b=EyZ+IOFQQ9jMPB04LUxyV2WcyUSuwKBemufG6R4LdtzUcCcLLs795LzepL8LcnV5mZ
         EkiylekJ7NE2j5yrEcTZW4JaAjAqa1VNmCs5dZ1ACFn2Wf8rSrCkN7nhY6UImudB3Jzb
         4hNXZssI7XGmoEI7PHcL0xurndlzrAqpk0bVv0xvew+EB4DLH+AC9t7FbukTUTnTkqp1
         6CG+nfWAkx0nGBrn5+yaVxlWKNdJNurFhlHcKbGkcgMq+CCWG2iLuy/SwFskM+o5QH9o
         yOzqkLIGdWDZ52AQxPMmuY0/h+41ko9coSmVK/t4XOE8xqBAa74zv0s3TEv0OjaBMH6K
         hoNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789078891; x=1789683691;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BPyu6SVSSY/lZ0kSKtHwj29Aj+MHmRzBkmpej4y7V/0=;
        b=AVmtnhMaJxm9eeN34AzhhtPwm0tcY4fky1ngQ6is/FXthFh9K8OrhlP1q4CxSRVjlI
         o5Q0oQutMl55J/LZIlZ5r/ru4Zz8CBJfFDr6xesnREkBh2z15mpTH6rm2EBDVj/2H33F
         P2+srdI/dzpX/wSsZMzOgDO3ZsKgxFndf/lRAgflkuZjpo8uBMbi31MdPjzQwgCObXvV
         i5TkJ94zAotFJbhbWQwVncUZOWwWl52F+2heLBEuMNGb87ptQVIMNIJWUzpbwYH0No03
         eIfBQxutRy0o+eZogZ8gG/rzybJxMUaJDjBV7CmzbI3tN0LCWdPZLwDiiSn9pQMrQQ0U
         Cg7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxv1CCZbBfHQTOt88QdNGyOOtNXsXzWNAGpSd6vbmBv6nKx9YQIi2NvZXA3MxkAcfRMenixk0TeS8EUSw==@vger.kernel.org
X-Gm-Message-State: AFuF++mZcGV4GZTXlop82goBWSsQkyFgKhIfLKjrDBuCEmnlcO3VWppu
	tCA2CJVcjGrpZ1/f6MCrQ9G/PqVpLeNINbMg7PSXXo/+Pea3kyEyVD2PHE86VX/kg3S00L3tGMz
	Bn4Z9XpDMdg==
X-Gm-Gg: AYBFou3QTYqkgv3s9IZI2O2Orwwa2n6ESvX/JFa/Ly8Vdj5V8Wy6PjiuFagVtJIISmW
	a+0gI4yrCjEFv3v7A7zJOyBmhdkh7Gl/6W09nz/0LuxQvrsZ2xauZpcr+hNykJK/G+rp8394fUo
	ZmolAfeaiSbTf1/2Vo9PGPTyXLMlYBQxsrbzBI4hg/v385QOxLUP5On5GdPbyrUiDNgVn2BINi7
	h5FOrOJmT9Srbtxf5UXK1P8tXxOx+nE3ihhyyoV+5aJSUuQKTKHt4Dpa19xF5dmFZxIsB9NUWUt
	10nGZjzQcY325Sg6V1Ce60rZJVhVap/1LxSPA+a17xRf6RWJ0QWWAYp7slwbS+a6+PXjUGA67TO
	Rx/8N1FA7WB1W2/WKPoDPioJJeilzeD82ur1KVWfJbvlJoklUVErocCl4lu7Tr7mckLIkVdh2Oo
	67YaT1E3XHyDL/OKGB8a2iQb3thxzWAk27pJOmbGKfAb9Ssi963kmeu97LVQ0IS4Q=
X-Received: by 2002:a05:6402:21cd:b0:6a9:850d:bb6f with SMTP id 4fb4d7f45d1cf-6a9b56275bcmr407018a12.8.1789078890662;
        Thu, 10 Sep 2026 15:21:30 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b28fd0e0dsm172350b3a.26.2026.09.10.15.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 15:21:29 -0700 (PDT)
Message-ID: <6b0481d1-a9af-42de-9da0-559019ceeb8f@suse.com>
Date: Fri, 11 Sep 2026 07:51:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: increment extent count once when logging extents
 during fast fsync
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <8f8353e08021070f6d5667386705d6b0d0dbbc47.1789057819.git.fdmanana@suse.com>
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
In-Reply-To: <8f8353e08021070f6d5667386705d6b0d0dbbc47.1789057819.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/11 02:05, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In btrfs_log_changed_extents() we increment the extent count twice, and
> we then fallback to a transaction commit if the count reaches a threshold
> of 32K. However we increment the count twice, which is confusing and
> pointless. So increment the count only once and reduce the threshold to
> half (16K).
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/tree-log.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index a00094604e54..6c6b362d7f4c 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -5350,7 +5350,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>   		 * have a bunch of extents we just want to commit since it will
>   		 * be faster.
>   		 */
> -		if (++num > 32768) {
> +		if (++num > SZ_16K) {
>   			list_del_init(&tree->modified_extents);
>   			ret = -EFBIG;
>   			goto process;
> @@ -5368,7 +5368,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>   		refcount_inc(&em->refs);
>   		em->flags |= EXTENT_FLAG_LOGGING;
>   		list_add_tail(&em->list, &extents);
> -		num++;
>   	}
>   
>   	list_sort(NULL, &extents, extent_cmp);

