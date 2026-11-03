Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793738532;
	b=DY2mxMUnTOtLGqNwf0WMaXqqtXB3ht+yeThUeBmel6oD1D8H0ytFg2Sx+gQ/fYpg8whp
	 /oHUsY5Js9h08GSo4Vimsr9GPi+DmrVrKCa6b/mdtLa4cOC/8iZhz9y/FkgVgHcgswMax
	 BHJx6dC9GKVqppvXcn1aoDYtnIyvVWUk9/ha2S/aWAi+ZIwjO6ZBtX4HM/unoRdsmBQnp
	 v/JUKz2ENzyYJrcDR8s4s+9Ir5MMmr3fTnZp5WHgCR0OM9X9wPCYa8DE5RRFHlbSiL6TO
	 LcJgtgV1ftqmNfITYUi6yDRWsbEwJ2U+1CgK3gOAI5+Ilps1XAJfyA8uixI9eWjJfCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793738532;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=7GFg9CMcw+k0GNRHnnRj1fRvrw9rtu6syCMCTKPIOQs=;
	b=kuOR6CFGNsBFPqbSsbZxCjBtF6E6IO9e8nrCCitwRKXl74h6BbpkF+1Yg41XkcWjjErL
	 36d+rOALOwxvMEUDdDRVzjYz3/edmvRhFFFHujGo/rJhdujKPrCbqEnHvLMvqyKekFdJM
	 oGUIxVAIKlHGxLBnwHnyjn4Ui8QlkaHaueUtDMdmCihBQlDDeUf2Oa+J3iAKzMa3IFk3c
	 cAnNU8Ve018etlxs1T655K6pH+UzaX83zO33OfB93C+xUkRqKWFtAwfPwHTp0f844c8Vr
	 qIvWkH5LR6oA3Le73CJvBZbfFHKTc1udQUDtkmpcVOwLMyRxAPN6cTlI9v+wahcauvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=PoHy6DNo;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93ED606A31B
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 20:42:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B93ED606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=PoHy6DNo
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so11429915e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 12:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793738530; x=1794343330; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7GFg9CMcw+k0GNRHnnRj1fRvrw9rtu6syCMCTKPIOQs=;
        b=PoHy6DNoBte1rC7hueSWVzXOSVVwzlRD0SOvaZQUUvtDEu1lmT8D2ms8uUZkT5xgub
         c/RarLNibSs/ROu3hgfzV02lIl2cTN4cv5K0oLMg4uBDaDwEnSCtjcua6DetpBEEZ0sr
         NoWfIdNAwg0G2oXOiwRhdkPNw3+6TVHdxvcztYKjpGL7ZwynDZ2HnyNJjqhJ0UAAffU5
         XAaYQJeYiJ+PAX86eDSTBvH9w2DdBI1/OiuAuWVEs711ZdI1s5UnEimxcZtEKhwSvsXc
         QcLHKp9NZeSNY6jC5dDbRFzZdNifdklLx4/cUIhfND/miS6liL1nEYVQRlxNUTlFluiN
         /86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793738530; x=1794343330;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7GFg9CMcw+k0GNRHnnRj1fRvrw9rtu6syCMCTKPIOQs=;
        b=hXohE0VX6E/ziUECAwtNnEKi98XstclNDP6WAocEAESycmWc429RgOv5466mNJYZQz
         /cM44v+Ius8n1jqhQIN9+Pst+7o+5MtWt9YFc4vFscIaPi7b2rGg2NA7PQzc1g3FylOQ
         VJJF7JPkuew3y2BToBBlJy1x5iLk6j092YzaOVEB8i8P+oVbBS2B0MadvoGLQUiAHyey
         pxEVXHfegqRimqLh6vijKpk5G7fNkkdSteDjywnUOlxwIJerawJNc93YGeumxt35XBbF
         /ffwCHW6qJjZXWLOfXIK1gDpt/fsG2PycWULjKPjDCjpZKw2qb1bZTiNaDoJh3xvnQSd
         VA8w==
X-Forwarded-Encrypted: i=1; AKwUvByB3IgVoyNpSETtR5cqonqqF3unPUKJSUoZXkD6fsExB709vLV0aUzySAzgbEtdaRZrTCbgPQ3Qfu1ftQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/D0Ww3vNmsai7tNmjSk3Y6fDeA15arb62cQOE1iVPF5Q4MDo2n
	5Qi/PHBDEOLlEq4qfjlpCO/tA/mN0A6ZQ6POWrAV8twoTzwMvBh6c331XiHXUrvHIl/ESKm0/u6
	jpyElqMA=
X-Gm-Gg: AYBFou3TQJXiH543Br0Fk4yMhgCnSVqYiUWf2g7miuZpiuurtoHo0S8YZn/Tf8N3saj
	B2I08nkCcFTlHNn9UB0YcXmdud776hNJzAipW2lFYU9XgkatND5XFCxZWiUnOG/su0VvnXQHGmL
	bG+E6Oo/+UxhbjffjcEfWopbp+93h/VuKhRDmVwvkx9I655WYy57a72GNsZcZX5K6zYXBEMcLeb
	w4FDPRbxZXEYC24Nse6MtCB+pCI20wmDTh+P04VgAmUpLcFe3HTUE/mLZ1Rkh7NR1b+PUmDTYZ5
	+dybQYLHimTbpyQa1n+XV0cGFKkPBpPrdvgrASMoHZGVdepaVDczO8FSxWMBsrCL8FlLjmdCwvi
	rCmbQWGw/ETfZakf9LhS7aDoHiz4NO1Yd+9BrJJ29pHP1HQYIfPsSWITG82KnHrfCqnZMgcZ235
	ECDC1B84M9oUbrLPVSYEddGEPZSU/mhv7W/GSxP0IRauL1UIjZbjfI3r+QFz4/L/uhXb4X4KtXE
	wXXGY9rNqD/PHJYh37waxvhjrnwbxWUp/a8bT7UiuPU37WNx3el49HZ8A8b0Cf1sA0fkMbcaiH5
	S5Bx2y0ajuG/ZI2Exm3N
X-Received: by 2002:a05:600d:849a:10b0:4a1:dbdf:6d31 with SMTP id 5b1f17b1804b1-4aa8b717bb4mr327050945e9.19.1793738530038;
        Tue, 03 Nov 2026 12:42:10 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38d36besm859710eec.11.2026.11.03.12.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 12:42:08 -0800 (PST)
Message-ID: <5843fbc8-95e6-4703-92db-5cd1df13ae9d@suse.com>
Date: Wed, 4 Nov 2026 07:12:05 +1030
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
Subject: Re: bitflip in extent tree questions
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <fa0ffb25-3c1d-46ce-8cc6-bdc1e2d86c2c@app.fastmail.com>
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
In-Reply-To: <fa0ffb25-3c1d-46ce-8cc6-bdc1e2d86c2c@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/4 03:38, Chris Murphy 写道:
> User reports transient Btrfs corruption.
[...]
> 
> The questions:
> 
> 1. In 3/8 checking extents, do the 1st and 3rd lines tell us that the metadata profile is DUP?

Nope, it's just how the extent item cross-check works.
 From the backref item in the extent tree, and from the file extent in 
the fs tree.

> 2. Why does the kernel not report a checksum mismatch? What does this tell us about the nature of the bitflip?

Bitflip happened in the RAM hardware. Btrfs calculate the csum when 
committing, so it has no way to know if the RAM is reliable or not.

> 3. Is this almost certainly logic board memory induced or is it possible it's a drive cache induced? Seems the lack of a checksum error tells us the checksum was computed after the bitflip? Therefore not drive DRAM?

I believe it's the system DRAM.

A memtest is always recommended for DDR4.
DDR5 has some extra checks, although not as good as full ECC, it should 
still reduce the chance.

 > 4. Is it safe to run --repair?

Yes. I believe so.

> 
> What else?
> 
> Thanks!
> 
> --
> Chris Murphy

