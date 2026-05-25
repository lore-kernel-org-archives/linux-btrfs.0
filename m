Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5A730C177
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779722004; cv=none; b=Y3R0sP4GkqNpPI3DEDETY3BMIgZvrDYxcMLo9Rp9mZAzB8vPZDKz0o3E+BvaYf8Y7qeqNSJXzvjEwigPyBKLoz6ec0phazSSgH8eZImW3Artq+2ZgUzqJ1ZEPwrjvKmpefDEnWT9LLrZ/DG5bh7j5EDNboS1JDkz83//T4cvgro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779722004; c=relaxed/simple;
	bh=NdD23v3jfOX326EkS4gUNd5Acj3CdFQI74dUN9p4peE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qukWznCLF9mgd4gDh14yoB3eIDSiJHD6JTbiaF0lynSWWPpJjICy0LAzjvmq7Bm1RdyevwL+hIHjjE7WTj0PxosVYhlJDgckUfb1MM54wf7SNSmtmsN50tpLaaK/MpArp0Wg+W6XLlTKrIANoElywsq2SgX1lG7qTBirgo9l4l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HCAaEoJ+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=85fH5dTU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UlJKlkE+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vApfa8Ph; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HCAaEoJ+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="85fH5dTU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UlJKlkE+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vApfa8Ph"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1060A67B77;
	Mon, 25 May 2026 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779722000;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dt4XXOfVKRrJIJGn85aA24AttknqOInNTi9Q69mR3Zw=;
	b=HCAaEoJ+JQCUo68c508TjQsjw99vJ8VAwZ91/G7eJTa5drmbe6nIvD7pNU3dPnCXKux74C
	/5jYcyCS0WzUqpWgUsuDc5v92vYuE3nKEBB25mi2eIf5uQw5fb2IOyBiOaFL1/Bpz5B0iJ
	sIfBDJf9TLgdBrNT6xjXjGzwxLa8vfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779722000;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dt4XXOfVKRrJIJGn85aA24AttknqOInNTi9Q69mR3Zw=;
	b=85fH5dTUWDSWev+ym2inIG2Jw0yGYfJFX2EiZpujpRo9SdleZJOJPhqVp20l2GQLqBpG8K
	un1HrGHTWIrr5KAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UlJKlkE+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vApfa8Ph
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779721999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dt4XXOfVKRrJIJGn85aA24AttknqOInNTi9Q69mR3Zw=;
	b=UlJKlkE+X172RFseeRcWET/eMDCQHD9sIxpm75XjCsIqC+vva0Pyxe8WveaxdwPE6lq+bE
	R7aTYrZpK0ZxGhs4m0psVbr9NHVUH82t0fvpxxNAwDiCUbSnE8AvYeruUGeD10JQAsNBQ5
	dm+rzFHX9WpcdAS1T2Ttocmkdy6g4Z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779721999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dt4XXOfVKRrJIJGn85aA24AttknqOInNTi9Q69mR3Zw=;
	b=vApfa8Ph2IIrRFU6ZyB6xU47FJK+jvWKGaywz6gMBxsegvnWjGXnvl49gYfEASbvmvuv0S
	SoWmdy6QG0d1jPAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC5C159CE4;
	Mon, 25 May 2026 15:13:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 69cINQ5nFGqwXgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 15:13:18 +0000
Date: Mon, 25 May 2026 17:13:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Teng Liu <27rabbitlt@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com, wqu@suse.com,
	linux-kernel@vger.kernel.org,
	syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] btrfs: validate data reloc tree file extent item
 members
Message-ID: <20260525151313.GF12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260427202822.278326-1-27rabbitlt@gmail.com>
 <20260513113553.213959-1-27rabbitlt@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513113553.213959-1-27rabbitlt@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.71
X-Rspamd-Queue-Id: 1060A67B77
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[3e20d8f3d41bac5dc9a2];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:dkim,suse.cz:replyto,appspotmail.com:email,syzkaller.appspot.com:url]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Wed, May 13, 2026 at 01:35:44PM +0200, Teng Liu wrote:
> get_new_location() uses BUG_ON() to crash the kernel if the file extent
> item it looks up has any of offset, compression, encryption, or
> other_encoding set non-zero. The data reloc inode is only written by
> relocation's own paths and the four fields are always 0 in what the
> kernel writes:
> 
>   - insert_prealloc_file_extent() memsets the stack item to zero and
>     only fills in type, disk_bytenr, disk_num_bytes and num_bytes, so
>     offset/compression/encryption/other_encoding stay 0.
>   - insert_ordered_extent_file_extent() copies oe->compress_type into
>     the file extent's compression field, but the data reloc inode is
>     created with BTRFS_INODE_NOCOMPRESS so compress_type is always 0;
>     encryption and other_encoding are reserved-and-zero in btrfs.
> 
> A non-zero value here means the leaf decoded from disk does not match
> what the kernel wrote, i.e. on-disk corruption. A malformed image
> reaches this code via balance and panics the kernel.
> 
> A previous attempt to enforce all four constraints in tree-checker's
> check_extent_data_item() was merged as commit 7d0ee95979e9 ("btrfs:
> validate data reloc tree file extent item members in tree-checker")
> and then reverted by commit 1c034697fcaa after btrfs/061 produced
> false positives on arm64 with 64K pages. The reason: relocation
> writeback legitimately produces REG file_extent_items with offset != 0
> in the data reloc tree. When an ordered extent covers only the back
> portion of an underlying PREALLOC (num_bytes < ram_bytes on the input
> file_extent), insert_ordered_extent_file_extent() inserts a REG with
> 
>   offset    = oe->offset
>   num_bytes = oe->num_bytes
>   ram_bytes preserved from the original PREALLOC,
> 
> and this item can reach disk if a transaction commit fires while it
> is present in the leaf.
> 
> The four fields belong in different layers:
> 
>   - compression, encryption and other_encoding are universal
>     invariants for every item in the data reloc tree, regardless of
>     cluster geometry. Enforce them in tree-checker's
>     check_extent_data_item() so a corrupt leaf is rejected at read
>     time.
> 
>   - offset is only an invariant at the cluster-boundary keys that
>     get_new_location() searches (the key is computed as
>     src_disk_bytenr - reloc_block_group_start). Partial-PREALLOC
>     writebacks legitimately place REG items at non-boundary keys with
>     offset != 0; tree-checker cannot reject these. The cluster-
>     boundary item is always written by either
>     insert_prealloc_file_extent() (offset=0 by memset) or by the
>     front portion of a partial writeback (offset=0 by construction),
>     so a non-zero offset there is corruption.
> 
> Enforce the universal invariants in check_extent_data_item() with a
> file_extent_err() rejection. Convert the BUG_ON() in
> get_new_location() to a -EUCLEAN return paired with btrfs_print_leaf()
> and btrfs_err() so the offending leaf is logged. The caller in
> replace_file_extents() already handles non-zero returns from
> get_new_location() by breaking out of the loop without aborting the
> transaction.
> 
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Suggested-by: David Sterba <dsterba@suse.com>
> Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>

Added to for-next, thanks.
