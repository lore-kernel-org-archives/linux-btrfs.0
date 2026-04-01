Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4606C191
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 00:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775001961; cv=none; b=UYeMX3aD2hzwJM+RxnNbilsnPqR/VSEuloEvmtFavjy3PIkFJUOuvD3Dhey+H4oH+tyVIwa5XLKPx/4D1BAnQTFFxyEpy6bbKc5bbVKfk2hCHtm47DAhJmw7+cS4AyWT9btJ73TiYFHdoQKtnUnNNhKXSSuizGQjyoXeE282cSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775001961; c=relaxed/simple;
	bh=wYB1kht2f3UYxbnvETiYpNjOrH+puJNpRmEgsywTQiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btub4kUltF+jLKyAInlzPT2pcPCCgIhbn7WAMdRTyvwGWJkxw0G3NxCAtufAlWR3SWrUU6MyhvubOlRvEZgB85QZUkPVU23thMS5AtoPFMnYo9O1AzMiYLRR81ZxyZ4mFhG75VS3LlhG9e0L2awjAGiVWYJMcQCZjSz1Xgzes34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jMIHloJF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A8uoqEMy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jMIHloJF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A8uoqEMy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jMIHloJF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A8uoqEMy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jMIHloJF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A8uoqEMy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 56F074D2AF;
	Wed,  1 Apr 2026 00:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775001958;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NxElbzT/TGvC1GRJsJjgsjyjqXc45if+q0t9Wz+tpXQ=;
	b=jMIHloJFo64m6UQ2esEQmrLjegr15/bUHNQRjhjJOyKfP4vNSpZBs9515xv5fyXzpxiGU/
	O5DNzLK4rAzpE0fWAndVJA4Z+3JTV3ccjoG698tk55diw8MIDIB8tQ8iu462BK/icsDrUK
	V3K7HSNXqc3aRlP3Fou/g+4uL/14Klw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775001958;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NxElbzT/TGvC1GRJsJjgsjyjqXc45if+q0t9Wz+tpXQ=;
	b=A8uoqEMyuuK6waTZhSmx+qevZ/kBXKXt3Xcny02JVi1G/JaZ2XgFJ4m98feRwVEjej2LQm
	ZrDywBunj6nugIDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jMIHloJF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=A8uoqEMy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775001958;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NxElbzT/TGvC1GRJsJjgsjyjqXc45if+q0t9Wz+tpXQ=;
	b=jMIHloJFo64m6UQ2esEQmrLjegr15/bUHNQRjhjJOyKfP4vNSpZBs9515xv5fyXzpxiGU/
	O5DNzLK4rAzpE0fWAndVJA4Z+3JTV3ccjoG698tk55diw8MIDIB8tQ8iu462BK/icsDrUK
	V3K7HSNXqc3aRlP3Fou/g+4uL/14Klw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775001958;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NxElbzT/TGvC1GRJsJjgsjyjqXc45if+q0t9Wz+tpXQ=;
	b=A8uoqEMyuuK6waTZhSmx+qevZ/kBXKXt3Xcny02JVi1G/JaZ2XgFJ4m98feRwVEjej2LQm
	ZrDywBunj6nugIDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E0744A0B0;
	Wed,  1 Apr 2026 00:05:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q6bIBmZhzGn/ZAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 01 Apr 2026 00:05:58 +0000
Date: Wed, 1 Apr 2026 02:05:56 +0200
From: David Sterba <dsterba@suse.cz>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: dsterba@suse.com, clm@fb.com, anand.jain@oracle.com, wqu@suse.com,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH] btrfs: disk-io: reject misaligned tree blocks in
 btree_csum_one_bio
Message-ID: <20260401000556.GC5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260325100411.2483356-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325100411.2483356-1-gality369@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.com,fb.com,oracle.com,vger.kernel.org,gmail.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 56F074D2AF
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Wed, Mar 25, 2026 at 06:04:11PM +0800, ZhengYuan Huang wrote:
> [BUG]
> Running btrfs balance on a corrupt image can trigger a GPF, with KASAN
> reporting a wild memory access:
> 
>   BTRFS warning: tree block not nodesize aligned, start 6179131392 nodesize 16384, can be resolved by a full metadata balance
>   Oops: general protection fault, probably for non-canonical address 0xe0009d1000000052: 0000 [#1] SMP KASAN NOPTI
>   KASAN: maybe wild-memory-access in range [0x0005088000000290-0x0005088000000297]
>   Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
>   RIP: 0010:get_unaligned_le64 include/linux/unaligned.h:28 [inline]
>   RIP: 0010:btrfs_header_bytenr fs/btrfs/accessors.h:647 [inline]
>   RIP: 0010:btree_csum_one_bio+0x175/0xfe0 fs/btrfs/disk-io.c:263
>   Call Trace:
> 	<TASK>
> 	btrfs_bio_csum fs/btrfs/bio.c:511 [inline]
> 	btrfs_submit_chunk+0x138d/0x1750 fs/btrfs/bio.c:744
> 	btrfs_submit_bbio+0x20/0x40 fs/btrfs/bio.c:814
> 	write_one_eb+0x9ea/0xd30 fs/btrfs/extent_io.c:2239
> 	btree_write_cache_pages+0x836/0xdc0 fs/btrfs/extent_io.c:2342
> 	btree_writepages+0x163/0x1c0 fs/btrfs/disk-io.c:512
> 	do_writepages+0x255/0x5c0 mm/page-writeback.c:2604
> 	filemap_fdatawrite_wbc mm/filemap.c:389 [inline]
> 	filemap_fdatawrite_wbc+0xf2/0x150 mm/filemap.c:379
> 	__filemap_fdatawrite_range+0xd2/0x120 mm/filemap.c:422
> 	filemap_fdatawrite_range+0x2f/0x50 mm/filemap.c:440
> 	btrfs_write_marked_extents+0x13c/0x2d0 fs/btrfs/transaction.c:1157
> 	btrfs_write_and_wait_transaction+0xe5/0x250 fs/btrfs/transaction.c:1264
> 	btrfs_commit_transaction+0x28af/0x3d90 fs/btrfs/transaction.c:2533
> 	insert_balance_item.isra.0+0x392/0x3f0 fs/btrfs/volumes.c:3712
> 	btrfs_balance+0x1021/0x42b0 fs/btrfs/volumes.c:4582
> 	btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
> 	btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
> 	...
> 
> [CAUSE]
> The corrupt image contains a tree block whose start address (6179131392)
> is page-aligned (4 KiB) but NOT nodesize-aligned (16 KiB):
> 
>   6179131392 % 16384 == 4096

While you say it's a corrupted image it feels like it was crafted to
have such offset. The warning is from 6d3a61945b0088 ("btrfs: warn on
tree blocks which are not nodesize aligned") and it tries to catch
problems of misaligned ebs.

As we'll be moving to the large folios eventually such misaligned blocks
will become a hard problem. So this should answer if this should be a
warning or an error.

As the commit and error message suggests to run balance to fix the
alignment problem I see that this should be somehow fixed if the crash
happens inside balance. On the other hand, the misalignment should not
happen at all.

As we try to be cautious about recognizing old filesystems with
potential problems we also have to stop at some point if it blocks a new
feature. The grace period is IMO long enough.

If you have reprocued the problem by normal operations then we should
look for the solution to prevent it. If it's from a crafted image that
basically creates a valid image, shifts a block to be come misaligned
and otherwise valid then I suggest to turn the warning to error and
reject the filesystem as early as possible.

> When alloc_extent_buffer() is called for such a block,
> check_eb_alignment() detects the nodesize misalignment, but only emits
> a one-time btrfs_warn() and returns false without failing the
> allocation. This allows the extent buffer to be created with a
> misaligned start.
> 
> Later, during transaction commit triggered by balance, write_one_eb()
> submits the dirty extent buffer for writeback, and
> btree_csum_one_bio() is called to checksum it before I/O submission.
> That path calls btrfs_header_bytenr(eb), which expands via
> BTRFS_SETGET_HEADER_FUNCS to:
> 
>   folio_address(eb->folios[0]) + offset_in_page(eb->start)
> 
> With a nodesize-misaligned start, eb->folios[0] does not correspond to
> a valid direct-mapped kernel address. folio_address() returns the
> garbage value 0x0005088000000260, and dereferencing +0x30 (the bytenr
> field offset in struct btrfs_header) triggers the GPF.
> 
> [FIX]
> Add a WARN_ON_ONCE() nodesize alignment check at the beginning of
> btree_csum_one_bio() and return -EIO for misaligned tree blocks.
> 
> btree_csum_one_bio() already guards against corrupted extent buffer
> state on the checksum path, and it also revalidates metadata on the
> write path. The alignment check follows that pattern and must happen
> before the first access to eb->folios[] via btrfs_header_bytenr().
> 
> Fixes: 6d3a61945b00 ("btrfs: warn on tree blocks which are not nodesize aligned")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> An alternative fix of promoting check_eb_alignment() from warn to error
> would prevent the misaligned eb from being created at all, but would
> break mount and repair workflows: users need to be able to read and
> inspect a filesystem containing legacy misaligned tree blocks in order
> to run "btrfs balance -m" and correct the alignment.

While I agree with that I think we should start rejecting such
filesystems because of the large folio support and because we hopefully
have spent the grace period without new reports and incidents.

If you have a crafted image, and possibly a minimal one, I can add it to
the btrfs-progs fuzzed images so it can be verified as part of the test
suite.
