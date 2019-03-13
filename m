Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32F1C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B7D52183F
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 09:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfCMJTD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:19:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:43416 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726843AbfCMJTD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Mar 2019 05:19:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 346A0B025;
        Wed, 13 Mar 2019 09:19:01 +0000 (UTC)
Subject: Re: [PATCH 1/6] btrfs: tree-checker: Verify chunk items
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-2-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <8612b9e4-bf67-32db-0c37-504e748354f8@suse.com>
Date:   Wed, 13 Mar 2019 11:19:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313085511.23540-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 13.03.19 г. 10:55 ч., Qu Wenruo wrote:
> We already have btrfs_check_chunk_valid() to verify each chunk before
> tree-checker.
> 
> Merge that function into tree-checker, and update its error message to
> be more readable.
> 
> Old error message would be something like:
>   BTRFS error (device dm-3): invalid chunk num_stipres: 0
> 
> New error message would be:
>   Btrfs critical (device dm-3): corrupt superblock syschunk array: chunk_start=2097152, invalid chunk num_stripes: 0
> Or
>   Btrfs critical (device dm-3): corrupt leaf: root=3 block=8388608 slot=3 chunk_start=2097152, invalid chunk num_stripes: 0
> 
> Btrfs_check_chunk_valid() is exported for super block syschunk array
> verification.
> 
> Also make tree-checker to verify chunk items, this makes chunk item
> checker covers all chunks and avoid fuzzed image.
> 
> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202751
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I had already reviewed the earlier posting of this patch so:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>


> ---
>  fs/btrfs/tree-checker.c | 152 ++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/tree-checker.h |   3 +
>  fs/btrfs/volumes.c      |  94 +------------------------
>  3 files changed, 156 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index b8cdaf472031..fe3f37c23c29 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -448,6 +448,152 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
>  	return 0;
>  }
>  
> +__printf(5, 6)
> +__cold
> +static void chunk_err(const struct btrfs_fs_info *fs_info,
> +		      const struct extent_buffer *leaf,
> +		      const struct btrfs_chunk *chunk, u64 logical,
> +		      const char *fmt, ...)
> +{
> +	/* Only superblock eb is able to have such small offset */
> +	bool is_sb = (leaf->start == BTRFS_SUPER_INFO_OFFSET);
> +	struct va_format vaf;
> +	va_list args;
> +	int i;
> +	int slot = -1;
> +
> +	if (!is_sb) {
> +		/*
> +		 * Get the slot number by iterating through all slots, this
> +		 * would provide better readability.
> +		 */
> +		for (i = 0; i < btrfs_header_nritems(leaf); i++) {
> +			if (btrfs_item_ptr_offset(leaf, i) ==
> +					(unsigned long) chunk) {
> +				slot = i;
> +				break;
> +			}
> +		}
> +	}
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	if (is_sb)
> +		btrfs_crit(fs_info,
> +		"corrupt superblock syschunk array: chunk_start=%llu, %pV",
> +			   logical, &vaf);
> +	else
> +		btrfs_crit(fs_info,
> +	"corrupt leaf: root=%llu block=%llu slot=%d chunk_start=%llu, %pV",
> +			   BTRFS_CHUNK_TREE_OBJECTID, leaf->start, slot,
> +			   logical, &vaf);
> +	va_end(args);
> +}
> +
> +/*
> + * The common chunk check which could also work on super block sys chunk array.
> + *
> + * Return -EUCLEAN if anything is corrupted.
> + * Return 0 if everything is OK.
> + */
> +int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
> +			    struct extent_buffer *leaf,
> +			    struct btrfs_chunk *chunk, u64 logical)
> +{
> +	u64 length;
> +	u64 stripe_len;
> +	u16 num_stripes;
> +	u16 sub_stripes;
> +	u64 type;
> +	u64 features;
> +	bool mixed = false;
> +
> +	length = btrfs_chunk_length(leaf, chunk);
> +	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
> +	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
> +	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
> +	type = btrfs_chunk_type(leaf, chunk);
> +
> +	if (!num_stripes) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			  "invalid chunk num_stripes: %u", num_stripes);
> +		return -EUCLEAN;
> +	}
> +	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			  "invalid chunk logical %llu", logical);
> +		return -EUCLEAN;
> +	}
> +	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			  "invalid chunk sectorsize %u",
> +			  btrfs_chunk_sector_size(leaf, chunk));
> +		return -EUCLEAN;
> +	}
> +	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			  "invalid chunk length %llu", length);
> +		return -EUCLEAN;
> +	}
> +	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			  "invalid chunk stripe length: %llu", stripe_len);
> +		return -EUCLEAN;
> +	}
> +	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> +	    type) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			  "unrecognized chunk type: %llu",
> +			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
> +			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> +			  btrfs_chunk_type(leaf, chunk));
> +		return -EUCLEAN;
> +	}
> +
> +	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			  "missing chunk type flag: 0x%llx", type);
> +		return -EUCLEAN;
> +	}
> +
> +	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
> +	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			"system chunk with data or metadata type: 0x%llx", type);
> +		return -EUCLEAN;
> +	}
> +
> +	features = btrfs_super_incompat_flags(fs_info->super_copy);
> +	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
> +		mixed = true;
> +
> +	if (!mixed) {
> +		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
> +		    (type & BTRFS_BLOCK_GROUP_DATA)) {
> +			chunk_err(fs_info, leaf, chunk, logical,
> +			"mixed chunk type in non-mixed mode: 0x%llx", type);
> +			return -EUCLEAN;
> +		}
> +	}
> +
> +	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
> +	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
> +	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
> +	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
> +	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
> +	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
> +	     num_stripes != 1)) {
> +		chunk_err(fs_info, leaf, chunk, logical,
> +			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
> +			num_stripes, sub_stripes,
> +			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
> +		return -EUCLEAN;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -455,6 +601,7 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
>  			   struct extent_buffer *leaf,
>  			   struct btrfs_key *key, int slot)
>  {
> +	struct btrfs_chunk *chunk;
>  	int ret = 0;
>  
>  	switch (key->type) {
> @@ -472,6 +619,11 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
>  	case BTRFS_BLOCK_GROUP_ITEM_KEY:
>  		ret = check_block_group_item(fs_info, leaf, key, slot);
>  		break;
> +	case BTRFS_CHUNK_ITEM_KEY:
> +		chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
> +		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk,
> +					      key->offset);
> +		break;
>  	}
>  	return ret;
>  }
> diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
> index 6f8d1b627c53..6cb96ba5e711 100644
> --- a/fs/btrfs/tree-checker.h
> +++ b/fs/btrfs/tree-checker.h
> @@ -33,4 +33,7 @@ int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
>  			   struct extent_buffer *leaf);
>  int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
>  
> +int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
> +			    struct extent_buffer *leaf,
> +			    struct btrfs_chunk *chunk, u64 logical);
>  #endif
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 15561926ab32..0e3822870f1e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -27,6 +27,7 @@
>  #include "math.h"
>  #include "dev-replace.h"
>  #include "sysfs.h"
> +#include "tree-checker.h"
>  
>  const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
>  	[BTRFS_RAID_RAID10] = {
> @@ -6705,99 +6706,6 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
>  	return dev;
>  }
>  
> -/* Return -EIO if any error, otherwise return 0. */
> -static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
> -				   struct extent_buffer *leaf,
> -				   struct btrfs_chunk *chunk, u64 logical)
> -{
> -	u64 length;
> -	u64 stripe_len;
> -	u16 num_stripes;
> -	u16 sub_stripes;
> -	u64 type;
> -	u64 features;
> -	bool mixed = false;
> -
> -	length = btrfs_chunk_length(leaf, chunk);
> -	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
> -	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
> -	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
> -	type = btrfs_chunk_type(leaf, chunk);
> -
> -	if (!num_stripes) {
> -		btrfs_err(fs_info, "invalid chunk num_stripes: %u",
> -			  num_stripes);
> -		return -EIO;
> -	}
> -	if (!IS_ALIGNED(logical, fs_info->sectorsize)) {
> -		btrfs_err(fs_info, "invalid chunk logical %llu", logical);
> -		return -EIO;
> -	}
> -	if (btrfs_chunk_sector_size(leaf, chunk) != fs_info->sectorsize) {
> -		btrfs_err(fs_info, "invalid chunk sectorsize %u",
> -			  btrfs_chunk_sector_size(leaf, chunk));
> -		return -EIO;
> -	}
> -	if (!length || !IS_ALIGNED(length, fs_info->sectorsize)) {
> -		btrfs_err(fs_info, "invalid chunk length %llu", length);
> -		return -EIO;
> -	}
> -	if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
> -		btrfs_err(fs_info, "invalid chunk stripe length: %llu",
> -			  stripe_len);
> -		return -EIO;
> -	}
> -	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> -	    type) {
> -		btrfs_err(fs_info, "unrecognized chunk type: %llu",
> -			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
> -			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> -			  btrfs_chunk_type(leaf, chunk));
> -		return -EIO;
> -	}
> -
> -	if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
> -		btrfs_err(fs_info, "missing chunk type flag: 0x%llx", type);
> -		return -EIO;
> -	}
> -
> -	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
> -	    (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
> -		btrfs_err(fs_info,
> -			"system chunk with data or metadata type: 0x%llx", type);
> -		return -EIO;
> -	}
> -
> -	features = btrfs_super_incompat_flags(fs_info->super_copy);
> -	if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
> -		mixed = true;
> -
> -	if (!mixed) {
> -		if ((type & BTRFS_BLOCK_GROUP_METADATA) &&
> -		    (type & BTRFS_BLOCK_GROUP_DATA)) {
> -			btrfs_err(fs_info,
> -			"mixed chunk type in non-mixed mode: 0x%llx", type);
> -			return -EIO;
> -		}
> -	}
> -
> -	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes != 2) ||
> -	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
> -	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
> -	    (type & BTRFS_BLOCK_GROUP_RAID6 && num_stripes < 3) ||
> -	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
> -	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
> -	     num_stripes != 1)) {
> -		btrfs_err(fs_info,
> -			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
> -			num_stripes, sub_stripes,
> -			type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
> -		return -EIO;
> -	}
> -
> -	return 0;
> -}
> -
>  static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
>  					u64 devid, u8 *uuid, bool error)
>  {
> 
