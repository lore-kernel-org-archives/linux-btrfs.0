Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F85D14D719
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 01:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776390679; cv=none; b=jkPNnMLBIq6yLh3LN0ZxD8cd/oeMOczjkjxGsHfYaHUEG2kEovib3SwncYUnFpC9htPT53jTD0u87fakxmpxpesww1MOBRZrbo05g05nTEXTLkWLxXpdZQvZUyrut5aeeUuin9G42/m8szDrZed2pMk/DpWCo2gtT1vs0r2C7t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776390679; c=relaxed/simple;
	bh=kKnCIxx43Vf2/z63NKeoD9/LdeSUq4TffhcqMTtkNb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsr7zu860HQOKbgKdE+GF/PGxe0SzmwmR/XTTykNzxeUKpnlUfd4rOjs1luMijHhnF6fzA97RnbWhaJkuOj/mrIY/Yo9CtLDCgcF+mzW0CZs0GSzw7+EEqoOQC63Q17LI9igqLqTNuDJH/sR3PaE84nPOOttzbnuyiHHQM5dOLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RkTvZXnH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OEICcA6t; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RkTvZXnH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OEICcA6t; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RkTvZXnH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OEICcA6t";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RkTvZXnH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OEICcA6t"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 92FB95BCF4;
	Fri, 17 Apr 2026 01:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776390676;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=059T/MSH5qN9PqS5Gt64vKbtz8Go7jGd89JTpxiNt5k=;
	b=RkTvZXnHjALU+1z8QKKTCZlLeuowp0FKZG3GkcASgZyF14aWzBG4YtazT+UI+yFy0CT1An
	4mfeZZMmgoh9GvKumX4/WASoT/jP988sBGjY8Oc6p2U40nzqgeiqhRayDwBJ7ta5U+SXj1
	l6z6Smi9Wp2qEA2u6xhTLEzsK3zAJs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776390676;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=059T/MSH5qN9PqS5Gt64vKbtz8Go7jGd89JTpxiNt5k=;
	b=OEICcA6t3eTi4rf4cdHcNvd1rd0mtDItuouD910jOFWSELV32cU1CuudGsVn3xOe+hrGop
	WSVZp0GvSeYOD7BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776390676;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=059T/MSH5qN9PqS5Gt64vKbtz8Go7jGd89JTpxiNt5k=;
	b=RkTvZXnHjALU+1z8QKKTCZlLeuowp0FKZG3GkcASgZyF14aWzBG4YtazT+UI+yFy0CT1An
	4mfeZZMmgoh9GvKumX4/WASoT/jP988sBGjY8Oc6p2U40nzqgeiqhRayDwBJ7ta5U+SXj1
	l6z6Smi9Wp2qEA2u6xhTLEzsK3zAJs8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776390676;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=059T/MSH5qN9PqS5Gt64vKbtz8Go7jGd89JTpxiNt5k=;
	b=OEICcA6t3eTi4rf4cdHcNvd1rd0mtDItuouD910jOFWSELV32cU1CuudGsVn3xOe+hrGop
	WSVZp0GvSeYOD7BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7391D593AE;
	Fri, 17 Apr 2026 01:51:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3CSYGxSS4WnzQQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 17 Apr 2026 01:51:16 +0000
Date: Fri, 17 Apr 2026 03:51:11 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 01/10] btrfs: use a kmem_cache for block groups
Message-ID: <20260417015111.GU12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1776278490.git.fdmanana@suse.com>
 <ccd87d11a25c4fc5c4a52869fd57994a96029307.1776278490.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccd87d11a25c4fc5c4a52869fd57994a96029307.1776278490.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	URIBL_BLOCKED(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Apr 15, 2026 at 07:44:39PM +0100, fdmanana@kernel.org wrote:
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -22,6 +22,23 @@
>  #include "accessors.h"
>  #include "extent-tree.h"
>  
> +static struct kmem_cache *block_group_cache;
> +
> +int __init btrfs_init_block_group(void)
> +{
> +	block_group_cache = kmem_cache_create("btrfs_block_group",
> +					      sizeof(struct btrfs_block_group),

In case the structure and cache name match you can use KMEM_CACHE.

> +					      0, 0, NULL);
> +	if (!block_group_cache)
> +		return -ENOMEM;
> +	return 0;
> +}
