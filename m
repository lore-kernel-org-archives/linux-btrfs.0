From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Wed, 6 Apr 2011 13:10:38 +0200
Message-ID: <201104061310.38951.johannes.hirte@fem.tu-ilmenau.de>
References: <201104051938.14319.johannes.hirte@fem.tu-ilmenau.de> <201104060000.11403.johannes.hirte@fem.tu-ilmenau.de> <20110405215752.GE484@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110405215752.GE484@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 05 April 2011 23:57:53 Josef Bacik wrote:
> > Now it hit
> 
> Man I cannot catch a break.  I hope this is the last one.  Thanks,
> 
> Josef
> 
> ---
>  fs/btrfs/free-space-cache.c |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 74bc432..b8052be 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -522,6 +522,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  	int bitmaps = 0;
>  	int ret = 0;
>  	bool next_page = false;
> +	bool out_of_space = false;
> 
>  	root = root->fs_info->tree_root;
> 
> @@ -629,6 +630,11 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  			offset = start_offset;
>  		}
> 
> +		if (index > last_index) {
> +			out_of_space = true;
> +			break;
> +		}
> +
>  		page = find_get_page(inode->i_mapping, index);
> 
>  		addr = kmap(page);
> @@ -732,6 +738,10 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  		struct btrfs_free_space *entry =
>  			list_entry(pos, struct btrfs_free_space, list);
> 
> +		if (index > last_index) {
> +			out_of_space = true;
> +			break;
> +		}
>  		page = find_get_page(inode->i_mapping, index);
> 
>  		addr = kmap(page);
> @@ -754,6 +764,28 @@ int btrfs_write_out_cache(struct btrfs_root *root,
>  		index++;
>  	}
> 
> +	if (out_of_space) {
> +		page = find_get_page(inode->i_mapping, 0);
> +
> +		/*
> +		 * Have to do the normal stuff in case writeback gets started on
> +		 * this page before we invalidate it.
> +		 */
> +		ClearPageChecked(page);
> +		set_page_extent_mapped(page);
> +		SetPageUptodate(page);
> +		set_page_dirty(page);
> +		unlock_page(page);
> +		page_cache_release(page);
> +		page_cache_release(page);
> +
> +		ret = 0;
> +		unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
> +				     i_size_read(inode) - 1, &cached_state,
> +				     GFP_NOFS);
> +		goto out_free;
> +	}
> +
>  	/* Zero out the rest of the pages just to make sure */
>  	while (index <= last_index) {
>  		void *addr;

Sorry no, it still hits the BUG() in inode.c (line 1565). It takes longer to 
hit than before but is still reproducible.
