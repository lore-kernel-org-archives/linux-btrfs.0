Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28521 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbaJ0KOH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 06:14:07 -0400
Message-ID: <544E1B50.1050903@cn.fujitsu.com>
Date: Mon, 27 Oct 2014 18:15:44 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix invalid leaf slot access in btrfs_lookup_extent()
References: <1414401415-27745-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1414401415-27745-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Oct 2014 09:16:55 +0000, Filipe Manana wrote:
> If we couldn't find our extent item, we accessed the current slot
> (path->slots[0]) to check if it corresponds to an equivalent skinny
> metadata item. However this slot could be beyond our last item in the
> leaf (i.e. path->slots[0] >= btrfs_header_nritems(leaf)), in which case
> we shouldn't process it.
> 
> Since btrfs_lookup_extent() is only used to find extent items for data
> extents, fix this by removing completely the logic that looks up for an
> equivalent skinny metadata item, since it can not exist.

I think we also need a better function name, such as btrfs_lookup_data_extent.

Thanks
Miao

> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0d599ba..9141b2b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -710,7 +710,7 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info)
>  	rcu_read_unlock();
>  }
>  
> -/* simple helper to search for an existing extent at a given offset */
> +/* simple helper to search for an existing data extent at a given offset */
>  int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
>  {
>  	int ret;
> @@ -726,12 +726,6 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
>  	key.type = BTRFS_EXTENT_ITEM_KEY;
>  	ret = btrfs_search_slot(NULL, root->fs_info->extent_root, &key, path,
>  				0, 0);
> -	if (ret > 0) {
> -		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> -		if (key.objectid == start &&
> -		    key.type == BTRFS_METADATA_ITEM_KEY)
> -			ret = 0;
> -	}
>  	btrfs_free_path(path);
>  	return ret;
>  }
> 

