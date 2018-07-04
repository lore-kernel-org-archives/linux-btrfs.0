Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52346 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932610AbeGDGJW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 02:09:22 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
Date: Wed, 4 Jul 2018 06:09:16 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557BA4@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com>
In-Reply-To: <20180703091009.16399-6-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Tuesday, July 03, 2018 5:10 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH 5/5] btrfs: Verify every chunk has corresponding block group at mount time
> 
> If a crafted btrfs has missing block group items, it could cause
> unexpected behavior and breaks our expectation on 1:1
> chunk<->block group mapping.
> 
> Although we added block group -> chunk mapping check, we still need
> chunk -> block group mapping check.
> 
> This patch will do extra check to ensure each chunk has its
> corresponding block group.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199847
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 52 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 82b446f014b9..746095034ca2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -10038,6 +10038,56 @@ static int check_exist_chunk(struct btrfs_fs_info *fs_info, u64 start, u64 len,
>  	return ret;
>  }
> 
> +/*
> + * Iterate all chunks and verify each of them has corresponding block group
> + */
> +static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
> +{
> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
> +	struct extent_map *em;
> +	struct btrfs_block_group_cache *bg;
> +	u64 start = 0;
> +	int ret = 0;
> +
> +	while (1) {
> +		read_lock(&map_tree->map_tree.lock);
> +		em = lookup_extent_mapping(&map_tree->map_tree, start,
> +					   (u64)-1 - start);
> +		read_unlock(&map_tree->map_tree.lock);
> +		if (!em)
> +			break;
> +
> +		bg = btrfs_lookup_block_group(fs_info, em->start);
> +		if (!bg) {
> +			btrfs_err_rl(fs_info,
> +	"chunk start=%llu len=%llu doesn't have corresponding block group",
> +				     em->start, em->len);
> +			ret = -ENOENT;
> +			free_extent_map(em);
> +			break;
> +		}
> +		if (bg->key.objectid != em->start ||
> +		    bg->key.offset != em->len ||
> +		    (bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK) !=
> +		    (em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> +			btrfs_err_rl(fs_info,
> +"chunk start=%llu len=%llu flags=0x%llx doesn't match with block group start=%llu len=%llu flags=0x%llx",
> +				em->start, em->len,
> +				em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK,
> +				bg->key.objectid, bg->key.offset,
> +				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
> +			ret = -EUCLEAN;
> +			free_extent_map(em);
> +			btrfs_put_block_group(bg);
> +			break;
> +		}
> +		start = em->start + em->len;
> +		free_extent_map(em);
> +		btrfs_put_block_group(bg);
> +	}
> +	return ret;
> +}
> +
>  int btrfs_read_block_groups(struct btrfs_fs_info *info)
>  {
>  	struct btrfs_path *path;
> @@ -10227,7 +10277,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
> 
>  	btrfs_add_raid_kobjects(info);
>  	init_global_block_rsv(info);
> -	ret = 0;
> +	ret = check_chunk_block_group_mappings(info);
>  error:
>  	btrfs_free_path(path);
>  	return ret;
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
