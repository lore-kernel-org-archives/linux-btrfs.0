Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637523;
	b=s2SsVl8DvQMv/4f0Z18Td46NSONQujBhboCtTliUrirTpPXJueyk8mHkt0aplGs8NV2m
	 26Txk9KKazkcOZnO9FPxLR/BCc/FtrIQHYyISHymYubN18ou5OoViPSZ3j0kifEt6q51C
	 5EM8S6G8mhVstnksLplQKoLiTky77+fQpy5hycs5/L3UX8H9iwzQNV7E0OVWx1C+/wu8V
	 6DoLeQ3Ky9sDjR6+cMo4uY5zDuXGfeLw6dFG6ET+lnLJ99LbPaQIBd/2xLQHf1zj3RXtP
	 etVg8FnPXLwlHJ645inbqxzlkAnAD27yc3u7g/esWn6B6p/YacJKJmqGYGZfm9spdZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637523;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZOj+wmbfnR4V93/1LXUJrz6FcwePRTn6Ri+meHwW8kY=;
	b=5nCbmo1V+HMfCm4PgEQ5dDUwkO7XfhP0VrjIBaN+OgZOutrwpHGhZkKpqKKw8SkJ/KXE
	 0ztQtxLripRPn2kawVcOVrJWAUgSd/r89kiXU2Vezak883p4WYh4lkO9skTJ5pefxq75v
	 /i2bo31ZodwvhzFOhttoRr2nslM3GHYv1rLTV26JFJFsxQnXps0JHeMjJsbkNOCq+jizW
	 jhe976PuTY9xQVvBYMYb0f39x8n34UGbP3nfP7eNVB2IZSJZEx+b/87spg/YPzZCQD2Vg
	 McsWz2ji8AdaElor11pcpzYk3N358G4BW5UD+NUS0kV8TF+LKCylp6cdBLJBatvnw/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=byLpOVNs;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E22606A321
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 20:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0E22606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=byLpOVNs
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c51bf011392so60229066b.3
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 12:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795637521; x=1796242321; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZOj+wmbfnR4V93/1LXUJrz6FcwePRTn6Ri+meHwW8kY=;
        b=byLpOVNslmcK/4SjyLQRGMIrHLTYO/r2GmoyeCwnaMbYmJSuShotrE4vGex86PRW4w
         88B9Ki4n3X+IL7pbYRXMYKF2dZFP94xR/Myyttoe9UtMJywSUVI8D88aRzqOKkU/cEDO
         lZp43KCP1kgUXd917pH98IAsmkRj7e4MWmDM+XgN9ccv023qxfLD1gnp/VVIEOPYjeqV
         wYtfCUcaebcGUDqAw2AsTZspFeYbxSetfR0PLhst2wXOw0kbIa4Lomhlh9rL2KLGTSAe
         4PzVZ8aGNV23tOcz2SFlIcu+3p8zR2xpH98EoEWazTYfbMSOMU2KHFEtpzhZJ48LVzCK
         6TIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795637521; x=1796242321;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZOj+wmbfnR4V93/1LXUJrz6FcwePRTn6Ri+meHwW8kY=;
        b=PXI+rpPuS/9f99e/kSlee8o5F8sRqNCzlyblGzwm0C5AtsyHK4zZgTFDPr880p+azD
         iDK4KyzYzK1aCam7UggCtsIrioIT7inr4T2Qm0wIvgFxeP1L6H+wloHZWshQRSOYqig2
         0f8GBets3OJo0FWcNQ4PeyCzuMQCNKy4aksxf5YGgYvaf3qorgU2MwzYd+bwXADE0oBD
         x1NTxx3w8x3cyOowQG7evBZWxUZ2UPHBM3RkLIM1JAIHqbnlq3Ru8K9/VMQrjHwLYeuW
         BPU8+euETB4i4fVUhlU9wIzJ8yvNvbPEzZwuZ3Vl9vSwt06dQGQ5ob2u0Ker35CrM5tf
         Y6eQ==
X-Forwarded-Encrypted: i=1; AL+hErHohYhM3NOvoTnCr+HGRnO5KQVIx4RLoUbGxQrOP1gG/57MCU/qYxVPsp02EDfDA78JZ3pdrfLp5n0dMA==@vger.kernel.org
X-Gm-Message-State: APuU4Z/JLjp57cSt6JTnXv9ByU9OPT4t50kYRhEDBowutoD42keD2opO
	sH5ewc45vbwOXOpofX5nhYWBPWetAJFIUONcmVyXEnVLQhsjlsx6W9LYjpdYpBWVmX8=
X-Gm-Gg: AZFdTZeh7927j0ByvEn9CtIScKyyNJSOrUoqt6KPoR5/3D1Q/kfynDNy1GCF/oZzizf
	rt4WHkmQTAfueEgVlvdtJ2JoTrK8ql1zw7W4cl+F0Fpw0Cjz1FehYLpT5p1mPG7J67g0Y2JLMZ7
	mNxz5n1VA14QH+hUdTt4vsI9sPPu59ixyEuMQ9z3oSK3aZDlkwCwCkUdPToBNj7h7Bptn1ZRPrs
	D35bwJ2Yv5gX94jas80jmIzEezHxiqOtqyQNCquzH14kUJY+MPtX0Wt5x+p9bMvT8/++9meP6Hm
	K/EFlcQqoF48IGDPTqd7vjuWP7VdlGyK4cSdHi0CglJsxYZZQt0XW2G+0o67SOtX0KIqX9fSSUd
	4XbC6R8K6PCPSCppReRlTrojeDAHWxrYlkMNUCVAxS7PBrNPMkA6sJprOl5Q8ixe/XIJzKBLSNr
	XjscT0AYmFH4Jq0eq++mzDRQOVfcTlwPmNKeRHQAtr2miXbFH5tEIACrQljlOe254awO5MnK6IX
	ENar9TjIMYPTgy9ZDOqdbgd1sPypdEF40Wu7WADnAd4YB3fC3OK86TqHyorelNP6+B8VG4VtSMA
	Fsni4u6DPRvJiETN830cfK6I0Cw/v3fB6MOcA+NSGjM=
X-Received: by 2002:a17:906:12cc:b0:c49:b393:f1ab with SMTP id a640c23a62f3a-c513ab33761mr1186252466b.30.1795637521004;
        Wed, 25 Nov 2026 12:12:01 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40f4312dfsm30679673a91.3.2026.11.25.12.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 12:11:58 -0800 (PST)
Message-ID: <71c0ba96-c3de-4c1b-81e1-27f224aaeeb5@suse.com>
Date: Thu, 26 Nov 2026 06:41:52 +1030
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
Subject: Re: [PATCH 1/6] fs: btrfs: Avoid a 64-bit modulo in __btrfs_devread()
To: Josef Schlehofer <pepe.schlehofer@gmail.com>,
 u-boot@lists.u-boot-project.org
Cc: Tom Rini <trini@konsulko.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Bradley Morgan <bradley.morgan@linux.dev>, linux-btrfs@vger.kernel.org,
 =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
 <20261125124259.95636-2-pepe.schlehofer@gmail.com>
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
In-Reply-To: <20261125124259.95636-2-pepe.schlehofer@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/25 23:12, Josef Schlehofer 写道:
> On 32-bit PowerPC, GCC turns the u64 '%' in __btrfs_devread() into a
> call to __umoddi3(), which U-Boot's private libgcc does not provide.
> 
> The shift by log2blksz on the line above already requires a power-of-two
> block size, so take the offset within the block with a mask.
> 
> Suggested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Cc: Marek Behún <kabel@kernel.org>
> Cc: Qu Wenruo <wqu@suse.com>
> Cc: Tom Rini <trini@konsulko.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/compat.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/compat.h b/fs/btrfs/compat.h
> index 4596b9d1dd3..e6784884835 100644
> --- a/fs/btrfs/compat.h
> +++ b/fs/btrfs/compat.h
> @@ -60,7 +60,7 @@ static inline int __btrfs_devread(struct blk_desc *desc,
>   	int ret;
>   
>   	sector = offset >> desc->log2blksz;
> -	byte_offset = offset % desc->blksz;
> +	byte_offset = offset & (desc->blksz - 1);
>   
>   	/* fs_devread() return 0 for error, >0 for success */
>   	ret = fs_devread(desc, part, sector, byte_offset, size, buf);

