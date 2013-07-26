Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778Ab3GZWJi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 18:09:38 -0400
Date: Fri, 26 Jul 2013 15:09:32 -0700
From: Zach Brown <zab@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
Message-ID: <20130726220932.GO26554@lenny.home.zabbo.net>
References: <1374856212-11228-1-git-send-email-mfasheh@suse.de>
 <1374856212-11228-5-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374856212-11228-5-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +static struct page *extent_same_get_page(struct inode *inode, u64 off)
> +{
> +	struct page *page;
> +	pgoff_t index;
> +	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
> +
> +	index = off >> PAGE_CACHE_SHIFT;
> +
> +	page = grab_cache_page(inode->i_mapping, index);
> +	if (!page)
> +		return NULL;
> +
> +	if (!PageUptodate(page)) {
> +		extent_read_full_page_nolock(tree, page, btrfs_get_extent, 0);

Do we need to test for errors from extent_read_full_page_nolock()?

> +static int btrfs_cmp_data(struct inode *src, u64 loff, struct inode *dst,
> +			  u64 dst_loff, u64 len)
> +{
> +	int ret = 0;
> +	struct page *src_page, *dst_page;
> +	unsigned int cmp_len = PAGE_CACHE_SIZE;
> +	void *addr, *dst_addr;
> +
> +	while (len) {
> +		if (len < PAGE_CACHE_SIZE)
> +			cmp_len = len;
> +
> +		src_page = extent_same_get_page(src, loff);
> +		if (!src_page)
> +			return -EINVAL;
> +		dst_page = extent_same_get_page(dst, dst_loff);
> +		if (!dst_page) {
> +			page_cache_release(src_page);
> +			return -EINVAL;
> +		}
> +		addr = kmap(src_page);
> +		dst_addr = kmap(dst_page);

Acquiring multiple kmaps can deadlock if you get enough tasks holding
the first kmap while their second kmap blocks waiting for free kmap
slots.  Just use kmap_atomic().  It has enough static slots for task
context to grab two.

> +
> +		flush_dcache_page(src_page);
> +		flush_dcache_page(dst_page);
> +
> +		if (memcmp(addr, dst_addr, cmp_len))
> +			ret = BTRFS_SAME_DATA_DIFFERS;

Might as well add the sub-page offset from the file offset so that this
can't silently corrupt data if someone starts trying to get block_size <
page_size patches working.  Or, I guess, add a WARN_ON error path up in
the caller where block alignment is tested?

> +	args_size = sizeof(tmp) + (tmp.dest_count *
> +			sizeof(struct btrfs_ioctl_same_extent_info));
> +
> +	/* Keep size of ioctl argument sane */
> +	if (args_size > PAGE_CACHE_SIZE) {
> +		ret = -E2BIG;
> +		goto out_drop_write;
> +	}
> +
> +	args = kmalloc(args_size, GFP_NOFS);
> +	if (!args) {
> +		ret = -ENOMEM;
> +		goto out_drop_write;
> +	}
> +
> +	ret = -EFAULT;
> +	if (copy_from_user(args,
> +			   (struct btrfs_ioctl_same_args __user *)argp,
> +			   args_size))
> +		goto out;

None of this is needed, and getting rid of that arg size limit would be
nice.  Copy into and store from on-stack structs as they're used.

> +	/* Make sure args didn't change magically between copies. */
> +	if (memcmp(&tmp, args, sizeof(tmp)))
> +		goto out;
> +
> +	if ((sizeof(tmp) + (sizeof(*info) * args->dest_count)) > args_size)
> +		goto out;

This should be deleted.  This magical change can happen after this
second copy and test and if it does.. who cares?

> +	/* pre-format 'out' fields to sane default values */
> +	for (i = 0; i < args->dest_count; i++) {
> +		info = &args->info[i];
> +		info->bytes_deduped = 0;
> +		info->status = 0;
> +	}

No need, just copy the output fields as they're discovered.  Because the
copies to userspace can partially fail userspace can't trust the output
fields if the syscall returns an error code anyway.

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

The comment doesn't really explain *why* it wants to bound the entire
ioctl, given that the ioctl can lock and clone in chunks.  Are callers
expected to notice truncated dedups and fix up and resubmit the
remainder of their extents? 

Is this just a leftover from the allocated temporary comparison buffer
that we can now remove? 

> +	ret = -EISDIR;
> +	if (S_ISDIR(src->i_mode))
> +		goto out;

Doesn't this have the same ISLNK problem that the destination file had?
Shouldn't both tests be !S_ISREG()?

> +	ret = 0;
> +	for (i = 0; i < args->dest_count; i++) {
> +		u64 dest_off;
> +
> +		info = &args->info[i];

		if (copy_from_user(&info, &args->info[i], sizeof(info)) {
			ret = -EFAULT;
			goto out;
		}

> +		if (S_ISDIR(dst->i_mode)) {
> +			info->status = -EISDIR;
> +			goto next;
> +		}
> +
> +		if (S_ISLNK(dst->i_mode)) {
> +			info->status = -EACCES;
> +			goto next;
> +		}

( !S_ISREG() )

> +
> +		info->status = -EINVAL;
> +		/* don't make the dst file partly checksummed */
> +		if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
> +		    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM))
> +			goto next;
> +
> +		dest_off = info->logical_offset;
> +		if (dest_off + len > dst->i_size || dest_off + len < dest_off)
> +			goto next;
> +		if (!IS_ALIGNED(dest_off, bs))
> +			goto next;

It just occurred to me: shouldn't these be tested under i_mutex?  Can't
altering the NODATASUM flags race after the test but before extent_same
gets the locks?  (Similar with the i_size test, I suppose.)

> +		info->status = btrfs_extent_same(src, off, len, dst, dest_off);
> +		if (info->status == 0) {
> +			info->bytes_deduped += len;
> +		} else
> +			break;	

		if (__put_user_unaligned(info.status, &args->info[i].status) ||
		    __put_user_unaligned(info.bytes_deduped, &args->info[i].bytes_deduped)) {
			ret = -EFAULT;
			goto out;
		}

> +
> +	if (copy_to_user(argp, args, args_size))
> +		ret = -EFAULT;
> +
> +out:
> +	if (dst_file)
> +		fput(dst_file);
> +	kfree(args);

Copying to and from the stack as needed gets rid of this final copy and
free.

> +#define BTRFS_SAME_DATA_DIFFERS	1
> +/* For extent-same ioctl */
> +struct btrfs_ioctl_same_extent_info {
> +	__s64 fd;		/* in - destination file */
> +	__u64 logical_offset;	/* in - start of extent in destination */
> +	__u64 bytes_deduped;	/* out - total # of bytes we were able
> +				 * to dedupe from this file */
> +	/* status of this dedupe operation:
> +	 * 0 if dedup succeeds
> +	 * < 0 for error
> +	 * == BTRFS_SAME_DATA_DIFFERS if data differs
> +	 */
> +	__s32 status;		/* out - see above description */
> +	__u32 reserved;
> +};

(I still think the output fields are more complexity than is justified,
but I'm not going to push it if Josef and Chris are fine with it.)

- z
