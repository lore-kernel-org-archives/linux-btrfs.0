Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DACD346FC3
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2026 04:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776573859; cv=none; b=q6O8xAnposB9vR6vkuGCaM+k2snVzZJTGWS3++qACUQin9KqStZaMFSt3kjgVSo9BiXTnpxCPOIE4SB9T77GvQoej1T0PdUVqrZhsJ29/WQFoIV+p6FiC4SNe6wkhuGs/nvwihvyKkqpfdZ+JYxSca4W3Xl4De0ZSaJuopLaShc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776573859; c=relaxed/simple;
	bh=plfYsTpVezT87ey7/OVSZCUaS24rzONspBY4F6ygeBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZFsg/eTpfIWXoShhaedAf0GEDcTSlkvD7h92UzZUyZGk18xsG3JL0q+URL/LLau8Ip48qm0iDw5r7OxR4H89oamFmmTIlUUxRuCsVHJ3JC4oq2I8oFA8h9MfiEryNmzosz2ldtT+ywRiUgorL287AnhedEPRSI0KXjsYsclKd9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OnBvsUzc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OnBvsUzc"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso20796115e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2026 21:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776573853; x=1777178653; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RaECflJokt1GxiUfUwhPRGxeFO5t1Q89htXXy49bnEg=;
        b=OnBvsUzcDOJdiDljJGJiHAlZrK0E3ifLQERwX22AyidMe8ANZi8GHoSSfL9m3/+p/z
         QgKtd5cxHrXY9Uolrwft+EPQawSFT9iYkmt163Sxs0qqbvq2IFNuttvPfjnUpHWvW8b4
         NZAwmwGXEbJMPJX2BUiqiXPYrdCY1zZIIk6AG54zTjsZdcxJRe9gETo8GPbHbUR3XyK/
         4LeuR7N6eugqo0aLN30AJrED/sig0tH1YHN/Gur0r7is6IU6HZ0GGe7mRa+aYxo79HSe
         hKEYaT7rnwV8D3yb6VPPSIVI8plhIZihjlLQen5UCKFE6He5zOXGeMIcCtSr0E0dI2Pc
         iljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776573853; x=1777178653;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RaECflJokt1GxiUfUwhPRGxeFO5t1Q89htXXy49bnEg=;
        b=KG+FL++jy8iuXv7s/f2Kk2eSoTf645VM1XWZ3MOv1DfNPYZHPkqoF5paqd1q0E0Z8M
         fLPryfl8Y4XaXQvBJUsenhviwXBdK3xGOx0ebbdIEK3Y5MzbifdLBgdXWrrFDeId1uJy
         8CxEn9eKh63xjw/noRvkTHXV+x2RgYVdxrccriLMO93fQop39/sziIxmXrQV9idJOYte
         ymU33kF+tiWQLahz0QI96ajGbj16u+5N4VbXJNGp17O72OwaPhrbYunA9bwx5UfHp9Dj
         0jhR+0vzvxdHLjiIjR7/yUcwih4b+OHAtlN1YAqQ8vSYQGSGBGBiQnUNR3Eu2hav5L/r
         jjgg==
X-Forwarded-Encrypted: i=1; AFNElJ+9k+kAXGQx2DiePUkgtuzN4yw1lUU6ZZRjz0TjZtlHS64yL81hqxQEAN/bmlkfmeux79nHlRvoNRsPNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwC1x4CsjXCo9AdV81TfSZkR3Q9zObTvUF5naVlxjv1A2yFQa8P
	/yeUQJ0EKy2wlyd4cgn9OC2meyix2vKkpUe/Y+mbkI6RunNqcTPd0lV8pmR+f0TtQII=
X-Gm-Gg: AeBDiesHIHXJkZsUbv6iTmQqU8sRY9tj07Dm7W2Lyz2y8qC5qydnrOGg+pgc4SQAIyt
	TMRVk/IrPNGHQTp5evjBkatbZJ/5xWRywRpJo4lXYIvtEsDX2ctrahETUzVB5IXrZJdousVnO9X
	oMzGkHSB33GP4lyIMjtQl3v7onTCKitoDGvKT16ZhIHfXJ5L4rlgMH26sp0bKl7HHRTkOkQNg3D
	D3a9wwoJ6BbpEBwLerm46U1lVoG73AhH8X94Hbnitl1EFV4hG0SFkp7nvsBkdS68Vxp2u9Z7MzX
	Fe+e04a6ENzikN1FURsDMshztxZbDcxpJHUGnXVYTFgKAE/BF6/awkplTaleGEypRhCYUt8jFnE
	mz156964bkIMSptLq6C3dkU22C5IaRIR7hhPB/xhB7RYQfzk1+ED3zyfkLOz8b5YuQvw8UGrR7D
	Fu4ZecQkgCpJ2qPMqGvMJ12IuGpHfMX1OzwsjpuaD1nnhqIY2LboO+SV5YBTppCw==
X-Received: by 2002:a05:600c:681b:b0:488:b9c6:11ba with SMTP id 5b1f17b1804b1-488fb794f80mr109324315e9.28.1776573853384;
        Sat, 18 Apr 2026 21:44:13 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff918sm67448705ad.13.2026.04.18.21.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2026 21:44:12 -0700 (PDT)
Message-ID: <6f19a16e-3ae6-4253-9a97-35a98bd767a9@suse.com>
Date: Sun, 19 Apr 2026 14:14:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: support for FALLOC_FL_INSERT_RANGE in
 btrfs_fallocate()
To: Paul Richards <paul.richards@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260418143808.199603-1-paul.richards@gmail.com>
 <20260418143808.199603-4-paul.richards@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260418143808.199603-4-paul.richards@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/19 00:08, Paul Richards 写道:
> Assisted-by: Amazon Q Developer:auto/unknown
> Signed-off-by: Paul Richards <paul.richards@gmail.com>
> ---
>   fs/btrfs/file.c | 238 ++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 238 insertions(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 99d24bef5f88..b708bb6a1082 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2945,6 +2945,241 @@ static int btrfs_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>   	return ret;
>   }
>   
> +static int btrfs_insert_range(struct inode *inode, loff_t offset, loff_t len)
> +{
> +	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_path *path;
> +	struct btrfs_trans_handle *trans = NULL;
> +	struct extent_buffer *leaf;
> +	struct btrfs_key key;
> +	struct btrfs_key new_key;
> +	u64 ino = btrfs_ino(BTRFS_I(inode));
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL))
> +		return -EOPNOTSUPP;
> +
> +	/* offset and len must be sector-aligned */
> +	if (!IS_ALIGNED(offset | len, fs_info->sectorsize))
> +		return -EINVAL;
> +
> +	/* offset must be within the file - use ftruncate to extend */
> +	if (offset >= inode->i_size)
> +		return -EINVAL;
> +
> +	/* result must not exceed the maximum file size */
> +	if (len > inode->i_sb->s_maxbytes - inode->i_size)
> +		return -EFBIG;
> +
> +	btrfs_info(fs_info,
> +		   "btrfs_insert_range: ino=%llu offset=%lld len=%lld i_size=%lld",
> +		   btrfs_ino(BTRFS_I(inode)), offset, len, inode->i_size);
> +
> +	/* wait for any ordered extents in [offset, i_size) to complete */
> +	ret = btrfs_wait_ordered_range(BTRFS_I(inode), offset,
> +				       inode->i_size - offset);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Flush and invalidate the page cache for [offset, i_size) upfront,
> +	 * following the same pattern as btrfs_collapse_range().
> +	 */
> +	ret = filemap_write_and_wait_range(inode->i_mapping, offset, LLONG_MAX);
> +	if (ret)
> +		return ret;
> +	truncate_pagecache_range(inode, offset, LLONG_MAX);
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	trans = btrfs_start_transaction(root, 1);

As we may iterate through a lot of file items, the nr_items == 1 is 
definitely not correct.

On the other hand I'm not sure what's the correct nr_item to be passed 
here either.
Thus this may cause problems for metadata reservation. This also applies 
to the previous patch.

> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		trans = NULL;
> +		goto out_path;
> +	}
> +
> +	/*
> +	 * Shift all BTRFS_EXTENT_DATA_KEY items with key.offset >= offset
> +	 * rightward by len bytes.
> +	 *
> +	 * We must iterate in reverse order (highest offset first) to avoid
> +	 * colliding with a key we haven't shifted yet - shifting forward
> +	 * would overwrite the next item's key before we process it.

OK, this explains why we can not have a shared helper to do the file 
offset shift.

> +	 *
> +	 * No pre-splitting of straddling extents is needed. If an extent
> +	 * straddles offset, the left portion (key.offset < offset) stays
> +	 * in place and the right portion is shifted. Both reference the
> +	 * same physical extent via their existing extent_offset fields,
> +	 * which remain correct after the key shift.
> +	 */
> +
> +	int nr_shifted = 0;
> +
> +	/* Find the last extent item for this inode */
> +	key.objectid = ino;
> +	key.type = BTRFS_EXTENT_DATA_KEY;
> +	key.offset = (u64)-1;
> +
> +	while (1) {
> +		struct btrfs_file_extent_item *fi;
> +		u64 disk_bytenr;
> +		u64 num_bytes;
> +		u64 extent_offset;
> +		int extent_type;
> +
> +		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);

Again you're doing btrfs_search_slot() for every file item, which is 
very inefficient.

> +		if (ret < 0)
> +			goto out_trans;
> +
> +		/*
> +		 * Search for (ino, EXTENT_DATA, -1) will never find an exact
> +		 * match, so ret == 1 and slot points one past the last item.
> +		 * Step back one slot to land on the last extent item.
> +		 */
> +		if (path->slots[0] == 0) {
> +			/* No items at all - nothing to shift */
> +			ret = 0;
> +			break;
> +		}
> +		path->slots[0]--;
> +
> +		leaf = path->nodes[0];
> +		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
> +
> +		/* If we've gone past this inode's items, we are done */
> +		if (key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY) {
> +			ret = 0;
> +			break;
> +		}
> +
> +		/* If this item is before the insertion point, we are done */
> +		if (key.offset < offset) {
> +			ret = 0;
> +			break;
> +		}
> +
> +		btrfs_info(fs_info,
> +			   "btrfs_insert_range: shifting key offset %llu -> %llu",
> +			   key.offset, key.offset + len);
> +
> +		fi = btrfs_item_ptr(leaf, path->slots[0],
> +				    struct btrfs_file_extent_item);
> +		extent_type = btrfs_file_extent_type(leaf, fi);
> +		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
> +		num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
> +		extent_offset = btrfs_file_extent_offset(leaf, fi);
> +
> +		/*
> +		 * Inline extents must have key.offset == 0 and cannot be
> +		 * shifted to a non-zero offset - the tree checker enforces
> +		 * this invariant. Reject with -EOPNOTSUPP.
> +		 *
> +		 * An inline extent can only exist if the file's entire content
> +		 * fits within a single sector, meaning it is the only extent
> +		 * item for this inode. It will therefore always be the first
> +		 * item we encounter in the reverse iteration, before any keys
> +		 * have been shifted, so bailing here leaves the file in a
> +		 * consistent state.
> +		 *
> +		 * TODO: support this case by converting the inline extent to
> +		 * a regular extent first, then shifting it. This would allow
> +		 * INSERT_RANGE on small files, which xfs supports.
> +		 */
> +		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> +			ret = -EOPNOTSUPP;
> +			btrfs_release_path(path);
> +			goto out_trans;
> +		}
> +
> +		memcpy(&new_key, &key, sizeof(new_key));
> +		new_key.offset += len;
> +		btrfs_set_item_key_safe(trans, path, &new_key);
> +
> +		/* Update back-reference: drop old offset, add new offset */
> +		if (extent_type != BTRFS_FILE_EXTENT_INLINE && disk_bytenr > 0) {
> +			ret = btrfs_shift_extent_backref(trans, root, ino,
> +					disk_bytenr, num_bytes,
> +					key.offset - extent_offset,
> +					new_key.offset - extent_offset);
> +			if (unlikely(ret))
> +				goto out_trans;
> +		}
> +
> +		/*
> +		 * Step back to the previous item for the next iteration.
> +		 * If we've reached slot 0 we need to move to the previous leaf.
> +		 */
> +		nr_shifted++;
> +		if (nr_shifted % BTRFS_INSERT_COLLAPSE_TRANSACTION_CYCLE_INTERVAL == 0) {
> +			btrfs_info(fs_info,
> +			   "btrfs_insert_range: cycling transaction, nr_shifted=%d", nr_shifted);
> +
> +			inode_inc_iversion(inode);
> +			inode_set_mtime_to_ts(inode,
> +					      inode_set_ctime_current(inode));
> +			ret = btrfs_update_inode(trans, BTRFS_I(inode));
> +			if (ret) {
> +				btrfs_release_path(path);
> +				goto out_trans;
> +			}
> +			btrfs_end_transaction(trans);
> +			btrfs_btree_balance_dirty(fs_info);
> +			trans = btrfs_start_transaction(root, 1);
> +			if (IS_ERR(trans)) {
> +				ret = PTR_ERR(trans);
> +				trans = NULL;
> +				btrfs_release_path(path);
> +				goto out_path;
> +			}
> +		}
> +
> +		/*
> +		 * Set key.offset to one below the current item so the next
> +		 * btrfs_search_slot lands on the item before it.
> +		 */
> +		if (key.offset == 0) {
> +			ret = 0;
> +			break;
> +		}
> +		key.offset--;
> +		btrfs_release_path(path);
> +	}
> +
> +	if (ret)
> +		goto out_trans;
> +
> +	/*
> +	 * Drop stale extent map entries so subsequent reads re-load correct
> +	 * mappings from the btree.
> +	 */
> +	btrfs_drop_extent_map_range(BTRFS_I(inode), offset, (u64)-1, false);
> +
> +	btrfs_info(fs_info,
> +		   "btrfs_insert_range: updating i_size %lld -> %lld",
> +		   inode->i_size, inode->i_size + len);
> +	inode_inc_iversion(inode);
> +	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +	i_size_write(inode, inode->i_size + len);
> +	btrfs_inode_safe_disk_i_size_write(BTRFS_I(inode), 0);
> +	ret = btrfs_update_inode(trans, BTRFS_I(inode));

After shifting all file extents to new file offsets, there is a hole in 
the range [@offset, @offset + @len), but there is no explicit hole 
extent for the range if ^no-holes.

This will cause fsck errors.

Thanks,
Qu

> +
> +out_trans:
> +	if (trans) {
> +		if (ret)
> +			btrfs_end_transaction(trans);
> +		else
> +			ret = btrfs_end_transaction(trans);
> +	}
> +out_path:
> +	btrfs_free_path(path);
> +	btrfs_info(fs_info, "btrfs_insert_range: returning %d", ret);
> +	return ret;
> +}
> +
>   static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
>   {
>   	struct inode *inode = file_inode(file);
> @@ -3596,6 +3831,9 @@ static long btrfs_fallocate(struct file *file, int mode,
>   	case FALLOC_FL_COLLAPSE_RANGE:
>   		ret = btrfs_collapse_range(inode, offset, len);
>   		break;
> +	case FALLOC_FL_INSERT_RANGE:
> +		ret = btrfs_insert_range(inode, offset, len);
> +		break;
>   	default:
>   		ret = -EOPNOTSUPP;
>   	}

