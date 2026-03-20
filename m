Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5603750BF
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 10:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774001571; cv=none; b=b/j5Iw4uHfSbBdsmp00woiBWQyGzVjMMScnYYjJ8pnIXWyjqIyVgyb/7J6jtCAq2omQxxAuL7abxmG80bOJmaTtWTvaCDbEuMjy29QBHXpCSlgmcUTVEzbQfzxIesMOBRGhujx/2UOPHJmpt4mODCNQ5wmzwHi5uZo0qDFv1My0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774001571; c=relaxed/simple;
	bh=xLOV0bDTqXAHn4fKFFoQLIhgT7ntgBMpl0pN4izaGOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K6xaDAA60Kd/Mc+QAIlM/BV3ef4ckxnyT0Q2uwD29ACfGkLRPl5VmZAMGZd1t5YHSbrtUawfK8UKV5Z+79n4p3JkT0fNw9TzhFqJMPeQVGqwwD9z3aun6gGVIOkbOLTviSn3zNUrv/GdSQvaJksPzv+lEALLwKRABOvHrl1FTU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JPpLkrQW; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JPpLkrQW"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48374014a77so16479735e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 03:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774001566; x=1774606366; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wWSropCexMVQ3GLyuz2NmWVsbmiOZaVPQKQZ9oCLgI0=;
        b=JPpLkrQW4Aca3cENOHJhZr7NAjKaX2vvUvZObWLF4b6UMtUR3mz8cSq1paGB3QI5zc
         8UB0zxZJCs1qYowy82SdDh938R/Cnd2e62lYZTOQNHzB3a47w6/kL2UA71g3+2qDiFgh
         /fMnS3p5iWS85mG4bRpEjZ5RDz8T4mIMutsRzt5qXBTA05AdH1EO/0zlmbYBKovXqmMj
         RVBEpkm2gzk7SZ3a+ecMAL730np2OQ83hzu8ZX9Tbh+kqvy9D148fIwOP64PCDEh8nGQ
         lqO5/9GkgBwdhj7kfhmjdDDAFiO8ZBDaYP/XtRecahzQP0iPGUJv2eGFMsI4XtSj9eMK
         g0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774001566; x=1774606366;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWSropCexMVQ3GLyuz2NmWVsbmiOZaVPQKQZ9oCLgI0=;
        b=HhmRQ5lv4QxS08G3v+op1VZNnsuL/Fd1sUgNkHi2ZZeT3VsmRG5l2BLpeWorAXn8mI
         wvMJr6DXJe3EC0p6Aynl8n7Iz/39nNEnYM37F/l0SfgSSofV8UpUJ2Fcwg7+sUULc5u0
         cnfh0JV45C36tw8gBh3tZVbLWE/HiLQZcSHZusprEs4a3zg5uYwz/vrO/muAKvfvRvhf
         9u+aVQPsfYAUIotTI15WXX815Ua0PO8cel6FjcRCNK/R4DtaCOaA08B09bGDCEoVYzjl
         uFakgqNepXBTpTOvHLbyjJHRDSFJ9/WqETsND7pNqkglBTCQvGbd6nZgzPPvJzjWCkoS
         iEDA==
X-Forwarded-Encrypted: i=1; AJvYcCUTUsiTt4vdIMJbDwXnNIaAHkfiZbPMFFijH2AkyJ/VTiJwGg7o46syPqtrpceAyt3aDNb94ddygnOfSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvCPyFIpDQ9kOp9gU0HGmE1lklI+NCKTuOkgvuK6ROUCT51M2U
	eGQW215Vw05SCnU6eD+48vSG77LKlAyRSKHfs0s7oI55/45We7JZW17b3EV6H2vwOkJqxVfQKBZ
	LNzvIzb4=
X-Gm-Gg: ATEYQzzFACvadSelr3oa9f59o6RINlb1w8MCXBw9LNAvCTkfVw5wFpb9+86NC8sxmkZ
	5EnHQTqhzryaTZi3/Kr+1HpGiNJREnafzaH0perJYgZZWA9xgD8tDWm2LTNuGKJqywD32auNNQl
	uwIsozlhqj4D4mySiXUH6M3rRxsN3SSKWd0xXoBlkGHp1R7jq1Aj1xRAHUVndGHqoPPFruYrbzD
	HefLXXupJ3DvFZvtXAK1NM16MDvMQzX2lqosvcrSXNorey3AsF9WlnaMLLkURwiVGZIJqzg0HDQ
	rSVC8qEzdczrj0tdoXvAfSTmrFTFoHRRpkZtWrUe6PxhOjJ9k7kDk7csAwlbxn2gpVES//NhohJ
	LTfNyv9Ypjgrdck1ZubsfPnYk4AVZAyBzNT3AA4fEH34WwjvaNLYyqlUjGUbr5H4qDZh9r3CbG2
	G2W5cIW2InDj8ks6W4dJfxbAr6sp8ti86SApxTk9H7Ily6PhPR08U=
X-Received: by 2002:a05:600c:8207:b0:485:3ff1:d5c3 with SMTP id 5b1f17b1804b1-486febb449bmr32536125e9.5.1774001566301;
        Fri, 20 Mar 2026 03:12:46 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03aa9619sm1664369b3a.6.2026.03.20.03.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 03:12:45 -0700 (PDT)
Message-ID: <0585bdae-de5b-4aaa-bb0c-4bbe0c2fca89@suse.com>
Date: Fri, 20 Mar 2026 20:42:38 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs: prevent direct reclaim during compressed
 readahead
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, boris@bur.io,
 mark@harmstone.com, clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-team@meta.com
References: <20260320073445.80218-1-jp.kobryn@linux.dev>
 <20260320073445.80218-3-jp.kobryn@linux.dev>
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
In-Reply-To: <20260320073445.80218-3-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/20 18:04, JP Kobryn (Meta) 写道:
> Prevent direct reclaim during compressed readahead. This is achieved by
> passing specific GFP flags whenever the bio is marked for readahead. The
> flags are similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM. Also,
> __GFP_NOWARN is added since these allocations are allowed to fail. Demand
> reads still use full GFP_NOFS and will enter reclaim if needed.

I believe it will be more convincing to explain why the current gfp 
flags is going to cause the problem you mentioned in the cover letter.

> 
> btrfs_submit_compressed_read() now makes use of the new gfp_t API for
> allocations within. Since non-readahead code may call this function, the
> bio flags are inspected to determine whether direct reclaim should be
> restricted or not.
> 
> add_ra_bio_pages() gains a bool parameter which allows callers to specify
> if they want to allow direct reclaim or not. In either case, the NOWARN
> flag was added unconditionally since the allocations are speculative.

After reading the code, I have a feeling that, we shouldn't act on the 
behalf of MM layer to add the next few folios into the page cache.

On the other hand, with the incoming large folios, we will completely 
skip the readahead for large folios.

I know this is not optimal as the next few folios may still belong to 
the same compressed extent and will cause re-read and re-decompression.

Thus I'm wondering, for your specific workload, will disabling 
compressed ra completely and fully rely on large folios help?

If the performance is acceptable, I'd prefer to disable compressed 
readahead completely and rely on large folios instead.

(Now I understand why other fses with compression support is completely 
relying on fixed IO size)

Thanks,
Qu


> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> ---
>   fs/btrfs/compression.c | 33 ++++++++++++++++++++++++++++-----
>   1 file changed, 28 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ae9cb5b7676c..f32cfc933bee 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -372,7 +372,8 @@ struct compressed_bio *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
>   static noinline int add_ra_bio_pages(struct inode *inode,
>   				     u64 compressed_end,
>   				     struct compressed_bio *cb,
> -				     int *memstall, unsigned long *pflags)
> +				     int *memstall, unsigned long *pflags,
> +				     bool direct_reclaim)
>   {
>   	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
>   	pgoff_t end_index;
> @@ -380,6 +381,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>   	u64 cur = cb->orig_bbio->file_offset + orig_bio->bi_iter.bi_size;
>   	u64 isize = i_size_read(inode);
>   	int ret;
> +	gfp_t constraint_gfp, cache_gfp;
>   	struct folio *folio;
>   	struct extent_map *em;
>   	struct address_space *mapping = inode->i_mapping;
> @@ -409,6 +411,14 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>   
>   	end_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
>   
> +	if (!direct_reclaim) {
> +		constraint_gfp = ~(__GFP_FS | __GFP_DIRECT_RECLAIM);
> +		cache_gfp = (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> +	} else {
> +		constraint_gfp = ~__GFP_FS;
> +		cache_gfp = GFP_NOFS | __GFP_NOWARN;
> +	}
> +
>   	while (cur < compressed_end) {
>   		pgoff_t page_end;
>   		pgoff_t pg_index = cur >> PAGE_SHIFT;
> @@ -438,12 +448,13 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>   			continue;
>   		}
>   
> -		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping, ~__GFP_FS),
> +		folio = filemap_alloc_folio(mapping_gfp_constraint(mapping,
> +					    constraint_gfp) | __GFP_NOWARN,
>   					    0, NULL);
>   		if (!folio)
>   			break;
>   
> -		if (filemap_add_folio(mapping, folio, pg_index, GFP_NOFS)) {
> +		if (filemap_add_folio(mapping, folio, pg_index, cache_gfp)) {
>   			/* There is already a page, skip to page end */
>   			cur += folio_size(folio);
>   			folio_put(folio);
> @@ -536,6 +547,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
>   	unsigned int compressed_len;
>   	const u32 min_folio_size = btrfs_min_folio_size(fs_info);
>   	u64 file_offset = bbio->file_offset;
> +	gfp_t gfp;
>   	u64 em_len;
>   	u64 em_start;
>   	struct extent_map *em;
> @@ -543,6 +555,17 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
>   	int memstall = 0;
>   	int ret;
>   
> +	/*
> +	 * If this is a readahead bio, prevent direct reclaim. This is done to
> +	 * avoid stalling on speculative allocations when memory pressure is
> +	 * high. The demand fault will retry with GFP_NOFS and enter direct
> +	 * reclaim if needed.
> +	 */
> +	if (bbio->bio.bi_opf & REQ_RAHEAD)
> +		gfp = (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> +	else
> +		gfp = GFP_NOFS;
> +
>   	/* we need the actual starting offset of this extent in the file */
>   	read_lock(&em_tree->lock);
>   	em = btrfs_lookup_extent_mapping(em_tree, file_offset, fs_info->sectorsize);
> @@ -573,7 +596,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
>   		struct folio *folio;
>   		u32 cur_len = min(compressed_len - i * min_folio_size, min_folio_size);
>   
> -		folio = btrfs_alloc_compr_folio(fs_info);
> +		folio = btrfs_alloc_compr_folio_gfp(fs_info, gfp);
>   		if (!folio) {
>   			ret = -ENOMEM;
>   			goto out_free_bio;
> @@ -589,7 +612,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
>   	ASSERT(cb->bbio.bio.bi_iter.bi_size == compressed_len);
>   
>   	add_ra_bio_pages(&inode->vfs_inode, em_start + em_len, cb, &memstall,
> -			 &pflags);
> +			 &pflags, !(bbio->bio.bi_opf & REQ_RAHEAD));
>   
>   	cb->len = bbio->bio.bi_iter.bi_size;
>   	cb->bbio.bio.bi_iter.bi_sector = bbio->bio.bi_iter.bi_sector;

