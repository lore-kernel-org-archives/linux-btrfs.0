Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E9C3264FD
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776103004; cv=none; b=nzZNO95P9F+dRcQ8aoJj3n6qrZaKSUaf/3UOV+cFmXr5Jx0hZikKJ+cn+bgI4cGC9JkXQTW/ukK720VrYJe68kazDU/MrgN4NbQbTTIwLUMuj2e5cMiqz8+7fULtVVd3xzfJ6FUoztXpMCgq3ZktTurDb43cUEoVMiJWswnUloI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776103004; c=relaxed/simple;
	bh=BxSAR0EJREn30fZK4E4D2FGpoDgADpis/LR9lAmmPAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b2M3pNqW1z7PXyUfaltofzVX1xUDLkE8SjKYW7QvqzsrEwE5k9HpjmIaHc08S+ABJ6mFhD03Sx69/1NYq3Y6F0MG9wC8xGkwLcoyx4dZ1BlWHfWX9UluAqNdQr17h+P/rHFiwxpma75hL4bJd/p4wYk9MzLfNbTBe0SJkzXIB/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PlShS6Z6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q0/EQVp0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PlShS6Z6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q0/EQVp0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PlShS6Z6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q0/EQVp0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PlShS6Z6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q0/EQVp0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B97BA5BDE2;
	Mon, 13 Apr 2026 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776102999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DsBvKkMn4/EhgHEKlFJ7ZAZbTNJDxhARESet8SGpP2k=;
	b=PlShS6Z6TN1GKa0PVKTn3HJqKB68lL3PFoAEv2gDn1AXzcPCDQgA2MZt6CvHpgqsqkWvsD
	p0EieZujwxk1HVkpoisBpdDNEceLZOmNklrqan7zllOOe9iBte8K4NB8yOwzMLIUF9FAbz
	V9Qhc9pauI7Rt2qmBUNalxV8QsMb3HI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776102999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DsBvKkMn4/EhgHEKlFJ7ZAZbTNJDxhARESet8SGpP2k=;
	b=Q0/EQVp0qPrcR//4XXlg55W404BuV+aDtYqRyEkDVHZ2bgbb4Csf6h3PPvUBd+Bf95LtjR
	sYh3nrl4MVeiYADw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PlShS6Z6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Q0/EQVp0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776102999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DsBvKkMn4/EhgHEKlFJ7ZAZbTNJDxhARESet8SGpP2k=;
	b=PlShS6Z6TN1GKa0PVKTn3HJqKB68lL3PFoAEv2gDn1AXzcPCDQgA2MZt6CvHpgqsqkWvsD
	p0EieZujwxk1HVkpoisBpdDNEceLZOmNklrqan7zllOOe9iBte8K4NB8yOwzMLIUF9FAbz
	V9Qhc9pauI7Rt2qmBUNalxV8QsMb3HI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776102999;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DsBvKkMn4/EhgHEKlFJ7ZAZbTNJDxhARESet8SGpP2k=;
	b=Q0/EQVp0qPrcR//4XXlg55W404BuV+aDtYqRyEkDVHZ2bgbb4Csf6h3PPvUBd+Bf95LtjR
	sYh3nrl4MVeiYADw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9581A4AFF1;
	Mon, 13 Apr 2026 17:56:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qthcJFcu3Wk3TAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 17:56:39 +0000
Date: Mon, 13 Apr 2026 19:56:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: apply first key check for readahead when possible
Message-ID: <20260413175638.GC12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <49ae0f6badb787c1111daff252f034b7ae94f257.1775991651.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ae0f6badb787c1111daff252f034b7ae94f257.1775991651.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B97BA5BDE2

On Sun, Apr 12, 2026 at 08:31:05PM +0930, Qu Wenruo wrote:
> Currently for tree block readahead we never pass a
> btrfs_tree_parent_check with @has_first_key set.
> 
> Without @has_first_key set, btrfs will skip the following extra
> checks:
> 
> - Header generation check
>   This is a minor one.
> 
> - Empty leaf/node checks
>   This is more serious, for certain trees like the csum tree, they are
>   allowed to be empty, thus an empty leaf can pass the tree checker.
>   But if there is a parent node for such an empty leaf, it indicates
>   corruption.
> 
>   Without @has_first_key set, we can no longer detect such a problem.
> 
>   In fact there is already a fuzzed image report that a corrupted csum
>   leaf which has zero nritems but still has a parent node can trigger
>   a BUG_ON() during csum deletion.
> 
> However there are only two call sites of btrfs_readahead_tree_block():
> 
> - Inside relocate_tree_blocks()
>   At this call site we are trying to grab the first key of the tree
>   block, thus we are not able to pass a @first_key parameter.
> 
> - Inside btrfs_readahead_node_child()
>   This is the more common call site, where we have the parent node and
>   want to readahead the child tree blocks.
> 
>   In this case we can easily grab the node key and pass it for checks.
> 
> Add a new parameter @first_key to btrfs_readahead_tree_block() and pass
> the node key to it inside btrfs_readahead_node_child().
> 
> This should plug the gap in empty leaf detection during readahead.
> 
> Link: https://lore.kernel.org/linux-btrfs/20260409071255.3358044-1-gality369@gmail.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

> ---
>  fs/btrfs/extent_io.c  | 16 +++++++++++++---
>  fs/btrfs/extent_io.h  |  3 ++-
>  fs/btrfs/relocation.c |  2 +-
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 3f59fb0a9ee5..4d5605aaf827 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4635,15 +4635,21 @@ int try_release_extent_buffer(struct folio *folio)
>   * to read the block we will not block on anything.
>   */
>  void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
> -				u64 bytenr, u64 owner_root, u64 gen, int level)
> +				u64 bytenr, u64 owner_root, u64 gen, int level,
> +				const struct btrfs_key *first_key)
>  {
>  	struct btrfs_tree_parent_check check = {
>  		.level = level,
> -		.transid = gen
> +		.transid = gen,

It's not necessary to add the "," or was there another reason?

>  	};
>  	struct extent_buffer *eb;
>  	int ret;
>  
> +	if (first_key) {
> +		memcpy(&check.first_key, first_key, sizeof(struct btrfs_key));
> +		check.has_first_key = true;
> +	}
> +
>  	eb = btrfs_find_create_tree_block(fs_info, bytenr, owner_root, level);
>  	if (IS_ERR(eb))
>  		return;
