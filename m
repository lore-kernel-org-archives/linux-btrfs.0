Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2670640F734
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 21:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407176; cv=none; b=LwP+qmOr11XoHdHf6/KfSK1TDbdjFISB515+00RSTE1sf8qThmC5LtLSuQiUHG6fkK6u6bEXo9HNOCX7tDMbFzGhmUXkeF0tb6EoljKWOsHx2n0pZmWZJsJ3HZke+FjRRSWZJA1ELEDtmn0tUKTwPRpkIITuf1Xf7LK4eNzO+1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407176; c=relaxed/simple;
	bh=Z9VpridfUlR+82fO8wAtuS3BcoFUmdlYax1A9vet5AY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YCt6oTeG32C69hzCvFK0aKy+WBjaeBYefP5zbQrdo2ytR37Zjk+Mc4xIMg8EzwkCsXw2FDW7yRkJ21IWjbwqvK5V86vmkA0TAiccD3Z5WkIEqzOtJQ6oqloquQxn7NqpvAkqnrWLhdeRulDOEMLl9l+DuM4aNAucNhl52KP1/6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BZic8qcU; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BZic8qcU"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a180fbeef5so11085345e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2026 14:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791407171; x=1792011971; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bHD2Cp/w/DMT73usVuT37Swqxuwc6wEMA724WvbswUQ=;
        b=BZic8qcUM90Mfv58nXB8TLkHJRVwRCdn5ttFezrvc1ueSt4+Pu3eKIXiYJXgVO4eHY
         5AD8ubPqhh2gGgRKihFOlvEtW+XhtKwSmVlna5qlcp7N1ufXeOBVh6KgPVfNDjgVAfFk
         lSz8XFkAcC+Kp4kOqt9cKzxTZ4IwBLv/QNWycz5zPMnVP2ar0x3UDAcZ9Rc4AxZcT4Nk
         wXY3E8fkHZPvt95c2+0ezbaXGch4VEkHlZy8rk1Ey2/g0hvphJTR0poRsSAnEGrWBzdv
         kEkIpXsfA9wD5lo4ZkhHmrTdS4ewdKavO4h5sAGz7ibKyD8g2fPgLGaA4ig3ymg/IhLP
         DntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791407171; x=1792011971;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bHD2Cp/w/DMT73usVuT37Swqxuwc6wEMA724WvbswUQ=;
        b=SxVHv0BULT2ceD1PlUl+M3xKfbulu9qlnxV0A5XrnjAibWBvRlrSN06ZkLk7WF9ERb
         LNLjFSxfjv0pYsKfh6JSKoA+e4qGxQ7MMPyMhBP+7iv0VIXsMun8UqI8kmJBM1HdiB2b
         iJUtrk/OQ64/c5+xsEsqp2PH4Nu55mvfVcSpXuhDOTAIulteH3MzlX9/h+p7jrA4cmGr
         CFPrYJScPMaLk4rioFiWZnZ/HVTTO9q6qlogOnwEprufHTMlakEpmY1OqXuQbSjNZXBi
         amxxgcsFa7NNIq3vBj4InzCEcMRD7Q5Ng1EgV1EVYtDEXmRAP2/4rXy2PN2xA++xTnfq
         Go5w==
X-Forwarded-Encrypted: i=1; AKwUvBy8Sk2+/kcIb79NMoTS0OTAOddHjMxxv2N8OU2HL1AmEQo87ZVgDL9XilIkzNY8NWaUnDUejW7YXevCIg==@vger.kernel.org
X-Gm-Message-State: AFuF++mQE0aCCP0/uIWMrFf029FC1HdgQ1tHwFU0jVpw1yfwgT9mrvvK
	knTNU4s8sNG9/kn4PDsxblqFnmBnZkiTuARx47tU+VCOrcIFObgucZc6wSlPa9GDAL/r+iQSTm6
	GVJ0d0s+o0w==
X-Gm-Gg: AYBFou1BrX8vi6nX8c3A3dTpVbcLmhaH+pVBOaf5d+Sy1vo85OZkJPPHDIbSdDueHFn
	MVzde9hwS4wc/YZwqzu1fIJfnZQUFtLluoAJPoW5yxucEhPOuFWTRVuqMQW4PDDwLVcWIrX3oQx
	xYF668tQjWEGoJiF3HVC2MdpP9w7oVZMT8wIUkZqei1pXc8mELUzOPWmSDjQ4uBejThVR2pt3Y5
	k7/c5AGhAZ1jxUUphX0weTQqwwmFxEBWbuU/9wHtSvoVci/1uyF3d094yFSlklI0XkvH4vCJKLf
	7nvUmWkKvp95hVTsMbSdFwYwMpu3CnbiDg1+xvjhD3qEOxCI6WLaUSDrciYnGEvE3mk2PELikVq
	5VhX4nBBbg/0QW4nx11knq1ZIAIfJH3caBqUfU/gfoeAEYn2Yf/5KECLZtN3Sykxs9vHLpI1Nr1
	CnQMbbTd8Xw55uF9VexlLqRlTRhTuxzgBCHbXVEm15wWklu5PvNjygneXefCpfWg==
X-Received: by 2002:a05:600c:3b0a:b0:4a1:70da:3350 with SMTP id 5b1f17b1804b1-4a180679e58mr54501055e9.32.1791407171087;
        Wed, 07 Oct 2026 14:06:11 -0700 (PDT)
Received: from [10.86.128.17] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1a7e9e4sm1148612a91.7.2026.10.07.14.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 14:06:10 -0700 (PDT)
Message-ID: <44c7d7f9-8ca5-4f55-92d2-debc8c22a612@suse.com>
Date: Thu, 8 Oct 2026 07:36:06 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: defrag: fix check to see if next extent can be
 defragged too
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <28749bc33ebb6dbb85b0acd298fbff300fc5d731.1791386424.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <28749bc33ebb6dbb85b0acd298fbff300fc5d731.1791386424.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/8 01:50, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We want to check if the next extent is at maximum capacity but we are
> passing the current extent map to get_extent_max_capacity() and not
> the next extent map. For example if the current extent is compressed (its
> maximum capacity is 128K) and the next extent is uncompressed (its
> maximum capacity is 128M), then we can bail out and not defrag the next
> extent too - when for example the next extent as a size of 128K, is
> uncompressed, and the extent threshold is >= 256K.
> 
> Fixes: 979b25c300db ("btrfs: defrag: don't defrag extents which are already at max capacity")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/defrag.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 75c87aee5de9..7010d714cfe1 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -811,7 +811,7 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em,
>   	 * If the next extent is at its max capacity, defragging current extent
>   	 * makes no sense, as the total number of extents won't change.
>   	 */
> -	if (next->len >= get_extent_max_capacity(fs_info, em))
> +	if (next->len >= get_extent_max_capacity(fs_info, next))
>   		goto out;
>   	/* Skip older extent */
>   	if (next->generation < newer_than)

