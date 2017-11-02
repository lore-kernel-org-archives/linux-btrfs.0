Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbdKBMNB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 08:13:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 44705AC67
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 12:13:00 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Add checker for variable length
 item
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171101121450.6297-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f6ec5a67-95e0-0950-3efa-c9c77ded3b2c@suse.com>
Date: Thu, 2 Nov 2017 14:12:59 +0200
MIME-Version: 1.0
In-Reply-To: <20171101121450.6297-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.11.2017 14:14, Qu Wenruo wrote:
> For the following types, we have items with variable length:
> (With BTRFS_ prefix and _KEY suffix snipped)
> 
> DIR_ITEM
> DIR_INDEX
> XATTR_ITEM
> INODE_REF
> INODE_EXTREF
> ROOT_REF
> ROOT_BACKREF
> 
> They all use @name_len to indicate their name length, and XATTR_ITEM has
> extra @data_len to indicate it data length.
> 
> Despite their variable length, it's also possible to have several such
> structure inside one item.
> 
> This patch will add checker to ensure:
> 
> 1) No structure header and its data cross item boundary
> 2) Except XATTR_ITEM, no structure should have non-zero @data_len
> 
> This checker is especially useful to avoid possible access beyond
> boundary for fuzzed image.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 123 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 123 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 114fc5f0ecc5..f26e86fcbd74 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -222,6 +222,120 @@ static int check_csum_item(struct btrfs_root *root, struct extent_buffer *leaf,
>  	return 0;
>  }
>  
> +static u32 get_header_size(u8 type)
> +{
> +	switch (type) {
> +	case BTRFS_DIR_ITEM_KEY:
> +	case BTRFS_DIR_INDEX_KEY:
> +	case BTRFS_XATTR_ITEM_KEY:
> +		return sizeof(struct btrfs_dir_item);
> +	case BTRFS_INODE_REF_KEY:
> +		return sizeof(struct btrfs_inode_ref);
> +	case BTRFS_INODE_EXTREF_KEY:
> +		return sizeof(struct btrfs_inode_extref);
> +	case BTRFS_ROOT_REF_KEY:
> +	case BTRFS_ROOT_BACKREF_KEY:
> +		return sizeof(struct btrfs_root_ref);
> +	}
> +	WARN_ON(1);
> +	return 0;
> +}
> +
> +static u16 get_header_namelen(struct extent_buffer *leaf, u8 type,
> +			      u32 header_offset)
> +{
> +	/*
> +	 * @header_offset is offset starts after leaf header, while the
> +	 * accessors expects offset starts from leaf header.
> +	 * Sowe need to adds LEAF_DATA_OFFSET here
> +	 */
> +	unsigned long leaf_offset = header_offset + BTRFS_LEAF_DATA_OFFSET;
> +
> +	switch (type) {
> +	case BTRFS_DIR_ITEM_KEY:
> +	case BTRFS_DIR_INDEX_KEY:
> +	case BTRFS_XATTR_ITEM_KEY:
> +		return btrfs_dir_name_len(leaf, (void *)leaf_offset);
> +	case BTRFS_INODE_REF_KEY:
> +		return btrfs_inode_ref_name_len(leaf, (void *)leaf_offset);
> +	case BTRFS_INODE_EXTREF_KEY:
> +		return btrfs_inode_extref_name_len(leaf, (void *)leaf_offset);
> +	case BTRFS_ROOT_REF_KEY:
> +	case BTRFS_ROOT_BACKREF_KEY:
> +		return btrfs_root_ref_name_len(leaf, (void *)leaf_offset);
> +	}
> +	WARN_ON(1);
> +	return 0;
> +}
> +
> +static u16 get_header_datalen(struct extent_buffer *leaf, u8 type,
> +			      unsigned long header_offset)
> +{
> +	/* Same as get_header_namelen */
> +	unsigned long leaf_offset = header_offset + BTRFS_LEAF_DATA_OFFSET;
> +
> +	switch (type) {
> +	case BTRFS_DIR_ITEM_KEY:
> +	case BTRFS_DIR_INDEX_KEY:
> +	case BTRFS_XATTR_ITEM_KEY:
> +		return btrfs_dir_data_len(leaf, (void *)leaf_offset);
> +	}
> +	return 0;
> +}
> +
> +/*
> + * For items with variable length, normally with namelen and tailing data.
> + * Like INODE_REF or XATTR
> + */
> +static int check_variable_length_item(struct btrfs_root *root,
> +				      struct extent_buffer *leaf,
> +				      struct btrfs_key *key, int slot)
> +{

One more thing - you are only validating the boundaries of such variable
length items, so make this specific. I.e rename the function to
something like:

validate_variable_boundaries
check_variable_length_item_boundary
check_item_boundaries

> +	u8 type = key->type;
> +	u32 item_start = btrfs_item_offset_nr(leaf, slot);
> +	u32 item_end = btrfs_item_end_nr(leaf, slot);
> +	u32 header_size = get_header_size(type);
> +	u32 total_size;
> +	u32 cur = item_start;
> +
> +	while (cur < item_end) {
> +		u32 namelen;
> +		u32 datalen;
> +
> +		/* header itself should not cross item boundary */
> +		if (cur + header_size > item_end) {
> +			generic_err(root, leaf, slot,
> +				"structure header crosses item boundary, have %u expect (%u, %u]",
> +				cur + header_size, cur, item_end);
> +			return -EUCLEAN;
> +		}
> +
> +		namelen = get_header_namelen(leaf, type, cur);
> +		datalen = get_header_datalen(leaf, type, cur);
> +
> +		/* Only XATTR can own data */
> +		if (type != BTRFS_XATTR_ITEM_KEY && datalen) {
> +			generic_err(root, leaf, slot,
> +				"item has invalid data len, have %u expect 0",
> +				datalen);
> +			return -EUCLEAN;
> +		}
> +
> +		total_size = header_size + namelen + datalen;
> +
> +		/* header and name/data should not cross item boundary */
> +		if (cur + total_size > item_end) {
> +			generic_err(root, leaf, slot,
> +				"structure data crosses item boundary, have %u expect (%u, %u]",
> +				cur + total_size, cur + header_size, item_end);
> +			return -EUCLEAN;
> +		}
> +
> +		cur += total_size;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -238,6 +352,15 @@ static int check_leaf_item(struct btrfs_root *root,
>  	case BTRFS_EXTENT_CSUM_KEY:
>  		ret = check_csum_item(root, leaf, key, slot);
>  		break;
> +	case BTRFS_DIR_ITEM_KEY:
> +	case BTRFS_XATTR_ITEM_KEY:
> +	case BTRFS_DIR_INDEX_KEY:
> +	case BTRFS_INODE_REF_KEY:
> +	case BTRFS_INODE_EXTREF_KEY:
> +	case BTRFS_ROOT_REF_KEY:
> +	case BTRFS_ROOT_BACKREF_KEY:
> +		ret = check_variable_length_item(root, leaf, key, slot);
> +		break;
>  	}
>  	return ret;
>  }
> 
