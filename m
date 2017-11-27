Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38829 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdK0XX3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 18:23:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D53AAADE0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Nov 2017 23:23:27 +0000 (UTC)
Date: Tue, 28 Nov 2017 00:21:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4 1/4] btrfs-progs: mkfs: Enhance minimal device size
 calculation to fix mkfs failure on small file
Message-ID: <20171127232131.GK3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171101013043.19294-1-wqu@suse.com>
 <20171101013043.19294-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171101013043.19294-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 09:30:40AM +0800, Qu Wenruo wrote:
> +u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
> +		       u64 data_profile)
> +{
> +	u64 reserved = 0;
> +	u64 meta_size;
> +	u64 data_size;
> +
> +	if (mixed)
> +		return 2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE +
> +			    btrfs_min_global_blk_rsv_size(nodesize));
> +
> +	/*
> +	 * minimal size calculation is complex due to several factors:
> +	 * 1) Temporary chunk resue
> +	 *    If specified chunk profile is SINGLE, we can resue
> +	 *    temporary chunks, no need to alloc new chunks.
> +	 *
> +	 * 2) Different minimal chunk size for different profile
> +	 *    For initial sys chunk, chunk size is fixed to 4M.
> +	 *    For single profile, minimal chunk size is 8M for all.
> +	 *    For other profiles, minimal chunk and stripe size
> +	 *    differs from 8M to 64M.
> +	 *
> +	 * To calculate it a little easier, here we assume we don't
> +	 * reuse any temporary chunk, and calculate the size all
> +	 * by ourselves.
> +	 *
> +	 * Temporary chunks sizes are always fixed:
> +	 * One initial sys chunk, one SINGLE meta, and one SINGLE data.
> +	 * The latter two are all 8M, accroding to @calc_size of
> +	 * btrfs_alloc_chunk().
> +	 */
> +	reserved += BTRFS_MKFS_SYSTEM_GROUP_SIZE + SZ_8M * 2;
> +
> +	/*
> +	 * For real chunks, we need to refer different sizes:
> +	 * For SINGLE, it's still fixed to 8M (@calc_size).
> +	 * For other profiles, refer to max(@min_stripe_size, @calc_size).
> +	 *
> +	 * And use the stripe size to calculate its physical used space.
> +	 */
> +	if (meta_profile & BTRFS_BLOCK_GROUP_PROFILE_MASK)
> +		meta_size = SZ_8M + SZ_32M;
> +	else
> +		meta_size = SZ_8M + SZ_8M;
> +	/* Only metadata put 2 stripes into one disk */

'mkfs.btrfs -d dup' also works, so I think this should be handled here
the same way as metadata, right?

> +	if (meta_profile & BTRFS_BLOCK_GROUP_DUP)
> +		meta_size *= 2;
> +	reserved += meta_size;
> +
> +	if (data_profile & BTRFS_BLOCK_GROUP_PROFILE_MASK)
> +		data_size = SZ_64M;
> +	else
> +		data_size = SZ_8M;
> +	if (data_profile & BTRFS_BLOCK_GROUP_DUP)
> +		data_size *= 2;
> +	reserved += data_size;
> +	return reserved;
> +}
