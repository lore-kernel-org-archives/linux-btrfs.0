Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D865355819;
	Mon,  7 Sep 2026 10:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778065; cv=none; b=FzIVGPJv/2DPGYGYm5x/tu/AyMsjblEXiNMaEkOotPucLKMhxfKtNQhhMFMz88MVBDsrydGqnzR+bNbgV+SWdgf4X0s7RAfQoQDAidz/Vef1p5DQEDzWdhluXhVMBTIBGwQvyzARiajl321Oez/gUIjzlmYGfAbhZ31Bz5kiO/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778065; c=relaxed/simple;
	bh=PVd4aOdn1eWZRW7b4udqu8g0xlHZoOEtI2q0HQbzi2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRUmY1P6ZycmEl0tiIfkfMOIu/b9iNCVE/XxxjJRU3L5nkKOzfuc3LB08ionDmZMZHJ50d4fZbU3zp7YgqbC7PNI6j+gYodTzvK+rGPYBDZcSb8Y02erJ+HEsv+EN3846E4SzOoVG7q0JviVP2W8zda4D353MNC12OXZXNRjwQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nED2/zbj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=f1z5Ufk5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LyUhgkZ/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=H/s59jte; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nED2/zbj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="f1z5Ufk5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LyUhgkZ/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="H/s59jte"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 36356219DC;
	Mon,  7 Sep 2026 10:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788778058;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h1d4rRqOvJBwSsnwp7+NEu7HPqgPge2Sx4rGHqc4AHA=;
	b=nED2/zbjv3j2I9nLXbaJCpsnxiRMVv/OYmrEC+ETeAojO64ti+Aou09/Z5mOyJHsGLZtK8
	GiGY0C0U61o3PF+Z2k0Fp1igfYzpeG57xjnh+KD4+oQjOHeIAfDIikWzUwj7nYRN9bRY2S
	SUGyV94FssnF9Viit60vh5O19DEsyTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788778058;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h1d4rRqOvJBwSsnwp7+NEu7HPqgPge2Sx4rGHqc4AHA=;
	b=f1z5Ufk5xh0+3NBVR06OPAPa+o7XcS8Tu39OFX4ypvQ8pfhCqp/zspkL0y3tNmT0qK4a1J
	baoWGMStnGewO9Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788778054;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h1d4rRqOvJBwSsnwp7+NEu7HPqgPge2Sx4rGHqc4AHA=;
	b=LyUhgkZ/GqI2RwI7CFeeSLytV7CpmnSzrEWEGfJzlYQB3fT+dZ2HxNyqCuVAYqPBlHsXcx
	I+gCQb+v8Wie38is8X/M7lACEu8F38GX5ci2VkQ2Ywo2aN4KbZbc8KGdzTLBJcl3nk6faQ
	q0n0uz/Lj+KI0PLiYO1l16D+p1BeHyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788778054;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h1d4rRqOvJBwSsnwp7+NEu7HPqgPge2Sx4rGHqc4AHA=;
	b=H/s59jtexGa9u+76I7kKL9b1cnVMQNRe/fOt5cUYfBPCE/R+/1qBZ96dwEk1CR/fSmHH2L
	owSsp4nX3UXzzaDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E8481339B;
	Mon,  7 Sep 2026 10:47:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CbpAkaWnmqvSQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 10:47:34 +0000
Date: Mon, 7 Sep 2026 12:47:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 0/4] btrfs: handle -ENOMEM errors in some synchronous
 dirops without aborting
Message-ID: <20260907104732.GS9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Tue, Aug 25, 2026 at 12:04:16PM -0400, Jeff Layton wrote:
> This version is almost exactly the same as v3, but I've dropped the two
> patches that change btrfs_insert_orphan_item() and
> btrfs_del_orphan_item() to use stack allocations. We have no known
> occurrences of those allocations failing, and I'm comfortable not
> solving that problem until we know that it is one.

Thanks.

> Jeff Layton (4):
>       btrfs: split btrfs_insert_delayed_dir_index() into prealloc and commit phases
>       btrfs: pre-allocate delayed dir index before btree modification
>       btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborting
>       btrfs: pre-allocate delayed dir index for non-overwrite rename

Added to for-next.
