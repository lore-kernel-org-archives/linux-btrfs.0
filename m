Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab3EXOFk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 10:05:40 -0400
Date: Fri, 24 May 2013 16:05:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <josef@redhat.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
Message-ID: <20130524140536.GQ5187@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1369160908-26195-1-git-send-email-mfasheh@suse.de>
 <1369160908-26195-5-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369160908-26195-5-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 21, 2013 at 11:28:28AM -0700, Mark Fasheh wrote:
> +static noinline int fill_data(struct inode *inode, u64 off, u64 len,
> +			      char **cur_buffer)
> +{
> +	struct page *page;
> +	void *addr;
> +	char *buffer;
> +	pgoff_t index;
> +	pgoff_t last_index;
> +	int ret = 0;
> +	int bytes_copied = 0;
> +	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
> +
> +	buffer = kmalloc(len, GFP_NOFS);

I've looked at the caller chain and len can be as big as 1MB, this is
likely to fail to allocate. More comments below.

> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	index = off >> PAGE_CACHE_SHIFT;
> +	last_index = (off + len - 1) >> PAGE_CACHE_SHIFT;
> +
> +	while (index <= last_index) {
> +		page = grab_cache_page(inode->i_mapping, index);
> +		if (!page) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		if (!PageUptodate(page)) {
> +			extent_read_full_page_nolock(tree, page,
> +						     btrfs_get_extent, 0);
> +			lock_page(page);
> +			if (!PageUptodate(page)) {
> +				unlock_page(page);
> +				page_cache_release(page);
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +		}
> +
> +		addr = kmap(page);
> +		memcpy(buffer + bytes_copied, addr, PAGE_CACHE_SIZE);
> +		kunmap(page);
> +		unlock_page(page);
> +		page_cache_release(page);
> +		bytes_copied += PAGE_CACHE_SIZE;
> +		index++;
> +	}
> +
> +	*cur_buffer = buffer;
> +
> +out:
> +	if (ret)
> +		kfree(buffer);
> +	return ret;
> +}
> +
>  static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
>  {
>  	/* do any pending delalloc/csum calc on src, one way or
> @@ -2476,6 +2534,236 @@ static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
> +static int btrfs_extent_same(struct inode *src, u64 loff, u64 len,
> +			     struct inode *dst, u64 dst_loff)
> +{
> +	char *orig_buffer = NULL;
> +	char *dst_inode_buffer = NULL;
> +	int ret;
> +
> +	/*
> +	 * btrfs_clone() can't handle extents in the same file
> +	 * yet. Once that works, we can drop this check and replace it
> +	 * with a check for the same inode, but overlapping extents.
> +	 */
> +	if (src == dst)
> +		return -EINVAL;
> +
> +	btrfs_double_lock(src, loff, dst, dst_loff, len);
> +

Let's see how fill_data is actually used:

> +	ret = fill_data(src, loff, len, &orig_buffer);

Now orig_buffer is allocated from inside fill_data

> +	ret = fill_data(dst, dst_loff, len, &dst_inode_buffer);

And again, although the buffers are just memcmp'ed:

> +	ret = memcmp(orig_buffer, dst_inode_buffer, len);

extents linked:

> +	ret = btrfs_clone(src, dst, loff, len, len, dst_loff);
> +
> +out:
> +	btrfs_double_unlock(src, loff, dst, dst_loff, len);
> +
and thrown away, all of this to be repeated on next call of
btrfs_extent_same:

> +	kfree(dst_inode_buffer);
> +	kfree(orig_buffer);
> +	return ret;
> +}

Apart from the potential kmalloc failure, I think at least the second
fill_data can be replaced with memcpy with orig_buffer. (Possibly both
fill_data/memcpy could be replaced by memcmp reading from both inodes in
parallel.)

> +#define BTRFS_MAX_DEDUPE_LEN	(16 * 1024 * 1024)
> +#define BTRFS_ONE_DEDUPE_LEN	(1 * 1024 * 1024)
> +
> +static long btrfs_ioctl_file_extent_same(struct file *file,
> +					 void __user *argp)
> +{
> +	struct btrfs_ioctl_same_args *args;
> +	struct btrfs_ioctl_same_args tmp;
> +	struct btrfs_ioctl_same_extent_info *info;
> +	struct inode *src = file->f_dentry->d_inode;
> +	struct file *dst_file = NULL;
> +	struct inode *dst;
> +	u64 off;
> +	u64 len;
> +	int args_size;
> +	int i;
> +	int ret;
> +	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;

The ioctl is available to non-root, so an extra care should be taken to
potentail overflows etc. I haven't spotted anything so far.

> +	if (copy_from_user(&tmp,
> +			   (struct btrfs_ioctl_same_args __user *)argp,
> +			   sizeof(tmp)))
> +		return -EFAULT;
> +
> +	args_size = sizeof(tmp) + (tmp.dest_count *
> +			sizeof(struct btrfs_ioctl_same_extent_info));

A minor note: computing the size like this works as long as the
structures do not require extra padding between elements, ie the gap at
the end of an element until alignmed start of the next element. That's
ok now and I don't think that the compiler would use alignment larger
than 8 bytes (ie for u64).

size of btrfs_ioctl_same_extent_info is 4x u64, and 'info' starts at 3rd
u64 inside btrfs_ioctl_same_args.

A proposed paranoid-safety check is something like

	struct btrfs_ioctl_same_extent_info dummy[2];

	ASSERT(sizeof(struct btrfs_ioctl_same_extent_info)
		== (&dummy[1] - &dummy[0]))

> +	/* Keep size of ioctl argument sane */
> +	if (args_size > PAGE_CACHE_SIZE)
> +		return -E2BIG;
> +
> +	args = kmalloc(args_size, GFP_NOFS);
> +	if (!args)
> +		return -ENOMEM;
> +
> +	ret = -EFAULT;
> +	if (copy_from_user(args,
> +			   (struct btrfs_ioctl_same_args __user *)argp,
> +			   args_size))
> +		goto out;
> +	/* Make sure args didn't change magically between copies. */

Not much fun left :)

> +	if (memcmp(&tmp, args, sizeof(tmp)))
> +		goto out;
> +
> +	if ((sizeof(tmp) + (sizeof(*info) * args->dest_count)) > args_size)
> +		goto out;
> +
> +	/* pre-format 'out' fields to sane default values */
> +	for (i = 0; i < args->dest_count; i++) {
> +		info = &args->info[i];
> +		info->bytes_deduped = 0;
> +		info->status = 0;
> +	}
> +
> +	off = args->logical_offset;
> +	len = args->length;
> +
> +	/*
> +	 * Limit the total length we will dedupe for each operation. 
> +	 * This is intended to bound the entire ioctl to something sane.
> +	 */
> +	if (len > BTRFS_MAX_DEDUPE_LEN)
> +		len = BTRFS_MAX_DEDUPE_LEN;
> +
> +	ret = -EINVAL;
> +	if (off + len > src->i_size || off + len < off)
> +		goto out;
> +	if (!IS_ALIGNED(off, bs) || !IS_ALIGNED(off + len, bs))
> +		goto out;
> +
> +	ret = -EISDIR;
> +	if (S_ISDIR(src->i_mode))
> +		goto out;
> +
> +	ret = 0;
> +	for (i = 0; i < args->dest_count; i++) {
> +		u64 dest_off;
> +		u64 src_off;
> +		u64 op_len;
> +
> +		info = &args->info[i];
> +
> +		dst_file = fget(info->fd);
> +		if (!dst_file) {
> +			printk(KERN_ERR "btrfs: invalid fd %lld\n", info->fd);

I think adding the keyword 'dedup' to the messages would make it more
clear at which operation it happend.

> +			info->status = -EBADF;
> +			continue;
> +		}
> +
> +		dst = dst_file->f_dentry->d_inode;
> +		if (S_ISDIR(dst->i_mode)) {
> +			printk(KERN_ERR "btrfs: file is dir %lld\n", info->fd);
> +			info->status = -EISDIR;
> +			goto next;
> +		}
> +
> +		info->status = -EINVAL;
> +		if (dst == src) {
> +			printk(KERN_ERR "btrfs: file dup %lld\n", info->fd);
> +			goto next;
> +		}
> +
> +		dest_off = info->logical_offset;
> +
> +		if (dest_off + len > dst->i_size || dest_off + len < dest_off)
> +			goto next;
> +		if (!IS_ALIGNED(dest_off, bs))
> +			goto next;
> +
> +		/*
> +		 * The purpose of this loop is to limit the number of
> +		 * bytes we dedupe during a single call to
> +		 * btrfs_extent_same().
> +		 *
> +		 * In order to memcmp the data we have to allocate a
> +		 * pair of buffers. We don't want to allocate too
> +		 * large a buffer, so limiting the size for each
> +		 * dedupe is an easy way to do this.
> +		 */
> +		src_off = off;
> +		op_len = len;
> +		while (op_len) {
> +			u64 tmp_len;
> +
> +			tmp_len = op_len;
> +			if (op_len > BTRFS_ONE_DEDUPE_LEN)
> +				tmp_len = BTRFS_ONE_DEDUPE_LEN;
> +
> +			info->status = btrfs_extent_same(src, src_off, tmp_len,
> +							 dst, dest_off);
> +			if (info->status == 0) {
> +				info->bytes_deduped += tmp_len;
> +			} else
> +				break;
> +
> +			dest_off += tmp_len;
> +			src_off += tmp_len;
> +			op_len -= tmp_len;
> +		}
> +
> +next:
> +		fput(dst_file);
> +		dst_file = NULL;
> +	}
> +
> +	if (copy_to_user(argp, args, args_size))
> +		ret = -EFAULT;
> +
> +out:
> +	if (dst_file)
> +		fput(dst_file);
> +	kfree(args);
> +	return ret;
> +}
