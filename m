Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCE21C5D5E
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 21:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791753813; cv=none; b=ZtolPTR9WHpwrHYNDLEi0jiRAG9nuHGwWxalVlklk+OCirEtcaXUgYFIIyAVdZ1j5OGEFjg0jWr40ZI94uDOGxmkGc4QP6MXhQCJpU3IkJwNDLSIai73W+KZqijhyE9JUIs/mXJEt1V97RbhkLWkgnhoGq1CTlz0CJ782NtD8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791753813; c=relaxed/simple;
	bh=zjPE5zTj8PO+aNeJHCeGEEYHwzZ6X+Z5pJ7yEUO3wRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y2nWPV0tAQvIv3bLhnmq1KqokNeTeUlY1kg7yBu9mK9opU4UDruORNFSxzU78tSSkbxGn9UDzjPUN4rEdQ8DnX5GaBOtnR8Mg6RzlnyjrpflgzjG69XGPhs1X+8/lK5RJCGwek6wbI4Pt0CN1MK54S3c4VTw6n82uQ4SP4whNwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DoYqa9hw; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DoYqa9hw"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a16c399641so13088235e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 14:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791753810; x=1792358610; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NtR6Oup1vyS42rk0xqVvYxoHAQHA6UwyWoozV7iO88o=;
        b=DoYqa9hw6OpiQ4j4Dw1NeALw2Jv7GDCYEujGs8IppLtjZ/JfboxeTy5rjYx/VbGpld
         5kG40L7c1Xp61QcZNpSG/Ay4tPSv8Fm01l9y/Xiu4MyIZ6ezfhhzGxW3VrcmymRY/sjM
         plQEeNSNOzOrYUELdNbs/nVngdl9CwEKb7hUpl4x53pABhcED59iH+JxQYzfx6S+AASW
         DxE4a1U0wFABR5s48Lhr7LJWtrVRdGyv7z6gjeN9yRMtdNSR+rTqZhsIjwuKmQujJB2i
         hYvgrXIquGg4VnGuUfxbyUaHGx1XIX6FaBxbGOZhXiOj676tW39zsiV0pVTo3R++ryqo
         j4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791753810; x=1792358610;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NtR6Oup1vyS42rk0xqVvYxoHAQHA6UwyWoozV7iO88o=;
        b=NEZ0m6jrbrmsB5Jq6ckZSn8gpM0jsuUMPtcK7GzluY+VXYytXKKbCbdwB1atkDtv8j
         JyZibEU9G7WzElyRJEvH0wxF/aXAAQmgPjLznEB2aI2ehbyBkJASnPpx1RFDX5r7T2k+
         hRt/1gJoby03E5bX9TZx/0Ff+JeaPanqOiFW5DU19uQ+0ChDrhb33QG9AQhoGnDQAaTl
         RKpY9WW9OeL52DkficHB1yCDwPt/0xORDnXRzYrpR0GncI4SzO59r7fclWY9XFeQHVj8
         JEs2qfJnuABhKXbRYbbpJ4NljOVBVe95YA8qQSq2YBkMHV960uJopwFrgCUl9vGIXkdb
         r9qw==
X-Forwarded-Encrypted: i=1; AKwUvBxkXXPBwSuWzf91kGpI6A8T8xSglp3/JJJMErRKprvHXX1WjLnsnTS17JxDHUArhvwzFTHBzgRH2jhguQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIdYpIU0h+IQLpOsmymle8nnevXyNvC91VKaze6anHrVtMEVUR0
	8twaRIE/NHqRhqAvliTw5x/H7WukFfN4YsrIFoHFjDVCIE2r98Ovt6NIMw6hOgCjD7s=
X-Gm-Gg: AYBFou1UpmfBD6BDkyAheD18BLjR4RG2bBz0cqPDGkrmYOcqPPuXToG/M8WNPdsfWcd
	jCnvi+F1gul7Yt6IqZxm+sddLdoQUb5DGn48R3YXqq9xhhm6wU9GtF/qeXAbe6HO2pnRJhwmWYL
	ndxpqzi//k2WJyTOLgcJmDNz4b6FprZNWAAUwHniHY10iV+TAb++cYjCrKaDSetxdL7/dlnBBL3
	dzNqEOsu8TBMLd/0Rp4hb2WCxIedQjAEpRasiuOvslQUIKoxlitCRe5Np0iutKQhaKQhfb1wchv
	fZeXTpVyiEXzsIOBRDpE4IznaeSt0Nr7xrC5uPT1f5DsMvKjdRgpdH4ss2P40OLIPC0eVQpOGBe
	VBXbyNONn/c0p95hIAey2gOTe+geN2ENXmjkXw/AX8TvZZgp50M3o9NL2isa+5ugFibEltQqylV
	Q0JVRkZ8kTiRyWp+3hrqA8/YIpbiR4WzcD+N3CDJvV08GwpZqry8Am843pacmjsDQ=
X-Received: by 2002:a05:600d:644f:10b0:4a1:9661:14b5 with SMTP id 5b1f17b1804b1-4a196611aa3mr53282695e9.29.1791753810027;
        Sun, 11 Oct 2026 14:23:30 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ddac6dsm12716817a91.7.2026.10.11.14.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 14:23:26 -0700 (PDT)
Message-ID: <7932729c-0e40-47e1-baf1-3e8de645b486@suse.com>
Date: Mon, 12 Oct 2026 07:53:21 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fstests: generic: add a test case to check fsverity
 reads
To: Dhruva G <goledhruva@gmail.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org
References: <20261010090422.59743-1-wqu@suse.com>
 <745a6dae-ff3c-45de-8bba-1e2efd45ca47@gmail.com>
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
In-Reply-To: <745a6dae-ff3c-45de-8bba-1e2efd45ca47@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/12 05:19, Dhruva G 写道:
> On 10-10-2026 14:34, Qu Wenruo wrote:
>> There is a bug report that with the recently enabled large folios
> 
> Do you want to perhaps add a link to this bug report? Just for more context,
> no hard requirement as such.

If you want the report, just check the btrfs fix patch.

A regression test doesn't care about the initial report, only a kernel 
fix care.
