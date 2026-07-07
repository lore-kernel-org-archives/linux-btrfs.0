Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7DB4252A2
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 14:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783434807; cv=pass; b=r5JYEBUITs559EN0grQ42ZF8ecm8me0zy8/AmiSVUiSokHxAdIPOSYuy4wpkqwjclc4SUi04BFbhBcQ0wESxivUBE/kDAAYGbGFv9Hl4hA/E9kt+DxPWA3LYXpOjtQWBvehYFaATpzybRbEFd5epvYZRWkqqbPW4xjnHFIsGRew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783434807; c=relaxed/simple;
	bh=xYilDSxOI6do0n6SZKC31MPiyy1EBx+XTChNkNJ4Ayo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YlslIkgKSbT1WS0jvQUrnPAPx9BAlFbA/rzY6YMjQW8ms2tuM9s+gMc+n4M5SW7B6cF0e+KJ1V1sjKTCxaWklIZlJcbE2OGUpPFJ3cV2BCEZvqluxKoUG9UAoL537s/mQiKwP3G6ESZA+VMQhiA2aFl8t3zzAdrg5nBAgNpj8fk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ev2D1lNt; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ev2D1lNt"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so2725628f8f.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 07:33:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783434805; cv=none;
        d=google.com; s=arc-20260327;
        b=BfRClFyYDMwhBsD5JM7oGGvNq5Mkp0LIO1601MRzU59vnaF8CaD3wWK+2MotIDfzrh
         qLR1b0qZHRl0iaD7j7JHqaAOXbR3jZVq2Ky2uiHriOQoYqWKhk7AqmGVz2zPaZc+OUdf
         Bj6GYOZqWZcHwrUAq3Ic2fOgv431pzb5ZHsjOlpAu0ocyV61iuVjaLoKYZJBB9pInG6o
         fZ17L+GpWm91XOaqNPhVJs2ztFw8NfrI1q+/gHc0ue9GaMR4JUBzHHo4l+4cxoUQbt2J
         CPaxJaGiQHVrwo/YiwEWO3gKcPCXNDecN9AajYRlwaFe8Ddg6rkowslGirU2xq4doOQp
         87LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NEyRUcC0eInL1m14heAugAgai/7ecjcR50dungH3ju4=;
        fh=LXrCVi35QSAvcS1NZ3QzMMAoteZsMUPqkIC5It3XAQI=;
        b=XoFWo/HNGE0ha5CpRacnqfEBklv29Z9ci7IWUAOqNzlmVLXUjfS9nYLD/zfcHn4BJl
         LOlbCAnWs9bLzc+0BIU8Tg/zWv9egz9ZDB/GjMqqDuBjXD/tuVkkmwfTGD2VVoSEJv/f
         0/ECkhsk0JAVbi0q9cb4JVH1D5E+7Vd5H1Hd/NIYl0Y0my6LuzIreSrc59YhT6DkIuyp
         SInrGavCvM3SSCmtT99io0Qb85HTnfptdN9ssunRpNXrZr+SnigG83x1hlA3cA2BUS6r
         d7Ip6ZrwlJrPWOjx6USNO4spFjwwwVyh6XvbTtULFlLyW47o4tIRjCDrjcwtsByuKulb
         XlHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783434805; x=1784039605; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NEyRUcC0eInL1m14heAugAgai/7ecjcR50dungH3ju4=;
        b=ev2D1lNtzENVIvhWHnFT6xVDI8kWjyWmpShcqxe96CSgaDwc0KJWgDIODfIj7opaUZ
         KtwcH43HlS3L3qituEtpIcDQv9XlK7KlLBi2UhRZbzPEURWXJsQgycWpFoiOK/oZDNlH
         hbGNJ3hi/ebdsgfN4SihRkq2bLHKT+s8BgLb7lo3kG/qqsAablZF9vYZHJ7np2dUkdtU
         WDvDxB+h+6p0K7NG4Tr2K5UdJHRPc5wMkjLmWY6eALA4j4QGVHWJ7Fa95wAudt5gPxvI
         QMiY9lFfiME2wgjCliXtPD0GE4hLIEm+9iLxyESHMlA4/t5BOKVmss1kYlBZpSBTpEV5
         jkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783434805; x=1784039605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEyRUcC0eInL1m14heAugAgai/7ecjcR50dungH3ju4=;
        b=RPbjRrVuhJYGXJvA3evYzPrX399otVebMl5dI4rCFzblkh2EQ+X6Z1daXr52rELOUu
         /8xHUZOCiwRfh83L8Icc+/E+QjOd1fAr7rWtsYFhM+vqcAwX0WE59XHpT8oEXpaPESkw
         DxMbjywf1mGoNLrcXipCDIsCJg52agDIqAv/miKNdoFdB1cY+aqsBNAxw3wE7nl+t0Pq
         de7V3LdzdN17VL1mN4jCHjW85vyv75j+pbK3ieNXmVpY8gPcyFZctaLml+Ih5g32s+r6
         IOWLgurFf2bpigt3bhsrmKEE3x9gzLAwLCFqyB2Hbiv7LN2iVfZdbC6d3bWvcpAHXowS
         Kv/A==
X-Forwarded-Encrypted: i=1; AHgh+RpW26uUDNu2jD7ck9q6SSYITImiDOva7uTHIT/febNPV5R7EgFASqU9kQrZGjB5yhDLHGhm+lgq6dDC6g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoaXCABMS3R5P2pIe+qEQccTGHJ4EPupe5P3oyiZ+QlgoWebY5
	2gizUwhgH3sw9SvzLitXX24ckxq1RbV1IrsS7yIvZ86WEp/6ivf7jvY42H1+SgWwMca+ayaCGAo
	5XOkoVUi4XxKXxu7y+79P65uVvjFNwzDmqYjVj6lKKw==
X-Gm-Gg: AfdE7cnbmReoO4fWaL25zvj+DGaB6KsrwWcCCikHHmgbCBrqcykyWTOzkGlJkEtjXPE
	i0t06O888g0MpR+1YbgOZ2zhf8nTwI2bUE42Calj0ThJ0kt2Jxj2yboS8YtakMd2uWJam3sbk0F
	Z4N6U/sRyHNDF0oerXNSga8AgYi/9xd6wwvHbpy6/t7PYdvO5Hjqux4hOyoEcqDo6zBjzbTVsfV
	EUiQYcKnkOkejKi+veytYGbPFBb8ajgfDjExUV38Uj1BR5tjXwTIT1LW0Aq+i7Tv4+E8IMZ9Z/C
	5hLhJmP/07Y1kD7BU2FhtvxF1povzMHnem/v820lCesvCOlLaPE+PLlK6EkWQZ+tgY/utQ==
X-Received: by 2002:adf:e5cb:0:b0:46c:cffc:7638 with SMTP id
 ffacd0b85a97d-47de66cde20mr4676602f8f.30.1783434804628; Tue, 07 Jul 2026
 07:33:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707142736.2330146-1-neelx@suse.com>
In-Reply-To: <20260707142736.2330146-1-neelx@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 7 Jul 2026 16:33:13 +0200
X-Gm-Features: AVVi8CeB-MDEZ61D59OuK3R240uy2Wkn9hf6StiihAh_syE3H7rsSsllB5ZZm1U
Message-ID: <CAPjX3Fcqxu_CLJzzHV7qc32+PZF=Wh2hxqfndJGOCSda2H8Z5A@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] btrfs-progs: fscrypt updates
To: David Sterba <dsterba@suse.com>, WenRuo Qu <wqu@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 Jul 2026 at 16:27, Daniel Vacek <neelx@suse.com> wrote:
> This series is a rebase of an older set of fscrypt related changes from
> Sweet Tea Dorminy and Josef Bacik found here:
> https://github.com/josefbacik/btrfs-progs/tree/fscrypt
>
> It passed all my tests. Hopefully nothing blows. Enjoy testing.
>
> v3:
>  * dropped first patch and improved inline extent length checking
>  * correctly squashed the context key definitions into "btrfs-progs: add
>    inode encryption contexts"
>  * inline extents also show the encryption field now in tree dump

And I forgot to explicitly CC Qu as most of these changes are thanks
to his review of v2.

--nX

> v2: https://lore.kernel.org/linux-btrfs/20260624165144.556908-1-neelx@suse.com/
>  * works with v7 of the kernel fscrypt series
>  * the on-disk format changed and parts of the series had to be reworked
>    - particularly the encryption context is now stored as dedicated item
>      and not glued onto extent data item
>  * also parses the ENCRYPT inode item flag
>
> Daniel Vacek (1):
>   btrfs-progs: recognize ENCRYPT inode item flag
>
> Sweet Tea Dorminy (6):
>   btrfs-progs: add new FEATURE_INCOMPAT_ENCRYPT flag
>   btrfs-progs: start tracking extent encryption context info
>   btrfs-progs: add inode encryption contexts
>   btrfs-progs: print encryptin type field of file extents
>   btrfs-progs: handle fscrypt context items
>   btrfs-progs: check: update inline extent length checking
>
>  check/main.c                    | 34 ++++++++++++++++++---------------
>  kernel-shared/ctree.h           |  1 +
>  kernel-shared/print-tree.c      | 28 +++++++++++++++++++++++++--
>  kernel-shared/tree-checker.c    | 17 ++++++++++-------
>  kernel-shared/uapi/btrfs.h      |  1 +
>  kernel-shared/uapi/btrfs_tree.h | 11 +++++++++++
>  libbtrfsutil/btrfs.h            |  1 +
>  7 files changed, 69 insertions(+), 24 deletions(-)
>
> --
> 2.53.0
>
