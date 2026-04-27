Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3B1346782
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 15:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777304890; cv=none; b=BGA+mYuoAkefDC1srfv8p+iv6XWSMac0XCpToEUYq6ve1jf+auGptnikR+t2a2Qa3UNvPSKysq3rEUIslwFYxn0xfpP5VTy7SHdjHkky4EKox2ORNatVhqDzlhrlS4d7m9uYIY+/V55YLKy5gLsd30GLMVt8G5C7PeOsHqd2QqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777304890; c=relaxed/simple;
	bh=gbTHhX9usiWIz8mIR3MzZw1vWQVbgtPHlx2oQkxxmXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KHnJJ9BpHBMD5Y34dtUR8aL8rfmYWvUt5FK9mPgIBL/lrE54UeHM5JYjoQqrTvEV+q/yd/McIZ66icch9c4+BLhCFomHK73CwPOZlYijuMYjrKGkqxuemJEMS202t1stOdtHByE4tNOGfpc/GBnVaIFRMtyam1RbU18byaltQW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mzHJ+soD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=b5dSGa5k; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mzHJ+soD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=b5dSGa5k; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mzHJ+soD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="b5dSGa5k";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mzHJ+soD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="b5dSGa5k"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1E0795BCD0;
	Mon, 27 Apr 2026 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777304887;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9n76Wd9I1mvqMvjRbL+nbT7IFlD+cGUSny8G8Ij0fNI=;
	b=mzHJ+soDsF1JuUKGlWcBmeTfIbhZAe+QbIOdlImAWdNgETqgcXTMdRAGqAyqlB7ISHEgHz
	P9w+wStXVHchk6CW/9djN5ZeahP1fZUKRCVs4R6ToUwnqZ0YxAVUHMvrXlsLVBWdqH71R8
	GdZz7zUyCkoYm1NX0v6mazxCnHxmbhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777304887;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9n76Wd9I1mvqMvjRbL+nbT7IFlD+cGUSny8G8Ij0fNI=;
	b=b5dSGa5kWndvI9QyJrx+tRmpsrhQKA2Q6rocbhNfvcxFzZQVX6cS44MpNtpa35jOoYr383
	Gu2RFv8QIFPIjDAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mzHJ+soD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b5dSGa5k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777304887;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9n76Wd9I1mvqMvjRbL+nbT7IFlD+cGUSny8G8Ij0fNI=;
	b=mzHJ+soDsF1JuUKGlWcBmeTfIbhZAe+QbIOdlImAWdNgETqgcXTMdRAGqAyqlB7ISHEgHz
	P9w+wStXVHchk6CW/9djN5ZeahP1fZUKRCVs4R6ToUwnqZ0YxAVUHMvrXlsLVBWdqH71R8
	GdZz7zUyCkoYm1NX0v6mazxCnHxmbhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777304887;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9n76Wd9I1mvqMvjRbL+nbT7IFlD+cGUSny8G8Ij0fNI=;
	b=b5dSGa5kWndvI9QyJrx+tRmpsrhQKA2Q6rocbhNfvcxFzZQVX6cS44MpNtpa35jOoYr383
	Gu2RFv8QIFPIjDAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE5D1593B0;
	Mon, 27 Apr 2026 15:48:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wuXjNTaF72nmZgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 27 Apr 2026 15:48:06 +0000
Date: Mon, 27 Apr 2026 17:48:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>,
	Teng Liu <27rabbitlt@gmail.com>
Subject: Re: [PATCH v3] btrfs: warn about extent buffer that can not be
 released
Message-ID: <20260427154805.GQ12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4ac4a9f2c599841b00f39f3be082432f43130f3e.1776379191.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ac4a9f2c599841b00f39f3be082432f43130f3e.1776379191.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,suse.com:email,twin.jikos.cz:mid]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1E0795BCD0

On Fri, Apr 17, 2026 at 08:13:14AM +0930, Qu Wenruo wrote:
> When we unmount the fs or during mount failures, btrfs will call
> invalidate_inode_pages() to release all btree inode folios.
> 
> However that function can return -EBUSY if any folios can not be
> invalidated.
> This can be caused by:
> 
> - Some extent buffers are still held by btrfs
>   This is a logic error, as we should release all tree root nodes
>   during unmount and mount failure handling.
> 
> - Some extent buffers are under readahead and haven't yet finished
>   This is much rarer but valid cases.
>   In that case we should wait for those extent buffers.
> 
> Introduce a new helper invalidate_btree_folios() which will:
> 
> - Call invalidate_inode_pages2() and catch its return value
>   If it returned 0 as expected, that's great and we can call it a day.
> 
> - Otherwise go through each extent buffer in buffer_tree
>   Increase the ref by one first for the eb we're checking.
>   This is to ensure the eb won't be freed after the readahead is
>   finished.
> 
>   For eb that still has EXTENT_BUFFER_READING flag, wait for them to
>   finish first.
> 
>   After waiting for the readahead, check the refs of the eb and if it's
>   still dirty.
> 
>   If the eb refs is greater than 2 (one for the buffer tree, one hold by
>   us), it means we are still holding the extent buffer somewhere else,
>   which is a logic bug.
> 
>   If the eb is still dirty, it means a bug in transaction handling.
>   Unfortunately there are already test cases triggering this warning, so
>   our transaction cleanup hasn't done its work reliably.
> 
>   For either case, show a warning message about the eb, including its
>   bytenr, owner, refs and flags.
>   And if it's a debug build, also trigger WARN_ON_ONCE() so that fstests
>   can properly catch such situation.
> 
> Furthermore, to help debugging the unreleased extent buffers, output the
> transid of the current aborted transaction, so that we can know which
> transaction the unreleased extent buffers belong to.
> 
> This will help future debugging as we're already hitting the new
> warnings from test cases like generic/388.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221270
> Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
> Cc: Teng Liu <27rabbitlt@gmail.com>
> Tested-by: Teng Liu <27rabbitlt@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v3:
> - Revert the DEBUG_WANR_ON_ONCE() change
>   As there is only one user, a simple
>   WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG)) is more than enough.
> 
> - Output the generation of the unreleased eb too
>   Since it's possible to have 2 transactions (one committing and reached
>   UNBLOCKED state, one new running), the generation output will help us
>   to know which transaction the unreleased eb belongs to.
> 
> - Also output the transid when a transaction is aborted
>   To co-operate with the above change for debugging.
> 
> v2:
> - Add one extra ref before checking the eb
>   Although readahead has one extra ref, after the readahead finished the
>   extra ref will be dropped, and memory pressure can kick in to free the
>   extent buffer.
> 
> - Use rcu lock with xa_for_each() instead of xas lock and xas_for_each()
>   Since we're holding one extra eb ref to prevent eb from disappearing,
>   we no longer needs the more strict xas lock nor the extra xas
>   pause/unlock.
> 
>   Although xa_for_each() is more time consuming, we're at the cold path
>   already, not a huge cost.
> 
> - Remove the temporarary void pointer
>   And pass eb pointer directly into xas_for_each().
> 
> - Introduce DEBUG_WARN_ON_ONCE() helper
>   To follow the existing DEBUG_WARN() helper.
> 
> - Fix a typo
> 
> - Also fix the checkpatch warning on the exist DEBUG_WARN()
> ---
>  fs/btrfs/disk-io.c     | 49 ++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/extent_io.c   |  6 ------
>  fs/btrfs/extent_io.h   |  6 ++++++
>  fs/btrfs/transaction.h |  8 +++----
>  4 files changed, 57 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 7800a1b20290..241acdc16da1 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3272,6 +3272,51 @@ static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
>  	return false;
>  }
>  
> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)

This is too close to the generic invalidate_inode_pages2, please add
btrfs_ prefix.

> +{
> +	unsigned long index = 0;
> +	struct extent_buffer *eb;
> +	int ret;
> +
> +	ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +	if (likely(ret == 0))
> +		return;
> +
> +	/*
> +	 * Some btree pages can not be invalidated, this happens when some
> +	 * tree blocks are still held (either by some pointer or readahead).
> +	 */
> +	rcu_read_lock();
> +	xa_for_each(&fs_info->buffer_tree, index, eb) {
> +		/* Increase the ref so that the eb won't disappear. */
> +		if (!refcount_inc_not_zero(&eb->refs))
> +			continue;
> +		rcu_read_unlock();
> +
> +		/* Wait for any readahead first. */
> +		if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
> +			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
> +				       TASK_UNINTERRUPTIBLE);
> +		/*
> +		 * The refs threshold is 2, one hold by us at the beginning
> +		 * of the loop, one for the ownership in the buffer tree.
> +		 */
> +		if (unlikely(refcount_read(&eb->refs) > 2 ||
> +			     extent_buffer_under_io(eb))) {
> +			WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
> +			btrfs_warn(fs_info,
> +			"unable to release extent buffer %llu owner %llu gen %llu refs %u flags 0x%lx",
> +				   eb->start, btrfs_header_owner(eb),
> +				   btrfs_header_generation(eb),
> +				   refcount_read(&eb->refs), eb->bflags);
> +		}
> +		free_extent_buffer(eb);
> +		rcu_read_lock();
> +	}
> +	rcu_read_unlock();
> +	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +}
> +
>  int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
>  {
>  	u32 sectorsize;
> @@ -3702,7 +3747,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>  	if (fs_info->data_reloc_root)
>  		btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_root);
>  	free_root_pointers(fs_info, true);
> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +	invalidate_btree_folios(fs_info);
>  
>  fail_sb_buffer:
>  	btrfs_stop_all_workers(fs_info);
> @@ -4431,7 +4476,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>  	 * We must make sure there is not any read request to
>  	 * submit after we stop all workers.
>  	 */
> -	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +	invalidate_btree_folios(fs_info);
>  	btrfs_stop_all_workers(fs_info);
>  
>  	/*
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8d241a7a880f..4eab0f9909e3 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2872,12 +2872,6 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask)
>  	return try_release_extent_state(io_tree, folio);
>  }
>  
> -static int extent_buffer_under_io(const struct extent_buffer *eb)
> -{
> -	return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> -		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> -}
> -
>  static bool folio_range_has_eb(struct folio *folio)
>  {
>  	struct btrfs_folio_state *bfs;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index fd209233317f..b284aee1bfb0 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -326,6 +326,12 @@ static inline bool extent_buffer_uptodate(const struct extent_buffer *eb)
>  	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>  }
>  
> +static inline bool extent_buffer_under_io(const struct extent_buffer *eb)
> +{
> +	return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> +		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> +}
> +
>  int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
>  			 unsigned long start, unsigned long len);
>  void read_extent_buffer(const struct extent_buffer *eb, void *dst,
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7d70fe486758..264dcd4b3788 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -255,13 +255,13 @@ do {								\
>  		__first = true;					\
>  		if (WARN(btrfs_abort_should_print_stack(error),	\
>  			KERN_ERR				\
> -			"BTRFS: Transaction aborted (error %d)\n",	\
> -			(error))) {					\
> +			"BTRFS: Transaction %llu aborted (error %d)\n",	\
> +			(trans)->transid, (error))) {			\
>  			/* Stack trace printed. */			\
>  		} else {						\
>  			btrfs_err((trans)->fs_info,			\
> -				  "Transaction aborted (error %d)",	\
> -				  (error));			\
> +			"Transaction %llu aborted (error %d)",	\
> +				  (trans)->transid, (error));	\

Adding the transaction number adds like 4KiB of object code because the
calls are inlined so we can have exact location and stack.

It could be possibly moved to __btrfs_abort_transaction() but with some
additinal shuffling of the code from macro to the handler.
