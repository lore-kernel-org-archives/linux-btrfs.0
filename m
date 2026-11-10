Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794273731;
	b=hinoBlnvVRxpXIZCPCui/RnvuD7NVVzH7+4yQycqcA4AUeHCJjz7ZMBPkO4KReqNB2ip
	 kdYg+Yvy8RG0WF3p/ycxWoTBn8olpbUOxfm8//x9ZbjgW636xUuR5CPd9EkIbu2THv2r6
	 DUm9AFIKN0aEjejLFYLA4W8IszrZ1DhhG0/HMZXVDSsHSNCt2UG/7cB1LZPN4NDbgWvo8
	 3hMva9wvAq2ZyMUNmOMhfmE91MORxea042+OLUfqHi3LO5JtJZSO8mlKHnD6EBU1a6Nz9
	 EZSe8PfHXw6sSVZUOoykxTp4X9K0G9q2WqBDwehqP+ma7Z2Ul5x1t6KPN2bTqNSi8Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794273731;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:Autocrypt:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=mkpDKAuLxXFLldhF0NO/Hgh0j9VWWZBvEeHmn1EKkZY=;
	b=zZNFrY8Me4tjPngmzylih943WXugxx6zrwC1Q4eaGnJ6tJrNtMkg/WEyvlSZvdSybWIj
	 dzzNaS1VlsNqr8esOnSju/TUT5Ksxl7EPBCck16pdwaXFCtU8vUfzTm5AbnbbSxWGlE4N
	 tP5raNcVuUuG8yOIpaY4Y05odwOfyxG900jmga3hoVdVsXQmobt008+nM3fopXim8ofOV
	 FDQqASaHGML8YCMjjvhtJPo35JWKHPeBLmgeI0x+63+ZXuP8L/6MCrKogMB+8ALbRhKFz
	 tdNplC4Kwp3KsUBVPa9H+sG0Q8vSy56VEwYKV45DmEts1ToKoXkhqTxnUIwSOKPOWKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=RxRncdgs;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DA660A2620
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 01:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82DA660A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=RxRncdgs
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c49c32650adso35488266b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 17:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794273729; x=1794878529; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mkpDKAuLxXFLldhF0NO/Hgh0j9VWWZBvEeHmn1EKkZY=;
        b=RxRncdgslNA5Pdw1CiW2H1HUvuVyjjaBgQ7GPs9insq6oMgnJBOMebTKPnaTm010yG
         JFCW5eobiDyhaU1hE//6e1eF/nAqzHnyareZqm18/9GZkfFp7rYKLyMJPCWAWVqxnefO
         rK0FxGGtIK5ze5y5bpyA3MMUwUfJi8VGcb7YFEDZPQQ2Rx+sV47fApGS8pIWXvQwi3LI
         9u1C7ODCDL9n7ddpHydfNAIfGCWrh+MrgpyKhMdOZRfRJComGbUkHBjwVYrEsgLEgunl
         DJDL2jxEkfLxuYq61nMueUCYfFSwI5sUytEskXqInNP9WUUJEj6n+JRbrY1YEPY51Uec
         cueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794273729; x=1794878529;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mkpDKAuLxXFLldhF0NO/Hgh0j9VWWZBvEeHmn1EKkZY=;
        b=ziCXITul/ebT8ex/s9SLUygdCCzeQs4yBSV/tir32/BTBbiiGj1wy0yKNt0yslDNSe
         ed84Kh+trLdMmgFv7cINXohtNDCfgwPDIxWZB/hKn6bLT+LLiXfBjDpyhGXJVCVuOX9Z
         DWAEDhDtcFTKjhtv4NVh0MfuGRpdnmWHTUph2n9vkgaclCjQCvpCNmfFcK+A21NJvbSk
         QCIl3l2KycIGDGW4+i1kCKzPeFVKrdH9poeUU00VywNzd1kUFjPR2o+AP53oq3qQdg5z
         egcyGfx/MkZq+na0jB1Ajuc1W9OcuZ40qeIFZ7DzEK5Kt8E2c1tGeGTLj+YA52owVO9F
         k8xw==
X-Gm-Message-State: APuU4Z/OIo3+14h8xL2D8Lfp2Jn3T8wr2DNHlQdLuAJSWFbBR0NK/1o7
	YUIqrqghagkwAvGjLs3jpYDOevc2R+2CneKf+12ZV+eCx9Hzy9ZkL0ExOClh65DpXwk=
X-Gm-Gg: AYBFou3QVJiF2gLc7F6t5cxh1rdwWtnx7b1LdO+CdmrcjzXXZr3+B9Fw7NGG8DC9LoL
	OobcZDKyjG0F2gpC/8jjBzQcS80wWfnvnzrGmWMhFjYCPRBmGEeKEtCcYK1La1CqfgMSwGG4+zE
	gysK/zRQnqz3T1D+sct8y6cBCk7F1JeHyAT0b+WLYJlqkFm+pS3Q/2BlpMYt/7BaweJy+xOy8G6
	Sp+hqb+XYUGxcT02SleXvDz3eIDV3ECYL2hcHHxZ/zVoKNtXA+f8iGOjnn1/BrBBdRnX4pGJ/1i
	+1YLWc2Nnx5ltDpnMTX52emjL2QWtUJC2272hPzOvCvhvxp3+av70i6tlol+es866d7QZSo6HDY
	SCH0ToqRtQ6gED1b/3CmkGHwKguDghVirT4ZsV/1MniW76lrTYs3Mdziso6tNBtF7tJdr4WodjO
	1HllQE1sjAWVbb253UoOGaS5tndBr4DBWccsTH8a8SqeRPVo9kxbpDP/N5bN/nUBi6iUJDv6fCS
	xplcKHEceBKP4igGUau3NFxea0ffB3g8SEqS6zeXQOent8syqqIyuNa3BKD0/h/63ZVeSQFGA7p
	p9AUpf8bnGyRlqT7K/GCWg==
X-Received: by 2002:a17:907:3e8a:b0:c4c:f85f:aa2b with SMTP id a640c23a62f3a-c504961f6d1mr74060866b.24.1794273728992;
        Mon, 09 Nov 2026 17:22:08 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d695905sm245665a12.11.2026.11.09.17.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 17:22:08 -0800 (PST)
Message-ID: <44965cd2-30f9-4846-86b5-537f94f18958@suse.com>
Date: Tue, 10 Nov 2026 11:52:03 +1030
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
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, ardb@kernel.org
References: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>
 <20261110002255.GA1958@quark> <20261110010943.GB1958@quark>
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
In-Reply-To: <20261110010943.GB1958@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/10 11:39, Eric Biggers 写道:
> On Mon, Nov 09, 2026 at 04:22:55PM -0800, Eric Biggers wrote:
>> As much as I'd like to reduce the use of asm, I'm not sure this is super
>> convincing.  We get worse code generation and have to fall back to
>> inline asm anyway, as the x86 intrinsics are still unusable in the
>> kernel (which is different from userspace).
>>
>> This patch also introduces a compiler error with gcc. It seems only
>> clang was tested.  (Showing again that this kind of code often has
>> compiler-specific issues, and we have to be extra careful to test it
>> with every supported compiler version.)
>>
>> There's also a subtle bug where the inline asm blocks are missing the
>> volatile qualifier, so technically they could be reordered after the
>> kernel_fpu_end() and corrupt a userspace process's XMM registers.
>> Without inline asm, this issue would not have been possible.
>>
>> I'd be interested in seeing what you can come up with for
>> crc-pclmul-template.S, though I think that one is going to be harder to
>> replace.
> 
> Also, just to emphasize: most "C" code using this strategy will be
> mostly inline asm blocks, since that's what is needed to access the
> vector registers in kernel code.  See lib/raid/*/x86/ for some examples.
> 
> crc32c_x86_3way() is an exception because it mostly use scalar
> instructions, with only a few vector instructions.  So it makes this
> strategy seem a bit more workable.  But actually, as soon as this same
> strategy is adopted for crc-pclmul-template.S or any of the many crypto
> assembly files (AES, GHASH, ChaCha, Poly1305, BLAKE2, etc.) that use far
> more vector instructions, it will become mostly inline asm blocks, just
> like the RAID code.
> 
> So I feel it's kind of an odd path to go down.  Perhaps as a
> prerequisite for reimplementing some of this code in C (or will it soon
> be Rust?), we should get the x86 intrinsics working in the kernel first?

Indeed, it works almost flawlessly in user space just because there are 
already intrinsics available, and most of the code is just regular 
control flow, with mostly scalar code.

Thanks for the feedback, I'll just give up the idea in kernel, and enjoy 
the complete intrinsics in user space for now.

Thanks,
Qu

> 
> - Eric

