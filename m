Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E8402BA9
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 22:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756037; cv=none; b=NBOroh2L8zNWenODvFXnGNtNK8tz40M7O8bEdn4P/x/EBWKh4z+0DqH7K+IVmYuGwWtEgZNnaDmEdUGlnfHYuTLt84WDZpon9j/K/TA9FfH0iRDVILUojxITP4nfMVsAHbqJ4aY6gPrPoWBGySkosmQNufEmIz8t2fAqWP9VnCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756037; c=relaxed/simple;
	bh=qvKRHRzDkoph3UQCdp1o9FN4oPV9GtTCQDbYOg2bJr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=COKUTtl2WWmsal9MNxLWG4KZUzKPlBthGEJxlyAnmvxzBcARfaVGpHPnORJdXuBID+mgpFf+iK/xLDuCaY36SCsjyBXDREMjwRiUcnblt3A2kVVxzpqnykvunGIR6P5RYgVdnCTsRaiRQIk9rf+BdnuPREicOpyHqdtiorgO2Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BWBCqmSv; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BWBCqmSv"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c34bff61551so58763066b.2
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 15:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791756034; x=1792360834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CmS1JC2PMqEJQC5Rsqd//EXbuBMhdfqYYZqpjyGwymw=;
        b=BWBCqmSvpwRHS7SZHaGZZe13ZtRxvvje5ZudTuozkAKO+767Ugqc1CtWkfrZgg3hLn
         ElByGW6iyIMu0vqxyepCRlSF86KCPyRshclWfRE2UL4J6dqvKwdks2WwwVyGLNFcYmHC
         qO37JKa2O9dRZ6pykNCFO4NZMP0XY9VcQy15E8qSh2mNyEig8BPXqyQFXODdPIL8Dk8Z
         M+lTIHv5/6JMooAsfdy3KuYLPUG43GzXqa+tbAcsKdkEvJp2XBrp3440R0K6GCNT+dwj
         HYO9dlIE6nRDEon8jf88+vW+ogShHKaOOFB0VLNHzl3fjryZjF3HXTNr9Ybuv/YOhgN/
         g0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791756034; x=1792360834;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CmS1JC2PMqEJQC5Rsqd//EXbuBMhdfqYYZqpjyGwymw=;
        b=0Ae1Ch9PEHyQTQvZSSkXKXokHmB1qkHQplXY92/sRuoA6to8vKSj/1WeFWcYY2Hrr4
         ohoNVN+aKejkSpUesWvtXfY5kL0u0lSgxn20nopAsJJO+5yyrM9b7BqrJwPg8JIJKOU1
         1V0nycY6IOiiM8Ff+1dlLA08g6S4C8dRWmGcpYclxDUMKeaeA8E0c96L/XZ6OOsWBQTn
         cD7WDR+oQPvcndWvk3hA3H2dXEqJ2kOMCZjGOrY2SAq67PrncDtHiSsKlMs2Z4xnSGTn
         2Ebqz3qQiTVyWa5XncEcAt1+AH5o4221kk7mBAQYD9yE+pHsR3inQNqMLeV0RI/CL07Y
         X9YQ==
X-Forwarded-Encrypted: i=1; AKwUvBw6GJqaHPSJkvRJdWs4UhqzHriUoDb/diaOeF+dRm1V3fi9toKmbQrnEvj65s7T3qVnFITt7lheiTPbMA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJYp7NfXQjCoaI2d7S6WBEDCsBKfTmOEaEEGhGjiQlGuD5H4Z5L
	X+gc9VrEZtQRRNz10x8+ETQmJXSkscLB/KbyJznwQJpjIrWkvH7vGh6Ky5jflXBeI+rRfApBvh2
	Fuxs/JD5Blg==
X-Gm-Gg: AYBFou1K1b0512hb/oY1cd2Mhl1G4WXKz0ZScqeuzOVLviIkBjHMp2OIp9Bw/CKnc6U
	4hAd8pg2qiroHulh1AVUBKgxJOPp8PRwtpKz8Hh50/Z2ToyiaTrda5DVE1GNQehTpOqHCSYYq9Y
	dljAfI/24iSDoHZwAXhJ+uuzXeynNLHC3lT38a5nvZhmMzSUjbhHz2Uvne6q+pEgZfASJLRO6F0
	0qERlDCpjKuFeOXWHJFzyww7fH6mAaxC9A0c4MbmcsF6rTsXwlt3aTluMyh0X4XnPjNwY7kKnFL
	6KvZI/rRngcIWqT7JZhC3u6NfiQsQJwse3R5mW3/dWOnudB1VIFP6IPDzSzx33ak6jVkmGR3lcn
	KxzDaklqCJJimzNlueZ8of7JNw26H+t8EJvsEuC+Ldt6fEVnDs1MAAC3y2vaVA4+GKpzM6XTCXH
	3hc9xYxIgfaMpEM/KFy5cM/g47L+vdEJxvdinxWxaxyAHOaw5NgPPctooMykTy2P7NpyBEsD604
	g==
X-Received: by 2002:a17:906:c105:b0:c31:5bb8:4b3b with SMTP id a640c23a62f3a-c31a9a335femr816513766b.2.1791756034480;
        Sun, 11 Oct 2026 15:00:34 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm3186085b3a.40.2026.10.11.15.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 15:00:32 -0700 (PDT)
Message-ID: <2920bc87-3d1e-4bfa-99cc-8b4af37fec5e@suse.com>
Date: Mon, 12 Oct 2026 08:30:26 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: exercise NOCOMPRESS range and EOF handling
To: Dhruva G <goledhruva@gmail.com>, fstests@vger.kernel.org
Cc: Anand Jain <asj@kernel.org>, Filipe Manana <fdmanana@suse.com>,
 Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
 Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <cover.1791395660.git.goledhruva@gmail.com>
 <b99615bd-9b7c-48b6-ac70-d450a606388c@gmail.com>
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
In-Reply-To: <b99615bd-9b7c-48b6-ac70-d450a606388c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/12 06:10, Dhruva G 写道:
> Check that a bounded --nocomp request rewrites compressed extents in the
> selected range while distant untouched regions still point to their
> original compressed storage.
> Cover a partial final sector, zero length, a length extending past EOF,
> start at EOF, and the empty-file no-op. Preserve contents and sizes across
> the conversion and a remount.
> 
> Add shared FIEMAP and integrity helpers for the NOCOMPRESS tests. Require
> full mapping coverage and inspect every overlapping extent so holes and
> partly converted ranges cannot pass. Include a small ioctl helper to
> probe kernel support and check errno without btrfs-progs translation.
> 
> Signed-off-by: Dhruva Gole <goledhruva@gmail.com>
> ---
>   .gitignore                |   1 +
>   common/btrfs_nocomp       | 134 ++++++++++++++++++++++++++++++++++++++
>   src/Makefile              |   2 +-
>   src/btrfs_defrag_nocomp.c |  63 ++++++++++++++++++
>   tests/btrfs/355           |  80 +++++++++++++++++++++++
>   tests/btrfs/355.out       |   2 +
>   6 files changed, 281 insertions(+), 1 deletion(-)
>   create mode 100644 common/btrfs_nocomp
>   create mode 100644 src/btrfs_defrag_nocomp.c
>   create mode 100755 tests/btrfs/355
>   create mode 100644 tests/btrfs/355.out
> 
> diff --git a/.gitignore b/.gitignore
> index 0b6b9452..1bfa12ef 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -216,6 +216,7 @@ tags
>   /src/truncate
>   /src/t_btrfs_received_uuid_ioctl
>   /src/btrfs_ioctl
> +/src/btrfs_defrag_nocomp
>   
>   # Symlinked files
>   /tests/generic/035.out
> diff --git a/common/btrfs_nocomp b/common/btrfs_nocomp
> new file mode 100644
> index 00000000..7e2111e1
> --- /dev/null
> +++ b/common/btrfs_nocomp
> @@ -0,0 +1,134 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) Meta Platforms, Inc. and affiliates.
> +# Helpers for BTRFS_DEFRAG_RANGE_NOCOMPRESS tests.

I don't like a dedicated file just do all those.
Why not put them into common/btrfs?

> +
> +_nc_require()

And "nc" is too generic, _require_btrfs_defrag_nocompress() would make 
more sense.

All the namings here look just some temporary scaffolding, not for 
generic purposes.

> +{
> +	_require_scratch
> +	_require_test_program btrfs_defrag_nocomp
> +	_require_xfs_io_command fiemap ranged
> +	_require_btrfs_command filesystem defragment --nocomp
> +	_require_btrfs_no_nodatacow
> +	_require_btrfs_no_nodatasum
> +	_require_btrfs_no_autodefrag
> +	_require_btrfs_support_sectorsize 4096
> +	_wants_kernel_commit 009b2056cb25 \
> +		"btrfs: defrag: add flag to force no-compression"
> +}
> +
> +_nc_write()
> +{
> +	$XFS_IO_PROG -f -c "pwrite -S $4 -b 128K $2 $3" -c fsync "$1" \
> +		>> "$seqres.full" 2>&1 || _fail "write failed: $1"
> +}
> +
> +_nc_probe()
> +{
> +	local result
> +
> +	_nc_write "$SCRATCH_MNT/probe" 0 131072 0x5a
> +	result=$($here/src/btrfs_defrag_nocomp "$SCRATCH_MNT/probe" 0 131072) ||
> +		_fail "NOCOMPRESS probe failed"

Why we need such dedicated probe program while the kernel is already 
rejecting unknown flags with ENOTTY?

And I think this probing should also be done inside the 
_require_btrfs_defrag_nocompress().

> +	case "$result" in
> +	OK) ;;
> +	EOPNOTSUPP|ENOTTY) _notrun "kernel does not support NOCOMPRESS" ;;
> +	*) _fail "unexpected NOCOMPRESS probe result: $result" ;;
> +	esac
> +	rm -f "$SCRATCH_MNT/probe"
> +}
> +
> +_nc_defrag()
> +{
> +	local file="${@: -1}"
> +
> +	$BTRFS_UTIL_PROG filesystem defragment --nocomp "$@" \
> +		>> "$seqres.full" 2>&1 || _fail "NOCOMPRESS defrag failed"
> +	$XFS_IO_PROG -c fsync "$file" >> "$seqres.full" 2>&1 ||
> +		_fail "fsync after defrag failed"
> +}
> +
> +_nc_map()
> +{
> +	$XFS_IO_PROG -c "fiemap -v $2 $3" "$1" > "$tmp.nc-map" \
> +		2>> "$seqres.full" || _fail "fiemap failed: $1"
> +	cat "$tmp.nc-map" >> "$seqres.full"
> +}
> +
> +# FIEMAP prints logical offsets in 512-byte units. Check every overlapping
> +# extent and complete coverage, so a hole or a partly converted range fails.
> +# The caller supplies byte offsets and lengths, including a partial EOF sector.
> +_nc_check_range()

This looks a little overkilled to me.

For regular hole/compression flags, what about filtering out the 
non-hole logical bytenr (e.g. replace them with 'XXX' or 'regular'), 
then output to the stdout, and use golden output to verify?
