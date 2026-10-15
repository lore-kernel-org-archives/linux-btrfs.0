Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A083E9C08
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 21:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792098595; cv=none; b=CCmxfOXoa5BM1ouqAvoDmF082kVrVJGAa16dS+9mA0REIWO4t5rdw2dAVY4JAnayZjcZ2wpScTa9+WNejWhHwOeFkfNqB2+m3z0axU3aUJTGsmFJXT3h7s1yl5oPueDEulfypvKgXQS0p9ss1lTw8irGvoziy0cBM2GrD8czwMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792098595; c=relaxed/simple;
	bh=K+mkkYvEdMzx8jwAQDC1stA5w6bGt1j/ga05vKOFcxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s4CXQ7UTQeaUkwnSbOIgPLQIeK4CB4cGWULcxkEMEH0TuZ80atZ8pcKM3b/gtyM5QQYnXInyM7ZvDpr9GBDzADqbI6VzE0XLgIFSQi8Eyu8hKD/4Nsr26rvyJwAmtRLHaVodXmtixi8rHcBcr/VabTG+iVJ/b5lJTq5GF+0AsHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Gx3v4OUD; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Gx3v4OUD"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1ad2e2391so25654535e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792098589; x=1792703389; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68BOcddZL2NMOKM0FEt+ujFOu0/Ai8Do5blcAevTB4M=;
        b=Gx3v4OUD0TaAR/w1EqQd5zX0Gt3WwKlqcbV6WEWS5O7kpASZAzjuM6kepDhDL5XdhJ
         nuwoCG+y78It6dDqUvfbGbaqcnfMq+qvDspwKqZYVUBaluqqtbI939x9VfWg8Zt1MZVK
         YquWWgp9vBeaCqzmGuJK3JqY8mn/c84W+Pt8YBv3q8wSZz2uHYudAdj2L0iMSaP69tvo
         2C7X5fE3NIOAUrbhXFhhBBRfEwRIoJDlh0JSYwo5u1C357r7Ewa/AWjGkncbLRfGSpsR
         jWmoszBqGbOARlL84M6ZuUBIj3Pxw1hQ9KiGY+3cGyqGw6zkk/lVykm7TPDUbeAraSG1
         rEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792098589; x=1792703389;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=68BOcddZL2NMOKM0FEt+ujFOu0/Ai8Do5blcAevTB4M=;
        b=wW4sSSs9AjQndsiQ4gKi0jxjzgaPIqxOZ54NF5epFoTWCsBNoQPHPFC870PE9BRHyh
         znOTxi5xheaErnudyOFhIMr8aJqdvn+r9eHyRN8/vqV7ldprc0i8qQu9FLOlvetCA8Ys
         3BC2Z4M/6nLbpTXs9t01yIBp1ms9mBBCzToqVUre4aBTC/Kb8jKKURx7G3DTgVjowDPM
         ypd5pUd0pMGvZmn402xP1mAybA1kZoBFBLKkqPh9ErI/MoVKjL+n2mc04q8ejj0p1a8W
         OjkPFEOsbHZDGlXK7cUO/Jrws+PWtscajH/3Wr4ds9J62TmhlxkRuuNRM47VUKGb7wpF
         jLdw==
X-Gm-Message-State: AFq9FYLBnvnEU9mED4h1JaWPxDb3G9PphZhqWCn3sp2InLyAKwX3cI8r
	+yTDNrHcXuMarZIjQfGAuJpJwaQb80omi3KgGSlMd8tx6WWhdCR/B0l8vwmUd1Qd+N8=
X-Gm-Gg: AYBFou25uJxdk3KsOjD1uLaaLWNOUi9q65KbLZ5f0g+TCfh030kQSPXd096QRBNUsKL
	67kUN1AdDxxXnujTCeA9C6GIl/3ifQTWKauptNDpGzz3x2UrbwTGspoiZ8T+bEGRQQ3l0Me6xJl
	6xG/SmZStYFfTlLTjsCOKo1AAqNc/7UHjgA7W6IdxRMY8zT8qRT3gWaV3E5V3mDkeHnQsLSQUj0
	O0YrKtlpX8UNvVDu8WukOc4hWBQHXc/59BA0y9ie1P0nF3vOW2ih6epJBXWyb5TSpYSDXRouTRT
	DVsObPRvItxD1QVKrf0tH/ou24uHR0aqK50OUpZ+UX+Qaqyg6NiKKGmRxwJJRJRmLwuwiLgeBmT
	HDP2Bkt3eg4vyFaKzrhEEhj/s0iKv8EdjQq/BPYNuR5SX8oCSKCVGLD9z5vJlURy1UA2PKQZ7j0
	XN9zAJJuNB274Mq6SxYTv2BL9A0J3xH8S7bxgqCeJdUBDLFU47oLFQs17TACoItFDy+GIcoZrN8
	A==
X-Received: by 2002:a05:600c:4689:b0:4a0:1cfd:321 with SMTP id 5b1f17b1804b1-4a18e4a9b31mr436383485e9.12.1792098589066;
        Thu, 15 Oct 2026 14:09:49 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc98139ccsm180034a91.0.2026.10.15.14.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 14:09:47 -0700 (PDT)
Message-ID: <a8f56485-f2c1-40d0-96e5-b858b693984f@suse.com>
Date: Fri, 16 Oct 2026 07:39:40 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: test fiemap does not merge compressed extents
To: fdmanana@kernel.org, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
References: <5b73c7dc792763acc71d3f4286bccc473114fca3.1792077449.git.fdmanana@suse.com>
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
In-Reply-To: <5b73c7dc792763acc71d3f4286bccc473114fca3.1792077449.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/16 01:51, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that fiemap does not report logically adjacent compressed extents
> as a single extent.
> 
> This is a reproducer for a bug that is fixed by the following kernel
> patch:
> 
>    "btrfs: fix fiemap merging compressed extents"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   tests/btrfs/361     | 50 +++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/361.out |  8 ++++++++
>   2 files changed, 58 insertions(+)
>   create mode 100755 tests/btrfs/361
>   create mode 100644 tests/btrfs/361.out
> 
> diff --git a/tests/btrfs/361 b/tests/btrfs/361
> new file mode 100755
> index 00000000..96eff971
> --- /dev/null
> +++ b/tests/btrfs/361
> @@ -0,0 +1,50 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 SUSE S.A.  All Rights Reserved.
> +#
> +# FS QA Test 361
> +#
> +# Test that fiemap does not report logically adjacent compressed extents as a
> +# single extent.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick compress fiemap
> +
> +. ./common/filter
> +. ./common/punch # for _filter_fiemap_flags
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: fix fiemap merging compressed extents"
> +
> +_require_btrfs_support_sectorsize 4096
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "fiemap"
> +_require_scratch
> +
> +_scratch_mkfs -s 4K >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount "-o compress"
> +
> +# Do a write that compresses to a single 4K extent and represents the maximum
> +# compressed chunk size (128K).
> +$XFS_IO_PROG -f -c "pwrite 0 128K" $SCRATCH_MNT/foo | _filter_xfs_io
> +
> +# Sync to flush delalloc and allocate the 4K extent.
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
> +
> +# Now allocate a 124K extent in some other file, which will be adjacent (to the
> +# right) of the 4K extent previously allocated.
> +$XFS_IO_PROG -f -c "falloc 0 124K" $SCRATCH_MNT/filler
> +
> +# Do another write to the main file at its current EOF that is compressible and
> +# fits in a 4K extent.
> +$XFS_IO_PROG -c "pwrite 128K 128K" $SCRATCH_MNT/foo | _filter_xfs_io
> +
> +# Sync to flush delalloc and allocate the 4K extent.
> +$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
> +
> +# Run fiemap which should report 2 encoded extents, each with a logical size
> +# of 128K.
> +echo "Fiemap output:"
> +$XFS_IO_PROG -c "fiemap -v" $SCRATCH_MNT/foo | _filter_fiemap_flags 1
> +
> +_exit 0
> diff --git a/tests/btrfs/361.out b/tests/btrfs/361.out
> new file mode 100644
> index 00000000..b09afa3d
> --- /dev/null
> +++ b/tests/btrfs/361.out
> @@ -0,0 +1,8 @@
> +QA output created by 361
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 131072
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Fiemap output:
> +0: [0..255]: encoded
> +1: [256..511]: encoded|last

