Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792619377;
	b=w5TnHd25n3mXwwnxJeeQrQSgzbuRmMNcfFdl4Ixix9ix6+Ut2OweHdwDovF8AKMLmh4U
	 /dhQCyBw8SZC0vjZSwQs9hawlK9UTx0dO1y1Q98O8RxwRwZQQRMXMoQnSoNpbvP13PpvT
	 SpXEKsxQKXDodMCkidFSilbBIEsnngkQgYBospIvlwi6Wnp4wFWRN96eoNriORK5rIT+c
	 OTSZp3Tmqu1cgWt1jbXKPnRAxmEsQvGBkTZwZXzTc8/S5TW4jfZ0UsmVwU3AO8N5TEY+L
	 oOBBHnjr5YRUCYYxmoQptCKkJJ4kQ6RICEk6Nzu93y8cJZfJjx5ojx62jVnxhWXozhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792619377;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=SUwsXo18H2/yJ5WhM0iPY4LtiicyPtUbbX7QufsNDiA=;
	b=BiAHCwu9i1CF/sdR5tZ8H4xBQk7N7rVHuCkvcx2/Up41SFHUu7gcAcLatHhu9a3gKWGa
	 94oq47sTHmbvj3xP2dJatX8aIudAQ//KMxyqxoYEvs3nVUhdtirQ2J232znLva/yTtH/o
	 ebKonR9Ae09UhlH+38V1UGMShAjQ5GpyhdeeIOiL3Lg2/1utK7r0Zt9c8sKGLMff2e1bJ
	 op9LAmZEywGesN5nj1grFPoz1rDhI3aCaysOclSN73o6AxQgK2uTLurw7jsZw592zHvcY
	 adN+7xuszBpj4g/xZebj+Kdv+3Mt792pUnUi4kd0MCKC9hNN8QWSKbvsKeNF8PlSoBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbcbIH7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694CA606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 21:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GbcbIH7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463391F000C1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 21:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792619377;
	bh=SUwsXo18H2/yJ5WhM0iPY4LtiicyPtUbbX7QufsNDiA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GbcbIH7wo+LIhuQty8SW57T2TlrBKwpkHBLtwOpj2DppCxqPyIC9bhBtH7UMuK5EZ
	 N2Rhaf9WhP6mw7626J8JFuoK0JF05VzrItnFt1enr+a8ovEApHC8+iZYZ9kDPtl+g9
	 tVUYobaYSjqCRj6TsNuE8t+Umr3toUfwjZ4DIG7T5uJBNkVDWbv2qIFH/R3J2c0w7Q
	 IO3n/U3NYJyCVmdzT3UweVh7t1ySZs953SIRXB8vsGfiGPlVOpL/XT+p1M12u36wI7
	 Gwqk/ifjBefwKk/jPWsm6AiT9VncuOB7e0R125vPvdOMvMrO7XRLhL30DRzxoKnKey
	 qXBEdeuNdCKfA==
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-9906a5410f5so295180241.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 14:49:37 -0700 (PDT)
X-Gm-Message-State: AFq9FYJYUBvYbJtKr6gA7XZoS5Gs2GBnnPlFZbsosPV1yyl1haoDxydQ
	7vhghbeT4+ZxCuCCTUODve5d5IDuRR5E/Sup4AYon8MXgV8mqInYfn6LPTBju0k2dVzoMwX7KYm
	FTBGXJPVoiVeXp/WhipfRM+alqdKWMa0=
X-Received: by 2002:a05:6102:947:b0:7ca:866:7217 with SMTP id
 ada2fe7eead31-7cca973c31amr200625137.6.1792619376544; Wed, 21 Oct 2026
 14:49:36 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com>
 <CAL3q7H4JL0pWbGN-sQG7XCXeX60=fmxhSM-c-1xDka0eUbigKg@mail.gmail.com>
 <CAFoLKK+msAgM5tFx3w1n_i6TqHEWoSqULhidsNQA4qncK9weGw@mail.gmail.com>
 <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com> <cb95f89af722c5f57e99d4424c8b31a5155fbdc0.camel@scientia.org>
In-Reply-To: <cb95f89af722c5f57e99d4424c8b31a5155fbdc0.camel@scientia.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 21 Oct 2026 22:49:00 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7_uhKEQbdSQb34mgW1r=Gf0L2ko2=+ocpNRDnm72L_ZA@mail.gmail.com>
X-Gm-Features: AclHuK-4G6_GAKNwvF8sVJ7VjV2CgGulgnbaePOr9fYdB1IaZTCv26yM46n3P6A
Message-ID: <CAL3q7H7_uhKEQbdSQb34mgW1r=Gf0L2ko2=+ocpNRDnm72L_ZA@mail.gmail.com>
Subject: Re: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 9:39=E2=80=AFPM Christoph Anton Mitterer
<calestyo@scientia.org> wrote:
>
> Hey Filipe.
> AFAIU the bug "merely" caused the hole to be ignored and thus the
> received data to be written (inefficiently) without it?

The bug caused a hole punching command to be missing, so the file
content on the receiving end is different.

>
> Or did it also include any true data corruption.

It depends on what you mean by data corruption.
For some applications having a missing hole may cause
application-level data corruption or inconsistency.

If your concern is filesystem-level corruption=E2=80=94something that makes
`btrfs check`, `fsck`, or `scrub` report an error=E2=80=94then no.
Send/receive can never cause that level of corruption, it just issues
commands for operations that invoke system calls, like any
application.

>
> I guess there's no easy way to identify&"repair" affected files?

Just compare the version in the received snapshot with the one in the
original one - diff, md5sum, etc.

>
>
> Thanks,
> Chris.
