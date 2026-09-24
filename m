Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019382C027C
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271402; cv=none; b=PVC/CKGob0ZLe4pta3cwqRNJzzTequpRfAz2wqae/KAAFhgI+k22GHTPJgXK6FV3tcN3eoyh/Zz/5heTXyrNrQCublnlzaE3ik6onjE+n5MWUAaelFyfW7NqylunyJNSnVjdss5gyXlggggO2QQR67tMmir+vuHaSQ2XSiWrcj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271402; c=relaxed/simple;
	bh=9I9UhLKF4cXsEsdfjCkgGR4vR43RMu9o2VbADGesL7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KwlWjBcaec69eRdFEP+lYskWtSD+klT3keb8V5G3oTvfe2jzPzXIdlOVD1XENXpmFW3gmaxiLrDxGjM/iGB/egun3nu4KQAYiKAqzRL2yMBmoKS1G8VJEVS2thufBCrRtESgWGEeXjJhNSte7u2seRl+L2JjDNKuMpl+MMRQl/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=a4SEeo5v; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vW+b3y2K; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="a4SEeo5v";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vW+b3y2K"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id EA29E7A0021;
	Thu, 24 Sep 2026 13:36:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 24 Sep 2026 13:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1790271399; x=1790357799; bh=Zrl/sHnu0Y
	tjARYl5Ml4OwYyPlhG1pn5MEcXhe1MbFA=; b=a4SEeo5vOAhvBVRZATEraCv9+w
	vM/gfQyHjgfZhn6ZRkyfiptNQWkY6bBWa/keKnlZvqR0stKIW87BTJ1XazeZsNNT
	esz7xT5veKWmTUd25fTaAFpWv+9bLK4qs1nHDiPUZrzJT+RTLJa10PufV2zDVW/R
	t4rLarIE+2dpcURwhe+5fhxS83zG4MJpDP2M2A9ty0NLHrAUSbwXSLMdkV8H+iY1
	/Qrs8daBLK5vYmgrcJibmxSzW5emWGNAaOLbtLld9bvHEkcrx5sgDBNHL4GEoBag
	qKj1okEmRnaFkutxIuuzfS+x1e+TIWV6GKPmdPZ6yWGZvXTJCBFclgZIFh/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790271399; x=1790357799; bh=Zrl/sHnu0YtjARYl5Ml4OwYyPlhG1pn5MEc
	Xhe1MbFA=; b=vW+b3y2KkfNj408BYm+jjt48MFq1BujYb3LUhjbhcCvWeKnJITZ
	GJDGqZTsVtVTZoJLId2tiSs6DwqbVbcEGKFCsHaBP2MkZN158+72WUfSt93n0cBH
	1PYq9R88oA0z5XP5cVD9eW1Ux0cvcA1ARflboZDRTBIJt/cNqMmK2q/70P+yO6p/
	o2/3tcbCcflbNnpHWdO4wBEVg3SfY24UyiCBIy73jXjmBE94LZf7+TWuEIuUlyso
	WcX5e8J5jrCEKhEoe+FA89BEYWeHrKBTuY6U42i+EBVp8OQecQTknfQ2HQWzQeQB
	lEqS+gwjA2BqTCdM6o7c3EZ7twICgfOnTrQ==
X-ME-Sender: <xms:p1-1aqj0qso2HBrsm6yoFjUneymJ6mth7gRrPbFtzteigGb9hCTQ6g>
    <xme:p1-1ahC7DPaSeni1pwegTmnFI7wUZiJhgfJTC3TCw_SrZLMp1J2RbBtZ6t2dMrkXI
    -Vig_txjT0fnVHVhDhM9H94_2qQ4W3vilfM9pWP9m5kFdXKASjLI8Ns>
X-ME-Received: <xmr:p1-1avv7hLqMM7pXINZM2AYi7hPy-GPzx0EkimP7oWK0iTJJf7tx0qE>
X-ME-Proxy-Cause: dmFkZTE1TwKDhEB61c7Ww8tPYOfi98zfg4Uo29wIg/J0M64NTdsVqOpDqaGTnuY0Mtt+kV
    VQ3PtfnIwui5oZ52f/vAapktOmodixsCpvD+WCE6RCG0Eg4/RLBC5JiontbrD2pBXp5fOJ
    EJdthkeabjTZ2kC/ayk76Uv1fvDMZLfHvnMgwu1ohY0cGkOy2xN5asbSsgz5YNSUS+3lzx
    x7uQyBTigSXSTNT/w0jpCF3nK2seF+pFXoHbdfuvU/+Q6XxJYIq3rBExlGXTc+1/yzJETO
    Xqm40M3JYAc3oGHUPfen5h5i3UQ60/AQoXebGPcxLyoBEi0qfu3oO0Mmevea9ZaN4dYBs4
    Q7A8Wc62vi98i08tSPjcwtxYYkOI/oB67nLxpwG6V0g3epaGJGRuxYNlYH0NMGDWYgIpR2
    4gwn8fjgTVfcrvS4SD1IwekJvMQ5ivgubAXtIMVRK2KORCeHlF/raU1VjwY5IrnOIQN6Vi
    0OO8p/0q+i6uYQiGrnDZax/ENwZljN/erTUdbrXwEy/Z5k7xmS0KXL3MaDyHu2yE9/TO74
    37/oFG7tZf+2eXpPwqnI+gLfaGRjFVaE4A3aV/8Vi0McdPMr4112ZPZaaNYbYb9embcxTD
    Do9ma0Yi8FR3dsjO5Tan++xvbCvV2eafx+7ZOmdp5TkKeGvycqLPbkTVahIQ
X-ME-Proxy: <xmx:p1-1auYUQQK1Hm7qHMvUFe6AC1o1cuVXF8M4mC6b_O-UzKChVFeQxQ>
    <xmx:p1-1aqUHSxBg6D6KN2n6u-Nc0VaPCpHVAEWPLzLCPbnFpKD0vN4wrQ>
    <xmx:p1-1aq5qhBhE3Q2XnMCuBEtbjVFPa-2FkGJMSyrPmrdFOSUX-fQcAw>
    <xmx:p1-1athyNoCnFbVG_CZTFXckozKsqkqv3_B3UUkpZpo-iW0IQAzX4A>
    <xmx:p1-1aotXu7g1r_PhiWPMw3XcDTCpV0ueGjw2hNGpip3qvjM9j68gjXWu>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 13:36:39 -0400 (EDT)
Date: Thu, 24 Sep 2026 10:36:41 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 5/6] btrfs: implement uncompressed fallback for
 delayed bbio
Message-ID: <20260924173641.GC2146908@zen.localdomain>
References: <cover.1789687750.git.wqu@suse.com>
 <bc25ff663342a8edfc1b9b40e6e4e1ed9f0f75ec.1789687750.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc25ff663342a8edfc1b9b40e6e4e1ed9f0f75ec.1789687750.git.wqu@suse.com>

On Fri, Sep 18, 2026 at 09:00:30AM +0930, Qu Wenruo wrote:
> When compression fails (either bad ratio, fragmented free space, or
> writeback path chooses to submit the bio early), we have to fall back to
> uncompressed writes.
> 
> The uncompressed fallback is mostly the same as cow_file_range() but
> with some changes:
> 
> - Endio function is slightly different from the compressed path
>   Only in the folio freeing handling.
> 
> - Uncompressed fallback error handling
>   Since at this stage, the folios already have WRITEBACK flag set, we do
>   not need to do the usual page unlock/end writeback, but just free the
>   reserved space and call it a day.

Continuing the reserved space issue from patch 4, here, both finishing
that bug and showing a second very similar one.

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/inode.c | 162 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 160 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index fbc0e5426d45..f47106c3f9ed 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7804,16 +7804,174 @@ static bool try_submit_compressed(struct btrfs_bio *parent)
>  	return false;
>  }
>  
> +static void end_bbio_delayed_uncompressed(struct btrfs_bio *bbio)
> +{
> +	struct delayed_bio_private *dbp = bbio->private;
> +	struct btrfs_bio *parent = dbp->delayed_bbio;
> +	struct folio_iter fi;
> +
> +	bio_for_each_folio_all(fi, &bbio->bio)
> +		folio_put(fi.folio);
> +	btrfs_bio_end_io(parent, bbio->bio.bi_status);
> +	bio_put(&bbio->bio);
> +}
> +
> +static struct btrfs_bio *child_bbio_from_page_cache(struct btrfs_bio *parent,
> +						    u64 fileoff, u32 len)
> +{
> +	struct btrfs_inode *inode = parent->inode;
> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
> +	struct address_space *mapping = inode->vfs_inode.i_mapping;
> +	struct btrfs_bio *bbio;
> +	struct folio_iter fi;
> +	u64 cur = fileoff;
> +	int ret;
> +
> +	bbio = btrfs_bio_alloc(len >> fs_info->sectorsize_bits, REQ_OP_WRITE,
> +			       inode, fileoff, end_bbio_delayed_uncompressed,
> +			       parent->private);
> +
> +	while (cur < fileoff + len) {
> +		struct folio *folio;
> +		u32 cur_len;
> +		bool queued;
> +
> +		folio = filemap_get_folio(mapping, cur >> PAGE_SHIFT);
> +		if (IS_ERR(folio)) {
> +			ret = PTR_ERR(folio);
> +			goto error;
> +		}
> +		cur_len = min_t(u64, folio_next_pos(folio), fileoff + len) - cur;
> +		queued = bio_add_folio(&bbio->bio, folio, cur_len,
> +				    offset_in_folio(folio, cur));
> +		/* There should be enough slots for the bio. */
> +		if (WARN_ON(!queued)) {
> +			ret = -EIO;
> +			folio_put(folio);
> +			goto error;
> +		}
> +		cur += cur_len;
> +	}
> +
> +	return bbio;
> +error:
> +	bio_for_each_folio_all(fi, &bbio->bio)
> +		folio_put(fi.folio);
> +	bio_put(&bbio->bio);
> +	return ERR_PTR(ret);
> +}
> +
> +static int submit_one_uncompressed_range(struct btrfs_bio *parent, struct btrfs_key *ins,
> +					 struct extent_state **cached, u64 file_offset,
> +					 u32 num_bytes, u64 alloc_hint, u32 *ret_alloc_size)
> +{
> +	struct btrfs_inode *inode = parent->inode;
> +	struct btrfs_root *root = inode->root;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_ordered_extent *ordered;
> +	struct btrfs_file_extent file_extent;
> +	struct btrfs_bio *child = NULL;
> +	struct extent_map *em;
> +	u64 cur_end;
> +	u32 cur_len = 0;
> +	int ret;
> +

Suppose the compressed try failed without reserving, like in the actual
compression checks, then this reservation is currently valid and
reasonable and not a double dip. (if compression succeeded and reserved
then failed, this is the problematic one)

> +	ret = btrfs_reserve_extent(root, num_bytes, num_bytes, fs_info->sectorsize,
> +				   0, alloc_hint, ins, true, true);
> +	if (ret < 0)
> +		return ret;
> +
> +	cur_len = ins->offset;
> +	cur_end = file_offset + cur_len - 1;
> +
> +	file_extent.disk_bytenr = ins->objectid;
> +	file_extent.disk_num_bytes = ins->offset;
> +	file_extent.num_bytes = ins->offset;
> +	file_extent.ram_bytes = ins->offset;
> +	file_extent.offset = 0;
> +	file_extent.compression = BTRFS_COMPRESS_NONE;
> +
> +	child = child_bbio_from_page_cache(parent, file_offset, cur_len);
> +	if (IS_ERR(child)) {
> +		ret = PTR_ERR(child);
> +		child = NULL;
> +		goto free_reserved;
> +	}
> +
> +	btrfs_lock_extent(&inode->io_tree, file_offset, cur_end, cached);
> +	em = btrfs_create_io_em(inode, file_offset, &file_extent, BTRFS_ORDERED_REGULAR);
> +	if (IS_ERR(em)) {
> +		ret = PTR_ERR(em);
> +		btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
> +		goto free_reserved;
> +	}
> +	btrfs_free_extent_map(em);
> +	ordered = btrfs_alloc_ordered_extent(inode, file_offset, &file_extent,
> +					     1U << BTRFS_ORDERED_REGULAR);
> +	if (IS_ERR(ordered)) {
> +		btrfs_drop_extent_map_range(inode, file_offset, cur_end, false);
> +		btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
> +		ret = PTR_ERR(ordered);
> +		goto free_reserved;

Now suppose this fails. We will have a missing OE range in the parent,
so when we finish the parent, we will free its reservation (patch 1)

> +	}
> +	btrfs_dec_block_group_reservations(fs_info, ins->objectid);
> +	btrfs_unlock_extent(&inode->io_tree, file_offset, cur_end, cached);
> +
> +	child->ordered = ordered;
> +	child->private = parent->private;
> +	child->end_io = end_bbio_delayed_uncompressed;
> +	child->bio.bi_iter.bi_sector = ins->objectid >> SECTOR_SHIFT;
> +	atomic_inc(&parent->pending_ios);
> +	btrfs_submit_bbio(child, 0);
> +	*ret_alloc_size = cur_len;
> +	return 0;
> +
> +free_reserved:
> +	if (child) {
> +		struct folio_iter fi;
> +
> +		bio_for_each_folio_all(fi, &child->bio)
> +			folio_put(fi.folio);
> +		bio_put(&child->bio);
> +	}
> +	btrfs_qgroup_free_data(inode, NULL, file_offset, cur_len, NULL);
> +	btrfs_dec_block_group_reservations(fs_info, ins->objectid);

But we have already freed it here, so it is a double free.

> +	btrfs_free_reserved_extent(fs_info, ins->objectid, ins->offset, true);
> +	ASSERT(ret != -EAGAIN);
> +	return ret;
> +}
> +
>  static void run_delayed_bbio(struct work_struct *work)
>  {
>  	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
>  	struct btrfs_bio *parent = dbp->delayed_bbio;
> +	struct btrfs_key ins;
> +	struct extent_state *cached = NULL;
> +	const u32 uncompressed_size = bio_get_size(&parent->bio);
> +	const u64 start = parent->file_offset;
> +	const u64 end = start + uncompressed_size - 1;
> +	u64 cur = start;
> +	u64 alloc_hint;
> +	int ret = 0;
>  
>  	if (try_submit_compressed(parent))
>  		goto finish;
>  
> -	/* Uncompressed fallback is not yet implemented. */
> -	ASSERT(0);
> +	alloc_hint = btrfs_get_extent_allocation_hint(parent->inode, start,
> +						      uncompressed_size);
> +	while (cur < end) {
> +		u32 cur_len;
> +

(re patch 4: this is the missing second reserving call)

> +		ret = submit_one_uncompressed_range(parent, &ins, &cached,
> +						    cur, end + 1 - cur,
> +						    alloc_hint, &cur_len);
> +		if (ret < 0) {
> +			cmpxchg(&parent->status, BLK_STS_OK, errno_to_blk_status(ret));
> +			goto finish;
> +		}
> +		cur += cur_len;
> +		alloc_hint = ins.objectid + ins.offset;
> +	}
>  
>  finish:
>  	/*
> -- 
> 2.55.0
> 
