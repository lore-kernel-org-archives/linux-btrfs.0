Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795122865;
	b=Dpccs9xA5qmdgAloxh01B56ORqnZ+KqS+IPrI2kxEG/aldJXSSnQD3GCZrTw2fLrBBLe
	 yau2O8rHVZIVRfREeWtsZSy701g12ebDmSypWPuTAvpYdVQx2a2ZypMriE4qe2KvxDY8j
	 iwzz0fYYLNJ8so7oD2e5+p0QXQ7XiZfJ136KSCO7pK0hnuo5p2am5Ht23zUNdj8tWJ8C8
	 df7QJ72J7Bvv4FsHFxY724f1NWXHVROYfwiqj3CAHMahsQAzgNLp1PUl5NPY9AeSDV8s+
	 ywX/NNqG2KgbVOw97s42o4iFJRRnDUC1M8BKt9MX0o65436Ov+pk2p38u6DJ4Z8gX8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795122865;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=9h+Avev8cJaSokezSWNSeJS0md15NwHiJ9ch8FFLIgI=;
	b=oxXXIzz+BjRKY4obhrlwOOTfy0873MBwLYpXCn/ioZ601yP4Z3JDYPlYxAToEP/xtTEx
	 EvdpYSqzBsmwxCnK0cXyp+81yE4ql+CBD5B54zDQ+UcBblNWe/H0iSWcXhBkrHwFF/guK
	 YXXunaM3OWQ1fBjvVMyOCNk/oRvf6pZFwZL7crYunc6Y9R6jgI7zwyvrjPxTGY7fnFzzf
	 sRH8AmHqa26JBZIfhTKK0zgOmsqMqaUgw9g2e+jJfpNbaUj3QeM4kaHNHXXcwvYL+OTEz
	 U1X8jhZPT3HpG+wZxEyTVZh9o408XQyl5zsGNu9ULxV2nl4BhpaUSij2rezfMsJtWPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UtLPphqo;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042B0606A331
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 21:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 042B0606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=UtLPphqo
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c50abd5b4fcso34667766b.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 13:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795122863; x=1795727663; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9h+Avev8cJaSokezSWNSeJS0md15NwHiJ9ch8FFLIgI=;
        b=UtLPphqo4JjBP1TgU+ypZ2GQMvEitxBI3NT+fMU5FQGt5wW3UCm0mxxy2c+YE5RpUh
         1rnZQKG2cqMnoSXvdLPX8iZjavTrS3TFUcrOX77Iv+clMFxuOKM5FX5dJxpHorwW5AUD
         ywyQ9ckpWLRpuJHe4t731TcDzHUWnhWtKGKwULHjLa9WVjK9qDzCQbx7ILX+mX6TkTzL
         FTSZ9XDJhxLB8wQJxdawZ2RPNTieyEu5GDmuC8a+Od1j7jnjFCiQLvZ3jOvY/TE/xvIk
         QH/gxuW/3oTDI3yLsqOkbRKsVbF264oAlTvxAqg5XjjY5nrCczvSfnGMTEHIM1WR9uiQ
         hB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795122863; x=1795727663;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9h+Avev8cJaSokezSWNSeJS0md15NwHiJ9ch8FFLIgI=;
        b=XiWZiNkd+kKRL7CiGffM2o4qVTHOz/5/gkgqNwpMg2jOh4onHCfc6RMWuhiav+7Pbk
         /Utf1Jbcmv6SluHYP4Y8y9xHLPAZ9SihDcQ0900rw1Mly7tthmZMm43MuXLGwiIQqi4s
         9XPgmzI4AceHo6Zjc9tNtyODaEsmgsicpF68ckoWEOiWpB2t4Skyo3JVACCVhv3Uw04V
         t3nvbtLrJiRW9yO4ZiWKeEI8kgamnNvzWOavi5/XPsGWuxi7+jZXy1XY8IEd14AjwCby
         n+N4+voDN/a4qxJSAUMrdhizFeo0Zgy9e0+TcC+OZwj9AkvOYiEWETdlfnpvojcjFfKo
         3qxw==
X-Gm-Message-State: APuU4Z8ryZ0mqZMkdKLBlhRnlolZXESP+4Xa1RDSt+zEJhdUeWEUHgdd
	pKgzZVqG8y1crNjZ2l5YKQk0TdPTx83npRncMAGMAHm8V36h4UxmNhpM4JfTwGc7QlkGYHqGbUh
	SCKFi90Q=
X-Gm-Gg: AYBFou1GxbyrXsq89JuYDvF6GvlQ17E+wArUqUFEhzLEos+c33qe36lcLb3ws9Jq5Lw
	2K6Iyhh86rWDJgXW5GasupriD26oUsf4j0nUGFbDqy2T0+mwboqW2mQcEjtb2F5JUyUaqDc85P3
	OUiRfjXc/jmQEnTrdnJ+ItkxSbHlwu2WM9IZ6LQqzQaI5nSCAvpvuK9po4b5oo2zwnSA7KLhuqK
	zXCxmptAVRFvFqXkOjjcDELbnCfMjbSW+cs8EkAuxG7aBm0BW4RHyQIyEsolMXo1Gtc554/w8Yc
	9+Zv47kTWQjpqO1KnPUQzgbaMlkjRWtuAM3249htP1cq3N/krTOzly27+SgHhc+hnLtd8SVQrKg
	xg/gtVtpLw/hUFn+nuEffQVyM89+CU51jiBSDkJzdZzqCUYpE51gnPuHIUCvi20EAsULk/xeBn8
	Tk1x+OBqo8gFRyzhFsBlh9x9HhItttsVKVoUbdT3a7MYRUh1aXgy5PpDl2Bqj8+skHlJaxzt2Zh
	vSRM+g6tEjWyKUMOjV1hRl0NcO/gb6+B0GrpMT1jyHRyvDWXI4CMMQFQm/pCQsphQh+DYb37Uot
	r8y4vFfjLr69dYEVsjzMqbKZReH8YQYS3mmlPxqTF/o=
X-Received: by 2002:a17:906:c104:b0:c35:3880:773b with SMTP id a640c23a62f3a-c513aadb667mr119916566b.45.1795122863312;
        Thu, 19 Nov 2026 13:14:23 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad92c07sm998824a91.13.2026.11.19.13.14.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 13:14:22 -0800 (PST)
Message-ID: <62f64513-984e-485d-80e1-b4ab55f0f949@suse.com>
Date: Fri, 20 Nov 2026 07:44:19 +1030
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
Subject: Re: [PATCH 0/2] btrfs: fix and cleanup for btrfs_control_ioctl()
To: linux-btrfs@vger.kernel.org
References: <cover.1795112801.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1795112801.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/20 04:58, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Details in the individual change logs.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
> Filipe Manana (2):
>    btrfs: fix incorrect memory copying in BTRFS_IOC_GET_SUPPORTED_FEATURES
>    btrfs: use AUTO_KFREE() in btrfs_control_ioctl()
> 
>   fs/btrfs/super.c | 32 +++++++++++++++++++++++---------
>   1 file changed, 23 insertions(+), 9 deletions(-)
> 

