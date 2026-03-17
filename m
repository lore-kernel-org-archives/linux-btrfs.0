Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CBE35B653
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 10:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773742322; cv=none; b=pm0I9wAk5fq6RHGeTf42/Qp5XSgBClJEpMjXr0ZjmI/FleQNvbCRv6sHHPxOiW96E1e9pk+DqGH0F5zyIYrFLR8Tij5iEnw3i4clcegzWPsmyatABQpp3GFuXxOIYVBduTeAH4T41qDnvsW+sK9ou8o60XxDgG0zftM0jXF4uNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773742322; c=relaxed/simple;
	bh=UgHnwWr1roMBk95JUFpHeCfvARhe5QD5Mm2HiWnGca0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVw/qD1dU0JvfHaeYEiwMOGmWin7SbM7CmbBQKGYoR03TAgoXfAXLESkTKirXPXckCLIolxpOFK1fvC9xMsu3kZYSHckYZNV1+aNu8Xk31Tw+v9QpzkH/xFWEwNOpcpChDEdZCngfJU6lEAj3L4QX44z4MMUl3DLlDiqjXj6UEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cBS4oiYr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3sYWql3Y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rLKC7wrY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jpf53Ewd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cBS4oiYr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3sYWql3Y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rLKC7wrY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jpf53Ewd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E6E685BDB9;
	Tue, 17 Mar 2026 10:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773742319;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oN9oEn8L5BuQE7WPepuWh6yBRakm8rkTqigrb1+sJlg=;
	b=cBS4oiYrooz3GoMa3ZO6JXcUoI62bBLvNR2R/H0iW3jx6m7m1wLhTs6j6gMJEhX2EhnTaX
	SChbRZSLxLPAjq6wjinwmOUJ4VmDQwidCjeNGpCIpELIZBfry1pD+ear2ZFi4LJJ9ZvFrn
	vZZYZfb/VqbEyGxgAhkAR2y5rWMCKOI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773742319;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oN9oEn8L5BuQE7WPepuWh6yBRakm8rkTqigrb1+sJlg=;
	b=3sYWql3Yh9ALLBoJJRqygreH1ldxdpgiWp+211Ekq3/8b3tgUk0V9Mmnj2S91mcNbwYbRq
	J6zvEkoXHxTJAWDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773742318;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oN9oEn8L5BuQE7WPepuWh6yBRakm8rkTqigrb1+sJlg=;
	b=rLKC7wrYxKc7YPBxCbKsd8Qiv93iKLEII20kqb1UPwP4TBTaJJ6dEif1fiHBTMtf+3jqx2
	pPaQun62by9/AXHWyPM1yyR+F0HV72lVXxf2wDjcnXyJYJ4njCUsdSTVAQ8pRgd8n0JeSN
	HcqQ9BhbwgLNvsazh3Nr551VLbEs/r0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773742318;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oN9oEn8L5BuQE7WPepuWh6yBRakm8rkTqigrb1+sJlg=;
	b=jpf53EwdPDYNie1+o78CrsIExMnqZQPRDMTM1dC0pQHClZgOkPU6sVORU7hmAL0fYuO8dE
	aBo9uddpRwWSrjCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB3994273B;
	Tue, 17 Mar 2026 10:11:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j8WMLe4ouWkEWAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 17 Mar 2026 10:11:58 +0000
Date: Tue, 17 Mar 2026 11:11:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	Jean-Christophe Guillain <jean-christophe@guillain.net>
Subject: Re: [PATCH v2] btrfs: zlib: handle page aligned compressed size
 correctly
Message-ID: <20260317101157.GS5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ab5c12312b275589abd42c47a0c34b7e68375407.1773389056.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab5c12312b275589abd42c47a0c34b7e68375407.1773389056.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Fri, Mar 13, 2026 at 06:35:26PM +1030, Qu Wenruo wrote:
> [BUG]
> Since commit 3d74a7556fba ("btrfs: zlib: introduce zlib_compress_bio()
> helper"), there are some reports about different crashes in zlib
> compression path. One of the symptoms is list corruption like the
> following:
> 
>   list_del corruption. next->prev should be fffffbb340204a08, but was ffff8d6517cb7de0. (next=fffffbb3402d62c8)
>   ------------[ cut here ]------------
>   kernel BUG at lib/list_debug.c:65!
>   Oops: invalid opcode: 0000 [#1] SMP NOPTI
>   CPU: 1 UID: 0 PID: 21436 Comm: kworker/u16:7 Not tainted 7.0.0-rc2-jcg+ #1 PREEMPT
>   Hardware name: LENOVO 10VGS02P00/3130, BIOS M1XKT57A 02/10/2022
>   Workqueue: btrfs-delalloc btrfs_work_helper [btrfs]
>   RIP: 0010:__list_del_entry_valid_or_report+0xec/0xf0
>   Call Trace:
>    <TASK>
>    btrfs_alloc_compr_folio+0xae/0xc0 [btrfs]
>    zlib_compress_bio+0x39d/0x6a0 [btrfs]
>    btrfs_compress_bio+0x2e3/0x3d0 [btrfs]
>    compress_file_range+0x2b0/0x660 [btrfs]
>    btrfs_work_helper+0xdb/0x3e0 [btrfs]
>    process_one_work+0x192/0x3d0
>    worker_thread+0x19a/0x310
>    kthread+0xdf/0x120
>    ret_from_fork+0x22e/0x310
>    ret_from_fork_asm+0x1a/0x30
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
> 
> Other symptoms include VM_BUG_ON() during folio_put() but it's rarer.
> 
> David Sterba firstly reported this during his CI runs but unfortunately
> I'm unable to hit it.
> 
> Meanwhile zstd/lzo doesn't seem to have the same problem.
> 
> [CAUSE]
> During zlib_compress_bio() every time the output buffer is full, we
> queue the full folio into the compressed bio, and allocate a new folio
> as the output folio.
> 
> After the input has finished, we loop through zlib_deflate() with
> Z_FINISH to flush all output.
> 
> And when that is done, we still need to check if the last folio has any
> content, and if so we still need to queue that part into the compressed
> bio.
> 
> The problem is in the final folio handling, if the final folio is full
> (for x86_64 the folio size is 4K), the length to queue is calculated by
> 
>   u32 cur_len = offset_in_folio(out_folio, workspace->strm.total_out);
> 
> But since total_out is 4K aligned, the resulted @cur_len will be 0, then
> we hit the bio_add_folio(), which has a quirk that if bio_add_folio()
> got an length 0, it will still queue the folio into the bio, but return
> false.
> 
> In that case we go to out: tag, which calls btrfs_free_compr_folio() to
> release @out_folio, which may put the out folio into the btrfs global
> pool list.
> 
> On the other hand, that @out_folio is already added to the
> compressed bio, and will later be released again by
> cleanup_compressed_bio(), which results double release.
> 
> And if this time we still need to put the folio into the btrfs global
> pool list, it will result a list corruption because it's already in the
> list.

That's pretty convoluted but makes sense, it's an edge case and
depending on the compression data.

I guess we can drop patch
https://lore.kernel.org/linux-btrfs/30541df912ac4a2dd502796a823558fe1d88baa0.1772065237.git.wqu@suse.com/
the one removing the folio refcount from zlib, this was the first
trigger. Debugging with the assertion dropped allowed the bug to
manifest as the list corruption that I think made it more
understandable.

> [FIX]
> Instead of offset_inside_folio(), directly use the difference between
> strm.total_out and bi_size.
> So that if the last folio is completely full, we can still properly
> queue the full folio other than queueing zero byte.
> 
> Fixes: 3d74a7556fba ("btrfs: zlib: introduce zlib_compress_bio() helper")
> Cc: stable@vger.kernel.org # 7.0+

For same development cycle regressions the CC: stable is not necessary.

I'll queue the patch for the next -rc, thanks for fixing it.

> Reported-by: David Sterba <dsterba@suse.com>
> Reported-by: Jean-Christophe Guillain <jean-christophe@guillain.net>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=221176
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Add missing reported-by/link/cc tags
> ---
>  fs/btrfs/zlib.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index 1a5093525e32..147c92a4dd04 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -308,7 +308,9 @@ int zlib_compress_bio(struct list_head *ws, struct compressed_bio *cb)
>  	}
>  	/* Queue the remaining part of the folio. */

Maybe update this comment with brief description of the tricky case.

>  	if (workspace->strm.total_out > bio->bi_iter.bi_size) {
> -		u32 cur_len = offset_in_folio(out_folio, workspace->strm.total_out);
> +		const u32 cur_len = workspace->strm.total_out - bio->bi_iter.bi_size;
> +
> +		ASSERT(cur_len <= folio_size(out_folio));
>  
>  		if (!bio_add_folio(bio, out_folio, cur_len, 0)) {
>  			ret = -E2BIG;
> -- 
> 2.53.0
> 
