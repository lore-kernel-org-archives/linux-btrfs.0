Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4594EBAD7;
	Tue, 13 Oct 2026 12:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894140; cv=none; b=eJJaI+zCtzV6qVyKTMdSb1pWu+CMtnJIhqqRuGuoMV9uV7793jE0omAcoBZ2xFfRQ8/4gvKtJVtv1VXw2l+nsngijwnmpzH5uuOmuO55EJ8bsIYfRWG3DAsQPkrlFxcXziAP93wUcrLH6o5udroBrHQX516OsuboTVgXvbLWDSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894140; c=relaxed/simple;
	bh=ywiK+gX4Ip4X5HnD6TkPjtQdir8vLr/kQpjH/ztlvWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGfRzYF+GvDqwTpfD6zQUil2yJpzidheqdstV7zftG1sGRxzqnBZzZZjmo8BJqoWLBzpWUPMrhMDOfXtqaixgxdsbwE82U62IDOpe+COe1SWiIajngV+Okra9TIwPSpTogF1HBOdES1Tv1h5+YPWtKADmjCz66xZ2x0zP3KSPvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=smWi1ihr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R/MV1V77; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TsWWu4sq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HUwylZ2E; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="smWi1ihr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R/MV1V77";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TsWWu4sq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HUwylZ2E"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF94A21C31;
	Tue, 13 Oct 2026 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894137;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IGCmAGsfmmXxLdQJhGZGWtXqoVqw59mTSVOU4W5s73c=;
	b=smWi1ihr3Wn5DwWOO1A/HEA/fFdDBhYQ8U3qst/njHUlnlS3rQv8Jmz4GDmlZO0g3VJ+k3
	Em2irRAKZ5wmB6c7evXyBjjDrPzf/M04+o1Ik7arUJvliSD04Yyl7IjMf2mTJ69l1o1CnA
	B+NOGSQAgn1pjoP8n1TytiWdtQipDV8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894137;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IGCmAGsfmmXxLdQJhGZGWtXqoVqw59mTSVOU4W5s73c=;
	b=R/MV1V77GKww1wb/2MUCXM0RDXLxGlch2S45diOH/tVTZ+lRAx+cO8zAZx/5xnc6PzqnUx
	DzqBCrjRN3kS6jBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894135;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IGCmAGsfmmXxLdQJhGZGWtXqoVqw59mTSVOU4W5s73c=;
	b=TsWWu4sqKithahyKDI8QBWU6SbzOuIxn4ELfReGkSZt9uUppY8QcXfT8wJWn37AnbFWOrV
	NClVXwSfVJ1alPC60sBz4xuUm+AZ63G4XpKy2J6dMJpodW2I6iM23o4/wBjfwrBS4gpa7c
	wBs4MgKvvt1EtLkUgMog1GXayXiFr1U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894135;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IGCmAGsfmmXxLdQJhGZGWtXqoVqw59mTSVOU4W5s73c=;
	b=HUwylZ2EsPrgfhRXxbs/QdO2kmR8gscRbK4mmKCI5rYyID6UcLG085iYssqJXOlLY1b4F1
	78dMxoklf3sSSECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A533213341;
	Tue, 13 Oct 2026 12:22:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8ln0H3cizmovKQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 13 Oct 2026 12:22:15 +0000
Date: Tue, 13 Oct 2026 14:22:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/18] btrfs: remove the v1 space cache
Message-ID: <20261013122214.GA1310987@suse.cz>
Reply-To: dsterba@suse.cz
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[msgid.link:url,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]

On Mon, Oct 12, 2026 at 12:28:12PM -0400, Tal Zussman wrote:
> Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
> options can't select the v1 space cache anymore, but the code is all
> still there, and a filesystem with an old cache and no free space tree
> still enabled it from the superblock. Qu suggested removing it rather
> than converting its page handling to folios [1].
> 
> Patch 1 fixes a pre-existing leak in the cleanup path, where a crash
> before the delayed iput evicts a cache inode left it unreachable with
> its link count still set.
> 
> Patch 2 stops enabling the cache from the on-disk state, so an existing
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
> Patches 3-7 remove the write path, 8 and 9 the load path and
> disk_cache_state, and 10 and 11 the SPACE_CACHE flag and the unused
> half of the cleanup helper. Patches 12-17 remove the trimming ranges
> and the free space inode special cases in the write path, which only
> the v1 writer used. Patch 18 removes TRANS_JOIN_NOLOCK, which the space
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
> Based on the misc-next commit in btrfs for-next (a5c77fde6730).
> 
> [1] https://lore.kernel.org/linux-btrfs/e1dd5a75-9a67-4bc6-b8d8-bfff79b5b907@suse.com/
> 
> ---
> Changes in v4:
> - Patch 1 (new): Write the zero link count when removing a free space
>   inode, so an interrupted cleanup can't leak it.
> - Patch 2: Clear FREE_SPACE_TREE in btrfs_reconfigure() whenever the
>   free space tree is not on disk, so a remount that only warns about
>   the free space tree no longer leaves the option set, per Sashiko.
> - Patch 2: Dropped review tag.
> - Patch 16: Also drop the tree root check from the delalloc metadata
>   release.
> - Patch 18: Redo against the TRANS_* flag cleanups in for-next.
> - Link to v3: https://patch.msgid.link/20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu

Thanks, unfortunatelly this did not make it into the 7.4 pull as the
freeze was yesterday and I was not able to process the v3 last week.
The v4 still has some issues reported by sashiko. It could be still
possible to send that separately as 2nd pull to 7.4 because the code has
been in linux-next, small fixups would be possible, and it's code
removal.
