Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9151A178372
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 01:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776736773; cv=none; b=PincnP3JYXfJpcSmcTY043dqSpp/0g47lOBtZMF4h5WgtVw0Mf/si5Ae5iZeXVr9/BaPz0WvqsgUDMnSpI6FUHYclBPr9OeRjtRatSV6IXgbGHkPupjoWBA3wP2o0yajIfdzFCrm1+p2vZRfi7S3OgSjasYMxMygeUYfMeIcXpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776736773; c=relaxed/simple;
	bh=ReePLimBL8j3IvTR7mu4hFn46p80PJXkcgr5X7YZm1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ak4URAugfrfChgGAUEa9reDZ/hZUhvr1gmup2f2/FJIyuTjYYCHxYbEONHFvt3qTpDo8+w815yu8DRpVXm6OcQcDPgAqt40gvc5HSJGfmpXuiqzUoPPt9MBHNx8Gr7jZXELEqNp95gk8Vr8kwVFwHQXNgEs2ejSDAH/J0BYf/7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PcgbOOcd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tMnjeweZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PcgbOOcd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tMnjeweZ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PcgbOOcd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tMnjeweZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PcgbOOcd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tMnjeweZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D10D5BCDE;
	Tue, 21 Apr 2026 01:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776736769;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apGU4TaDdgF2fRbMGQL+ESvRCKiod47KHtGLk2uePQw=;
	b=PcgbOOcdZ/uhmbIuzDUc+AalUT+w949HjYiB9n1J8IfqSheY4U24Hf/x9i2LEh8w2xQ52H
	xuFIKtO8RNnr4qzig8vcNT/f9ZhxolNGicbTwOq5HggwXQsiuQNQXc62oD+Frx+eAqYflW
	c43Ub1P/Pwr870KGXQHZFv89mw28uVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776736769;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apGU4TaDdgF2fRbMGQL+ESvRCKiod47KHtGLk2uePQw=;
	b=tMnjeweZb/EUwlSgvKVD5dL30+X2GBzQhmA+OAf3c1VIWEzfN3+XD60gia3D+OkNHcVZWM
	13bfFVB/lkQ8rhDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776736769;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apGU4TaDdgF2fRbMGQL+ESvRCKiod47KHtGLk2uePQw=;
	b=PcgbOOcdZ/uhmbIuzDUc+AalUT+w949HjYiB9n1J8IfqSheY4U24Hf/x9i2LEh8w2xQ52H
	xuFIKtO8RNnr4qzig8vcNT/f9ZhxolNGicbTwOq5HggwXQsiuQNQXc62oD+Frx+eAqYflW
	c43Ub1P/Pwr870KGXQHZFv89mw28uVA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776736769;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=apGU4TaDdgF2fRbMGQL+ESvRCKiod47KHtGLk2uePQw=;
	b=tMnjeweZb/EUwlSgvKVD5dL30+X2GBzQhmA+OAf3c1VIWEzfN3+XD60gia3D+OkNHcVZWM
	13bfFVB/lkQ8rhDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F13A593AF;
	Tue, 21 Apr 2026 01:59:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d5k5DwHa5mkEdQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Apr 2026 01:59:29 +0000
Date: Tue, 21 Apr 2026 03:59:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, boris@bur.io,
	dsterba@suse.cz, fdmanana@kernel.org
Subject: Re: [PATCH v5] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
Message-ID: <20260421015923.GA12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260416180141.266457-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416180141.266457-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

On Thu, Apr 16, 2026 at 07:01:18PM +0100, Mark Harmstone wrote:
> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
> query the on-disk csums for a file.
> 
> The ioctl is deliberately per-file rather than exposing raw csum tree
> lookups, to avoid leaking information to users about files they may not
> have access to.
> 
> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
> the kernel, which details the offset and length we're interested in, and
> a buffer for the kernel to write its results into. The kernel writes a
> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
> csums if available.

I've added a note that the user buffer is 16MiB.

> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
> type to BTRFS_GET_CSUMS_ZEROED - this is so userspace knows it can use
> the precomputed hash of the zero sector. Otherwise, it sets the type to
> BTRFS_GET_CSUMS_NODATASUM, BTRFS_GET_CSUMS_COMPRESSED,
> BTRFS_GET_CSUM_ENCRYPTED, or BTRFS_GET_CSUM_INLINE.
> 
> For example, a file with a [0, 4K) hole and [4K, 12K) data extent would
> produce the following output buffer:
> 
>   | [0, 4K) ZEROED | [4K, 12K) HAS_CSUMS | csum data |
> 
> We do store the csums of compressed extents, but we deliberately don't
> return them here: they're hashed over the compressed data, not the
> uncompressed data that's returned to userspace. Similarly for encrypted
> data, once encryption is supported, in which the csums will be on the
> ciphertext.
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
>     # mkdir rootdir
>     # dd if=/dev/urandom of=rootdir/file bs=4096 count=4194304
> 
>     (without ioctl)
>     # echo 3 > /proc/sys/vm/drop_caches
>     # time mkfs.btrfs --rootdir rootdir testimg
>     ...
>     real    3m37.965s
>     user    0m5.496s
>     sys     0m6.125s
> 
>     # echo 3 > /proc/sys/vm/drop_caches
>     # time mkfs.btrfs --rootdir rootdir --reflink testimg
>     ...
>     real    2m8.342s
>     user    0m5.472s
>     sys     0m1.667s
> 
>     (with ioctl)
>     # echo 3 > /proc/sys/vm/drop_caches
>     # time mkfs.btrfs --rootdir rootdir testimg
>     ...
>     real    3m15.865s
>     user    0m4.258s
>     sys     0m6.261s
> 
>     # echo 3 > /proc/sys/vm/drop_caches
>     # time mkfs.btrfs --rootdir rootdir --reflink testimg
>     ...
>     real    0m5.847s
>     user    0m2.899s
>     sys     0m0.097s

And here I've mentioned the deduplication use case.

> Signed-off-by: Mark Harmstone <mark@harmstone.com>
> ---
> Changes since v4:
> * Added check that csum_root isn't NULL
> 
> Changes since v3:
> * Changed type to bit flags, so we can have e.g. COMPRESSED | ENCRYPTED
> * Made minor changes as requested by David Sterba
> 
>  fs/btrfs/ioctl.c           | 346 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs.h |  25 +++
>  2 files changed, 371 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a39460bf68a778..93046319711c7c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -56,6 +56,7 @@
>  #include "uuid-tree.h"
>  #include "ioctl.h"
>  #include "file.h"
> +#include "file-item.h"
>  #include "scrub.h"
>  #include "super.h"
>  
> @@ -5140,6 +5141,349 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg
>  	return ret;
>  }
>  
> +#define GET_CSUMS_BUF_MAX	SZ_16M
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
> +	if (unlikely(!csum_root)) {
> +		btrfs_err(fs_info,
> +			  "missing csum root for extent at bytenr %llu", disk_bytenr);
> +		return -EUCLEAN;
> +	}
> +
> +	ret = btrfs_lookup_csums_list(csum_root, disk_bytenr,
> +				      disk_bytenr + len - 1, &list, false);
> +	if (ret < 0)
> +		return ret;
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
> +	struct inode *vfs_inode = file_inode(file);
> +	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct btrfs_root *root = inode->root;
> +	struct btrfs_ioctl_get_csums_args args;
> +	BTRFS_PATH_AUTO_FREE(path);
> +	const u64 ino = btrfs_ino(inode);
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
> +	if (!S_ISREG(vfs_inode->i_mode))
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

I've kept it as is but this should use the check_add_overflow() helper,
please send a followup.

> +	if (args.flags != 0)
> +		return -EINVAL;
> +	if (args.buf_size < sizeof(struct btrfs_ioctl_get_csums_entry))
> +		return -EINVAL;
> +
> +	buf_limit = min_t(u64, args.buf_size, GET_CSUMS_BUF_MAX);
> +	ubuf = (u8 __user *)(argp + offsetof(struct btrfs_ioctl_get_csums_args, buf));
> +
> +	if (clear_user(ubuf, buf_limit))
> +		return -EFAULT;
> +
> +	cur_offset = args.offset;
> +	end_offset = args.offset + args.length;
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	ret = btrfs_wait_ordered_range(inode, cur_offset, args.length);
> +	if (ret)
> +		return ret;
> +
> +	ret = down_read_interruptible(&vfs_inode->i_rwsem);
> +	if (ret)
> +		return ret;
> +
> +	ret = btrfs_wait_ordered_range(inode, cur_offset, args.length);
> +	if (ret)
> +		goto out_unlock;
> +
> +	/* NODATASUM early exit. */
> +	if (inode->flags & BTRFS_INODE_NODATASUM) {
> +		struct btrfs_ioctl_get_csums_entry entry = {
> +			.offset = cur_offset,
> +			.length = end_offset - cur_offset,
> +			.type = BTRFS_GET_CSUMS_NODATASUM,
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
> +		struct btrfs_ioctl_get_csums_entry entry = { 0 };
> +		u64 extent_end;
> +		u64 disk_bytenr = 0;
> +		u64 extent_offset = 0;
> +		u64 range_start, range_len;
> +		u64 entry_csum_size;
> +		u64 key_offset;
> +		int extent_type;
> +		u8 compression;
> +		u8 encryption;
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
> +		encryption = btrfs_file_extent_encryption(leaf, ei);
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
> +				entry.offset = prev_extent_end;
> +				entry.length = hole_len;
> +				entry.type = BTRFS_GET_CSUMS_ZEROED;
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
> +		entry.offset = range_start;
> +		entry.length = range_len;
> +
> +		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> +			entry.type = BTRFS_GET_CSUMS_INLINE;
> +			if (compression != BTRFS_COMPRESS_NONE)
> +				entry.type |= BTRFS_GET_CSUMS_COMPRESSED;
> +			if (encryption != 0)
> +				entry.type |= BTRFS_GET_CSUMS_ENCRYPTED;
> +			entry_csum_size = 0;
> +		} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
> +			entry.type = BTRFS_GET_CSUMS_ZEROED;
> +			entry_csum_size = 0;
> +		} else {
> +			/* BTRFS_FILE_EXTENT_REG */
> +			if (disk_bytenr == 0) {
> +				/* Explicit hole. */
> +				entry.type = BTRFS_GET_CSUMS_ZEROED;
> +				entry_csum_size = 0;
> +			} else if (encryption != 0 ||
> +				   compression != BTRFS_COMPRESS_NONE) {
> +				entry.type = 0;
> +				if (encryption != 0)
> +					entry.type |= BTRFS_GET_CSUMS_ENCRYPTED;
> +				if (compression != BTRFS_COMPRESS_NONE)
> +					entry.type |= BTRFS_GET_CSUMS_COMPRESSED;
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
> +			.type = BTRFS_GET_CSUMS_ZEROED,
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
> +	up_read(&vfs_inode->i_rwsem);
> +	return ret;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -5297,6 +5641,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_subvol_sync(fs_info, argp);
>  	case BTRFS_IOC_SHUTDOWN:
>  		return btrfs_ioctl_shutdown(fs_info, arg);
> +	case BTRFS_IOC_GET_CSUMS:
> +		return btrfs_ioctl_get_csums(file, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 9165154a274d94..ddb7a8f2610d0e 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -1100,6 +1100,29 @@ enum btrfs_err_code {
>  	BTRFS_ERROR_DEV_RAID1C4_MIN_NOT_MET,
>  };
>  
> +/* Flags for struct btrfs_ioctl_get_csums_entry::type */
> +#define BTRFS_GET_CSUMS_HAS_CSUMS	(1 << 0)
> +#define BTRFS_GET_CSUMS_ZEROED		(1 << 1)
> +#define BTRFS_GET_CSUMS_NODATASUM	(1 << 2)
> +#define BTRFS_GET_CSUMS_COMPRESSED	(1 << 3)
> +#define BTRFS_GET_CSUMS_ENCRYPTED	(1 << 4)
> +#define BTRFS_GET_CSUMS_INLINE		(1 << 5)

Bit definitions must use an unsigned type, like (1U << ...)

> +struct btrfs_ioctl_get_csums_entry {
> +	__u64 offset;		/* file offset of this range */
> +	__u64 length;		/* length in bytes */
> +	__u32 type;		/* BTRFS_GET_CSUMS_* type */
> +	__u32 reserved;		/* padding, must be 0 */

Comments should be on separate line and following the common style of a
full sentence.

> +};
> +
> +struct btrfs_ioctl_get_csums_args {
> +	__u64 offset;		/* in/out: file offset */
> +	__u64 length;		/* in/out: range length */
> +	__u64 buf_size;		/* in/out: buffer capacity / bytes written */
> +	__u64 flags;		/* in: flags, must be 0 for now */
> +	__u8 buf[];		/* out: entries + csum data */
> +};
> +
>  /* Flags for IOC_SHUTDOWN, must match XFS_FSOP_GOING_FLAGS_* flags. */
>  #define BTRFS_SHUTDOWN_FLAGS_DEFAULT			0x0
>  #define BTRFS_SHUTDOWN_FLAGS_LOGFLUSH			0x1
> @@ -1226,6 +1249,8 @@ enum btrfs_err_code {
>  				     struct btrfs_ioctl_encoded_io_args)
>  #define BTRFS_IOC_SUBVOL_SYNC_WAIT _IOW(BTRFS_IOCTL_MAGIC, 65, \
>  					struct btrfs_ioctl_subvol_wait)
> +#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
> +				  struct btrfs_ioctl_get_csums_args)

Functionally it seems OK, so I've added it to for-next, with some coding
style fixups. Thanks.
