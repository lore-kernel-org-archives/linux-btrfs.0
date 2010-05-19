From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 5/5] Btrfs: do aio_write instead of write
Date: Wed, 19 May 2010 10:41:34 -0400
Message-ID: <20100519144133.GA2316@localhost.localdomain>
References: <1274216747-9450-1-git-send-email-josef@redhat.com> <1274216747-9450-5-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1274216747-9450-5-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 18, 2010 at 05:05:47PM -0400, Josef Bacik wrote:
> In order for AIO to work, we need to implement aio_write.  This patch converts
> our btrfs_file_write to btrfs_aio_write.  I've tested this with xfstests and
> nothing broke, and the AIO stuff magically started working.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/extent_io.c |   11 ++++-
>  fs/btrfs/file.c      |  145 +++++++++++++++++++++++--------------------------
>  2 files changed, 78 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d2d0368..c407f1c 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2020,6 +2020,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
>  	sector_t sector;
>  	struct extent_map *em;
>  	struct block_device *bdev;
> +	struct btrfs_ordered_extent *ordered;
>  	int ret;
>  	int nr = 0;
>  	size_t page_offset = 0;
> @@ -2031,7 +2032,15 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
>  	set_page_extent_mapped(page);
>  
>  	end = page_end;
> -	lock_extent(tree, start, end, GFP_NOFS);
> +	while (1) {
> +		lock_extent(tree, start, end, GFP_NOFS);
> +		ordered = btrfs_lookup_ordered_extent(inode, start);
> +		if (!ordered)
> +			break;
> +		unlock_extent(tree, start, end, GFP_NOFS);
> +		btrfs_start_ordered_extent(inode, ordered, 1);
> +		btrfs_put_ordered_extent(ordered);
> +	}
>  
>  	if (page->index == last_byte >> PAGE_CACHE_SHIFT) {
>  		char *userpage;
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index dace07b..132bd4c 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -46,32 +46,42 @@
>  static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
>  					 int write_bytes,
>  					 struct page **prepared_pages,
> -					 const char __user *buf)
> +					 struct iov_iter *i)
>  {
> -	long page_fault = 0;
> -	int i;
> +	size_t copied;
> +	int pg = 0;
>  	int offset = pos & (PAGE_CACHE_SIZE - 1);
>  
> -	for (i = 0; i < num_pages && write_bytes > 0; i++, offset = 0) {
> +	while (write_bytes > 0) {
>  		size_t count = min_t(size_t,
>  				     PAGE_CACHE_SIZE - offset, write_bytes);
> -		struct page *page = prepared_pages[i];
> -		fault_in_pages_readable(buf, count);
> +		struct page *page = prepared_pages[pg];
> +again:
> +		if (unlikely(iov_iter_fault_in_readable(i, count)))
> +			return -EFAULT;
>  
>  		/* Copy data from userspace to the current page */
> -		kmap(page);
> -		page_fault = __copy_from_user(page_address(page) + offset,
> -					      buf, count);
> +		copied = iov_iter_copy_from_user(page, i, offset, count);
> +
>  		/* Flush processor's dcache for this page */
>  		flush_dcache_page(page);
> -		kunmap(page);
> -		buf += count;
> -		write_bytes -= count;
> +		iov_iter_advance(i, copied);
> +		write_bytes -= copied;
>  
> -		if (page_fault)
> -			break;
> +		if (unlikely(copied == 0)) {
> +			count = min_t(size_t, PAGE_CACHE_SIZE - offset,
> +				      iov_iter_single_seg_count(i));
> +			goto again;
> +		}
> +
> +		if (unlikely(copied < PAGE_CACHE_SIZE - offset)) {
> +			offset += copied;
> +		} else {
> +			pg++;
> +			offset = 0;
> +		}
>  	}
> -	return page_fault ? -EFAULT : 0;
> +	return 0;
>  }
>  
>  /*
> @@ -823,60 +833,24 @@ again:
>  	return 0;
>  }
>  
> -/* Copied from read-write.c */
> -static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
> -{
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> -	if (!kiocbIsKicked(iocb))
> -		schedule();
> -	else
> -		kiocbClearKicked(iocb);
> -	__set_current_state(TASK_RUNNING);
> -}
> -
> -/*
> - * Just a copy of what do_sync_write does.
> - */
> -static ssize_t __btrfs_direct_write(struct file *file, const char __user *buf,
> -				    size_t count, loff_t pos, loff_t *ppos)
> +static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
> +				    const struct iovec *iov,
> +				    unsigned long nr_segs, loff_t pos)
>  {
> -	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = count };
> -	unsigned long nr_segs = 1;
> -	struct kiocb kiocb;
> -	ssize_t ret;
> -
> -	init_sync_kiocb(&kiocb, file);
> -	kiocb.ki_pos = pos;
> -	kiocb.ki_left = count;
> -	kiocb.ki_nbytes = count;
> -
> -	while (1) {
> -		ret = generic_file_direct_write(&kiocb, &iov, &nr_segs, pos,
> -						ppos, count, count);
> -		if (ret != -EIOCBRETRY)
> -			break;
> -		wait_on_retry_sync_kiocb(&kiocb);
> -	}
> -
> -	if (ret == -EIOCBQUEUED)
> -		ret = wait_on_sync_kiocb(&kiocb);
> -	*ppos = kiocb.ki_pos;
> -	return ret;
> -}
> -
> -static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
> -				size_t count, loff_t *ppos)
> -{
> -	loff_t pos;
> +	struct file *file = iocb->ki_filp;
> +	struct inode *inode = fdentry(file)->d_inode;
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct page *pinned[2];
> +	struct page **pages = NULL;
> +	struct iov_iter i;
> +	loff_t *ppos = &iocb->ki_pos;
>  	loff_t start_pos;
>  	ssize_t num_written = 0;
>  	ssize_t err = 0;
> +	size_t count;
> +	size_t ocount;
>  	int ret = 0;
> -	struct inode *inode = fdentry(file)->d_inode;
> -	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	struct page **pages = NULL;
>  	int nrptrs;
> -	struct page *pinned[2];
>  	unsigned long first_index;
>  	unsigned long last_index;
>  	int will_write;
> @@ -888,7 +862,6 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
>  	pinned[0] = NULL;
>  	pinned[1] = NULL;
>  
> -	pos = *ppos;
>  	start_pos = pos;
>  
>  	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> @@ -902,6 +875,11 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
>  
>  	mutex_lock(&inode->i_mutex);
>  
> +	err = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
> +	if (err)
> +		goto out;
> +	count = ocount;
> +
>  	current->backing_dev_info = inode->i_mapping->backing_dev_info;
>  	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
>  	if (err)
> @@ -918,14 +896,28 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
>  	BTRFS_I(inode)->sequence++;
>  
>  	if (unlikely(file->f_flags & O_DIRECT)) {
> -		num_written = __btrfs_direct_write(file, buf, count, pos,
> -						   ppos);
> -		pos += num_written;
> -		count -= num_written;
> +		ret = btrfs_check_data_free_space(root, inode, count);
> +		if (ret)
> +			goto out;
>  
> -		/* We've written everything we wanted to, exit */
> -		if (num_written < 0 || !count)
> +		num_written = generic_file_direct_write(iocb, iov, &nr_segs,
> +							pos, ppos, count,
> +							ocount);
> +
> +		/* All reservations for DIO are done internally */
> +		btrfs_free_reserved_data_space(root, inode, count);
> +
> +		if (num_written > 0)
> +			pos += num_written;
> +			count -= num_written;
> +
> +		if (num_written < 0) {
> +			ret = num_written;
> +			num_written = 0;
>  			goto out;
> +		} else if (!count) {
> +			goto out;
> +		}
>  

Hrm, it looks like this part got munged when I did my git rebase.  I will fix it
up and resubmit.  Thanks,

Josef
