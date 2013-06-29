Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41873 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3F2KwR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 06:52:17 -0400
Date: Sat, 29 Jun 2013 18:52:09 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: make backref walking code handle skinny metadata
Message-ID: <20130629105208.GC7849@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1372439578-17151-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372439578-17151-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 28, 2013 at 01:12:58PM -0400, Josef Bacik wrote:
> I missed fixing the backref stuff when I introduced the skinny metadata.  If you
> try and do things like snapshot aware defrag with skinny metadata you are going
> to see tons of warnings related to the backref count being less than 0.  This is
> because the delayed refs will be found for stuff just fine, but it won't find
> the skinny metadata extent refs.  With this patch I'm not seeing warnings
> anymore.  Thanks,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

- liubo

> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/backref.c |   31 +++++++++++++++++++++++++------
>  1 files changed, 25 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 431ea92..eaf1333 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -597,6 +597,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
>  	int slot;
>  	struct extent_buffer *leaf;
>  	struct btrfs_key key;
> +	struct btrfs_key found_key;
>  	unsigned long ptr;
>  	unsigned long end;
>  	struct btrfs_extent_item *ei;
> @@ -614,17 +615,21 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
>  
>  	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
>  	flags = btrfs_extent_flags(leaf, ei);
> +	btrfs_item_key_to_cpu(leaf, &found_key, slot);
>  
>  	ptr = (unsigned long)(ei + 1);
>  	end = (unsigned long)ei + item_size;
>  
> -	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
> +	if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&
> +	    flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
>  		struct btrfs_tree_block_info *info;
>  
>  		info = (struct btrfs_tree_block_info *)ptr;
>  		*info_level = btrfs_tree_block_level(leaf, info);
>  		ptr += sizeof(struct btrfs_tree_block_info);
>  		BUG_ON(ptr > end);
> +	} else if (found_key.type == BTRFS_METADATA_ITEM_KEY) {
> +		*info_level = found_key.offset;
>  	} else {
>  		BUG_ON(!(flags & BTRFS_EXTENT_FLAG_DATA));
>  	}
> @@ -796,8 +801,11 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
>  	INIT_LIST_HEAD(&prefs_delayed);
>  
>  	key.objectid = bytenr;
> -	key.type = BTRFS_EXTENT_ITEM_KEY;
>  	key.offset = (u64)-1;
> +	if (btrfs_fs_incompat(fs_info, SKINNY_METADATA))
> +		key.type = BTRFS_METADATA_ITEM_KEY;
> +	else
> +		key.type = BTRFS_EXTENT_ITEM_KEY;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
> @@ -862,7 +870,8 @@ again:
>  		slot = path->slots[0];
>  		btrfs_item_key_to_cpu(leaf, &key, slot);
>  		if (key.objectid == bytenr &&
> -		    key.type == BTRFS_EXTENT_ITEM_KEY) {
> +		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
> +		     key.type == BTRFS_METADATA_ITEM_KEY)) {
>  			ret = __add_inline_refs(fs_info, path, bytenr,
>  						&info_level, &prefs);
>  			if (ret)
> @@ -1276,12 +1285,16 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
>  {
>  	int ret;
>  	u64 flags;
> +	u64 size = 0;
>  	u32 item_size;
>  	struct extent_buffer *eb;
>  	struct btrfs_extent_item *ei;
>  	struct btrfs_key key;
>  
> -	key.type = BTRFS_EXTENT_ITEM_KEY;
> +	if (btrfs_fs_incompat(fs_info, SKINNY_METADATA))
> +		key.type = BTRFS_METADATA_ITEM_KEY;
> +	else
> +		key.type = BTRFS_EXTENT_ITEM_KEY;
>  	key.objectid = logical;
>  	key.offset = (u64)-1;
>  
> @@ -1294,9 +1307,15 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
>  		return ret;
>  
>  	btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
> -	if (found_key->type != BTRFS_EXTENT_ITEM_KEY ||
> +	if (found_key->type == BTRFS_METADATA_ITEM_KEY)
> +		size = fs_info->extent_root->leafsize;
> +	else if (found_key->type == BTRFS_EXTENT_ITEM_KEY)
> +		size = found_key->offset;
> +
> +	if ((found_key->type != BTRFS_EXTENT_ITEM_KEY &&
> +	     found_key->type != BTRFS_METADATA_ITEM_KEY) ||
>  	    found_key->objectid > logical ||
> -	    found_key->objectid + found_key->offset <= logical) {
> +	    found_key->objectid + size <= logical) {
>  		pr_debug("logical %llu is not within any extent\n",
>  			 (unsigned long long)logical);
>  		return -ENOENT;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
