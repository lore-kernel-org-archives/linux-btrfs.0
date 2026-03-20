Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07E33B95F8
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 13:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774011825; cv=none; b=VXNs41TFIj97S/yzEq8OGh8BiXOj/v5jmKVVUozhucQmzMbXEKqX9kNXXigVFPoGX9o8hXyYUkzR1ojabJAdnuX7GPxIdSh8XOeB+w3YY4+kruYZsVmh/3mwEy5KKW3A35fIH/FHAudQ45DOGAZB8CmQcqJCNgoTasyRlJOPAF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774011825; c=relaxed/simple;
	bh=14oYr7ftkfiGRJzCDAP93O0HXhMuYLXVAMQYxH3cBDE=;
	h=Message-ID:Date:Mime-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i4k9daXtKFz4SJTtcdFI8d24we/vh9a82NRmCw4UECepGt5cQBU1tdtKYm37iquToTvfNmYJeBHCB24ltFAGczKziNe46+DL2kdpuWmTcqRkQ/+K1cv6hMDdIKmcJU3We9OAWwv10xlU3bbGEbn1BhazVnQE6JgR9XNbYLqw3QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=ZmrXF2Q+; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="ZmrXF2Q+"
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 7CEA6312618
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 13:03:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774011819;
	bh=WnLpG3vqQ8hM2BtlFQWhrVDdL+5u2GdnJdbacARgw2M=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=ZmrXF2Q+R2q7+Y9KCWX92fHu+KD1fonZZmOJauiYwbaOgMLCoOSXy/h88j6YosI9i
	 22bxoy0M5RlKJSvcAeN15UEVGDkVcn6nMBf0IJ6i2S5uYwcSTSCjX/htTrqSyz5fli
	 GZZfCusWhlJ81fLI9LgxOEhCLxLxW2dq2cSkgo6A=
Message-ID: <374ccf9a-fc34-4720-9280-7d75fb253885@harmstone.com>
Date: Fri, 20 Mar 2026 13:03:39 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20260320125058.90053-1-mark@harmstone.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <20260320125058.90053-1-mark@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

mkfs patches for this: https://github.com/kdave/btrfs-progs/pull/1096

On 20/03/2026 12.50 pm, Mark Harmstone wrote:
> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
> query the on-disk csums for a file.
> 
> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
> the kernel, which details the offset and length we're interested in, and
> a buffer for the kernel to write its results into. The kernel writes a
> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
> csums if available.
> 
> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
> type to BTRFS_GET_CSUMS_SPARSE - this is so userspace knows it can use
> the precomputed hash of the zero sector. Otherwise, it sets the type to
> BTRFS_GET_CSUMS_NO_CSUMS.
> 
> We do store the csums of compressed extents, but we deliberately don't
> return them here: they're hashed over the compressed data, not the
> uncompressed data that's returned to userspace.
> 
> The main use case for this is for speeding up mkfs.btrfs --rootdir. For
> the case when the source FS is btrfs and using the same csum algorithm,
> we can avoid having to recalculate the csums - in my synthetic
> benchmarks (16GB file on a spinning-rust drive), this resulted in a ~11%
> speed-up (218s to 196s).
> 
> When using the --reflink option added in btrfs-progs v6.16.1, we can forgo
> reading the data entirely, resulting a ~2200% speed-up on the same test
> (128s to 6s).
> 
>      # mkdir rootdir
>      # dd if=/dev/urandom of=rootdir/file bs=4096 count=4194304
> 
>      (without ioctl)
>      # echo 3 > /proc/sys/vm/drop_caches
>      # time mkfs.btrfs --rootdir rootdir testimg
>      ...
>      real    3m37.965s
>      user    0m5.496s
>      sys     0m6.125s
> 
>      # echo 3 > /proc/sys/vm/drop_caches
>      # time mkfs.btrfs --rootdir rootdir --reflink testimg
>      ...
>      real    2m8.342s
>      user    0m5.472s
>      sys     0m1.667s
> 
>      (with ioctl)
>      # echo 3 > /proc/sys/vm/drop_caches
>      # time mkfs.btrfs --rootdir rootdir testimg
>      ...
>      real    3m15.865s
>      user    0m4.258s
>      sys     0m6.261s
> 
>      # echo 3 > /proc/sys/vm/drop_caches
>      # time mkfs.btrfs --rootdir rootdir --reflink testimg
>      ...
>      real    0m5.847s
>      user    0m2.899s
>      sys     0m0.097s
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> ---
>   fs/btrfs/ioctl.c           | 330 +++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/btrfs.h |  21 +++
>   2 files changed, 351 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a4d715bbed57ba..b7c8bfb90fed29 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -56,6 +56,7 @@
>   #include "uuid-tree.h"
>   #include "ioctl.h"
>   #include "file.h"
> +#include "file-item.h"
>   #include "scrub.h"
>   #include "super.h"
>   
> @@ -5138,6 +5139,333 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg
>   }
>   #endif
>   
> +#define GET_CSUMS_BUF_MAX	(16 * 1024 * 1024)
> +
> +static int copy_csums_to_user(struct btrfs_fs_info *fs_info, u64 disk_bytenr,
> +			      u64 len, u8 __user *buf)
> +{
> +	struct btrfs_root *csum_root;
> +	struct btrfs_ordered_sum *sums;
> +	LIST_HEAD(list);
> +	const u32 csum_size = fs_info->csum_size;
> +	int ret;
> +
> +	csum_root = btrfs_csum_root(fs_info, disk_bytenr);
> +
> +	ret = btrfs_lookup_csums_list(csum_root, disk_bytenr,
> +				      disk_bytenr + len - 1, &list, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Clear the output buffer to handle potential gaps in csum coverage. */
> +	if (clear_user(buf, (len >> fs_info->sectorsize_bits) * csum_size)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = 0;
> +	while (!list_empty(&list)) {
> +		u64 offset;
> +		size_t copy_size;
> +
> +		sums = list_first_entry(&list, struct btrfs_ordered_sum, list);
> +		list_del(&sums->list);
> +
> +		offset = ((sums->logical - disk_bytenr) >> fs_info->sectorsize_bits) * csum_size;
> +		copy_size = (sums->len >> fs_info->sectorsize_bits) * csum_size;
> +
> +		if (copy_to_user(buf + offset, sums->sums, copy_size)) {
> +			kfree(sums);
> +			ret = -EFAULT;
> +			goto out;
> +		}
> +
> +		kfree(sums);
> +	}
> +
> +out:
> +	while (!list_empty(&list)) {
> +		sums = list_first_entry(&list, struct btrfs_ordered_sum, list);
> +		list_del(&sums->list);
> +		kfree(sums);
> +	}
> +	return ret;
> +}
> +
> +static int btrfs_ioctl_get_csums(struct file *file, void __user *argp)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct btrfs_inode *bi = BTRFS_I(inode);
> +	struct btrfs_fs_info *fs_info = bi->root->fs_info;
> +	struct btrfs_root *root = bi->root;
> +	struct btrfs_ioctl_get_csums_args args;
> +	BTRFS_PATH_AUTO_FREE(path);
> +	const u64 ino = btrfs_ino(bi);
> +	const u32 sectorsize = fs_info->sectorsize;
> +	const u32 csum_size = fs_info->csum_size;
> +	u8 __user *ubuf;
> +	u64 buf_limit;
> +	u64 buf_used = 0;
> +	u64 cur_offset;
> +	u64 end_offset;
> +	u64 prev_extent_end;
> +	struct btrfs_key key;
> +	int ret;
> +
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&args, argp, sizeof(args)))
> +		return -EFAULT;
> +
> +	if (!IS_ALIGNED(args.offset, sectorsize) ||
> +	    !IS_ALIGNED(args.length, sectorsize))
> +		return -EINVAL;
> +	if (args.length == 0)
> +		return -EINVAL;
> +	if (args.offset + args.length < args.offset)
> +		return -EOVERFLOW;
> +	if (args.buf_size < sizeof(struct btrfs_ioctl_get_csums_entry))
> +		return -EINVAL;
> +
> +	buf_limit = min_t(u64, args.buf_size, GET_CSUMS_BUF_MAX);
> +	ubuf = (u8 __user *)(argp + offsetof(struct btrfs_ioctl_get_csums_args, buf));
> +	cur_offset = args.offset;
> +	end_offset = args.offset + args.length;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret = btrfs_wait_ordered_range(bi, cur_offset, args.length);
> +	if (ret)
> +		return ret;
> +
> +	btrfs_inode_lock(bi, BTRFS_ILOCK_SHARED);
> +
> +	ret = btrfs_wait_ordered_range(bi, cur_offset, args.length);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/* NODATASUM early exit. */
> +	if (bi->flags & BTRFS_INODE_NODATASUM) {
> +		struct btrfs_ioctl_get_csums_entry entry = {
> +			.offset = cur_offset,
> +			.length = end_offset - cur_offset,
> +			.type = BTRFS_GET_CSUMS_NO_CSUMS,
> +		};
> +
> +		if (copy_to_user(ubuf, &entry, sizeof(entry))) {
> +			ret = -EFAULT;
> +			goto out_unlock;
> +		}
> +
> +		buf_used = sizeof(entry);
> +		cur_offset = end_offset;
> +		goto done;
> +	}
> +
> +	prev_extent_end = cur_offset;
> +
> +	while (cur_offset < end_offset) {
> +		struct btrfs_file_extent_item *ei;
> +		struct extent_buffer *leaf;
> +		struct btrfs_ioctl_get_csums_entry entry;
> +		u64 extent_end;
> +		u64 disk_bytenr = 0;
> +		u64 extent_offset = 0;
> +		u64 range_start, range_len;
> +		u64 entry_csum_size;
> +		u64 key_offset;
> +		int extent_type;
> +		u8 compression;
> +
> +		/* Search for the extent at or before cur_offset. */
> +		key.objectid = ino;
> +		key.type = BTRFS_EXTENT_DATA_KEY;
> +		key.offset = cur_offset;
> +
> +		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +		if (ret < 0)
> +			goto out_unlock;
> +
> +		if (ret > 0 && path->slots[0] > 0) {
> +			btrfs_item_key_to_cpu(path->nodes[0], &key,
> +					      path->slots[0] - 1);
> +			if (key.objectid == ino &&
> +			    key.type == BTRFS_EXTENT_DATA_KEY) {
> +				path->slots[0]--;
> +				if (btrfs_file_extent_end(path) <= cur_offset)
> +					path->slots[0]++;
> +			}
> +		}
> +
> +		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
> +			ret = btrfs_next_leaf(root, path);
> +			if (ret < 0)
> +				goto out_unlock;
> +			if (ret > 0) {
> +				ret = 0;
> +				btrfs_release_path(path);
> +				break;
> +			}
> +		}
> +
> +		leaf = path->nodes[0];
> +
> +		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +		if (key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY) {
> +			btrfs_release_path(path);
> +			break;
> +		}
> +
> +		extent_end = btrfs_file_extent_end(path);
> +		key_offset = key.offset;
> +
> +		/* Read extent fields before releasing the path. */
> +		ei = btrfs_item_ptr(leaf, path->slots[0],
> +				    struct btrfs_file_extent_item);
> +		extent_type = btrfs_file_extent_type(leaf, ei);
> +		compression = btrfs_file_extent_compression(leaf, ei);
> +
> +		if (extent_type != BTRFS_FILE_EXTENT_INLINE) {
> +			disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, ei);
> +			if (disk_bytenr && compression == BTRFS_COMPRESS_NONE)
> +				extent_offset = btrfs_file_extent_offset(leaf, ei);
> +		}
> +
> +		btrfs_release_path(path);
> +
> +		/* Implicit hole (NO_HOLES feature). */
> +		if (prev_extent_end < key_offset) {
> +			u64 hole_end = min(key_offset, end_offset);
> +			u64 hole_len = hole_end - prev_extent_end;
> +
> +			if (prev_extent_end >= cur_offset) {
> +				memset(&entry, 0, sizeof(entry));
> +				entry.offset = prev_extent_end;
> +				entry.length = hole_len;
> +				entry.type = BTRFS_GET_CSUMS_SPARSE;
> +
> +				if (buf_used + sizeof(entry) > buf_limit)
> +					goto done;
> +				if (copy_to_user(ubuf + buf_used, &entry,
> +						 sizeof(entry))) {
> +					ret = -EFAULT;
> +					goto out_unlock;
> +				}
> +				buf_used += sizeof(entry);
> +				cur_offset = hole_end;
> +			}
> +
> +			if (key_offset >= end_offset) {
> +				cur_offset = end_offset;
> +				break;
> +			}
> +		}
> +
> +		/* Clamp to our query range. */
> +		range_start = max(cur_offset, key_offset);
> +		range_len = min(extent_end, end_offset) - range_start;
> +
> +		memset(&entry, 0, sizeof(entry));
> +		entry.offset = range_start;
> +		entry.length = range_len;
> +
> +		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> +			entry.type = BTRFS_GET_CSUMS_NO_CSUMS;
> +			entry_csum_size = 0;
> +		} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
> +			entry.type = BTRFS_GET_CSUMS_SPARSE;
> +			entry_csum_size = 0;
> +		} else {
> +			/* BTRFS_FILE_EXTENT_REG */
> +			if (disk_bytenr == 0) {
> +				/* Explicit hole. */
> +				entry.type = BTRFS_GET_CSUMS_SPARSE;
> +				entry_csum_size = 0;
> +			} else if (compression != BTRFS_COMPRESS_NONE) {
> +				entry.type = BTRFS_GET_CSUMS_NO_CSUMS;
> +				entry_csum_size = 0;
> +			} else {
> +				entry.type = BTRFS_GET_CSUMS_HAS_CSUMS;
> +				entry_csum_size = (range_len >> fs_info->sectorsize_bits) * csum_size;
> +			}
> +		}
> +
> +		/* Check if this entry (+ csum data) fits in the buffer. */
> +		if (buf_used + sizeof(entry) + entry_csum_size > buf_limit) {
> +			if (buf_used == 0) {
> +				ret = -EOVERFLOW;
> +				goto out_unlock;
> +			}
> +			goto done;
> +		}
> +
> +		if (copy_to_user(ubuf + buf_used, &entry, sizeof(entry))) {
> +			ret = -EFAULT;
> +			goto out_unlock;
> +		}
> +		buf_used += sizeof(entry);
> +
> +		if (entry.type == BTRFS_GET_CSUMS_HAS_CSUMS) {
> +			ret = copy_csums_to_user(fs_info,
> +				disk_bytenr + extent_offset + (range_start - key_offset),
> +				range_len, ubuf + buf_used);
> +			if (ret)
> +				goto out_unlock;
> +			buf_used += entry_csum_size;
> +		}
> +
> +		cur_offset = range_start + range_len;
> +		prev_extent_end = extent_end;
> +
> +		if (fatal_signal_pending(current)) {
> +			if (buf_used == 0) {
> +				ret = -EINTR;
> +				goto out_unlock;
> +			}
> +			goto done;
> +		}
> +
> +		cond_resched();
> +	}
> +
> +	/* Handle trailing implicit hole. */
> +	if (cur_offset < end_offset) {
> +		struct btrfs_ioctl_get_csums_entry entry = {
> +			.offset = prev_extent_end,
> +			.length = end_offset - prev_extent_end,
> +			.type = BTRFS_GET_CSUMS_SPARSE,
> +		};
> +
> +		if (buf_used + sizeof(entry) <= buf_limit) {
> +			if (copy_to_user(ubuf + buf_used, &entry,
> +					 sizeof(entry))) {
> +				ret = -EFAULT;
> +				goto out_unlock;
> +			}
> +			buf_used += sizeof(entry);
> +			cur_offset = end_offset;
> +		}
> +	}
> +
> +done:
> +	args.offset = cur_offset;
> +	args.length = (cur_offset < end_offset) ? end_offset - cur_offset : 0;
> +	args.buf_size = buf_used;
> +
> +	if (copy_to_user(argp, &args, sizeof(args)))
> +		ret = -EFAULT;
> +
> +out_unlock:
> +	btrfs_inode_unlock(bi, BTRFS_ILOCK_SHARED);
> +	return ret;
> +}
> +
>   long btrfs_ioctl(struct file *file, unsigned int
>   		cmd, unsigned long arg)
>   {
> @@ -5293,6 +5621,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>   #endif
>   	case BTRFS_IOC_SUBVOL_SYNC_WAIT:
>   		return btrfs_ioctl_subvol_sync(fs_info, argp);
> +	case BTRFS_IOC_GET_CSUMS:
> +		return btrfs_ioctl_get_csums(file, argp);
>   #ifdef CONFIG_BTRFS_EXPERIMENTAL
>   	case BTRFS_IOC_SHUTDOWN:
>   		return btrfs_ioctl_shutdown(fs_info, arg);
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9165154a274d94..db1374c892f825 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -1100,6 +1100,25 @@ enum btrfs_err_code {
>   	BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
>   };
>   
> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
> +#define BTRFS_GET_CSUMS_HAS_CSUMS	0
> +#define BTRFS_GET_CSUMS_SPARSE		1
> +#define BTRFS_GET_CSUMS_NO_CSUMS	2
> +
> +struct btrfs_ioctl_get_csums_entry {
> +	__u64 offset;		/* file offset of this range */
> +	__u64 length;		/* length in bytes */
> +	__u32 type;		/* BTRFS_GET_CSUMS_* type */
> +	__u32 reserved;		/* padding, must be 0 */
> +};
> +
> +struct btrfs_ioctl_get_csums_args {
> +	__u64 offset;		/* in/out: file offset */
> +	__u64 length;		/* in/out: range length */
> +	__u64 buf_size;		/* in/out: buffer capacity / bytes written */
> +	__u8 buf[];		/* out: entries + csum data */
> +};
> +
>   /* Flags for IOC_SHUTDOWN, must match XFS_FSOP_GOING_FLAGS_* flags. */
>   #define BTRFS_SHUTDOWN_FLAGS_DEFAULT			0x0
>   #define BTRFS_SHUTDOWN_FLAGS_LOGFLUSH			0x1
> @@ -1226,6 +1245,8 @@ enum btrfs_err_code {
>   				     struct btrfs_ioctl_encoded_io_args)
>   #define BTRFS_IOC_SUBVOL_SYNC_WAIT _IOW(BTRFS_IOCTL_MAGIC, 65, \
>   					struct btrfs_ioctl_subvol_wait)
> +#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
> +				  struct btrfs_ioctl_get_csums_args)
>   
>   /* Shutdown ioctl should follow XFS's interfaces, thus not using btrfs magic. */
>   #define BTRFS_IOC_SHUTDOWN	_IOR('X', 125, __u32)

