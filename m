Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427F91C7012
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 10:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779705111; cv=none; b=rgLJ3GdkSGk6gYPnjAkiCJ8igtr9I95xlJ9QKPMWcfxq+rXLfI7LLplSvM4NdkHdDSKIUTw5vXKZtss4imzQXDDPkoXFiZjSr06XVyAhjH6XSVlmKlY5H3MoThdiurYMc8TwvGU+ktgMJzewg1I2+p1igvBeKJr5mLPoQfhu2Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779705111; c=relaxed/simple;
	bh=Z/EeS73chawEGFO/mgLW+ydhfIHz1n7k0n2unS3IY6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWenfNNal38nsnr6bgTPLH16vNajWbc/viBEl0/v3CjXqgJNaImEAFjiffoGTREgZkHxsWk1RIAiLpdXQObAisZGYAZzIMqBrHAnCR2BW5TSeRLxQAP5j4EzPomweZ8xZVX/9XVzUAfZM+nGNGfckGXHfU4ZPRXiTYbyH9QLEAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mEV4nFRz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ghyQUNr7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=e6JHH5LC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BBWoJzqe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mEV4nFRz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ghyQUNr7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="e6JHH5LC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BBWoJzqe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 54D5566DF1;
	Mon, 25 May 2026 10:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779705108;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=krpVleC/BEOM/ocx63HhxxACKjuifQUxzyLd/OZ09hE=;
	b=mEV4nFRzyymGfaI0Tn+3rtRaz0sOkYp4DvJ5zBd6ElDjwl2fEi128lOA4BrFx9V54YM0YJ
	LycA8K+QU4Hpf0w4X8kbFmXK5ZXcY0L1E2XX1+zNZ6AJ4Twnh3tKD3p12UFLiacmZvvIyB
	lnv2vTuVdS1pCjHOkOZNLxTC8w866tA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779705108;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=krpVleC/BEOM/ocx63HhxxACKjuifQUxzyLd/OZ09hE=;
	b=ghyQUNr7HH8Iznml57gY+pc8HZmzl7NbkBhmv1H/92AnObOZvNREV/cTZcvXY4szPxfCE3
	GkOYnePdAsHteeCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779705107;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=krpVleC/BEOM/ocx63HhxxACKjuifQUxzyLd/OZ09hE=;
	b=e6JHH5LCVM8UQCybewEleS1mVS9PEpLw6PjoyPExKCVWORUGt0tEO8QadhDiUzaTOsoI0v
	oPWlLZ504ERSiS7SdfGzuFfV0sV7V5swZ288dBu6N8U9cgulrqMdECf2sPhKCg+C4eGVx6
	YaSVKH6OmVUUg+xJkK5ue2f1JoAEK+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779705107;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=krpVleC/BEOM/ocx63HhxxACKjuifQUxzyLd/OZ09hE=;
	b=BBWoJzqeP5si4vAvIR1rio09lLtHD+cA+RHLTHuilLVwftL3+kxHO44sL9RhTu1jCO3ENB
	ybq26pLtwDeaLsAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33FB759BCB;
	Mon, 25 May 2026 10:31:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +NVxDBMlFGopSQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 10:31:47 +0000
Date: Mon, 25 May 2026 12:31:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: experimental support for huge data folios
Message-ID: <20260525103145.GX12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778646753.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1778646753.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, May 13, 2026 at 02:06:17PM +0930, Qu Wenruo wrote:
> [CHANGELOG]
> v2:
> - Rebased to the latest for-next branch
>   There are several conflicts with the removal of locked and ordered
>   sub-bitmaps.
> 
>   Now huge folios will take full advantage of the reduced sub-bitmap
>   size.
>   Previously we need 5x64 bytes for the sub-bitmaps, now it's only
>   3x64 bytes, a reduction of 40%.
> 
>   Although the increase on on-stack memory usage is still there.
> 
> - Minor grammar fixes
>   Mostly in the commit message.
> 
> RFC->v1:
> - Rebased to the latest for-next branch
>   Which provides a stable baseline that can pass usual fstests runs, and
>   no more 2K fs block size support.
> 
> - Mark the new huge folio support as experimental
>   Since the large folio support itself is moved out of experimental
>   features, the huge folio support will need to be hidden behind
>   experimental.
> 
> - Rework the blocks per folio limit
>   Previously blocks per folio limit is always calculated by
>   BTRFS_MAX_FOLIO_SIZE / BTRFS_MIN_BLOCK_SIZE, but the real blocks per
>   folio is also depending on the fs block size.
> 
>   Now introduce a new BTRFS_MAX_BLOCKS_PER_FOLIO macro, which is either
>   BITS_PER_LONG (the old one), or 512 (the new experimental one).
> 
>   This will allow non-experimental builds to get rid of the enlarged
>   bitmap, thus lower the on-stack memory usage for non-experimental
>   builds.
> 
> Currently btrfs only supports folios as large as BITS_PER_LONG * blocks.
> This is an artificial limit introduced to make bitmap operations easier.
> 
> Btrfs has two extra bitmaps that are out of btrfs_folio_state structure,
> btrfs_bio_ctrl->submit_bitmap and @delalloc_bitmap inside
> writepage_delalloc().
> 
> Limits the bitmap size to BITS_PER_LONG makes it very easy to handle the
> above two bitmaps, we can just use a local unsigned long, no need to do
> any memory allocation.
> 
> On the other hand, those two external bitmaps are the only thing
> limiting huge folios.
> 
> The 1st patch will update the comments related to subpage implementation
> first.
> The 2nd patch will handle the subpage internal operations, mostly to
> handle bitmap dumping.
> The 3rd patch will prepare btrfs_bio_ctrl::submit_bitmap to be a proper
> pointer for the incoming huge folios support.
> 
> The final patch will enable the huge folio support, by using on-stack
> bitmap that can contain 512 bits.
> That will ensure 2MiB folio size, which is order 9 on 4K page sized
> systems.
> 
> Qu Wenruo (4):
>   btrfs: update the out-of-date comments on subpage
>   btrfs: prepare subpage operations to support >= BITS_PER_LONG
>     sub-bitmaps
>   btrfs: migrate btrfs_bio_ctrl::submit_bitmap to support larger bitmaps
>   btrfs: introduce support for huge folios

Please add it to for-next, thanks.
