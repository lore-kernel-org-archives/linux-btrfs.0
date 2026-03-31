Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C314657E2
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 21:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774994113; cv=pass; b=KUzxqvhVf08wb2zYv/Ofy93lOJySSENwKQKLsAVMe9JBON/OP95J6fIYRLdbBIruDY+XnLkiv8hm3ViM8+caeuuu2ZNAyi0LjYd7n+xthb5g/34gc8vucislHGJs2XMloBb4u/xstRI1QJ0lDgaGiZ3ajYYuZg0K1iVSXV2WIII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774994113; c=relaxed/simple;
	bh=O2GC0U5w7FXXHMCo7rTX1avQBZaBE7cU1bFhWAr6QAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uz3V0oH++B/iKQMeeArlkHKEA6/f0ZOBdg22dUsvgtKDlF4OPxF2NNBpgDPBmn6qMzp8J6sp+XR9gu2nR+Ondx/cHXrRrL8sOM2DQekuB/+ZXskklLQUR3JIOJuzbAEUNtnEo/o9HM5xpSWW8XH2BDlkXOI03dmeTxYDO5ecNbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com; spf=pass smtp.mailfrom=vietors.com; dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b=EQkc+JnC; arc=pass smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=vietors.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vietors.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vietors.com header.i=@vietors.com header.b="EQkc+JnC"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79652789a0cso2920807b3.3
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 14:55:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774994110; cv=none;
        d=google.com; s=arc-20240605;
        b=OXAH+Wb545ccthtceH1DdjxhfCI1KGG8HYJfln07sPC4KpEsacPCGSymK0pcSjRiu/
         cdONKn8UIx7bceHsRy6GFgm9wy/6LA3tSiIUfSM9tX+vUQG0IFr1SmxGmn9H4/7arece
         U+eEyvSW8rKF5X7JZNdbQkX3x/jBJtWDOajNwJtSqnQObKgCKqZqAA9h3yLTrtzoPnSr
         P7lOlmP43YJe4WLJ7RcZmyXzUfc+l3HNZHHw2Qo1Gw2bIdl9AunjL1/Pt1nNEZPiHTab
         BpT/g8SSakRguklw5MUwfyqjZu6RJxGHmkvLM4KjQAzmixlA+Yzo8iPJvinHNkVoTPry
         CSrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dd2RO98BN6whGUug11U0YwyWzS2FOKBGpJdbVt5w9H0=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=ERr/3z6qelOG/ZcMBQgSfGHqQJW4LMQmBSKGb5ks0q55nwNFH2cw2h4oder+wXZ1u6
         IdR8R4Fq9VYi19ZROisCktwQ/Adu9BrL31KbqehG4GCO8gzJpxCxj7vP+yvHFyTctY1s
         Uv2+ZPluPs1vSnY+1NfpKSpPnvV4i2pGDcvuIkASmAEodInfX8fIs1GbYXDqLsAbLW6a
         tfhm/FQO9grdg0gPr4oVM9UY3sozy00aajU1Cg23rsK49jjQF0f/JXD3t3yCszAlwSmu
         oWMGQLQwnTyl9KTKuXmyFv8ed9F0hYMvrGwhmbJlL6YFHZDlpmDJepsHR4MZXRp+BJdM
         LNqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vietors.com; s=google; t=1774994110; x=1775598910; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dd2RO98BN6whGUug11U0YwyWzS2FOKBGpJdbVt5w9H0=;
        b=EQkc+JnCtHgd7YNl2KrDtV5+8rl2BMAcZSiVJY++y5/SpqxQqFlrRx8jnYdEqqMTQQ
         oRs5cDjwqBsYgflwH+Nd2QcwrAL0L/IbBQqWEfoBDZJ3vud0RQk5oEvkF7ioz5uZCV3B
         pHvY4aIZ2eEfRid9ICVxDYiJLh5vFdN8r4kVsAWf5u4iM+exDdWfW0D+IjgwCLj+yb4K
         uan1tXnDPt1Q41dhJHiKlxeLMr+kIX8K2+qPg5MU2VwTQa+bdeejkN11CohNJ9Lr3FqH
         FO11Ei92f2CAPvtB8TzqwuM6538cb1L+9Vak1yQ6IlNhhHsVt3fT7HmZ2U5MCLaMDGQ7
         czVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774994110; x=1775598910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dd2RO98BN6whGUug11U0YwyWzS2FOKBGpJdbVt5w9H0=;
        b=Z7Ctdv7jeUNCqwC4fObbvcLe6c+wr3Qy0bjI7+2oI/V3QpAbq7byHI3K0Rx+JIKhl+
         pB/jOvKTc8s5tv3en5Zbgi3MZJA+/m0orQN+B2KwT78vB/Cdyo2Mdujk3fZqe5EW3fPU
         jrJeRgV5EjNa4xLjp2Jjd0BPTgNzLgqrEnceMAzP4L0PHqDuRmoCJwdIMnGVo7kdbbWt
         md8nPeIli7swTVmmni431z3qGcc9kqN0uAFl3336h/8hiPpTOxLJBkAof6T+zGqTNcD3
         4Qrwq1+GwSkfim2zAvqWBlpMLMhCG8FSDelA0BnrmtfBVG8ZFDGFlhS3maBUMFSxk73R
         s1LQ==
X-Gm-Message-State: AOJu0Yy6saJLVqiyuQ+uNJdifvhPhV2iSVvWUL9rguAtqjLMAdRI1fhY
	RgZrrThWShrfIibGV0voOwbbcvHTjWpm2/9GxCQ4ohOX6IU/Ld8TrDPQr2akJGnC9PWSslT/7Gm
	/ONvhyNKtCOSQpWL4DXaJaqWe21uKnni244HaUxCAlUEHQJ8junj1nI0=
X-Gm-Gg: ATEYQzyLgKJpOXg2ytbqxPqXPHQxhD299WxQgFMXNRx2/vi2CT4I6Cg4H8tDRe4mAoA
	yRmnOAixK4gdKj5Zj44K0DdbW82IDvUGU2TQL1ETXtjy9uX9eH8LOqesaBEIMFoVcmTE4C1178R
	NhGnuHnoTns/N9VSIUdLWcPtt+U1sMw5WGVWzex7iU6ISZO0D+z9JOrGwR6/b2fjgMvnHfNEguD
	BMCChNOucPmYGN/CW0BZ29j7sE+vsQCvVNG9a0MRsllEXBYE3odbTL0LJLWQ2jdu6eNHJU9uiXl
	91Tg54BRU9k9qvQPp/9DBZWdvKZvFAyXadu4rQ==
X-Received: by 2002:a05:690c:6ac4:b0:79f:57f3:2843 with SMTP id
 00721157ae682-7a212b26c62mr9170767b3.8.1774994110599; Tue, 31 Mar 2026
 14:55:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
 <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com> <CAF1bhLWJuHjf8e-4o9y-hhFqadpQ=13P-PZSJLem5Q_A2T-CTw@mail.gmail.com>
 <d470a043-72c0-4124-800c-385c19007b9e@suse.com>
In-Reply-To: <d470a043-72c0-4124-800c-385c19007b9e@suse.com>
From: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
Date: Tue, 31 Mar 2026 23:54:59 +0200
X-Gm-Features: AQROBzDwed6cRPPbmYmCv0chQKXMVZHu6hV-hLaMa02wzE0MFmbzH4o9lsMZH4o
Message-ID: <CAF1bhLVahaWzAk3xXLdDSgacHjnMZLutbcP05zuxfTc3JuK-4Q@mail.gmail.com>
Subject: Re: Problem mounting 4-drive RAID1 fs after replace was interrupted
 by kernel crash
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2026 at 11:31=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/4/1 07:53, Jaron Vi=C3=ABtor =E5=86=99=E9=81=93:
> > On Tue, Mar 31, 2026 at 11:14=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote=
:
> [...]
> >>
> >> Kernel version please.
> >>
> >> And with all devices (including the new and failing disks), and "btrfs
> >> dev scan", the mount still fails with the same message?
> >>
> >> If so, mount with "degraded" mount option, and try to cancel the
> >> replacement, then try again.
> >
> > Thanks for your reply!
> > This is on kernel 6.19.10, the problem (and start of the replace
> > operation) was originally started on kernel 6.18.2 - I updated in
> > hopes that would fix things, but it made no difference.
> > Yes, with all drives the mount fails with the same message. Attempting
> > to mount degraded (or ro,degraded) also gives the exact same message
> > as well, so I have no way to cancel the replacement (that I know of).
>
> Then please provide the following dump, just use any device is fine
> (maybe except the replace target/source device):
>
>   # btrfs ins dump-tree -t root <device>
>
> Then the following dump for each device, including the target and source
> device:
>
>   # btrfs ins dump-super -f <device>
>

I've uploaded the dumps here:
https://transfer.ddvtech.com/obowqfcDsl/dumps.tar.gz
/dev/sdh is the failing drive, /dev/sdk is the replacement drive.

> I still remember I handled a similar bug before, which seems to be a
> bitflip in the devid.
>
> And just in case, please also run a memtest to rule out any hardware
> memory problems.
> You won't believe how frequent such problems are observed, especially if
> your NUC is running DDR4 memory.

Ok, I'll run a memtest overnight just in case.
Though I should note this system had been running for several months
with no observed problems, so it's -probably- not bad memory.

>
> Thanks,
> Qu
>
> >
> > Kind regards,
> > Jaron
> >
> >>
> >> Thanks,
> >> Q
