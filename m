Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9061E3EC2DB
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2026 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778075025; cv=none; b=gaczOQ2i8B+atQaVCj5x77/nTqMpdCcTK+WABMzgwpkq3CRLZjnvyetRT5YibkkQPAbVzblwQdtkqDV+t4QnOwaQxgBChzyQrjZB2fHuwhgTLylPJtu1xPHdSlmEITHqTFoUDnlrHku9Cwp53fvEr9jALC2LlTTLE/4s7F5v7SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778075025; c=relaxed/simple;
	bh=eDHnrkj9aNYuc5uMxxntRmN9oHbo9NX8e2lJYlgsesc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QioAgvqNrLBiqA5eDA/IoLL04+HsB7/63EHBtagPbKHTvWgUjlPlV2H0b/4xSeTLnxJa+Qzc8Or6JAWrMRtCwj/Mfezw79fhEOi5EzrA9YKk2NdC7sbvQF9gCU2aZtq0LSidDCP2zsQKr/UphSFeUHeF1UJ4oEkAataYmZXdP5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ynx19IKV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YvFm/q5k; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ynx19IKV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YvFm/q5k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ynx19IKV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YvFm/q5k";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ynx19IKV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YvFm/q5k"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D41CB6BCEA;
	Wed,  6 May 2026 13:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778075022;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VdtTT3nz9moBejioGCzRuKWgcRlEjo9z+bvLXWINDXc=;
	b=Ynx19IKVO0SapoZE7rFP+bsK3YuMuLpHmwfsL3OKiA10ofLSgYX76DhITKc6xhlcwE1VZV
	CtZKyE9Fc0nTLdVMZ+sS1VbrFbivWaUeUr/nmUTLpJcUda7U7yBu6AqyMcoH9BRzI1CYTP
	cHAZq1NIbtoFUsSzMvrm/NPLdCc8evM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778075022;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VdtTT3nz9moBejioGCzRuKWgcRlEjo9z+bvLXWINDXc=;
	b=YvFm/q5kEXMY6T60/INbqdp2p9uu3krA56repONCMs2wLY+vw0lOsHG/UbN2P926BdZHKc
	cz2E+rcY09StihCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778075022;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VdtTT3nz9moBejioGCzRuKWgcRlEjo9z+bvLXWINDXc=;
	b=Ynx19IKVO0SapoZE7rFP+bsK3YuMuLpHmwfsL3OKiA10ofLSgYX76DhITKc6xhlcwE1VZV
	CtZKyE9Fc0nTLdVMZ+sS1VbrFbivWaUeUr/nmUTLpJcUda7U7yBu6AqyMcoH9BRzI1CYTP
	cHAZq1NIbtoFUsSzMvrm/NPLdCc8evM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778075022;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VdtTT3nz9moBejioGCzRuKWgcRlEjo9z+bvLXWINDXc=;
	b=YvFm/q5kEXMY6T60/INbqdp2p9uu3krA56repONCMs2wLY+vw0lOsHG/UbN2P926BdZHKc
	cz2E+rcY09StihCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDAD4593A3;
	Wed,  6 May 2026 13:43:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SOoLLo5F+2nYewAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 06 May 2026 13:43:42 +0000
Date: Wed, 6 May 2026 15:43:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/4] btrfs: remove folio ordered flag
Message-ID: <20260506134341.GD2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777937175.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777937175.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00

On Tue, May 05, 2026 at 09:19:20AM +0930, Qu Wenruo wrote:
> Btrfs has a long history using an internal folio flag called ordered,
> which is to indicate if an fs block is covered by an ordered extent.
> 
> However this means we need to synchronize between ordered extents, which
> are managed by a per-inode ordered tree, and folio flag/subpage bitmap.
> 
> Furthermore with huge folio support, the ordered bitmap can be as large
> as 64 bytes (512 bits), which is not a small amount.
> 
> The series is going to remove folio ordered flag completely, along with
> the ordered subpage bitmap.
> 
> Most call sites of folio_test_ordered() are just inside ASSERT()s, so
> it's not too hard to remove them.
> 
> But there is a special call site inside btrfs_invalidate_folio() where
> we use ordered flag to check if we can skip an ordered extent.
> This is worked around by using the fact that we have waited for
> writeback of the folio, so that endio should have already finished for
> the writeback range. Then check dirty flags to determine if we can skip
> the OE range.
> 
> To get a reliable dirty flag for both sub-folio and full-folio cases, we
> can not clear the folio dirty flag early, so the first patch is
> introduced to change the folio dirty flag clearing timing, then the
> second patch can remove the folio_test_ordered() usage.
> 
> Then the third patch is to remove the remaining folio_test_ordered()
> usage, and finally we can remove the whole ordered flag/subpage bitmap
> completely.
> 
> [REASON FOR RFC]
> I'm not sure if we should remove the folio ordered flag completely, or
> keep it an internal debug feature for a while.

For debugging and additional verification we can keep it as long as it's
practical.

> The main concern is that we're removing quite some ASSERT()s, some are
> never hit, but at least one is very useful and had triggered several
> times during development, exposing bugs.
> 
> In the long run, we will eventually remove the folio ordered
> flag/subpage bitmap so that we can align btrfs_folio_state with
> iomap_folio_state, so ordered flags should still be gone eventually.
> 
> Another point of concern is the new btrfs_ordered_extent_in_range()
> helper for extent_writepage_io().
> Previously we're just doing a folio flag check, now we have to do an
> rbtree search.
> I hope the overhead is not that huge.

This seems to be a concern for removing the ordered bit, it will have
some performance impact. Searching in rb-tree is not cheap, compared to
a single bit check. This kind of optimization could be there even after
we switch to iomap.

Otherwise, reducing the size of bitmaps makes sense. We could live for a
release with less effective storage just to make sure things work and
then remove ordered bitmap or other optimizations.
