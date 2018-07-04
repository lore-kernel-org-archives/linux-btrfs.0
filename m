Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15994 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932270AbeGDFpZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 01:45:25 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 4/5] btrfs: Check each block group has corresponding
 chunk at mount time
Date: Wed, 4 Jul 2018 05:45:20 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557B53@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-5-wqu@suse.com>
In-Reply-To: <20180703091009.16399-5-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Tuesday, July 03, 2018 5:10 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH 4/5] btrfs: Check each block group has corresponding chunk at mount time
> 
> A crafted btrfs with incorrect chunk<->block group mapping, it could leads
> to a lot of unexpected behavior.
> 
> Although the crafted image can be catched by block group item checker
> added in "[PATCH] btrfs: tree-checker: Verify block_group_item", if one
> crafted a valid enough block group item which can pass above check but
> still mismatch with existing chunk, it could cause a lot of undefined
> behavior.
> 
> This patch will add extra block group -> chunk mapping check, to ensure
> we have a completely matching (start, len, flags) chunk for each block
> group at mount time.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199837
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 55 ++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3d9fe58c0080..82b446f014b9 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10003,6 +10003,41 @@ btrfs_create_block_group_cache(struct btrfs_fs_info *fs_info,
>  	return cache;
>  }
> 
> +static int check_exist_chunk(struct btrfs_fs_info *fs_info, u64 start, u64 len,
> +			     u64 flags)
> +{
> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
> +	struct extent_map *em;
> +	int ret;
> +
> +	read_lock(&map_tree->map_tree.lock);
> +	em = lookup_extent_mapping(&map_tree->map_tree, start, len);
> +	read_unlock(&map_tree->map_tree.lock);
> +
> +	if (!em) {
> +		btrfs_err_rl(fs_info,
> +	"block group start=%llu len=%llu doesn't have corresponding chunk",
> +			     start, len);
> +		ret = -ENOENT;
> +		goto out;
> +	}

This check has been done in find_first_block_group which has been called before
check_exist_chunk be called.

> +	if (em->start != start || em->len != len ||
> +	    (em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK) !=
> +	    (flags & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> +		btrfs_err_rl(fs_info,
> +"block group start=%llu len=%llu flags=0x%llx doesn't match with chunk start=%llu len=%llu flags=0x%llx",
> +			     start, len , flags & BTRFS_BLOCK_GROUP_TYPE_MASK,
> +			     em->start, em->len, em->map_lookup->type &
> +			     BTRFS_BLOCK_GROUP_TYPE_MASK);
> +		ret = -EUCLEAN;
> +		goto out;
> +	}
Should this check also be added to find_first_block_group?

> +	ret = 0;
> +out:
> +	free_extent_map(em);
> +	return ret;
> +}
> +
>  int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  {
>  	struct btrfs_path *path;
> @@ -10036,6 +10071,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  		need_clear = 1;
> 
>  	while (1) {
> +		struct btrfs_block_group_item bg;
> +		int slot;
> +
>  		ret = find_first_block_group(info, path, &key);
>  		if (ret > 0)
>  			break;
> @@ -10043,7 +10081,20 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  			goto error;
> 
>  		leaf = path->nodes[0];
> -		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
> +		slot = path->slots[0];
> +		btrfs_item_key_to_cpu(leaf, &found_key, slot);
> +
> +		read_extent_buffer(leaf, &bg, btrfs_item_ptr_offset(leaf, slot),
> +				   sizeof(bg));
> +		/*
> +		 * Chunk and block group must have 1:1 mapping.
> +		 * So there must be a chunk for this block group.
> +		 */
> +		ret = check_exist_chunk(info, found_key.objectid,
> +					found_key.offset,
> +					btrfs_block_group_flags(&bg));
> +		if (ret < 0)
> +			goto error;
> 
>  		cache = btrfs_create_block_group_cache(info, found_key.objectid,
>  						       found_key.offset);
> @@ -10068,7 +10119,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  		}
> 
>  		read_extent_buffer(leaf, &cache->item,
> -				   btrfs_item_ptr_offset(leaf, path->slots[0]),
> +				   btrfs_item_ptr_offset(leaf, slot),
>  				   sizeof(cache->item));
>  		cache->flags = btrfs_block_group_flags(&cache->item);
>  		if (!mixed &&
> --
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
