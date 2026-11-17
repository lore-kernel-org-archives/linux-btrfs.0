Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794893933;
	b=V2pQn8uwo0aU8mC0/mGUC1S0oEcZ9wDRIF+3C+SKoJ5p6btnEnmF9sjA6dP+Xnsz34XA
	 zoDbIIvcd7or6N2HZYP+6kUOLc8f4EjetsESTNDbmXuEAP8s1WI3If2Dpf2/AiV0PQlvD
	 GtOKUR8Tm8r8t6XEctuFiOpFB+42lCqBV7iAiTHAskTKgvEdGE7FBWtAuLN9t03zufeA+
	 jjOY7g5vac4HOkyPg+Q3qmSDp6Er38ZkpRJXC6NGQDU6rdNHLrdIgYW4PS8yNlQ2dBSXc
	 h4GNQPuPhMB/o30e5MmUanR8Vg7xSIOP5dv6nQXB5TqwA87OZ4K5GOL54NrhPrzq2yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794893933;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=i15R/H+wWlGr4uvJa/8sk/uao6pBpjxxY1UfQQh+R/I=;
	b=SBa3G2PIBVqpuQJMxWTMifph1Sr/0CE5HQk5K7PerjSIXWP9qPfr87uKFClC4+cdkE3I
	 rkOQZEx8TUC6+fr1k6sU+paemBg3S31nheXVEa17ujBEhm5M+h4c0+NCQk7ddiklKMSig
	 jbkTEih5QuyPMg5CjFamOrK0pwbs1hUmM6F7Yw/17PsOk4692W+YBqpXwvOLIU9t3Vh4a
	 yd1pSphsAtPEBmjcx3lggVdzjoxk+NPbUQAF2fixD5d+u26CYutTaUIk6Qpr3IC30/vud
	 ka1e68iRsPp4h7ycmrcJZPhsxURBD9qM6GG8hoOD/2I1j8V97QG42fyyggojNtuf9Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JVk2bPKz;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B2E606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 05:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2B2E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=JVk2bPKz
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso26650955e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 21:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794893931; x=1795498731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i15R/H+wWlGr4uvJa/8sk/uao6pBpjxxY1UfQQh+R/I=;
        b=JVk2bPKzzm2L+FNyLQRNLRhwhPaAea1yXiiDP4nIasQqxAx5idlF1H/E+K0d2+G2Sr
         Zga3nTm470haf2t6k4++FZBxhe8n1fekXBlAknUDc3GemBbxemMkpeETpWFG+9f3JCSB
         LJLibe7UpupFqbyqO/0h/xuA9PAuQn6O27ob6jC4kPtZlfvsPLH4+xqcwZwUH58YteW8
         9iMwFJPH1nGDVBX8noI/GHKcfqi3+w4B8hJ/YZrLfjHzYYBGSjDb8I8qWdmplxweaeQB
         6mlg6HQ6KqME+sY5n0icsDdZZerPLRttBO+rZGOnkLaHlmOJLR0iRJNfdk3bYd5nmo7V
         eMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794893931; x=1795498731;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i15R/H+wWlGr4uvJa/8sk/uao6pBpjxxY1UfQQh+R/I=;
        b=Pz2eLAmiOthHNgEmL5Jj2U4x3AkeNG6QpBkhu0jJWM+hy53/ybYAJ3dmeI5hbuJUdC
         BKgbbzuX8psggmBPqbm43XRuMLlDjuSlWiRSlzlv0cs9UQW6GIUpyJ58CL5Qm0O9efai
         Ga02ZWYPzvPKsTVv2WIx8cU48EoHbx7LaNxhs6+qIow+4wtRCR/a4iYsjS12Tmdv8aaz
         Tc4gaz17+WRLUY8s/jiPnlDZhYsV0R1L9brBKwirb9QDCTR5Y3RaZNZq4E9nay9HdRNn
         dFURVnF9dtDVEf4K0vSfD+Z95+GQYi+rzopwUHYJu7q4FVVYIRYuRjJ2oSxJByolA+sL
         T/pg==
X-Forwarded-Encrypted: i=1; AL+hErHN/Mluf9hZidMmS59EmYi2SOq8bOa7lA2qNpgQzQ5i7WSiDTab0BdWB59E92lNVHeIbsh0RBoY/RfzYg==@vger.kernel.org
X-Gm-Message-State: APuU4Z/GezWLn3J3jBtTtrbuqiN1q7fizVlBUdDSYrdlN4Dw9AX3p0rw
	uaWUQtT1ztsSXNUkXdsSKlSUuCv+ah9zTtIpBs3aWtMKY5ciT5hXt99U1Pp7skbXh5A=
X-Gm-Gg: AYBFou2amSczo5ZQzmE2YzyaRsp75VL699B5vpTnY66YATHcsEJReFsHC46cp3k8gvr
	5B+HRCbYVOtBgvSHQCZKcYUJB7Zxxv7hxDG5ODRkLVujs6L+84AfUbY5XxAFT2Td+vHpZ+td+9x
	wc5BKkgcm1eMC+czgea+OL7VzzwASpHHgX0NXhhsRTTgwrqp88eAql9DVngtG+L0VQRTh76I3jM
	s9W2bpPvASC84XjbQg5GG/RZSvVxVi/lPQ4c6HCdlItJ20S5v+X6ItH1DvAsvEL1cpiSogbKSpn
	jLaAdgyV3ilmrt6rfLh08kwEDdqHyCRGk55z6Y0fgBH3hngB0xrBxWOibo4hBYwiMKONmnXm2Yx
	FuEKNT/ngttaIi+UZfzeO5/3ABQOtFKhjz6cfAULF0IDRDODddyQAihPIrn2EDaWV6bT5JcBg2u
	HTylL7GlJokHTfdxO9Yh8i5/PiHNvQemAY5Tgmpvqz9lGpvvfkwICJoSKL44iKZrkG4uctpW/QH
	3w967cMhqj3BY/IWnxVBKF7QMTvzAZM7i9jJpTnaNQdnP6aF0t6a1olAzy4MQPunSubqx2jaexN
	64yVe3rsEe1B4y/0SFOiIQ==
X-Received: by 2002:a05:600c:6092:b0:4a3:5aea:21e5 with SMTP id 5b1f17b1804b1-4bb55a42ff2mr246747625e9.9.1794893930858;
        Mon, 16 Nov 2026 21:38:50 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed263b354sm4377244b3a.47.2026.11.16.21.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 21:38:49 -0800 (PST)
Message-ID: <a6045455-5c90-4a79-85e8-06587f0b65db@suse.com>
Date: Tue, 17 Nov 2026 16:08:45 +1030
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
Subject: Re: [PATCH v3] btrfs: tree-checker: reject file extents with
 oversized disk_num_bytes
To: Cheng Yongkang <teel4res@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261117023841.467366-1-teel4res@gmail.com>
 <35bcaa47-55c5-4b2f-962a-c3168bdf52a5@suse.com>
 <20261117045725.606165-1-teel4res@gmail.com>
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
In-Reply-To: <20261117045725.606165-1-teel4res@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/17 15:27, Cheng Yongkang 写道:
> On 2026/11/17 15:01, Qu Wenruo wrote:
>> I don't know which agent you're using, but I have seen several ones (not
>> only from you) doing this linking-to-older-versions behavior.
>>
>> It doesn't make much sense.
> [...]
>> And the full changelog would make more sense, other than letting the
>> reviewer to jump to your previous version for history.
> 
> The links came from Documentation/process/submitting-patches.rst, which
> recommends adding lore links to previous versions after the "---" line.
> Its example also lists the changes of every version, though, and I only
> listed the v3 changes. That was my mistake.
> 
> I'll follow the btrfs style from now on: the full changelog of all
> versions, without links to the older ones.
> 
>> I think the ram bytes check should apply to both compressed and
>> uncompressed extents.
>>
>> For compressed, it's MAX_UNCOMPRESSED, and for uncompressed it's U32_MAX.
> 
> Will do in v4, with max_ram_bytes picked the same way as
> max_disk_num_bytes.

And Sashiko has some reviews too:

  https://sashiko.dev/#/patchset/20261117023841.467366-1-teel4res%40gmail.com

> 
> Thanks,
> Cheng Yongkang

