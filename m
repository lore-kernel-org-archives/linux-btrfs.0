Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29759 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752490AbcFCO6E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jun 2016 10:58:04 -0400
Subject: Re: [PATCH v10 18/21] btrfs: dedupe: Add support for on-disk hash
 search
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-19-git-send-email-quwenruo@cn.fujitsu.com>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <6f76099c-6ca8-ad85-701b-5b39c3864d31@fb.com>
Date: Fri, 3 Jun 2016 10:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <1459492512-31435-19-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/01/2016 02:35 AM, Qu Wenruo wrote:
> Now on-disk backend should be able to search hash now.
>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/dedupe.c | 167 ++++++++++++++++++++++++++++++++++++++++++++++++------
>  fs/btrfs/dedupe.h |   1 +
>  2 files changed, 151 insertions(+), 17 deletions(-)
>
> diff --git a/fs/btrfs/dedupe.c b/fs/btrfs/dedupe.c
> index a274c1c..00f2a01 100644
> --- a/fs/btrfs/dedupe.c
> +++ b/fs/btrfs/dedupe.c
> @@ -652,6 +652,112 @@ int btrfs_dedupe_disable(struct btrfs_fs_info *fs_info)
>  }
>
>  /*
> + * Compare ondisk hash with src.
> + * Return 0 if hash matches.
> + * Return non-zero for hash mismatch
> + *
> + * Caller should ensure the slot contains a valid hash item.
> + */
> +static int memcmp_ondisk_hash(const struct btrfs_key *key,
> +			      struct extent_buffer *node, int slot,
> +			      int hash_len, const u8 *src)
> +{
> +	u64 offset;
> +	int ret;
> +
> +	/* Return value doesn't make sense in this case though */
> +	if (WARN_ON(hash_len <= 8 || key->type != BTRFS_DEDUPE_HASH_ITEM_KEY))

No magic numbers please.

> +		return -EINVAL;
> +
> +	/* compare the hash exlcuding the last 64 bits */
> +	offset = btrfs_item_ptr_offset(node, slot);
> +	ret = memcmp_extent_buffer(node, src, offset, hash_len - 8);
> +	if (ret)
> +		return ret;
> +	return memcmp(&key->objectid, src + hash_len - 8, 8);
> +}
> +
> + /*
> + * Return 0 for not found
> + * Return >0 for found and set bytenr_ret
> + * Return <0 for error
> + */
> +static int ondisk_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash,
> +			      u64 *bytenr_ret, u32 *num_bytes_ret)
> +{
> +	struct btrfs_path *path;
> +	struct btrfs_key key;
> +	struct btrfs_root *dedupe_root = dedupe_info->dedupe_root;
> +	u8 *buf = NULL;
> +	u64 hash_key;
> +	int hash_len = btrfs_dedupe_sizes[dedupe_info->hash_type];
> +	int ret;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	buf = kmalloc(hash_len, GFP_NOFS);
> +	if (!buf) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	memcpy(&hash_key, hash + hash_len - 8, 8);
> +	key.objectid = hash_key;
> +	key.type = BTRFS_DEDUPE_HASH_ITEM_KEY;
> +	key.offset = (u64)-1;
> +
> +	ret = btrfs_search_slot(NULL, dedupe_root, &key, path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	WARN_ON(ret == 0);
> +	while (1) {
> +		struct extent_buffer *node;
> +		struct btrfs_dedupe_hash_item *hash_item;
> +		int slot;
> +
> +		ret = btrfs_previous_item(dedupe_root, path, hash_key,
> +					  BTRFS_DEDUPE_HASH_ITEM_KEY);
> +		if (ret < 0)
> +			break;
> +		if (ret > 0) {
> +			ret = 0;
> +			break;
> +		}
> +
> +		node = path->nodes[0];
> +		slot = path->slots[0];
> +		btrfs_item_key_to_cpu(node, &key, slot);
> +
> +		/*
> +		 * Type of objectid mismatch means no previous item may
> +		 * hit, exit searching
> +		 */
> +		if (key.type != BTRFS_DEDUPE_HASH_ITEM_KEY ||
> +		    memcmp(&key.objectid, &hash_key, 8))
> +			break;
> +		hash_item = btrfs_item_ptr(node, slot,
> +				struct btrfs_dedupe_hash_item);
> +		/*
> +		 * If the hash mismatch, it's still possible that previous item
> +		 * has the desired hash.
> +		 */
> +		if (memcmp_ondisk_hash(&key, node, slot, hash_len, hash))
> +			continue;
> +		/* Found */
> +		ret = 1;
> +		*bytenr_ret = key.offset;
> +		*num_bytes_ret = dedupe_info->blocksize;
> +		break;
> +	}
> +out:
> +	kfree(buf);
> +	btrfs_free_path(path);
> +	return ret;
> +}
> +
> +/*
>   * Caller must ensure the corresponding ref head is not being run.
>   */
>  static struct inmem_hash *
> @@ -681,9 +787,36 @@ inmem_search_hash(struct btrfs_dedupe_info *dedupe_info, u8 *hash)
>  	return NULL;
>  }
>
> -static int inmem_search(struct btrfs_dedupe_info *dedupe_info,
> -			struct inode *inode, u64 file_pos,
> -			struct btrfs_dedupe_hash *hash)
> +/* Wapper for different backends, caller needs to hold dedupe_info->lock */
> +static inline int generic_search_hash(struct btrfs_dedupe_info *dedupe_info,
> +				      u8 *hash, u64 *bytenr_ret,
> +				      u32 *num_bytes_ret)
> +{
> +	if (dedupe_info->backend == BTRFS_DEDUPE_BACKEND_INMEMORY) {
> +		struct inmem_hash *found_hash;
> +		int ret;
> +
> +		found_hash = inmem_search_hash(dedupe_info, hash);
> +		if (found_hash) {
> +			ret = 1;
> +			*bytenr_ret = found_hash->bytenr;
> +			*num_bytes_ret = found_hash->num_bytes;
> +		} else {
> +			ret = 0;
> +			*bytenr_ret = 0;
> +			*num_bytes_ret = 0;

Why set it to 0 only in the INMEMORY case?  If they need to be zero'ed 
perhaps do it at the start of the helper?  Thanks,

Josef
