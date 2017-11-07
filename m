Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:46939 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753018AbdKGCas (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 21:30:48 -0500
Subject: Re: [PATCH 2/3] btrfs: tree-checker: Add checker for dir item
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, <lakshmipathi.g@gmail.com>
References: <20171106092013.4465-1-wqu@suse.com>
 <20171106092013.4465-3-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <591e717f-45a4-3223-7bc7-976024e3e71e@cn.fujitsu.com>
Date: Tue, 7 Nov 2017 10:34:15 +0800
MIME-Version: 1.0
In-Reply-To: <20171106092013.4465-3-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/06/2017 05:20 PM, Qu Wenruo wrote:
> Add checker for dir item, for key types DIR_ITEM, DIR_INDEX and
> XATTR_ITEM.
> 
> This checker does comprehensive check for:
> 1) dir_item header and its data size
>     Against item boundary and maximum name/xattr length.
>     This part is mostly the same as old verify_dir_item().
> 
> 2) dir_type
>     Against maximum file types, and against key type.
>     Since XATTR key should only have FT_XATTR dir item, and normal dir
>     item type should not have XATTR key.
> 
>     The check between key->type and dir_type is newly introduced by this
>     patch.
> 
> 3) name hash
>     For XATTR and DIR_ITEM key, key->offset is name hash (crc32).
>     Check the hash of name against key to ensure it's correct.
> 
>     The name hash check is only found in btrfs-progs before this patch.
> 

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/tree-checker.c | 141 ++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 141 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index a4c2517fa2a1..9644c9616f95 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -30,6 +30,7 @@
>   #include "tree-checker.h"
>   #include "disk-io.h"
>   #include "compression.h"
> +#include "hash.h"
>   
>   /*
>    * Error message should follow the following format:
> @@ -222,6 +223,141 @@ static int check_csum_item(struct btrfs_root *root, struct extent_buffer *leaf,
>   	return 0;
>   }
>   
> +/*
> + * Customized reported for dir_item, only important new info is key->objectid,
> + * which represents inode number
> + */
> +__printf(4, 5)
> +static void dir_item_err(const struct btrfs_root *root,
> +			 const struct extent_buffer *eb, int slot,
> +			 const char *fmt, ...)
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
> +	btrfs_crit(root->fs_info,
> +	"corrupt %s: root=%llu block=%llu slot=%d ino=%llu, %pV",
> +		btrfs_header_level(eb) == 0 ? "leaf" : "node", root->objectid,
> +		btrfs_header_bytenr(eb), slot, key.objectid, &vaf);
> +	va_end(args);
> +}
> +
> +static int check_dir_item(struct btrfs_root *root,
> +			  struct extent_buffer *leaf,
> +			  struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_dir_item *di;
> +	u32 item_size = btrfs_item_size_nr(leaf, slot);
> +	u32 cur = 0;
> +
> +	di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
> +	while (cur < item_size) {
> +		char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
> +		u32 name_len;
> +		u32 data_len;
> +		u32 max_name_len;
> +		u32 total_size;
> +		u32 name_hash;
> +		u8 dir_type;
> +
> +		/* header itself should not cross item boundary */
> +		if (cur + sizeof(*di) > item_size) {
> +			dir_item_err(root, leaf, slot,
> +				"dir item header crosses item boundary, have %lu expect (%u, %u]",
> +				cur + sizeof(*di), cur, item_size);
> +			return -EUCLEAN;
> +		}
> +
> +		/* dir type check */
> +		dir_type = btrfs_dir_type(leaf, di);
> +		if (dir_type >= BTRFS_FT_MAX) {
> +			dir_item_err(root, leaf, slot,
> +				"invalid dir item type, have %u expect [0, %u)",
> +				dir_type, BTRFS_FT_MAX);
> +			return -EUCLEAN;
> +		}
> +
> +		if (key->type == BTRFS_XATTR_ITEM_KEY &&
> +		    dir_type != BTRFS_FT_XATTR) {
> +			dir_item_err(root, leaf, slot,
> +				"invalid dir item type for XATTR key, have %u expect %u",
> +				dir_type, BTRFS_FT_XATTR);
> +			return -EUCLEAN;
> +		}
> +		if (dir_type == BTRFS_FT_XATTR &&
> +		    key->type != BTRFS_XATTR_ITEM_KEY) {
> +			dir_item_err(root, leaf, slot,
> +				"xattr dir type found for non-XATTR key");
> +			return -EUCLEAN;
> +		}
> +		if (dir_type == BTRFS_FT_XATTR)
> +			max_name_len = XATTR_NAME_MAX;
> +		else
> +			max_name_len = BTRFS_NAME_LEN;
> +
> +		/* Name/data length check */
> +		name_len = btrfs_dir_name_len(leaf, di);
> +		data_len = btrfs_dir_data_len(leaf, di);
> +		if (name_len > max_name_len) {
> +			dir_item_err(root, leaf, slot,
> +				"dir item name len too long, have %u expect (0, %u]",
> +				name_len, max_name_len);
> +			return -EUCLEAN;
> +		}
> +		if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root->fs_info)) {
> +			dir_item_err(root, leaf, slot,
> +				"dir item name and data len too long, have %u expect (0, %u)",
> +				name_len + data_len,
> +				BTRFS_MAX_XATTR_SIZE(root->fs_info));
> +			return -EUCLEAN;
> +		}
> +
> +		if (data_len && dir_type != BTRFS_FT_XATTR) {
> +			dir_item_err(root, leaf, slot,
> +				"dir item with invalid data len, have %u expect 0",
> +				data_len);
> +			return -EUCLEAN;
> +		}
> +
> +		total_size = sizeof(*di) + name_len + data_len;
> +
> +		/* header and name/data should not cross item boundary */
> +		if (cur + total_size > item_size) {
> +			dir_item_err(root, leaf, slot,
> +				"dir item data crosses item boundary, have %u expect (%lu, %u]",
> +				cur + total_size, cur + sizeof(*di), item_size);
> +			return -EUCLEAN;
> +		}
> +
> +		/*
> +		 * Special check for XATTR/DIR_ITEM, as key->offset is name
> +		 * hash, should match its name
> +		 */
> +		if (key->type == BTRFS_DIR_ITEM_KEY ||
> +		    key->type == BTRFS_XATTR_ITEM_KEY) {
> +			read_extent_buffer(leaf, namebuf,
> +					(unsigned long)(di + 1), name_len);
> +			name_hash = btrfs_name_hash(namebuf, name_len);
> +			if (key->offset != name_hash) {
> +				dir_item_err(root, leaf, slot,
> +					"name hash mismatch with key, have 0x%016x expect 0x%016llx",
> +					name_hash, key->offset);
> +				return -EUCLEAN;
> +			}
> +		}
> +		cur += total_size;
> +		di = (struct btrfs_dir_item *)((void *)di + total_size);
> +	}
> +	return 0;
> +}
> +
>   /*
>    * Common point to switch the item-specific validation.
>    */
> @@ -238,6 +374,11 @@ static int check_leaf_item(struct btrfs_root *root,
>   	case BTRFS_EXTENT_CSUM_KEY:
>   		ret = check_csum_item(root, leaf, key, slot);
>   		break;
> +	case BTRFS_DIR_ITEM_KEY:
> +	case BTRFS_DIR_INDEX_KEY:
> +	case BTRFS_XATTR_ITEM_KEY:
> +		ret = check_dir_item(root, leaf, key, slot);
> +		break;
>   	}
>   	return ret;
>   }
> 


