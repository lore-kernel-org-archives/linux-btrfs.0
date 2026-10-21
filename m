Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792622450;
	b=LiozEu2zvBzxz2h5SiRKJ6fGm4USUU0JR32LtczdtOELnphjfYtxFmlXJ/0fYAR3NzPL
	 WyJyYk887uVJPuGq8QrGszc28nz2Zsc30oz/11kzQDUUIubGv59ePk6d5ST/il8B8pFBm
	 kV4vOr+y2SeZEKKjdh/xo0ASUj51vABSJG3sAXD81MeR4j25lKhCUhN/3blH/sCXtDDjA
	 FP7KhUJzO9q8hBzm1RbXU8/+xir+JGZKDdpTMFb4HwY/Fa1zZ025WLqO6BX2oxyXOTeQU
	 NAWjQt4/V2kUBUwopviKccjTIABDVoXG52AtvGPFsZeSZ/ViGqyHkQ682Q462ZfQikQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792622450;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=mCIP7CySVhVuwde0EUpBxqJDMwXfCEYhRRKFBJxwSJM=;
	b=ucTA7opXFYz4e6mAmaA0ZbpfRwVas3e/H+QC//szSfaMPkS9oE7bUiB037/rqDEC+hGj
	 U5tk/5zIIlfvprI/Jn8/Ul/GuIFutwayATbVIGjXPt4HoNbK5mdU1MDDW9TpdN65ObdHd
	 MnhEgJhdJ4nbKqNS8rDlhnbPTbd1AGu2tdAZTwIbmjuQC2eqezj4gsVJWeXVSvjWM4dlN
	 qyBZLERtQrJLz+ahLBexMZP29rzfhVVFPkI2if7RxZksKLMgJFZ7XAa3P6M52k68hvCLk
	 nUra/sTADI1aoo4jql0e+GWsshMU6qrmNaDvrgjpb8ceaEx5PI1KrWXCXBFmO0JH6iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AgT9frIC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BD3606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 22:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AgT9frIC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847331F000C1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 22:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792622449;
	bh=mCIP7CySVhVuwde0EUpBxqJDMwXfCEYhRRKFBJxwSJM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AgT9frICUFYxknHpo0YyLC5GH3/hz5dL4BbQQ8edPBsImOF885ayd7ir88xjcIQwg
	 uj44/dTpaKb1L9zOHL2tWYr5Cb8lKCSflXQUASWP9sNoHGsSodk4PX73nc6MzhM5WU
	 vPBztHpM2zPz64vOT2cktI5xJOQQtIOaQj55+omIxoPoXOy7agGMsTgtc1Yhp6nTT9
	 8b/WiqlnL19KbvLU4O7fBsyw9H/W59/9+ZtffC5hAeOamTgykSKx+q3lWqffKdvW4+
	 3u1/95O1eBvCt8EooTKKyjJNfcdc04QJDY8Q8J17CzNuS2s08ouZ6TZm8k9zrDcJV9
	 rESUp8SJUOvOg==
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eac4855401so614503e0c.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 15:40:49 -0700 (PDT)
X-Gm-Message-State: AFq9FYIhRe+9uo1WIP0LvdSGcMJ/O3g+WyHyFJLu0hz/MC6ps33217VS
	YMaKsDgJj8hrnQ22xBlwIXR/DaC4cjL+flOVfkIdAwJDMdNay470fol4Xhp1m2aOJAb6U/R3368
	k0x01iLpVXJpBgb4ho1e40BoxphCjXqU=
X-Received: by 2002:a05:6102:2c81:b0:7c3:2401:c4be with SMTP id
 ada2fe7eead31-7cc9263e69dmr1260296137.14.1792622448652; Wed, 21 Oct 2026
 15:40:48 -0700 (PDT)
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
 <CAL3q7H538OKkxD93rMZYgiwiZ+4VWwaEw4Nf+o1XDT5OYUeEeA@mail.gmail.com>
 <cb95f89af722c5f57e99d4424c8b31a5155fbdc0.camel@scientia.org>
 <CAL3q7H7_uhKEQbdSQb34mgW1r=Gf0L2ko2=+ocpNRDnm72L_ZA@mail.gmail.com> <9a7a569a1dd5fedcc414bd4ddc60c153f23198ec.camel@scientia.org>
In-Reply-To: <9a7a569a1dd5fedcc414bd4ddc60c153f23198ec.camel@scientia.org>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 21 Oct 2026 23:40:10 +0100
X-Gmail-Original-Message-ID: <CAL3q7H53ivAa5721LdZL6O4maKOrxaZDMc9iD3zWU0p86XzmWg@mail.gmail.com>
X-Gm-Features: AclHuK-cNKYeRZ7iNa5ZKolp6fQo7lGTvCrTndlwZr1WADbl3PRUjtWgyTbYkdc
Message-ID: <CAL3q7H53ivAa5721LdZL6O4maKOrxaZDMc9iD3zWU0p86XzmWg@mail.gmail.com>
Subject: Re: [BUG] incremental send omits hole after trimming the tail of a
 leaf-last file extent item (receiver keeps stale data)
To: Christoph Anton Mitterer <calestyo@scientia.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 11:32=E2=80=AFPM Christoph Anton Mitterer
<calestyo@scientia.org> wrote:
>
> On Wed, 2026-10-21 at 22:49 +0100, Filipe Manana wrote:
> > It depends on what you mean by data corruption.
> > For some applications having a missing hole may cause
> > application-level data corruption or inconsistency.
>
> Oh? I thought this would be just like a when a sparse file is written
> inefficiently and consecutive 0x0 are actually written to storage and
> not punched out.
>
> So I'd have expected that only very unusual stuff could cause breakage,
> like when the software explicitly expects the hole at some point (but
> then doesn't find it) or when the used space on disk is bigger than
> expected... but not when it simply reads.
>
>
>
> > Just compare the version in the received snapshot with the one in the
> > original one - diff, md5sum, etc.
>
> Would this ever report anything? I mean shouldn't file A with the hole
> (which is still read as 0x0) give the same than file B without (where
> the 0x0 are stored on disk)?

Christoph,

If a file range has data instead of a hole, naturally a digest
calculation (md5sum, etc.) will produce different results between the
original snapshot and the received snapshot.
It's not about writing explicit zeroes vs sending a fallocate punch
hole command; it's about not replacing data with zeroes (be it an
actual hole or extents written with zeroes).

If you read the report and the reproducer, or the fstests case I sent,
you will see that.

>
>
> Thanks,
> Chris.
