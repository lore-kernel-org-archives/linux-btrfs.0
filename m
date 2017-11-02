Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35419 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752632AbdKBIqX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Nov 2017 04:46:23 -0400
Subject: Re: [PATCH] btrfs: Move leaf verification to correct timing to avoid
 false panic for sanity test
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, lakshmipathi.g@gmail.com
References: <20171102070406.21138-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <590f5b56-9141-442c-751a-63cac7819f6c@suse.com>
Date: Thu, 2 Nov 2017 10:46:21 +0200
MIME-Version: 1.0
In-Reply-To: <20171102070406.21138-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.11.2017 09:04, Qu Wenruo wrote:
> [BUG]
> If we run btrfs with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y, it will
> instantly cause kernel panic like:
> 
> ------
> ...
> assertion failed: 0, file: fs/btrfs/disk-io.c, line: 3853
> ...
> Call Trace:
>  btrfs_mark_buffer_dirty+0x187/0x1f0 [btrfs]
>  setup_items_for_insert+0x385/0x650 [btrfs]
>  __btrfs_drop_extents+0x129a/0x1870 [btrfs]
> ...
> ------
> 
> [Cause]
> Btrfs will call btrfs_check_leaf() in btrfs_mark_buffer_dirty() to check
> if the leaf is valid with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y.
> 
> However some btrfs_mark_buffer_dirty() caller, like
> setup_items_for_insert(), doesn't really initialize its item data but
> only initialize its item pointers, leaving item data uninitialized.
> 
> This makes tree-checker catch uninitialized data as error, causing
> such panic.
> 
> [Fix]
> The correct timing to check leaf validation should be before write IO or
> after read IO.
> 
> Just like ee have already done the tree validation check at btree
> readpage end io hook, this patch will move the write time tree checker to
> csum_dirty_buffer().
> 
> As csum_dirty_buffer() is called just before submitting btree write bio, as
> the call path shows:
> 
> btree_submit_bio_hook()
> |- __btree_submit_bio_start()
>    |- btree_csum_one_bio()
>       |- csum_dirty_buffer()
>          |- btrfs_check_leaf()
> 
> By this we can ensure the leaf passed in is in consistent status, and
> can check them without causing tons of false alert.
> 
> Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>


Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/disk-io.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index efce9a2fa9be..6c17bce2a05e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -506,6 +506,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  	u64 start = page_offset(page);
>  	u64 found_start;
>  	struct extent_buffer *eb;
> +	int ret;
>  
>  	eb = (struct extent_buffer *)page->private;
>  	if (page != eb->pages[0])
> @@ -524,7 +525,24 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  	ASSERT(memcmp_extent_buffer(eb, fs_info->fsid,
>  			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
>  
> -	return csum_tree_block(fs_info, eb, 0);
> +	ret = csum_tree_block(fs_info, eb, 0);
> +	if (ret)
> +		return ret;
> +
> +#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
> +	/*
> +	 * Do extra check before we write the tree block into disk.
> +	 */
> +	if (btrfs_header_level(eb) == 0) {
> +	    ret = btrfs_check_leaf(fs_info->tree_root, eb);
> +	    if (ret) {
> +		btrfs_print_leaf(eb);
> +		ASSERT(0);
> +		return ret;
> +	    }
> +	}
> +#endif
> +	return 0;
>  }
>  
>  static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
> @@ -3847,12 +3865,6 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
>  		percpu_counter_add_batch(&fs_info->dirty_metadata_bytes,
>  					 buf->len,
>  					 fs_info->dirty_metadata_batch);
> -#ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
> -	if (btrfs_header_level(buf) == 0 && btrfs_check_leaf(root, buf)) {
> -		btrfs_print_leaf(buf);
> -		ASSERT(0);
> -	}
> -#endif
>  }
>  
>  static void __btrfs_btree_balance_dirty(struct btrfs_fs_info *fs_info,
> 
