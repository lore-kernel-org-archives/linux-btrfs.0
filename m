From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
Date: Thu, 27 Jan 2011 14:09:27 +0100
Message-ID: <201101271409.27877.johannes.hirte@fem.tu-ilmenau.de>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291887014-18447-1-git-send-email-xin.zhong@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 09 December 2010 10:30:14 Zhong, Xin wrote:
> This problem is found in meego testing:
> http://bugs.meego.com/show_bug.cgi?id=6672
> A file in btrfs is mmaped and the mmaped buffer is passed to pwrite to
> write to the same page of the same file. In btrfs_file_aio_write(), the
> pages is locked by prepare_pages(). So when btrfs_copy_from_user() is
> called, page fault happens and the same page needs to be locked again in
> filemap_fault(). The fix is to move iov_iter_fault_in_readable() before
> prepage_pages() to make page fault happen before pages are locked. And
> also disable page fault in critical region in btrfs_copy_from_user().
> 
> Reviewed-by: Yan, Zheng<zheng.z.yan@intel.com>
> Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
> ---
>  fs/btrfs/file.c |   92
> ++++++++++++++++++++++++++++++++++++------------------- 1 files changed,
> 60 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index c1faded..66836d8 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -48,30 +48,34 @@ static noinline int btrfs_copy_from_user(loff_t pos,
> int num_pages, struct page **prepared_pages,
>  					 struct iov_iter *i)
>  {
> -	size_t copied;
> +	size_t copied = 0;
>  	int pg = 0;
>  	int offset = pos & (PAGE_CACHE_SIZE - 1);
> +	int total_copied = 0;
> 
>  	while (write_bytes > 0) {
>  		size_t count = min_t(size_t,
>  				     PAGE_CACHE_SIZE - offset, write_bytes);
>  		struct page *page = prepared_pages[pg];
> -again:
> -		if (unlikely(iov_iter_fault_in_readable(i, count)))
> -			return -EFAULT;
> -
> -		/* Copy data from userspace to the current page */
> -		copied = iov_iter_copy_from_user(page, i, offset, count);
> +		/*
> +		 * Copy data from userspace to the current page
> +		 *
> +		 * Disable pagefault to avoid recursive lock since
> +		 * the pages are already locked
> +		 */
> +		pagefault_disable();
> +		copied = iov_iter_copy_from_user_atomic(page, i, offset, count);
> +		pagefault_enable();
> 
>  		/* Flush processor's dcache for this page */
>  		flush_dcache_page(page);
>  		iov_iter_advance(i, copied);
>  		write_bytes -= copied;
> +		total_copied += copied;
> 
> +		/* Return to btrfs_file_aio_write to fault page */
>  		if (unlikely(copied == 0)) {
> -			count = min_t(size_t, PAGE_CACHE_SIZE - offset,
> -				      iov_iter_single_seg_count(i));
> -			goto again;
> +			break;
>  		}
> 
>  		if (unlikely(copied < PAGE_CACHE_SIZE - offset)) {
> @@ -81,7 +85,7 @@ again:
>  			offset = 0;
>  		}
>  	}
> -	return 0;
> +	return total_copied;
>  }
> 
>  /*
> @@ -854,6 +858,8 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
>  	unsigned long last_index;
>  	int will_write;
>  	int buffered = 0;
> +	int copied = 0;
> +	int dirty_pages = 0;
> 
>  	will_write = ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
>  		      (file->f_flags & O_DIRECT));
> @@ -970,7 +976,17 @@ static ssize_t btrfs_file_aio_write(struct kiocb
> *iocb, WARN_ON(num_pages > nrptrs);
>  		memset(pages, 0, sizeof(struct page *) * nrptrs);
> 
> -		ret = btrfs_delalloc_reserve_space(inode, write_bytes);
> +		/*
> +		 * Fault pages before locking them in prepare_pages
> +		 * to avoid recursive lock
> +		 */
> +		if (unlikely(iov_iter_fault_in_readable(&i, write_bytes))) {
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		ret = btrfs_delalloc_reserve_space(inode,
> +					num_pages << PAGE_CACHE_SHIFT);
>  		if (ret)
>  			goto out;
> 
> @@ -978,37 +994,49 @@ static ssize_t btrfs_file_aio_write(struct kiocb
> *iocb, pos, first_index, last_index,
>  				    write_bytes);
>  		if (ret) {
> -			btrfs_delalloc_release_space(inode, write_bytes);
> +			btrfs_delalloc_release_space(inode,
> +					num_pages << PAGE_CACHE_SHIFT);
>  			goto out;
>  		}
> 
> -		ret = btrfs_copy_from_user(pos, num_pages,
> +		copied = btrfs_copy_from_user(pos, num_pages,
>  					   write_bytes, pages, &i);
> -		if (ret == 0) {
> +		dirty_pages = (copied + PAGE_CACHE_SIZE - 1) >>
> +					PAGE_CACHE_SHIFT;
> +
> +		if (num_pages > dirty_pages) {
> +			if (copied > 0)
> +				atomic_inc(
> +					&BTRFS_I(inode)->outstanding_extents);
> +			btrfs_delalloc_release_space(inode,
> +					(num_pages - dirty_pages) <<
> +					PAGE_CACHE_SHIFT);
> +		}
> +
> +		if (copied > 0) {
>  			dirty_and_release_pages(NULL, root, file, pages,
> -						num_pages, pos, write_bytes);
> +						dirty_pages, pos, copied);
>  		}
> 
>  		btrfs_drop_pages(pages, num_pages);
> -		if (ret) {
> -			btrfs_delalloc_release_space(inode, write_bytes);
> -			goto out;
> -		}
> 
> -		if (will_write) {
> -			filemap_fdatawrite_range(inode->i_mapping, pos,
> -						 pos + write_bytes - 1);
> -		} else {
> -			balance_dirty_pages_ratelimited_nr(inode->i_mapping,
> -							   num_pages);
> -			if (num_pages <
> -			    (root->leafsize >> PAGE_CACHE_SHIFT) + 1)
> -				btrfs_btree_balance_dirty(root, 1);
> -			btrfs_throttle(root);
> +		if (copied > 0) {
> +			if (will_write) {
> +				filemap_fdatawrite_range(inode->i_mapping, pos,
> +							 pos + copied - 1);
> +			} else {
> +				balance_dirty_pages_ratelimited_nr(
> +							inode->i_mapping,
> +							dirty_pages);
> +				if (dirty_pages <
> +				(root->leafsize >> PAGE_CACHE_SHIFT) + 1)
> +					btrfs_btree_balance_dirty(root, 1);
> +				btrfs_throttle(root);
> +			}
>  		}
> 
> -		pos += write_bytes;
> -		num_written += write_bytes;
> +		pos += copied;
> +		num_written += copied;
> 
>  		cond_resched();
>  	}

This patch breaks one of my Gentoo boxes. When I try to install/update via 
emerge, some packages hang. It seems that it's always a "svn info" process 
that is stuck in kernel eating 100% CPU. I don't know how svn is involved 
here, but reverting this patch makes the system work again. I'll try to get a 
simple testcase.

regards,
  Johannes
