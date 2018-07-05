Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753604AbeGEPSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 11:18:07 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ACEC4AD12
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 15:18:06 +0000 (UTC)
Date: Thu, 5 Jul 2018 17:18:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
Message-ID: <20180705151804.GH3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180703091009.16399-6-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 05:10:09PM +0800, Qu Wenruo wrote:
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

This needs a comment.

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

-EUCLEAN ?

> +			free_extent_map(em);
> +			break;
> +		}
> +		if (bg->key.objectid != em->start ||
> +		    bg->key.offset != em->len ||
> +		    (bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK) !=
> +		    (em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> +			btrfs_err_rl(fs_info,

Why is this ratelmited? I'd understand that a fuzzed image will spew a
lot of these errors but for a normal case, it should be ok to print all
the messages.

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
> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
