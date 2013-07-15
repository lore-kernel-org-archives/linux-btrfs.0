Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab3GOUz6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 16:55:58 -0400
Date: Mon, 15 Jul 2013 13:55:51 -0700
From: Zach Brown <zab@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
Message-ID: <20130715205551.GT25414@lenny.home.zabbo.net>
References: <1370982698-757-1-git-send-email-mfasheh@suse.de>
 <1370982698-757-5-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370982698-757-5-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef asked that I check out the offline dedup patches.  I hope that I
found the most recent posting in my archives :).

The first three patches seemed fine.  I have questions about the
read/compare/clone core:

> +		addr = kmap(page);
> +		memcpy(buffer + bytes_copied, addr, PAGE_CACHE_SIZE);
> +		kunmap(page);

I think you need flush_dcache_page() here 'cause there could be writable
user address mappings of these page cache pages.

> +static void btrfs_double_lock(struct inode *inode1, u64 loff1,
> +			      struct inode *inode2, u64 loff2, u64 len)
> +{
> +	if (inode1 < inode2) {
> +		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
> +		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
> +		lock_extent_range(inode1, loff1, len);
> +		lock_extent_range(inode2, loff2, len);
> +	} else {
> +		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_PARENT);
> +		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_CHILD);
> +		lock_extent_range(inode2, loff2, len);
> +		lock_extent_range(inode1, loff1, len);
> +	}
> +}

I'd do it a little differently to reduce the surface area for future 1/2
copy-paste typos.  (And maybe make it safe for when src == dst?)

	if (inode1 > inode2)
		swap(inode1, inode2)

	mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
	lock_extent_range(inode1, loff1, len);
	if (inode1 != inode2) {
		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
		lock_extent_range(inode2, loff2, len);
	}

If lockdep lets us do this, anyway :/.  (Then maybe a similar swap to
match in unlock, I'm not sure.)

> +	if (copy_from_user(&tmp,
> +			   (struct btrfs_ioctl_same_args __user *)argp,
> +			   sizeof(tmp))) {
> +		ret = -EFAULT;
> +		goto out_drop_write;
> +	}
> +
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
> +	/* Make sure args didn't change magically between copies. */
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

I'd get rid of all this code by only copying each input argument on to
the stack as it's needed and by getting rid of the writable output
struct fields.  (more on this later)

> +	/*
> +	 * Limit the total length we will dedupe for each operation. 
> +	 * This is intended to bound the entire ioctl to something sane.
> +	 */
> +	if (len > BTRFS_MAX_DEDUPE_LEN)
> +		len = BTRFS_MAX_DEDUPE_LEN;

[ ... ]

> +	src_buffer = btrfs_kvmalloc(len, GFP_NOFS);
> +	dst_buffer = btrfs_kvmalloc(len, GFP_NOFS);
> +	if (!src_buffer || !dst_buffer) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}

Why use these allocated intermediate buffers at all?  Regardless of how
large a region you decide to lock and clone at a time, you can get page
refs for both files and use kmap_atomic() to compare without copying. 

And if you don't have the buffers, why not lock and clone as much as
the user asked for?

I could understand wanting to reduce lock hold times, but you could do
that by doing the initial io waits on shared page cache references and
only using the expensive locks to verify the pages and perform the
clone.  But hopefully that complexity isn't really needed?

> +		if (S_ISDIR(dst->i_mode)) {
> +			info->status = -EISDIR;
> +			goto next;
> +		}

Does anything stop us from getting here with symlinks?  It looks like
btrfs_symlink() helpfully overrides i_fop with the _file_ operations
which have .ioctl.  I didn't actually try it.

> +	if (copy_to_user(argp, args, args_size))
> +		ret = -EFAULT;

I don't think it should be possible to return -EFAULT after all the work
is done just because some input memory was accidentally read-only for
whatever reason.

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

As I said, I'd get rid of the output fields.  Like the other vectored io
syscalls, the return value can indicate the number of initial
consecutive bytes that worked.  When no progess was made then it can
return errors.  Userspace is left to sort out the resulting state and
figure out the extents to retry in exactly the same way that it found
the initial extents to attempt to dedupe in the first place.

(And imagine strace trying to print the inputs and outputs.  Poor, poor,
strace! :))

I hope this helps!

- z
