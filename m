Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793730860;
	b=yNmJ71Vx//dT5NPChfZILAKvoud/n8BymBrUHi15lZ4kt0lq3BA/etJ0oohyVBWnDLfz
	 0LYsIvhm8ZsTR1VoJuERzjrLlXAEtsWn2YsluWM8dfja6eQe81IBdclj5JYgDm4C/ljKc
	 bbxZmqS+la+/r4epDVa59vnUtt2E+XgNxG0B8AdkU409nB7DCcylTyhjfzGYmxhmv0b3Z
	 iQSh08Pqx53phWcn7gDHLGmzmV4FXpDsiOWpVDIWrHapjip/8m2jnxyS1SJi5oIMc/MBr
	 /+erFysfMnWTcFqIXzPLcDigRb3P7e6KePul+ThBjrFca0qS88v9e78pEUJkv1qzBdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793730860;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=B/cmcTDQRcOAXfNbk9K/zMx+8NKYEanXMLNS9TD/wko=;
	b=N14envGPbcETurGDXco62qA+7ZhGkdPCx0dj8Y/H54pn1cs16iqRl9owyjxiHwkD0jYJ
	 2yr40brWSEzNy2qb05BBenWaVUcT+hYl2FIMXTJMiot9Dq6+iUx+5f4xnnagTOuE3TP76
	 nqJKPa0x/sCiGdmlDGIMf03XMgB176HQsx6iydQPUlVPLxGKM0qCnXgdBm5eiueg0ZRHT
	 RzACvSuPzLAFuVQk3uB1BH1v/11s88eUF5Zl1Qg/tyHZSE14SNsIhupjxtEA4XIMmYC78
	 T3d/LDu6ZMD3Gy3F+I9LG3Bkyfxbq6dbA17ych7G++3ppB6ESTrOly76dVGnALtM48g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=colorremedies.com;
	spf=pass smtp.mailfrom=colorremedies.com;
	dkim=pass header.d=colorremedies.com header.i=@colorremedies.com header.a=rsa-sha256 header.s=fm3 header.b=MC0n8GAS;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=w08nnpQd;
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E55606A329
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 18:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10E55606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=colorremedies.com header.i=@colorremedies.com header.a=rsa-sha256 header.s=fm3 header.b=MC0n8GAS;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=w08nnpQd
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2AF8E7A007F
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 13:34:14 -0500 (EST)
Received: from phl-imap-01 ([10.202.2.91])
  by phl-compute-01.internal (MEProxy); Tue, 03 Nov 2026 13:34:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	colorremedies.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to; s=fm3; t=1793730854; x=1793817254; bh=B/cmcTDQRcOAXfNbk9K/z
	Mx+8NKYEanXMLNS9TD/wko=; b=MC0n8GASxyR/SkS7CtelRJXGn8E3Lawoh87Vv
	KfHap+InZ/n5Wz4dOMFm36GbsoWJ4k5Vq1kMma4ycU6932rWQgyADT2IozD/q1Ok
	fYjZDmOwPB4EKhKrMSjPxbbUgVy6WYTuDPIQJtnqegs/6yHj3994X4FAreePwa2E
	1Qx59LiL5/p4sv7hEnDztuhXIZ4DTiNj8YkBE4lVjFOtpv5VZVd8d5ZVMWsY1saM
	24vtaAQjBhP95V1vb8BCoBim8qBgrXFhYYb9+2NQS2fbDaFY5TVhsYOsghMCUaZa
	jX51JPaFkSrozZtbNN6wTnIudnlKdMGZlAwYT5EIckoMINemg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793730854; x=1793817254; bh=B
	/cmcTDQRcOAXfNbk9K/zMx+8NKYEanXMLNS9TD/wko=; b=w08nnpQd3yRGhdsFh
	HQWffn9t6uFRk2ftiElSlH1h9OPz/lDrYtW4FV1S2OJoScCbSN0M9ZL1zvtD6KyF
	0YxvDwAR0gHVJFR9y7qA2ehlXyaVUMFtRF01Y4qo7I0fnTa1IAFPZx3nZbtFERMM
	3mc6g4KiyoIel5pzDBBPrkH7pyLMeZQ89iIE0/8NvOYm/U/e3StW+X+6pGQ2pN+x
	wwbW8iFKAj0ntR4eG4sOwWT/Q2EWoV80xEpbKYWac9i/W/KXnksVIK/rL5P8hcYM
	xbJoz25ODlYCy+vm5pgncZtAAEABdbj+GvtWhINEyqD71mCUSTr3auTfWxu4fheY
	R7VCw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=colorremedies.com a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793730854; d=colorremedies.com;
	mf=PGxpc3RzQGNvbG9ycmVtZWRpZXMuY29tPg==;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:fTWJmIqGzvG7CNzg8B114NmQKOaK0nfyTRdjkNkzkwOs4dF
	Rsf50lVqNfA0v42BJ7VMn44z/SvkaUXmBAYa9StBRhchiEzRoMMw/MYxrFRqhXMi
	sMHmITdrm4futuyOwGcr+C8WetZtNkQAgqBoSBkvvgv6d5QiVFODTrXNAdKVvtPw
	PMDf31NveOGrubMWy5baDng8tN9gHP6RpZf2ikgi7UhxtbX9to4Kvj/z+hFR04GP
	ZbIL9P/XsujBXG+7T4q0S8+yW/vCPQxC4as1OjDbg+mL9UdF31Q/fNMOI6QIlt5Z
	qhO66TxAgW6/aJKj7j+lc/BgmJKqcjxE2hWPQ/g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=content-transfer-encoding,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:2a5+2nCS77pi+PZvywgCgOoClZVlP/Vd6R39gsX1ocA=:fHE6asmHKEqJoQ/5e3VGbeY3h6+ERWC8nJ5jd7ZYynI=;
X-ME-Sender: <xms:JSnqakDe86B8PeLLEC5LOexPiNgMOUKpR0oQBlz6v6ZcASV97_xjnw>
    <xme:JSnqahX1EeCowrJA3IQUHNsW4tJcFQRVxWomGm0XxmocgovnFB_44KhFJkThkywsU
    BhmP2qJ1Kt3QZX3XZ_v9mniiqgqXb5QtCHLhsOdMigHbxSkyrJh8L85>
X-ME-Proxy-Cause: dmFkZTGdbS9X5xvCL1DBFQFQDEWO2fdJkXP9UN87M4K5oBGCxfXlowAhiDTHcr/dV9Oc74
    GpWsUD94mQIBRLxsinfucssRLl5zr9AmP6eCylcLV9tEH0GxbEksnhBNU+wphQa/Fzen3G
    W3c21V+WTwJIX7JAQG6263abFKmRc571782M+Nz4PIczq1vzRqQhsSQHx/kQfJaJzIlXG2
    yIr+llCRyGcJJ4T6P8yoO+7nBtwp5zCOmVutWQMSwbQxt7WOO/atiqvnQz7Dm3/xTmqD2L
    hAQ0V1fgKo4j1/Qe4FlIg1kvMeaf//zd6VLD80g+j/b+sSKMr2QHoph3Qse32qQZ4PJ8co
    hg3GGTQ6pU+ubV6nWbeJd9YnwPUj2The5sdegBFKFLKmQr8ay5S90bA0MuYrKE+DWMjxOZ
    thI1A/WH8bvslR8WXigKNj66VCElfTTEYD75hT91ecBIGyNewbFoZUH0osiRZyagn4L3cH
    e9PLOqbgdD/mkxbBm8HAdG9YgjZSKhvh+vXHTfiIsr6ajmkKSeYsC1zkfU71QkY1s8S33j
    7TWTCwpjafBbUpFBK1f45GhwF1c3XfSKqHyxFry61cvCFYE74qXkdKd9qu+KAsLHE0R4Ep
    mBSHkX1Kn0yLToOjuaGjqRubqgRSG6Z7jT1SronJjgowJzY4cOrfxWoB0wdg
X-ME-Proxy: <xmx:JSnqahSRzwYA_3NImwEAcDo7ndVE7qll0qT6Z9AQKYaPquMnTzvgXQ>
    <xmx:JSnqaqs-nuGezxz8c65shLdz3gK0QvNRJqAoLoPucD74ApmTqnpafg>
    <xmx:JSnqajtGd-22Q4p6jkwCc3oWbOuZzH7Ccu8IzMy3x-5Gq6tY5AZwNg>
    <xmx:JSnqagzW8O6SMSx8CN_AmBISHKYoHWSJFhQUrisf1Xd0uJjN6_5Ypw>
    <xmx:JinqajmAc5VMWuzxguK0bt8yHj4romA6gCMS7rM-4zPv3gOXv9q1YcBt>
Feedback-ID: i06494636:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C33B218C0067; Tue,  3 Nov 2026 13:34:13 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A0TrnmbjStBo
Date: Tue, 03 Nov 2026 13:33:53 -0500
From: "Chris Murphy" <lists@colorremedies.com>
To: "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <b045ed55-18bd-48d0-9dc4-2756c61039d6@app.fastmail.com>
In-Reply-To: <fa0ffb25-3c1d-46ce-8cc6-bdc1e2d86c2c@app.fastmail.com>
References: <fa0ffb25-3c1d-46ce-8cc6-bdc1e2d86c2c@app.fastmail.com>
Subject: Re: bitflip in extent tree questions
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

4. Is it safe to run --repair? 

I'm uncertain if btrfs check repair has the ability to safely fix this type of error.

Chris Murphy

On Tue, Nov 3, 2026, at 12:08 PM, Chris Murphy wrote:
> User reports transient Btrfs corruption.
>
> $ sudo btrfs check --readonly /dev/nvme0n1p3
> Opening filesystem to check...
> Checking filesystem on /dev/nvme0n1p3
> UUID: 73b0efc1-1bbf-44a9-b61c-f4b8936608ae
> [1/8] checking log skipped (none written)
> [2/8] checking root items
> [3/8] checking extents
> data extent[3068469248, 4096] referencer count mismatch (root 257 owner 
> 3844574 offset 382279680) wanted 0 have 1
> data extent[3068469248, 4096] bytenr mimsmatch, extent item bytenr 
> 3068469248 file item bytenr 0
> data extent[3068469248, 4096] referencer count mismatch (root 257 owner 
> 3844574 offset 382541824) wanted 1 have 0
> backpointer mismatch on [3068469248 4096]
> ERROR: errors found in extent allocation tree or chunk allocation
> [4/8] checking free space tree
> [5/8] checking fs roots
> [6/8] checking only csums items (without verifying data)
> [7/8] checking root refs
> [8/8] checking quota groups skipped (not enabled on this FS)
> found 851404390400 bytes used, error(s) found
> total csum bytes: 828557228
> total tree bytes: 2640494592
> total fs tree bytes: 1551499264
> total extent tree bytes: 167936000
> btree space waste bytes: 398250390
> file data blocks allocated: 10191907336192
>  referenced 895043592192
>
> Clear bitflip:
> 382279680 = 16C92000 = 10110110010010010000000000000
>
> 382541824 = 16CD2000 = 10110110011010010000000000000
>
> The questions:
>
> 1. In 3/8 checking extents, do the 1st and 3rd lines tell us that the 
> metadata profile is DUP?
> 2. Why does the kernel not report a checksum mismatch? What does this 
> tell us about the nature of the bitflip?
> 3. Is this almost certainly logic board memory induced or is it 
> possible it's a drive cache induced? Seems the lack of a checksum error 
> tells us the checksum was computed after the bitflip? Therefore not 
> drive DRAM?

-- 
Chris Murphy
