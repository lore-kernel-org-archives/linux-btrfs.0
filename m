Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794285497;
	b=wtLHseSqdPnaOgSm8J03olrCbFxnw7gse3b/oT17ihAgb9osz/AdPkZx8tRUHiB0YASf
	 BFmaZeXfss+dxwAC1g1oKe9aNP044aW0VLrNDmrXSMASCAh2IZekRGpEjtR8HRbccFpqv
	 fNxiVu5zEx9Cbvq4H2UaCtYr13Qts8vcIMHQ4ALmQi5w72sbEA3yBOcqtuaChnT0MY8rE
	 fgsl8Q5TFPrMIvyL04fcK7qwTKuB6rCNVLsuEVS2WuU5ec3od2g6uxlKYpwy1pNYqNf2W
	 nSni6zS0qm7JT2zgKLVI8NM+1EcE+FSA3jEf/BxbINUchcR5XiOcRimU9tLiLoqX2dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794285497;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=l/hJijI93Hh2vyStYQqSK02BWYM5ijef4Wr5JYevaGU=;
	b=qyVMsJvJ3MoJr1klmnYzXhZ3qf3f/BRF16qZAySZd9W+CrdBFkkEvEv0xjqrgc2nIJKb
	 OXmMY+BzLlMXsHFYq+MXjodoGCSwjtY6u0EOtghMP0MZwpUELHiPq4kK/1W9l0ONelXlk
	 CH3BemTD3DredEl8eHgaXq/+5IXXGMn6emseNOBDPBOqQ3ysQIahqSWkDIYotef8VzNCa
	 nl7mzzm7Xu/LuOcalCJwDhrKIg8HFEJG6hHvzDV4pxP9QUgLurDFvKa9Qn+KNoUuNZxxl
	 Z5RZCvcLLL19dUpNgT5txc/tuCB+vN4OxnJoloJOF5HXQhQmQyOIBaaqU0rXZP7kGSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=CqPnRmKH;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5BF606A33F;
	Tue, 10 Nov 2026 04:38:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC5BF606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=CqPnRmKH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794285489; x=1794890289; i=quwenruo.btrfs@gmx.com;
	bh=l/hJijI93Hh2vyStYQqSK02BWYM5ijef4Wr5JYevaGU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=CqPnRmKHXnHgEGpH4HMOBwnpkep+unON2BwxYqVQKCz5mMco4+Cz/i6w4196Dc1e
	 RibzOO/USSc4YK6otRhxwe1hBgHfjFqGZfaQzqglx53VujQr0H8AVuYh4Y4nOfWcU
	 uJaNyQmSiFW1GSwKTebKw1XVlypR8+WYLLKgcCC9s95z86lYybHIOHDgx0A/waaqy
	 99g4qQF92S7kMuXoZ6lx511BM0xAxtki5IEtU/KDL6ym2js/m7T6DqIozMmtH1S7b
	 JPmsK7kZIZ8H6lUyMtk1UrExZMEtdznrv4hAQmG8Q6GB54/QIYOmlBvFJr1AT7Z81
	 xeNhWZXRQzjLipkfpQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MeU4s-1wsOjU1tye-00aRO2; Tue, 10
 Nov 2026 05:38:09 +0100
Message-ID: <e2a8d755-c989-42bf-9adb-bb0ef2bc3872@gmx.com>
Date: Tue, 10 Nov 2026 15:08:03 +1030
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
To: Eric Biggers <ebiggers@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, ardb@kernel.org
References: <090c5f6603b1102c877c8649f7a6569f362bfe61.1794268279.git.wqu@suse.com>
 <20261110002255.GA1958@quark> <20261110010943.GB1958@quark>
 <44965cd2-30f9-4846-86b5-537f94f18958@suse.com> <20261110013546.GC1958@quark>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <20261110013546.GC1958@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2w4JE/IeKq7nvreok4KWfmUo7ZGyAdInR26K+BZi6LT5wGpKGS1
 9/Xz+WLaAlRtqpKSW2959tLAWP98/X6rejBWCEo2pmmjoS5gtuq6OuALdA+z5Xg+U0tpNMl
 u2agTo8/tVYkN7SdwOb9BZ7YO/IDt7cp6Sjm0phewLamcuP6H+cpSzMesSFd0LnCSuxexZL
 YkUtOxg9i1dG8CWWV9m0Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6h2B/ipwoiA=;GTY4VK4lKZ8i3XnEssqnT06Vr7F
 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
 6z0Rk/LC1GuY=



=E5=9C=A8 2026/11/10 12:05, Eric Biggers =E5=86=99=E9=81=93:
> On Tue, Nov 10, 2026 at 11:52:03AM +1030, Qu Wenruo wrote:
>> =E5=9C=A8 2026/11/10 11:39, Eric Biggers =E5=86=99=E9=81=93:
>>> On Mon, Nov 09, 2026 at 04:22:55PM -0800, Eric Biggers wrote:
>>>> As much as I'd like to reduce the use of asm, I'm not sure this is su=
per
>>>> convincing.  We get worse code generation and have to fall back to
>>>> inline asm anyway, as the x86 intrinsics are still unusable in the
>>>> kernel (which is different from userspace).
>>>>
>>>> This patch also introduces a compiler error with gcc. It seems only
>>>> clang was tested.  (Showing again that this kind of code often has
>>>> compiler-specific issues, and we have to be extra careful to test it
>>>> with every supported compiler version.)
>>>>
>>>> There's also a subtle bug where the inline asm blocks are missing the
>>>> volatile qualifier, so technically they could be reordered after the
>>>> kernel_fpu_end() and corrupt a userspace process's XMM registers.
>>>> Without inline asm, this issue would not have been possible.
>>>>
>>>> I'd be interested in seeing what you can come up with for
>>>> crc-pclmul-template.S, though I think that one is going to be harder =
to
>>>> replace.
>>>
>>> Also, just to emphasize: most "C" code using this strategy will be
>>> mostly inline asm blocks, since that's what is needed to access the
>>> vector registers in kernel code.  See lib/raid/*/x86/ for some example=
s.
>>>
>>> crc32c_x86_3way() is an exception because it mostly use scalar
>>> instructions, with only a few vector instructions.  So it makes this
>>> strategy seem a bit more workable.  But actually, as soon as this same
>>> strategy is adopted for crc-pclmul-template.S or any of the many crypt=
o
>>> assembly files (AES, GHASH, ChaCha, Poly1305, BLAKE2, etc.) that use f=
ar
>>> more vector instructions, it will become mostly inline asm blocks, jus=
t
>>> like the RAID code.
>>>
>>> So I feel it's kind of an odd path to go down.  Perhaps as a
>>> prerequisite for reimplementing some of this code in C (or will it soo=
n
>>> be Rust?), we should get the x86 intrinsics working in the kernel firs=
t?
>>
>> Indeed, it works almost flawlessly in user space just because there are
>> already intrinsics available, and most of the code is just regular cont=
rol
>> flow, with mostly scalar code.
>>
>> Thanks for the feedback, I'll just give up the idea in kernel, and enjo=
y the
>> complete intrinsics in user space for now.
>>
>> Thanks,
>> Qu
>=20
> Okay.  I'd be interested in someone trying to get the x86 intrinsics
> working in the kernel, though.  Just when I last tried it, it still
> wasn't possible to include <immintrin.h> without errors.

I don't think we can use the compiler's wrappers directly, there are=20
quite a lot of conflicts with kernel's library.

So a different, independent copy may be needed.

If we can get that part done, it will be much easier to do the conversion.
Although introducing the intrinsics itself may be a much larger project.

Thanks,
Qu

>=20
> - Eric

