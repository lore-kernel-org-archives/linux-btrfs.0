Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D3933B951
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 14:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784729619; cv=none; b=ihA9MWsW3sOxpNuwBEu1V98Rw8oXUKwcsFKGyUo9jvF25XfDYizcuUkA2zCCayOA3Qx60Kr33GeeGhWpZ2IYodtnTuC3tJwLzFaUEyG8mRTeHXaTGdG52UxT9+TipP8zZ7k3L0iz46sEJ6I6E0Yd8f1gAwLEwrcIcw83UXPqYf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784729619; c=relaxed/simple;
	bh=AaZtNK/B7SMQprtmzWNWE5BRdD18Uc35UXXzfh/neW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3N/Bj71jTrkmG8X44j+/+f4nvJrYUjHxXA9tVnR4kStzZBIv0zhwubhMMJRGZwXuBdQGd0dhu0tsSw1UlHeHpl3GdON3bRWic86pR94Bp3zqRXBtr7lFODke3N8X9v2Mo+b/xtGPTeTzuOiNzAUY4PIOZ5+QT1TUFmMOkF+Qa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hZrW9WZy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BhxGGLMg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hZrW9WZy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BhxGGLMg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hZrW9WZy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BhxGGLMg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hZrW9WZy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BhxGGLMg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 909897AB1E;
	Wed, 22 Jul 2026 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784729615;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K48AGq7UCzxHtkT3ZTIdUfMHrUukIVT94KecuIqrXWk=;
	b=hZrW9WZyUmMNx14mLZvs2l+lkcofsE+VBsvFQ7+xpI8yw+vQ7nGBuo+ubuXpm6rJZQW8of
	ZiT69HuGTgpPHqgQ07oRd7SJlNIh8IVYGdHrtIPX/NeeIwk+4rf1jjcMyHsRgW3J1M4cs5
	ZaOMHAbpkahan7J/zKqJySuQPwt/x8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784729615;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K48AGq7UCzxHtkT3ZTIdUfMHrUukIVT94KecuIqrXWk=;
	b=BhxGGLMgeJxiie/CHgW4PG7YGi1UzHB4Fbx6znvSOePnD1HmAZLyDNR7/F3j+6mzuV9ztO
	oxy7o/ypjOykbzAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hZrW9WZy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BhxGGLMg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784729615;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K48AGq7UCzxHtkT3ZTIdUfMHrUukIVT94KecuIqrXWk=;
	b=hZrW9WZyUmMNx14mLZvs2l+lkcofsE+VBsvFQ7+xpI8yw+vQ7nGBuo+ubuXpm6rJZQW8of
	ZiT69HuGTgpPHqgQ07oRd7SJlNIh8IVYGdHrtIPX/NeeIwk+4rf1jjcMyHsRgW3J1M4cs5
	ZaOMHAbpkahan7J/zKqJySuQPwt/x8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784729615;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K48AGq7UCzxHtkT3ZTIdUfMHrUukIVT94KecuIqrXWk=;
	b=BhxGGLMgeJxiie/CHgW4PG7YGi1UzHB4Fbx6znvSOePnD1HmAZLyDNR7/F3j+6mzuV9ztO
	oxy7o/ypjOykbzAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86959779B0;
	Wed, 22 Jul 2026 14:13:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WiqiIA/QYGraWgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 22 Jul 2026 14:13:35 +0000
Date: Wed, 22 Jul 2026 16:13:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: disable large folios for systems with highmem
Message-ID: <20260722141334.GM10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <555623ad2f49989444fd60eb2bd11f0371086670.1784540975.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555623ad2f49989444fd60eb2bd11f0371086670.1784540975.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.cz:replyto,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Queue-Id: 909897AB1E
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Mon, Jul 20, 2026 at 07:19:41PM +0930, Qu Wenruo wrote:
> [BUG]
> There is a bug report that on 32bit systems (i686), btrfs crashes when
> trying to do zstd compression:
> 
>  BUG: unable to handle page fault for address: fffbc000
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  CPU: 0 UID: 0 PID: 61 Comm: kworker/u8:5 Tainted: G                 N  7.2.0-rc3-P3 #2 PREEMPTLAZY
>  Hardware name: LENOVO 2007F2G/2007F2G, BIOS 79ETE7WW (2.27 ) 03/21/2011
>  Workqueue: btrfs-delalloc btrfs_work_helper
>  EIP: ZSTD_compressStream2+0x221/0x5fc
>  Call Trace:
>   ZSTD_compressStream+0xd/0x48
>   zstd_compress_stream+0x8/0x10
>   zstd_compress_bio+0x20a/0x564
>   btrfs_compress_bio+0x94/0xc0
>   compress_file_range+0x20a/0x380
>   btrfs_work_helper+0xc1/0x1b4
>   process_scheduled_works+0x15f/0x204
>   worker_thread+0x10c/0x178
>   kthread+0xe1/0xe8
>   ret_from_fork+0x1d/0x14c
>   ret_from_fork_asm+0x12/0x18
>   entry_INT80_32+0xf0/0xf0
>  CR2: 00000000fffbc000
>  ---[ end trace 0000000000000000 ]---
> 
> [CAUSE]
> Inside zstd_compress_bio(), we assume the whole page cache folio can be
> mapped in one go.
> 
> However that assumption is not true on systems with CONFIG_HIGHMEM, the
> pages of the large folio can be in HIGHMEM, which needs to be mapped
> before access.
> 
> Meanwhile zstd_compress_bio() only map the page of a large folio where
> the start filepos is, the remaining pages are not mapped, and accessing
> the remaining pages will trigger the above crash.
> 
> [FIX]
> Do not enable large folios when the kernel has CONFIG_HIGHMEM enabled.
> 
> This is the same handling for bs > ps support.
> 
> Link: https://github.com/kdave/btrfs-progs/issues/1146
> Fixes: 9bce95edb1b4 ("btrfs: move large data folios out of experimental features")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
