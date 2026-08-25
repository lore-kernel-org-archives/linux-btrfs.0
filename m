Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA873B42F2
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787686597; cv=pass; b=ERwgECvNbevGTCDPCe6jSphMj8p+7BgX501iOgT1PJNNwQBTYPjVDHSRnXQoTNQ9JzYB7PBMhRKxohTLRY9AAHazIVh2kRobgywyoBouLF+4SVQEhtEuGpFhpzQ24CcI3X3sPCtGpJ734CB1vOXTj0Lvh1QA38DmDnjGWkIjbbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787686597; c=relaxed/simple;
	bh=KOhMryspN38Cmz5uo2I6+8ZxutLOxcy4lygTGmMd/o0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBz+yYSlMlLqkMSBi89kqTsl/U6o0NWaRfYuhux9MzsrTcXEeges1DyXMGDaV17EILZTyDENcn5W1hXxb+nOBNgzYdsF7IBHMPVInEkbNALe5sYAmNm/WBFAbLXK8Mggrri7hT3P++h1G0OZEmoAfxacUTCCSCgTKHH6KWUeWRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tA3h615O; arc=pass smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tA3h615O"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ccdf36f63dso29715ad.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 12:36:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787686595; cv=none;
        d=google.com; s=arc-20260327;
        b=fnMUj5rKr5ujIAEqLd+T0qTNC51MHX23gRDQleY/jSji6YJlyxRMm8czmsUl0ERu3a
         U1XKNPC2qLzKF55IesRvKkg4eIdBofz+ko5xnOfIi0jCMbNhwmkeJrr3ZVh7ljtO5PXN
         Yoc1YHk1Ibyg6eZJtuEr9QIg6R3E1n9lqEsgVtSDOcn7GelJnY/Aug4YYEhsQ4NwPiHD
         jgKfolLC7gPyypV0luhbz6dGbRac4XKD+MeHUaPDSIeMPFvqQsQL5Tw2RjzG5otLlD8O
         j4rkX5iPMBCGt0NQZWR7ply9fYfP55DiefdTMVJthyUwaGbZliKsg6t3iPsO7lPcS91h
         qmAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        fh=H/wVwyimagAD9ASde3sRfvutQeDV5H7sSAmBg/0tPOM=;
        b=c2YI6Rvhtj/AUK2HRj2SjqX9314NHb2fooHMEAQVUbTC/LSP8ZVeCYEIWjTAKKnxmi
         lQJEXY1nILrfUGh7Nq4meuzXt4cF58Y+wSaBHZ2Ni9FNt1pojiVIbQv5qojmdVFWIq5G
         hm5IKZe02/ihgo3ybgj2CgtGL06NWFJt5oYghWCzx35xKUt7Qkbqi8Jw1BlSbdROt+fh
         OxyiIx8fxWX/vZJ3RIVIY08H+/mdmhK/03QMG2k0fkYsHxC/lmmiRYEnAm0hOvHT4mY9
         6nw2lKwgfIOjWFpUratDPy5lDXBzab7H4OHa+IliL/hhfeqbhGupn5AMx+6wqegN3pCJ
         in1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787686595; x=1788291395; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        b=tA3h615OGwycKAHvIXUuZI8JTMBn9AbhoC1rf8jssVE+XWXX6WMQYRhRmzlu2myoe8
         ODTosQrKf4/xSFMnNhhxA/svxIsKdeomjhpZwnwbv6vqvffxDzw5SF1iJ2ttUcr7f6dg
         8I9fGi3KJHO9QHoKqvRpXXAuBRlplZSIr/55EwiTwfRD3A0TbHYsj1egu3Uuw9AQ4Xmt
         aBLge9wmpABnmpo58DVbsm8004x4YnEvn1W+loNHfzqTpjGqzPGnibAjyYwmCPoMPV6r
         6FzgPaOh7s9rX+ipKLtDs1WfQzIOcwMn9i7fqGiNi0JCAkJzLA+TfXmDFV7+3R1ENeh/
         fDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787686595; x=1788291395;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=avJtC2H9j16Vv7kg9X4QNLDoCqhlTskpwP2KPqQ1efI=;
        b=DBR9/ADYyvMCYumPe+KVuM5wR6JNLO7XPPTGDrjZTU/PYW/zsljWaQiy/fIxyaVotC
         yTbF/T1i37woVyut+KQ0JrGkQ1EBqA79Mq6da3OEJhXvKrIPioeYwrqZT6j2W/E/2DeH
         qYc30k7sVxxrNMdQyim/7TtMngYoAm9rurAW0+tqNjKYQki5XGrmQ3KR+/DsYy2BFEgG
         GuKIs6dJeD/fSOVFKvxJW18bY6dOuu3u8mqHULQBoAwCeTnu2zlYgq0cqLH/545q7/5W
         PJ6d8Zupw3mkrJk6sDVIuRxa4SWT/WEgmhC4nTXaMi1hpjDCzYhr4S817lQncrH/1LYy
         Qnnw==
X-Forwarded-Encrypted: i=1; AHgh+RouBJM96ZbX/Bu9M9bk7whv8l2tLpjBq+XJysnPAC6HaGRCJhIKnbrxFFurscJwYoURy9yl0Em1j0+/AQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kf14AIHAEFedPVIAYuGHBl7oYnRn4IjN6elR1khsVb5/fnG9rj
	csUdBpfhynJoZtm3ya+6r3efoEHZCBTCRRGPxHJZlagcNReJUQPd8IuipFEtU2UooUIcdABPhN0
	Ka6vi7SN2xI9r5GaOQVAktHfLK24hOMcXePOYsDJc
X-Gm-Gg: AR+sD13LqDUGk03KmpJuZEUEq79tKrTOfLsG1dB341GT2djLogOtlQnhItEGwIvNxQ0
	L3Din7yx/rWhLvpuiwo9eOBSTMkrHZY1kgnB3//ho6hJ9kVG5ow3v2Y3QQTefqYMi112iI2AzER
	rRKAyy2nxTF6p+HdhD4Thkhl33EhU37z2OPZpT3VzfBwt2vOqQ3yLi4tsM5sK7FT60RCe4pTh9t
	rM5xGgnzHFf6O4ne+sJwGX1Nx7G8hh7rFk1XEojrs5zFzTazv41SQg6ZzgepvM4Zns3xG2vUuOa
	s6Pi/PcNs3z3QutRn5pd4vtZ/jMTNmf5mmPvTleibX846hpfuq5sjtxu0zZlTmAGvdPwWhRzEoL
	16JKVkeHI0ZXfY6Ww14uY8k8b0xmvNg==
X-Received: by 2002:a17:903:1212:b0:2ca:4bb4:4bd with SMTP id
 d9443c01a7336-2d707b56b7emr797585ad.5.1787686594656; Tue, 25 Aug 2026
 12:36:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 21:35:57 +0200
X-Gm-Features: AcwNN1XEivO2VIW62cWvikMmNl_P5W9RRd7WplSlKAdk_NVsBbnZnmYpBAZkAzg
Message-ID: <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 9:08=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and so on=
.
>
> This is not how filesystems want to be informed of folio dirtying.
> It was fine for ext2, but anything that's journalled or COW has work
> to do before the folio is made dirty, and it's hard to do that work
> under the page table spinlock (not all callers hold that lock, but the
> filesystem has to be able to handle the cases where it is.
>
> Filesystems want the page_mkwrite() entry point to be how they find out
> about a folio being dirtied -- and that works great!  Except that we
> can writeback the folio for a number of reasons.  If it's been dirtied
> due to a shared writable mmap, that's fine; we map the folio read-only
> and any subsequent writes will re-enter the page_mkwrite path.
>
> The problem is GUP.  We have no way to force the GUP caller to go
> through page_mkwrite again.  So instead we make the GUP caller call
> folio_mark_dirty_lock() which many just don't, and generally we get away
> with it.  But it's a bug, and a bad interface.

We currently have get_user_pages*() and pin_user_pages*(), where only
the pin_*() version is properly usable for write access, right? And
dropping such pins should always go through unpin_*() helpers?

Could we strictly ban using get_user_pages*() for write access, and
use the unpin_*() helpers to somehow enforce that folios are always
dirtied on unpin? I guess the problem with that is that we have no
state that tracks whether the pin was read-only, and finding free bits
in struct page to keep track of this is hard?

> There's also the problem that GUP users bypass the folio_wait_stable()
> mechanism.  If a page is written to while somebody is creating a
> checksum over that page, the checksum will be corrupted.  If we want
> to fix this, we have to bounce-buffer the page.  There's no way to
> prevent or delay a GUP user from writing to the page.  Enjoy your RAID.
>
> My proposal is this:
>
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.

I don't understand this part of the MM/VFS machinery well - would this
mean that a long-term pin of a dirty pagecache folio could cause an
unbounded number of disk writes in regular intervals, even if nothing
actually writes into the folio? I'm guessing that could be bad for
cheap flash storage, but maybe this is in the category of "yes that
would be bad but it would be userspace's fault".
