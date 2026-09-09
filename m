Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DB1282F05;
	Wed,  9 Sep 2026 01:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788916135; cv=none; b=SYfureByVvQ+OQ7zROOKvn0mzvRI0+BoX3Iv6lEPm3vgCaIm7aIAfOUTZCpxVRysmbMirKTy+JoQ2HaNoXtSTBR25b7Br+6aSg0XUzPr3CzC19E+nz6wrjWgyeCoPb6VwWRYYGv5MgJfl1h2S+WdQzNyvgEbVVy5GTTE45Cd220=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788916135; c=relaxed/simple;
	bh=vHUe78W3WXthp1H+qK5EnvxdnwG5fkl7jO3pkTH8uFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICvqGG6myUIGKE2wnapXJQpQ6jCXRkpGKIifHtZeXzvzeXWzBA7yafLO7ytDzDXYhpHi78oHMCth8YqOIvb3ExChVMxITGiQSGN3sOHxBBaAtM6utplxBO35Foy6r97iZ8UHWn9IPTQt10l2xETPLQCjKQxK8z9kerbt2VScgVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h45MfnsL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GC2XnkZk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=U+oNu1NO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bh2tM9px; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h45MfnsL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GC2XnkZk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="U+oNu1NO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bh2tM9px"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E209121A75;
	Wed,  9 Sep 2026 01:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788916132;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3VeZ1pB51rIWEXEGcGHzu07VIOIhIzZdXjlb/Ixm98=;
	b=h45MfnsLNlKgAgoymNQdwgdMZTfG6KmAtvLEDXXM2qjihjc6xPk44wbaeALlt/HtCBL/A5
	uCwcC/CrpW4RAGm0aAgumVDk6VmZUp7RFzviLEPL5y5ODgdXU20KGfHkczZc+Zy1IWlRF0
	smr100YRrHBnPOaRCzLOPb94JPZEboE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788916132;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3VeZ1pB51rIWEXEGcGHzu07VIOIhIzZdXjlb/Ixm98=;
	b=GC2XnkZk+5ag3p2ghTbj9m3IIWEo9gTcwifWk1ZFTjMhxNsYswK+dIl5McEODBOTTegFCi
	T8HEkj4XfS818VDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=U+oNu1NO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bh2tM9px
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788916131;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3VeZ1pB51rIWEXEGcGHzu07VIOIhIzZdXjlb/Ixm98=;
	b=U+oNu1NOgN7GqNmpH2UpRJOFW7xirfyvpLeFHQKBlInhH4v+VavtvYUKmdNBmxmGufHQj2
	cmn/K8+mAoCdFXrIYnNZRT8X5BtKbwUh4bPVHSLmbPLKRq4iltBgZSkRZDSeTkfD7JvkN0
	6QLmy23PTlN4jU2ivA1uUxXzzbLrzEo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788916131;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3VeZ1pB51rIWEXEGcGHzu07VIOIhIzZdXjlb/Ixm98=;
	b=bh2tM9pxSzpRYWIcaJXOklmu/WgRA3QCymMzK9UrVPwfg6wkbUqZKZBigvu+E7xboBSDPT
	I8UQbXgSR98TofCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F6E01347F;
	Wed,  9 Sep 2026 01:08:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tzAzIqOxoGqQagAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 09 Sep 2026 01:08:51 +0000
Date: Wed, 9 Sep 2026 03:08:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] btrfs: remove the v1 space cache
Message-ID: <20260909010846.GH9053@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E209121A75
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Mon, Sep 07, 2026 at 09:19:15PM -0400, Tal Zussman wrote:
> Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
> options can't select the v1 space cache anymore, but the code is all
> still there, and a filesystem with an old cache and no free space tree
> still enabled it from the superblock. Qu suggested removing it rather
> than converting its page handling to folios [1].
> 
> Patch 1 stops enabling the cache from the on-disk state, so an existing
> cache is cleaned up on the next read-write mount, as -o nospace_cache
> already did. This is the one user-visible change: the cleanup is now
> unconditional, and a read-write mount fails if it fails.

In case it fails there are 2 ways how to fix it:

- convert to free space tree during mount (the recommended conversion
  from v1 to v2) but it could fail for the same reason

- on unmounted filesystem do 'btrfs rescue clear-space-cache v1'

> Patches 2-5
> remove the write path, 6 and 7 the load path and disk_cache_state, and
> 8 and 9 the SPACE_CACHE flag and the unused half of the cleanup helper.
> Patches 10-15 remove the trimming ranges and the free space inode
> special cases in the write path, which only the v1 writer used.

The piecemeal removal is good, makes it clear what's still needed, as
listed below.

> What's left is what's needed to find and delete the cache inodes of an
> existing filesystem:
> 
> 1. lookup_free_space_inode(), btrfs_remove_free_space_inode(), and
>    btrfs_cleanup_free_space_cache_v1(), which runs on the first
>    read-write mount and zeroes cache_generation in the super block.
> 
> 2. btrfs_truncate_free_space_cache() and delete_v1_space_cache(), which
>    relocation uses to get a cache inode's extents out of a block group.
> 
> 3. btrfs_is_free_space_inode(), for the evict and inode update paths.
> 
> 4. The on-disk definitions: cache_generation in the super block,
>    BTRFS_FREE_SPACE_OBJECTID, and the free space header and entry
>    items.
> 
> space_cache and space_cache=v1 still fall back to nospace_cache with a
> warning.

The sperblock::space_cache will remain unused and the only valid value
is 0. Repurposing it in the future is possible but we need a long period
in between.

The points listed above for the code that will be still needed seem
minimal. It could be removed eventually leaving only the unmounted
clearing.

I'll add the series as topic branch to linux-next. The mentioned change
to tranaction NOJOIN is simple and no-op in the code so it'll get
updated for the final merge.
