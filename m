Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D859C314D21
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 03:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777346039; cv=none; b=YAhPuhxwy/V4BtJM+yIvr5fJNUxmL8CwX7nc7ABQMBV2u9Tss4CAL3ei10rCeoLHqohai/4XqA+k1nxG8sK/+G/Fia9GmxRv42mQwW4u9A9xAb3X0jvwpmkN1CJleMon5cO0ENtoWdlC/+b7WQRo2bk0msGPph44I982ulZvviI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777346039; c=relaxed/simple;
	bh=tu6bnEq9h0T35B9FBeUbZWyV19fHfBWi9XlnExU6Y/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CJQPd9Ep1aWgUHck4rEQ6KqiAFTzKhBL1H8DOKTy/BHcWJR2WLqcK02mSUL/P9+59qboN71ZeWwy8qaVEVLZsMv7ELg5q4QBfl2AbTnrs0aXYzFwq54Zx7OOJVH8hz/YkakcaXPc/xm1/VEDLe/z8p01+ju8gk2pFevbBgmsWzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LoPGcfEz; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LoPGcfEz"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48896199cbaso107834405e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 20:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777346036; x=1777950836; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WLRdx6vrhxqil850JAnuEufxVhMOeWlB+VYeL61H3P4=;
        b=LoPGcfEzgZbp1myIi7h77A5t35Zq+yOTqe/+thAaMta6R/qn/+a4I0VtFGaVql5OC7
         K8OPrpSnzMlSqxAR0+lKDajclLc5dUXVtUmbKAMJ3/0KZ7Zr5/cUsr0QVR9ikxuJCapm
         G/TjjNhin4svui89M403AyNoKG7x74qiBLJYxDLssXoDopIXHB/Wl1VS/QrUjzPItl6u
         auleJMK8VIUI46a4zgqS0R75DH3Im/hj8pjVzzfEzZSNDT8W63DTtCc9LkAcuJgGV6OD
         dzRQWASTlA7DJKdrVLg1/E38Yq/Nd1Bb4nqihxTd9s7O+5/DQgkdO7b4hY1kVjdj7QZj
         QtdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777346036; x=1777950836;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLRdx6vrhxqil850JAnuEufxVhMOeWlB+VYeL61H3P4=;
        b=F62X6xEbXSUgrAswwaRvgKeukWqgNjYsfhYu+5JYxAKQlt3kO4nixKgeBsiQ7B1ytC
         8auFKoRnLZkPsWjXfTTq3WiruGH+T/QCb/h3mDOtzaLPwgvJHtrXjhka73VmY2JxT5hT
         wwFrIMsrqL1UXfHGQoZYCpNR1KlMCc4FtFMyn9hy2DR3J0zGEhHdgWjfBgUppD1cZeHm
         Oqp6XDD9dgKzZgFlpo54DnllvafRyY4EXZ3H0JoZjzgw1qpjf4Ol9kyDbt9bBnLgb8nx
         WsZXGNRZnOradT+kQo6V+x60pBogx+amJ6Ag5Z1N3HhC/lZDvKhiGsfrNTNtiuSTImlf
         iqRA==
X-Forwarded-Encrypted: i=1; AFNElJ+rwy+reQA5VirUPE+rWA3EwDSJxm0KnrsF/eHKRQdTaEqyyJhbsaxF8pmynmDfsgFHuYp37EkUYzqVIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsiVlC3K2G1qLAgkpvnVDH9jDIioXRKscmnb/m7ltKoFPbh98k
	nrAgdaoFEdNufWxl8lJwT0/ViWJzr5n9ZblHMmAlmuz3pILmklHdinEUq+Ra9OnsJzY=
X-Gm-Gg: AeBDiessRPffH+s0+sZoWW4uTXPJ5eo8Vjh9PwnmeCARgxdqq2Pt0TXTl5KqhhzPl+L
	cp0Xua4Xqzyvl5K8+0We5tj7PeqdwEars08tbe1yhz5vOLd1TEG8Kfvm14eNT5TCueKT9THqo+n
	jQ90dWONJ7iAtlvzEjRVTl6mgnTcC2GsDFzDB/iypzqdOuqePCvh0jsdVGhSeUm6JAxKBSP71vl
	uGR6uzOVBkQ6a5fCh1ZtSSSGI9upWLVfTOKewC36zdxrJcwIFOkhEE03gJqnI/O0zydHYwL7x+g
	+PutKawnxmiiGbeAmhcmtFJGE66nd36Mz1qeGzqNQXjFofOSTff0lrRhxHE9O4MEJwOZXT1MsKe
	Ykl+GZzTlDNtOhhFTj8AKts84mlVnEjArB9Lv+MxIWnrA1juzezzqtxuodDcmrWETX480K2h4oe
	8D8MHWazejWs4AGyLrA9Pe9NwvaT4Qicqfd/4utanFoz+POmlYNxgJfXkxJlvMWA==
X-Received: by 2002:a05:600c:5494:b0:488:ffad:6728 with SMTP id 5b1f17b1804b1-48a77b05c77mr18789155e9.19.1777346036179;
        Mon, 27 Apr 2026 20:13:56 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fc2ba84a2sm717715a12.13.2026.04.27.20.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 20:13:55 -0700 (PDT)
Message-ID: <2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
Date: Tue, 28 Apr 2026 12:43:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild <brainchild@mailbox.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
 <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
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
In-Reply-To: <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/28 12:03, brainchild 写道:
> With swap disabled, the scrub operation seems to reach completion, with no errors found.
>   
> However, the check operation still discovers the same errors.

Scrub is not a fsck, from man page of btrfs-scrub:

Note:
         Scrub is not a filesystem checker (fsck, btrfs-check(8)). It 
can only detect filesystem damage using the checksum validation, and it 
can only repair filesystem damage by copying from other known good replicas.

         btrfs-check(8) performs more exhaustive checking and can 
sometimes be used, with expert guidance, to rebuild certain corrupted 
filesystem structures in the absence of any good replica.


>   
> The output of `rescue fix-device-size' is "No device size related problem found".
>   
> After, check still reports the same errors, including the super mismatch.

If you do not want to manually fix the nbytes mismatch, go "btrfs check 
--repair", which may also help to fix the super block size mismatch.
