Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6543 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932786AbeGDCVB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 22:21:01 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 1/5] btrfs: tree-checker: Verify block_group_item
Date: Wed, 4 Jul 2018 02:20:57 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A85579F8@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-2-wqu@suse.com>
In-Reply-To: <20180703091009.16399-2-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Tuesday, July 03, 2018 5:10 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH 1/5] btrfs: tree-checker: Verify block_group_item
> 
> A crafted image with invalid block group items could make free space cache
> code to cause panic.
> 
> We could early detect such invalid block group item by checking:
> 1) Item size
>    Fixed value.
> 2) Block group size (key.offset)
>    We have a up limit on block group item (10G)
> 3) Chunk objectid
>    Fixed value.
> 4) Type
>    Only 4 valid type values, DATA, METADATA, SYSTEM and DATA|METADATA.
>    No more than 1 bit set for profile type.
> 5) Used space
>    No more than block group size.
> 
> This should allow btrfs to detect and refuse to mount the crafted image.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199849
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 101 ++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.c      |   2 +-
>  fs/btrfs/volumes.h      |   2 +
>  3 files changed, 104 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 8d40e7dd8c30..1cd735b099df 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -19,6 +19,7 @@
>  #include "tree-checker.h"
>  #include "disk-io.h"
>  #include "compression.h"
> +#include "volumes.h"
> 
>  /*
>   * Error message should follow the following format:
> @@ -353,6 +354,103 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
>  	return 0;
>  }
> 
> +__printf(4, 5)
> +__cold
> +static void block_group_err(const struct btrfs_fs_info *fs_info,
> +			    const struct extent_buffer *eb, int slot,
> +			    const char *fmt, ...)
> +{
> +	struct btrfs_key key;
> +	struct va_format vaf;
> +	va_list args;
> +
> +	btrfs_item_key_to_cpu(eb, &key, slot);
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	btrfs_crit(fs_info,
> +	"corrupt %s: root=%llu block=%llu slot=%d bg_start=%llu bg_len=%llu, %pV",
> +		btrfs_header_level(eb) == 0 ? "leaf" : "node",
> +		btrfs_header_owner(eb), btrfs_header_bytenr(eb), slot,
> +		key.objectid, key.offset, &vaf);
> +	va_end(args);
> +}
> +
> +static int check_block_group_item(struct btrfs_fs_info *fs_info,
> +				  struct extent_buffer *leaf,
> +				  struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_block_group_item bgi;
> +	u32 item_size = btrfs_item_size_nr(leaf, slot);
> +	u64 flags;
> +	u64 type_flags;
> +
> +	/*
> +	 * Here we don't really care about unalignment since extent allocator
> +	 * can handle it.
> +	 * We care more about the size, as if one block group is larger than
> +	 * maximum size, it's must be some obvious corruption
> +	 */
> +	if (key->offset > BTRFS_MAX_DATA_CHUNK_SIZE || key->offset == 0) {
> +		block_group_err(fs_info, leaf, slot,
> +			"invalid block group size, have %llu expect (0, %llu]",
> +				key->offset, 10ULL * SZ_1G);
> +		return -EUCLEAN;
> +	}
> +
> +	if (item_size != sizeof(bgi)) {
> +		block_group_err(fs_info, leaf, slot,
> +			"invalid item size, have %u expect %lu",
> +				item_size, sizeof(bgi));
> +		return -EUCLEAN;
> +	}
> +
> +	read_extent_buffer(leaf, &bgi, btrfs_item_ptr_offset(leaf, slot),
> +			   sizeof(bgi));
> +	if (btrfs_block_group_chunk_objectid(&bgi) !=
> +	    BTRFS_FIRST_CHUNK_TREE_OBJECTID) {
> +		block_group_err(fs_info, leaf, slot,
> +		"invalid block group chunk objectid, have %llu expect %llu",
> +				btrfs_block_group_chunk_objectid(&bgi),
> +				BTRFS_FIRST_CHUNK_TREE_OBJECTID);
> +		return -EUCLEAN;
> +	}
> +
> +	if (btrfs_block_group_used(&bgi) > key->offset) {
> +		block_group_err(fs_info, leaf, slot,
> +			"invalid block group used, have %llu expect [0, %llu)",
> +				btrfs_block_group_used(&bgi), key->offset);
> +		return -EUCLEAN;
> +	}
> +
> +	flags = btrfs_block_group_flags(&bgi);
> +	if (hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1) {
> +		block_group_err(fs_info, leaf, slot,
> +"invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 bit set",
> +			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
> +			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));
> +		return -EUCLEAN;
> +	}
> +
> +	type_flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
> +	if (type_flags != BTRFS_BLOCK_GROUP_DATA &&
> +	    type_flags != BTRFS_BLOCK_GROUP_METADATA &&
> +	    type_flags != BTRFS_BLOCK_GROUP_SYSTEM &&
> +	    type_flags != (BTRFS_BLOCK_GROUP_METADATA |
> +			   BTRFS_BLOCK_GROUP_DATA)) {
> +		block_group_err(fs_info, leaf, slot,
> +"invalid type flags, have 0x%llx (%lu bits set) expect either 0x%llx, 0x%llx, 0x%llu or 0x%llx",
> +			type_flags, hweight64(type_flags),
> +			BTRFS_BLOCK_GROUP_DATA, BTRFS_BLOCK_GROUP_METADATA,
> +			BTRFS_BLOCK_GROUP_SYSTEM,
> +			BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA);
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -374,6 +472,9 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
>  	case BTRFS_XATTR_ITEM_KEY:
>  		ret = check_dir_item(fs_info, leaf, key, slot);
>  		break;
> +	case BTRFS_BLOCK_GROUP_ITEM_KEY:
> +		ret = check_block_group_item(fs_info, leaf, key, slot);
> +		break;
>  	}
>  	return ret;
>  }
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e034ad9e23b4..b33bf29130b6 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4690,7 +4690,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
> 
>  	if (type & BTRFS_BLOCK_GROUP_DATA) {
>  		max_stripe_size = SZ_1G;
> -		max_chunk_size = 10 * max_stripe_size;
> +		max_chunk_size = BTRFS_MAX_DATA_CHUNK_SIZE;
>  		if (!devs_max)
>  			devs_max = BTRFS_MAX_DEVS(info);
>  	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 5139ec8daf4c..77e6004b6cb9 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -11,6 +11,8 @@
>  #include <linux/btrfs.h>
>  #include "async-thread.h"
> 
> +#define BTRFS_MAX_DATA_CHUNK_SIZE	(10ULL * SZ_1G)
> +
>  extern struct mutex uuid_mutex;
> 
>  #define BTRFS_STRIPE_LEN	SZ_64K
> --

Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>

> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
