Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D530155A5D
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 01:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786931919; cv=none; b=rCZWQneR2nEonIFPvESRZv0PPz/Rg/Rj5FVMza/UdzQvaMFj0iLsvkVmMaWbR3vIHLGQ6sgoMIWA825oDDGt9Pan/ju/eysl7iMxYRMkj0kLs0RKyeBY33uqRzg5InskgNJZuBwi2CqSa478w+xBFDnhorCwQXl6yf15ZMo5LO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786931919; c=relaxed/simple;
	bh=fH9X1K73Qtur/X+i74/6gehMInQQ3aCszbD5x3V8kxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hrWPsaUb9bnG0AgzQMha0w2oAmT2wirHDpVYqsFKvIsWWAUmpglIEFX/cKISghVJoF5Sv86fmTkGxliHAyawpxSVGVDv+bo85tP4k3B3+2CzfFSI/q5sjAfxDqlPrXYvpwbELEI6XYwBQrIzFDjqlvAus+Q+POntssgM5KVjGjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QJapX5Fx; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QJapX5Fx"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954d29264cso13670435e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 18:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786931916; x=1787536716; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ZcLnDQQm/s4AY0/yIqWhj4qCQ3fkOAKe4Ep5Pm38+I=;
        b=QJapX5FxlNrbhWyXoArc8vwTUyEb2C0jBaSY+Bq4YHG4cLzK5u3xCgNtpQcmZHxHYw
         Sx2FV95sgiFXwub09Undl9sCToDQeyHcjoiFRgaVMULsX8MZ4M1nxIDGICsqxywUvHs7
         pn5nzfcrdYPxKAvMzldWDCFxfGq2plSepbqzgSRrmXdH9CRzbfxcP6eQnAJRCV0sf9MR
         HxkmYrG4Q9xD5GMnYCq5lB5A+sphWscUgdXOiTeH2t3KulGZo6DiF8sj0vJuKg/vKwhA
         J5Vow6AoXHA7sgLN2q2Yj+H8j3EClW5Gwhnfg5e+TO8IS5L4w68kodmly4ZX0Fhtkl5H
         tSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786931916; x=1787536716;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1ZcLnDQQm/s4AY0/yIqWhj4qCQ3fkOAKe4Ep5Pm38+I=;
        b=mHMa2Tzmx1vKWIfUeMY18z6BMpel8CTiZcdyX2/0vMdjH6DhsaC1t8vQUScmyxqWAC
         Sd1fqD4+Op78vbnvFal/2DlN9ylPUPViNIyBIFPR6M1A6cXsZcNV7yYAQndG+1+8RWV4
         lSJWVKg+tmj+3mblTb+78fjppGpXFDibhf+ERezXr5XjzNVGmGbEFXnZYijpBryg5bbL
         5jVQMfa/HiKwyYhi8Y2uE2cyBzs8GcbQyksfbYmBNJk4tMWYKufjxdH96QP14x+bcVxM
         O0RywQQ9/ZolRjqqpqC3saF5iw36TPEYaIyAbBZ59tHRsINhOkf8EYchyU2vn2IagOw6
         uxQw==
X-Forwarded-Encrypted: i=1; AHgh+RqHfo91MD89YVF3x+fe5umrfTu4EOKlPxh9KhHXOvmG+w/hypykBOm26DJRGVbdUqsHeKqzyekSgxS4qQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ1dNmQ6F5GnpDi4fUbMcQ9aT2LVHJ2/X4RH0+hPHWzb/Pf7gN
	8fWSEji/Y86WFikeFWEfahweXobtwBtmodY+Y85EOFNO0SfzmcQ/5/ljApo4grykfbXFdH2ErBA
	BfPMu4qi2wQ==
X-Gm-Gg: AR+sD12jvF7o1Z7+MUAB7rB4ztXbfN9vLdsFRJAi3FkIO7/uYLva9ORZFa8abJPIEU2
	Dv4x5Kahe2zhxv/+p6LCDTuD5dm/kCwEcuLWDVEPGaJdyG/nZBW/Jt8RTQ9epGy35b4xGBmXYVM
	QiLnk3Y9duZmHIk2NjsjOEda5fMSziur2fwd9PN1XcGg5MHxjexvF+w6rDdN4h3Fi7gqkyZ27L9
	2amydeC5Zlk8HU0Y9GYoxdU5oyxvIRMKtZDYxoOoFTQzv+6Ew0ks/Rwd4T4VXKv3RyVNO4tx99f
	ZNHE1BX+8g2510wAwKgLZ/33YlJzucnfAXWGDYE5jDLU1L/F1dICCSR/3RWv+FtugruCpHkBR2x
	DW/j/S8i+Vo+3xbeehcR0j2eXrA7tJCiJi39ByxrcAiBFVxycRnwg6PhRFkKcP8IMpwZl7wova2
	hvab9QXXl2UKWZBysdpTo7yHjkAlLA3y6M9FKvLswdOoSv10UTdNw3Vw==
X-Received: by 2002:a05:600c:4688:b0:499:8807:345f with SMTP id 5b1f17b1804b1-49988073627mr291548715e9.13.1786931915860;
        Sun, 16 Aug 2026 18:58:35 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267be8e5c8sm359439eec.16.2026.08.16.18.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 18:58:34 -0700 (PDT)
Message-ID: <267b4f65-9afb-4997-ad26-d1ff5addce9f@suse.com>
Date: Mon, 17 Aug 2026 11:28:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix transaction use-after-free in raid stripe
 insertion
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
References: <20260817012733.2962781-1-shuangpeng.kernel@gmail.com>
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
In-Reply-To: <20260817012733.2962781-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/17 10:57, Shuangpeng Bai 写道:
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

Please disclose LLM usage.

> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> ---
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

