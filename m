Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab3CNXhH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 19:37:07 -0400
Date: Fri, 15 Mar 2013 00:37:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/10] Btrfs-progs: make restore deal with really broken
 file systems
Message-ID: <20130314233705.GA7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
 <1363109897-7931-11-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363109897-7931-11-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 01:38:17PM -0400, Josef Bacik wrote:
> --- a/cmds-restore.c
> +++ b/cmds-restore.c
> @@ -839,27 +839,67 @@ static int do_list_roots(struct btrfs_root *root)
>  static struct btrfs_root *open_fs(const char *dev, u64 root_location,
>  				  int super_mirror, int list_roots)
>  {
> +	struct btrfs_fs_info *fs_info = NULL;
>  	struct btrfs_root *root = NULL;
>  	u64 bytenr;
>  	int i;
>  
>  	for (i = super_mirror; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>  		bytenr = btrfs_sb_offset(i);
> -		root = open_ctree_recovery(dev, bytenr, root_location);
> -		if (root)
> +		fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0, 1);
> +		if (fs_info)
>  			break;
>  		fprintf(stderr, "Could not open root, trying backup super\n");
>  	}
>  
> -	if (root && list_roots) {
> -		int ret = do_list_roots(root);
> -		if (ret) {
> +	if (!fs_info)
> +		return NULL;
> +
> +	/*
> +	 * All we really need to succeed is reading the chunk tree, everything
> +	 * else we can do by hand, since we only need to read the tree root and
> +	 * the fs_root.
> +	 */
> +	if (!extent_buffer_uptodate(fs_info->tree_root->node)) {
> +		u64 generation;
> +
> +		root = fs_info->tree_root;
> +		if (!root_location)
> +			root_location = btrfs_super_root(fs_info->super_copy);
> +		generation = btrfs_super_generation(fs_info->super_copy);
> +		root->node = read_tree_block(root, root_location,
> +					     root->leafsize, generation);
> +		if (!extent_buffer_uptodate(root->node)) {
> +			fprintf(stderr, "Error opening tree root\n");
>  			close_ctree(root);
> +			return NULL;
> +		}
> +	}
> +
> +	if (!list_roots && !fs_info->fs_root) {
> +		struct btrfs_key key;
> +
> +		key.objectid = BTRFS_FS_TREE_OBJECTID;
> +		key.type = BTRFS_ROOT_ITEM_KEY;
> +		key.offset = (u64)-1;
> +		fs_info->fs_root = btrfs_read_fs_root_no_cache(fs_info, &key);
> +		if (IS_ERR(fs_info->fs_root)) {
> +			fprintf(stderr, "Couldn't read fs root: %ld\n",
> +				PTR_ERR(fs_info->fs_root));
> +			close_ctree(fs_info->tree_root);
> +			return NULL;
> +		}
> +	}
> +
> +	if (list_roots) {
> +		int ret = do_list_roots(fs_info->tree_root);
> +		if (ret) {
> +			close_ctree(fs_info->tree_root);
>  			root = NULL;

Setting root to NULL here has no effect, I wonder if this should be
'return NULL' instead, or if it's really ok to return fs_info->fs_root
even after close_ctree() which calls free_fs_roots and other cleanups.


>  		}
>  	}
>  
> -	return root;
> +	return fs_info->fs_root;
>  }
