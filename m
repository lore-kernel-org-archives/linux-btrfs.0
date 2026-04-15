Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225023BD237
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 13:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776261423; cv=none; b=mJlp7gLMGdedNB/PFRzcHRQF1WXnJlKJaMrND58W+/24sonktaLTRLpOc0CQ3Iv9eJj/JSJcAQMEQGtVK603DdCA1jZyR1fnNoiYMar7qatSM6G1BxuZsCf7wzQpczh1wJvS8WmMiMkGMnpAycas0Ti7d1CwKaO+8nGhcUihhfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776261423; c=relaxed/simple;
	bh=FFLa4sF7vIXKmakgeVoACVeDe4rY9ESnhbtmOYdOgDo=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JJmSxg4sLrvUBXnp3LLsbOT4mKa3nNjXnVq0v+oErQ4WJQnhEL+n9ZeVE98/L9EhPWww3I6g4DC8TPXQSNf36P8i8XVFDHY569cxB6B8luusDbTq2RSdaSjo+CyzXdvq5IOcQgA8rQVvzla29ckp49kdVuzh0tfCVnvAGLFQNqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=1riic3Tq; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="1riic3Tq"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 1C00C31D9CD;
	Wed, 15 Apr 2026 14:56:50 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1776261410;
	bh=XYnV0faaji5j3jy/OGSJA5H8gl5ODXpHIExqHiUImPk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=1riic3Tqg5Qj1K0yUfqaZgwm+SnjYgIq78uOqk07g60+Uvgh5OJ0sE3cVuYdvTfF9
	 ymz4IOUP0Ra03RZZs4xDkglWS0U/j3klgbsq+3DKCul/OEph8UHdjJ0H/i3m02uEa6
	 v5nGLlLV8tdhVF/5kW07lTTeqNZsbvuJUY9tNzdA=
Message-ID: <e1861274-8d36-4a79-8092-aa7e2ba39240@harmstone.com>
Date: Wed, 15 Apr 2026 14:56:49 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v3] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, boris@bur.io
References: <20260413171440.116041-1-mark@harmstone.com>
 <20260414020739.GK12792@twin.jikos.cz>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <20260414020739.GK12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks David.

On 14/04/2026 3.07 am, David Sterba wrote:
> On Mon, Apr 13, 2026 at 06:14:16PM +0100, Mark Harmstone wrote:
>> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
>> query the on-disk csums for a file.
>>
>> The ioctl is deliberately per-file rather than exposing raw csum tree
>> lookups, to avoid leaking information to users about files they may not
>> have access to.
>>
>> This is done by userspace passing a struct btrfs_ioctl_get_csums_args to
>> the kernel, which details the offset and length we're interested in, and
>> a buffer for the kernel to write its results into. The kernel writes a
>> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
>> csums if available.
>>
>> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
>> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
>> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
>> type to BTRFS_GET_CSUMS_ZEROED - this is so userspace knows it can use
>> the precomputed hash of the zero sector. Otherwise, it sets the type to
>> BTRFS_GET_CSUMS_NODATASUM, BTRFS_GET_CSUMS_COMPRESSED,
>> BTRFS_GET_CSUM_ENCRYPTED, or BTRFS_GET_CSUM_INLINE.
>>
>> For example, a file with a [0, 4K) hole and [4K, 12K) data extent would
>> produce the following output buffer:
>>
>>    | [0, 4K) ZEROED | [4K, 12K) HAS_CSUMS | csum data |
>>
>> We do store the csums of compressed extents, but we deliberately don't
>> return them here: they're hashed over the compressed data, not the
>> uncompressed data that's returned to userspace. Similarly for encrypted
>> data, once encryption is supported, in which the csums will be on the
>> ciphertext.
>>
>> The main use case for this is for speeding up mkfs.btrfs --rootdir.
> 
> In the past reading the checksums was desired for deduplication, and we
> had some proposed ioctls but I think it was not extensive to also cover
> the holes, compression. Basically a wrapper for the search tree ioctl on
> the checksum tree.
> 
> Handling all the types in this patch seems to be complete.
> 
>> For
>> the case when the source FS is btrfs and using the same csum algorithm,
>> we can avoid having to recalculate the csums - in my synthetic
>> benchmarks (16GB file on a spinning-rust drive), this resulted in a ~11%
>> speed-up (218s to 196s).
>>
>> When using the --reflink option added in btrfs-progs v6.16.1, we can forgo
>> reading the data entirely, resulting a ~2200% speed-up on the same test
>> (128s to 6s).
> 
> Repeated mkfs is a specific use case, normaly it happens just once but I
> understand that for preparing various images the time savings are
> significiant.
> 
> Once this ioctl is available I think the deduplication tools will make
> use of it as an initial filter before actually doing the real
> deduplication of extents.

IIRC the mathematics of the birthday paradox is that for an n-bit hash, 
you need 2^(n/2) sectors to have a 50% chance of a collision.

For the 32-bit hashes, that means a 50% chance of a collision every 256 
MB. For the 256-bit hashes, that's 2^140 bytes... whatever that works 
out as. So the dedupe logic would no doubt be that for larger hash sizes 
GET_CSUMS itself will be sufficient.

> As this is a unprivileged ioctl and touching structures and memory we'll
> need a security pass on the final version. So far I haven't see any
> issues known to me.
> 
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -56,6 +56,7 @@
>>   #include "uuid-tree.h"
>>   #include "ioctl.h"
>>   #include "file.h"
>> +#include "file-item.h"
>>   #include "scrub.h"
>>   #include "super.h"
>>   
>> @@ -5139,6 +5140,340 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg
>>   }
>>   #endif
>>   
>> +#define GET_CSUMS_BUF_MAX	SZ_16M
>> +
>> +static int copy_csums_to_user(struct btrfs_fs_info *fs_info, u64 disk_bytenr,
>> +			      u64 len, u8 __user *buf)
>> +{
>> +	struct btrfs_root *csum_root;
>> +	struct btrfs_ordered_sum *sums;
>> +	LIST_HEAD(list);
>> +	const u32 csum_size = fs_info->csum_size;
>> +	int ret;
>> +
>> +	csum_root = btrfs_csum_root(fs_info, disk_bytenr);
>> +
>> +	ret = btrfs_lookup_csums_list(csum_root, disk_bytenr,
>> +				      disk_bytenr + len - 1, &list, false);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* Clear the output buffer to handle potential gaps in csum coverage. */
>> +	if (clear_user(buf, (len >> fs_info->sectorsize_bits) * csum_size)) {
> 
> Clearning the partial range here is good but I think it should be done
> globally right at the start of the ioctl, regardless of how many data we
> return.
> 
> OTOH this can have a peformance hit in case a large buffer is provided
> by default but for various ranges and possibly short ones, not matching
> the entire buffer. So repeated calls will have to clear 16M but return
> a few kilobytes.

That's fine - this isn't an interface change, so we can always change it 
later if it turns out to be a bottleneck. At any rate it's going to be 
faster than userspace calculating the csums manually.

>> +		ret = -EFAULT;
>> +		goto out;
>> +	}
>> +
>> +	ret = 0;
>> +	while (!list_empty(&list)) {
>> +		u64 offset;
>> +		size_t copy_size;
>> +
>> +		sums = list_first_entry(&list, struct btrfs_ordered_sum, list);
>> +		list_del(&sums->list);
>> +
>> +		offset = ((sums->logical - disk_bytenr) >> fs_info->sectorsize_bits) * csum_size;
>> +		copy_size = (sums->len >> fs_info->sectorsize_bits) * csum_size;
>> +
>> +		if (copy_to_user(buf + offset, sums->sums, copy_size)) {
>> +			kfree(sums);
>> +			ret = -EFAULT;
>> +			goto out;
>> +		}
>> +
>> +		kfree(sums);
>> +	}
>> +
>> +out:
>> +	while (!list_empty(&list)) {
>> +		sums = list_first_entry(&list, struct btrfs_ordered_sum, list);
>> +		list_del(&sums->list);
>> +		kfree(sums);
>> +	}
>> +	return ret;
>> +}
>> +
>> +static int btrfs_ioctl_get_csums(struct file *file, void __user *argp)
>> +{
>> +	struct inode *inode = file_inode(file);
> 
> Please use vfs_inode
> 
>> +	struct btrfs_inode *bi = BTRFS_I(inode);
> 
> and plain inode
> 
>> +	struct btrfs_fs_info *fs_info = bi->root->fs_info;
>> +	struct btrfs_root *root = bi->root;
>> +	struct btrfs_ioctl_get_csums_args args;
>> +	BTRFS_PATH_AUTO_FREE(path);
>> +	const u64 ino = btrfs_ino(bi);
>> +	const u32 sectorsize = fs_info->sectorsize;
>> +	const u32 csum_size = fs_info->csum_size;
>> +	u8 __user *ubuf;
>> +	u64 buf_limit;
>> +	u64 buf_used = 0;
>> +	u64 cur_offset;
>> +	u64 end_offset;
>> +	u64 prev_extent_end;
>> +	struct btrfs_key key;
>> +	int ret;
>> +
>> +	if (!(file->f_mode & FMODE_READ))
>> +		return -EBADF;
>> +
>> +	if (!S_ISREG(inode->i_mode))
>> +		return -EINVAL;
>> +
>> +	if (copy_from_user(&args, argp, sizeof(args)))
>> +		return -EFAULT;
>> +
>> +	if (!IS_ALIGNED(args.offset, sectorsize) ||
>> +	    !IS_ALIGNED(args.length, sectorsize))
>> +		return -EINVAL;
>> +	if (args.length == 0)
>> +		return -EINVAL;
>> +	if (args.offset + args.length < args.offset)
>> +		return -EOVERFLOW;
>> +	if (args.flags != 0)
>> +		return -EINVAL;
>> +	if (args.buf_size < sizeof(struct btrfs_ioctl_get_csums_entry))
>> +		return -EINVAL;
>> +
>> +	buf_limit = min_t(u64, args.buf_size, GET_CSUMS_BUF_MAX);
>> +	ubuf = (u8 __user *)(argp + offsetof(struct btrfs_ioctl_get_csums_args, buf));
>> +	cur_offset = args.offset;
>> +	end_offset = args.offset + args.length;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	ret = btrfs_wait_ordered_range(bi, cur_offset, args.length);
>> +	if (ret)
>> +		return ret;
>> +
>> +	btrfs_inode_lock(bi, BTRFS_ILOCK_SHARED);
> 
> This needs to be interruptible, all other points are. There's no inode
> lock helper for that so you'd have to add it or call
> down_rwsem_interruptible().
> 
>> +
>> +	ret = btrfs_wait_ordered_range(bi, cur_offset, args.length);
>> +	if (ret)
>> +		goto out_unlock;
>> +
>> +	/* NODATASUM early exit. */
>> +	if (bi->flags & BTRFS_INODE_NODATASUM) {
>> +		struct btrfs_ioctl_get_csums_entry entry = {
>> +			.offset = cur_offset,
>> +			.length = end_offset - cur_offset,
>> +			.type = BTRFS_GET_CSUMS_NODATASUM,
>> +		};
>> +
>> +		if (copy_to_user(ubuf, &entry, sizeof(entry))) {
>> +			ret = -EFAULT;
>> +			goto out_unlock;
>> +		}
>> +
>> +		buf_used = sizeof(entry);
>> +		cur_offset = end_offset;
>> +		goto done;
>> +	}
>> +
>> +	prev_extent_end = cur_offset;
>> +
>> +	while (cur_offset < end_offset) {
>> +		struct btrfs_file_extent_item *ei;
>> +		struct extent_buffer *leaf;
>> +		struct btrfs_ioctl_get_csums_entry entry;
> 
> Please initialize that right away with = { 0 }, it's done later by
> memset() but for something filled partially it's better to do it at the
> beginning than forgetting to do it later.
> 
> Overall comment, please check the final patch that there are not
> unnecessary line breaks that overflow 80 chars only slightly. I've seen
> a few and would have fixed it but I think I've been pointing that out
> enough in the past. I'll fix anything that's left if needed.

