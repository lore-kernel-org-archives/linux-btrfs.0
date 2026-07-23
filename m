Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00296388393
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825645; cv=none; b=S0VUSKm9dntjskPeq+P26GUoLwdRqsqjrE6LbxaXztqacAgrSOrreEhzOmxbTGfbsc+TOQccvpqnlLcxj+GnVKIP4YV7bdZkead/h0JovATsrNZ3csVeOVYmLql2tOxvMiTBkIaeQuI4gouAHUTgdPdRah2Ay6TZFDKVfnb/K/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825645; c=relaxed/simple;
	bh=q5swujroPoO4zU/PaPFmHJLD6fpwDxYzP/+IPRYqOiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qybhiTWO77PWeWzqb9jZT9cn5N178KRPYVWB311XAql8Yi+xV07K+Lw+kjbX9EMFkt56J0/OmwD/DfZ++M281d6X0MRh8KMfP4V3mUcCIbo3DdA1nL7iLxuYQY4SyrkPaZ4LVNUFtQyVUzDxQP5h4vH6pHm8HuPI+vc7q+KU4rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ps6y6JQx; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LQhPwxHA; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ps6y6JQx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LQhPwxHA"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 1DECBEC032E;
	Thu, 23 Jul 2026 12:54:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 23 Jul 2026 12:54:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784825642; x=1784912042; bh=b2o4tE/jXM
	lzCmuGWvOzc7Se2kB2SDmO29RNdFWHst4=; b=ps6y6JQxysmPZRmK7k0dkcwEU5
	vAgfWZakYUKbrInB2X6jI/GLAZGOMKkj4uJMADBcH0y6VpHBd5iESMX1haKzMBrL
	fHlZqdmmqiJN0pQrlxRXUhT5j6Ym5ZcVQVb0MiE/zyIzETXfsAUxR3+CFZ053t5n
	iK6lwFvU9drAflc/NBA7JMHWUYtEryWs2ACe8LfokKVbv1HtMGIE8rfQGH7L0T+w
	AxmfdrVNIXm27TrRTU0xAbPv4byVUFuFSrugaNC88WLIHIZbvpaaMlLuWOzFofkU
	3SXuP3W7IuyDdJC2EYht247YbHJMHgtQXDnq7LMtA7m9lEkxrw5uZGCzPWjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784825642; x=1784912042; bh=b2o4tE/jXMlzCmuGWvOzc7Se2kB2SDmO29R
	NdFWHst4=; b=LQhPwxHAywUYIHOL4iKpjECijJzvd6lqJs99aoVUX+gbx2kA4B6
	ww2rXuXfyBI25xYCCwdykC+CCHpyk2gVzKWPiXl1JdiTXaHBOvTqGE+x3rqQWD+1
	3k1ZamrxncSAS/x3q4ln7wWU+wfi7v8ufDkRGoRLxor/rZVWMkWK08vGXYZDxFL5
	FXOiJSLqRWnkCq/Vz8UNiU5X7l1tV64lC6UXXbhldX+SDWOIgOfKMu5UEOlDVPZF
	W270BN9HAl37RTZ8kXa/UAZUVX9n0JdE+TrzKN03FYXl7Z2NFHw0C0xDw0p/3Os9
	VNfW/B0AXIdMjOm+Em6v563bF6sCP3QP5qA==
X-ME-Sender: <xms:KUdiapQUVW_C0kAOqbePA84O0F7J_bGOUbD1bryBRasWSPFj2gCbvA>
    <xme:KUdiamf8lx-feirccMRpWK4WUtez005C7-eK0JEAwOVYMaemlYznLWiqoax6vsw4T
    bVQjHZL_exkclU9awta9n6NOvwKSGhx1ZJWEPRfStmK5JtNW4S-nJ8>
X-ME-Received: <xmr:KUdiaopcMkr5h6aVJWwFFK-F-JDnsW7Kx3ERjZdql8z8pbusVb7tlO1cc4vE-1p6Yy7goq_vkZYl6106EL5puDkuS04>
X-ME-Proxy-Cause: dmFkZTGdaVIsy0MYksNn9Rpewd7yyliVgcelsvG9Bm7lT6lhIiJqARxdSflxNs+c40xDsL
    4j4Tox2Go8P6zpxPvpLmUIY0pmfX/Mhx3T1hj3Hfon9pROwxvjmwGIU3vmehMepR/LJdC4
    Am4ki2aEYyZksym/f1yI4hWqyAdRppfcteCVoQLtoYa3tuLeLqnUMZEhQTgduzRViumAu1
    OXC4OMNWdohZF235zKbWHXH/ZgudxpVnrnnNorYKkF/ExHtbYjfF0WkKFfvmOLoIl79kxM
    hXTsdtpCxsJZ+t4kuyYecgehI4Mr4utePl3YLQb5P8nL9xTsldu8ybxdAcbOaKB2C9ddVz
    5Gr/SPiMPgDrrmYyCGDgpYOZYXtc8ttg+VMVOWv5oNHPYTVORByapTdrxtiRkCXLfuceml
    LNkQ2O4F3mtE15gxdqyJXyW3dxAWEqnuHon7U5AvHTrOG7IkGrmIdufc3qRC9ktxo7/OPL
    kbJPvDLuMMR1CCL9DhJkRDuP39zwn2+fmtsgvxyXF0UUZWAUKKha6l8vAEmyFT3rJH5EdV
    3WADG3oBDpiy0KFzIRMHaJ9uXjtZjBHJIDOIRJj9e9Lls7Bke/WYukBzZqOhVnZ5+6BpkS
    PCfuag7f6iDrjO27xMc9/mw6WB/ubxzmfK3BHkD1lHtEAht26HtG1GZSP+fQ
X-ME-Proxy: <xmx:KUdian_SurV26gorsDMgEh_pLUgWRZSLVd_Ecqy4SHdJgRBOmi3GJA>
    <xmx:KUdiakeJM88vPR4CvrlF5bl4tkwatXsCSZ20TM5724yVM5OrNuLGlQ>
    <xmx:KUdiahJc6zTgsgLuskxM0GPgiguRPdRXKdZuwoL1zIU3f6jHz4mKmg>
    <xmx:KUdiakjWjoeDQ7qQSM9sCMfm4evSNjsix7I8-yZ8m4oJ3Ku-VH02aQ>
    <xmx:KkdiaiwU7bXoDPfOvDHnLJeVe4BSvVmU9gctIio7Y0GzA3TSi2XRItYy>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 12:54:01 -0400 (EDT)
Date: Thu, 23 Jul 2026 09:53:50 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2 1/4] btrfs: zoned: flush active metadata block group
 at btree_writepages() start
Message-ID: <20260723165350.GA752950@zen.localdomain>
References: <20260723155428.94187-1-johannes.thumshirn@wdc.com>
 <20260723155428.94187-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723155428.94187-2-johannes.thumshirn@wdc.com>

On Thu, Jul 23, 2026 at 05:54:25PM +0200, Johannes Thumshirn wrote:
> btree_writepages() writes the btree inode's dirty metadata in ascending
> logical address order. On a zoned filesystem only one metadata and one
> system block group is active for writing at a time, and
> check_bg_is_active() (via btrfs_check_meta_write_pointer()) pivots the
> active block group as writeback moves from one block group to the next.
> 
> If the active block group sits at a higher logical address than another
> block group that also holds dirty metadata, the ascending walk reaches
> the lower one first and, to write it, has to finish the active block
> group and activate the lower one. It cannot finish a block group that
> still has unsent IO, and during WB_SYNC_ALL && !for_sync (commit)
> writeback it deliberately refuses to wait for that IO under
> fs_info->zoned_meta_io_lock, as that can deadlock. The pivot thus cannot
> issue the submission itself either, so it gives up:
> btrfs_check_meta_write_pointer() returns -EAGAIN, which
> btrfs_write_and_wait_transaction() treats as fatal and aborts the
> transaction, forcing the filesystem read-only. This happens
> intermittently under metadata-heavy relocation (e.g. fstests btrfs/187).
> 
> Flush the active metadata and system block groups at the start of
> btree_writepages(), under the fs_info->zoned_meta_io_lock it already
> holds, so they have no unsent IO left and the later pivot can finish
> them and make forward progress.
> 
> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
> Assisted-by: LLM (debugging, commit message)
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

This version looks great, thanks.

Reviewed-by: Boris Burkov <boris@bur.io>
> ---
>  fs/btrfs/extent_io.c | 113 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 92 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d119dcf9e34b..e3125ef701ce 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2383,6 +2383,76 @@ void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start,
>  	}
>  }
>  
> +static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
> +				    struct writeback_control *wbc)
> +{
> +	struct extent_buffer *eb = ctx->eb;
> +	int ret;
> +
> +	ret = btrfs_check_meta_write_pointer(eb->fs_info, ctx);
> +	if (ret)
> +		return ret;
> +
> +	if (!lock_extent_buffer_for_io(eb, wbc))
> +		return 0;
> +
> +	/* Implies write in zoned mode. */
> +	if (ctx->zoned_bg) {
> +		/* Mark the last eb in the block group. */
> +		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
> +		ctx->zoned_bg->meta_write_pointer += eb->len;
> +	}
> +	write_one_eb(eb, wbc);
> +	return 0;
> +}
> +
> +/*
> + * On a zoned filesystem, write out the currently dirty metadata extent buffers
> + * of @bg. Used to flush the active metadata/system block group before the
> + * ascending-address walk in btree_writepages(), so that walk can pivot the
> + * active block group away (finishing it) instead of aborting the commit; see
> + * the caller for details.
> + */
> +static void flush_active_meta_bg(struct address_space *mapping,
> +				 struct writeback_control *wbc,
> +				 struct btrfs_eb_write_context *ctx,
> +				 struct btrfs_block_group *bg)
> +{
> +	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
> +	unsigned long index = bg->start >> fs_info->nodesize_bits;
> +	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
> +	struct eb_batch batch;
> +	unsigned int nr_ebs;
> +
> +	ASSERT(btrfs_is_zoned(fs_info));
> +	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
> +
> +	eb_batch_init(&batch);
> +	while (index <= end &&
> +	       (nr_ebs = buffer_tree_get_ebs_tag(fs_info, &index, end,
> +						 PAGECACHE_TAG_DIRTY, &batch))) {
> +		struct extent_buffer *eb;
> +
> +		while ((eb = eb_batch_next(&batch)) != NULL) {
> +			ctx->eb = eb;
> +
> +			/*
> +			 * If the eb is behind the write pointer (-EBUSY, e.g.
> +			 * already being written by someone else) skip it and
> +			 * carry on. Only a hole at the write pointer (-EAGAIN)
> +			 * stops the flush. The main walk in btree_writepages()
> +			 * then deals with it.
> +			 */
> +			if (write_meta_extent_buffer(ctx, wbc) == -EAGAIN) {
> +				eb_batch_release(&batch);
> +				return;
> +			}
> +		}
> +		eb_batch_release(&batch);
> +		cond_resched();
> +	}
> +}
> +
>  int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
>  	struct btrfs_eb_write_context ctx = { .wbc = wbc };
> @@ -2418,6 +2488,22 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
>  	else
>  		tag = PAGECACHE_TAG_DIRTY;
>  	btrfs_zoned_meta_io_lock(fs_info);
> +
> +	/*
> +	 * On a zoned filesystem, flush the currently active metadata/system
> +	 * block group(s) first, under this same lock, so the ascending-address
> +	 * walk below can pivot the active block group instead of aborting the
> +	 * transaction commit with -EAGAIN.
> +	 */
> +	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
> +	    !wbc->for_sync) {
> +		if (fs_info->active_meta_bg)
> +			flush_active_meta_bg(mapping, wbc, &ctx,
> +					     fs_info->active_meta_bg);
> +		if (fs_info->active_system_bg)
> +			flush_active_meta_bg(mapping, wbc, &ctx,
> +					     fs_info->active_system_bg);
> +	}
>  retry:
>  	if (wbc->sync_mode == WB_SYNC_ALL)
>  		buffer_tree_tag_for_writeback(fs_info, index, end);
> @@ -2428,28 +2514,13 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
>  		while ((eb = eb_batch_next(&batch)) != NULL) {
>  			ctx.eb = eb;
>  
> -			ret = btrfs_check_meta_write_pointer(eb->fs_info, &ctx);
> -			if (ret) {
> -				if (ret == -EBUSY)
> -					ret = 0;
> -
> -				if (ret) {
> -					done = true;
> -					break;
> -				}
> -				continue;
> -			}
> -
> -			if (!lock_extent_buffer_for_io(eb, wbc))
> -				continue;
> -
> -			/* Implies write in zoned mode. */
> -			if (ctx.zoned_bg) {
> -				/* Mark the last eb in the block group. */
> -				btrfs_schedule_zone_finish_bg(ctx.zoned_bg, eb);
> -				ctx.zoned_bg->meta_write_pointer += eb->len;
> +			ret = write_meta_extent_buffer(&ctx, wbc);
> +			if (ret == -EBUSY) {
> +				ret = 0;
> +			} else if (ret) {
> +				done = true;
> +				break;
>  			}
> -			write_one_eb(eb, wbc);
>  		}
>  		nr_to_write_done = (wbc->nr_to_write <= 0);
>  		eb_batch_release(&batch);
> -- 
> 2.55.0
> 
