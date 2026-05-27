Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01907396B70
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 21:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779918153; cv=none; b=odfDcHFwy1Q0HFgjCEclzQTHMkPKezVswBE/dl16crcYPRp/3cuubBuub6P7R+qbDIT79wWLwkiDSBa47t7c+7poVLtsSbJ7uznHCRW5yBy027L1k0G+mrf6DJHvvUQeJXt92YpNwFXfmbjDBvOtnGLVkBoIIRhvxGDP2J7oqxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779918153; c=relaxed/simple;
	bh=VwyPW+uWwaOoHXe8y4QYpLlAh72XBOp7sQsu8zJv7m0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FUXX21UPUNwHCvsfhb3kyxOz/5VhISicgPO4MRsnREySuGpuVdM4a4XM1GmQ1VzQh/HLgXVHUK0lSl4ivwoQzLdHWNCOc+WORz1C3AojvBhuT8TN+2sL0DTbP/nyVt5hEMrm4Ee8UwZb5/5WdOTN3cgRZAm41i+6VxrIxGFJSCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SaDr3UWH; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SaDr3UWH"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490426d72f7so54913745e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 14:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779918150; x=1780522950; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0VOhZribKcPjc6Hnyo4Z8VzgC9ld/pnCaQhWDDtwrI=;
        b=SaDr3UWHhKOHULIKHqTRe1ytVTMuCIUCLnYfYTApgrZtvTWKiZ1tdOUaIwNQmpPgi0
         /rRggS4KeMl9itWtRt95biGfBVFhIAcEfBoQva5ElXvbqg+o1CGeXmRGe920i23BlEtz
         4XxI2u+/5pmDWKSP3K3QvYhH2yrQknlfeClw0NYzHSAlUYtPmKwtz9AHvgTD5itX0k51
         EaJ0BG1QuFS1zmLIcWEXvzED4hihhXOBeDeb3kHsmhFKY+klET/BqyGNs754UB6wcDA5
         HtCxhquuUe3+lHuQtaCXDPyZ0UX9fZjKgpoiE1ETMLCQ7YlzqkRtacGdc4Z4cBnvVFRa
         pAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779918150; x=1780522950;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0VOhZribKcPjc6Hnyo4Z8VzgC9ld/pnCaQhWDDtwrI=;
        b=kYouet1mAsLcGRKQjyCpYcWH+H2ZY9UOItLkB8uVUE5C5NtYslr0BoFnW9kXTj40a2
         Msj86tOBrLwtoOQOH2KPKGYOAOxAtU7j7O8ZOrv2RzkoJ88rdsYTvKkae7dD2Q9QptfX
         smXqyf+O5FrdzRORBqgIleb0BfUOIx4I5Iu8+PxnfJ8qXH9JccVIETUHs20k2iibO9pe
         vA0VdEosGWFemALdGZbk40tYyk6P+LfmRH1vs7lCDcDXVChg99gIazvZ3rH5/ZblA/yK
         em2bYi79aVcNfo556yiuww77rYSe4HIpQKVOYLJdIcwltSUlYbAltSpmhHkiwpu5WY2a
         S4JA==
X-Forwarded-Encrypted: i=1; AFNElJ9Nl3Ic7TfJnW8Sn+he3lP7npC5RgojxCqYZLgujNunzkAQ6H83/sBw0/t+DphVTWAPnHTXAM+x9bPMAg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqwVsIov5EmMJF+tBDCbHLfEet4EFmFkB+a9w0bEh0V6F6k1j4
	c96HK67fUvU5MvJR5FL501piXXKCenbBx2YorqM0i2+hMrAYygeS2Zu0Bclq49x41injKSyI+rt
	64BfD
X-Gm-Gg: Acq92OEc/AkK42ch6tiiBwurv0vSXjVzuNnmwh8EdDsvV9euoDPsI+eBufyqQ4kn40i
	6+rJiPSeJ9alW8gApDBqlFKsxIpE6ENSAGdlxzP0TquCd1/n/gCA1fGJgHCvgwkGtb0u0pf+jKW
	FFi/B04GXRFxsPdOHCp+ceXgR/ThKPWTxvwoKeof7dndrMWPTzkbr97LaW2VDewJtxxbQ1XsG2S
	hbTDpMUCCC48J/a5iWjxvLj32K9aafD7hlrECqcvaazOrPnp/ZHvVko9sCTTCeDPuJmLB/D/bsP
	YXImMvHXtEHv5jV+LhqsiviyKmHcp3TtcbLqQcFYUnRJkoJGV6nqfy3mUmY2FVX+ac2rzpjeTBD
	G0Pj9tSkJd9oJTSsscMaeYoc5Ka/AE1KSvMV/UP0AXG+Z9QeBv/MxiS0fmH4YpqS3YPGYGfQGLL
	391jsorhThhxiJps26YW4wiFsl6r41m7t0Rb+Jx2IIdvgB2MCQZ7Fgt6rvLdHCNsoqIkfUawxo2
	k86rxOs+wFuaGDTTXpYplNhmpKF2OwbFF/0L4+TGLYpUjYy25Ndng+nYQ==
X-Received: by 2002:a05:600c:698d:b0:490:601f:d77b with SMTP id 5b1f17b1804b1-490601fd94amr312205115e9.0.1779918150321;
        Wed, 27 May 2026 14:42:30 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36b7653c9ffsm743782a91.4.2026.05.27.14.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 14:42:29 -0700 (PDT)
Message-ID: <bea8a50b-4a14-4351-a56a-d295b90750b5@suse.com>
Date: Thu, 28 May 2026 07:12:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: generic/362: remove the old file to reflect new
 mount options
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20260526070055.60193-1-wqu@suse.com>
 <ahaQjYYQWcuOaRaq@infradead.org>
 <e9fc0374-4a97-4cab-8f9d-9de39587cbec@suse.com>
 <ahbrvyNg65OjGhpS@infradead.org>
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
In-Reply-To: <ahbrvyNg65OjGhpS@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/27 22:33, Christoph Hellwig 写道:
> On Wed, May 27, 2026 at 04:20:38PM +0930, Qu Wenruo wrote:
>>> I'd rather add a copy of the test that runs on the scratch device
>>> that can control the environment.  Or maybe just change the test
>>> to use the scratch device?
>>
>> I'm completely happy with using scratch device instead of test dev.
>>
>> If no special reason to use test dev, the next update will go scratch dev
>> instead.
> 
> I went back and re-read this.  What is the special mount option you
> change?   If you want to always exercise this as nocow, maybe add a new
> btrfs test that is a copy and uses the scratch device?  Or am I
> misunderstanding something?
> 

My point is, the current script prevent the test case to respect certain 
mount options, thus reduce the coverage.

E.g. in a multi-section fstests setup, default and nodatasum mount 
options are defined in different sections, and default mount option will 
be run first.

Then the next nodatasum section will still utilize the old inode created 
with regular default options, thus reduce the coverage.


Sure, a dedicated btrfs copy will help, but that will introduce duplication.
Not sure what is the proper way to handle such situation.


For now I'll follow Filipe's review to use _cleanup() to delete those 
involves test cases.

Thanks,
Qu
