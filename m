Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0B43290B0
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 19:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998017; cv=none; b=EiJNxaYa+Nnsa+UqEpilzuFLx6nAl1xMjOK0TNnDO2F/oUIf0sGYCleHVhbFSYgN45MkHkHWJo/O8S4zT/Heiiemc3tFm2i/MFIbF/JV6vDVBvRFc+rxf0Hb9/GvQGkvzYVUv2svc0uYUMQBhLY/n6BAN9ujn2luXxr5VR8HNOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998017; c=relaxed/simple;
	bh=P+ByYNckpT1t/67Kr0AgEkwaNN+WkxiMGbIBfun1Q5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJ4BXABSB8KKDHH8ltJVDf8kNNTBS25qKmIHA4v1EnPVSGnU8urovUntrNfOdvcglm+DyJGapUzRGn3oD+6IAPgREChYttu+hhmwIb/4XKyTP2xAN8PCwBGHlLD30Q14rq3VHv+LjtM2A8wzVvDVWaQ6cfz9pHxejUJMJ+ILV2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Or8SwKXO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=sltjmsTq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zubfS0/w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rsz9m0+l; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Or8SwKXO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="sltjmsTq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zubfS0/w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rsz9m0+l"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2233A6AD8F;
	Thu, 28 May 2026 19:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779998014;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5rqmPKpJfakfPeye35L/XLU2gEfjGhjdOVp0GQrAt1s=;
	b=Or8SwKXO8IacUsaGvCFpqfNtFVhfmLqJ8rn1WsJHn+3z3gSZo6YTpJJMQUi8gwfOkSaz8m
	56H2bwKBuCgYWzQAVpOqMBXvnCKW/DRuShi8X0vVoqezgpy60KBtey4+nBX20QLGe/E+nK
	E+kR8fz68pAs3M4gWmq1uTlvJdEZocM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779998014;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5rqmPKpJfakfPeye35L/XLU2gEfjGhjdOVp0GQrAt1s=;
	b=sltjmsTqg3r5MLG+6yeePAQ67OCoS8aZN418/ZcHmfUNpElki7QtYJMnrWpmpPnT7huRr9
	PYNreM+JWOVKOZBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779998013;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5rqmPKpJfakfPeye35L/XLU2gEfjGhjdOVp0GQrAt1s=;
	b=zubfS0/wIewkti+HH1L9BLBsvs5YadMiztNUi5/Jefl+XRpHVFPjNsEpSlFXn6Guaplzkc
	RzuwmGKX6xkd+a+DJb0yqrFw/hA0BqXhxrvV/HNzRZtGbrNwc8grGxetdZDqDpemCYmeyH
	5lMoX4REEhUaZnPNVYhnGudZXdE9vIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779998013;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5rqmPKpJfakfPeye35L/XLU2gEfjGhjdOVp0GQrAt1s=;
	b=Rsz9m0+lF2YmFaLXtCyk2x5Rh7W570Q55k34bXBYd9P5TxYdYbgcYLakpbH9gZzxfuczLK
	ZQlxSnZotVJRBkBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1740D5AF68;
	Thu, 28 May 2026 19:53:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AtduBT2dGGrUQQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 28 May 2026 19:53:33 +0000
Date: Thu, 28 May 2026 21:53:31 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: switch local indicator variables to bools
Message-ID: <20260528195331.GD880787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260526113321.127533-1-dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526113321.127533-1-dsterba@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]

On Tue, May 26, 2026 at 01:33:21PM +0200, David Sterba wrote:
> @@ -2395,7 +2395,7 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
>  					ret = 0;
>  
>  				if (ret) {
> -					done = 1;
> +					done = false;

Will be fixed in for-next.

>  					break;
>  				}
>  				continue;
