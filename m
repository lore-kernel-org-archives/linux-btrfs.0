Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256F13FB048
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Aug 2026 23:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785885296; cv=none; b=Xyi6UYqYf722vHzhfIcH13zZOhD+3TZyDzS4KoRUsYg7aDxXZCnQOOjPQZkU3N/xxrXL/TYCfqbfUzXCJwf9fLr81BQO4dEsIk8hG5jsrXN/N/n6cMxOOpy+YbznRijF1CWg9bHN04grw2ENaAisvItDDIicg2TfAPyApY4Z13c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785885296; c=relaxed/simple;
	bh=hBd3RdRcpdWDMej8R9gqEnTAx/TbgteZ2Rw9RGFLABs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vGE8IvlaHPBkWSXuaKkAn/FIAty6Brz+Q1M13daOs4RY1KpZhh3wKrtGXkqXXkqKDXzvoMIHjmgKZXfXo2ZX10rQyZO3WrHMtbp2+9srBKOuxwcIpka1SBQJndERasaMiqw+W21XUcbuVeyK0NgqDxDjXqPJCUS/PEDlGBNypxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ENge3ARZ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ENge3ARZ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4980dc26022so2709365e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2026 16:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785885292; x=1786490092; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gVO0lbq+F7w1lPsidYYPIHS+lLaDCUZ+ohMwanJ7ycE=;
        b=ENge3ARZN+BKEEQdQYEeJrwO5LJ7XqwRQYhKCSy0KvpvWqZTiAsEuZ/2uz3qvn5xXi
         lWZFmDgLJsFP534nPQjW5YSI/22VV6z8jqReoRV6ne+/rVrvYsUt+cjXsZCppeR7XXq3
         JL6qY68esMcdnSBymJ55ETtGbhbJV309837Ro5mL2fkXTApJyhRWj6SbbS5XHq1yTsqA
         2KJLJRpUOB7DOpuQsF/gj5nt5uANHZ9lXJkrFkxPGHZA+2bS/ZrwcpECIXprBHr/nYna
         SqnSQmTXjL9mbGnlaPVubpOCowQpws8QHe48FsWyh7lBsagOzUNyNwlAlvTb0C6OLyGu
         0mZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785885292; x=1786490092;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gVO0lbq+F7w1lPsidYYPIHS+lLaDCUZ+ohMwanJ7ycE=;
        b=jvqRyi5kHTZwptEKTTaMleNjDk/x9WHmyIFPG3/ffGhEQTXOUHe/QTS7ob6GvI1wsS
         oidm/uAmwUluSfrmyUjkA1CAyMqzyltsdpd86I/XhMVEAzJeKTEPB0Oq1MB9kUX04lTd
         +QPjFX1c38sHRqt3hJkj3od+AHx4tBrjgEx4LSgADb7KgX3RMEI3CoJZg/rUjLDy0nt6
         zwAkJ8LviMfQZmn9kX1OTcF9FoK5sWVXxlsJot0dtBAOJ5VSy9C3Lr99dPwqdsKRCDSZ
         wQuRasc7BMF+Ci3l3bMikG9el5b6l7ni+KcgSicpFcOOv7YrtGUWbr7730AaHMzylTAn
         hgDg==
X-Gm-Message-State: AOJu0YzSHEN6vFHHH6PTEUFfBBcJNdvEgajSsaouI3dpsiuBaFjMGFaj
	PZ52BBmu18QcFS75s2adhdZDG7mnFOkvEn71bOmhM061J8aFbd2AW83GrICKexKsSRc4kg59u8p
	hRElmFz6mRw==
X-Gm-Gg: AR+sD10u2xJ+d0tVK3v7nl6LdohL6CEvvZ3+N4l+3IQAuWjfVVBcbz1d/ow5WRW+1s7
	ayTpeW/mmpV7GGxLF52DUeQSTWUTDMFsHvQXlB6h39ni0OnPQuI7oUux4Tju4vmPxSuBxPua7QW
	Ou40DgxGPTVHpq/m4g5edq52yP2mT5T5Q17s314DZuxQ6UqI0Dsuzrtfl9cJjndue1+nGur/dC+
	RCdANQfVk6CWgMasaQmGORoVpNTUwGi4W2JBdnaIJUJL3GUq/zvmk3f2bOw4KiWgVxdcxIx34TN
	CmR+kEYtER/jiSzg0knotbTq+URhMBu2chf7nHAysdbNzmqH4Y6zWryBUPsdGbnB5pdWdDgEdim
	sch42BwaRG+ibj24a0L65NY+VVHAdtE2BC2NKPpS6ArUnFBZIdIpKoJkkdCNA99V8GXNSuLRJNY
	4GY5leOIzPLf9wBbSyTKUL4gKxhHJWdLne9Nv2P5N0Is22cqv2AsGlEA==
X-Received: by 2002:a05:600c:5686:b0:493:a623:d090 with SMTP id 5b1f17b1804b1-4994e7c60c2mr12748495e9.10.1785885292390;
        Tue, 04 Aug 2026 16:14:52 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867a96e4sm8360255eec.26.2026.08.04.16.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 16:14:51 -0700 (PDT)
Message-ID: <8b16c994-b322-42c9-b134-47dca5f2682e@suse.com>
Date: Wed, 5 Aug 2026 08:44:43 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] btrfs: split btrfs_insert_delayed_dir_index() into
 prealloc and commit phases
To: Jeff Layton <jlayton@kernel.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@fb.com
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
 <20260804-btrfs-enomem-v2-2-4d923170e8c1@kernel.org>
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
In-Reply-To: <20260804-btrfs-enomem-v2-2-4d923170e8c1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/5 01:14, Jeff Layton 写道:
> Split btrfs_insert_delayed_dir_index() into three functions using a new
> btrfs_dir_index_prealloc struct to bundle the pre-allocated resources:
> 
> - btrfs_prealloc_delayed_dir_index(): performs the two GFP_NOFS
>    allocations (delayed node + delayed item) that can fail with -ENOMEM.
> - btrfs_insert_delayed_dir_index_prealloc(): populates the item data,
>    inserts into the rb-tree, and reserves metadata space. Cannot fail
>    with -ENOMEM since all allocations were done in the prealloc step.
> - btrfs_free_delayed_dir_index_prealloc(): frees pre-allocated
>    resources when the caller's btree insertion fails.
> 
> The original btrfs_insert_delayed_dir_index() is refactored into a thin
> wrapper that calls the prealloc and commit functions.
> 
> This split allows callers to move the fallible memory allocations before
> the point of no return (the DIR_ITEM btree insertion), so that -ENOMEM
> can be returned cleanly without aborting the transaction.
> 
> Assisted-by: LLM
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/btrfs/delayed-inode.c | 111 +++++++++++++++++++++++++++++++++++++----------
>   fs/btrfs/delayed-inode.h |  17 ++++++++
>   2 files changed, 104 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index db2ffab0941a..95d2dca80444 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -6,6 +6,7 @@
>   
>   #include <linux/slab.h>
>   #include <linux/iversion.h>
> +#include <linux/error-injection.h>
>   #include "ctree.h"
>   #include "fs.h"
>   #include "messages.h"
> @@ -1469,35 +1470,74 @@ static void btrfs_release_dir_index_item_space(struct btrfs_trans_handle *trans)
>   	trans->bytes_reserved -= bytes;
>   }
>   
> -/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
> -int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
> -				   const char *name, int name_len,
> -				   struct btrfs_inode *dir,
> -				   const struct btrfs_disk_key *disk_key, u8 flags,
> -				   u64 index)
> +/*
> + * Pre-allocate a delayed node and delayed item for a dir index insertion.
> + * Call this before modifying the btree so that ENOMEM can be returned
> + * before any on-disk state has changed.
> + *
> + * Returns 0 on success, -ENOMEM on allocation failure.
> + */
> +int btrfs_prealloc_delayed_dir_index(struct btrfs_inode *dir,
> +				     const char *name, int name_len,
> +				     struct btrfs_dir_index_prealloc *prealloc)

We can directly return a btrfs_dir_index_prealloc pointer, which reduce 
the parameter list.

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
