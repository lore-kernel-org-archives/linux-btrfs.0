Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7CC2FF178
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Feb 2026 16:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770393622; cv=none; b=N3XHdCba1zEvPlQdkgzORlFayDSfsDVtKlG3xizU4fCMgO318nmuUXUREqYWIa/BM0t4aPAnbnwFemPR956BMIeRRqdaA3BvHjCzuqP9Roj5/WonVAg8p/v18swrgPZKOX/TATq3eHSTDE8iX58KzSylRajSz2XpPcKOrpSJjwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770393622; c=relaxed/simple;
	bh=rcxzcqAouXCG1ArqwW67/U0pigdeAS5kRKR5aH2BLc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3eujkrSICMorDvw7Mx3jxJcNbVZiFnSEZRvfgiZ9cKJo1ahEAiTppC0u5PFR4C07Mq3+5/dLFhnpHX66ESLx5gWSGwTib83BRiYCfPpihFkbuA9ObAXUvYuEbwenYjgnwwBwMYkNWS3GLUCEY9AefyKbwfBcgMWG5RYdwBhw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=e5IyKtc7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nvcp9gX+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=e5IyKtc7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nvcp9gX+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="e5IyKtc7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nvcp9gX+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="e5IyKtc7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nvcp9gX+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0967A3E6E1;
	Fri,  6 Feb 2026 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770393620;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h4ZOS76nVTJyE8LigoojRCT3Poo6wLDijFn9dj6mxYQ=;
	b=e5IyKtc7xaU1RCz+e7zu1gv8JUOlqsBZx36Cr8onYYnIWwa3mtmKD7luksdOPfhV+y9qvQ
	MPCd32jG8DeDBkXdHCjL0yMZomw2kto5cNLhwtbLWzIcdrYVKC3CJq5DufuwZ/JOJVnmtK
	67JrdvTloPH3yNFj2NIx42OnwlVF86k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770393620;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h4ZOS76nVTJyE8LigoojRCT3Poo6wLDijFn9dj6mxYQ=;
	b=nvcp9gX+2MRvlr/YhRldw2bWvGUqV0yXgZIBLxeo/gxp5BOfvWyoy3Cx/wR5pu+BnKOpdO
	H+MyF+sXFA39oUDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e5IyKtc7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nvcp9gX+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770393620;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h4ZOS76nVTJyE8LigoojRCT3Poo6wLDijFn9dj6mxYQ=;
	b=e5IyKtc7xaU1RCz+e7zu1gv8JUOlqsBZx36Cr8onYYnIWwa3mtmKD7luksdOPfhV+y9qvQ
	MPCd32jG8DeDBkXdHCjL0yMZomw2kto5cNLhwtbLWzIcdrYVKC3CJq5DufuwZ/JOJVnmtK
	67JrdvTloPH3yNFj2NIx42OnwlVF86k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770393620;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h4ZOS76nVTJyE8LigoojRCT3Poo6wLDijFn9dj6mxYQ=;
	b=nvcp9gX+2MRvlr/YhRldw2bWvGUqV0yXgZIBLxeo/gxp5BOfvWyoy3Cx/wR5pu+BnKOpdO
	H+MyF+sXFA39oUDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D70BA3EA63;
	Fri,  6 Feb 2026 16:00:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S71RNBMQhmnuDQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 06 Feb 2026 16:00:19 +0000
Date: Fri, 6 Feb 2026 17:00:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>
Subject: Re: [PATCH] btrfs: fix the folio leak on S390 hardware acceleration
Message-ID: <20260206160018.GY26902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <bcf36edfb7ac3caf3373174e741bb29c0feb268b.1768802004.git.wqu@suse.com>
 <1218d786-ad7a-4971-9cd5-273232f62d79@suse.com>
 <4055f852-0488-4ccf-abb5-bc5f8d2c9635@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4055f852-0488-4ccf-abb5-bc5f8d2c9635@linux.ibm.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 0967A3E6E1
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Thu, Feb 05, 2026 at 11:54:21PM +0100, Mikhail Zaslonko wrote:
> Hello Qu,
> 
> Sorry for the late response. 
> I ran some test on s390 including folio-leak verification. LGTM.
> 
> Tested-by:   Mikhail Zaslonko <zaslonko@linux.ibm.com>

Thanks for testing, the patch has been merged to 6.19.
