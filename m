Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795844622;
	b=Z7wByBabpknriQKGcssPtQYwbdq9yLaO0C49TSYhA29I1kjWwvhZxrnlfnuq2fSLLG+v
	 V98xrd3KliC1wqjR8QrC3fpYrdQzvdcdLh63+IBudsyr8hpcdf+FwbdIluD8qsLA/Jtbg
	 oA4r28YsX3FgQXZUicb7U0jbmlp2mU/HCZQlrJZeI63Qc0A5cuqLaN9g7WAXww9ke1Ry0
	 85yIsAIH5R6QjEBNJ0wJRAO0Hyk85y9YRNaP2QinCLHwDwIyCneotJq2AE7L3cPj98NUp
	 XeokPTOfpdEXKWuVrhPsoMRFDX+94LPskVf3+CUOk+ddTn6Ac6jn77KNoihjdNx4e2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795844622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=bcPnOaDULJWAknTPZNtEm+h4HZFHDsds7HqmJHmlW0E=;
	b=Hq5bs8EyEpokxLLAiqFyhcmjdpmqxpctH8pdEiCZ6c7zrVFA73Sl5SyfSz0QcyUOUQFj
	 kcISr635bdIKZ07SkFBCOsQAs9cQUSR5pnq2Qnr1B5fkIk+ILVhj6vfA0uNE92V7UVUMM
	 w7OkziB9wj1ihS5gKV3QQvIT6fp/FiJ8jmuUibRsyfa4Wymm+PaInovDsrnkEG1cd0dU7
	 gGewqwO9sg8NbgXBkTP36b7IAin1/N2snWJaFcjTXboNNzVY3qTnM15ZlfX+xahn/EfUg
	 EvyWnaBUDKlT97fo5/xm61OTzdzhZoHKEkGa39Jadm7oe4UotPtcnu3dcmj661H+W3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=W6NrKuli;
	arc=none smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341A6606A31E
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2026 05:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 341A6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=W6NrKuli
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b8c60e0d39so11245791a12.2
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 21:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795844620; x=1796449420; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bcPnOaDULJWAknTPZNtEm+h4HZFHDsds7HqmJHmlW0E=;
        b=W6NrKuliSDPJ0DMhL1hyQ4WnYhMq/6j0vdDxnC+tpl0KTj5qYdf+jR+wBkBJ3s3ACR
         tOK1iZYH2J25JIEgrF5yCWY9qk+HJoAibPBDMiOjPnQWeNmRd+ld9TlbM3RgCTet7bl/
         zR0Vyc58mFPzE49I7Bjgjk1Q8YsYafLzAB1iBmZTNTd1UduJA4Jd/NR+PFSCUHkNnJhO
         d+XipmpKTfeUUBMHD1HomW1nfLMpdxyAbqb//OnYr4CGEp1CN3zgRe56CAHYelT3JgSR
         PJlvrTn6pQ/0RRZrF/wbBQYdNm4FERTXG4HaP9RMX4vvq/LTtM1/Pc764EakMnur6PJo
         Fvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795844620; x=1796449420;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bcPnOaDULJWAknTPZNtEm+h4HZFHDsds7HqmJHmlW0E=;
        b=Wck/zrT6hyctXPkkVFDlOXrNtnqfpdHkjs2XgHQ8JVy8FWjwqjnk1sFXelJSRhgcMv
         jUYa/g5UzJWJ1+AqxftdKH3H8UEpBoFbBmlnDuNtfBRoNZD7CxMeO9+woWFeWjpfQfyR
         ch4bktlxKYJrhNZUuZuzJPlCAnI82hJ1cTBRiQ6ocUNCPUDnRWKtAtyEyC+S+hjPv1OX
         3MSyqcKSasfWNq7JbuM6i9r2bU6FHzBzvhxtQnCIFkX5TMWLZyxk7Wgk1tuJtuoQLr1Y
         8WZRauTYhKexhj2KLn35mV+fuhl06QQ3asSwrHn3ZpUPozXhr3/mASYHPXzlPp9Tforq
         BdLQ==
X-Gm-Message-State: APuU4Z+v3bB3GzpOjyxTvzXY1m4g55NPHeYx0WYFKqVXRa1B7cvlLGn7
	CxbttT/XuzkRxagX+UnhZyzDzdz+0+XYB1wfJFqWyxQ+ZJdwfXAg6rLgJ9uS0K4afQE=
X-Gm-Gg: AZFdTZdZf2dti/bxBrZEbKfWNhDIOqRl1gkjs0MVeiZVDrrKFY7Y7+SmnXFvlWEja4Z
	VkXz6uMroDCfp4wYxETg1xPC36Sj12QXvrSBTonD9+1tEDwwX2aYCgcVpPaMTu4LCnlzNkz40sb
	onFfVEg9skU96OszFrGhrWbS2HPsTMpUOkZQtv5bK2U2VdahlhkopjJyxPjtZBFDLdEYOTlgCYr
	U4Gx4+SHqZ7rgm4nQ/Ssf8cg0oqAXraqb3SsNdF2kcUaj5y53fClIbIzaY6mcpBEqkaIbwwqrwM
	bONex2eeGh621g1Gh+xj8FBFEZEA0AZDLu8QHExdOCKH8f9NJ1j2AF8covZU2XnNqoWpiV+eKAd
	G3k83fmXvd0dX2F4hJnqRRCYXITt48nQ0gd57wAYFyyttw8owwPu/XeTlr6EPIvDr7QYi3txEhG
	LyjpvgDfRT5/Kj/oGxiim67m76kpuOkNhxaic4NkEAt6rAq173M5firxG1dT29QXe853+ZBKeit
	EK1AlDOOU8y4iTyu4t+xbH9IdDrsJR61HSIZt6X2ES+ZY/Upua3MzAslzKXlTPGbBd/AhA5mFeS
	5A2GMkP8PfiPO54zpMYNcFk=
X-Received: by 2002:a05:6402:158a:b0:6bb:6c8:c4c6 with SMTP id 4fb4d7f45d1cf-6bb06c8ca6cmr12267604a12.45.1795844620451;
        Fri, 27 Nov 2026 21:43:40 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde7f91c6f5sm11366549a12.27.2026.11.27.21.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 21:43:38 -0800 (PST)
Message-ID: <05837923-9377-4ab5-b46d-ef0124784c74@suse.com>
Date: Sat, 28 Nov 2026 16:13:32 +1030
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
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-btrfs@vger.kernel.org, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <0037554862c0d9dce3ddafd1238347e4b16a5079.1795581896.git.wqu@suse.com>
 <20261126133712.GN774860@unreal>
 <978c5ae0-8cf2-47d4-8fb5-1d96896132be@suse.com>
 <20261127151418.GY774860@unreal>
 <138ba3eb-7225-429b-9791-2de9d49e1fdf@suse.com>
 <20261128045649.GE774860@unreal>
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
In-Reply-To: <20261128045649.GE774860@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/28 15:26, Leon Romanovsky 写道:
> On Sat, Nov 28, 2026 at 08:31:09AM +1030, Qu Wenruo wrote:
>>
>>
>> 在 2026/11/28 01:44, Leon Romanovsky 写道:
>>> On Fri, Nov 27, 2026 at 08:23:13PM +1030, Qu Wenruo wrote:
>>>>
>>>>
>>>> 在 2026/11/27 00:07, Leon Romanovsky 写道:
>>>>> On Wed, Nov 25, 2026 at 03:16:21PM +1030, Qu Wenruo wrote:
>>>>>> This new file is mostly based on my personal preferences, focusing on
>>>>>> how to improve the human readability in the LLM era.
>>>>>>
>>>>>> The new file should also act as a guide for humans that want to be a
>>>>>> long term contributor to btrfs.
>>>>>
>>>>> My previous comment still applies. Most of it is relevant to other
>>>>> subsystems as well, and some of the suggestions duplicate existing
>>>>> documentation.
>>>>
>>>> One question is, I can't find a generic one, nor there is a generic entry
>>>> inside the MAINTAINERS file.
>>>>
>>>> If we're going to create a generic one, shouldn't we just update the
>>>> existing docs like `Documentation/process/submitting-patches.rst` instead?
>>>
>>> See Documentation/process/coding-assistants.rst file.
>>> For example, this series from Sasha changes it
>>> https://lore.kernel.org/workflows/20261126171926.2766137-1-sashal@kernel.org/
>>
>> I think this is against Krzysztof's comment:
>>
>>
>>> Then it should be a maintainer profile. We should write docs for humans,
>>> which can be used by agents. Not the other way around.
>>
>> I agree with that comment.
>>
>> But putting that into code-assistants.rst means it's only for LLMs, not
>> humans.
> 
> Please decide to whom you are writing first.
> Almost everything written in your proposal is for LLMs.

LLM will also refer to maintainer's profile, through MAINTAINER's P: line.

> 
> LLMs instructions go to the coding-assistants, instructions for humans
> to submitting-patches and specific to BTFS goes to maintainer profile.

LLM will also refer to that submitting-patches file through the current 
coding-assitants.rst:16.

So I don't know you are pushing so hard to distinguish files for human 
and LLMs.
