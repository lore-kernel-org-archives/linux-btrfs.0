Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29203016EE
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 01:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781228472; cv=none; b=qMz9CQvb8hLOp920IcbpELdXF5BUElDYMnMuVknvHWQawWaYT/fMmDxkqXbQqsLzSHpljUw13kLgtXXJ5hzyjyInWAzihTrQ/VtiA9D1tr3pOCLWeexf4yIviOqLQVeXdtI8N5amDyvKS+3wy/LYFsQ1Ec6NizFUIQEThkIVY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781228472; c=relaxed/simple;
	bh=H3QgjYHgUWgLf5Hdz3zpZLRu7eotRDY/FjvNmRe5QL8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=FemJKQ49WoWz2KxMcUC9edvw3zUgPhwRzG56RMTXLDRtqVsm1bmaFF8ppBSIKCR9GbkDkTf7mfLkWZWe/ecx41FZYL4YImTxkkjafLcYR5kj26t7MS1SI59H7xO0htl4glimANT7pnK2XOzXxsXJOm9e9Nt62nXtt8ZX7r/DIeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Po7oArLi; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Po7oArLi"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-beb2a97cc9aso78521666b.2
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 18:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781228469; x=1781833269; darn=vger.kernel.org;
        h=content-transfer-encoding:autocrypt:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EwJ/p+oe1BDJOA94TxGJDYaoC20bK7b6q/AC5geke2c=;
        b=Po7oArLiuN+Ili81TrZoVsortN2L255hMIMWslh/69YFBK5Jwm9Lsd5nJvoy8nGwvb
         bX34+jzDpxUaZF/XmsqtILykyB0nuaUt6J8JAVMv7oQNW+eh2JJds68YQDzAgNv1S/Cq
         tUmPF1eUHzZBVbPSoDjuKFYl61wC/zXJnb0hr7TUWoJ0nU48mUj1Qq4gCUlYK5q5NDIe
         c/W8UuLGVoLvtxactjoqCtLaGtd30KG9VtHR5P8FRFF9mzLIB+pULZ3TYcUDtKYxVmtZ
         uTZuLyJbLJsyPHd4wcA2IFoqHhP8Ta2dDEy7/FNxRB8BjypewAIPChvqMq+HxW6EOJUA
         it5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781228469; x=1781833269;
        h=content-transfer-encoding:autocrypt:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwJ/p+oe1BDJOA94TxGJDYaoC20bK7b6q/AC5geke2c=;
        b=Yo8EUo/l5ExK04qyp9aLIhof8z4zm/Rpe6giCCzmbD8TnNUpMiiiy6RiLqj5VKUnYb
         GmIVM05bZ41j6QcleCNAF0Bd0Rmk9cewwmFGoCQBp21eGnytYNZGY/QPuwP0CJnKgisr
         oVlolwQfCADsoqSio97cRZfWw6reJfjto9EyVJtvFW6L+TWl5d4ofq610XGciM7N3wLe
         tiahZDA7AHsYbdUvhc1MxjxKNoWTvtpNbRYMBH0ofXU1GOFvj05VO1nB7EJijcxEqGxw
         lX3c64IOUD1rwQqamgS+NSnF0lRD9VqbRpErazFH/P5Yu5p6P7s575NYX85hAv8zIJ1g
         qhKQ==
X-Gm-Message-State: AOJu0Yz6GbkP1Et5LNT8OfwJ+lJD67zW9ySRulcCLoZnIxlRX5xEReTo
	DM3wwZGMHyyBjfFLOxbaOcERMoWg61mPKT71UKH/SarXWANrlwziLVjQ7CGxb33LLgsnZCDOR0o
	5NPJ8
X-Gm-Gg: Acq92OElxepSLPchVxVGAcbf8h1nA+H8rCfYbLXRv3vQO1OPWMpsxKWNNp/PshD2TF1
	a2e7COxM4oPKGgqPLz6GGCSrocGn9aCsh3+dlARzx4m8LDyoo4+s7s1wUwmSSevGiKQ58nZEOb/
	jbFJU1qv6/wJFbb2sHkXSiieu4lIDIKtnyjajCsN+S2mynTJjpJGbn45KsFIfGHZ2aU3t+o6lI6
	R/pVCVqnjXddLF1F9t1znxj5d/1nU5r7DlMsqIq4TeJvvT7lmh+CwcrQQkmkteHg43uQt5bfbi+
	uKaPPmIW9ADoPTnh23bF9OdrKGfqKXFGbiRM+TxhbQFIJQKjgqr3CstZRqOEuR+R0Pef9mYvwoI
	XQe9gHuXTNwvn5mzGk24FLe6QIulxwFLTq0hIJpbBQ5+ZMO5dgltGDAP5/JfAp4te0tjNMuWwgj
	1icIHSFHISVM/LJwNCTZcL5XIYN+PqbRTVAWRdT42X65BFLGU62eYoFrGSvfQto94HDW10hVyBg
	+hUUKW6AQAS6rrHHva2odmKj78HipaB+OGnZcOOtYRmEvc=
X-Received: by 2002:a17:907:7b91:b0:bf1:1df7:3e50 with SMTP id a640c23a62f3a-bfe27b20a09mr22554666b.3.1781228469252;
        Thu, 11 Jun 2026 18:41:09 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ac9bfe1sm431703b3a.12.2026.06.11.18.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 18:41:08 -0700 (PDT)
Message-ID: <b866b2e6-292f-4c5e-ae5a-d77e983cfefd@suse.com>
Date: Fri, 12 Jun 2026 11:11:03 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
From: Qu Wenruo <wqu@suse.com>
Subject: Direct IO page bouncing got some garbage?
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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Recently I'm trying to make btrfs utilize IOMAP_DIO_BOUNCE, however I'm 
experiencing weird data corruption.

During test case generic/708, I'm reliably hitting garbage pages at the 
last 64KiB, the garbage even contains an ELF header.

In that test case, we mmap a 2MiB sized buffer from another file, and 
use that 2MiB mmapped memory as buffer for direct IO, write into a 
different file.

The source file has dirty page cache for that 2MiB range, and no 
writeback happened during that direct IO write.

So it means as long as we fault in all the pages of that 2MiB buffer, we 
should be able to copy them into the newly allocated folio, and submit a 
bio using the bounced pages.

But the last 64KiB is reliably corrupted with some ELF header.

I'm wondering where the corruption is from, especially it seems btrfs 
has very little to do, except calling fault_in_iov_readable() to fault 
in all the pages.

Thanks,
Qu
