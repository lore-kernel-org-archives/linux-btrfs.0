Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34816 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3FABBH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 21:01:07 -0400
Date: Sat, 1 Jun 2013 09:59:33 +0900
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: init relocate extent_io_tree with a mapping
Message-ID: <20130601005932.GB20727@liubo.sigma3.com.sg>
Reply-To: bo.li.liu@oracle.com
References: <1370020005-3157-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370020005-3157-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 31, 2013 at 01:06:45PM -0400, Josef Bacik wrote:
> Dave reported a NULL pointer deref.  This is caused because he thought he'd be
> smart and add sanity checks to the extent_io bit operations, but he didn't
> expect a tree to have a NULL mapping.  To fix this we just need to init the
> relocation's processed_blocks with the btree_inode->i_mapping.  Thanks,

That fits my suspection, hhh.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Reported-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/relocation.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 6dbee86..1b50c41 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4081,7 +4081,7 @@ out:
>  	return inode;
>  }
>  
> -static struct reloc_control *alloc_reloc_control(void)
> +static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
>  {
>  	struct reloc_control *rc;
>  
> @@ -4092,7 +4092,8 @@ static struct reloc_control *alloc_reloc_control(void)
>  	INIT_LIST_HEAD(&rc->reloc_roots);
>  	backref_cache_init(&rc->backref_cache);
>  	mapping_tree_init(&rc->reloc_root_tree);
> -	extent_io_tree_init(&rc->processed_blocks, NULL);
> +	extent_io_tree_init(&rc->processed_blocks,
> +			    fs_info->btree_inode->i_mapping);
>  	return rc;
>  }
>  
> @@ -4109,7 +4110,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
>  	int rw = 0;
>  	int err = 0;
>  
> -	rc = alloc_reloc_control();
> +	rc = alloc_reloc_control(fs_info);
>  	if (!rc)
>  		return -ENOMEM;
>  
> @@ -4310,7 +4311,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
>  	if (list_empty(&reloc_roots))
>  		goto out;
>  
> -	rc = alloc_reloc_control();
> +	rc = alloc_reloc_control(root->fs_info);
>  	if (!rc) {
>  		err = -ENOMEM;
>  		goto out;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
