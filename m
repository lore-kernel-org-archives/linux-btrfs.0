Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:34376 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab3HHHXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 03:23:08 -0400
Message-ID: <5203475A.9070705@jan-o-sch.net>
Date: Thu, 08 Aug 2013 09:23:06 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: stop using GFP_ATOMIC when allocating rewind ebs
References: <1375909909-25955-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1375909909-25955-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
On Wed, August 07, 2013 at 23:11 (+0200), Josef Bacik wrote:
> There is no reason we can't just set the path to blocking and then do normal
> GFP_NOFS allocations for these extent buffers.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/ctree.c     |   16 ++++++++++------
>  fs/btrfs/extent_io.c |    8 ++++----
>  2 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 1dd8a71..414a2d7 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1191,8 +1191,8 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>   * is freed (its refcount is decremented).
>   */
>  static struct extent_buffer *
> -tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> -		    u64 time_seq)
> +tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
> +		    struct extent_buffer *eb, u64 time_seq)
>  {
>  	struct extent_buffer *eb_rewin;
>  	struct tree_mod_elem *tm;
> @@ -1207,12 +1207,15 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  	if (!tm)
>  		return eb;
>  
> +	btrfs_set_path_blocking(path);
> +	btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> +
>  	if (tm->op == MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
>  		BUG_ON(tm->slot != 0);
>  		eb_rewin = alloc_dummy_extent_buffer(eb->start,
>  						fs_info->tree_root->nodesize);
>  		if (!eb_rewin) {
> -			btrfs_tree_read_unlock(eb);
> +			btrfs_tree_read_unlock_blocking(eb);
>  			free_extent_buffer(eb);
>  			return NULL;
>  		}
> @@ -1224,13 +1227,14 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  	} else {
>  		eb_rewin = btrfs_clone_extent_buffer(eb);
>  		if (!eb_rewin) {
> -			btrfs_tree_read_unlock(eb);
> +			btrfs_tree_read_unlock_blocking(eb);
>  			free_extent_buffer(eb);
>  			return NULL;
>  		}
>  	}
>  
> -	btrfs_tree_read_unlock(eb);
> +	btrfs_clear_path_blocking(path, NULL, BTRFS_READ_LOCK);
> +	btrfs_tree_read_unlock_blocking(eb);

unlock_blocking? Rest looks ok to me.

Thanks,
-Jan

>  	free_extent_buffer(eb);
>  
>  	extent_buffer_get(eb_rewin);
> @@ -2779,7 +2783,7 @@ again:
>  				btrfs_clear_path_blocking(p, b,
>  							  BTRFS_READ_LOCK);
>  			}
> -			b = tree_mod_log_rewind(root->fs_info, b, time_seq);
> +			b = tree_mod_log_rewind(root->fs_info, p, b, time_seq);
>  			if (!b) {
>  				ret = -ENOMEM;
>  				goto done;
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b422cba..beda5a8 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4340,12 +4340,12 @@ struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src)
>  	struct extent_buffer *new;
>  	unsigned long num_pages = num_extent_pages(src->start, src->len);
>  
> -	new = __alloc_extent_buffer(NULL, src->start, src->len, GFP_ATOMIC);
> +	new = __alloc_extent_buffer(NULL, src->start, src->len, GFP_NOFS);
>  	if (new == NULL)
>  		return NULL;
>  
>  	for (i = 0; i < num_pages; i++) {
> -		p = alloc_page(GFP_ATOMIC);
> +		p = alloc_page(GFP_NOFS);
>  		if (!p) {
>  			btrfs_release_extent_buffer(new);
>  			return NULL;
> @@ -4369,12 +4369,12 @@ struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len)
>  	unsigned long num_pages = num_extent_pages(0, len);
>  	unsigned long i;
>  
> -	eb = __alloc_extent_buffer(NULL, start, len, GFP_ATOMIC);
> +	eb = __alloc_extent_buffer(NULL, start, len, GFP_NOFS);
>  	if (!eb)
>  		return NULL;
>  
>  	for (i = 0; i < num_pages; i++) {
> -		eb->pages[i] = alloc_page(GFP_ATOMIC);
> +		eb->pages[i] = alloc_page(GFP_NOFS);
>  		if (!eb->pages[i])
>  			goto err;
>  	}
> 
