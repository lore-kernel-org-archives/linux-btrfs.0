Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795724184;
	b=H69HZiKsIwfwd77DroHC6S2Iz4QjAFdTG1QPHFmVLeb0PuqbJeOIqeG3+Sd1+tlxljw+
	 M+etF3OfFcrCk9h/v9cJfy24XubXIv6nARzvQVkLNNnFdvxRX4wjlTlt5uqMl0/F5WTql
	 uAMIihyn2LrwRTBTmN3mHI4OzSuV97D9jEzdEjR6iEwKPh/DyN3KvKDtCqR1vYhNn8uHF
	 6rk13gGGuVRMU2JfpOizqEDf16RGULI6Y1Sy3abzU63xh67kZWCLAD/0mTZSq58kfeSop
	 nakMnK8mVJTlfn+ahakmjgTzkvnJd+hpI3LqIUQ2xlHxs2V+vLH3+dQg0laedzwX6Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795724184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=/wsJRCHe7FIbszYgCTAc12a0vo/sbNBxQyzD5jQDveI=;
	b=5FoNoFzbnIOIAhh6dGKczTvMOV++lBgDHWSfeGNFpagWamvyiCI0BHgz01R6LePEuTK2
	 fWpQrkYJ1eYZKua2L8Y9HIW75LiQzWZ4LZK1EMp/91GWPzeOnckqX8qILzHCc48Rdhe2g
	 T85Jsz/hrZiJOUYA+cS0bA4eu9JACtS+Rtmji3E+HzEYp5PHkdrlCm7pnMWoLfnqAZbqm
	 L2jhmCrkH5+e93Gx+YYqoeTk6nMq2qsEODBr7jSK2Dg0hzj1aknGudGweJzMjJEd7zfBi
	 LSc7gljF8W4JFVGWb756h5Id0qjmz3RwdSQ0TtY+h42gq0iOA8LCLVQ/pk9TzLjee8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=f5MARyQo;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA65A606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 20:16:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA65A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=f5MARyQo
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b87a92c17eso10392434a12.3
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 12:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795724182; x=1796328982; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/wsJRCHe7FIbszYgCTAc12a0vo/sbNBxQyzD5jQDveI=;
        b=f5MARyQoy1BOcLepTCdlHPmbpyAtCtsGoVxFFkLBpDfFe0OysxlGSyezXwPXeGvuW/
         uZpHCm5gtXgYObEcaMBkQQqQJ24vWi06V9WlIlVXJPGx/uwrMT7O9Kdfp4HxVk3HTHhW
         k7EH82Qbz+3KEcUQI7PM4j7glFCEmYsF4tSqnq/KsflblIe6Z3/ZSOywIZ0KZ3UAbWP6
         Ry6/AP0H5oiHzrMCp6QUE9cmZfn6iJPGFjg6wB0iRnxzcfFSZOHgRGGwdN9za6YXbix6
         /eulKiWDwhMKsQ63ruvrjNvV9EYplo6NPLSx2TVic/TvAQJ3QRJzzFdv6+HmpPRXUuqj
         WAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795724182; x=1796328982;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/wsJRCHe7FIbszYgCTAc12a0vo/sbNBxQyzD5jQDveI=;
        b=YxcFqeGDR2ngqnxPHZz9HXyUAKwKlG9blFqk9RJLs3hf1OXxN+FK0r+g4YnlgaEsYl
         h7x8xExpMZXfQm8yPxvhT6ST4UnoyaOX3DAqSVYFtVuLd5tZeiABEJ4hj2r1oaLJgZa7
         OqXhLMarJKpeIX5EDDYtyGNbUqwqhfuJvSIQAjTDr3iW7FotlvnbWd4c3W9ZuBGqTxj8
         3t8u+Xu3//cGqnUi1wE4CNxpkjrlA+5jFGO3pzfG0+kBMq7Mlr9TXdLSHGB6o2l/WF3K
         KJ2gaXiw3gCjWxSOD+0mlhpXvpzhN9GZV0ipGbW8AvH6+wiWvhm5JVSsgWB2i8mU15Gr
         kSwQ==
X-Gm-Message-State: APuU4Z/qT3og2stoUEwYOjrfCmR4D9k8gz7Shk6eLYH9FtHmODactZko
	K10rvgOyO+2li9setzopmU3dgt9PVGG0Lu3h1OTCuwzgNsGpc/B1n/6lgLAeujz2Vgnzx66SfR0
	En9Ylu4kkNw==
X-Gm-Gg: AZFdTZdf7rVdyXpY6O24yLo+pEcYrEEOV5Y58U+xiDaSPgVFclqbtjUJP3NdQiuHHzS
	YngJBV+yRaHrnw5+xjYAiXHBSCAac1MwNSt9idcMIHnlXarl5GDN6pzS6KVWqxXFVumXKQnuYUp
	FJ7/OCBGuzb9VB6vYEozrmC2ELoFUAz8liXlrLUkhGT8fID8FSXiUAeyeRv0noBSRuHrqmajH/L
	ATEMKfKMuF52Fw19CjSnoPNwnskwBOcBZQVWETZCgQEYIw6MaqfwpfkB8GZOum8kmwt9rb0qWRE
	Od1L0rEHfFRasAq7RFDYEcK7cPOikOPbKUYIjWxNOnTtg3RdKNisy1IP6okZM44WLlclMB/8ZhD
	8mMgIqjPZj/S8fYJb7G704lPH19mdh8pjNmnItvvL67x+K5qc6AUlZntfKnd72OvonfAGzYbqeV
	V6QqzXGqgbvzbBwJYhQ0JJLvE3SSfC6R5Q6Q03V7o0it0+fC04RrICRagpkwm3CuSHY4kqct+7i
	C2xXvcwpc4C4lrP0cvJRE5ASfESSgjwtlySRivatTaExkwZLT/eNzexaAzTn1pGMYn/5YFI9c86
	9BxsVac+6DrPFh+e4emLjIrkeOXi1nbWCTsFuMm15RI=
X-Received: by 2002:a05:6402:234d:b0:6bb:3374:42c1 with SMTP id 4fb4d7f45d1cf-6bb337448c8mr4124485a12.19.1795724182084;
        Thu, 26 Nov 2026 12:16:22 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b495035339sm21329479a91.0.2026.11.26.12.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 12:16:20 -0800 (PST)
Message-ID: <63b8fbe7-2e01-454e-82c5-dfa5883be88e@suse.com>
Date: Fri, 27 Nov 2026 06:46:14 +1030
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
Subject: Re: [PATCH] btrfs: add a maintainer entry profile
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <0037554862c0d9dce3ddafd1238347e4b16a5079.1795581896.git.wqu@suse.com>
 <20261126155105.GD3245297@twin.jikos.cz>
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
In-Reply-To: <20261126155105.GD3245297@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/27 02:21, David Sterba 写道:
> On Wed, Nov 25, 2026 at 03:16:21PM +1030, Qu Wenruo wrote:
>> This new file is mostly based on my personal preferences, focusing on
>> how to improve the human readability in the LLM era.
>>
>> The new file should also act as a guide for humans that want to be a
>> long term contributor to btrfs.
> 
> I understandthe motivation but I'm not sure this is the right way. I've
> avoided adding the maintainer profile and rather created and updated the
> pages in the web documentation,
> https://btrfs.readthedocs.io/en/latest/dev/Developer-s-FAQ.html . It's
> burried so we can make it more visible, but the visibility problem
> applies to the maintainer profile too. The ones who know it exists and
> where to find it are rare. IME it always ends up replying to mails with
> the link.

It looks like LLM will follow the existing AGENT.md and reach this 
maintainer's profile.

> 
> I'd rather keep full contribution documentation on the RTD site, this is
> more flexible to update. As a compromise we can add the maintainer
> profile and add link to the page. We can eventually mention some key
> differences from other subsystems to the maintainer file too, but as
> Leon also noted there's an overlap and lots of General information.

I can try to push the general ones, but so far I'd say the upstream RTD 
doc is not followed by LLM/human either.

So at least the profile looks one step better than the existing RTD.

Thanks,
Qu
