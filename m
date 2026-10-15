Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EF42EEE69
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 21:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792098534; cv=none; b=CgvOCfCGMIo5Q9/MEaf99IkaG8Pn/lKcGrBwPfvGnn7FtpjcoBTw9g+lVqx/2zD9YJBQLQLC0dyglhFY2vtk9RapQrDo43kj2pjXpZYm2/m1MIljqqwRzSCtr3QTl001lvh6A3OJ+CkP8kLNdI2vW1yG3Km+DUi8v0UAeXQ9eWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792098534; c=relaxed/simple;
	bh=qadG7DpmY0wshPT0WfeZPEfDy1AX8bwXCU9I799zkNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Avp+edIT//zIMOqyStVfJsuZ2TmGDGGkIB0WnyC60vyZMU8Y6YCz3lMZcvyvPOdJC1wEKKQKgK3v+q+HKJm3ClLfVHpj5d9TgyWyeXQDBwe/1+CRJzA3hpu15DkrVDEie5y4mEP41ABzU+ra4wwl/74/s0WMnGZe1zOTomJQ+44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ObDLreQ0; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ObDLreQ0"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so35899715e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792098530; x=1792703330; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0H55KTNpph3jETofIE3FkNkfqSOkMeDAke22JDHaxZg=;
        b=ObDLreQ0vO72k2Dbxe6DMzmME9SIQrZJ/kw1IalBt0vl2jqMiDV1JSCrdG6bDtys5Z
         1iLoAELHTtRbl1I2RkcxlR0MABjQdg7k6z69vWQoT/IZoeG/Tw2fpyHtV3lUVmh3uBy6
         /n7HmPd/ogGPTWSg4/Ev/uwB2sDQ6lkMMNFrZD/QiEd4lRmWech5g99ilWpwV5u0EqdG
         tPsDXKyJJvxrzakK3jxzoVX3tBa8IjwDcl8XeGCt0EdtFEYFPT/fesoIF6dtDlxsAR+T
         u2IEU7F/aY/993C9Lvz2Wy5exAYYW0mNB7I5z7h2yvpM7hw8TjSmizg8nTiky1R5T1tU
         WkWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792098530; x=1792703330;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0H55KTNpph3jETofIE3FkNkfqSOkMeDAke22JDHaxZg=;
        b=nHDFajGu/0Ym7z0qOHD6kitqBe+M7ptn2yFT0nGaifoyHzcjYT+3vOsH2MDP3VuX3z
         3xHzhu6EL9X0WvTCNp0rtKFX5W8Ly9QpDql52P1ym1hOkocaXqpZmU9QgaowrUDQL297
         ZujMVK4eXhW0nrJDZXJhYyh2hFuV+IkdUR8PjnvG9V4GLSZoK6rvl2kACSiogxWitkNO
         SpGTbm6zHSEa/6savFaiFnnfGXmh/qQ74qjhWrQj6ajEIguqQ+D46SjM3ej/sCeQgsKo
         XQrR46LMH6tAQEkTYpSZbnJtvqAveM5p4nkrot+B8erGPvdTah8VZm4vSg68W8gGBgtG
         UAlw==
X-Forwarded-Encrypted: i=1; AKwUvBx8Itzp10x3qYb4y4/lR5KpXPb7k9EyeSAWN2z05I6jfhNjiNL/jWYyiIlWujwUwMigkyAW85Qk/YB/ZQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIMlF7h42TJd8eK8mjm4fsh4eRHU/+lmhJePqyVrJr3+g5EVa+i
	MeecuFV/JOIv/UZoDaoR0YinnVfnrNIEbXdJ0VVCFZuZ+JQr+5sS5TgPFxn6hHYrBUM=
X-Gm-Gg: AYBFou3x6kqAlekoCUYqLB043+FxFa6wFUX4vVLLBhATxxjF+2ISEm/g/WmO4VvdV3v
	39IUq/2pMa8Ne+YkdYp8i19uxm96n2ctiBMRKc+NWrO+5ZyqR20BNTl9u5X4o4OuzqzPlF9ymBO
	ZZfeosIDJyzkVtJ6qbTBRzpb4pA5pnz9cQz3XduP3M3szjc7DOPAmPtrIMCIIb+B0YI7OFh8j1i
	EjASGZnc1EWdUcBJl5mIu68cMbBSm+DgEyI1IR5cxyIb0QkESGvy+9VoqZxYKSMJJKilPCo/tdx
	T05HPUNj2T+yGs334s/2nszeQD0Ps1O/fDp518bMXh2BBLN7gS6yv0dkVObpY9Y54bbmkh34TKw
	H7QbDHrOec5v3UdFAGqIlpK0bFads5pMi3sXE1Twe4vyX9HcQWOxoLg0vFqjfC6kqpgxSOUj/mJ
	gJ/PIgxTHkoDp8gEqAppy96ynKY75UApwfeDbIGCpQveO+j4JD3dKptp/jpWG9SbQ=
X-Received: by 2002:a05:600c:3f06:b0:49f:ce78:356f with SMTP id 5b1f17b1804b1-4a18e4ca2acmr403247525e9.32.1792098529746;
        Thu, 15 Oct 2026 14:08:49 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e5c4b57sm1228535ad.4.2026.10.15.14.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 14:08:48 -0700 (PDT)
Message-ID: <cffef26c-5708-413a-9fb5-939aa1a0ef7e@suse.com>
Date: Fri, 16 Oct 2026 07:38:44 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: scrub: fix lost error return value when scrubbing
 raid56 parity stripe
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <ce83d31f7e25d1f3953fb84cdb3e379aee1864d9.1792086517.git.fdmanana@suse.com>
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
In-Reply-To: <ce83d31f7e25d1f3953fb84cdb3e379aee1864d9.1792086517.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/16 04:18, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we findnd errors we are returning the value of 'ret', which has a value

s/findnd/find/

> of 0 from some previous function call that succeeded, instead of returning
> an -EIO error. Fix this by returning -EIO instead of 'ret'.
> 
> Fixes: fab0c0f03cfd ("btrfs: introduce BTRFS_PATH_AUTO_RELEASE() helper")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/scrub.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 479c0e037015..ba2e27cc5351 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2250,7 +2250,7 @@ static int scrub_raid56_parity_stripe(struct scrub_ctx *sctx,
>   "scrub: unrepaired sectors detected, full stripe %llu data stripe %u errors %*pbl",
>   				  full_stripe_start, i, stripe->nr_sectors,
>   				  &error);
> -			return ret;
> +			return -EIO;
>   		}
>   		bitmap_or(&extent_bitmap, &extent_bitmap, &has_extent,
>   			  stripe->nr_sectors);

