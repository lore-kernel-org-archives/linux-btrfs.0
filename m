Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8E12BFC7B
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 02:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776392296; cv=none; b=ZQzbrxIvr7wOuRmiuOccNjYchLbZfnZDvFi6KbbaaFwQ/0dhdqGQcRF2a8Fkt1DGXFxQUFg0ai/ZELObCmcRGPm1EP/ZPKOOs4F6NPScvnkeGIqtEP2ByLC3bh70OdpsxdU74ikWU4KNRPLheYH0WHnCPqweB3qcAMiRUZDDl3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776392296; c=relaxed/simple;
	bh=+rYvu3tav5RkGqrrS9OtifKX6QoxLxEt0bRdpLEVNtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSDrBUKE5msOxxbOVtnhlcPFjgxNXdFLKvyoN9pnOD63fLnj/YnfWo5Z60J5621UFDnoZ6j2OKEMw494hCM3lp6SKy39P/8039/yD40nbnotLAmHQmIEfpspymx0vdqzSHRtKxSZ6btL9LtzpNvUoi/UJu7WajkA2bSmvN2oSXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=K/qNGUoF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V2wzjObU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=K/qNGUoF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V2wzjObU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="K/qNGUoF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V2wzjObU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="K/qNGUoF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V2wzjObU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03B8A6A917;
	Fri, 17 Apr 2026 02:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776392292;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pySAkRCjmTr5rc6pFnTjQI4ZaN1r9Tub392aiNulslw=;
	b=K/qNGUoF112Y9j1qf4SbmwHg5jvgsy7Ou3nglQdEZV6N+0ftwjlk0QvSS/2OY/uaGeBsM1
	xqr4lQ/Ve8MHDmxTezg7EAH3YQwUQhD6zPS5BY8lw6SjDIbalp/p10gzc5Wiy0OT7pF21R
	qE6FnnVsJCSbuwRSpI42qEg6ksTH1AY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776392292;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pySAkRCjmTr5rc6pFnTjQI4ZaN1r9Tub392aiNulslw=;
	b=V2wzjObUdeuvXX8rJHUAv43ug7pszAkMvmrvyRVBFhienlPRlw9uLHHE9fEW4gt05mqgBr
	i4qIesl7O+aHaVDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="K/qNGUoF";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V2wzjObU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776392292;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pySAkRCjmTr5rc6pFnTjQI4ZaN1r9Tub392aiNulslw=;
	b=K/qNGUoF112Y9j1qf4SbmwHg5jvgsy7Ou3nglQdEZV6N+0ftwjlk0QvSS/2OY/uaGeBsM1
	xqr4lQ/Ve8MHDmxTezg7EAH3YQwUQhD6zPS5BY8lw6SjDIbalp/p10gzc5Wiy0OT7pF21R
	qE6FnnVsJCSbuwRSpI42qEg6ksTH1AY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776392292;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pySAkRCjmTr5rc6pFnTjQI4ZaN1r9Tub392aiNulslw=;
	b=V2wzjObUdeuvXX8rJHUAv43ug7pszAkMvmrvyRVBFhienlPRlw9uLHHE9fEW4gt05mqgBr
	i4qIesl7O+aHaVDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC219593AE;
	Fri, 17 Apr 2026 02:18:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZRiCNWOY4WnmWgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 17 Apr 2026 02:18:11 +0000
Date: Fri, 17 Apr 2026 04:18:10 +0200
From: David Sterba <dsterba@suse.cz>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs: fix multiple bugs in raid-stripe-tree
 deletion path
Message-ID: <20260417021810.GX12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260413065249.2320122-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413065249.2320122-1-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 03B8A6A917

On Mon, Apr 13, 2026 at 02:52:31PM +0800, robbieko wrote:
> This series fixes six bugs in fs/btrfs/raid-stripe-tree.c, all within the
> stripe extent deletion and partial deletion code paths.
> 
> Patch 1 fixes btrfs_partially_delete_raid_extent() failing to copy the
> devid when rebuilding a truncated stripe extent, resulting in zeroed-out
> devids and corrupted stripe mappings.
> 
> Patch 2 fixes btrfs_delete_raid_extent() using offset=0 for the search
> key, which can miss entries when the target is the first item on a leaf.
> Changed to offset=(u64)-1 with proper boundary handling.
> 
> Patch 3 fixes btrfs_previous_item() being called with min_objectid=start,
> which prevents finding the preceding stripe extent whose objectid is less
> than start.
> 
> Patch 4 replaces an ASSERT(found_start <= start) with proper error
> handling that returns -ENOENT, avoiding kernel panics on unexpected
> B-tree states.
> 
> Patch 5 handles -EAGAIN from btrfs_duplicate_item() in the punch-a-hole
> case and refreshes the stale leaf pointer after a potential leaf split.
> 
> Patch 6 adds return value checking for all three call sites of
> btrfs_partially_delete_raid_extent() to avoid silently losing errors.
> 
> robbieko (6):
>   btrfs: copy devid in btrfs_partially_delete_raid_extent()
>   btrfs: fix raid stripe search missing entries at leaf boundaries
>   btrfs: fix wrong min_objectid in btrfs_previous_item() call
>   btrfs: replace ASSERT with proper error handling in stripe lookup
>     fallback
>   btrfs: handle -EAGAIN from btrfs_duplicate_item and refresh stale leaf
>     pointer
>   btrfs: check return value of btrfs_partially_delete_raid_extent()

Added to for-next, thanks.
