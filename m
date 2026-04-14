Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138DC86341
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 02:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776132464; cv=none; b=gND4ZXiDv4xyHbto4rGDV8+/EQk9dbK/Wpe4QBOUXKedf+lnbnpVIsM8Rks5MV8RSHRgmzCuv0LumzDGAvnf0ttXBlov0kmwNnv0nj7lciIRIEvhHXjl3w50LX/FMvPIfOnfOeWRLc4zfHpHWinjBFl+kt4PjHVNO3awumXdlto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776132464; c=relaxed/simple;
	bh=rBccyEY1JiW8ZWynQ48RrQ77KPES9Pmb4Pk32dSnIlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvvjioQtC6iCJgi4Se7ZdgU5loTVHACaNhuxtMEC6zXaFK3/4QAkdezstgEa+VfvSG6qI2Tm15wgyP/UpZ60d7PIv+UWmUnqjuyrBHbhcYC05HRIiFkxm4uS9TE7qB8eTUEvnjcnK5l4Is2AJWlOP9KvV2swe7+o6Yk5ZHdgG40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gqQCGlLW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pemfhFAQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WeiFM+VW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aSAo3fYy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gqQCGlLW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pemfhFAQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WeiFM+VW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aSAo3fYy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E35F85BDD1;
	Tue, 14 Apr 2026 02:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776132461;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lD1Nixa9x4VSywu0G10hmeq99p7n/wdSjD7oeZwjCXM=;
	b=gqQCGlLWaRXcP5WgvmF1Z4gpHg3h8jek7IRN55v/Sn+28ypziDoxCasXZfHaQo0TUTSJ9H
	fVTOluQayz8bGjjtkC4j6WqMhNXDWOm2g2mRSueMzCB7GaTbkJExac3SaUbyPN2rbRouy+
	CwHt9BcamHu/N0IHBKUjxrYV4YrI3fA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776132461;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lD1Nixa9x4VSywu0G10hmeq99p7n/wdSjD7oeZwjCXM=;
	b=pemfhFAQrqmR9/Jcrk2YfJ5mowJBfowGnVWuIjq/tN8XQJfvl5ZKWMRRgrAp2QwDt7E6XX
	t28ceLDvgWCNU+Bw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WeiFM+VW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aSAo3fYy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776132460;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lD1Nixa9x4VSywu0G10hmeq99p7n/wdSjD7oeZwjCXM=;
	b=WeiFM+VWCEHVF5Z9dq/mul9Eqw6LctPb2N0ZFTFtBviG0zujdbJhURbYq/PwZgtDcBmh/L
	apQKywFhWzc0psJCYF/pWnhVZeQ9Arv8sNe7kRTgh11nw4FFT5HyHMapEyTKa2XTcG//e1
	Bdt9jy3FEB6yWcTa0ZLDBLdI6/86IEo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776132460;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lD1Nixa9x4VSywu0G10hmeq99p7n/wdSjD7oeZwjCXM=;
	b=aSAo3fYyMIfZkGzt/JlgynkXwexWl/4Dnba0WXtU4Oyk40SBTpG83GDMUpOeAILlfsaEPf
	iTWsFCH3rmU5qcBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8A094B1D5;
	Tue, 14 Apr 2026 02:07:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +cL+KGyh3Wl9IAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 14 Apr 2026 02:07:40 +0000
Date: Tue, 14 Apr 2026 04:07:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, boris@bur.io
Subject: Re: [PATCH v3] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
Message-ID: <20260414020739.GK12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260413171440.116041-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413171440.116041-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E35F85BDD1

On Mon, Apr 13, 2026 at 06:14:16PM +0100, Mark Harmstone wrote:
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
> 
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
> The main use case for this is for speeding up mkfs.btrfs --rootdir.

In the past reading the checksums was desired for deduplication, and we
had some proposed ioctls but I think it was not extensive to also cover
the holes, compression. Basically a wrapper for the search tree ioctl on
the checksum tree.

Handling all the types in this patch seems to be complete.

> For
> the case when the source FS is btrfs and using the same csum algorithm,
> we can avoid having to recalculate the csums - in my synthetic
> benchmarks (16GB file on a spinning-rust drive), this resulted in a ~11%
> speed-up (218s to 196s).
> 
> When using the --reflink option added in btrfs-progs v6.16.1, we can forgo
> reading the data entirely, resulting a ~2200% speed-up on the same test
> (128s to 6s).

Repeated mkfs is a specific use case, normaly it happens just once but I
understand that for preparing various images the time savings are
significiant.

Once this ioctl is available I think the deduplication tools will make
use of it as an initial filter before actually doing the real
deduplication of extents.

As this is a unprivileged ioctl and touching structures and memory we'll
need a security pass on the final version. So far I haven't see any
issues known to me.

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
> @@ -5139,6 +5140,340 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg
>  }
>  #endif
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
> +
> +	ret = btrfs_lookup_csums_list(csum_root, disk_bytenr,
> +				      disk_bytenr + len - 1, &list, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Clear the output buffer to handle potential gaps in csum coverage. */
> +	if (clear_user(buf, (len >> fs_info->sectorsize_bits) * csum_size)) {

Clearning the partial range here is good but I think it should be done
globally right at the start of the ioctl, regardless of how many data we
return.

OTOH this can have a peformance hit in case a large buffer is provided
by default but for various ranges and possibly short ones, not matching
the entire buffer. So repeated calls will have to clear 16M but return
a few kilobytes.

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

Please use vfs_inode

> +	struct btrfs_inode *bi = BTRFS_I(inode);

and plain inode

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
> +	if (args.flags != 0)
> +		return -EINVAL;
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

This needs to be interruptible, all other points are. There's no inode
lock helper for that so you'd have to add it or call
down_rwsem_interruptible().

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
> +		struct btrfs_ioctl_get_csums_entry entry;

Please initialize that right away with = { 0 }, it's done later by
memset() but for something filled partially it's better to do it at the
beginning than forgetting to do it later.

Overall comment, please check the final patch that there are not
unnecessary line breaks that overflow 80 chars only slightly. I've seen
a few and would have fixed it but I think I've been pointing that out
enough in the past. I'll fix anything that's left if needed.
