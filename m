Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E944B394793
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 04:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773289000; cv=none; b=IKMYcqfPYPIPoBASFZp7g0ja3oGMqIltq6kZkUMg2x0RPFkjxXXycghO70JO/KOhLoQ+nF8uG1dS4CtwL9rk+fe8c+7B0T9l1NY003fCSyxclfrcGfUC6TMwz1fxmRLrowc6N3GlPbcsfUmSEh/NQYU83PUkvKik3tMLWPEwLsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773289000; c=relaxed/simple;
	bh=degI9UtriRzk6E9NLOGTEqlhW9RkWB4S+ky7EXT+Jqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PaWsccgJ0ANf+UtsShz7GmGPB+Ar3mdTZ60kgW7bINAuJl+UH9eXBq+XBAWCe16jXvIujozFeVziH7hY+kOz3r6/cPDeAAC32fJ572B57BidIO2waLc8//ZnVb2yGoEMbqwqh6UMKjk0eNK8+zc7BRaHrDo5FHmSPiz/Z1JtOQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gFHlc347; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gFHlc347"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48541edecf9so5405205e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Mar 2026 21:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773288997; x=1773893797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=LeKguCeq1Mvbd8EXbCPRxs/GF0b3KgpsAgS9qiROQR4=;
        b=gFHlc3472Jn5X6W78FXvETC0WD2EulP+gIliYblqYfKMfFeUGhFbR6rlb1H0IrtFDj
         BVyRsVAb04ct9sPU/fkaEvHzW0/c9doAK9XujLvSbLsteYgS07MnVCSZQmNdL5ntnKzs
         gDMpKebvs0WiXOV8R1sLPSXvWuvPdTjWjFG8KYy0Ln09ddbT9V4ZcloXnc+lObJBocfD
         qD77Z7YqAQiOPUbEhA7t97q6iNXwFPybTgQaJhTdVGy1zNnTymD6zIqnerZglZ3pWoYZ
         vCOrXBY9Hk05OoNuO8Du8wYU+qWTgNfbNrFYP3+AgNYFgvmA4EYwr1pvfgk4ECZdnCoq
         yMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773288997; x=1773893797;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeKguCeq1Mvbd8EXbCPRxs/GF0b3KgpsAgS9qiROQR4=;
        b=u400w8RZqAJ1ssnU21Z4EUmTSxgafhtfAgcSlOJ6qjwzImFJUeKnR1ao+FZh5XNeKm
         4GCwc2nbVCUejj9nSpBCnoYAdA6WjYx37NPuHLJWLlQeBYd516cXoO9LwYErAabOfBAC
         DAjclo0tHOxolyJRVLcXgWkbttDISQcdJVE5+LE7U7/CFU3RfPsz2H9FAxunPZ4MdMj5
         N899c/8Q3peLa13+QXaW7kyQlPdr4ajGjBQK6tVFrPvqcVEcPe0P+8wrcCwM4DM6rKTr
         fB8W1YnGTB1zRcUncQIMSvedZqzWIgzJR2RoqvImeKpEB0FNSKvJCwS9iPfrQRpSBqL8
         ghZw==
X-Forwarded-Encrypted: i=1; AJvYcCWH02hEnaZbX+NPHg7hk2q3sql8WsEUtXlBBwe40mVUkp9Sj9Ml4Whi2riKE2YIoL/TguJnPbV79E02yg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwR8HLADYp7jG7ZekUXjtYyLalpRb+cp4IgCDA9xUcMQLI3g0oj
	Rd8S8lrDvYEkTTUuq5R8lnIuGct7h9GQ5DeVpZEhkeaU65bWA5aYB55oYfMtpvEymq4=
X-Gm-Gg: ATEYQzyHdGiLNUh+2cOZQR2V/OZMrSrdLPcM+/oHBsiMe5qv7g0gYk+K98t7yaphi3D
	kWGgqTYYAwwtnhVu6e5IBqKEx/GWMzWLePJ59MiSp6jAFmc+FYUth/zUcXrxjIb88VS9XqzMxe6
	7w893qEniGVloab1/UASWIug4AWlGRUzycOxJ0RMIAAH6oheIq2CpGcykB3prDZh6zLLvQ/10cJ
	R/wP8slcq0oD0FX85WVCCpi37zMnRqnlkcpo6iBDJlTzC68sGC2J2Eq/M3mVGgNqd8vXzjaf2lM
	DQcbUFaZwyFU/suPmukSKHHKrGpx6h5xKHx3l3Q7qwO4VexKXMxzLc7YPFX8U9ZF7YGXOaeShQT
	Zcmt+fAsI7sn0fT5QQ4zZs/zgFNzhJMMuZ2azaptnmgmcPjmIy2P/e36+/JmUC/iIkKLqbjeK7A
	/fS+MtEJPQ7DRmA7rPXMOwaqf+qyMxCMmLANp4n5HeWauhJp7Exlw=
X-Received: by 2002:a05:600c:46d2:b0:485:38fc:7080 with SMTP id 5b1f17b1804b1-4854b10ef23mr74677455e9.28.1773288997208;
        Wed, 11 Mar 2026 21:16:37 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0725e0cdsm1278294b3a.16.2026.03.11.21.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 21:16:36 -0700 (PDT)
Message-ID: <a478f7a7-5255-4039-9ace-7d2b410db602@suse.com>
Date: Thu, 12 Mar 2026 14:46:29 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: reject root items with drop_progress and zero
 drop_level
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com, stable@vger.kernel.org
References: <20260312001443.3011961-1-gality369@gmail.com>
 <17c102a6-bbd1-4937-b5cc-5f6912551180@suse.com>
 <8533b404-3377-416e-81d9-2bdb00baaae2@suse.com>
 <CAOmEq9UusAbrMLSMkca+DEPff9hXokAvVn3V4acQ0EvSp67HLQ@mail.gmail.com>
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
In-Reply-To: <CAOmEq9UusAbrMLSMkca+DEPff9hXokAvVn3V4acQ0EvSp67HLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/12 12:40, ZhengYuan Huang 写道:
> Thanks a lot for the explanation. I think I now understand the
> intended use of the
> Fixes: tag.
> 
> I still have one question, though. In this case, scripts/checkpatch.pl
> warns that a
> Fixes: tag should be added, which seems inconsistent with the submission
> guidelines you pointed me to.

If you check the checkpatch.pl itself, the logic in it is pretty simple 
and can give false alerts.

It just checks if the commit message has BUG: or KASAN/UBSAN lines.

So it's false alert prune.

> 
> My understanding had been that patches should generally be sent only
> after passing
> checkpatch.pl cleanly,

No, that is only a script which has its limits.
Checkpatch is good for its code style checks, but not always correct on 
other suggestions.

Sometimes even its code style checks may conflict with the rules inside 
each subsystem.


> so I wanted to ask: is this kind of warning acceptable in
> practice,

Yes, unless you believe a simple perl script can be as good as human 
common sense.

> or does it mean my local checkpatch.pl is outdated?

Since you're already using the latest rc kernel, I believe you're 
already using the latest checkpatch.

Thanks,
Qu

> If it is outdated,
> should I generally use the latest checkpatch.pl when checking patches
> before submission?
> 
> Thanks again,
> ZhengYuan Huang

