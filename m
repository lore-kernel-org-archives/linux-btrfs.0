Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8163BFAEE
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 23:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788910044; cv=none; b=nofLpg0LVBhF/rGvz8/uIZU6jmXezVfWmETGiW8Uhogh1gWU41cETUhKs2BW39qXoMpBpEKWHRa5bEhS61mMyWVIWbyao26izynVk0EAu3WJ7POcGf5unSdjTXx3s+pqg8O1xOR2/O+qGfZOEjPZqv11hwAfkWI+t0u+HVkhaGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788910044; c=relaxed/simple;
	bh=aA7naFOmKiKH3pqg037i/RkIUxfjrkWg3ooAImp5GaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pZwIEO2jAqZGqQPZ56doKoRdBm5XD9upNh4Q3vRjHQz0GjitDl7wVyLQb/bYtpEMwl6tR4BGjdQbnQ3dtRPlWqAnnXn3iKlZA5fAIunUIKluMcLWVwngR8LNhb2PFBXPTNwI2dmN11PknzdOOt9EpKGUyFIrWtB/05flY4RJXRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=caCAb3lb; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="caCAb3lb"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so73024365e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 16:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788910037; x=1789514837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BKungc95W8zvsAh8Dlqssw4+0Qh2FdJLHVTyAL+LA2k=;
        b=caCAb3lbsgC25U2ObztrMMrubkBdjM+4BHeD6H7x0yeQ+42LmGnz3LqZ+DbXveIGHd
         7EyTF27YPPJEPZQiYZrRmUfxp7aFi5ANSNrtGj6cHID57kJdgQw0LpDKnhFB0/XQbero
         zhz107TGCufT6zpSpgDTSwhDwrhwZmhTEsIDo59+7OHrh/th4W5CxvKAolYbn40X1vh/
         S91MgsX3A6A0+3tT5f1lUNxYHIieUlIUUhtvO4ZxjYHv+ZX4c+nZmOcB5wLuWi7ZztiR
         PcR902ZBnX/Co18a4WHzV689sX8sX6rQSQeWipcQGLYS8J5LD1EaF3hIIkYbVRIkWXFg
         8lPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788910037; x=1789514837;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BKungc95W8zvsAh8Dlqssw4+0Qh2FdJLHVTyAL+LA2k=;
        b=jWXSG8EY/fhdZofLSUGRfRn8xrEWLci68vLflQ7i3ZNdXdlAW1viWg+5otuJ9chMMK
         bTXt8rZzpw2TgbCt9bhQT3Fm5t8Sv+9KXCcDUQSvMswpPMBDCMYhQz1vAeVUDTHL/rxV
         gpm05i7GGUtgTtItVxwmt4+f/HcjWIFygEt8wY4YkMtWmF3JGrzet11q2ueUbQcv+aTJ
         m0+Kzvcyk6RPmxwrIAxeZa2/cnL3auaj6q5K9cA6bF7R0vqAJJvL7FdSYXq31iiQy7GE
         sNXfbEdRz/5L7y38PJ1QkkyZrC075BtlkPztv7C4tcBaaDeYDkkTJVMC/kOaDQFSEIIq
         8WTw==
X-Forwarded-Encrypted: i=1; AKwUvBxqYRCoa0Tsuk4yWLCoiOGatQyj0J+IYZcvtgp9Krox4IG4RWyQ9It7Pc1+5PpN1KmbT5e3QfKu6gZR1A==@vger.kernel.org
X-Gm-Message-State: AFuF++l4Lcr02RZrXkojuXS0PBSeXAIxzpkfY4UjOkGPiEBE1qR4VGaJ
	CZ52ztMwQKKJtHnDsmCVkVxAHNJSXJVsk3WNuXt/URuJqS1NyhSb0JbCI7IlSh/ubnQ=
X-Gm-Gg: AYBFou1n/2qu8yFBD7m3bqdlI/ZqHRrY2meneH+4ryyG+h1UsFwDl5UGupFcQF9ckH3
	qetVBd61PF8hCN+FSHAvgfMMAtLegdg3wH5o8WO9ASZOpsrZyO13SwcxAviicvIp2cWq4lISj1T
	oqe444LHR9Nvw149p5dhDNbqtmWuowAVmjfY0oQBLUjC99QeHQ0lhVMxT7VKzkpAMTd0sjDuNSq
	EKuKi5JxGmH/63yU9FZ2qBFlCF7bNmVO5pdWtznyMSbvrTlw4ngTKmbN8p2nu5u2QkbeyBpmhO1
	xp3arHDrTJOGb1J2y86ic8G/v1gK/Lk8ka6dug11n6YPyKEu0Yvh8g4RsujsjK5nVpmxKxEUVOs
	l1EFHqgrz+/acJ5AIQddgt0Gh+sOMBzXrXEQtAcPMVwsjlSh9PttW1saff2xNT4eKdWgHk3UUkA
	3TRr29anjdILkWoLw5z2UdPT7S0i7d615Lyj+zU96Wu/lzB6U62vflhg==
X-Received: by 2002:a05:600c:474c:b0:49c:fa21:1c8b with SMTP id 5b1f17b1804b1-49cfa211d53mr283798455e9.32.1788910037324;
        Tue, 08 Sep 2026 16:27:17 -0700 (PDT)
Received: from [10.86.128.131] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db149cb5f0sm64965105ad.67.2026.09.08.16.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 16:27:15 -0700 (PDT)
Message-ID: <79173e81-f276-4645-a2a9-9f90128c94ce@suse.com>
Date: Wed, 9 Sep 2026 08:57:10 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: btrfs: My gripe with GFP_NOFS.
To: xavierbachmeyer182 <xavierbachmeyer182@protonmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6SRUHO1jWdUSQhTEPij3Kig63B1oVIl3cq3lkj-NZWUs_fyoMiPoOg92ZpyPfcldn4aHZDgGmpI4p70Rf5kqll4lmwBKqawCMlapVVg1Wm8=@protonmail.com>
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
In-Reply-To: <6SRUHO1jWdUSQhTEPij3Kig63B1oVIl3cq3lkj-NZWUs_fyoMiPoOg92ZpyPfcldn4aHZDgGmpI4p70Rf5kqll4lmwBKqawCMlapVVg1Wm8=@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/9 07:36, xavierbachmeyer182 写道:
> 
> ( I sent this to David Sterba as well. )

Please send to the list next time.

> 
> Hello.
> 
> Let me preface this by saying that I am completely clueless when it 
> comes to anything and everything...
> 
> I don't like things like GFP_NOFS because I feel there should be more 
> graceful ways of handling page allocation failures.
> There was plenty of memory (contiguous or otherwise) at that moment that 
> could of been freed up to satisfy the allocation(s).
> It's not like I was running anything memory intensive, just some 
> downloads and a archive file extraction.

Your available memory can be fragmented, and Linux's page cache can use 
up a lot of memory.

> 
> I know GFP_NOFS is used when holding locks and such, but still, can't 
> exceptions be made?

Nope. As long as the operation is in the write path, NOFS must be used 
or it can easily deadlock.

> Like if there is a bunch of unused fluff in the page cache thingy, that 
> can be tossed aside without issues, right?

Nope, the same as above.

> I'm also curious about things like folios and hugepages and such, could 
> those help any?

Nope again, huge pages/folios are just physically contig pages.

Anyway the kvmalloc() should fix your problem, or at least greatly 
reduce the chance to hit it.

> 
> As for the 64K nodesize, I use it out of habit, kinda like using sha256 
> or blake2 for csums, which had a similar issue in the past.
> 
> Thanks and have a good day / evening.
> 
> 

