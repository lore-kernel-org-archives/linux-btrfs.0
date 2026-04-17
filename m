Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CDF1D5CFE
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 02:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776392204; cv=none; b=U8fkwWwaj0eYGWe12KEH9lFlPk0HNK8RINCZNSHg++dUaQRFvQhSd9mr9HW96JDA4nF7fB57vFC/GF4ME0j80UX97a48+sn0WoZYI5PpV+hJ4ZxxYN7HXCXz+zeCIefTverOkVD2DiooWwExhSLkzuX9821xnwLxf7h7OyLwyRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776392204; c=relaxed/simple;
	bh=TtHdIPGNaE57N/t2aPDZ03/w17eQeWHxDtYPaIFoxLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VqxWx+nUwot9l766z6yTOR5YpVmhiApUMZ8zxE4ROi7X3ghByHsaTBgomCVK9mdxDnPvUSCdo345zW3bG16ONhhOR4fAtvXvFm03Vd5OmcjoFO6fvcyDyydgVgrFd0YF+bivA5DACfXm14emGPMzJkKzUR0kNR4iWbhlWzphAYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0+KL5OQA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0/rxEKqr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0+KL5OQA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0/rxEKqr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0+KL5OQA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0/rxEKqr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0+KL5OQA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0/rxEKqr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FD6F5BD22;
	Fri, 17 Apr 2026 02:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776392201;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOeJx6wjUp54CVaoRn4HGvCBaMUx5DRlwTOwoGnyyXw=;
	b=0+KL5OQABggts1Zdpa6eYeOGzliO51vhPIVqFX7o42aIvdfYUWo3jYGgsjnOvFAkdeRJPY
	HF2Uw9DkwvtQj7Kjk+rgQlyrJB1WHKxgu04k6jhnBdl4R8D450M88ZDe6pBOj/8Dk7VjJt
	TE629EZ1hiXDza4yRPY63i8tRaxKDXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776392201;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOeJx6wjUp54CVaoRn4HGvCBaMUx5DRlwTOwoGnyyXw=;
	b=0/rxEKqrRcyRXGVoTfsnfJqLaxUTRmaXo/aehtdGmfxtVKx7A9d+oMb8PjRfz67tVnrXXk
	EHmBf8aGo6qVX7Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776392201;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOeJx6wjUp54CVaoRn4HGvCBaMUx5DRlwTOwoGnyyXw=;
	b=0+KL5OQABggts1Zdpa6eYeOGzliO51vhPIVqFX7o42aIvdfYUWo3jYGgsjnOvFAkdeRJPY
	HF2Uw9DkwvtQj7Kjk+rgQlyrJB1WHKxgu04k6jhnBdl4R8D450M88ZDe6pBOj/8Dk7VjJt
	TE629EZ1hiXDza4yRPY63i8tRaxKDXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776392201;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOeJx6wjUp54CVaoRn4HGvCBaMUx5DRlwTOwoGnyyXw=;
	b=0/rxEKqrRcyRXGVoTfsnfJqLaxUTRmaXo/aehtdGmfxtVKx7A9d+oMb8PjRfz67tVnrXXk
	EHmBf8aGo6qVX7Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16E7C593AE;
	Fri, 17 Apr 2026 02:16:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KXdtBQmY4WmOWQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 17 Apr 2026 02:16:41 +0000
Date: Fri, 17 Apr 2026 04:16:39 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/10] btrfs: reduce memory consumption for block
 groups
Message-ID: <20260417021639.GW12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1776278490.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1776278490.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.com:email];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Apr 15, 2026 at 07:44:38PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Reduce the amount of memory used by block groups by using kmem caches
> and reducing structure sizes, plus a few cleanups. Details in the
> change logs.
> 
> V2: Add one extra patch that was missing, to further reduce the size
>     of struct btrfs_free_space_ctl (patch 7/10).
> 
> Filipe Manana (10):
>   btrfs: use a kmem_cache for block groups
>   btrfs: reduce size of struct btrfs_block_group
>   btrfs: use a kmem_cache for free space control structures
>   btrfs: remove start field from struct btrfs_free_space_ctl
>   btrfs: remove unit field from struct btrfs_free_space_ctl
>   btrfs: reduce size of struct btrfs_free_space_ctl
>   btrfs: remove op field from struct btrfs_free_space_ctl
>   btrfs: remove block group argument from copy_free_space_cache()
>   btrfs: remove unnecessary ctl argument from __btrfs_write_out_cache()
>   btrfs: remove unnecessary ctl argument from write_cache_extent_entries()

Reviewed-by: David Sterba <dsterba@suse.com>

We're planning to remove the free-space-cache in the future and
hopefully majority of users have been using the FST so I'm not sure the
optimizations will have much impact.
