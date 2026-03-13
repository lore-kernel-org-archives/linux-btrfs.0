Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CD937C10B
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 23:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773445785; cv=none; b=K2M1mEnOHzTwBYUeeb36Ug+tJjypawtPIWwOPF67On13F5hy4wCerEDQh6YLufoodlNXs82HIcWvt/BBusW7184yjmgTNUQ+KutV7Yl3l0OXpdkMhu4uUxxsB5cBf2MTDHdFIUVwd47ENIHG2pu1M9EGfbwuwGLIDrh3fNa/qJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773445785; c=relaxed/simple;
	bh=Ug3wEHDhYNRNvcxRpPUXYilANr5OS42G07jtI2lQsF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZDK9xga1cIocqWXD1CKJfbVIxLLwlUOioUdJCWgGeyt5uINOe0z7QMWlhKtsUXaP1U8GZRieF3jCqAS46VhKDuOZGBXPMllqenkASzNyz3xVO1eS8EiR2gAX5Sdqaa26vvIBAjtOlb4gt+Am/oIuQ43yiYBUb9MvDidIYgoH6mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WAeF9i+2; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WAeF9i+2"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48540355459so24105365e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 16:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773445781; x=1774050581; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2+abZk65FMlelhEsZphyR/S+RxRS2Dmb37FzndSoqfw=;
        b=WAeF9i+2m3liEvRYM521y+KjcOePBq4XV99P57P3IKl6AkJforrlYUWuY0r7B5wibr
         OGhkos/Un3UFNun9P0QDPPFDdi32iVsnmvuA4DqbPnvxG9o/XkLn+k3gfbRZivGbSCxl
         Gfjy6QN/1NbFt1uX8eR5B3CPrqwGYK8I10nqVszAnISdKARwLG/YylKcqpjvqnC3KQUT
         mZn+DJ1MmVEsGYM0UUhZRXMmTaUvTkCHFkWvXUYbm6X4Tu7vLBVgSZPQBMQnKL+5lyj6
         mT2Z3t0QV/ExGGdnryWYNOGhIYo/pfXHvv3LkQPZ1Pcv++NVL9Q5oFOgxw4D60sNZkUF
         le3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773445781; x=1774050581;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+abZk65FMlelhEsZphyR/S+RxRS2Dmb37FzndSoqfw=;
        b=fzXutGr3i8RFpG8yB0K4bxu4xNTOy86OWKLfwSYe+T0cgVM+SJsLTihpM5dLAzCbEh
         lGw3NAOdq0Y98iJpM54CpuDUYM1Jei/TaqdI/4fbzJm5wXtqaZXzfcETdH7ABcD3N3qA
         fxinr2fexrgq71a+UB8H7Tshn9rAMEV2y80SjIywHMm0Fd2yJAxuNUL5vaYVdzDcTqoI
         dy91Bvy/wHqKiBupI8b+ND716E1w10yKQWHnlOA58EVQvtFQ6/VEqLt8cOxawfK3JeI/
         NLZmvpJjD47omO3TQJkMsYunfWSEQJ+yGeEx+YpIQkF1nE7CtwgXNIhLQk7kvz0qnDTh
         Ky3A==
X-Gm-Message-State: AOJu0YxSq2Cy/U+N5MijPCts4TBVCUjL3avVN7BHCJjus1KKdfM21la+
	DghdCVFR2hZlb1j4jHJpszEu+gbloeWGiTSsFKNdwm4Bp1dvKS//8zZ0lgSLyIPAReY=
X-Gm-Gg: ATEYQzxy/4TL3N+FgiBv1XCe7xO3q5iVrEPEwUfV3qne2PV4ZHWS6i6De1PxfpRMGc5
	nyMkgJs51LGiOA1xEXsZcwXpCt94PQvyy+mtxnLlpS28+gWV5TLGfGQBt77PBB9cvCv8xhwvKRX
	wKM+dCGP40sGZNKC9PikQvQ3sM4I1rg6dF9v2QmAgFYA3yQczEcx94nKYkUKto6eAsZ0xOsk8Nz
	ZJetrVHHMATggB61rhf0pgIvbKKuXc3YKbXlwEw/c7xfcKlx3cUDbwr4hU0qLDxNavegF7Ft3XU
	ybbQN9fS8JewlbjLn+NUGcfapH1xsYaNXbdTmYOwh3DPJGvs8/Cr5RB8Mu73ZcxDtXvphVoBh2K
	7Bl7MTPWqsc3kq2XJ2UNZTgGOv6NXcUctRcos+5yk+fMDIJhiJ8lvFMYyNgZ12XIKwxmV+mnIhM
	LWrGB/iifsR3mJtoKhWMcXY5Qu7tNErwJ3PB+WIdVYKiQ8+gysnuKEV7mvxMzTZQ==
X-Received: by 2002:a05:600c:4689:b0:485:2fc5:39f with SMTP id 5b1f17b1804b1-48556713b6dmr82954915e9.29.1773445781016;
        Fri, 13 Mar 2026 16:49:41 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73ebb77465sm2561802a12.25.2026.03.13.16.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 16:49:40 -0700 (PDT)
Message-ID: <1c34e37c-9a5c-4063-9e4d-84c797c0daa8@suse.com>
Date: Sat, 14 Mar 2026 10:19:31 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] btrfs: verify cached extent buffers against tree
 parent checks
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260313091924.570554-1-gality369@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
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
In-Reply-To: <20260313091924.570554-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/13 19:49, ZhengYuan Huang 写道:
> This series fixes a btrfs crash caused by reusing a cached extent buffer
> without re-running the caller supplied tree-parent verification.
> 
> The problem happens when a tree block is first read and validated with one
> expected level, then later looked up again through a path that derives a
> different expected level from corrupted metadata. If the extent buffer is
> already marked EXTENT_BUFFER_UPTODATE, the cached-hit path returns it
> without re-validating the supplied btrfs_tree_parent_check. This can allow
> an inconsistent btrfs_root to be constructed and later lead to a
> null-ptr-deref during backref walking.
> 
> Patch 1/2 is a preparatory change that extends
> btrfs_buffer_uptodate() to support tree-parent verification on cached
> buffers. Patch 2/2 uses that support on the cached-hit path and contains
> the actual fix.
> 
> Together, these changes make cache hits and fresh reads follow the same
> tree-parent verification rules, turning the corruption into a read failure
> instead of constructing an inconsistent root object and crashing later.
> 
> For reference, a more detailed analysis of the trigger path is available at:
> https://lore.kernel.org/all/CAOmEq9U14a=pwN_dw2M70gfujhMKki434cfmegoxcyUpkYs5bQ@mail.gmail.com/
> 
> Changes since v1:
>    - drop the adhoc root-specific consistency check in read_tree_root_path()
>    - move the validation into the cached-hit path as suggested by Qu Wenruo
>    - extend btrfs_buffer_uptodate() with an optional tree-parent check
>    - make read_tree_root_path() pass its check when validating a cached root
> 
> ZhengYuan Huang (2):
>    btrfs: add tree parent check to btrfs_buffer_uptodate()
>    btrfs: revalidate cached tree blocks on the uptodate path

The code looks good to me, but considering both patches are small, and 
without the second patch the first one doesn't make much sense.

So I'll merge both into a single patch at merging.

Thanks,
Qu

> 
>   fs/btrfs/ctree.c       |  2 +-
>   fs/btrfs/disk-io.c     | 18 ++++++++++++++----
>   fs/btrfs/disk-io.h     |  3 ++-
>   fs/btrfs/extent-tree.c |  2 +-
>   fs/btrfs/extent_io.c   | 12 ++++++++++--
>   fs/btrfs/tree-log.c    |  2 +-
>   6 files changed, 29 insertions(+), 10 deletions(-)
> 

