Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279041;
	b=XzJB4QXhIVZR13wlba8/QktvQAcG9Rl71/uc5N3ezO5GasJJk3bTAPfg3b1KrI37ArGe
	 L0c6K1tkbQSPMmSPQCGJLeCGvmAt5BpHW5n2SphpWg6Gwc04uvtJYRClwANrxlLYQgaW4
	 h5zGs5L9td/brvBQOPSTk+9Tx8evGgPC/jWtW4ppnQsDSqvjzb2RaBhYNv1aKt67vEeH5
	 UTZpyToxfQ7VyoD8OPISDIoP7W+DCeBEJtDUEPzdB0ue4sRlpenYauynPhQxuG5/TnSax
	 mVXo0yUnb9PXP6VQkHmCXmdLkuj0HRrQ7PVux7uZhEF7dwVAcpCfrQGKA30UcuBE5gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279041;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=5UHj/t5CDWyFZXFdKWFyneK5LIc0CEinK2vxzwjd+YM=;
	b=OGN7PCBBd43qzxRcu+i2z19RcgPnDN0e4coAcELeAHmJZZapgdWthAX+lTCNP5oMUDk7
	 o3KWA4VNZEIn0p0xOEFMMze6A3Blm6GhI3WD8IB2/Jd75QkQZcRzsQfYFeJyZilaOnkzu
	 cMKPQHwybZsITM/evdni8Jk7I1iSqV5su5EwnAG6OAqac6OrPYm8M6cBL4J3MEQhR9DA/
	 Dt9uL57860JN5tMcL9o6dZWyLI79wZIkXVKxBaObHh/AzGPTDDrHauKEqYwEkHazVOtL8
	 ehtJzML1MQEsYrBm9jdTbSfJ+29pucV0ReJ4+292xVpcI7RkUpN1nLBf5Jl5/uAULyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ampx.net;
	spf=pass smtp.mailfrom=ampx.net;
	dkim=pass header.d=ampx.net header.i=@ampx.net header.a=rsa-sha256 header.s=fm2 header.b=SejwmCSu;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=QKQnPT9a;
	arc=none smtp.remote-ip=202.12.124.152
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA6A606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 02:50:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FA6A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ampx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ampx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ampx.net header.i=@ampx.net header.a=rsa-sha256 header.s=fm2 header.b=SejwmCSu;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=QKQnPT9a
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 733B97A01B4
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 21:50:40 -0500 (EST)
Received: from phl-imap-03 ([10.202.2.93])
  by phl-compute-03.internal (MEProxy); Mon, 09 Nov 2026 21:50:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ampx.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794279040;
	 x=1794365440; bh=5UHj/t5CDWyFZXFdKWFyneK5LIc0CEinK2vxzwjd+YM=; b=
	SejwmCSuprwOIw/Ne2Hx54OOEY7nbBRzTm71YLeUoI/uPQf2+I4Y8E/GwYGIDA42
	mAElNW5+xCJGZ0TYYkfL9Sy/WcHTFWYi8RuhfjA8t7n3wvOjaiZ46jzuuKFoNSkA
	BL/bUwT2C1JgXhzN9lOtNodbh/6HdEvE8R3a3/EAwiRW1eWyR37a8ON+R/GUybto
	MPYMICzKjzQtVxdE+Il7uJKPMwyOuYzPc7+gdGcVfJNm30kc2VLhQTUgZ7SlFldx
	UDsBvFV7bOc6Bj59H1MCWUWkwSM902yBHxyrAbv8nIZHbjdKxErISDJbDRtYgpdD
	OZwQt5apQDtTN+xZcyENEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794279040; x=
	1794365440; bh=5UHj/t5CDWyFZXFdKWFyneK5LIc0CEinK2vxzwjd+YM=; b=Q
	KQnPT9a4mORUzJS3oz1Opa7RV4fd69qwNS/fRQx6IT7OigYl8w4g8gPxPSciJf0m
	38gLhrzYz1aVCn3O0UkA1kzq/Sspld2TAxcaGgT8swDz2BvRmzpVqikjtPBHSwhR
	vpGPsXy5xYB2TEh9jddf0xiadw6UArshAIVZqtTxrZ3LSe+P6zqFce7gMkDErh/7
	zrvnITgFgXqYarpA9KOhfJ4FA241Ef+/oK92zDH6MB8/CmsSzCVdeJ8SmFEj6CEb
	uBNoGYfLrc+ogla3/REJNIhxnxygDaRUZkeX5L3JZyLk8mvCSAoRAGhBGhKf4F4B
	nVx2bI9ROm436pGqmc61A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=ampx.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794279040; d=ampx.net;
	mf=PHN0ZXJsaW5nQGFtcHgubmV0Pg==;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm2:rsa-sha256:Uqt6KoU562cFCIRGKWibqpjJZ7SbyAoOcrSlmmJ5TAHeKAX
	+JFv9100VXTVIk2Az9eUhheQI5Kpl6LM+8NhKjLh87BPxFZITJc7PEEX3VZQ3DTS
	TQmwIh1uh/ikFcwzpftgunDSR+r5I3gp3Ky80CTkKLCjpvGvq+G9k4oT0F81j9p6
	pLqpJa7wrPcv+rWBYhQDLP+bG20aWLpiOKQtzocDmaoVzeyHM9jME2xa1cFQR+zy
	5rqL719yPtYMzPBbbqqObRz+X2bkDnl2KiX8TWN6CDIZWXFsIY8a8nb1fUbRuQPJ
	OIXCa22KDZIVh6ow8sh6KNa3ULtVplFWcS15ZEw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:A3CTrlkx7EC1iw9ZZVgdJsb7hnfYv67dttRbaIlwawA=:5UHj/t5CDWyFZXFdKWFyneK5LIc0CEinK2vxzwjd+YM=;
X-ME-Sender: <xms:f4byanlhRWunXntgrryDlD4qBsqtTenSWo3D_Hf8Y0LPjzYtGuEqlg>
    <xme:f4byaloKOKfY7jjTqhowVAfsJJ4QuNitRL72kFBN4ySPwqBryLaiQJcHAjZEx1fBq
    oFeMD9rH1esGxhPlFbz6EEi80WlP1Cr4hoGO_DzY01LF0pnFrw2WKQD>
X-ME-Proxy-Cause: dmFkZTFydLUBivG1RLJg+ULrvIXrDv0ytzC3zWyvH5h3ajH7KwEdl+4JEUSRiRwKiKFXKh
    uabz+Jh1GYiWUxhgc5Up5SmKhQghAZwx0oyFk7F+tumURlRKpFwRmuATZHpnIrauPgTSzV
    lQFfXB9iZKS0yRlYr8p49XKFJK1O3RU9vQgkzz4m2whCjmCb1cRg9JFsatsXeBwGrtffAD
    pM0pkK/UvHFtxGImjP2ezrAH4SiBugm7EdzaNn6vvUpLJYgPG5/0JxBYMOcfpqNFm0JCUq
    b2UkAe7IAByMJaLI5nsytgsiOukgpPx8o8U+tzCCxKSAsqqaBIW0lCxGUhxsSh1o/jrbq1
    WLjmYQOK9e6U/5gs1ZYHtqsp51SROx+JZi7EBmGq55HogFzqdZMieTiavHchH2tYiLvecm
    glflF2RF921zrlBQOeiNcEPCq+JG21RiWjebE5chh7rwU8eojPr48SX9+Iti2vxbAcBxE/
    oJJheVYg4NZc4gm4ws3O8GTtPeb2xEzj4mLgyBgIXzD2cn2qeOUfaRsk3AnKz3vhhhI4iG
    O4gsV1Ir4d1exVfcykj4UZ8y68bPPt5LKs5q/dW0CsvvKCUgtWYIYChwCAWiKPvA7S3H5X
    lkeOxx8TUNi5Kqnp4moqXZrAFElsTBJyXSOSUsqSiMpfFVUBucHACPGfcimA
X-ME-Proxy: <xmx:f4byakj5VcsFvpUSvdf77YXAjDjrvgytywbVNUeC2HLFb3yco7Imdw>
    <xmx:f4byakxXvPid9Muz-PCE5dwpfVD7ECtAirvEBX_G2O0RJNydPTfF2g>
    <xmx:f4byavLuEOuO8koYx6fStsl1T5Ja4IrPclorg0qgZ6HD7H5al1SpXw>
    <xmx:f4byajSqjHoNR_IjDn6Jxqqo4zrnX_e_UxL65TYA6Dr5f41KKKkaOQ>
    <xmx:gIbyapVXNDlRnabyWWuUlmh6dwWFUNAPbWzi6dCw0lmO_8h_pK9q_eDA>
Feedback-ID: iebe147d5:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B245618E006C; Mon,  9 Nov 2026 21:50:39 -0500 (EST)
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
Date: Mon, 09 Nov 2026 21:50:19 -0500
From: "Sterling Windmill" <sterling@ampx.net>
To: linux-btrfs@vger.kernel.org, koraynilay <koray.fra@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>
Message-Id: <bebe248b-8eb5-48f3-8dc7-ddaf8e4a09c4@app.fastmail.com>
In-Reply-To: <DMQYN0GE281B.1PW8AIHGLUNDF@gmail.com>
References: <557fae4a-3c08-43cc-924c-89d1f0f3896d@app.fastmail.com>
 <DMQQG1D324U7.2945KG0ANDDJZ@gmail.com>
 <5225511a-c66f-40e5-b9d6-31ff572496da@app.fastmail.com>
 <DMQYN0GE281B.1PW8AIHGLUNDF@gmail.com>
Subject: Re: [RFC] btrfs: forcing compression per inode via the compression property?
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

> I read the code a bit (and bounced some ideas with gemini) and I think a
> "force:algo:level" would work well.
>
> This, compared to "algo:level:force", would also allow a "force" value
> (handled like "none" is already handled), that lets the user set *only*
> the compress-force, without having to specify algo:level, so inheriting
> from -o compress=, and the parsing would be as simple as if ("force")
> str += 6, where str is the xattr string that gets then parsed by the
> rest of the code (in compression_apply()).

Thanks, a bare "force" value is a nice thing to have, and I agree the
separate property isn't worth it.

From reading the code only, a few things stand out for the bare
"force" case, where prop_compress would stay 0:

- compress_file_range() starts from fs_info->compress_type, so on a
filesystem mounted without compress= there is no algorithm to use.
It needs a defined behaviour, such as falling back to zlib as the
chattr +c path does, or having no effect.

- The check at mark_incompressible only looks at FORCE_COMPRESS and
prop_compress, so a failed attempt would set NOCOMPRESS and leave
it behind after force is removed.

- btrfs_compress_typelevel2str() returns NULL when prop_compress is
0, so children wouldn't inherit it and btrfs_fileattr_set() would
fall back to the mount algorithm. That helper would also need to
emit "force" in whichever form we choose.

One thing I should have mentioned: Qu pointed out on v1 that older
kernels ignore an appended ":<level>" because apply only compares the
leading bytes. "zstd:3:force" would keep that property, with older
kernels treating it as plain zstd, while "force:zstd:3" and a bare
"force" would get -EINVAL from both validate and apply. Is bare
"force" worth that trade-off, or would the suffix be better?

If we go with the prefix, the match probably needs to be exactly
"force:", in both validate and apply, and "force:none" should be
rejected.

> It should probably be a separate patch, but it'd depend on my patch
> series, so not sure if I should just make a v7 with that or not.

I'd lean towards a separate patch on top rather than a v7, since this
is a new feature that may need its own discussion, and it shouldn't
hold up your series.

David, do you have a preference? And if the series isn't likely to
land soon, would you rather see force as a small standalone patch?

I'm happy to write the force patch on top, or to test yours on the
images from my table, whichever you prefer.

Thanks,
Sterling
