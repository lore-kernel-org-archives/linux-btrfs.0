Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AE23E316B
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 08:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785141500; cv=none; b=mJzwGeBiXUWfhv8sidM1mmW+8EbNHGRgBKNV0cFFV1U7XWz6jPSwZ0H8tkg31jue9ge+cQZI6hKXcEDzZ3xKYRGBDRfHOKyPR8wTiChA906mu7yesadoWcbyUHQQEQAynsUiT324qB16Bv9z1ZgqHnt/im8OhElrsfBxzwHXLK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785141500; c=relaxed/simple;
	bh=/EqyqfkBKxZ5+pMr5EqltkNxP0Z7LTHGJ5LqW/iOTyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M3R4C16qU47tPrp3Qzg5eY39mWInBbGdbCa65AVmyCAeu6CcihUzdyO6MCTp3bOVCP/PO/qiOrHDj+HPPK542/WOgH5HYfUGTN2DT58PbQl0BQOGuMJ6FYFvgPJ2xRV5wcdxo8zD8lRYBFDkWZRBnxEA1vA/pyZz0w+TVPRal20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=chs5PnFo; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="chs5PnFo"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-495757ccbc1so22484315e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 01:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785141495; x=1785746295; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YosLvDkB9h/G3eVEuQgq8C9VDZxfaJ+1RkYLHw2lclQ=;
        b=chs5PnFo/c4syxIn4/ytnbuynn8zXgLfdtfwEaBTyAoLTPnlhJ/jSYqUzuo/P1prJZ
         lBu3FdhkM1FwVenqWuYs9T3ct1DKZO+VfVENnqW0ivqCvHQwEXttSNNKqWpYwf109AxR
         OqdnBtIYhEUiB59HXRUst2kCX8GpLyGC05jbPIyWmq+eFR7MDObJRU9jb/yxJPXbYkuG
         WazyWrTpiAJN4F1TSroIOZljgxLdjQO8MuIi+H21DBtdT31JkspFgMTRH/sjCPTtNdFM
         hOD8BkFTHh1DjaAm6sksu0JwMKkytfMH1aenCgz1LvUWSyXDBZwAufzX0P4MNekkHDO8
         aQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785141495; x=1785746295;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YosLvDkB9h/G3eVEuQgq8C9VDZxfaJ+1RkYLHw2lclQ=;
        b=Iyjdc+Ultp+MSM+SHO54oZIl3kPUluG7YneC0+vPpSDnPIu8jXNUsGNSriTDked12G
         U5Y9uHNLZqeq/W6cUvkP0onShYGxUEuYV2N7m5WgwEKp1Ty+I7hrnNCCnu+n6pE1i3nx
         bYVQzEwJVMhuzVBlg9uCt3wEsEsZ295x0FkWFiLH/2IGpobYj8svHwoXR8z7HMJnBI+H
         phzJlAVAh6qaZC0BgqQ7Uz3XaDg6D1HWaodZDjmSs7r3WZoHQM+AvKXFQBTWisc4/En6
         hCyJAkMgpgoynzZkSX7RsTiImBU5Wcv2s7knqPHWvCMToaIZR8zl9hTE1TRx1G/oZY9h
         mReQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp22x1jteAWlWj4v8RxTQzxxlNd/KABsEgRNqs/A6Y0g4gyuPlJG5AVC47PcSUVmA6Yj+daHjhz321C8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9c4wmd5u0jQswPrub9DqKEkEka8SEpCdDc2fuk7pM1SmRbj8E
	orKIiONq+TgQESrIR/SnwxUGNyTJSzV4X855znW5pHMDnLtdV7X6n6sTmCKa1BGRn+s=
X-Gm-Gg: AR+sD11S1Y0IJ/9JYxxgSBCnPg7roprExvfjyUX4gkLt3vM3O2kHPoWSDHbGvNV3qon
	gtk/O9fhjX/kWckiyG2/o9lBWmkYUVKbh6X+nr92yIhUQABgXEx58SBJk4OUgtgQ7BlslVGlzPf
	f4i56toVupnJ0qf/7GxgGkRVWRlNNO8pPu6jy0Y7Dhy3OcuTG0ejCSYqgEmkS9bn1AtJI6pnN3P
	kbaARTT1wYvzz8tOO+Aror+QHGea3NZoPxdJsCxmBkj6wt3+o5+VIQ/bIwEQDG2mGZVzCdcaUYZ
	VFsTBqEoqp/v/IXBQfEvU0pccs4xnl8x95LXZjLq+R5QkRVmGvpCi+xCQ/yxs2ygKQR+AvWwhSq
	DRW1+X5O3NALkPi5osNgnDECRfk8uHtPepI5iUxOgWI6LC/0QAUMA7cKio0j6R0uQDAnOCUQ=
X-Received: by 2002:a05:600c:35d0:b0:493:e79e:da63 with SMTP id 5b1f17b1804b1-496b5708bacmr93093375e9.34.1785141494361;
        Mon, 27 Jul 2026 01:38:14 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e52f0c6f2sm23981332c88.11.2026.07.27.01.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 01:38:13 -0700 (PDT)
Message-ID: <5b2694a2-a5cd-47bd-b225-8d7c74426e2d@suse.com>
Date: Mon, 27 Jul 2026 18:08:08 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: trigger cow fixup via dirty_folio()
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: willy@infradead.org
References: <9f7a81cdd022d9e3f69d347a17c0a25438ccec14.1785131713.git.boris@bur.io>
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
In-Reply-To: <9f7a81cdd022d9e3f69d347a17c0a25438ccec14.1785131713.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/27 15:30, Boris Burkov 写道:
[...]
> +static noinline_for_stack int writepage_fixup(struct btrfs_inode *inode,
> +					      struct folio *folio,
> +					      struct btrfs_bio_ctrl *bio_ctrl)
> +{
> +	struct btrfs_fs_info *fs_info = inode_to_fs_info(&inode->vfs_inode);
> +	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
> +	const u32 sectorsize = fs_info->sectorsize;
> +	const u64 page_start = folio_pos(folio);
> +	bool found_fixup = false;
> +	unsigned int bit;
> +
> +	/*
> +	 * A folio was dirtied without calling aops->dirty_folio() which we
> +	 * explicitly assert is not allowed.
> +	 */
> +	if (unlikely(bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio))) {
> +		DEBUG_WARN();
> +		btrfs_err_rl(fs_info,
> +			     "root %lld ino %llu folio %llu is dirty with an empty dirty bitmap",
> +			     btrfs_root_id(inode->root), btrfs_ino(inode),
> +			     folio_pos(folio));
> +		return -EUCLEAN;
> +	}
> +
> +	/* Cheap check on the folio flag. Set iff the fixup bitmap is non-empty. */
> +	if (likely(!folio_test_fixup_pending(folio)))
> +		return 0;
> +
> +	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
> +		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
> +		const bool needs_fixup = btrfs_folio_test_fixup(fs_info, folio,
> +								start, sectorsize);
> +
> +		debug_check_writepage_fixup(inode, start, sectorsize, needs_fixup);
> +		if (needs_fixup) {
> +			bitmap_clear(bio_ctrl->submit_bitmap, bit, 1);
> +			found_fixup = true;
> +		}
> +	}
> +	if (likely(found_fixup)) {
> +		btrfs_queue_writepage_fixup(inode, folio);

Missing the error handling of -ENOMEM.

> +		folio_redirty_for_writepage(bio_ctrl->wbc, folio);
> +		if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
> +			folio_unlock(folio);
> +			return 1;
> +		}
> +		return 0;
> +	}
> +	/* We should always find fixup if the folio fixup flag was set. */
> +	DEBUG_WARN();
> +	btrfs_err_rl(fs_info,
> +		     "root %lld ino %llu folio %llu is fixup with an empty fixup bitmap",
> +		     btrfs_root_id(inode->root), btrfs_ino(inode),
> +		     folio_pos(folio));
> +
> +	return -EUCLEAN;
> +}
> +
>   /*
>    * Do all of the delayed allocation setup.
>    *
> @@ -1514,6 +1623,10 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
>   	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
>   	btrfs_copy_subpage_dirty_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
>   
> +	ret = writepage_fixup(inode, folio, bio_ctrl);
> +	if (ret)
> +		return ret;
> +
>   	for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
>   			      blocks_per_folio) {
>   		u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 06b5884a9bcd..11503848a64d 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -714,6 +714,8 @@ struct btrfs_fs_info {
>   	struct btrfs_workqueue *endio_write_workers;
>   	struct btrfs_workqueue *endio_freespace_worker;
>   	struct btrfs_workqueue *caching_workers;
> +
> +	struct btrfs_workqueue *fixup_workers;

Do we need btrfs_workqueue? This workload doesn't need to complex async 
submission and sequential ending.

Thus a regular workqueue should be enough.

> +static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
> +{
> +	struct btrfs_writepage_fixup *fixup =
> +		container_of(work, struct btrfs_writepage_fixup, work);
> +	struct extent_state *cached_state = NULL;
> +	struct extent_changeset *data_reserved = NULL;
> +	unsigned long delalloc_bitmap[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO)] = { 0 };
> +	struct folio *folio = fixup->folio;
> +	struct btrfs_inode *inode = fixup->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
> +	const u32 sectorsize = fs_info->sectorsize;
> +	const u64 page_start = folio_pos(folio);
> +	const u64 page_end = folio_next_pos(folio) - 1;
> +	unsigned int start_bit;
> +	unsigned int end_bit;
> +	unsigned int bit;
> +	bool reserved;
> +	int ret;
> +
> +	/*
> +	 * We would prefer to reserve under the folio lock when we know exactly
> +	 * which blocks need a reservation. Unfortunately, since the reservation
> +	 * can go into flushers which can go into writeback, which takes folio
> +	 * locks, that is not possible. Therefore, we have to reserve for the
> +	 * whole folio here, then release what we didn't end up needing once we
> +	 * figure it out.
> +	 *
> +	 * Also note the slightly strange error checking. If fixup is actually
> +	 * not set, we don't need to mark an error on the mapping. So hang on to
> +	 * ret until after we lock and find out if we actually care.
> +	 */
> +	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
> +					   folio_size(folio));
> +	reserved = (ret == 0);
> +again:
> +	folio_lock(folio);
> +
> +	if (!folio->mapping || !folio_test_fixup_pending(folio))
> +		goto out;
> +	if (ret)
> +		goto out_error;
> +
> +	btrfs_lock_extent(&inode->io_tree, page_start, page_end, &cached_state);
> +
> +	for (bit = 0; bit < blocks_per_folio; bit++) {
> +		struct btrfs_ordered_extent *ordered;
> +		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
> +
> +		if (test_bit(bit, delalloc_bitmap))

Dead check. It's always false, as the delalloc_bitmap is initialized to 
all zero.
> +			continue;
> +		if (!btrfs_folio_test_fixup(fs_info, folio, start, sectorsize))
> +			continue;
> +		/*
> +		 * Any task that sets EXTENT_DELALLOC clears the fixup bits
> +		 * under the folio lock, so it should be impossible to observe
> +		 * both under the lock. Setting delalloc twice would wrongly
> +		 * double account the space.
> +		 */
> +		if (IS_ENABLED(CONFIG_BTRFS_DEBUG) &&
> +		    unlikely(btrfs_test_range_bit_exists(&inode->io_tree, start,
> +							 start + sectorsize - 1,
> +							 EXTENT_DELALLOC))) {
> +			DEBUG_WARN("fixup worker: delalloc and fixup conflict. ino %llu start %llu",
> +				   btrfs_ino(inode), start);
> +			btrfs_folio_clear_fixup(fs_info, folio, start, sectorsize);
> +			continue;
> +		}
> +		ordered = btrfs_lookup_ordered_range(inode, start, sectorsize);
> +		if (ordered) {
> +			trace_btrfs_writepage_fixup_defer(inode, ordered);
> +			btrfs_unlock_extent(&inode->io_tree, page_start,
> +					    page_end, &cached_state);
> +			folio_unlock(folio);
> +			btrfs_start_ordered_extent(ordered);
> +			btrfs_put_ordered_extent(ordered);
> +			goto again;
> +		}
> +		ret = btrfs_set_extent_delalloc(inode, start,
> +						start + sectorsize - 1, 0,
> +						&cached_state);
> +		if (ret) {
> +			btrfs_unlock_extent(&inode->io_tree, page_start,
> +					    page_end, &cached_state);
> +			goto out_error;
> +		}
> +		trace_btrfs_writepage_fixup_reserve(inode, start, sectorsize);
> +		btrfs_folio_clear_fixup(fs_info, folio, start, sectorsize);
> +		set_bit(bit, delalloc_bitmap);
> +	}
> +
> +	btrfs_unlock_extent(&inode->io_tree, page_start, page_end, &cached_state);
> +	goto out;
> +
> +out_error:

This goto out; to skip error handling looks a little weird.

Considering we never overwrite @ret during error path, I'd prefer to hid 
the two error handling lines behide an "if (ret < 0) {}", and remove 
"out_error:" label, and the above "goto out;".


> +	/* Failure here is analagous to failure in writeback. */
> +	mapping_set_error(folio->mapping, ret);
> +	btrfs_folio_clear_fixup_dirty(fs_info, folio, page_start,
> +				      folio_size(folio));
> +out:
> +	if (reserved) {
> +		btrfs_delalloc_release_extents(inode, folio_size(folio));
> +		for_each_clear_bitrange(start_bit, end_bit, delalloc_bitmap,
> +					blocks_per_folio)
> +			btrfs_delalloc_release_space(inode, data_reserved,
> +				page_start + (start_bit << fs_info->sectorsize_bits),
> +				(end_bit - start_bit) << fs_info->sectorsize_bits,
> +				true);
> +	}
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	kfree(fixup);
> +	extent_changeset_free(data_reserved);
> +	btrfs_add_delayed_iput(inode);
> +}
> +
> +/*
> + * Queue space reservation fixup work for blocks dirtied without a space reservation.
> + *
> + * Should be used by writeback while holding the folio locked.
> + */
> +int btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio)
> +{
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct btrfs_writepage_fixup *fixup;
> +
> +	fixup = kzalloc_obj(*fixup, GFP_NOFS);
> +	if (!fixup)
> +		return -ENOMEM;
> +
> +	/*
> +	 * The worker's space reservation happens outside the folio lock, and
> +	 * folio->mapping cannot be trusted outside of it. Pin the inode
> +	 * alongside the folio.
> +	 */
> +	ihold(&inode->vfs_inode);
> +	folio_get(folio);
> +	btrfs_init_work(&fixup->work, btrfs_writepage_fixup_worker, NULL);
> +	fixup->folio = folio;
> +	fixup->inode = inode;
> +	btrfs_queue_work(fs_info->fixup_workers, &fixup->work);
> +	return 0;
> +}
> +
>   /*
>    * Clear the old accounting flags and set EXTENT_DELALLOC for the range.
>    *
> @@ -7519,6 +7676,12 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
>   	folio_wait_writeback(folio);
>   	wait_subpage_spinlock(folio);
>   
> +	/*
> +	 * The invalidated blocks are going away; drop any fixup blocks among
> +	 * them, data included, as they have no space reservation.
> +	 */
> +	btrfs_folio_clear_fixup_dirty(fs_info, folio, page_start + offset, length);
> +
>   	/*
>   	 * For subpage case, we have call sites like
>   	 * btrfs_punch_hole_lock_range() which passes range not aligned to
> @@ -10584,6 +10747,31 @@ static const struct file_operations btrfs_dir_file_operations = {
>   	.setlease	= generic_setlease,
>   };
>   
> +/*
> + * The folio is going dirty without a btrfs delalloc space reservation.
> + * This requires a fixup before writeback which we might sleep so cannot
> + * run in this context, so we merely set state on the folio indicating it
> + * needs fixup before writeback.
> + *
> + * Note that there is no range in the input, so the whole folio is marked
> + * dirty and fixup.
> + */
> +static bool btrfs_data_dirty_folio(struct address_space *mapping,
> +				   struct folio *folio)
> +{
> +	struct btrfs_inode *inode = BTRFS_I(mapping->host);
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	const u64 page_start = folio_pos(folio);
> +	const u64 range_end = min_t(u64, folio_next_pos(folio),
> +				    round_up(i_size_read(&inode->vfs_inode),
> +					     fs_info->sectorsize));

Not sure if we need to handle anything beyond EOF yet.

If it's beyond EOF, we still re-dirty them, at during writeback it will 
trigger the beyond EOF handling.

Thus it looks like we do not need to do this here.

> +
> +	if (range_end > page_start)
> +		btrfs_folio_set_fixup_dirty(fs_info, folio, page_start,
> +					    range_end - page_start);
> +	return filemap_dirty_folio(mapping, folio);
> +}
> +
>   /*
>    * btrfs doesn't support the bmap operation because swapfiles
>    * use bmap to make a mapping of extents in the file.  They assume
> @@ -10604,7 +10792,7 @@ static const struct address_space_operations btrfs_aops = {
>   	.launder_folio	= btrfs_launder_folio,
>   	.release_folio	= btrfs_release_folio,
>   	.migrate_folio	= btrfs_migrate_folio,
> -	.dirty_folio	= filemap_dirty_folio,
> +	.dirty_folio	= btrfs_data_dirty_folio,
>   	.error_remove_folio = generic_error_remove_folio,
>   	.swap_activate	= btrfs_swap_activate,
>   	.swap_deactivate = btrfs_swap_deactivate,
> diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
> index 2a9397be8116..a986a4bf61c9 100644
> --- a/fs/btrfs/subpage.c
> +++ b/fs/btrfs/subpage.c
> @@ -345,18 +345,57 @@ void btrfs_subpage_clear_uptodate(const struct btrfs_fs_info *fs_info,
>   	spin_unlock_irqrestore(&bfs->lock, flags);
>   }
>   
> +/*
> + * folio_mark_dirty() for a folio we are dirtying with a space reservation.
> + *
> + * dirtiers without a reservation use btrfs_data_dirty_folio().
> + */
> +static void btrfs_folio_mark_dirty(struct folio *folio)
> +{
> +	struct address_space *mapping = folio_mapping(folio);
> +
> +	if (!mapping || !mapping->host || !is_data_inode(BTRFS_I(mapping->host))) {

Oh, you have find out the better way to distinguish metadata inode.

If the folio has no mapping, it must belong to a dummy eb, thus it must 
not be data folio.

Kudos to that.

Otherwise looks good to me.

Great thanks for the fix,
Qu

