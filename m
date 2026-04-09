Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14DD3AA4FA
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 09:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775725810; cv=none; b=DerE9LanyCDXWzqly2Jm64eZ5e2vBppKqtr0fFt1phMeRThmMy4NoUa3piLv64qzijfD18Hinr6mNsvnRlQv7Ag1k1kjKH5lp7lveBzG1rRTY2YyrETX4lyz4OGBUFzz/x04fzmsYPI2HKKz9hZqtiHGGuxLRFuluc7/DSUWWBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775725810; c=relaxed/simple;
	bh=aHSCcGT95+kWl6j42ltcbAa4mMZ60X09QFDlZKL+WSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HIeV0Mg5XQACosNMNbo2X8/Lkvm/HJCR6xX2NnDV6tEU5c5aD4M7NSoq+HlNtsZgFxLoFawuj0wE0hMOBr1qmWiRD/ggNTiBxq6MLKO7zYmNcgv+6U5y+SvOCA9NGfVyj0VMcA/JV91ZfwjLi6txIFs1JB3G6ME3OUPUYzqAhxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O0aeGyfN; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O0aeGyfN"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488d2079582so2423855e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 02:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775725807; x=1776330607; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hn1YfMN5dNczp3TPS/oCuceIDSJTLacozfn6OJnroZg=;
        b=O0aeGyfN5lFBCOYOgIlFRIL7fdN6hprr50Rv1fen8nk+o9NgT9uu0SgUWCIb5dLkFt
         8CtKG1qe50ysf4iClSp6TjwhpD5YfMHyoQ2hUfNdJZpjsL2XvXF7zjiyam9a3aDFBnIV
         qy/qBuK1iMBgJ60/XMeh/T0yNs5Qhuv4ucH6nqWS6XfvLkjzdPTsGBm1vce+s87BNVo6
         QZCQzC42C7QJcyij+wp6GmD+xcbkm/OskFfbcZeR2wu43mqg+5YhdNk/jtcg0jgNMwsR
         QwFsVRCjwvSR1XLTdElk/7GKNk/Jlt5LB9bQdJgQxolAfUnMhUA0FuERgn+skyrAkhHY
         wIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775725807; x=1776330607;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hn1YfMN5dNczp3TPS/oCuceIDSJTLacozfn6OJnroZg=;
        b=i+35aSy7iN4izxidBOO6fqN3XeRSsVjvOckSFtpdm1w2vvhTJpIm5rmWnL/VQ+bL1f
         pZa/8o8xWzQ9Qg77l06TwYEEPZW2fjbtnsWvH6CIhVoM3JyyHC6AWSeOhZaHjC4qLC8c
         P0spLx44HzTBZEU49QBMh9oaHm47YZNjlBChtHTTJ8Es0foV4NfDzpiz/FzjR3KPZMCk
         1w+LfmMlLgbIwpjtZgxTupKQlsKyF+0WZJlWkPQRsWBB86SgfUdb7mIVCaQlD+yRAwrj
         JmzkNphlve7hfBeiAXt5mu87XxIJb/okTjVCAZTXPsyjQPLxzWxo11xmsxK/D/tnq3BX
         nr9w==
X-Gm-Message-State: AOJu0Ywfmv7g03UWC8+2I9x8iEx6DGpZnrcWt21wq79AyTj4rGJhE0na
	9ceXv27vbp1abtCi2cseWx1FCrfwARywfwSQUVplA4CUHvM38mqDudj/966SuXzXVBU=
X-Gm-Gg: AeBDievZZismBRbmd5gjimzLD6y3qYURpxSD+i4ldQPr4pqq259lUulPCFj6skU8iO4
	71fH52PkQPC2HxvMtLTemwiAHy9O5mwogpSJbNsJqr/29YH13gNil+AMWPbhc9veb/oII8ae8I+
	j+P9wAr+BoQ39OH6e9tEXmDJcS5077JcPqgDVJe/1FN09Kd6SRobR6kMhhVJHym4IXChJMVV3Zt
	xzWVJn+NhcTz7DXah5uYLWBlJWQ9qV7oN2qQrsh2JCSqDniwya1/B0n1Zo1XWeBBzsZkovB7krv
	JmQAL1SWFuuCgaDFwp6g3A0BoR8a5cBwQH0lAjA6xtL9M/DSkiR17tyNdjQ8I48et/pO46hk4Uy
	mgN0i+hIcpaZIMjD/sQksEaON2+tNRQpDHj1hiYzreLfVHtZN4d+adp7xxC8apy1AVTDBaw15Yy
	D8hBCZ2gGcV5e0x0p/MQ7xkInTLHfLY/uVErkvVqL/GXOwqgD0YA0=
X-Received: by 2002:a05:600c:630a:b0:488:8840:e5ae with SMTP id 5b1f17b1804b1-488997eed8bmr343379825e9.24.1775725806685;
        Thu, 09 Apr 2026 02:10:06 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c65991a8sm22370515a12.28.2026.04.09.02.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 02:10:05 -0700 (PDT)
Message-ID: <baea8ced-c1c2-4a2b-810e-30c957c50498@suse.com>
Date: Thu, 9 Apr 2026 18:39:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: reject empty non-root tree blocks at read time
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
 zheng.yan@oracle.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260409081140.3400650-1-gality369@gmail.com>
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
In-Reply-To: <20260409081140.3400650-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/9 17:41, ZhengYuan Huang 写道:
> 
> [CAUSE]
> The old btrfs_verify_level_key() path rejected tree blocks with
> nritems == 0 whenever the parent check provided a first key.
> Commit 947a629988f1 ("btrfs: move tree block parentness check into
> validate_extent_buffer()") moved the parentness checks into the read-time
> validation path, but it dropped that guard. This lets an empty non-root
> tree block pass read-time validation even though slot 0 must exist if the
> parent provides a first key.

Wait for a second, there is still the nritems == 0 check inside 
btrfs_verify_level_key().

It looks like there is a missing link.

Is the btrfs_buffer_uptodate() call inside read_block_for_search() not 
passing the correct check structure?

Thanks,
Qu
