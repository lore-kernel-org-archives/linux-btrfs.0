Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02605C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C08C12086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:15:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C08C12086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbeK0SMh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 13:12:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:56796 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729041AbeK0SMh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 13:12:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04126AF88
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 07:15:39 +0000 (UTC)
Subject: Re: [PATCH 2/5] btrfs-progs: image: Fix block group item flags when
 restoring multi-device image to single device
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181127023315.28176-1-wqu@suse.com>
 <20181127023315.28176-3-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <39f8f85a-6469-ff5a-f745-fb4f97ff6593@suse.com>
Date:   Tue, 27 Nov 2018 09:15:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181127023315.28176-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 27.11.18 г. 4:33 ч., Qu Wenruo wrote:
> Since btrfs-image is just restoring tree blocks without really check if
> that tree block contents makes sense, for multi-device image, block
> group items will keep that incorrect block group flags.
> 
> For example, for a metadata RAID1 data RAID0 btrfs recovered to a single
> disk, its chunk tree will look like:
> 
> 	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096)
> 		length 8388608 owner 2 stripe_len 65536 type SYSTEM
> 	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704)
> 		length 1073741824 owner 2 stripe_len 65536 type METADATA
> 	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 1104150528)
> 		length 1073741824 owner 2 stripe_len 65536 type DATA
> 
> All chunks have correct type (SINGLE).
> 
> While its block group items will look like:
> 
> 	item 1 key (22020096 BLOCK_GROUP_ITEM 8388608)
> 		block group used 16384 chunk_objectid 256 flags SYSTEM|RAID1
> 	item 3 key (30408704 BLOCK_GROUP_ITEM 1073741824)
> 		block group used 114688 chunk_objectid 256 flags METADATA|RAID1
> 	item 11 key (1104150528 BLOCK_GROUP_ITEM 1073741824)
> 		block group used 1572864 chunk_objectid 256 flags DATA|RAID0
> 
> All block group items still have the wrong profiles.
> 
> And btrfs check (lowmem mode for better output) will report error for such image:
> 
>   ERROR: chunk[22020096 30408704) related block group item flags mismatch, wanted: 2, have: 18
>   ERROR: chunk[30408704 1104150528) related block group item flags mismatch, wanted: 4, have: 20
>   ERROR: chunk[1104150528 2177892352) related block group item flags mismatch, wanted: 1, have: 9
> 
> This patch will do an extra repair for block group items to fix the
> profile of them.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  image/main.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/image/main.c b/image/main.c
> index 36b5c95ea146..9060f6b1b665 100644
> --- a/image/main.c
> +++ b/image/main.c
> @@ -2164,6 +2164,52 @@ again:
>  	return 0;
>  }
>  
> +static void fixup_block_groups(struct btrfs_trans_handle *trans,
> +			      struct btrfs_fs_info *fs_info)

You are not even using the trans handle in this function, why pass it?

> +{
> +	struct btrfs_block_group_cache *bg;
> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
> +	struct cache_extent *ce;
> +	struct map_lookup *map;
> +	u64 extra_flags;
> +
> +	for (ce = search_cache_extent(&map_tree->cache_tree, 0); ce;
> +	     ce = next_cache_extent(ce)) {
> +		map = container_of(ce, struct map_lookup, ce);
> +
> +		bg = btrfs_lookup_block_group(fs_info, ce->start);
> +		if (!bg) {
> +			warning(
> +		"can't find block group %llu, result fs may not be mountable",
> +				ce->start);
> +			continue;
> +		}
> +		extra_flags = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
> +
> +		if (bg->flags == map->type)
> +			continue;
> +
> +		/* Update the block group item and mark the bg dirty */
> +		bg->flags = map->type;
> +		btrfs_set_block_group_flags(&bg->item, bg->flags);
> +		set_extent_bits(&fs_info->block_group_cache, ce->start,
> +				ce->start + ce->size - 1, BLOCK_GROUP_DIRTY);
> +
> +		/*
> +		 * Chunk and bg flags can be different, changing bg flags
> +		 * without update avail_data/meta_alloc_bits will lead to
> +		 * ENOSPC.
> +		 * So here we set avail_*_alloc_bits to match chunk types.
> +		 */
> +		if (map->type & BTRFS_BLOCK_GROUP_DATA)
> +			fs_info->avail_data_alloc_bits = extra_flags;
> +		if (map->type & BTRFS_BLOCK_GROUP_METADATA)
> +			fs_info->avail_metadata_alloc_bits = extra_flags;
> +		if (map->type & BTRFS_BLOCK_GROUP_SYSTEM)
> +			fs_info->avail_system_alloc_bits = extra_flags;
> +	}
> +}
> +
>  static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
>  			 struct mdrestore_struct *mdres, off_t dev_size)
>  {
> @@ -2180,6 +2226,7 @@ static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
>  		return PTR_ERR(trans);
>  	}
>  
> +	fixup_block_groups(trans, fs_info);
>  	ret = fixup_device_size(trans, fs_info, mdres, dev_size);
>  	if (ret < 0)
>  		goto error;
> 
