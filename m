Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C132773E4
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044103; cv=none; b=oQ5dGbf/Ei8eB05JHQrLKlX7AVXKffnFtD4KmW65o+euMKALGMDKriMqULSmNscyJHFs7qizqo1tiBBOwLNgtL0GgzsfEHzEzowA1Q7faozF6lh/4+bmCJ/MxRXN8LzaBNHensGkvXsm3AAfqVgFa5y746G8wXIe7Ef9p+Jev3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044103; c=relaxed/simple;
	bh=9B8Jej8471XU/VD1UK+/oALLMis2rCpt1wHRntSbEEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N54m+eAcheKe215VMFNPMTAeCLISX+PKwpRiYMj6BHqIpOII1SexxALs0b1LTYdpF2T7vYg9feBfPLLeNJQJs3lanjuzIJCenBFyGO5JOGaJDkvP/lTDYLglzAv2nTUbBr1QFZj61wFJt43lwRoLTXKXDNFzmtEVMyo+NdzgO8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RRqVonRo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u4mmS0ey; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RRqVonRo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u4mmS0ey; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RRqVonRo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u4mmS0ey";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RRqVonRo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u4mmS0ey"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 685A44D42D;
	Fri, 20 Mar 2026 22:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774044099;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GSxB2f7I2qkHrbG/2/TJ9kKn2pK4gmlj3PBQQebW2O0=;
	b=RRqVonRoGNySnE1FIR6yLhgV93+HPt5Lxpf4ifnIu4c7/ObEx+qYPv6lAGf8+kkfxTD6fJ
	K2n56iI8/DqZq7GRsWCL1l/8qihqINA6Qp89TyW4mqJuPaCcYZtlK7cRQLU0Dpb+OR0imd
	CpQu+wTJt6RAPVI221OIvkO/xHaejPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774044099;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GSxB2f7I2qkHrbG/2/TJ9kKn2pK4gmlj3PBQQebW2O0=;
	b=u4mmS0eyuUTTXPUF7s4BkOHKtYINIWfPMNom9BhyyASQC2Yg9KrPPP6vRg3+OG7oOTbxDp
	p+VZGxfn+kH6e/CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RRqVonRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=u4mmS0ey
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774044099;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GSxB2f7I2qkHrbG/2/TJ9kKn2pK4gmlj3PBQQebW2O0=;
	b=RRqVonRoGNySnE1FIR6yLhgV93+HPt5Lxpf4ifnIu4c7/ObEx+qYPv6lAGf8+kkfxTD6fJ
	K2n56iI8/DqZq7GRsWCL1l/8qihqINA6Qp89TyW4mqJuPaCcYZtlK7cRQLU0Dpb+OR0imd
	CpQu+wTJt6RAPVI221OIvkO/xHaejPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774044099;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GSxB2f7I2qkHrbG/2/TJ9kKn2pK4gmlj3PBQQebW2O0=;
	b=u4mmS0eyuUTTXPUF7s4BkOHKtYINIWfPMNom9BhyyASQC2Yg9KrPPP6vRg3+OG7oOTbxDp
	p+VZGxfn+kH6e/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D6E342A0A;
	Fri, 20 Mar 2026 22:01:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id navODsPDvWmsCAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 20 Mar 2026 22:01:39 +0000
Date: Fri, 20 Mar 2026 23:01:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Daniel J Blueman <daniel@quora.org>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
Message-ID: <20260320220137.GI5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260319053413.14771-1-daniel@quora.org>
 <4d6f78d3-f274-43e1-adc8-c4fff4f85e24@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d6f78d3-f274-43e1-adc8-c4fff4f85e24@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 685A44D42D

On Thu, Mar 19, 2026 at 07:26:34PM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/3/19 16:04, Daniel J Blueman 写道:
> > When booting Linux 7.0-rc4 on a Qualcomm Snapdragon X1 with KASAN
> > software tagging with a BTRFS filesystem, we see:
> > 
> > BUG: KASAN: invalid-access in xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
> > Read of size 8 at addr 7bff000804fe1000 by task kworker/u49:2/138
> > Pointer tag: [7b], memory tag: [b2]
> > 
> > CPU: 0 UID: 0 PID: 138 Comm: kworker/u49:2 Not tainted 7.0.0-rc4+ #34 PREEMPTLAZY
> > Hardware name: LENOVO 83ED/LNVNB161216, BIOS NHCN60WW 09/11/2025
> > Workqueue: btrfs-endio-meta simple_end_io_work
> > Call trace:
> > show_stack (arch/arm64/kernel/stacktrace.c:501) (C)
> > dump_stack_lvl (lib/dump_stack.c:122)
> > print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
> > kasan_report (mm/kasan/report.c:597)
> > kasan_check_range (mm/kasan/sw_tags.c:86 (discriminator 1))
> > __hwasan_loadN_noabort (mm/kasan/sw_tags.c:158)
> > xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
> > btrfs_csum_update (fs/btrfs/fs.c:106)
> > csum_tree_block (fs/btrfs/disk-io.c:103 (discriminator 3))
> > btrfs_validate_extent_buffer (fs/btrfs/disk-io.c:389)
> > end_bbio_meta_read (fs/btrfs/extent_io.c:3853 (discriminator 1))
> > btrfs_bio_end_io (fs/btrfs/bio.c:152)
> > simple_end_io_work (fs/btrfs/bio.c:388)
> > process_one_work (./arch/arm64/include/asm/jump_label.h:36 ./include/trace/events/workqueue.h:110 kernel/workqueue.c:3281)
> > worker_thread (kernel/workqueue.c:3353 (discriminator 2) kernel/workqueue.c:3440 (discriminator 2))
> > kthread (kernel/kthread.c:436)
> > ret_from_fork (arch/arm64/kernel/entry.S:861)
> > 
> > The buggy address belongs to the physical page:
> > page: refcount:3 mapcount:0 mapping:f1ff00080055dee8 index:0x2467bd pfn:0x884fe1
> > memcg:51ff000800e68ec0 aops:btree_aops ino:1
> > flags: 0x9340000000004000(private|zone=2|kasantag=0x4d)
> > raw: 9340000000004000 0000000000000000 dead000000000122 f1ff00080055dee8
> > raw: 00000000002467bd 43ff00081d0cc6f0 00000003ffffffff 51ff000800e68ec0
> > page dumped because: kasan: bad access detected
> > 
> > Memory state around the buggy address:
> > ffff000804fe0e00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
> > ffff000804fe0f00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
> >> ffff000804fe1000: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> > ^
> > ffff000804fe1100: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> > ffff000804fe1200: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
> > 
> > This occurs as contiguous pages may have different KASAN tags in the upper address
> > bits, leading to a tag mismatch if linear addressing is used.
> > 
> > Fix this by treating them as discontiguous.
> > 
> > Signed-off-by: Daniel J Blueman <daniel@quora.org>
> > Fixes: 397239ed6a6c ("btrfs: allow extent buffer helpers to skip cross-page handling")
> > 
> > ---
> >   fs/btrfs/extent_io.c | 12 ++++++++++--
> >   1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 5f97a3d2a8d7..e2b241fb6c0e 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -3517,8 +3517,16 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
> >   		 * At this stage, either we allocated a large folio, thus @i
> >   		 * would only be 0, or we fall back to per-page allocation.
> >   		 */
> > -		if (i && folio_page(eb->folios[i - 1], 0) + 1 != folio_page(folio, 0))
> > -			page_contig = false;
> > +		if (i > 0) {
> > +			struct page *prev = folio_page(eb->folios[i - 1], 0);
> > +			struct page *curr = folio_page(folio, 0);
> > +
> > +			/*
> > +			 * Contiguous pages may have different tags; can't be treated as contiguous
> > +			 */
> > +			if (curr != prev + 1 || page_kasan_tag(curr) != page_kasan_tag(prev))
> > +				page_contig = false;
> 
> I am not a fan of this solution.
> 
> Although it doesn't affect end users who don't have KASAN soft tag 
> enabled, I don't get what we can really get from the different tags.
> 
> I mean all those pages are already contig in physical addresses, why we 
> can not access the range in one go?
> 
> Maybe it will be better to set all pages with the same random tag if 
> page_contig is true?

I don't know if there's an interface how to change the tags but adding
one condition that enables a sanitizer to work on some platform does not
sound like a terrible thing. The contiguous pages on our side is an
optimization so it's a special case, I'd rather adapt to the sanitizers
than to let people ignore a warning or have to read a warning that that
one is harmless.
