Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752689AbeGBH2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 03:28:38 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10D98AD1E
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 07:28:37 +0000 (UTC)
Subject: Re: [PATCH] btrfs: tree-checker: Verify block_group_item
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180702055348.25623-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a317cbc6-8352-9ab2-eb46-cef094d3fd99@suse.com>
Date: Mon, 2 Jul 2018 10:28:35 +0300
MIME-Version: 1.0
In-Reply-To: <20180702055348.25623-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.07.2018 08:53, Qu Wenruo wrote:
> As reported in https://bugzilla.kernel.org/show_bug.cgi?id=199849,
> a crafted image with invalid block group items could make free space cache
> code to cause panic.
> 
> We could early detect such invalid block group item by checking:
> 1) Size (key)
>    We have a up limit on block group item (10G)
> 2) Chunk objectid
> 3) Type
>    Exactly 1 bit set for type and no more than 1 bit set for profile
> 4) Used space
>    No more than block group size.
> 
> This should allow btrfs to detect and refuse to mount the crafted image.
> 
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 88 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 8d40e7dd8c30..a42187ba50d7 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -353,6 +353,91 @@ static int check_dir_item(struct btrfs_fs_info *fs_info,
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
Seems it's not mandatory that this extent buffer points to a leaf, it
might very well point to an interim node (judging from the
btrfs_header_level() check in block_group_err). I'd suggest you use the
more neutral - eb .
> +				  struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_block_group_item bgi;
> +	u32 item_size = btrfs_item_size_nr(leaf, slot);
> +	u64 flags;
> +
> +	/*
> +	 * Here we don't really care about unalignment since extent allocator
> +	 * can handle it.
> +	 * We care more about the size, as if one block group is larger than
> +	 * maximum size, it's must be some obvious corruption
> +	 */
> +	if (key->offset > 10ULL * SZ_1G) {
> +		block_group_err(fs_info, leaf, slot,
> +			"invalid block group size, have %llu expect (0, %llu)",
> +				key->offset, 10ULL * SZ_1G);
> +		return -EUCLEAN;
> +	}

Put an empty line after each if to distinguish each part more easily.

> +	if (item_size != sizeof(bgi)) {
> +		block_group_err(fs_info, leaf, slot,
> +			"invalid item size, have %u expect %lu",
> +				item_size, sizeof(bgi));
> +		return -EUCLEAN;
> +	}
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
> +	if (btrfs_block_group_used(&bgi) > key->offset) {
> +		block_group_err(fs_info, leaf, slot,
> +			"invalid block group used, have %llu expect [0, %llu)",
> +				btrfs_block_group_used(&bgi), key->offset);
> +		return -EUCLEAN;
> +	}
> +	flags = btrfs_block_group_flags(&bgi);
> +	if (!((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 ||
> +	      hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 1)) {

Can you make this condition a bit more stupid like:

if ((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 ||
hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) > 1)

It's easy to miss the ! right before the two (( and it causes a mild
head scratch :)

> +		block_group_err(fs_info, leaf, slot,
> +"invalid profile flags, have 0x%llx (%lu bits set) expect no more than 1 bit set",
> +			flags & BTRFS_BLOCK_GROUP_PROFILE_MASK,
> +			hweight64(flags & BTRFS_BLOCK_GROUP_PROFILE_MASK));
> +		return -EUCLEAN;
> +	}
> +	if (hweight64(flags & BTRFS_BLOCK_GROUP_TYPE_MASK) != 1) {
> +		block_group_err(fs_info, leaf, slot,
> +"invalid type flags, have 0x%llx (%lu bits set) expect exactly 1 bit set",
> +			flags & BTRFS_BLOCK_GROUP_TYPE_MASK,
> +			hweight64(flags & BTRFS_BLOCK_GROUP_TYPE_MASK));
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -374,6 +459,9 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
>  	case BTRFS_XATTR_ITEM_KEY:
>  		ret = check_dir_item(fs_info, leaf, key, slot);
>  		break;
> +	case BTRFS_BLOCK_GROUP_ITEM_KEY:
> +		ret = check_block_group_item(fs_info, leaf, key, slot);
> +		break;
>  	}
>  	return ret;
>  }
> 
