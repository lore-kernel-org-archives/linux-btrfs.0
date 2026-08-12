Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75777409604
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 23:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786576957; cv=none; b=J1KwLjriC8zVHUVccVJIL33llvHfzUqo2Bl8JNTW3VSg3xNeexORJ9ifHqSTWH0P6Ae5AfejMS6VJ1mQXcgoqMUTNVl+COPjd09caJhsglLx7tg74iF2owJyGHnsh12yLgQDxU65iMGpUsb7o4aeWVqfl+lbxcbjMELo1tmYeG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786576957; c=relaxed/simple;
	bh=yZqyT7zrV2AbREOue7/aoanU7iIRl6HJBpqFrXQpe5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VUiasfvhtlOW/ZZF7D8F91I51gBTNcRME/s0O9VDXwMMshaQWC8BuBRdJDch3oKbO4C7V2UBK2PlGurTkJNWtJxD4GnZqs0eoqJu2D9xMUShjroaizuh5ZpGw0yNL6kz+l6zFPA6h1c3WLorUYRiLMmu91tKTSu2we6XAbiEzhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gOF2MdpN; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gOF2MdpN"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4994c49f588so3524905e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 16:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786576953; x=1787181753; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FfTK390tCylmcmt2r6IRThobn+mZilkOSqi6fOgLqUg=;
        b=gOF2MdpNUDmm3gkW8TwGHG4/z/eYKInaXp7DFzfqTELoM+huoLAI5wuKAeBhj6SB9e
         ii+8vgEOcgEqTFw0EkOHRXkgpCx57g4OUc+PjGbc1AZSmxHHwqvuiTweOwxSAhcYaN7v
         J5GyBLesSs0vJImGYrAJTQTJb9a47jo7cKgSntAiEa8j5XBJd+t5bZJf3hoc3Icot8aS
         0HPZ+WK9BoZxkB6btb9NcBI5Mvybvo3vDcVeALJbGZY7bIeSzMcwuPw2csuWNpCb2EHZ
         PZG5Bx8TOybwpv8Avlot87zetGIjMsDEGbFDbWnZEEbjrb5aEHXM4p17hv+3Dn9EYZGk
         +Czw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786576953; x=1787181753;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FfTK390tCylmcmt2r6IRThobn+mZilkOSqi6fOgLqUg=;
        b=LzAYAX4bpv5CG1XremGlbNGfp0lY0juUO0wG9y/F8vjWKMPcNBnZ6eA9iDHO6JiOgA
         D5rQ3/DiEsO/rITgYdhgHArkS1+FitMNYU/QydL6GPdQmdtWt/tFWBBe2DtpkNluaaEK
         Lz6Yqmd5aeLU2bw0GJc/OEnCFdKZX+ESeartNO6G6qUQYn79gwQA7bbkjnmTy7akUcQl
         cuI3BuWuST6GjQMUCN0b4X5RIwelCpL14FgV0B35Bvb+/YxBHsQgAju+K+cUzJZbiraW
         JXDeQrUYxbPNpUq48X//VGqM/6uPDLpLzyvaU5vIcE7P02/C3vqMR6K5ZSYC8+MYG7wQ
         sjOg==
X-Gm-Message-State: AOJu0YxvyZ7PdlOShlpJpckMfdF3Qldxd3VcIO5V7+6i97v7gKp6od/Y
	9Dr4G8Q/sKfMSM7Jg1Q6JJPhOeCl1vixhTVP2N3vAhqZcbg+wlwUn776+geHms04ab0/3kpXq+D
	O0nbT1CvQhQ==
X-Gm-Gg: AR+sD11W9THwywlW3BU8uUepiOtM4YbrLcTRSqmQeexPEL+5gkG18WgsU+y5WD6azJt
	3t6couu96WY4HwPVMghUHBlxBO/n9Tw3Lam1edRs2lLD2T+9PqnpDmKfYAEs8xayg0sBlt3kYLo
	1nYF2Lx080Hd5CbL3ZYcQ53tIbOcAcAyV7MNWefSzbLic+A4ELUil9c6P7CAJUCO7KK6YSZ3xUE
	9YhRxfjuTfP58rdo/p5heAelb+Z6t8sSVInguQtf+nOXvWq4gwHBxaw5yMDwBqsN0TMX/BVwjUZ
	ilxzP3ErU2QE+s5hVLnAiS/NCj+yOuahQrzk7tjOlmBWVJRkOF3oNWyx1eF2URDLIx9MeqfeNGB
	5gVhAt4cgGu1G/eQ8ENsPtp2/b3D4BslU54HcXTbGGH2X5SQeRzu69pOqwPwvKD9C80Ujyvy3+C
	LtK3ZJN6IZnKs44VGisLIydZMI8rDBsoih6iXhQW565QglxucHYRA7yA==
X-Received: by 2002:a05:600d:8489:10b0:495:7aaf:77b with SMTP id 5b1f17b1804b1-49982107b89mr11064105e9.0.1786576952646;
        Wed, 12 Aug 2026 16:22:32 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebcb6a9a3sm698785eec.12.2026.08.12.16.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 16:22:31 -0700 (PDT)
Message-ID: <1943a03e-5569-4a8b-b008-14211517c805@suse.com>
Date: Thu, 13 Aug 2026 08:52:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] btrfs: handle -ENOMEM errors in some synchronous
 dirops without aborting
To: Jeff Layton <jlayton@kernel.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@fb.com
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
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
In-Reply-To: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/12 03:44, Jeff Layton 写道:
> This version fixes some issues Qu pointed out in review of v2. I did end
> up adopting his suggestion to allocate the prealloc container as well,
> which makes the API cleaner. Original cover letter follows:
> 
> We've had a (relatively small) number of ENOMEM btrfs aborts occur in
> synchronous directory morphing codepaths. It's not terribly common, but
> there are a few places where an memory allocation failure results in an
> abort.
> 
> This patchset reworks the code to do the allocations up front, before the
> point where we'd have to abort the fs if it fails.
> 
> This does not cover all potential cases where this can currently occur:
> 
> In particular, a rename that overwrites the target can still abort the
> fs if a memory allocation fails. Fixing that is substantially more work,
> unfortunately.
> 
> This also doesn't cover orphaning a new inode on failure (which can
> trigger new memory allocations), so this series is designed to work in
> conjunction with with Boris' GFP_NOFAIL series [1].
> 
> AFAICT, these are ancient problems, dating back at least to ~2011. I
> didn't bother adding Fixes: tags.
> 
> AI disclosure: I made heavy use of an LLM in this patchset, from
> drafting the initial series to helping test it.
> 
> [1] https://lore.kernel.org/linux-btrfs/cover.1784673567.git.boris@bur.io/
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changes in v3:
> - btrfs_prealloc_delayed_dir_index() now allocates and returns the
>    btrfs_dir_index_prealloc instead of filling in a caller-provided on-stack
>    struct, so a NULL pointer means "no prealloc" and callers no longer need
>    to use prealloc->item as an is-allocated flag (as suggested by Qu).
> - Fix a leak of a caller-supplied prealloc in btrfs_insert_dir_item() when
>    btrfs_alloc_path() fails; all error exits now go through a single
>    out_free_prealloc label (Qu Wenruo).
> - Move the dir index name memcpy into btrfs_prealloc_delayed_dir_index()
>    instead of duplicating it at the call sites (Qu Wenruo).
> - New patch to use an on-stack path in btrfs_del_orphan_item().
> - btrfs_create_new_inode(): persist nlink=0 with btrfs_update_inode() after
>    orphaning the new inode. Otherwise orphan cleanup sees nlink > 0, drops
>    the orphan item and leaks the inode.
> - Pick up Reviewed-by tags from Qu Wenruo.
> - Link to v2: https://lore.kernel.org/r/20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org
> 
> Changes in v2:
> - Use an on-stack btrfs_path in btrfs_insert_orphan_item() so the ENOMEM
>    recovery does not itself fail on a path allocation.
> - Simplify the recovery in btrfs_create_new_inode() to rely on
>    btrfs_orphan_add()'s internal abort instead of aborting twice.
> - Add ALLOW_ERROR_INJECTION() on btrfs_prealloc_delayed_dir_index() and a
>    new fstest (btrfs/351) to exercise the ENOMEM path.
> - Link to v1: https://lore.kernel.org/r/20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org
> 
> ---
> Jeff Layton (6):
>        btrfs: use an on-stack path in btrfs_insert_orphan_item()
>        btrfs: use an on-stack path in btrfs_del_orphan_item()
>        btrfs: split btrfs_insert_delayed_dir_index() into prealloc and commit phases
>        btrfs: pre-allocate delayed dir index before btree modification
>        btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborting
>        btrfs: pre-allocate delayed dir index for non-overwrite rename
> 
>   fs/btrfs/btrfs_inode.h   |   4 +-
>   fs/btrfs/delayed-inode.c | 115 ++++++++++++++++++++++++++++++++++++-----------
>   fs/btrfs/delayed-inode.h |  22 ++++++---
>   fs/btrfs/dir-item.c      |  42 +++++++++++------
>   fs/btrfs/dir-item.h      |   5 ++-
>   fs/btrfs/inode.c         |  64 +++++++++++++++++++++-----
>   fs/btrfs/orphan.c        |  36 +++++++--------
>   fs/btrfs/transaction.c   |   2 +-
>   fs/btrfs/tree-log.c      |   4 +-
>   9 files changed, 215 insertions(+), 79 deletions(-)
> ---
> base-commit: 76d8783d4c196f4ac990b97ee9f56d2e6797e173
> change-id: 20260715-btrfs-enomem-988f2cc36ffd
> 
> Best regards,

