Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E0D43CE5B
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 17:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740128; cv=none; b=I1b5vl/UN6R8YXzTjgPNvanSBHmpxPSJ2Ed79vyqRFFF6QSX/zdu3S7v8+rDNFpltq01aNSBYsxZXdqS46Kb/TepESZpQDApXAuiBpuypPlqM7JpkzeOKG1VHXOaQe2Tmaehfm3x84YMS+OGYPt9bzjaLvV3TOs4Su3aQKp9S3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740128; c=relaxed/simple;
	bh=bsyDdArxZh1Jw2bCX2pLJ3eyPQYYITPykgA1o/GNnzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpdYOt8XGl+15Rllgw5EOGGbapcSL54/Y7THbb9w4FG6ZrQCwzndngQtqlS9f8R9f4z7pSQEXtRAn4rl57O8oqp6XNkoD2p8/kW70sB0Kku/QqIokBJmIR80m6CppDCGdoQz5pPXH2dtHzEoniphuj46zePUSigfozGb2/bVRhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=lXG3DSQX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KmYDsFiv; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="lXG3DSQX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KmYDsFiv"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 66AA3EC021B;
	Wed, 22 Jul 2026 13:08:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 22 Jul 2026 13:08:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1784740125; x=1784826525; bh=LNL4mfdy0J
	kQ7XWeeIlC6Ne5EzLj9ywe0dDXWwmTtiU=; b=lXG3DSQXLvmtO48BkkjGD69mxi
	zfVzDXwG0eEj2QCp6D0i01QJbk1382z1nD4mzevYoNieFsNN8dBImouvoZ1zP3NP
	eb/02R0h7+fRJgfZCGy9ste9WolxA0QGdCLiHXQYe6OguAm+W8wXKszvUitp73CV
	JUSt7xbPmdzsifV/8SDzyk/lhMsyZQ9b3WRGovnV9p++3BELfqk32MRFyuaZ4McG
	hYyV4irg5uNEEH0HjR13Lg/7VTtBrPrg/eBRcW/+I0Rr/p6CESf3byMW4kydam11
	Uo7UH3Ha6j1mMHNAmtNLj0zqntqRb2QfAo0wlFCGAHbFS9ZzDyRt7Lrj0OCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784740125; x=1784826525; bh=LNL4mfdy0JkQ7XWeeIlC6Ne5EzLj9ywe0dD
	XWwmTtiU=; b=KmYDsFivhLBwpiYjalg1LgTIU/DER7sfMCzzeVM4LmZUXOFsJmb
	3ylb8YYFX7W1B0n/6fUoOgsOUOcJrH1DM5wjW9V7tc9aGxe62eynvClSiqtN6OIh
	MFj1PioNL4+CsxV+tJ882oKWuean0dZNtLYkkETQoi4jOkY8zFw4bVIWbiZvLXbL
	9A/NRxbnPx8oUFzTpjPtpljUPnVR0QfEd8sQR83pL874AtM9UZF5thxzb6+5h5Ke
	qTfoiGCQ/1Gr4V9oqEjmzUYnhn0ln0uSWcU0XngvDvPdY8zQvpG7ZUeW501ANStc
	uNRTFEKioNJm0Va4FGJi5sYLPMyP32G+cOg==
X-ME-Sender: <xms:Hflgaq0hQCuBzX49Nrc8vxq4VcoAXhnw34ndWs4zAYe5RFGazEvrsw>
    <xme:Hflgaj-rODWU025BpcmQ4ixKaW33Kb_m9gmMaJS9GDK-wjBtLEpVVvG_NVGnSqO6Z
    F_FkMqNgDVF2a3X8LFEA-QwPTjjm6Wl6uxj3nO0RuW6g7aS6-MxclSb>
X-ME-Received: <xmr:HflgarMWIra-pPLR9LR6nWR_6rPwyLC1F1bBhpY3X9bLJH3rqJOxIdYCFGJPqXjZsL_FALq5hrWswJCkgjcY6Sx-4_E>
X-ME-Proxy-Cause: dmFkZTF34rlrCJ91SvsS2LxZQheJtmlSS8tPH0QiJtZjIAD58gc+V9eZcvISkhnY557Nr2
    4iJKuQzTcZD0J9dfIKKokpl5hYdogZh8c77mAPFpumlBuBXLMc7aBs1yyOB8MPsMsNKg8n
    fAWc5eD75WX9b7njjuiDpMI9twlsu5UbVb4b7f29xGXyZg0Jb4gMKKZutCKm++8OxbU+22
    4BufkiavXU57c9fMmY1OgI1I3sckK/F71qdnCX7j9do2oHfC/SzZTNyC6dWHQ526xWGud2
    mAjEODRGSyCu2E9RuW4J9yppYGTOF8IUistnMmassP5HI5F4mNOAVJPIjNG/CxJbrTDJHO
    ywrbmIP7ImBl9gFeTgZETPRTrk6K/QsLH3V+QvG2FGPWkZMKfTrkrVSeIvTu58p6n/S51L
    0RIukrfit/mceF5KEVZnD/GuauS1Vdrtgt5mLBnS168aanAghLeYjnhD61gdLiMkMHqhCU
    S/g6rT8s/86CDcwiV4mNxmc0FogCxtPmSqxQxW8nLsp8SzuO5A0XGnq0MTVcnKq9UNkCue
    PGd6LXrhmYQpOuYSOHo5j4TS0kgA2Wg28OqbHzxf6CxjOvhLrgAst2fVxyiAojv0su81uu
    cEHtodSoMvNMlpz4cxLgJSeZFhDCz7CnHuFFq9jtRKMW5RlwEF+tZ8QCBsdw
X-ME-Proxy: <xmx:HflganemjdkhALUxS4CIL9N4s8EFomIawqLuoqPLviBW6d2M5qmI1w>
    <xmx:HflgaqWHqMHrMC0XEWYyxD8pcTAq0I2OWq6ZDXynmbiY0ZqN_-E5FA>
    <xmx:HflgavhYuAQButVhJwZB9IdviguXG1jOCENnMWtZH5V1lIev48bs9Q>
    <xmx:Hflgap_5RQ1xGWONsMj13ycwcfvrEYLih9AjMrDxIWFU3ZKwKKdLEA>
    <xmx:HflgaqBb6pZwonylZeixtYojWoo1z2A1b94FKcdcEEnjwMwsAWBS-gWv>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jul 2026 13:08:44 -0400 (EDT)
Date: Wed, 22 Jul 2026 10:08:35 -0700
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
	Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/4] btrfs: zoned: flush active metadata block group at
 btree_writepages() start
Message-ID: <20260722170835.GB26033@zen.localdomain>
References: <20260722113016.1896990-1-johannes.thumshirn@wdc.com>
 <20260722113016.1896990-2-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722113016.1896990-2-johannes.thumshirn@wdc.com>

On Wed, Jul 22, 2026 at 01:30:13PM +0200, Johannes Thumshirn wrote:
> On a zoned filesystem btree_writepages() writes metadata in ascending

wording nit: isn't this true on non-zoned too? Maybe something like:
btree_writepages() writes metadata in ascending logical order. On a
zoned filsystem, which keeps a single .... <something terrible happens>

> logical address order and keeps a single active metadata/system block group,
> pivoting it via btrfs_check_meta_write_pointer() -> check_bg_is_active() as
> writeback moves between block groups.
> 
> If the active block group is at a higher address than another block group
> that also has dirty metadata, the walk reaches the lower one first and the
> pivot must finish the active block group. It cannot finish one that still has
> unsent IO, and refuses to wait for it during WB_SYNC_ALL commit writeback, so

Can you add some more detail on why it refuses? Or why the pivot can't
be the one to do these submissions? I think that would help fully
motivate this change.

> btrfs_check_meta_write_pointer() returns -EAGAIN and the transaction is
> aborted, forcing the filesystem read-only. This happens intermittently under
> metadata-heavy relocation (e.g. fstests btrfs/187).
> 
> Flush the active metadata and system block groups at the start of
> btree_writepages(), under the fs_info->zoned_meta_io_lock it already holds, so
> they have no unsent IO and the later pivot can finish them.
> 
> Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
> Assisted-by: LLM (debugging, commit message)
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/extent_io.c | 62 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 97bd18d515af..bac3edabe7c9 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2383,6 +2383,52 @@ void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start,
>  	}
>  }
>  
> +/* Write out the dirty metadata extent buffers of a single block group. */

This comment is quite generic, and not zoned specific, but the function
name is much more zoned focused (and we assert zoned)

I am also not a huge fan of this code mostly duplicating the loop in
btree_writepages while just leaving that spot open coded. Is that an
intentional decision because of important distinctions between the two?
Is there a variant we could lift to "write a range" and make
flush_active_meta_bg() and btree_writepages share it? (like the while
loop basically? or maybe the per-eb bit?)

note the missing call to btrfs_schedule_zone_finish_bg() I noted inline
as a concrete reason it's helpful to not duplicate.

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
> +			 * Best effort: if the eb is not writable at the write
> +			 * pointer (e.g. a hole), stop flushing this bg and let
> +			 * the main walk deal with it.
> +			 */
> +			if (btrfs_check_meta_write_pointer(eb->fs_info, ctx)) {
> +				eb_batch_release(&batch);
> +				return;
> +			}
> +
> +			if (!lock_extent_buffer_for_io(eb, wbc))
> +				continue;
> +
> +			if (ctx->zoned_bg)

the btree_writepages code also calls btrfs_schedule_zone_finish_bg()
here, is that intentionally omitted?

> +				ctx->zoned_bg->meta_write_pointer += eb->len;
> +			write_one_eb(eb, wbc);
> +		}
> +		eb_batch_release(&batch);
> +		cond_resched();
> +	}
> +}
> +
>  int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
>  {
>  	struct btrfs_eb_write_context ctx = { .wbc = wbc };
> @@ -2418,6 +2464,22 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
>  	else
>  		tag = PAGECACHE_TAG_DIRTY;
>  	btrfs_zoned_meta_io_lock(fs_info);
> +
> +	/*
> +	 * On a zoned filesystem, flush the currently active metadata/system
> +	 * block group(s) first, under this same lock, so the ascending-address
> +	 * walk below can pivot the active block group instead of aborting the
> +	 * commit with -EAGAIN.
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

I think this placement makes sense, but I also wouldn't mind just having
a more generic "eb ordering" concept that zoned could use to plug the
active ebs to the front of the list then fallback to the normal order,
or something. Not a deal breaker for me, just food for thought.

I think fewer "tricks" for zoned writeback and more "it falls out
correctly from a generic form" would make it easier to maintain in the
long run. Obviously there are real, important differences so this kind
of thing is never free...

Thanks,
Boris

>  retry:
>  	if (wbc->sync_mode == WB_SYNC_ALL)
>  		buffer_tree_tag_for_writeback(fs_info, index, end);
> -- 
> 2.54.0
> 
