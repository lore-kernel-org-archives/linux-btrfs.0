Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499642E62B7
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 19:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773431263; cv=none; b=dgUGHkwqgUGbuZvohPN0XcXTA9KG2+gc5uJCanI3SIAjSa89hZcCoSA7ewFdxnSYbQPN5Ux+i9jN5fYAAueWhiTiE3Qn0iXETwwKki8RBo6s5xG1fy1W71zVhBZAlxVez2h8kCt6us7edTlD1TT5gnlacG7ze12KQOEsBLjov0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773431263; c=relaxed/simple;
	bh=7PAR6oJgug5y+pGYC+lFzHxoHSf14o36YcnmRoxevqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJDmctBj52AW6uIqBCEZeeldyXXjhGePHaawjJJak4ryPYQI54v7QsINaQta7PkGElEWBAXw/Pn4/Qcaqym+Gy8uiwAoiRq8jBL4LWNaU1MSrb4Qaop1q1rVGmYeDz4fUGugijspxCEowNw7HFJNwuDivG+ZhTnjukkV/nUL9fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vvVp0YOj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+4/nisCJ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vvVp0YOj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+4/nisCJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vvVp0YOj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+4/nisCJ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vvVp0YOj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+4/nisCJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4D91F4DAE2;
	Fri, 13 Mar 2026 19:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773431260;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ine/dPrN6erv666w318kZqV25NbvxGY85XUvYri24D8=;
	b=vvVp0YOjFtHgpIFMXrcinySCJUyWDcmBPFVT7xERq4ubaT35LNvCSUYeUOC/srNmsOpR00
	UZYRRyAiTZuFGHXn/fQ5iUa3Ig/mXPZ7/sFe/wZUwjUNQLYdY9IyCZ5DABz9dOSfYlYRo/
	x/VtU4Lktuic7opVwivsJ/6DNMmWABQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773431260;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ine/dPrN6erv666w318kZqV25NbvxGY85XUvYri24D8=;
	b=+4/nisCJyK42BlV/s5NL3PS/VGWh94DpvDav/SIPYzttCsMTNOhBQBA88wXfuST9dP/Ac5
	kX3/uXFNpyXMvlAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vvVp0YOj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+4/nisCJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773431260;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ine/dPrN6erv666w318kZqV25NbvxGY85XUvYri24D8=;
	b=vvVp0YOjFtHgpIFMXrcinySCJUyWDcmBPFVT7xERq4ubaT35LNvCSUYeUOC/srNmsOpR00
	UZYRRyAiTZuFGHXn/fQ5iUa3Ig/mXPZ7/sFe/wZUwjUNQLYdY9IyCZ5DABz9dOSfYlYRo/
	x/VtU4Lktuic7opVwivsJ/6DNMmWABQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773431260;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ine/dPrN6erv666w318kZqV25NbvxGY85XUvYri24D8=;
	b=+4/nisCJyK42BlV/s5NL3PS/VGWh94DpvDav/SIPYzttCsMTNOhBQBA88wXfuST9dP/Ac5
	kX3/uXFNpyXMvlAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34ADD406C5;
	Fri, 13 Mar 2026 19:47:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7fWzDNxptGkufAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 13 Mar 2026 19:47:40 +0000
Date: Fri, 13 Mar 2026 20:47:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, gality369@gmail.com
Subject: Re: [PATCH 1/2] btrfs: tree-checker: introduce checks for
 FREE_SPACE_INFO
Message-ID: <20260313194739.GL5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1773094579.git.wqu@suse.com>
 <dcc4425060fb18e7dc5b45e4ea05cd8afec13f6c.1773094579.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcc4425060fb18e7dc5b45e4ea05cd8afec13f6c.1773094579.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
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
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 4D91F4DAE2
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Tue, Mar 10, 2026 at 08:49:25AM +1030, Qu Wenruo wrote:
> Introduce checks for FREE_SPACE_INFO item, which include:
> 
> - Key alignment check
>   The objectid is the logical bytenr of the chunk/bg, and offset is the
>   length of the chunk/bg, thus they should all be aligned to the fs
>   block size.
> 
> - Item size check
>   The FREE_SPACE_INFO should a fix size.
> 
> - Flags check
>   The flags member should has no other flags than
>   BTRFS_FREE_SPACE_USING_BITMAPS.
> 
>   For future expansion, introduce a new macro
>   BTRFS_FREE_SPACE_FLAGS_MASK for such checks.
> 
>   And since we're here, the BTRFS_FREE_SPACE_USING_BITMAPS should not
>   use unsigned long long, as the flags is only 32 bits wide.
>   So fix that to use unsigned long.
> 
> - Extent count check
>   That member shows how many free space bitmap/extent items there are
>   inside the chunk/bg.
> 
>   And we know the chunk size (from key->offset), thus there should be at
>   most (key->offset >> sectorsize_bits) blocks inside the chunk.
>   Use that value as the upper limit and if that counter is larger than
>   that, there is a high chance it's a bitflip in high bits.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c         | 45 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/btrfs_tree.h |  3 ++-
>  2 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index ac4c4573ee39..980e4d52061f 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1928,6 +1928,48 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
>  	return 0;
>  }
>  
> +static int check_free_space_info(struct extent_buffer *leaf, struct btrfs_key *key,
> +				 int slot)
> +{
> +	struct btrfs_fs_info *fs_info = leaf->fs_info;
> +	struct btrfs_free_space_info *fsi;
> +	const u32 blocksize = fs_info->sectorsize;
> +	u32 flags;
> +
> +	if (unlikely(!IS_ALIGNED(key->objectid, blocksize) ||
> +		     !IS_ALIGNED(key->offset, blocksize))) {
> +		generic_err(leaf, slot,
> +		"free space info key range is not aligned to %u, has (%llu %u %llu)",

Please use the BTRFS_KEY_FMT macro for key specifier, I'll fix it in
git, thanks.
