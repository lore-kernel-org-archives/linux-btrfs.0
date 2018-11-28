Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11739C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 08:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB0022086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 08:56:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB0022086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbeK1T5Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 14:57:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:44994 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727413AbeK1T5Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 14:57:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6ADE7AC15;
        Wed, 28 Nov 2018 08:56:21 +0000 (UTC)
Subject: Re: [RFC PATCH 03/17] btrfs: priority alloc: introduce
 compute_block_group_priority/usage
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
 <20181128031148.357-4-suy.fnst@cn.fujitsu.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <61fce179-44f6-176c-7e34-da951b579a12@suse.com>
Date:   Wed, 28 Nov 2018 10:56:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181128031148.357-4-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.11.18 г. 5:11 ч., Su Yue wrote:
> Introduce compute_block_group_usage() and compute_block_group_usage().
> And call the latter in btrfs_make_block_group() and
> btrfs_read_block_groups().
> 
> compute_priority_level use ilog2(free) to compute priority level.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 60 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d242a1174e50..0f4c5b1e0bcc 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10091,6 +10091,7 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
>  	return ret;
>  }
>  
> +static long compute_block_group_priority(struct btrfs_block_group_cache *bg);

That is ugly, just put the function above the first place where they are
going to be used and don't introduce forward declarations for static
functions.

>  int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  {
>  	struct btrfs_path *path;
> @@ -10224,6 +10225,8 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  
>  		link_block_group(cache);
>  
> +		cache->priority = compute_block_group_priority(cache);
> +
>  		set_avail_alloc_bits(info, cache->flags);
>  		if (btrfs_chunk_readonly(info, cache->key.objectid)) {
>  			inc_block_group_ro(cache, 1);
> @@ -10373,6 +10376,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
>  
>  	link_block_group(cache);
>  
> +	cache->priority = compute_block_group_priority(cache);
> +
>  	list_add_tail(&cache->bg_list, &trans->new_bgs);
>  
>  	set_avail_alloc_bits(fs_info, type);
> @@ -11190,3 +11195,58 @@ void btrfs_mark_bg_unused(struct btrfs_block_group_cache *bg)
>  	}
>  	spin_unlock(&fs_info->unused_bgs_lock);
>  }
> +
> +enum btrfs_priority_shift {
> +	PRIORITY_USAGE_SHIFT = 0
> +};
> +
> +static inline u8
> +compute_block_group_usage(struct btrfs_block_group_cache *cache)
> +{
> +	u64 num_bytes;
> +	u8 usage;
> +
> +	num_bytes = cache->reserved + cache->bytes_super +
> +		btrfs_block_group_used(&cache->item);
> +
> +	usage = div_u64(num_bytes, div_factor_fine(cache->key.offset, 1));

Mention somewhere (either as a function description or in the patch
description) that you use the % used.

> +
> +	return usage;
> +}
> +
> +static long compute_block_group_priority(struct btrfs_block_group_cache *bg)
> +{
> +	u8 usage;
> +	long priority = 0;
> +
> +	if (btrfs_test_opt(bg->fs_info, PRIORITY_USAGE)) {
> +		usage = compute_block_group_usage(bg);
> +		priority |= usage << PRIORITY_USAGE_SHIFT;
> +	}

Why is priority a signed type and not unsigned, I assume priority can
never be negative? I briefly looked at the other patches and most of the
time the argument passed is indeed na unsigned value.

> +
> +	return priority;
> +}
> +
> +static int compute_priority_level(struct btrfs_fs_info *fs_info,
> +				  long priority)
> +{
> +	int level = 0;
> +
> +	if (btrfs_test_opt(fs_info, PRIORITY_USAGE)) {
> +		u8 free;
> +
> +		WARN_ON(priority < 0);

I think this WARN_ON is redundant provided that the high-level
interfaces are sane and don't allow negative value to trickle down.

> +		free = 100 - (priority >> PRIORITY_USAGE_SHIFT);
> +
> +		if (free == 0)
> +			level = 0;
> +		else if (free == 100)
> +			level = ilog2(free) + 1;
> +		else
> +			level = ilog2(free);
> +		/* log2(1) == 0, leave level 0 for unused block_groups */
> +		level = ilog2(100) + 1 - level;
> +	}
> +
> +	return level;
> +}
> 
