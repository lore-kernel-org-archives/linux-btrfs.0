Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750795AbeFFNZQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 09:25:16 -0400
Date: Wed, 6 Jun 2018 15:22:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: willy@infradead.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: btrfs: Change return type to vm_fault_t
Message-ID: <20180606132228.GF3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180605154635.GA27201@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605154635.GA27201@jordon-HP-15-Notebook-PC>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 09:16:35PM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.
> 
> Ref-> commit 1c8f422059ae ("mm: change return type to vm_fault_t")
> 
> vmf_error() is the newly introduce inline function
> in 4.17-rc6.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>  fs/btrfs/ctree.h |  2 +-
>  fs/btrfs/inode.c | 28 +++++++++++++---------------
>  2 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0d422c9..1f52d9fd 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3218,7 +3218,7 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
>  			 size_t size, struct bio *bio,
>  			 unsigned long bio_flags);
>  void btrfs_set_range_writeback(void *private_data, u64 start, u64 end);
> -int btrfs_page_mkwrite(struct vm_fault *vmf);
> +vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf);
>  int btrfs_readpage(struct file *file, struct page *page);
>  void btrfs_evict_inode(struct inode *inode);
>  int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0b86cf1..20bde86 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8873,7 +8873,7 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
>   * beyond EOF, then the page is guaranteed safe against truncation until we
>   * unlock the page.
>   */
> -int btrfs_page_mkwrite(struct vm_fault *vmf)
> +vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>  {
>  	struct page *page = vmf->page;
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
> @@ -8885,8 +8885,9 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
>  	char *kaddr;
>  	unsigned long zero_start;
>  	loff_t size;
> -	int ret;
> +	int err;

Please use ret2 for the variable name. We're leaving the err/ret naming
pattern and use 'ret' to match the function return value and ret2, ret3
for the temporary return values.

>  	int reserved = 0;
> +	vm_fault_t ret;
>  	u64 reserved_space;
>  	u64 page_start;
>  	u64 page_end;
> @@ -8907,17 +8908,14 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
>  	 * end up waiting indefinitely to get a lock on the page currently
>  	 * being processed by btrfs_page_mkwrite() function.
>  	 */
> -	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
> +	err = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
>  					   reserved_space);
> -	if (!ret) {
> -		ret = file_update_time(vmf->vma->vm_file);
> +	if (!err) {
> +		err = file_update_time(vmf->vma->vm_file);
>  		reserved = 1;
>  	}
> -	if (ret) {
> -		if (ret == -ENOMEM)
> -			ret = VM_FAULT_OOM;
> -		else /* -ENOSPC, -EIO, etc */
> -			ret = VM_FAULT_SIGBUS;
> +	if (err) {
> +		ret = vmf_error(err);
>  		if (reserved)
>  			goto out;
>  		goto out_noreserve;
> @@ -8976,15 +8974,15 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
>  			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
>  			  0, 0, &cached_state);
>  
> -	ret = btrfs_set_extent_delalloc(inode, page_start, end, 0,
> +	err = btrfs_set_extent_delalloc(inode, page_start, end, 0,
>  					&cached_state, 0);
> -	if (ret) {
> +	if (err) {
>  		unlock_extent_cached(io_tree, page_start, page_end,
>  				     &cached_state);
>  		ret = VM_FAULT_SIGBUS;
>  		goto out_unlock;
>  	}
> -	ret = 0;
> +	err = 0;
>  
>  	/* page is wholly or partially inside EOF */
>  	if (page_start + PAGE_SIZE > size)
> @@ -9009,11 +9007,11 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
>  	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
>  
>  out_unlock:
> -	if (!ret) {
> +	if (!err) {
>  		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
>  		sb_end_pagefault(inode->i_sb);
>  		extent_changeset_free(data_reserved);
> -		return VM_FAULT_LOCKED;
> +		ret = VM_FAULT_LOCKED;

That's not a direct change as it changes the code flow and lets the
branch continue. As the error handling and cleanup code is partially
done in this branch continuing wrong AFAICS.

>  	}
>  	unlock_page(page);
>  out:
