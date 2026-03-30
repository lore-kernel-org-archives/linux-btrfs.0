Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CFC2BE7DC
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 20:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774902868; cv=none; b=qREGXB+/y/NXaYa7JD0ksBDIAs/IQXTiMHXuwGnx8a2HgPDPmOLCC2g5a6QEnz4NPmk+7/S0REmNKoOhSvaBwwzuhOj9QixTZG3nNEy4v3Mjdb8uIEjt5BmgQy+PS7GunZ4lbc42VNCv4CJvs7k5n3igeOVY3Y1QOftjIPQa5qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774902868; c=relaxed/simple;
	bh=NV7QUKKnzjUoc5IPFIy1PsH4pnNBRrGJhZquQX13c7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJD2Eowg6BKWdENQuYyVNSq0nQpPOerag3eT7Aa6v4sCWAHE2BG3vZpH5Rup5XjG7LCFkj6h2t+xNXZ/t1s7C92+rkPcBfKXJPH0QN/lMCSdSseYO/trn8Z3IWBDXlJof2Br3M6Uewjk2TyTUaqcHm4H/4AVAXzirbtXaX+ReXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DMUrzdnx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LXT2Pb05; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DMUrzdnx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LXT2Pb05; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DMUrzdnx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LXT2Pb05";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DMUrzdnx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LXT2Pb05"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BF11F4D24A;
	Mon, 30 Mar 2026 20:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774902864;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=937cq5IzldHkyuR5bqZkbiw2an25eDIdCNpcnidTRnw=;
	b=DMUrzdnxN735vuEmpLwqoe7akEWRLaljaOUZDCT4QXfb2wSxlsHKjcW47NAurkJADLAUjp
	9oMByhirGyimu9/F1BeWbMhcIW2zQPkI23C1oQS4HaA24CEZ87vq5hEhhI8KG/LxP1Rkc1
	SQKd4SiRfKhTATIiuNSJWoFbLRrLvSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774902864;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=937cq5IzldHkyuR5bqZkbiw2an25eDIdCNpcnidTRnw=;
	b=LXT2Pb05CcBUHF8GsEJaV1TFraUTkXHfudqg8uKzeoATYXmp+au9ldyFJJm+cB8xDT5vJy
	ONaOyc5uYjXpuOCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DMUrzdnx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LXT2Pb05
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774902864;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=937cq5IzldHkyuR5bqZkbiw2an25eDIdCNpcnidTRnw=;
	b=DMUrzdnxN735vuEmpLwqoe7akEWRLaljaOUZDCT4QXfb2wSxlsHKjcW47NAurkJADLAUjp
	9oMByhirGyimu9/F1BeWbMhcIW2zQPkI23C1oQS4HaA24CEZ87vq5hEhhI8KG/LxP1Rkc1
	SQKd4SiRfKhTATIiuNSJWoFbLRrLvSk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774902864;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=937cq5IzldHkyuR5bqZkbiw2an25eDIdCNpcnidTRnw=;
	b=LXT2Pb05CcBUHF8GsEJaV1TFraUTkXHfudqg8uKzeoATYXmp+au9ldyFJJm+cB8xDT5vJy
	ONaOyc5uYjXpuOCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DE994A0A2;
	Mon, 30 Mar 2026 20:34:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YFlmJlDeymm5TQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 30 Mar 2026 20:34:24 +0000
Date: Mon, 30 Mar 2026 22:34:15 +0200
From: David Sterba <dsterba@suse.cz>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: mark@harmstone.com, boris@bur.io, wqu@suse.com, dsterba@suse.com,
	clm@fb.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-team@meta.com
Subject: Re: [RESEND PATCH v2] btrfs: prevent direct reclaim during
 compressed readahead
Message-ID: <20260330203415.GB5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260328214619.114790-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328214619.114790-1-jp.kobryn@linux.dev>
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: BF11F4D24A
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Sat, Mar 28, 2026 at 02:46:19PM -0700, JP Kobryn (Meta) wrote:
> Under memory pressure, direct reclaim can kick in during compressed
> readahead. This puts the associated task into D-state. Then shrink_lruvec()
> disables interrupts when acquiring the LRU lock. Under heavy pressure,
> we've observed reclaim can run long enough that the CPU becomes prone to
> CSD lock stalls since it cannot service incoming IPIs. Although the CSD
> lock stalls are the worst case scenario, we have found many more subtle
> occurrences of this latency on the order of seconds, over a minute in some
> cases.
> 
> Prevent direct reclaim during compressed readahead. This is achieved by
> using different GFP flags at key points when the bio is marked for
> readahead.
> 
> There are two functions that allocate during compressed readahead:
> btrfs_alloc_compr_folio() and add_ra_bio_pages(). Both currently use
> GFP_NOFS which includes __GFP_DIRECT_RECLAIM.
> 
> For the internal API call btrfs_alloc_compr_folio(), the signature changes
> to accept an additional gfp_t parameter. At the readahead call site, it
> gets flags similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM.
> __GFP_NOWARN is added since these allocations are allowed to fail. Demand
> reads still use full GFP_NOFS and will enter reclaim if needed. All other
> existing call sites of btrfs_alloc_compr_folio() now explicitly pass
> GFP_NOFS to retain their current behavior.
> 
> add_ra_bio_pages() gains a bool parameter which allows callers to specify
> if they want to allow direct reclaim or not. In either case, the
> __GFP_NOWARN flag was added unconditionally since the allocations are
> speculative.
> 
> There has been some previous work done on calling add_ra_bio_pages() [0].
> This patch is complementary: where that patch reduces call frequency, this
> patch reduces the latency associated with those calls.
> 
> [0] https://lore.kernel.org/linux-btrfs/656838ec1232314a2657716e59f4f15a8eadba64.1751492111.git.boris@bur.io/
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> Reviewed-by: Mark Harmstone <mark@harmstone.com>
> ---
> v2:
>  - dropped patch 1/2, squashed into single patch based on David's feedback
>  - changed btrfs_alloc_compr_folio() signature instead of new _gfp variant
>  - update other existing callers to pass GFP_NOFS explicitly

Added to for-next, thanks.
