Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC6825B0AF
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 12:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784636836; cv=none; b=nl5zVpjcFcPm5vuwyPhLqXg3I5nke79sAwAO/ajErEn6O3Uf7Qo11m5Q5zF6YKLBvLek27ea9H5847KDkaPyg8YtEQZHR3ZWXqfusyGF2t9v4wIoxXSBVmfc/r4wElqqDxNhWeYaBFg30INm8sbeblDHdVvL7Dlhd2rk/gbBlvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784636836; c=relaxed/simple;
	bh=twrE9nXixrTSUIJj1+tXS1I4jp5WgIOj0lCl1/LDU4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Un9QEp+ms/6M5oEzH45EHum+vx1nqjp4y8HfMQldUqqwRw8hSfXXHkJey3whHFCqhk555o/2aXD0fqbWQ+/hIk7RCP9BgLnBhU8Y1kGNQRayNG4FyUKDvYEeM1poqzA5d3XkrNXaU1GScQ6TqlEXHkIdfoUg/8RgJxkj+/Sf4e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rqMAiuV4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wsNciPgv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rqMAiuV4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wsNciPgv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rqMAiuV4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wsNciPgv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rqMAiuV4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wsNciPgv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 942D47A4FA;
	Tue, 21 Jul 2026 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784636832;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0K5TC72m9HZ43JjgBrdpk6uKWc+M/5Z/8dOF22lxqsM=;
	b=rqMAiuV4RcRFRO7eQvTvzNO/e8X6rLCduu+gpvOqrObKlZalk2i+EhVg3yFlIQ+eMotS0V
	5U0oWeqkh5HM+z/L6/lf2F648vNc0NMjADm94qbBjThvnW/fz7gg9jQJnxx1XZcJ8NDWxY
	sNDyGnnIw+6hOhnixb4Ck5P+2zV9lGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784636832;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0K5TC72m9HZ43JjgBrdpk6uKWc+M/5Z/8dOF22lxqsM=;
	b=wsNciPgvjSeBtsNape+36oLh4g9lM9YXYxm10ari1W/LB857LtCNYXkp4+qT/eh4yeSPFG
	kz/9GvBGgs0kB8Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rqMAiuV4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wsNciPgv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784636832;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0K5TC72m9HZ43JjgBrdpk6uKWc+M/5Z/8dOF22lxqsM=;
	b=rqMAiuV4RcRFRO7eQvTvzNO/e8X6rLCduu+gpvOqrObKlZalk2i+EhVg3yFlIQ+eMotS0V
	5U0oWeqkh5HM+z/L6/lf2F648vNc0NMjADm94qbBjThvnW/fz7gg9jQJnxx1XZcJ8NDWxY
	sNDyGnnIw+6hOhnixb4Ck5P+2zV9lGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784636832;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0K5TC72m9HZ43JjgBrdpk6uKWc+M/5Z/8dOF22lxqsM=;
	b=wsNciPgvjSeBtsNape+36oLh4g9lM9YXYxm10ari1W/LB857LtCNYXkp4+qT/eh4yeSPFG
	kz/9GvBGgs0kB8Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 78959779AA;
	Tue, 21 Jul 2026 12:27:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LLo5HaBlX2r7SwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Jul 2026 12:27:12 +0000
Date: Tue, 21 Jul 2026 14:27:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Leo Martins <loemra.dev@gmail.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>, Sun YangKai <sunk67188@gmail.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2] btrfs: replace writeback inhibition xarray with a
 fixed inline buffer
Message-ID: <20260721122707.GJ10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <12d3c3f07b8610ca13b0f3f792d420541afb7b33.1782949130.git.loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12d3c3f07b8610ca13b0f3f792d420541afb7b33.1782949130.git.loemra.dev@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 942D47A4FA
X-Spam-Flag: NO
X-Spam-Score: -2.71
X-Spam-Level: 
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.com,vger.kernel.org,fb.com,bur.io,gmail.com,intel.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Wed, Jul 01, 2026 at 04:47:10PM -0700, Leo Martins wrote:
> Commit f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent
> COW amplification") tracks the extent buffers a transaction handle has
> inhibited in a per-handle xarray. Keying the tracking to the transaction
> handle is correct, but using an xarray for it causes two problems in
> production.
> 
> First, a write_iops regression. Every COW calls
> btrfs_inhibit_eb_writeback() from btrfs_force_cow_block() and
> should_cow_block(), which does an xa_store() keyed by eb->start. The
> kernel test robot reported a 22.6% fio.write_iops regression on a
> single-task 4k randwrite workload (ftruncate ioengine, buffered IO) on
> btrfs. The cost is the per-COW xarray store done on every COW'd block.
> Replacing it with a non-allocating fixed buffer recovers the lost
> throughput, and that buffer does more per-COW bookkeeping yet still
> recovers, so the cost is the xarray operation itself rather than the
> extra tracking work.
> 
> Second, an unbounded cleanup walk. btrfs_uninhibit_all_eb_writeback()
> iterates every eb the handle inhibited with xa_for_each(). A single
> handle that COWs a very large number of blocks (inode eviction, or
> truncate of a file with many extents, where btrfs_truncate_inode_items()
> loops over many search_again descents under one handle) makes that walk
> arbitrarily long. It runs in __btrfs_end_transaction() before
> num_writers is dropped, so it blocks the committing thread; this shows up
> as multi-second stalls and RCU stall reports.
> 
> Replace the xarray with a fixed inline array on btrfs_trans_handle,
> managed with a CLOCK (second-chance) eviction policy. Inhibiting a buffer
> becomes an array append with no allocation and no tree walk, and the
> end-of-handle cleanup is bounded by the array size.
> 
> The set that actually needs protection is the working set the handle
> revisits across search_again descents, the search path frontier, which is
> on the order of the tree height. It is not every block the handle ever
> COWs. should_cow_block() re-inhibiting an already tracked buffer marks it
> referenced, so revisited buffers survive eviction while write-once buffers
> are reclaimed first. A small fixed buffer is therefore enough where a
> non-evicting array would either overflow or have to grow without bound.
> BTRFS_INHIBITED_EBS_SLOTS is 8 and the reference bits pack into a u32.
> 
> The CLOCK eviction is what justifies the extra complexity over a plain
> non-evicting array. The test workload stresses amplification: it removes
> 16 heavily fragmented 64 MiB files in one transaction while background
> writeback keeps writing out in-use metadata. A re-COW event is a buffer
> already COWed in the running transaction that was written back and then
> COWed again; the figure below is the ratio of re-COW events to first-COW
> events summed across the eviction (n=5, lower is better):
> 
>   tracking                           re-COW per first-COW
>   no inhibition                      6.1
>   non-evicting array, 32 slots       3.8
>   CLOCK array, 8 slots (this patch)  1.6
>   unbounded xarray (reverted)        1.4
> 
> The non-evicting array fills with write-once buffers and stops covering
> the buffers the handle keeps revisiting, so even at four times the slots
> it leaves most of the amplification. CLOCK evicts the cold buffers and
> keeps the revisited ones, recovering almost all of the unbounded benefit.
> The eviction policy, not the buffer size, is what closes the gap.
> 
> eb->writeback_inhibitors and the WB_SYNC_ALL bypass in
> lock_extent_buffer_for_io() are unchanged, so fsync and commit behavior
> are unaffected. A reference is taken on each tracked buffer so it cannot
> be freed while the array points at it; eviction drops that reference and
> the inhibitor count.
> 
> Fixes: f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202603112240.f7605968-lkp@intel.com
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> Reviewed-by: Sun YangKai <sunk67188@gmail.com>
> ---
> v2:
> - Present the amplification numbers as a table instead of prose (David Sterba).
> - Use int for the loop indices and the slot local instead of u32 (David Sterba).
> - Replace the BTRFS_INHIBITED_EBS_SLOTS comment with static_assert checks for
>   the <= 32 bound and the power-of-two size (David Sterba).
> - Widen inhibited_ebs_hand from u8 to u32; the handle stays in the same slab
>   bucket and the u8 only left an alignment hole (David Sterba).
> - Factor slot selection and eviction into btrfs_inhibit_claim_slot()
>   (Sun YangKai).
> - Add Reviewed-by from Sun YangKai.

I've fixed up the thing Filipe pointed out and added the patch to
for-next, also with a reference to the testing report from Chengfeng Lin.
