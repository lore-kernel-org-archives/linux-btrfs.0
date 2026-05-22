Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA41299959
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 21:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779484199; cv=none; b=GhqqxQvM0MUm7VvuCWzOQSY1qqUGZ4eOlwCd/sUoFjUts0Ax1AfkoshO9vQf59rPGdrZCxFsB08CRTYi4Fl0NMVefTaSKonM7pD2KCoeuPn8LobCUi5+uWTReczn4iwmMqSD4o9QqMnNEax+mRHRtJgkt3Zha25ljPM1ei8/wlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779484199; c=relaxed/simple;
	bh=RSKkgpw88iBkAfoaL2hS3SPTbJGLY7fCHePBrN3ZCd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XneoMUMdKevmFUPiNoBmHKp/DIhlJMnOxuG5bGswVDBZmy+t+3J8t3D1uK5nw3JeXJjkrTYydBSLdU+dkEN1nli7XkyNUxXNVBOi+R6UxWu7lW1ngv9vjKfx3MIkujp7QAbki9bW4PwNqlzOXBV1iYc9ND6ueg7Ym+44WV4k96E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=hEw9SUd4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LNPb1KR2; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="hEw9SUd4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LNPb1KR2"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id E0F051D000C4;
	Fri, 22 May 2026 17:09:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 17:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779484196; x=1779570596; bh=+6BfagQfdN
	EConricpjPXhPwscH8cKamfWJ0+gtBAvY=; b=hEw9SUd42PdP7leKPRhxY7QwDN
	povD8SKaIN5J3T2Ncv5j6sEpjbSD0NedQuqxLYnCI34CFo8QQWL3kxxX79AkCzuV
	+dHj4/fLchprX0Pil/1QF/UxjMOAFuTi0fbHx69zWXIMHEZIWK4pO83TmOZ+1UjZ
	w2+AiEqnFCADw5VBavoImoe/88r6MYzkjIwhKGbdlxPStHHCpHed/wKLRNzA1zs/
	3IqMqprhzxyhXGiVPb4tLg++1/kkboTBuvIWNjHDb59RqEwVjBTRurz1zxJbQK+2
	Rb12jNggnnBf9J6cDYcsMVRs5ULgRbnTHfKbZ++CYC3Vnpu9pH5vP1ezGKSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779484196; x=1779570596; bh=+6BfagQfdNEConricpjPXhPwscH8cKamfWJ
	0+gtBAvY=; b=LNPb1KR2ta9jaO7aG8FGZKdKnVrQfuVc2sfotoPyxertSP5ovTq
	/qQthrvt+1h2PDT4rlgCC1oL0SPKMr/WbFmM38n/YoaXZ24ct27BV/Wl5FGXisX1
	9tKM+uwmZIt+2DY/kgdoCjY7wpfblvEHnSSJTXwr4H4mZDYONBWZ/uWxkCJrcWAL
	R1sDRWelXJjWinwgVuEzONKQ2OtdOGDSBPQF2qSj45vxz4To2P4oJybcv5sPQSZ1
	hmxYuRodWbhuz2CqulftrkQjPuIpOM29AQl1eg3iCR1TFgvko5oT06PU36TnhzYk
	isU97ReYdhkytNJoY58aIfUkVIVkcXNyitg==
X-ME-Sender: <xms:JMYQapKRgaXJEdh7ezd02bXWI8L9nyuiSUdv8JxjRdRsb6HR5daM1Q>
    <xme:JMYQarLGH4jY3GqPwDWddRqCn2x7Go5tgcC4KTmi2yQTzDIxPeeVFrFDp5OyzrvaN
    BdrZSfv2WwxQlVR-lhe15UERlU8txd0EgWo8veNXRVtg3bQXHxJ6oCv>
X-ME-Received: <xmr:JMYQavV7bD58wTyjbEMBkVVUMcTf_zOPvxWxbVJy9eG3jARBLNd4Nj9WHn1ooAteL1WHb4py7IP4IZkFVx2KmXR0180>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduheduvdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeekvd
    ekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfihquhesshhushgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvh
    hgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:JMYQalguRe9M41czihIT086IaDT_2DN6fvGBlQge1Xc9OiYdloqQnw>
    <xmx:JMYQai9J_vp41iMGXKau-3E9dXD6pwNnBTrPm-NoE90ytBBFP6ZqFA>
    <xmx:JMYQanBO8SofyGgOUcUrgxGvW3Nih0OX7chKRcobjr6SR0C4xtTPwg>
    <xmx:JMYQanK4C2AgAdufB-lYMKz1QVTdLVwEoFysvAcLG98PZzzsGXelXA>
    <xmx:JMYQakXfdO54a9LCA2ly2PmZ8x11msvgKIrBMSp15cBIdA_dC6JhtJPC>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 17:09:56 -0400 (EDT)
Date: Fri, 22 May 2026 14:09:51 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 6/6] btrfs: enable experimental delayed compression
 support
Message-ID: <20260522210951.GA3071612@zen.localdomain>
References: <cover.1778902677.git.wqu@suse.com>
 <1e72627dfa498d4437323abd820868c8e3b3dbf5.1778902678.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e72627dfa498d4437323abd820868c8e3b3dbf5.1778902678.git.wqu@suse.com>

On Sat, May 16, 2026 at 01:15:19PM +0930, Qu Wenruo wrote:
> Instead of the existing async submission path, the new delayed bbio will
> handle compressed writes by:
> 
> - Allocating delayed em/oe at run_delalloc_*() time
>   Thus no data extent is reserved at that time.
> 
> - Delayed bbio will be assembled at extent_writepage_io() time
> 
> - Delayed bbio will be intercepted just before submission
>   Which will run compression (or fallback to uncompressed writes) in
>   workqueue.
>   Data extents will only be reserved at that time, and the delayed em
>   will be replaced by real ones.
> 
>   Meanwhile the real OE will be added as a child of the parent delayed
>   OE, and when the parent OE finishes, the child OE will be finished
>   with their file extents inserted.
> 
> This has some benefits:
> 
> - Higher concurrency
>   Previously async submission will hold the folio and io tree range
>   locked, this means we can not even read the uptodate folio.
> 
>   Furthermore although the compressed write is queued into a workqueue
>   for submission and extent_writepage_io() will skip the compressed
>   range, when we need to write the next folio of the compressed range,
>   we will need to wait for the folio to be unlocked.
> 
>   This makes async submission less async.
> 
> - Future DONTCACHE writes support
>   We do not support DONTCACHE because that feature requires writeback path
>   to clear the folio dirty and submit them sequentially.
> 
>   Meanwhile async submission makes the writeback async, breaking the
>   sequential submission requirement.
> 
>   This is also why we need complex per-block tracking for writeback
>   flags, while iomap only requires a counter tracking.
> 
>   With the new delayed compression, the lifespan of a folio aligns with
>   DONTCACHE and iomap.
> 
> There is an extra handling for defrag, where we have to write and wait
> for the defrag range.
> This is to avoid clearing inode->defrag_compress before the delayed
> compression started.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/defrag.c    | 26 ++++++++++++++++---
>  fs/btrfs/extent_io.c |  5 +++-
>  fs/btrfs/inode.c     | 61 +++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 84 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index f0c6758b7055..092693cbb79e 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -1342,6 +1342,7 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
>  	struct btrfs_fs_info *fs_info = inode->root->fs_info;
>  	unsigned long sectors_defragged = 0;
>  	u64 isize = i_size_read(&inode->vfs_inode);
> +	const u64 start = round_down(range->start, fs_info->sectorsize);
>  	u64 cur;
>  	u64 last_byte;
>  	bool do_compress = (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS);
> @@ -1393,7 +1394,7 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
>  	}
>  
>  	/* Align the range */
> -	cur = round_down(range->start, fs_info->sectorsize);
> +	cur = start;
>  	last_byte = round_up(last_byte, fs_info->sectorsize) - 1;
>  
>  	/*
> @@ -1464,10 +1465,27 @@ int btrfs_defrag_file(struct btrfs_inode *inode, struct file_ra_state *ra,
>  		 * need to be written back immediately.
>  		 */
>  		if (range->flags & BTRFS_DEFRAG_RANGE_START_IO) {
> -			filemap_flush(inode->vfs_inode.i_mapping);
> -			if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
> -				     &inode->runtime_flags))
> +			/*
> +			 * For experimental delayed writeback, we must wait
> +			 * for the range to be fully written back before
> +			 * clearing inode->defrag_compress.
> +			 *
> +			 * Regular filemap_flush() will only start writeback,
> +			 * which will only create delayed OEs. But the real
> +			 * compression is happening later.
> +			 * This means if we just flush but not wait for writeback,
> +			 * the inode->defrag_compress clearing can race with
> +			 * compression, causing the defrag algorithm not reflected.
> +			 */
> +			if (IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL)) {
> +				filemap_write_and_wait_range(inode->vfs_inode.i_mapping,
> +							     start, last_byte);
> +			} else {
>  				filemap_flush(inode->vfs_inode.i_mapping);
> +				if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
> +					     &inode->runtime_flags))
> +					filemap_flush(inode->vfs_inode.i_mapping);
> +			}
>  		}
>  		if (range->compress_type == BTRFS_COMPRESS_LZO)
>  			btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 7adf8e80ba36..6ec7682df565 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -899,8 +899,11 @@ static unsigned int submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
>  		 * If we have accumulated decent amount of IO, send it to the
>  		 * block layer so that IO can run while we are accumulating
>  		 * more folios to write.
> +		 *
> +		 * This doesn't apply to delayed bbio which is going to be
> +		 * compressed.
>  		 */
> -		else if (bio_ctrl->wbc &&
> +		else if (bio_ctrl->wbc && !bio_ctrl->bbio->is_delayed &&
>  			 bio_ctrl->bbio->bio.bi_iter.bi_size >=
>  			    inode->root->fs_info->writeback_bio_size)
>  			submit_one_bio(bio_ctrl);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 75376c2ef665..4acf710f7e0a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1654,6 +1654,58 @@ static bool run_delalloc_compressed(struct btrfs_inode *inode,
>  	return true;
>  }
>  
> +static int run_delalloc_delayed(struct btrfs_inode *inode, struct folio *locked_folio,
> +				u64 start, u64 end)
> +{
> +	struct btrfs_root *root = inode->root;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct extent_state *cached = NULL;
> +	u64 cur = start;
> +	int ret;
> +
> +	if (btrfs_is_shutdown(fs_info)) {
> +		ret = -EIO;
> +		goto error;
> +	}
> +	while (cur < end) {
> +		struct extent_map *em;
> +		struct btrfs_ordered_extent *oe;
> +		u32 cur_len = min_t(u64, end + 1 - cur, BTRFS_MAX_COMPRESSED);
> +
> +		btrfs_lock_extent(&inode->io_tree, cur, cur + cur_len - 1, &cached);
> +		em = btrfs_create_delayed_em(inode, cur, cur_len);
> +		if (IS_ERR(em)) {
> +			ret = PTR_ERR(em);
> +			goto error;
> +		}
> +		btrfs_free_extent_map(em);
> +		oe = btrfs_alloc_delayed_ordered_extent(inode, cur, cur_len);
> +		if (IS_ERR(oe)) {
> +			btrfs_drop_extent_map_range(inode, cur, cur + cur_len - 1, false);
> +			ret = PTR_ERR(oe);

I believe Chris's code review prompts found a subtle bug in this patch,
that I attempted to trace out so I will restate in my own words.

Suppose we successfully created one delayed OE, then the second one
fails and does goto error.

> +			goto error;
> +		}
> +		btrfs_put_ordered_extent(oe);
> +
> +		cur += cur_len;
> +	}
> +	extent_clear_unlock_delalloc(inode, start, end, locked_folio, &cached,
> +				     EXTENT_LOCKED | EXTENT_DELALLOC,
> +				     PAGE_UNLOCK);
> +	return 0;
> +error:
> +	if (start < cur) {
> +		btrfs_drop_extent_map_range(inode, start, cur - 1, false);
> +		btrfs_cleanup_ordered_extents(inode, start, cur - start);

We will run this code and it will finish the delayed OE we did create,
with an error set. That will queue up running finish_delayed_ordered(),
which will see 0 child OEs and free rsv with
btrfs_delalloc_release_space().

> +	}
> +	/* No range has any extent reserved, just clear them all. */
> +	extent_clear_unlock_delalloc(inode, start, end, locked_folio, &cached,
> +			EXTENT_LOCKED | EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
> +			EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
> +			PAGE_UNLOCK | PAGE_START_WRITEBACK | PAGE_END_WRITEBACK);

But then this will also free the rsv because of EXTENT_DO_ACCOUNTING

So I think it really is a double free on the "partial delayed OE
creation error" path.

Thanks,
Boris

> +	return ret;
> +}
> +
>  /*
>   * Run the delalloc range from start to end, and write back any dirty pages
>   * covered by the range.
> @@ -2427,9 +2479,12 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_fol
>  		return run_delalloc_nocow(inode, locked_folio, start, end);
>  
>  	if (btrfs_inode_can_compress(inode) &&
> -	    inode_need_compress(inode, start, end, false) &&
> -	    run_delalloc_compressed(inode, locked_folio, start, end, wbc))
> -		return 1;
> +	    inode_need_compress(inode, start, end, false)) {
> +		if (IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL))
> +			return run_delalloc_delayed(inode, locked_folio, start, end);
> +		else if (run_delalloc_compressed(inode, locked_folio, start, end, wbc))
> +			return 1;
> +	}
>  
>  	if (zoned)
>  		return run_delalloc_cow(inode, locked_folio, start, end, wbc, true);
> -- 
> 2.54.0
> 
