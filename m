Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ABC3BE635
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 22:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788215251; cv=none; b=beTQ2Bx/zXpVTFuow5UK6QqWpHpzC7fmMg68ESWptO+IzcqqXSbm8ixckvuDoA3Ogk7tOuvq4WjEVrzVrUkTLlvj1RYzECsXCjENovg7S5zLbHHx9U/9TzJmAtnKWKIBthrwyevbDvDLkTCRtiHJULXJDWsQobf4kloTWF9/8eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788215251; c=relaxed/simple;
	bh=mFs9jyAJIqg5UZabHnaeuHr1elc5PYCAO1UYkfm3Ghg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TaTu+mqt40nfODWZ8ao5EXEsEDp5qJi8ZDun85EB5n3aSDtIy2bMEW6W0kNyNoZ6uK9yPAYK2604i6hKQzibmceiCnVBtmkPi6wdrzeRdsBsHHz1bKCjD5P5vuuFM1G7N7z62HQsYozmKWjDt4CRxara0UVgVTJJklWEPTD1qWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LLc2BgvR; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LLc2BgvR"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso3001755e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 15:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788215248; x=1788820048; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3CSZkrYDR5e/hDvNdlQ7lc0nLj5SAFQdDVsNpWkWgNw=;
        b=LLc2BgvRWLGHkv5Vaw3jEp897lqZQoNsucNOILiQXo9wyFKLU2blq9E547Kn81ii1Z
         uPMO+pnFkvNeirHkum5BDRleJ/BI0xtABA7lHtlTzEpHNMnbaQLg1a29MWZPJbLTdpD+
         dezbDcg+B7/Eq/lzQP1/Zvl58Iwbf4gohklX2FvFIRH/S0RhWF+c4qytWUcI8BJ22+k8
         ZbvdDVk2AUv0WuoElzYOtogpZP+bj3zXRdz6fNV2IypXkKddUvyL//ib0qZGYsyzCPCu
         2Wct4HAP8eApnrn38ubhMGn87pLvMoWPjABeeGBlxfmZSbq+GFu1l3b1SBQy7TtF8pFg
         rrZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788215248; x=1788820048;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3CSZkrYDR5e/hDvNdlQ7lc0nLj5SAFQdDVsNpWkWgNw=;
        b=ifkAmsxlWwI3OtktBX3XndxQws9aI56vmo5tFraJDjFDu6tVWCRAxaavHc3NsWPk75
         fzrfZT0tXPAoPz4WDIQ3Rwo4L3KrwIBefMFqDsUw7FbSNUisnL4KAyqC1J8f7zxp8LST
         lnRyOv/yrJ8LKdXS/1k31v3R9rvTqfQ/LzhHxYYVes2Jl9M6QOPQpp6pT2ArOBruiV0F
         zu+YrGBzIJQ2I7OfKA0A2KM62OfN+ewRb119wjenh5zGz71xH++O4M9Il4oVORPx+Utg
         1zFuZcX4TM1epzzyk9lG/4oPg83ZjEMr7F8UgAZkYt9919QwyMyp1WQENSwkAd22Qw+n
         WSOw==
X-Gm-Message-State: AFuF++mZFIBBvRoS6xGy9qg+90zmHFoUblukXqMiFq0iJ0kl1mWxuC5H
	wzAQ6SclPtNGJoHIHSDGweLBnk97jUznXatDXkjOlvVBzo+ZXjRauNC310oT81TEzbM=
X-Gm-Gg: AR+sD10Kd0mgPyUuzX6TjUDR6QVN8Oxm5rLg5060ldgB+pNc2JE0XCzA0e1tCKUUKG1
	KYDE/Fs2V/imYvUYjLiYGUDuZSDKvuUc6B00rk6eVuyMh4zDU0u8wFAzw1OBD1XHPmc+gekRDTK
	OmrrOQOwATF7jFlb6cFRRC/q93RXcNDkBDShoWRXzeqHTPdaaR7HTSSgJT+Vb27cNsy17f9NiEH
	UzqW4MD2+wbhdktamri7ncIBRtEUc2W7xQUxEGjbEsFA1BUWqByTZ3G+cJYlSa4odXL0+TAw6k/
	gz9XiV927mTIO6nVp9pnFbW0hRbkZBKq8d6cReAcFgOCohY6CrTGRBOIcyUk42eUEWl8rI9PgdQ
	2/nV4fCxmoxz1WEQIm/CfZxA783SItjD4vMbeIBiOS+tDRQu56WCylD4gdlHcCWknrD6KAnKy4H
	0WeF2IvNa6YuL9EUEvyhoWXpZoGqIjusnFy3AjX8BxtcOdDlgPScQY
X-Received: by 2002:a05:600c:322a:b0:49b:914a:94a2 with SMTP id 5b1f17b1804b1-49cdd407d08mr15457695e9.1.1788215247764;
        Mon, 31 Aug 2026 15:27:27 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d4a1732sm1759764a91.7.2026.08.31.15.27.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 15:27:26 -0700 (PDT)
Message-ID: <9e51fd6c-f797-42a9-9e13-6b74180fa415@suse.com>
Date: Tue, 1 Sep 2026 07:57:22 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: use ordered extent to grab the logical address
 for submission
To: Boris Burkov <boris@bur.io>, Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <6576913842ae66ca1aa4f24cb60c544abe3ca43e.1785996696.git.wqu@suse.com>
 <CAPjX3FeYx6tKrbPy-b9W8eN3QKwLzG9Tt8=d85XSs-LfPpxMpg@mail.gmail.com>
 <20260831212213.GA325502@zen.localdomain>
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
In-Reply-To: <20260831212213.GA325502@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/1 06:52, Boris Burkov 写道:
> On Mon, Aug 31, 2026 at 09:46:18AM +0200, Daniel Vacek wrote:
>> On Thu, 6 Aug 2026 at 08:16, Qu Wenruo <wqu@suse.com> wrote:
>>> In submit_one_sector() we call btrfs_get_extent() to grab the IO extent
>>> map so that we know where the logical location to submit the block.
>>>
>>> However there is no guarantee that there is an IO extent map for the
>>> block, and if there is no IO extent map nor ordered extent,
>>> btrfs_get_extent() can grab the file extent from on-disk metadata.
>>>
>>> That's why we have ASSERT()s to reject holes and compressed file
>>> extents.
>>>
>>> On the other hand, for the write range we should have both an IO extent
>>> map and an ordered extent, so there is no reason not to grab the ordered
>>> extent instead.
>>>
>>> There is some minor advantages:
>>>
>>> - No hole ordered extent
>>>    So no need to rely on ASSERT()s to reject hole extents.
>>>
>>>    And the ASSERT()s are depending on the kernel config, without
>>>    CONFIG_BTRFS_ASSERT those ASSERT()s won't even trigger.
>>>
>>> - No IO errors
>>>    Unlike btrfs_get_extent() which can return IO error when doing the
>>>    metadata tree search, btrfs_lookup_ordered_extent() will either return
>>>    an OE or not found.
>>>
>>> - Cached OE in bio_ctrl->bbio
>>>    At bbio allocation we have already did an OE lookup, and we have a
>>>    high chance that the current block also belongs to that OE.
>>>    Use that cached OE can reduce the frequency to do an rb-tree search.
>>>
>>> - Smaller rb-tree
>>>    Unlike extent-map-tree, which can contain cached extent maps, the life
>>>    span of ordered extents are much shorter, they get removed from the
>>>    ordered tree after the file extent item is inserted into the subvolume
>>>    tree.
>>>
>>>    So doing ordered extent tree search can be a tiny faster.
>>>
>>> And since we're here, also address some minor points:
>>>
>>> - Add error message for every EUCLEAN error
>>>
>>> - Remove a dead comment on btrfs_folio_clear_dirty()
>>>    We no longer call folio_clear_dirty_for_io() since commit 095be159f3eb
>>>    ("btrfs: unify folio dirty flag clearing"), so the folio flag is
>>>    still dirty, and the folio dirty flag will be cleared by the last dirty
>>>    block.
>>>
> 
> I like Daniel's suggested cleanup (though maybe the "get_oe_from_bbio"
> name doesn't quite capture the file position passed in as part of the
> conceptual name. I still like it overall for making the refcount_inc
> more symmetrical with lookup, that was the aspect of your code that
> stuck out the most to me.
> 
> Conceptually it looks good and you can add
> Reviewed-by: Boris Burkov <boris@bur.io>

Thank both Daniel and you for the suggestion and review.

I'll send out a v3 to include the reviewed-by tag and Daniel's suggestion.

Thanks,
Qu

> to this version or v3 if you do do the nice cleanup.
> 
> Thanks,
> Boris
> 
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> Changelog:
>>> v2:
>>> - Extract a helper to determine if the @filepos is in the bbio OE range
>>>    Which reduces several "bio_ctrl->bbio->ordered" duplication, and use
>>>    in_range() to make is easier to read.
>>> ---
>>>   fs/btrfs/extent_io.c | 63 +++++++++++++++++++++++++++-----------------
>>>   1 file changed, 39 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>> index d7600e5fa3d9..50cee1b13b6d 100644
>>> --- a/fs/btrfs/extent_io.c
>>> +++ b/fs/btrfs/extent_io.c
>>> @@ -1808,6 +1808,18 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
>>>          return 0;
>>>   }
>>>
>>> +static bool block_in_bbio_oe_range(const struct btrfs_bio_ctrl *bio_ctrl,
>>> +                                  u64 filepos)
>>> +{
>>> +       struct btrfs_ordered_extent *oe;
>>> +
>>> +       if (!bio_ctrl->bbio || !bio_ctrl->bbio->ordered)
>>> +               return false;
>>> +
>>> +       oe = bio_ctrl->bbio->ordered;
>>> +       return in_range(filepos, oe->file_offset, oe->num_bytes);
>>> +}
>>> +
>>>   /*
>>>    * Return 0 if we have submitted or queued the sector for submission.
>>>    * Return <0 for critical errors, and the involved sector will be cleaned up.
>>> @@ -1820,11 +1832,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
>>>                               loff_t i_size)
>>>   {
>>>          struct btrfs_fs_info *fs_info = inode->root->fs_info;
>>> -       struct extent_map *em;
>>> +       struct btrfs_ordered_extent *oe;
>>>          u64 block_start;
>>>          u64 disk_bytenr;
>>>          u64 extent_offset;
>>> -       u64 em_end;
>>>          const u32 sectorsize = fs_info->sectorsize;
>>>          unsigned int queued;
>>>
>>> @@ -1833,8 +1844,14 @@ static int submit_one_sector(struct btrfs_inode *inode,
>>>          /* @filepos >= i_size case should be handled by the caller. */
>>>          ASSERT(filepos < i_size);
>>>
>>> -       em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
>>> -       if (IS_ERR(em)) {
>>> +       /* Try to reuse the existing OE from bbio first. */
>>> +       if (block_in_bbio_oe_range(bio_ctrl, filepos)) {
>>> +               oe = bio_ctrl->bbio->ordered;
>>> +               refcount_inc(&oe->refs);
>>> +       } else {
>>> +               oe = btrfs_lookup_ordered_extent(inode, filepos);
>>> +       }
>>> +       if (unlikely(!oe)) {
>>>                  /*
>>>                   * bio_ctrl may contain a bio crossing several folios.
>>>                   * Submit it immediately so that the bio has a chance
>>
>> How about this small cleanup?:
>>
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -1691,6 +1691,22 @@ static noinline_for_stack int
>> writepage_delalloc(struct btrfs_inode *inode,
>>       return 0;
>>   }
>>
>> +static struct btrfs_ordered_extent *get_oe_from_bbio(const struct
>> btrfs_bio *bbio,
>> +                             u64 filepos)
>> +{
>> +    struct btrfs_ordered_extent *oe;
>> +
>> +    if (!bbio || !bbio->ordered)
>> +        return NULL;
>> +
>> +    oe = bbio->ordered;
>> +    if (!in_range(filepos, oe->file_offset, oe->num_bytes))
>> +        return NULL;
>> +
>> +    refcount_inc(&oe->refs);
>> +    return oe;
>> +}
>> +
>>   /*
>>    * Return 0 if we have submitted or queued the sector for submission.
>>    * Return <0 for critical errors, and the involved sector will be cleaned up.
>> @@ -1715,8 +1731,11 @@ static int submit_one_sector(struct btrfs_inode *inode,
>>       /* @filepos >= i_size case should be handled by the caller. */
>>       ASSERT(filepos < i_size);
>>
>> -    em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
>> -    if (IS_ERR(em)) {
>> +    /* Try to reuse the existing OE from bbio first. */
>> +    oe = get_oe_from_bbio(bio_ctrl->bbio, filepos);
>> +    if (!oe)
>> +        oe = btrfs_lookup_ordered_extent(inode, filepos);
>> +    if (unlikely(!oe)) {
>>           /*
>>            * bio_ctrl may contain a bio crossing several folios.
>>            * Submit it immediately so that the bio has a chance
>>
>> --nX
>>
>>> @@ -1857,31 +1874,25 @@ static int submit_one_sector(struct btrfs_inode *inode,
>>>                   */
>>>                  btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
>>>                                                 false);
>>> -               return PTR_ERR(em);
>>> +               btrfs_err_rl(fs_info,
>>> +               "no ordered extent for root %lld ino %llu filepos %llu",
>>> +                            btrfs_root_id(inode->root), btrfs_ino(inode),
>>> +                            filepos);
>>> +               return -EUCLEAN;
>>>          }
>>>
>>> -       extent_offset = filepos - em->start;
>>> -       em_end = btrfs_extent_map_end(em);
>>> -       ASSERT(filepos <= em_end);
>>> -       ASSERT(IS_ALIGNED(em->start, sectorsize));
>>> -       ASSERT(IS_ALIGNED(em->len, sectorsize));
>>> +       extent_offset = filepos - oe->file_offset;
>>> +       ASSERT(filepos < oe->file_offset + oe->num_bytes);
>>> +       ASSERT(IS_ALIGNED(oe->file_offset, sectorsize));
>>> +       ASSERT(IS_ALIGNED(oe->num_bytes, sectorsize));
>>> +       ASSERT(oe->compress_type == BTRFS_COMPRESS_NONE);
>>> +       ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &oe->flags));
>>>
>>> -       block_start = btrfs_extent_map_block_start(em);
>>> -       disk_bytenr = btrfs_extent_map_block_start(em) + extent_offset;
>>> +       block_start = oe->disk_bytenr + oe->offset;
>>> +       disk_bytenr = block_start + extent_offset;
>>>
>>> -       ASSERT(!btrfs_extent_map_is_compressed(em));
>>> -       ASSERT(block_start != EXTENT_MAP_HOLE);
>>> -       ASSERT(block_start != EXTENT_MAP_INLINE);
>>> +       btrfs_put_ordered_extent(oe);
>>>
>>> -       btrfs_free_extent_map(em);
>>> -       em = NULL;
>>> -
>>> -       /*
>>> -        * Although the PageDirty bit is cleared before entering this
>>> -        * function, subpage dirty bit is not cleared.
>>> -        * So clear subpage dirty bit here so next time we won't submit
>>> -        * a folio for a range already written to disk.
>>> -        */
>>>          btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
>>>          btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
>>>          /*
>>> @@ -1898,6 +1909,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
>>>                  btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
>>>                  btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
>>>                                                 false);
>>> +               btrfs_err_rl(fs_info,
>>> +               "failed to queue sector for root %lld ino %llu filepos %llu",
>>> +                            btrfs_root_id(inode->root),
>>> +                            btrfs_ino(inode), filepos);
>>>                  return -EUCLEAN;
>>>          }
>>>          return 0;
>>> --
>>> 2.54.0
>>>
>>>

