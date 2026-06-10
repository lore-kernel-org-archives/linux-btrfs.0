Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ED640D573
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2026 00:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781050594; cv=none; b=HkLIYsmRmEPIAPlFST8Q3F9GLiu49Mp90JIwtQcdQySpW7QO8FmRmO8RUIIaXlbXAXaq95lLSzMOJseqcM0PRX14oLmuQaJbOrvhBTBWS3Xsp/p77z8/Ptefsq37GPTb7RBGRSRWsNn/GH9JI6AesmbsomyxHpH0SP+b1kNPbMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781050594; c=relaxed/simple;
	bh=CRrtJEDu74/QxIa31et97un2hMv8iDqSfbmTBYm9+R4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ogl9c7VT94e8I9KLCij3tXjsKgNmXFlF20KWyAhHvgbD9n5P8SR0vVa66WPppK9o5JPDT2lr5dsqTwvjweeAljTMgO4tg9bPksI8PhdGWaearsNeSyEVcpD8E4cB0P17fpLTPtpgbPsjX5K3dg34C35FgBwyPeuOQxaV62aD/h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AVUWgrFc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AVUWgrFc"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso51002215e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2026 17:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781050591; x=1781655391; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yjXP6/2P/mZS0k8lkxHgVDK/PiffilYyOidZC/UvvmM=;
        b=AVUWgrFc0wYp+PyJwo1epny1I2/4C6TtSUar3E7bX40EZGZIv/oE+y8q+D/LxZNNxC
         hqmjEh9pFyT7rVhmtcMw6gQbPA4oBxWASfdMWmDpDs5PHp9DQmE1GG9tsVQbUk3Rogdr
         l/s47AJHEKdHxBDCvAZQ9yg/1OH6uQNbY3+5E6elSolqWs4f2QoSOFxjfNjE3cI+SIy5
         /T2M0sRkA7omJVMAQ1wH/f0J5Yf2S4GUnrdwv8AsZUPLDpsaNhn3xJMWYDRaPYYsjO+f
         hivY7daVhmyNxLYWSple553rqXrJdR44fUHFmpeGx67mYxQqal0GlO23sIOFTw5YpRde
         Np5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781050591; x=1781655391;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjXP6/2P/mZS0k8lkxHgVDK/PiffilYyOidZC/UvvmM=;
        b=PK6SYwUp7IP+APvfXrB9DtTIOfC7nCZN+p/0Ai7WZrwB1/+tGXhbfxqX+AlMjynZhZ
         6bBqfk3TssDGYUOScj9oiJerJLaKWG5ubJjeJg0zwcvtTQxFkAdyAraApnaqUYhhvlvB
         VVVR/VgoZMvjvmF4uQ4VfPDLtqNJhJb/CfRI9Pu9p5Ti9E/uvpKkYX1O0F5ZeiMrGiMa
         Pksz3Uxp7cQpK6OXPD2AtLj+O0oxLQLZIyJRstbvmiarlqOhtnztPLBz85fZZzfScSVU
         qftpwNchMf+ztxSy8OoLqvuspS2E4duL1SzUBJCd6LOy8ImOOEyyrPhl54tit/zY55R2
         2lRg==
X-Gm-Message-State: AOJu0YzKZ1STDlVe+KDTOpUjqAaurggjGc9S3TnQqASz2AU1RkM/eKVz
	zAyaSwe5saHf1NxbI/Ct4XRctwr6HbASF3P7yiF3zy0L2lB7f0Mt3SctIxxfbCuKl3c=
X-Gm-Gg: Acq92OGINUxnGmKr3KtwFWPPtLFBuHnm6jJaDUVxRGW4uCJLYBEzbkzGEREP8ovsRO+
	PVZveGdwLowv+PiZ09LHmPmHLeR2MvnHsA6fAuYsvEf2dlRcqT6hSGIYx9jnLhOL0JWe9+eTBd1
	8lTRx/Ku6llkC/iGKdvcZHxcZiJgZAcPY/qU3KtV5xHl8GbsgjzH+v3DH4NeNVUncG0fJ3DwhQT
	1dbmw3ROv56SoW2N0G46tcVQVEGZwlGzQitCt6Qmg5YZsc9TmW6fxXIsOsJOMlwKiEmIHYP3zR0
	b+Is/kV4nLM5yXVZ/c2Bm+r788pN6k28sAbdR/cTqycnQP2IiGLJRIeDkgQZnK83aMLl5uGo0lF
	uikLv9M0BkKpdIRh2SzHIfD/VA6v+nblmnG8xZC8fqisM35OtljwzcYYWjuecSlYU/ZFyQbXfDi
	byQ02WTfzITjVYAmMVydgWNPxLwfFlOuf3ecL7eg==
X-Received: by 2002:a05:600c:3146:b0:490:9df1:f0d5 with SMTP id 5b1f17b1804b1-490d72345dbmr61519635e9.28.1781050590943;
        Tue, 09 Jun 2026 17:16:30 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf82fecsm20729426a91.3.2026.06.09.17.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 17:16:29 -0700 (PDT)
Message-ID: <f7220873-14be-4e71-91df-f77486dba803@suse.com>
Date: Wed, 10 Jun 2026 09:46:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH btrfs] btrfs: reject free space cache with more entries
 than pages
To: Xiang Mei <xmei5@asu.edu>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
 Chris Mason <clm@fb.com>, Josef Bacik <josef@redhat.com>,
 Weiming Shi <bestswngs@gmail.com>
References: <20260609081135.2972081-1-xmei5@asu.edu>
 <5b33a684-f74c-41d5-8f95-11f76a0c7a35@suse.com>
 <jnoeup5w2qznvycfqkoze6f3pv2dg6wgeoax4kiv743tmiapd3@fdmnmlat7a2a>
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
In-Reply-To: <jnoeup5w2qznvycfqkoze6f3pv2dg6wgeoax4kiv743tmiapd3@fdmnmlat7a2a>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/10 08:57, Xiang Mei 写道:
[...]
> 
> Feel free to let us know if you can't reprodce this bug. We are glad to
> help.


In this case, I stronglly recommend to you guys to send out a dedicated 
mail, showing the PoC, needed assets/step to reproduce the situation as 
a bug report first, just like what syzbot is doing.

Then send a proper fix, with Link: tag pointing to that bug report.

If you want to fix the bug by yourself, and don't want trigger-happy 
guys like me to fix it before your fix, you can just mention that a fix 
is already on the way in the bug report mail.


This is way better for us to do a comprehensive review and provide more 
accurate advice on what to improve.
