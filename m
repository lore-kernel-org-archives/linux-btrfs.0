Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794291799;
	b=X6aguZoDZGaVb9C265bcQy8aHq3u19Za0YJVVQNinKEncCKIXA8vj+FjAysPiUUMpJH5
	 Jy4vEzTnCf/BINbQvvKQluXU3Ga8FXaF7SqYCDMBAakJ4isiFuB1JT1M8LxvoSHCYjRhL
	 6x6RtzDr8O98ho9/1d5eiWOlnS40QEoJoBEyblnxEG/FwiTqx/oRYfF46LWxMDt/kH4qj
	 HhlL3rMrB9yqhCYBVmSH6uzO2xChbFg3YQclSGJqP++DJ/jC/emhJY+bo9+xzQjND59p+
	 ldtgsq5XabfJAhQg+s7D4O4j/X0OopQTojRnseU4b4JbySxSr0hjhp+8klz8U8DVPeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794291799;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UAPDPpsWyOzP1GmMDjs7bfHO6Bj6rMt1kUP4yCPLw44=;
	b=Kc2TefKJWnCfzKHcxIrgn7WaZqnPtjfPSPXla/EqZ6kWgpiOz2WY1BKPqOF2NEZ8xpho
	 zWRq1eriobq0ocXZbSoRYL29oOFisGCrAUAPjtY8O/IT3ROiGfmjVPX2g398HMhehCckm
	 +AryeqbFPcmcJaSxSVwUujzEJGo6Nq1ejNweAzP+AtjhEaRQ88TUTawm35TZOZ5+YuiCR
	 xlPNbvLLZ1YXv/z3UhfbtOKn/YBvLoAimWawkABhFAepbOpBsUtI+Ly6qTRM5yyW3npn8
	 BIqqfxtG6ux1Q64E1q66LZm8DByQ9lX8r6iavCsius2aDTPJ2/4xb3MRNmS2jHME+xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=F7O0DTSe;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A29606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36A29606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=F7O0DTSe
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso15571095e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 22:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794291797; x=1794896597; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UAPDPpsWyOzP1GmMDjs7bfHO6Bj6rMt1kUP4yCPLw44=;
        b=F7O0DTSeH9j3hBOerSKxMhnuEDavLr+NDUBf1JMSukD+zGq5ZWVtSAh3+WAC1RteHm
         GchSK/pZvQuk4LEN+TBdQXa1uwsHfduBZdHDgNobqWBMrLz7ZBUAoLpgPcQivvcHId8D
         vgXduduIlf5XYE8/oR8r5zpivriURS70I6I4g84NFmNFhGH0/uyKBoxRV7luTASKtS1f
         AH9oNVZpF8YSicuM2PSZqWqaSOBJ/YimYfb5cOvXsdXcIuhZqBErFyyslkLbtUuQ4q+u
         wTmsUjpdUpsCPDMx+gCFcljGiRQ4tyjWYvdav0tPlXknfymoMVv0K5E1G7YSPc/CopLJ
         Iwww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794291797; x=1794896597;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UAPDPpsWyOzP1GmMDjs7bfHO6Bj6rMt1kUP4yCPLw44=;
        b=2nF1Rul2I55zenXcM/lJVSnySBaiD7/3gmSDiBghFmINHD4tqf7bOVj2eIDGlhD6eD
         QaeqU9w5uum9MaEBJSesn3/9i3LtMGqRuL2IKMztZH1uEbKuLons/fP3EOfvQRH3GJCr
         g7r8jEKGdzj2JW3o1W1p1xQrOEXJ6FRhZ9C2q6/GWY/GyQGuD48gqb/2hNftGpkpyvV8
         YcfNXzPPphLgi7sJ7rcusEySTwD+QRUCAVjJmaTOfEWlm1vXrPrZGJnYsIUqQDmBh4fK
         +QMK2g5QN3InK4FPQ9v1k54nyiTLVwLHiBhdR6S2Uy5xgZyia0uh6M5Y/5JDvzOSox/I
         gIsA==
X-Gm-Message-State: APuU4Z+rtFY/eTUjJpMYEiH0x7GLqMI9lhZRJCgvWS/H3aa+Z07tydKE
	uIGoL+WJVrwIoHjaEveXttWLQEsyYq3BS5Ty9XU2o2Prd/E2bQSmlTy8BVyxET/mORYygwH/KQO
	LI5ldOr0=
X-Gm-Gg: AYBFou1nm8xnDgYpbvQgDTYvXZwh3esQSOF1uOwaO0H3rDjB3i9B2HgQdkveoYQZROF
	4F7/N2ZfnJBoue6d0Ldn8NvlDGuJGdSUTC2KTK/fodhlaRRb+sJYAD0JaQnrFea1S3LvZ30rgZA
	Blqm4HNn9td/k0u9TAqzRIBZxRn5U486BwKj6vKPFStD70PSQxolVz83inpx9YI43ZMHJ1kg5tH
	6bSNFjTlLKKCglAudV89+EGocKsdJmbdgbBQmfXJgeHaM+N4PTqD5cXW/Gby07inhVquh2egzwA
	A6Do5LRplXDOD3pxX8X6qx7YcgGCeyAoFEkfe+KCjap0FNQ3ZaeMIUfrM/XXb3tj8D9mVZDXXcr
	Va9MuED+beMvFAyUj3g5mlON1FrezH5uVcJ6V+J65x3Wbl9l1BkvgRJfqOMYPhwoSHd2jh/nFB8
	1QKDrc7yti1VrjxKeSoW/kPq2uPkEVgovuLcCEnt7RTsHpcODkwC4ac3ZN81w63ELn1Hj+cevEI
	oQR+NbD0/+ey4DswxPcr1c8rYdvqQ/8D7NTLP7kYh8XyRn4XNj8k+uzRQeUTzQZfRMKmMVig+e+
	0YbU8vXEZ6hf3dFLZ8V1pg==
X-Received: by 2002:a05:600c:8b83:b0:4a1:dade:f049 with SMTP id 5b1f17b1804b1-4ba0234278bmr21402045e9.15.1794291797504;
        Mon, 09 Nov 2026 22:23:17 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d9baa5sm5100535ad.45.2026.11.09.22.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 22:23:16 -0800 (PST)
Message-ID: <1f37e2df-a832-4184-b9fc-798f8325731e@suse.com>
Date: Tue, 10 Nov 2026 16:53:12 +1030
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
Subject: Re: [PATCH] lib/crc: x86: rewrite crc32c_x86_3way() in C with inline
 asm
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Eric Biggers <ebiggers@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, ardb@kernel.org
References: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>
 <20261110002255.GA1958@quark> <20261110010943.GB1958@quark>
 <44965cd2-30f9-4846-86b5-537f94f18958@suse.com> <20261110013546.GC1958@quark>
 <e2a8d755-c989-42bf-9adb-bb0ef2bc3872@gmx.com>
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
In-Reply-To: <e2a8d755-c989-42bf-9adb-bb0ef2bc3872@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/10 15:08, Qu Wenruo 写道:
> 
> 
> 在 2026/11/10 12:05, Eric Biggers 写道:
>> On Tue, Nov 10, 2026 at 11:52:03AM +1030, Qu Wenruo wrote:
>>> 在 2026/11/10 11:39, Eric Biggers 写道:
>>>> On Mon, Nov 09, 2026 at 04:22:55PM -0800, Eric Biggers wrote:
>>>>> As much as I'd like to reduce the use of asm, I'm not sure this is 
>>>>> super
>>>>> convincing.  We get worse code generation and have to fall back to
>>>>> inline asm anyway, as the x86 intrinsics are still unusable in the
>>>>> kernel (which is different from userspace).
>>>>>
>>>>> This patch also introduces a compiler error with gcc. It seems only
>>>>> clang was tested.  (Showing again that this kind of code often has
>>>>> compiler-specific issues, and we have to be extra careful to test it
>>>>> with every supported compiler version.)
>>>>>
>>>>> There's also a subtle bug where the inline asm blocks are missing the
>>>>> volatile qualifier, so technically they could be reordered after the
>>>>> kernel_fpu_end() and corrupt a userspace process's XMM registers.
>>>>> Without inline asm, this issue would not have been possible.
>>>>>
>>>>> I'd be interested in seeing what you can come up with for
>>>>> crc-pclmul-template.S, though I think that one is going to be 
>>>>> harder to
>>>>> replace.
>>>>
>>>> Also, just to emphasize: most "C" code using this strategy will be
>>>> mostly inline asm blocks, since that's what is needed to access the
>>>> vector registers in kernel code.  See lib/raid/*/x86/ for some 
>>>> examples.
>>>>
>>>> crc32c_x86_3way() is an exception because it mostly use scalar
>>>> instructions, with only a few vector instructions.  So it makes this
>>>> strategy seem a bit more workable.  But actually, as soon as this same
>>>> strategy is adopted for crc-pclmul-template.S or any of the many crypto
>>>> assembly files (AES, GHASH, ChaCha, Poly1305, BLAKE2, etc.) that use 
>>>> far
>>>> more vector instructions, it will become mostly inline asm blocks, just
>>>> like the RAID code.
>>>>
>>>> So I feel it's kind of an odd path to go down.  Perhaps as a
>>>> prerequisite for reimplementing some of this code in C (or will it soon
>>>> be Rust?), we should get the x86 intrinsics working in the kernel 
>>>> first?
>>>
>>> Indeed, it works almost flawlessly in user space just because there are
>>> already intrinsics available, and most of the code is just regular 
>>> control
>>> flow, with mostly scalar code.
>>>
>>> Thanks for the feedback, I'll just give up the idea in kernel, and 
>>> enjoy the
>>> complete intrinsics in user space for now.
>>>
>>> Thanks,
>>> Qu
>>
>> Okay.  I'd be interested in someone trying to get the x86 intrinsics
>> working in the kernel, though.  Just when I last tried it, it still
>> wasn't possible to include <immintrin.h> without errors.
> 
> I don't think we can use the compiler's wrappers directly, there are 
> quite a lot of conflicts with kernel's library.
> 
> So a different, independent copy may be needed.
> 
> If we can get that part done, it will be much easier to do the conversion.
> Although introducing the intrinsics itself may be a much larger project.

It looks like there is already 
`arch/arm64/include/asm/neon-intrinsics.h` including the intrinsics from 
the compiler and solves the conflicts manually.

So that looks like a solution to pull in the needed intrinsics to make 
things a little simpler.

> 
> Thanks,
> Qu
> 
>>
>> - Eric
> 

