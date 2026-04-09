Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8E03A4531
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 09:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775727518; cv=none; b=U3a7Z4XWPUFpghtbgazoMUT3OgKzUVvRZT6N2/kdwzOzEa1l05t++vsAC6bYMl5jkiigh56nMHNE7Ar/qp0uLEnXMV062TKzCcqlPL+/oXQfmzaHv4G1pAhk2ISsDWv9/G/OYW+T2i99CKbdHdGibYmlWOz7AceCIiS2mfFiopg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775727518; c=relaxed/simple;
	bh=xCcBvd9nev8dZrsI2lqpu3H7Qt9H8FAKp0Z64IDArpY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=BKYdRggEk+PoB09lovuK1lLHYOjWv8/P12YIasWeVafccFo2Tu+86mpUI0VX32g/RiUMZMWWz261ZVV/b92CMbcIV1Gp4XtTBR9ORhp9hx93/CfGtRNqZUngY9wtShb8CpFe3PpgEeEao1QnmVf/q0j+S5ljFVpL9ybkuas1cE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JPjXNxZ7; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JPjXNxZ7"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b0046078so7168015e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 02:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775727513; x=1776332313; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=38ZrH1Crcdop27P4rVvBC10kiE5Ph7GbdYYASQ5oT38=;
        b=JPjXNxZ7mNEzvsBJOLqB09uCu17xgMnJ3LcmbsGLrejhIcgKuAO1BRzI15q3xWxIsZ
         FCZxFNQd2RYBJwcX7Gnm2kwsxLJzwnKupBste/52jpgjPfdYOOlrQzVCpy998qvQduzr
         EpsmVlagfSmCV1sppbcMX9+0ylKsxzDd8rgzoMpbWCcK3xQVLPHquP4+MPSmeWd/aUhv
         nCt9aS9Mgl/R35H0IP31fvEwOlNxRi+NTBCiop+sNbyVIj9J4cMCU2T5xisx64lKdyxa
         wKAEwlumhqdYvlgRhz99z0omHFWD8f+Arv7edU4eizveCLpbI9B7MGLMGhqTi81SoyuI
         m3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775727513; x=1776332313;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38ZrH1Crcdop27P4rVvBC10kiE5Ph7GbdYYASQ5oT38=;
        b=CFk0geoh6H2+fGDn5X6+DW/cciesVRqfuiYFL33OqIAGiKCtn8cACuJFZ2Cgmdm4yF
         7RIkRiD2id1sttma7R8TnjejxLQYeGRyAXX3B+ou2wHEk+OlTp0Dms4Di+tVVFgUxOFf
         UN6hTW9bjOa1lAvT3c972xYXdAAzCJ5E/EL3YkKzYRkKSb57sMJWM5iD0NlvEVwnEJcR
         U/m3K3kmCgLv6p/gbprK+7QfQR6nsGHbnFKZEnYWoFH0L6mmEL1+738j1dO5Z/E8VfkS
         xeflxNbfaNGBARiTCGf0GRmkCnCM3yIouGfHczfACsvVcwo8JCYNb1cObd1e2rJA+3Hp
         VZpQ==
X-Gm-Message-State: AOJu0YwoCnT4kWEZ1VglDzvwM2fuY+bZsW1ctfRFGew6j8HtXPHAULnf
	BNJ6/2F2PYISP/euxUMtDkPSr0vPn7qn6aJaIzbUDo4sV6adVXjp9eWdrrDpW/bYLgg=
X-Gm-Gg: AeBDieunm498vyZQ9j5wELVHP3FBdMeCUVxVYT45cIhyfq8y0Cr5plVVP2jr4+6Hg+k
	fZrzN+iG3PztYdROpBWFjrgyx+HbxYjPtsjcDsb7fJP8ffVxqW7kxM2mqAvhJa7Q+drp/UAO1PW
	wnzoIBvt7F/IwXzNfrGl8dNqpK7B0wgtczg2saZNflArVYxoFhLyfX3v/220jIjNOll+ZcdPpPO
	mw0f2zViWJesD2lfIMQO00eldxiSfGT6OVhA7Lw5f5zwl6kL64WH2D3PIno7ix5VHWmMvWVB+H5
	fbBEvug2bWeFQ2Fa3531+PDYOADok2RePxbTigRHn+9mkYoXeZpGmN6xGaOuh9Qf4pMbqcncaMj
	9CeZb+ZyTEuaBRbJ8TbofivohdPyB0wu1nAnuI/ZdA65A+OQEaLej4KYHXYL57uxPL75uiOd+Wq
	aPViFG1yB+VThc6T3qHvGGiaCi+yzd1FCaLUOFI2sO0FmrUecqlZk=
X-Received: by 2002:a05:600c:3e88:b0:488:c744:49b with SMTP id 5b1f17b1804b1-488c7440750mr77766095e9.7.1775727513303;
        Thu, 09 Apr 2026 02:38:33 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274735633sm235179335ad.6.2026.04.09.02.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 02:38:32 -0700 (PDT)
Message-ID: <cf81b1f7-017d-40b4-99e1-7cc94c7f5b25@suse.com>
Date: Thu, 9 Apr 2026 19:08:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: reject empty non-root tree blocks at read time
From: Qu Wenruo <wqu@suse.com>
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
 zheng.yan@oracle.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260409081140.3400650-1-gality369@gmail.com>
 <baea8ced-c1c2-4a2b-810e-30c957c50498@suse.com>
Content-Language: en-US
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
In-Reply-To: <baea8ced-c1c2-4a2b-810e-30c957c50498@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/9 18:39, Qu Wenruo 写道:
> 
> 
> 在 2026/4/9 17:41, ZhengYuan Huang 写道:
>>
>> [CAUSE]
>> The old btrfs_verify_level_key() path rejected tree blocks with
>> nritems == 0 whenever the parent check provided a first key.
>> Commit 947a629988f1 ("btrfs: move tree block parentness check into
>> validate_extent_buffer()") moved the parentness checks into the read-time
>> validation path, but it dropped that guard. This lets an empty non-root
>> tree block pass read-time validation even though slot 0 must exist if the
>> parent provides a first key.
> 
> Wait for a second, there is still the nritems == 0 check inside 
> btrfs_verify_level_key().
> 
> It looks like there is a missing link.
> 
> Is the btrfs_buffer_uptodate() call inside read_block_for_search() not 
> passing the correct check structure?

And if you can provide the fuzzed image for each of your fix/report, it 
will help a lot.

It will not only provide a reliable way to test, but also allows 
reviewer to verify if the root cause is correct.

> 
> Thanks,
> Qu

