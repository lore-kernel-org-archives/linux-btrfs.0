Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792997556;
	b=BDx9Nj9yei1dWte0bi01/HStyZqR7IIb6G8yT7Mk/I2ejLcNbFpRMNMBLg5lkxsPjlHB
	 GPwFWpO+bwU/e/YNDiODUZvR4nEXu3adMBkhzdYs644Ndl+BUcoyh5f5T7irTaA0Tm5j7
	 C+RZy4EumsrfIOeSlYAzR+HTH5s3PQmzcZ0T+eWhp8ZGXDC3iDAEeCkvTg0m6i1/MYp6e
	 W7OrgGhKMLUCtOjA8OozgA7sdw227OgLeNUHXsLVJcuTFdQFP/8yp7jTUWpD4jIXNXfTR
	 1nglftSk0352AysXAL5amJCfxTqNPvQI5i1mPE4irrqD3imLMrOg9gzP41RpXSUrhiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792997556;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=yMkHVJrgkXiylHKHm06Xu7QUXMG7Q5NGsbYNWZu/ZwU=;
	b=lj/2QKP6WHnvV6Z3DHEoGxQY9sn8T2cIjlhyFGl3TQEde6VKG1vxA8U/8pQblO/QZfnA
	 zMxiu8ZE7/efloj95wPcKTZZ/VfZyK/6ucYGw3QFKrwijIDiJxbWPcANXtaNj3ko/alma
	 s2JrTyiviXS+u1zKYP6iEiNyU+mEgRNWc10ld+NTrKA3AVxV3Wsr6mOVSaYxT4s2MWrVR
	 wgubdgSW1XxZbEi7x5xex/559j5XcG/6yNpxtHix450mKqL5dqaE3VKnHH5nFdG1Gz8kP
	 zQbupAsDnrSAEIY7jUjm2pf+0nYbVpt0wEskbqQeRHoIKN9R26Yf09vB7D9sZ3UHJJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=QJMJwrGX;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313A6606A31A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2026 06:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 313A6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=QJMJwrGX
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso10939435e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 23:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792997553; x=1793602353; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yMkHVJrgkXiylHKHm06Xu7QUXMG7Q5NGsbYNWZu/ZwU=;
        b=QJMJwrGXBfHar8n2mBpIejM/9k14EX+mn1FhwieMjHOcZbaCZvgtFwqVMus8lWplbW
         2QrZ/sejE8amQDGyxaaWyo5KDSK+sLdH5fzAgLYsL7ddY3Tz3QZaiV42TXzc+Okb1zI8
         rUeerJ4oCUCQBIZT+BTjEpNBnNylo+MBzsX5lHTKEHNSD/wqKCGqXyB2lNsgwGFeF+24
         /XVEXxO3sTBNEfBzi/Y3gqFyal6uWl5GcS34alwjaAwk7SGorb8afKdW3nSn8J+rsShW
         47R35baLPJUVdda9jSypwIbHirKXAzrts5Zuh4iiOnbFNnmNBf1LX2A/sCDnD++0mKwr
         LFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792997553; x=1793602353;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yMkHVJrgkXiylHKHm06Xu7QUXMG7Q5NGsbYNWZu/ZwU=;
        b=TtrWY3VIXXHafHUTRr8Ir0VB6d7K+5ngC0hmVRRdJrtEyfQEvjdNJC0Lh6wkiHqDMA
         VcopMjfrPtabqBVbQrLEYji5gwjJdLjqwMdZgnVQKOMR4AOGa/g4ajyxRaDpqDTvs/3B
         wBGRY/8DJR1MoxM1mUIwvdajLToY6F6VDXMS37HPAQV9BVOSk13h221SKrL9QL82XkkD
         sKEC0jeL4c854Wc8BojaPAxSPtfzFouKNVZLyFDJtZIZsZVmUkqhKfcFCXHF/ezfdfpG
         /kJEsB5gqMXtEwfgPE0CzWxj2SIRD+yfolSDu2ciHDdBXlze8QfEnbrYsJ1UCWQTYk47
         qmAg==
X-Forwarded-Encrypted: i=1; AKwUvBwTOeHQfZir1BiYmNuHSJkex8zeJmRRGZxkC+k3LH23els+yrcJGm+VuvsXP1jM2DTdbBhMMY1+D2eJpg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLvtSvgaxy8G3Q/eB4oXfGQXBfn4XZY9Dslh/KEmLGOQg1Cp+Kl
	Mql+cBFEJ9CFdfwacOfjDqdAHcrCE2xp4qpv7jlLwwcYE6XPXATcGX37TWVNqJ6O6oU=
X-Gm-Gg: AYBFou3lqzv09fXK1C1EUIbhkzccS+DJStqPsPzCsNottKiQRRls6VUALPQ7kReascP
	dUBh26d+MUaPepeSPZt7N1vEFuC0IiL5KZq/28CT7wqCSXKvgqBx5rnVPOpqavtHsyPo66dkPiP
	GZyFRvtDp9TfArjHUQK8X6qouAuCvRSz4I6L0BNjjW1Mt8z9Gf1wY3RgmIzv9YD88SQBzBiesFt
	o7XlqkzUTDFLVHW1oF0YxndQ2dTWBhB9/ILW9ehoc2s8omil75yLB1x+/9CDvMgEtW5mVRiMaLb
	VxKkc3I6KoJIshxmT3BKQgGbevhQBmMIGrlVeTsJvS92aTnbAffl3/apmJy9sJ93MshYN+k8PDN
	XwRFTRZoUfGCtppXuFO8Wypqlcthz9zR3xL1e/X7elQLcsVag6xGz3/5wjs9r3JL8bexTBhfJ58
	d7ozLTnP+GEeoIR7mjlCSLdPAGIlqBz3WQoeJPmypouiVGZas5gq9mkevK6TruMpWKyukuSuvJ7
	5snluuTn67ofJiBqxJxDrViLg0IOZ015XiB8M166yRO1rHuQd+OapHHrVLh49hZpQu2/Q==
X-Received: by 2002:a05:600c:3114:b0:49d:34:420d with SMTP id 5b1f17b1804b1-4a35acc7716mr97917815e9.20.1792997553574;
        Sun, 25 Oct 2026 23:52:33 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeb819729sm7049215a91.0.2026.10.25.23.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 23:52:32 -0700 (PDT)
Message-ID: <96b705a1-81ad-4e89-af71-a27d009333b8@suse.com>
Date: Mon, 26 Oct 2026 17:22:28 +1030
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
Subject: Re: [PATCH] btrfs: return an error for unrepaired RAID56 scrub
 sectors
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261025180304.349254-1-teel4res@gmail.com>
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
In-Reply-To: <20261025180304.349254-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/26 04:33, Cheng Yongkang 写道:
> scrub_raid56_parity_stripe() returns the leftover value of
> scrub_find_fill_first_stripe() (0 or 1) when it detects unrepaired
> sectors in a data stripe.  Scrub callers only treat negative values as
> errors, so the unrepaired state is masked as success and P/Q
> regeneration is skipped; a device replace can then copy corrupted data.
> 
> Return -EIO so the unrepaired sectors are reported and the corrupt
> stripe is not treated as healthy.
> 
> The masked-success behavior was reproduced 3/3 times: baseline scrub
> returned 0 with "finished ... status: 0", left P/Q unregenerated, and a
> device replace copied corruption.  With this change scrub returns -EIO
> and the replace is canceled; healthy RAID1/RAID5 scrub still succeeds.
> 
> Assisted-by: LLM
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
>   fs/btrfs/scrub.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 479c0e0..ba2e27c 100644
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

