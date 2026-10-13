Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3A555C324
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 21:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791927510; cv=none; b=CoWUAtEPYtfn+mFlwuX2Ih5rTGfdPkla9Ch5+Y8TsmdSF3rWXTSU/x0taMVbwTbQS4xDNz5JiQXMiqo6Bdm6mj5B44tpRyaWFu8JMm+fYGEY5vjOBQDR7tJ7g19rCmMV24gPtR+WZsgw1qvKJ93ZE8x+e6Z//mdSZR5PRFLrbfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791927510; c=relaxed/simple;
	bh=7uJANPnEzNDLXlPyZwKfbEqFxxB+0ct/9ss+XSn4Wo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oOpW+/Fu6jzpCFdp3gEFBTojsED5D4+OgJ/PKd48d87tUKsHn4UvLJILOgYSjPCxRXywyooWaz2tMk3x2rUnHheSdYbX0VQjyI7ysS53oSefhMlIAxfqfp27qPx3gMKNKt5NMNPjftvXk/Cc8yMXfsLSfQlGqi50GhvcLDzEw1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q6chdQsZ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q6chdQsZ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a0e1b0681bso24855875e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 14:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791927507; x=1792532307; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SeiK8ZyxkQIyZd1Pses16K7o3z7KWoWsXpfBOJdg54g=;
        b=Q6chdQsZ5etu1dRJWw6ueroFeXK2gE0DR7rs1dzrxGuy7KrgXvoQ59KfvbUT0ouYan
         t810YH2ro8G+UL7ng/Geq9jkoTe2otZB8SZ4WJIslzraQm5Olzd8zOPHY8BGIGV8j9fq
         ilBBsRIk1Q5CzJkSpPFeKgcIvRAwlT1Sq9UHbmFUDmp+DiAze4N7yEFVtZ4RxrODCACV
         v6vF7sufs1nEMCnLuNnV7VIzFPuaSF10GdXb9xZMO+U6tXMODXtRr/PZ/NmutdvIhrJC
         DAR4h+I+oXb7sxPiYmWf0jEtwC14YYEyn1Tca+Ka/ggShfc2nVSaw56gCEd9USytZaz2
         O9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791927507; x=1792532307;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SeiK8ZyxkQIyZd1Pses16K7o3z7KWoWsXpfBOJdg54g=;
        b=xYJrHseY402zd2P67BfuUMBezmW4Ovm2zwWuj/Vi+weuTkRhiCNkzITSfHGLBAHoV0
         1UeIOIX200xp6fBO416BRK2IKO0Sw76GIr51kXPBsG7UZTcjdLCDzHVYKebL7rKPdsOS
         lhWcWeyhP2lLjmxgQIRLDY3ybCeyxGY/V7gyIBvooKxyPLEiFKbWOa98DoTBBqNo0Z/Y
         bQL/pcbAsnrogAhVDkfR/GnKdh8vbv5052fNyDnUlU8FklQfq6AOryf0mspnEu5QchpX
         wpVTRmAoD8oxpc7DAKZhdwZEXguKOf4rB0WACSq8Ptmr5Bh9um6NMGExNlHQL/POM2b4
         XkkA==
X-Forwarded-Encrypted: i=1; AKwUvBxaEg/vvrGkHximIQj9AShGS70sy6Gc6mSiwqjVWdP5I6Dxje8E69mv72hI+FU9Ob57BDncNAoY9as/kw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLBu6kx2cAbchVjBry6NdcJgX+boacLIKVnneeL7AuSga3CjbTm
	ZiebFGurNFLJnzYI1Gg7QLIQXi2qUGqFWXYA3YpwNlWMD0+VPkhY1bauzKvLzSrjfvc=
X-Gm-Gg: AYBFou2Qeu/qs8SVsdyru/S+glra18aPl57FnLT+VdBFgO8OWJGvEq8t2R2VvCfAtBu
	PSKGE+6yC77LvktOrbJ6Z8gK2VbRFxT40RG2cqOu5O0pikvruE3AhyBLn50I0T8Z4+TJ1Zqmebs
	X/sX7cVj/lqmV7KYXYWMFmGCVFY19uyyecdff3tsSE8kZMCKVMDmoT0rOGBCevA2v9HGCo/KyA9
	Ia9sK3f8sIXIwlsZUbKVylJfBSbVjFvq2Sk5zvA9uYw2tcEProM/9Llcj0TpVN5n212zZMVzVz0
	j8pmD91QZXdo2GzQfZld+IFlP2fBBbPDnR/Jdrw+V4ryDDRF6Ym1jqltG2IbBOQCXkKT/B36Zl9
	CLAppAPzNjtTn5TdQsCWS8nSVxlAhG2YRc4/24EVqmlNEOAvnWA2vLjy3xtD3hPETmCGOSx8pZq
	QUzQAHkml/gEObTcMBjLVkhwyKXw3oz3R0H7M8eubz51qurQoULo2/VgtTKpW6SUg=
X-Received: by 2002:a05:600c:674a:b0:4a1:7cf8:5433 with SMTP id 5b1f17b1804b1-4a18e443ee9mr256401635e9.3.1791927506957;
        Tue, 13 Oct 2026 14:38:26 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f2a88b4sm1450688a91.14.2026.10.13.14.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 14:38:25 -0700 (PDT)
Message-ID: <e3df2af3-9bb9-428d-a0f3-dee98c25a7ab@suse.com>
Date: Wed, 14 Oct 2026 08:08:20 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: exercise NOCOMPRESS range and EOF handling
To: Dhruva G <goledhruva@gmail.com>, fstests@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <cover.1791395660.git.goledhruva@gmail.com>
 <b99615bd-9b7c-48b6-ac70-d450a606388c@gmail.com>
 <2920bc87-3d1e-4bfa-99cc-8b4af37fec5e@suse.com>
 <ea99086d-94ea-4b44-a2f2-076047fb22d4@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <ea99086d-94ea-4b44-a2f2-076047fb22d4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/14 04:38, Dhruva G 写道:
> On 12-10-2026 03:30, Qu Wenruo wrote:
[...]
>> This looks a little overkilled to me.
>>> For regular hole/compression flags, what about filtering out the
>> non-hole logical bytenr (e.g. replace them with 'XXX' or 'regular'),
>> then output to the stdout, and use golden output to verify?
> 
> 
> For patch 3, the test also needs to distinguish compressed inline extents from compressed non-inline extents.
> _filter_fiemap_flags 1 retains the encoded flag, but currently filters out the inline flag.
> 
> Would you prefer a small opt-in extension to retain the inline flag, or a test-local filter?

I think for now a local filter would be good enough if there is only one 
test case requiring this.

But in the long run, we want a filter that only filters out the bytenr.
Maybe something like _filter_fiemap_keep_flags().

> With the extension, existing callers would retain their current output, and the inline test could use:
> _filter_fiemap_flags 1 1.

More than one boolean parameters in a row is never a good idea to me.

Thus I'd prefer a dedicated filter.

Thanks,
Qu

> 
> Thanks for reviewing and suggestions!
> 
> Regards,
> Dhruva Gole

