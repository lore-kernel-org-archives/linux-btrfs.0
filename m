Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D4637CD4C
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 21:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773436703; cv=none; b=t1PxZewuOq89DTFWQ11DWRdxUJ4vVBCNvwDnMwZU+mwSkr/YJFt0zxniV58Uc6P/jpqgRTpifyPNW+R4b3SDhlnLubyL5R2GuxRqbd43vEPV23wdNYzFeBeaXPgHE2TJx65EGrEGYEAhcd6jBJEAxYoVn1YET7exEeHMMbcCECs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773436703; c=relaxed/simple;
	bh=3vWJ19ARNLBiH+wxciIhj1XxiBD+sRkeOSK9Nq7jEeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m81XdNEonw4V/7f/EvpUZi1wuxugDj0Mwmjus1i/lUU12UkTCbYiPMeDvquXkNmQlJJIfc0YmLqZh6wICWj7wY+lF6iHeoiIuDlBELd9Qso8QxaQcLNTUUbHwkfiSrRN5fEz0Q+HhLzA9SONzgEb7fDp/B/LudgRURCzzh/Dld8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=B392UGqF; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="B392UGqF"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48540355459so23314925e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 14:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773436700; x=1774041500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=h9jUL+w3LLozonRWkmy85pJGGu0CB7zoRbVPxPJlHP8=;
        b=B392UGqFCBkZBVBomNalOY10Q5Puc1L/NN+yQ1KdZFOBZXTonWr+gbioCdjcH/Bcjn
         mRZy/gfrfxf9c0ZFGgcwytqUIdgBSBj1r5IK9BMd3hV86m9LioXYeYvC18xcjz1TSNmo
         euK2xKbzRoAFncHmbmkpUtIk6GTwaqb3Xne4/GR43iVZB6o74eWTl51ax7iEWgwmRu0R
         dvhzNT6Ww+QzWQhzkB3B57fmdfEDYqpyCc6CHnkmQWPbF62WMbyDDK7l3eaFOrednojO
         hSHDLy4KyLbkVSI5RkvdAVbNnEyyWNieO/+x1+4l9p0QnKOuOvemW4fpgryc7nL8wzQp
         qdyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773436700; x=1774041500;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h9jUL+w3LLozonRWkmy85pJGGu0CB7zoRbVPxPJlHP8=;
        b=UGKRTAjJt/sugf64vo1qI2xfqSKOIOjqv0TAad0kafOR+2Ty+fZziLLLFgspLXYGbn
         RI1AT8JWLKKbeCTqjDPGLk5A8gHhGEmT8OZY8wWSZ2q24wXvSSP0Jrvpgbur6kpQzI6g
         8eGRuE3gicK5EYLcSh40Z6lsMg5tqy/6DyLVYEs3CbyPo77AZZNpHJrm7bUZV7ypqFWO
         +PwfnfeioyAPaUwoPcnQuymxZPl0UMnw87ThWJrBjHYmVxpNdi1ohecL3VfmaH8oGyUM
         OljIPbwWk4lnoL/hLrfknirH6oWEKn/DYHtfCkHs/xD1D6AGD+q4vCanOBxFVID37fZh
         CqFw==
X-Forwarded-Encrypted: i=1; AJvYcCXAhWxFzqyJIg9AJL4EsEP9x9WENiU4hCnw9DMofAt8/6y/nvbSVyZZunquUMkirRjb+CiDjG6fk1q13w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0E1oWrMkBrNss/XZtobQDnBUhvmBMTBey3aCZ6OQWMX1iznBY
	o122dubRDmr/b0ho2MX/VD0E86Q79aFQxDqJgCCAAWd/vtRIXINblGpPFyNiDIC5uFE=
X-Gm-Gg: ATEYQzyv/iORcdi44aCc+mEyfcTXNwhLFgrWAWyO60MTZphIXyVDXdZmwC4vTUsqf4D
	9+xefdwTh0VxvQApOR8Qaw642pCcGAcp8BZvKblDuNzqX+SxVXXDYe+eOb8Ns4hoU0E+mKD79FA
	AxlB7KFk2ADFxKxV3eiuXrUsYzjtl+aNWLZcIvMHFwWKpC7hNkWJVxjaJpBgdNz7vrEEcJ/YIlH
	x+FfskaQKzB+2O+YEdJSNzrDrHWdLTbDT0hDpd0qZb+ieQOsFMGfmCbuKSOJejK/wpxQojD30pE
	SSM8XN4RPlyNfLAzLcBqYn2UMb4Z2PWl1f2fDjnhCr3oA/MOsqoX0WCBCpIgpmK4gf4sZm04Z2V
	BsxxTk3CRW8V6eGgGuIQMbb1yoOEI2kvGOvAfN0hbmLieglJKrJQ8WtNCf+nG9j5wb36l88m3mQ
	bj9KYv4TV2EMPuABqTX/xxUcvxA+YIXWfQVmdo23GqSYTqqs94smE=
X-Received: by 2002:a05:600c:8b6f:b0:477:5c58:3d42 with SMTP id 5b1f17b1804b1-485566d92f3mr79272505e9.10.1773436699651;
        Fri, 13 Mar 2026 14:18:19 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece82b39esm42640355ad.74.2026.03.13.14.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 14:18:18 -0700 (PDT)
Message-ID: <f54edcda-ef6e-48bc-b828-31eeca545e00@suse.com>
Date: Sat, 14 Mar 2026 07:48:14 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: btrfs_log_dev_io_error() on all bio errors
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: hch@lst.de
References: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io>
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
In-Reply-To: <d2edb3eda4038ef4f2dbd7b76a33a84e3b4ba32c.1773429838.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/14 05:56, Boris Burkov 写道:
> As far as I can tell, we never intentionally constrained ourselves to
> these status codes, and it is misleading and surprising to lack the
> bdev error logging when we get a different error code from the block
> layer. This can lead to jumping to a wrong conclusion like "this
> system didn't see any bio failures but aborted with EIO".
> 
> For example on nvme devices, I observe many failures coming back as
> BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
> BLK_STS_* status values in nvme_error_status().
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu


> ---
>   fs/btrfs/bio.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2a2a21aec817..08b1d62603d0 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -352,8 +352,7 @@ static void btrfs_log_dev_io_error(const struct bio *bio, struct btrfs_device *d
>   {
>   	if (!dev || !dev->bdev)
>   		return;
> -	if (bio->bi_status != BLK_STS_IOERR && bio->bi_status != BLK_STS_TARGET)
> -		return;
> +	ASSERT(bio->bi_status);
>   
>   	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
>   		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);

