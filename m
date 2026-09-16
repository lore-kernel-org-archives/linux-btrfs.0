Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3280B4EC670
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 13:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789563970; cv=none; b=QOP8SKnVDfTy2sakCSRoMI8MVWgkJrQTTNVnAvAeExKGxyHnvqMgLfd0PxV3vGpwYFqSk9TCpHe0mGCPCXzxoO/NaEhEqEOTAHmxfxyX1bd02IylOiELWO/JBIYeYe7QO8iuCl8shgu1yH9I8tR5TG3bUUjF8m6Z+QIZbExVqxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789563970; c=relaxed/simple;
	bh=Jw1lH1XRsFL/eZ0mnUKwE3Cp6bKqErZ39gJNW0y5nhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbAmRM527OBF0Y3J1qXaPmNRc1t09/d5JQrbEMza831CkPlaAKr7plm7bkE2ZEWZJTUXG8wNhqyv0EwygD+ZCoFZjiDusDKGJVhA/8R+SC4Qy9evsbGIY85AI/sTvWG9ZCRuzSP5/tfu0YNusvWv1NXZr8A29BwuyzCMgvFgmoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WWLPB0+1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=65MkSheL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=do2WTvzQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zfUzwZC5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WWLPB0+1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="65MkSheL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="do2WTvzQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zfUzwZC5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B59D721A2B;
	Wed, 16 Sep 2026 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789563962;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2w4lbhBJfJtIDX0p/jiED3IUpfW1ntqn0mQvGKHZ3tc=;
	b=WWLPB0+1p8o5ERGazth8uP38cj0psAmHJpE76M9oG3EuqsZQANfm976EgxQ0qWATG5plkD
	3jRqTMFgIFaWL/T+XZpV4uLN5qGrHU4VP4226i/eVfCbBSOyMFQS4w+TjRbls7aUY3t0fv
	s9K1fpl0SYH+qTW/sdzc7z7Z1jtkchg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789563962;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2w4lbhBJfJtIDX0p/jiED3IUpfW1ntqn0mQvGKHZ3tc=;
	b=65MkSheLcjePa/DFfaWPh1ojntrR5kmiMw5hOgLZZ69Eg6Eji09YctXpd81kCrkheswszj
	78eKhNK9We7Nh7DA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=do2WTvzQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zfUzwZC5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789563958;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2w4lbhBJfJtIDX0p/jiED3IUpfW1ntqn0mQvGKHZ3tc=;
	b=do2WTvzQrYn0wsx1VsbF99zFpUo6JH8bTj0h4w+LdSEdw/H6V8xlAys+w26Jem0Wqqstv/
	5iO2HNR1zUfOGcPJ+G9BRMQx0ci5pLoA4lXLzuKlYWBxqr19lh3fyVsRFGwsX7G5nB80cz
	Su4sTojclOYuLZKhdYtdgrMoq7bA7Jk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789563958;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2w4lbhBJfJtIDX0p/jiED3IUpfW1ntqn0mQvGKHZ3tc=;
	b=zfUzwZC5aUD8fr2FCgC4J20wWJp6owaaBXlXm8oWzpJOXNiIfg1ZV54FEL1hIUJ5NDUrR8
	K6tONWuCi1n5rYBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7BC2E136D1;
	Wed, 16 Sep 2026 13:05:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OtOZFTaUqmrWBgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 16 Sep 2026 13:05:58 +0000
Date: Wed, 16 Sep 2026 15:05:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: cleanup submit_extent_folio()
Message-ID: <20260916130549.GU54722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <ce764b1e763090b6d8983a06bb57ef08f74b1206.1789298944.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce764b1e763090b6d8983a06bb57ef08f74b1206.1789298944.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: B59D721A2B
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO

On Sun, Sep 13, 2026 at 08:59:15PM +0930, Qu Wenruo wrote:
> Cleanup submit_extent_folio() by:
> 
> - Remove @size parameter
>   Since commit b2e743927fdd ("btrfs: make btrfs_do_readpage() to do
>   block-by-block read"), all callers are passing sectorsize as @size,
>   so there is no need for such parameter.
> 
>   Furthermore since we only write one block at a time, there is no need
>   for a while() loop, nor the advance of various local variables.
> 
> - Update the comments on the parameter list
>   * @disk_bytenr is shared for both read and write
>   * rename @page to @folio
> 
> - Update the return value to return 0 or error
>   Since we won't queue multiple blocks anyway, there is no point in
>   returning the queued bytes.
>   It makes more sense to return an error code, although the only error
>   code will be -EUCLEAN for writes.
> 
> - Rename submit_extent_folio() to submit_one_block()
> 
> - Rename submit_one_sector() to submit_write_sector()
> 
> - Update the error message to utilize the new returned error code inside
>   submit_write_sector()
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This is a wide cleanup and as it stands is probably fine, for clarity
I'd also update the subject to say it's being renamed. I want to avoid
giving examples of subjects wich are too general, we do a good job in
that respect, I tried to look up similar one and it's from a long time
ago.
