Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A96245516F;
	Fri, 16 Oct 2026 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170860; cv=none; b=B7A35eFJyuEKD3KIcEOJV6RR+LkJEEBf7Ox9+jL/t1vSNfDEhAQMQFBfPrjeUKKOiZ2fgcxSLm7jqNLLFhbUXr6w9v+B+ukeRapTtVMc3o24HMsk9chl8I8R41p9QL29tOee7BgsQCiA8H7PZEP9P5Omt4c64h/qKh3vng+CyV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170860; c=relaxed/simple;
	bh=JYapKKS6ruYfXba2ERZhWRXjyBU4WUUxYqInIjsJWeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVjBSbu66N+HcExEbr3vBS8LiKDO3vNU+AeTbT37sSGPs3hRAeT8XSI7Fq5G02jXSZes93rsBVCL1U5EXYNFIqaoZuErZw4A7M214dT7aHXlP9T7ZNveEcnyiIYNpZ5SfS9MZZtxFQFeJg87SGiXXC80ZCC+nqLOG79Zp3ABFm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CnJTg5JR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ipIkDzCe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=26SFX1xF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u4H8dCxU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CnJTg5JR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ipIkDzCe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="26SFX1xF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u4H8dCxU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5EEC721CE8;
	Fri, 16 Oct 2026 17:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792170856;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjRpDGLYi8+0KKXQb8F+0ihOVW+dwncBYmwpvFHeGww=;
	b=CnJTg5JRrM88TAIZWGVqJM0Kf10Jw/J4ZDC3xwzpKEYA5+2thJLDowg2hfE9Fz53IuzeFs
	OHrYXaIfrvbaZgubVzXoXmeRHCIs1c71JtSO8YHFczPmh4OB6hGmPWSRVkQlME0uGJdQvx
	dtqdC8AtaQ7Q4GL4v64fsKTktm0LBeo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792170856;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjRpDGLYi8+0KKXQb8F+0ihOVW+dwncBYmwpvFHeGww=;
	b=ipIkDzCeoMsk1lD98V/baGANkK/KQ8kHQyE0gDX72hcQou93tOtzRrKh7v087dNsL+ch+j
	Bep5JsT8cnTy/YCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=26SFX1xF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=u4H8dCxU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792170854;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjRpDGLYi8+0KKXQb8F+0ihOVW+dwncBYmwpvFHeGww=;
	b=26SFX1xF2Y94Ev0iU/JdlR5DIvshA9RjDFOZ16YJbcLoSOuRpB5TdBKUNm63ULdnBjA/5+
	ht9L2wPRPDX7qaoCASOm1LxytDWPPUxnNiYZNI4dSK9M6pEslgxygfP1sD2yT+3MxGPfgs
	K7JkY9QdQA/HhRNVS3pEYuSY4cI/5Ko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792170854;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjRpDGLYi8+0KKXQb8F+0ihOVW+dwncBYmwpvFHeGww=;
	b=u4H8dCxUDZBDB1KA2lCCw2R4oL+Z8pexYz8xdQQikZm1yURVdtSiv9b7o39eVbXv8pO1kX
	VlN+fu7As4w4gZCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30165139B7;
	Fri, 16 Oct 2026 17:14:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2MiFA2Zb0mosWAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 16 Oct 2026 17:14:14 +0000
Date: Fri, 16 Oct 2026 19:14:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/19] btrfs: remove the v1 space cache
Message-ID: <20261016171411.GB1310987@suse.cz>
Reply-To: dsterba@suse.cz
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Spam-Score: -4.21
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,msgid.link:url];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Level: 
X-Rspamd-Queue-Id: 5EEC721CE8
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Thu, Oct 15, 2026 at 10:43:13AM -0400, Tal Zussman wrote:
> Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
> options can't select the v1 space cache anymore, but the code is all
> still there, and a filesystem with an old cache and no free space tree
> still enabled it from the superblock. Qu suggested removing it rather
> than converting its page handling to folios [1].
> 
> Patch 1 fixes a pre-existing bug in the ordered extent error path: a
> truncated ordered extent that fails to complete kept the extent maps for
> its written part while the extent itself was freed.
> 
> Patch 2 fixes a pre-existing leak in the cleanup path, where a crash
> before the delayed iput evicts a cache inode left it unreachable with
> its link count still set.
> 
> Patch 3 stops enabling the cache from the on-disk state, so an existing
> cache is cleaned up on the next read-write mount, as -o nospace_cache
> already did. This is the one user-visible change: the cleanup is now
> unconditional, and a read-write mount fails if it fails. There are two
> ways to fix this failure:
> 
> 1. Convert to the free space tree during mount (the recommended
>    conversion), but this could fail for the same reason.
> 
> 2. Run 'btrfs rescue clear-space-cache v1' on an unmounted filesystem.
> 
> Patches 4-8 remove the write path, 9 and 10 the load path and
> disk_cache_state, and 11 and 12 the SPACE_CACHE flag and the unused
> half of the cleanup helper. Patches 13-18 remove the trimming ranges
> and the free space inode special cases in the write path, which only
> the v1 writer used. Patch 19 removes TRANS_JOIN_NOLOCK, which the space
> cache was the only user of.
> 
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
> 
> This also removes the page-based I/O in the free space code.
> btrfs_io_ctl used a struct page array and was one of the last users
> of clear_page_dirty_for_io().
> 
> Tested with fstests (btrfs and generic quick groups), with and without
> the free space tree, with no regressions against the base kernel.
> Upgrading from a filesystem with an existing v1 cache written by a 6.8
> kernel was also tested. The cache is removed on the first read-write
> mount and on remount from read-only, and the resulting filesystem is
> clean under btrfs check and still mountable by the old kernel.
> 
> Based on btrfs for-7.4.
> 
> [1] https://lore.kernel.org/linux-btrfs/e1dd5a75-9a67-4bc6-b8d8-bfff79b5b907@suse.com/
> 
> ---
> Changes in v5:
> - Patch 1 (new): Drop the extent maps of the written part when a
>   truncated ordered extent fails to complete, per Sashiko.
> - Link to v4: https://patch.msgid.link/20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu

Thanks for the update, I've moved the patchset to for-next. Current plan
is to send it as a separate pull request for 7.4.
