Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532D639DBE3;
	Fri, 20 Mar 2026 11:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005292; cv=none; b=I0GlOqeviECKHub+3IvRTgmhTeeaCSPVS5rA+tf7EojOEZyoK7W8ikN/BeyEJ71eXeF9mPuXrjOqn2lo0Fax90arJ4cf92QQ3zQFj8pbf5hbio0n5Ro3wcp4ZwH5kii2b2YR+rlULjOc6Sdp96wQyrJs3qDYwWkylvw0t7/2NKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005292; c=relaxed/simple;
	bh=lUe0AcsrhAVKVgfwuiF2nNAVyDKWVFoqNDeLJLhnvQw=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C+0XR6VWZcnaWcoSb9uusWaZQ6tRu31FMRRCtzpmXOxPBMj/uUjut7VsKvVMWe98OneSUX/EQtEI5KIY4xq7k59369T0mRDNZUGyYaUZtYxNmDtDPoN8CHOYQGy79XfttPGGyqA+h+/e3leEf3WIPdjolA2gAFbcnk7CSv6NcE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=tivsofr9; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="tivsofr9"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id A7D8531255E;
	Fri, 20 Mar 2026 11:14:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774005288;
	bh=q+F9hCW0vBpqwe50d8+VmLKxBJHOAX/VML+Vd8jCgCc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=tivsofr9Mtw0xqbNawzVV03o42XtsX0/TWdVUscghJcVjMBWMKvmtV+Ati6sImtkX
	 7kU5vzFwab/1yMHA6oXcyCiSGYyB5fQO7T1jzAes7n3RjzLqH8MR/VpNfJJNnleQeu
	 Z/flxonIY8/r0Flix/n35oincFaK/V9HfMwrOoGM=
Message-ID: <60096e1c-dad1-474c-808f-f51f09d07117@harmstone.com>
Date: Fri, 20 Mar 2026 11:14:48 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH 2/2] btrfs: prevent direct reclaim during compressed
 readahead
To: Qu Wenruo <wqu@suse.com>, "JP Kobryn (Meta)" <jp.kobryn@linux.dev>,
 boris@bur.io, clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-team@meta.com
References: <20260320073445.80218-1-jp.kobryn@linux.dev>
 <20260320073445.80218-3-jp.kobryn@linux.dev>
 <0585bdae-de5b-4aaa-bb0c-4bbe0c2fca89@suse.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <0585bdae-de5b-4aaa-bb0c-4bbe0c2fca89@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/03/2026 10.12 am, Qu Wenruo wrote:
> 
> 
> 在 2026/3/20 18:04, JP Kobryn (Meta) 写道:
>> Prevent direct reclaim during compressed readahead. This is achieved by
>> passing specific GFP flags whenever the bio is marked for readahead. The
>> flags are similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM. Also,
>> __GFP_NOWARN is added since these allocations are allowed to fail. Demand
>> reads still use full GFP_NOFS and will enter reclaim if needed.
> 
> I believe it will be more convincing to explain why the current gfp 
> flags is going to cause the problem you mentioned in the cover letter.
> 
>>
>> btrfs_submit_compressed_read() now makes use of the new gfp_t API for
>> allocations within. Since non-readahead code may call this function, the
>> bio flags are inspected to determine whether direct reclaim should be
>> restricted or not.
>>
>> add_ra_bio_pages() gains a bool parameter which allows callers to specify
>> if they want to allow direct reclaim or not. In either case, the NOWARN
>> flag was added unconditionally since the allocations are speculative.
> 
> After reading the code, I have a feeling that, we shouldn't act on the 
> behalf of MM layer to add the next few folios into the page cache.

Your idea might have merit, but this is a quick fix for a problem that 
JP has seen in production. Reworking the whole thing might be the 
ultimate solution, but that's much riskier, and will take more testing, 
than the proposed change.

> On the other hand, with the incoming large folios, we will completely 
> skip the readahead for large folios.
> 
> I know this is not optimal as the next few folios may still belong to 
> the same compressed extent and will cause re-read and re-decompression.
> 
> Thus I'm wondering, for your specific workload, will disabling 
> compressed ra completely and fully rely on large folios help?
> 
> If the performance is acceptable, I'd prefer to disable compressed 
> readahead completely and rely on large folios instead.
> 
> (Now I understand why other fses with compression support is completely 
> relying on fixed IO size)
> 
> Thanks,
> Qu
> 
> 
>>
>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
>> ---
>>   fs/btrfs/compression.c | 33 ++++++++++++++++++++++++++++-----
>>   1 file changed, 28 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>> index ae9cb5b7676c..f32cfc933bee 100644
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -372,7 +372,8 @@ struct compressed_bio 
>> *btrfs_alloc_compressed_write(struct btrfs_inode *inode,
>>   static noinline int add_ra_bio_pages(struct inode *inode,
>>                        u64 compressed_end,
>>                        struct compressed_bio *cb,
>> -                     int *memstall, unsigned long *pflags)
>> +                     int *memstall, unsigned long *pflags,
>> +                     bool direct_reclaim)
>>   {
>>       struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
>>       pgoff_t end_index;
>> @@ -380,6 +381,7 @@ static noinline int add_ra_bio_pages(struct inode 
>> *inode,
>>       u64 cur = cb->orig_bbio->file_offset + orig_bio->bi_iter.bi_size;
>>       u64 isize = i_size_read(inode);
>>       int ret;
>> +    gfp_t constraint_gfp, cache_gfp;
>>       struct folio *folio;
>>       struct extent_map *em;
>>       struct address_space *mapping = inode->i_mapping;
>> @@ -409,6 +411,14 @@ static noinline int add_ra_bio_pages(struct inode 
>> *inode,
>>       end_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
>> +    if (!direct_reclaim) {
>> +        constraint_gfp = ~(__GFP_FS | __GFP_DIRECT_RECLAIM);
>> +        cache_gfp = (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
>> +    } else {
>> +        constraint_gfp = ~__GFP_FS;
>> +        cache_gfp = GFP_NOFS | __GFP_NOWARN;
>> +    }
>> +
>>       while (cur < compressed_end) {
>>           pgoff_t page_end;
>>           pgoff_t pg_index = cur >> PAGE_SHIFT;
>> @@ -438,12 +448,13 @@ static noinline int add_ra_bio_pages(struct 
>> inode *inode,
>>               continue;
>>           }
>> -        folio = filemap_alloc_folio(mapping_gfp_constraint(mapping, 
>> ~__GFP_FS),
>> +        folio = filemap_alloc_folio(mapping_gfp_constraint(mapping,
>> +                        constraint_gfp) | __GFP_NOWARN,
>>                           0, NULL);
>>           if (!folio)
>>               break;
>> -        if (filemap_add_folio(mapping, folio, pg_index, GFP_NOFS)) {
>> +        if (filemap_add_folio(mapping, folio, pg_index, cache_gfp)) {
>>               /* There is already a page, skip to page end */
>>               cur += folio_size(folio);
>>               folio_put(folio);
>> @@ -536,6 +547,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio 
>> *bbio)
>>       unsigned int compressed_len;
>>       const u32 min_folio_size = btrfs_min_folio_size(fs_info);
>>       u64 file_offset = bbio->file_offset;
>> +    gfp_t gfp;
>>       u64 em_len;
>>       u64 em_start;
>>       struct extent_map *em;
>> @@ -543,6 +555,17 @@ void btrfs_submit_compressed_read(struct 
>> btrfs_bio *bbio)
>>       int memstall = 0;
>>       int ret;
>> +    /*
>> +     * If this is a readahead bio, prevent direct reclaim. This is 
>> done to
>> +     * avoid stalling on speculative allocations when memory pressure is
>> +     * high. The demand fault will retry with GFP_NOFS and enter direct
>> +     * reclaim if needed.
>> +     */
>> +    if (bbio->bio.bi_opf & REQ_RAHEAD)
>> +        gfp = (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
>> +    else
>> +        gfp = GFP_NOFS;
>> +
>>       /* we need the actual starting offset of this extent in the file */
>>       read_lock(&em_tree->lock);
>>       em = btrfs_lookup_extent_mapping(em_tree, file_offset, fs_info- 
>> >sectorsize);
>> @@ -573,7 +596,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio 
>> *bbio)
>>           struct folio *folio;
>>           u32 cur_len = min(compressed_len - i * min_folio_size, 
>> min_folio_size);
>> -        folio = btrfs_alloc_compr_folio(fs_info);
>> +        folio = btrfs_alloc_compr_folio_gfp(fs_info, gfp);
>>           if (!folio) {
>>               ret = -ENOMEM;
>>               goto out_free_bio;
>> @@ -589,7 +612,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio 
>> *bbio)
>>       ASSERT(cb->bbio.bio.bi_iter.bi_size == compressed_len);
>>       add_ra_bio_pages(&inode->vfs_inode, em_start + em_len, cb, 
>> &memstall,
>> -             &pflags);
>> +             &pflags, !(bbio->bio.bi_opf & REQ_RAHEAD));
>>       cb->len = bbio->bio.bi_iter.bi_size;
>>       cb->bbio.bio.bi_iter.bi_sector = bbio->bio.bi_iter.bi_sector;
> 

