Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794233665;
	b=cg0mHtRE2ehezMx5AxgYENZ4dOvT8dN0v8iK6lmBfL0ZEUmveDgkVlZ/0R7J72yiY9fX
	 aHqdP2eEikd0UrMSaiIBBfNVYyTiUUuit9S4+cD5yaSa4dNByv0ZKmP4zzEVHMRGeHYpj
	 EpmiCb0RZsTcPIDHXCCxoE88aVnXs+lmk7n77R80+xZZUr8ARapysZvrVHv5HTOC749dh
	 LsEXbtkdIDwFuyzk3x+n+9gvxYV+E299gjd2Yd9vfv9AHH2sOxFyieBVL//lbqKO8W9gp
	 2wRYT2BYDmqYbGIATNuaJHSLcJAq3APZR5p9E0uDiPDXxiKu5/0tYA2bj2a4hSFE3VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794233665;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=AcHHMXrnuSzlxN8df3lXl8TWnZ4VN2Rd3OQcEzkx2fk=;
	b=EQnaEmZmnhtlhze8qKMXDCeBl4KP1LkvU8gybCTLFj7JhUmP8Ew1n0KRESnvob3C92e/
	 WtvjaIy7NP9pMCBf1wyMrH/YwuzuoTbE5UUsdM/ynB+8Br9jyTNfOKj5Aee+rPWtiQuAi
	 9rclFcltprykc2GJReQsVj62ptxUeBBCryhM4OBQMQEF1MkgAp99sjHnIZwcv5y8N4z72
	 2IaT4f7y0WQaseNSfS5pDlWva3w/xMSc2yjqnKLM1qxPv3Gs2sF94ZipS0Z5vZqowZSsh
	 1Ec+VXNqSHr/yOLT6//plVdDP+3t9pOcv695K020vC14GMrjhsjE6t3Rx4p38EMJ3TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ampx.net;
	spf=pass smtp.mailfrom=ampx.net;
	dkim=pass header.d=ampx.net header.i=@ampx.net header.a=rsa-sha256 header.s=fm2 header.b=s+gGsApI;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Wx1j63xz;
	arc=none smtp.remote-ip=202.12.124.151
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D257606A33D
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 14:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D257606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ampx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ampx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ampx.net header.i=@ampx.net header.a=rsa-sha256 header.s=fm2 header.b=s+gGsApI;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Wx1j63xz
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 809781D0015B
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 09:14:24 -0500 (EST)
Received: from phl-imap-03 ([10.202.2.93])
  by phl-compute-03.internal (MEProxy); Mon, 09 Nov 2026 09:14:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ampx.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794233664;
	 x=1794320064; bh=AcHHMXrnuSzlxN8df3lXl8TWnZ4VN2Rd3OQcEzkx2fk=; b=
	s+gGsApI/EOmS/8fjmiE5NOp0inQvwJ38uekgsY2CE1S4qTJ7/zQ3VINRYg/ytps
	Wv+xH9BlNQZaM7HMnFHoAVIg3EPEc8ysNI8MaBFhoGwu1e1pxMhR/EXDD8+q1I71
	8M1eZ9JvbNqpTLutXvjsXl2TU+UclNM6RBQ9ghOPGYEfPIOf08n8RMK482SuY0wk
	Z2qsQaVW5uy9NhydUYXSFzO19NsRNRl8WE2XLIUP3TH8u2znlem4PyYWoYFLUkT2
	5ILlHrbwk4PWEyk3cB5lOPb+XzoV2aE8ihTun8cDvWvbHXsNCwIjoI/Te0YLAODl
	PEE7XubGNFgelaC9b0UH6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794233664; x=
	1794320064; bh=AcHHMXrnuSzlxN8df3lXl8TWnZ4VN2Rd3OQcEzkx2fk=; b=W
	x1j63xzkHr3O+V8hiqVOwQyuVs/WtrVru+gCWSXyNx7QA2TFSf8aC+5QvcvPZ2nD
	EXPPORJ7/bHH+BYJFJ2xCAaalmKbB1vCxOBcJywpGeHyzzh29H18pFiKfnKHe3JM
	z/hGa71QJ7dIwffEq7QtqJahfm5lzr2XMinvvLGwLY7Uvv1v/twBFmaqDrUf9/NX
	Bt0fn4U0q65TXo9hHRiHPALKMSORWgOyb6cue+hyxY5hKOmBYeuOyLl/MNqQR0x+
	+ZlHwD2zeYqQK0HAwnFTjqmRzGBXHsjlVgQJXFscoA14ZF02ehW0B2tfpIzRDhye
	q8Na+cCy1m4NhhbTCcnKA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=ampx.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794233664; d=ampx.net;
	mf=PHN0ZXJsaW5nQGFtcHgubmV0Pg==;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm2:rsa-sha256:hXkt7cbsLd3HEpCkk7BeX1YrqqQ8OOhF7StxO6XTo5Ouj29
	MBZbIs8uD3slPCe5EaufWioM1gmXtWYkzbKVF2H8/9FYHseDt11UriX1SvKlCwPs
	TIdWjagiD6buLPa2P+ifjM7QSn6rBLD+InK4VdlaMbfxEmaTlbD76Mno/uo172Qq
	XyD2jCYgQruTGTldRhOwr8EhF2EeF3FmBbrGcfv6yqJA0MVVupRbE74UCNUDc8RN
	FTVHf4mQ7GxWGeMOsHulxxyX2n7kb+J/mXIgEWiaD8JjOvcTT/s/876dceZizRRi
	Y4ywR88XOgqeaHy9kMF8OZdMGJ24acTJduJ6omQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:grEPGYTIn6AXRshIEtQ0VUkNY3bbUuCjSwBw/SuTTR0=:AcHHMXrnuSzlxN8df3lXl8TWnZ4VN2Rd3OQcEzkx2fk=;
X-ME-Sender: <xms:P9Xxalm6VN0-UU4aafcwMaD7RRM65Cu49PXkM-HjZC30c3EHekQkMw>
    <xme:P9XxarohGjC9dFd1_bKibeT4BR-akmweyzLOctqhyRrNwCrRnR_lUpIH9dUkQhnp7
    WuL2yV-p38GEj_wX4mmk9uV8jspxXuJFaJeiX9MVuX79LqVfx9iAzo>
X-ME-Proxy-Cause: dmFkZTF6APVwtVper2eHHd7Gh6EOKMvX/m35lt4HzcybNXK87dQPWluZ8gj2e3PMK5uvqI
    sM3UNtZtm+18ZKSDrbTDT6USGJZsd6yTVuR8lQMA/QkYN/4K1+wZfvqoeUXwd+Uh/VpasL
    XRPHauBjgO4k2vP8zXC45tBnR5vhOX/KZ2w4RMzFuWc3Q8PIvy790eY3JQzR09NiUhGDEe
    Dyq0gdXF3RoZSgqol4ZFCI2nNkLHXqPZ4+bKFVeEUr0+hpaJNqnxWd8M4vf/eM1/srQlS7
    RGwBxugNbiEGjihbQrsOmygh1Y6j2twl2cup/qFgTLAV3c+tcAyyQET3NhRBOpnp/jWCjI
    I4SmWGSQI8OXdcNsZGOsZaYPbc2EHyeW72wFaNfsudmXDJiGveqewIu3L5P6i/A3adf/6g
    xvO1b1cLO6PUpbUC/wDsbgcA/988Bm9TZr03Qwy7VHlCYi3sJ1OKSJZoY9AFhk1jH7WcL/
    1jpD69bXOMvJzkS9d16Rzdh/t9jK/ZNOfht0ZCwDXNVC4Ol1ltKkjUuspg0MspgvsduRJQ
    fN04+MMWjgq2N5OiYwWaTIIFlQtR5m8WAoW01MRt3JTIE0yrj7zdWOK0ejA9Ow/vDPdR7P
    zsfcl8n79Jwc9+9NW2S+GXp2ClhkL8LpQ9nokCsjxbiq3O9993u437IM7ZlA
X-ME-Proxy: <xmx:P9XxaijDpdEFh7WjCCJgSLW3yA9-ORY5aAEI80YtRmNRzSJbBmXcvQ>
    <xmx:P9XxaqyLlLLiWKR6X4vy-1Wc1PIID5XXJCWZbpfPZWCNcjkR3TmrAA>
    <xmx:P9XxatJ7rdOnmzFNuVH4hBrmBJTUNvWFJFvulsgYavtOnjfDT80G6A>
    <xmx:P9XxapTlRUrTIqwa4-c4999c36JrV8xWSt6F6iAd2WV6Uz4xPCTIaw>
    <xmx:QNXxap_9lxgwbbkSokGuf1Lt0vJTZaR2IgG8kR6aR1MkhDLH488pxIr5>
Feedback-ID: iebe147d5:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DBB8D18E0071; Mon,  9 Nov 2026 09:14:23 -0500 (EST)
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
Date: Mon, 09 Nov 2026 09:14:03 -0500
From: "Sterling Windmill" <sterling@ampx.net>
To: koraynilay <koray.fra@gmail.com>, linux-btrfs@vger.kernel.org
Cc: "David Sterba" <dsterba@suse.com>
Message-Id: <5225511a-c66f-40e5-b9d6-31ff572496da@app.fastmail.com>
In-Reply-To: <DMQQG1D324U7.2945KG0ANDDJZ@gmail.com>
References: <557fae4a-3c08-43cc-924c-89d1f0f3896d@app.fastmail.com>
 <DMQQG1D324U7.2945KG0ANDDJZ@gmail.com>
Subject: Re: [RFC] btrfs: forcing compression per inode via the compression property?
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

> Hello, there is a github issue tracking this and a patch[2] (by me)
> currently pending final review.
>
> Can you see if [2] has the same behaviour you expect?
>
> [1]: https://github.com/kdave/btrfs-progs/issues/329
> [2]: https://lore.kernel.org/linux-btrfs/20261103194734.598182-1-koray.fra@gmail.com/T/#t

Hi koraynilay,

Thanks for pointing me at it. From reading the series (I haven't built
or run it), it looks like it solves a related but different problem.

It lets the property carry a level, which is useful, but the only
inode.c changes are to how the level is chosen. inode_need_compress()
is untouched, so a file with btrfs.compression=zstd:3 would still go
through btrfs_compress_heuristic(), because FORCE_COMPRESS still only
comes from the mount option. I would expect to keep getting the 31G
result from my table, unless I've missed something.

What I'm after is a way for the property to skip the heuristic the
way compress-force does, so that one subvolume can behave like
compress-force on a filesystem mounted with plain compress.

Since your series defines the "algo:level" syntax, would something
like "zstd:3:force" fit as a follow-up on top of it? The alternative
I can see is a separate property, which would only need a small
change to inode_need_compress() and wouldn't depend on your series,
at the cost of having two properties for one setting. I'd be glad to
hear which you or others on the list would prefer.

Thanks,
Sterling
