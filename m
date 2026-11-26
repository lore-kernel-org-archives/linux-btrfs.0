Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795727401;
	b=rnbc+jxTvZzPYb/3DwNNDepbjtPLAn8S/P7IJ0n2x+COrmXIR4yvWedrvZogkt8Qt4YT
	 1G4fvuC169iX/+LTzZeSSDAHDk/CJ5cRGrzlQ2VeTWVLSGs0UK/OcjO8EETSdLe49rRy0
	 5wQewvC6OWrjkL1n1qwKkE1tKs4kS3fUqFEbHxUwLK/YPaC6UJTbdTYVYK3Y6nti1v5sP
	 Kb1yxhgvDwBmbpZpy0cMHGTTOU0JbXWCl12OxOBPc6nks1SuLJvzMOfAO3C0xtqz1R9n3
	 yqMvys7XYEHlYSbzygBz8gccUw6kiflxX0GuLhOWhYsDVh3tMkw6FuxWQ1g0f6XWYLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727401;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=z+X5hSShmDdNyCInHh2t7NHUTRnUnKZzS9JxOXOuE1c=;
	b=evo9y8VttU41uWm7d4CUwUo8wscImy6rnSHtDDKnw5J/1yX+xLNffPwam8kZtrK5SbH6
	 br2rsVxhgd7wF1Aqo/2pA/cH6o90UQMt4YPOhW/lOoUC2gCV2KXFsZ7C9cdTkKKxvCD5P
	 j/wA5SW+pUYRkLuGJzu/n7OMI9DKydybsrS1c9f+8iZKE9QDzMRzaMzg6KjGTd1LWOQ2E
	 /iseK3nJeOas+C+pLXZXoH+iG1/Qvj+ZjAz9vkPuQb5M+8bTIiCYDRjM82oD+Ve9cNL4y
	 s2WxVhkFt1vv9uPliYlHBEBC5izVdkwlyiW1DoOd8jsSD8YqLFNgksvNiYF/MvJfXpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yefxk46c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C3E606A323
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 21:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yefxk46c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853C51F00896;
	Thu, 26 Nov 2026 21:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727400;
	bh=z+X5hSShmDdNyCInHh2t7NHUTRnUnKZzS9JxOXOuE1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Yefxk46cW+1irRhw/UOWn0RoLOYRUu12TbWj07+KGAD/NxMsvFmzGHOAp6axhTUms
	 k6lb+oyAzT+ENVUj7otLd3f9v/m1X8tOFefQm5Dw/qdyJZZiJc/wEjBF7EFfeuosHk
	 u2bTKFdo0WGn5fVAxGw6bJOardbSXn5e2DyTagmbHx1m390porwMcUx/yYuMgLjTd+
	 fhL1+e9ICfZqRaoyhGZ+NKtM1xtQf3VAA4mK2Vbz+kYrdz/xP+4kfaPHuuLNiHY0VZ
	 6/kYMrVR5WrjS2hDd2h04whZwOyflB1EPLMXv9Tjfm2YnuYlbKiG+YUe4ZupP/vMeK
	 AP5JHfQSVAWrw==
Message-ID: <a70e0150-abae-4545-95bd-e9bf7f594458@kernel.org>
Date: Fri, 27 Nov 2026 06:09:58 +0900
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] btrfs: zoned: search for hinted block-group in
 prepare_allocation_zoned
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>,
 Wilfred Mallawa <wilfred.opensource@gmail.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
 <20261126132820.570379-2-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261126132820.570379-2-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/26 22:28, Johannes Thumshirn wrote:
> When searching for a block-group to place to allocate data extents from,
> honor the hint passed in if the hint falls within the range of an
> already active block-group.
> 
> If the hint doesn't fall into an active block-group or the hinted
> block-group does not have enough available space left, fall back to an
> avtive block-group that has enough space left for the allocation.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/extent-tree.c       | 41 ++++++++++++++++++++++++++++++------
>  include/trace/events/btrfs.h | 29 +++++++++++++++++++++++++
>  2 files changed, 64 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d59289ce3294..0541b38129e5 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4472,7 +4472,8 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
>  				    struct find_free_extent_ctl *ffe_ctl,
>  				    struct btrfs_space_info *space_info)
>  {
> -	struct btrfs_block_group *block_group;
> +	struct btrfs_block_group *block_group, *fallback = NULL;
> +	u64 hint = ffe_ctl->hint_byte;
>  
>  	if (ffe_ctl->for_treelog) {
>  		spin_lock(&fs_info->treelog_bg_lock);
> @@ -4501,13 +4502,41 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
>  		 */
>  		u64 avail = block_group->zone_capacity - block_group->alloc_offset;
>  
> -		if (block_group_bits(block_group, ffe_ctl->flags) &&
> -		    block_group->space_info == space_info &&
> -		    avail >= ffe_ctl->num_bytes) {
> -			ffe_ctl->hint_byte = block_group->start;
> +		if (!block_group_bits(block_group, ffe_ctl->flags))
> +			continue;
> +
> +		if (block_group->space_info != space_info)
> +			continue;
> +
> +		if (test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC,
> +					&block_group->runtime_flags))
> +			continue;
> +
> +		if (avail < ffe_ctl->num_bytes)
> +			continue;
> +
> +		/*
> +		 * Remember the first block-group that fits the allocation. Then
> +		 * check if the hint in ffe_ctl::hint_byte is in the active_bgs
> +		 * list and has enough space available. If yes pick it. If not,
> +		 * use the fallback block-group.
> +		 */
> +		if (!fallback)
> +			fallback = block_group;
> +
> +		if (in_range(ffe_ctl->hint_byte, block_group->start,
> +			     block_group->length))
>  			break;
> -		}
>  	}
> +
> +	if (list_entry_is_head(block_group, &fs_info->zone_active_bgs,
> +				active_bg_list))
> +		block_group = fallback;

It took me a while to understand what the test is... To make this easier to
understand, why not use a "bg" variable for the loop, and set block_group to bg
if the in_range() test is true? You can then simply have:

	if (!block_group)
		block_group = fallback;

That would be a lot easier to understand and nicer to read :)

Other than this, this looks all good to me.

> +
> +	if (block_group)
> +		ffe_ctl->hint_byte = block_group->start;
> +
> +	trace_prepare_allocation_zoned(fs_info, hint, block_group);
>  	spin_unlock(&fs_info->zone_active_bgs_lock);
>  
>  	return 0;
> diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
> index dd862d1f2a2c..1378e697a46f 100644
> --- a/include/trace/events/btrfs.h
> +++ b/include/trace/events/btrfs.h
> @@ -2241,6 +2241,35 @@ TRACE_EVENT(btrfs_find_free_extent_have_block_group,
>  				 BTRFS_GROUP_FLAGS))
>  );
>  
> +TRACE_EVENT(prepare_allocation_zoned,
> +
> +	TP_PROTO(const struct btrfs_fs_info *fs_info,
> +		 u64 hint_byte, const struct btrfs_block_group *block_group),
> +
> +	TP_ARGS(fs_info, hint_byte, block_group),
> +
> +	TP_STRUCT__entry_btrfs(
> +		__field(	u64,	hint_byte		)
> +		__field(	u64,	bg_start		)
> +		__field(	u64,	bg_flags		)
> +		__field(	bool,	hit			)
> +	),
> +
> +	TP_fast_assign_btrfs(fs_info,
> +		__entry->hint_byte	= hint_byte;
> +		__entry->bg_start	= block_group ? block_group->start : 0;
> +		__entry->bg_flags	= block_group ? block_group->flags : 0;
> +		__entry->hit		= block_group && in_range(hint_byte,
> +						block_group->start,
> +						block_group->length);
> +	),
> +
> +	TP_printk_btrfs("hint=%llu block_group=%llu bg_flags=%llu(%s) hit=%d",
> +			__entry->hint_byte, __entry->bg_start, __entry->bg_flags,
> +			__print_flags((unsigned long)__entry->bg_flags, "|",
> +				BTRFS_GROUP_FLAGS), __entry->hit)
> +);
> +
>  DECLARE_EVENT_CLASS(btrfs__reserve_extent,
>  
>  	TP_PROTO(const struct btrfs_block_group *block_group,


-- 
Damien Le Moal
Western Digital Research
