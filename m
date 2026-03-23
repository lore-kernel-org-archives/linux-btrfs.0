Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2FA3D7D90
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 19:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774295070; cv=none; b=SP+kAHQZ7gL/2aGR2yDeKmpW4la5oqEoVKc1d5C/Z/MJKyoSB5bM2sEApcI1J9fOlxnIT5Ug8Bix50IxAHYvjUQJwYAPXDrUH+vWKJTjWnvWxtxWbu6R0R1Au3DldwcrXcPHVS+2SogReGFXvTlaMVqqCev/pzD6qBtO6MJxbdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774295070; c=relaxed/simple;
	bh=0cFNeClas5JHgxuvbz4eBSty0GiLYs9SklTIMS61rlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXrZBRqU0JymEFLgKKN5C1gFtfQMX6vIwXdv0ZEtgiG0KBq2Ok1MF/jaaxKQO6pHZ1AaPPL9XyEQIEbfcwytyA7HLkX7gKAG4RM6uKFgut1txYsPC45phjY5zfJlqXDQStitPoqrfdPCRDL2iJ6qzxaTY9RD5oeZ6fA4MrvayZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zCW/K/Qv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xrG610Qt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zCW/K/Qv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xrG610Qt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zCW/K/Qv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xrG610Qt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zCW/K/Qv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xrG610Qt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D03C05BDCC;
	Mon, 23 Mar 2026 19:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774295067;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=92iBbP0NR3h/T4hctwfwO//Djl0dcQ1W+jnyJg/PT3s=;
	b=zCW/K/QvHIXKx9xeqdYta0qsOj59jfAmFUBt20qfPTw0N+rv4j4BHBN1u+uPlusGw4lODV
	1Le9sF1cxmNQJtouh3x+wjVIqPN6LYYa7pQnOkCS6cuvrrD+pRMyWhRApNffqJwiEf9UWJ
	fPQbM+AfNvXvoxoc6gELkvtNmbcq0fY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774295067;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=92iBbP0NR3h/T4hctwfwO//Djl0dcQ1W+jnyJg/PT3s=;
	b=xrG610QtpSsSYuMaDmwTqPgnzE3BmsZyXUmZnKp8Gqw4tj/1lVpKPmt05uPZZcr4BKFMoB
	SAmoQGhJz7SxNoBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774295067;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=92iBbP0NR3h/T4hctwfwO//Djl0dcQ1W+jnyJg/PT3s=;
	b=zCW/K/QvHIXKx9xeqdYta0qsOj59jfAmFUBt20qfPTw0N+rv4j4BHBN1u+uPlusGw4lODV
	1Le9sF1cxmNQJtouh3x+wjVIqPN6LYYa7pQnOkCS6cuvrrD+pRMyWhRApNffqJwiEf9UWJ
	fPQbM+AfNvXvoxoc6gELkvtNmbcq0fY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774295067;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=92iBbP0NR3h/T4hctwfwO//Djl0dcQ1W+jnyJg/PT3s=;
	b=xrG610QtpSsSYuMaDmwTqPgnzE3BmsZyXUmZnKp8Gqw4tj/1lVpKPmt05uPZZcr4BKFMoB
	SAmoQGhJz7SxNoBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDAE843A44;
	Mon, 23 Mar 2026 19:44:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iFwrLhuYwWlPaAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 19:44:27 +0000
Date: Mon, 23 Mar 2026 20:44:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: check remap-tree flags in
 btrfs_check_chunk_valid()
Message-ID: <20260323194422.GT5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260323172729.152556-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323172729.152556-1-mark@harmstone.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[harmstone.com:email,suse.com:email,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto]
X-Spam-Flag: NO

On Mon, Mar 23, 2026 at 05:27:23PM +0000, Mark Harmstone wrote:
> Add a check to btrfs_check_chunk_valid() that the METADATA_REMAP and
> REMAPPED flags are only set if the REMAP_TREE incompat flag is also set.
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>

Reviewed-by: David Sterba <dsterba@suse.com>
