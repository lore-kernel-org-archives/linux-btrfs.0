Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3B154DACE
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 21:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792098357; cv=none; b=AMirVoG7s0NBj7IBzL46UieYUPSTmW8kOmOi2cF8Bi80SCm99n0SDaWSgEUyh3tw+06cDzHXnMKa5BbvT0zShPDAW/HXjW5q/vUVOjL3k0py1MDwZcoleFfESKAgI6EVawYVkfaxyWSCtHjGnt7rEeIt57qU5dWrDCBAK1kVrfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792098357; c=relaxed/simple;
	bh=cONfY7w2Dk9OBGkMd9K2vIwaZOIDmAddVxzZEqjWrkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rJZaI4djXhYZ2zQw6lRJQMfRLEHZoGyKGSW4uaoR/LVSaVr459EQ1TpzhkkonI+gfGTCApfR6r1kSbJ1i7kQXI7cFP6FG82jFBFGFwv3BbCQGR14me77NS42olYW7Eojg39nn3Bv2T7iU9sQuwATtuyBackgbthTYY5lrypAAXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y0x6PSU5; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y0x6PSU5"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so36193585e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792098353; x=1792703153; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9KV4G5n8tJMBWtFYRFxeM0Py/sTYPBjkRIbDZjbDEM4=;
        b=Y0x6PSU5r/2nOu/3+luwMmEX0eiJaS0YWpPbrFcKCHCguXqWKtcOjr801qjKu0QUuJ
         FPjcfarjPtcWip2uEziWT2YnY9rZfD528+GVkLwaPnIQ/A5+0h0pz43fEalsVQLEDobg
         o9nWI0iNNIth2KlTuq1IqHmbyIEwXin4d4TivgKfAwscVbO0LXdE/IzFwlzl3zBMBTf/
         5vLYWddtJvZxJtEEnKqJS2zVhjKL3hFz6pqYjNEJAqOSQ7aAF7hZMadEWXLTqp7sTApe
         sryseCbzXcyAKVuOazbvTItL/XJVP71hGcEDBPXdhl+c2w9kiYf9XHd/QD+7vMqlsl6q
         WoJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792098353; x=1792703153;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9KV4G5n8tJMBWtFYRFxeM0Py/sTYPBjkRIbDZjbDEM4=;
        b=esE4/EJNFYW+nqXvOeHs4nzc2jj99TYuCJdENWcPy5oGTRw8vdCv3rQNbTgsmQWCvb
         FxlwntyucYuszMu9UDSD+2v/stZfoUxzDNFPOful1lhQ8ao7XrNcBGvHdRCS/3FsSSem
         W9xuTaNnjjf/IrXvm+EftWWlprBSj2z7aSVcDUANiE+FaTLnZZZIEc23xmBzo4ZSXwnM
         t8o1NyD7jKZfdTTW6l3MXFwNLHtQDnkLLU81J5VUZoA72G1+tkbyGhULc7h4lqoCLj8i
         7HN+KammjpXnJ3DM/7kovU6WyelnBPmbnX2fD0E3x/nQqjEICdDIBtqILqqWhVlhUGoZ
         k5yA==
X-Forwarded-Encrypted: i=1; AKwUvBwxAlrCECa1/jVef3ydglUw51gwcoUrH+54JYry2/uQVplbpo7e/sksuKbvn7JU0thmMWs2B8KAIO6tmA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIfYLok21sC+m4HKRM/xoJnnNbswC3BCzKliyzPN3mXBrgf6+Vx
	hnwt74Dl+QR3t/z7kBFMa7jsaykQnmlQwbeAlzNV+ne+564WDNVVqYlQ9kyWeyLSfekQ+1OIDGD
	CrLbRtjoKoQ==
X-Gm-Gg: AYBFou01fn5r1XuMVDhl3RkEYP9qz/VLS/fzd8AgyJZXU3R2RHTukxJU+VlqxJo7NyM
	pQwMQvXkH4za0CvgO31YlzgPm2KFWRz/j/dAFoTRjfHD8fE3FsbJSnu3HZOJx48Vsa+KoTDF0er
	bDzTnYXYzH31MHltgWIAUfIHJhOEuyqixL2Vc814XozBdQDQ6bbR7z0lMkIAYHSn3rbHRLBtadH
	5oSJ9I5l/j0v3RNi3ZIGUq3wUxTPZwtcxDSb3RzfCfOIFfwNn5Y9CCKn8F5UiPc1eADi1peUW8i
	gUJhLtqUURIo2wJ+0hI9O+1QdNozk96Q9z/z1PVQC1isnARI/LF5wPH410Yml+NSgkhZJwMsIay
	bq0FW/iguNXbtuvMTDtneJDd5Ey337dlsVN8XtTcz6tTgbMgzx+OxM8+cW7yDC8TPmP8iSgdW8E
	+7zeqneSnxgJh/O3dTgmUNG4y6pNgYtIMH8qZsVZmLqoO3liscY1/9zkn8bAw3eMg=
X-Received: by 2002:a05:600c:8b09:b0:49c:c0d4:53d9 with SMTP id 5b1f17b1804b1-4a18e4a95b7mr440310795e9.14.1792098353034;
        Thu, 15 Oct 2026 14:05:53 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acca125a46sm153142a91.3.2026.10.15.14.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 14:05:51 -0700 (PDT)
Message-ID: <f961af77-5fc2-47ad-a8f8-be2ef2218d07@suse.com>
Date: Fri, 16 Oct 2026 07:35:47 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix fiemap merging compressed extents
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <79aa555b1433ac7bdfd9dd17e30a306a066ac762.1792077285.git.fdmanana@suse.com>
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
In-Reply-To: <79aa555b1433ac7bdfd9dd17e30a306a066ac762.1792077285.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/16 01:45, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Compressed extents are never supposed to be merged by the fiemap code and
> reported as a single extent, as each extent's content comes from a
> different compression stream and has its own header and context.
> 
> We currently rely on checking the logical and physical address adjacency
> to prevent merging compressed extents but that is broken. Consider the
> following reproducer which explains why the merging happens:
> 
>    $ cat test.sh
>    #!/bin/bash
> 
>    DEV=/dev/sdi
>    MNT=/mnt/sdi
> 
>    mkfs.btrfs -s 4K -f $DEV
>    mount -o compress $DEV $MNT
> 
>    # Do a write that compresses to a single 4K extent and represents the
>    # maximum compressed chunk size (128K).
>    xfs_io -f -c "pwrite 0 128K" $MNT/foo
> 
>    # Sync to flush delalloc and allocate the 4K extent.
>    sync -f $MNT
> 
>    # Now allocate a 124K extent in some other file, which will be adjacent
>    # (to the right) of the 4K extent previously allocated.
>    xfs_io -f -c "falloc 0 124K" $MNT/filler
> 
>    # Do another write to the main file at its current EOF that is
>    # compressible and fits in a 4K extent.
>    xfs_io -c "pwrite 128K 128K" $MNT/foo
>    # Sync to flush delalloc and allocate the 4K extent.
>    sync -f $MNT
> 
>    # Run fiemap which should report 2 encoded extents, each with a
>    # logical size of 128K.
>    xfs_io -c "fiemap -v" $MNT/foo
> 
>    umount $MNT
> 
> Running this, fiemap will report a single extent:
> 
>    $ ./test.sh
>    (...)
>    /mnt/sdi/foo:
>     EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>       0: [0..511]:        26624..27135       512   0x9
> 
> Fix this by never attempting to merge extents if the flags contain
> FIEMAP_EXTENT_ENCODED.
> 
> Fixes: 4751832da990 ("btrfs: fiemap: Cache and merge fiemap extent before submit it to user")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/fiemap.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
> index 7a2a97180099..817171028413 100644
> --- a/fs/btrfs/fiemap.c
> +++ b/fs/btrfs/fiemap.c
> @@ -228,7 +228,8 @@ static int emit_fiemap_extent(struct fiemap_extent_info *fieinfo,
>   	 *
>   	 * 3) Share same flags
>   	 */
> -	if (cache->offset + cache->len  == offset &&
> +	if (!(flags & FIEMAP_EXTENT_ENCODED) &&
> +	    cache->offset + cache->len == offset &&
>   	    cache->phys + cache->len == phys  &&
>   	    cache->flags == flags) {
>   		cache->len += len;

