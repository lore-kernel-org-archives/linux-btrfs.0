Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52286 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752541AbdEIO7t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 10:59:49 -0400
Date: Tue, 9 May 2017 16:59:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/3] Btrfs: replace tree->mapping with tree->private_data
Message-ID: <20170509145940.GB5491@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1493999835-26731-1-git-send-email-jbacik@fb.com>
 <1493999835-26731-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1493999835-26731-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One comment to the callbacks in extent_io_ops: there are 2 instances of
the callback structure and 2 groups of callbacks. The callbacks that
exist for both instances are in the "mandatory" group and the rest is in
the "optional. As you add set_range_writeback and tree_fs_info to both,
please move them to mandatory and remove any checks if the callback
exists.

On Fri, May 05, 2017 at 11:57:13AM -0400, Josef Bacik wrote:
> @@ -4643,6 +4649,7 @@ static const struct extent_io_ops btree_extent_io_ops = {
>  	/* note we're sharing with inode.c for the merge bio hook */
>  	.merge_bio_hook = btrfs_merge_bio_hook,
>  	.readpage_io_failed_hook = btree_io_failed_hook,
> -
>  	/* optional callbacks */
> +	.set_range_writeback = btrfs_set_range_writeback,
> +	.tree_fs_info = btree_fs_info,

Move to the previous section.

> @@ -154,9 +144,9 @@ static noinline void flush_write_bio(void *data);
>  static inline struct btrfs_fs_info *
>  tree_fs_info(struct extent_io_tree *tree)
>  {
> -	if (!tree->mapping)
> -		return NULL;
> -	return btrfs_sb(tree->mapping->host->i_sb);
> +	if (tree->ops && tree->ops->tree_fs_info)
                         ^^^^^^^^^^^^^^^^^^^^^^^
Dro the check

> +		return tree->ops->tree_fs_info(tree->private_data);
> +	return NULL;
>  }
>  
>  int __init extent_io_init(void)
>  struct io_failure_record;
>  
> -typedef	int (extent_submit_bio_hook_t)(struct inode *inode, struct bio *bio,
> +typedef	int (extent_submit_bio_hook_t)(void *private_data, struct bio *bio,
>  				       int mirror_num, unsigned long bio_flags,
>  				       u64 bio_offset);
>  struct extent_io_ops {
> @@ -108,28 +108,32 @@ struct extent_io_ops {
>  	/*
>  	 * Optional hooks, called if the pointer is not NULL
>  	 */
> -	int (*fill_delalloc)(struct inode *inode, struct page *locked_page,
> +	int (*fill_delalloc)(void *private_data, struct page *locked_page,
>  			     u64 start, u64 end, int *page_started,
>  			     unsigned long *nr_written);
>  
>  	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
>  	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
>  				      struct extent_state *state, int uptodate);
> -	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
> +	void (*set_bit_hook)(void *private_data, struct extent_state *state,
>  			     unsigned *bits);
> -	void (*clear_bit_hook)(struct btrfs_inode *inode,
> +	void (*clear_bit_hook)(void *private_data,
>  			struct extent_state *state,
>  			unsigned *bits);
> -	void (*merge_extent_hook)(struct inode *inode,
> +	void (*merge_extent_hook)(void *private_data,
>  				  struct extent_state *new,
>  				  struct extent_state *other);
> -	void (*split_extent_hook)(struct inode *inode,
> +	void (*split_extent_hook)(void *private_data,
>  				  struct extent_state *orig, u64 split);
> +	void (*check_extent_io_range)(void *private_data, const char *caller,
> +				      u64 start, u64 end);
> +	struct btrfs_fs_info *(*tree_fs_info)(void *private_data);
> +	void (*set_range_writeback)(void *private_data, u64 start, u64 end);

Also move the definitions.

>  };
>  
> @@ -10578,6 +10623,9 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
>  	.clear_bit_hook = btrfs_clear_bit_hook,
>  	.merge_extent_hook = btrfs_merge_extent_hook,
>  	.split_extent_hook = btrfs_split_extent_hook,
> +	.check_extent_io_range = btrfs_check_extent_io_range,
> +	.tree_fs_info = iotree_fs_info,
> +	.set_range_writeback = btrfs_set_range_writeback,

Move to the previous section.

>  };

Otherwise looks ok.
