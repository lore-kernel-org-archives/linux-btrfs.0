Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1207420125F
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 02:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776134746; cv=none; b=DrqiAyMndHB14fD+CR3+d8qe733MLiB9U0NTruAQUAlMNOciD0RB6lF6dQZ7V7rr5dhoG2L2t78WEgUWxnHplpUwBfFSznA49UP6U8h0kgVbn15mHXLaUevgHYeLUA8x2UgDKhHyqNfA+QQuadLXRZF+gk5N2vjKGo5AWNr0iZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776134746; c=relaxed/simple;
	bh=2sszIlo6i9n5O7g5aZGL5P3UTcTyutgNumB6KRnmJS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8nglXOSjEGXVoHb3z7I9gbtXQmqqSqnbUeh58AxsSNEo3f2dBlkdqOUKtyZKPusopMHMSow6Uw5luwjOs4IMCFZDTfb1qbf29nQUoSwAfnw+U+FpNbl54ZLFtxzNGwRchII3fYEUlr3KN42bnr+vmXpXJlDkibXq9mrXhq1aII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Wk/mvkXB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+13XL6l+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Wk/mvkXB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+13XL6l+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Wk/mvkXB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+13XL6l+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Wk/mvkXB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+13XL6l+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 450815BDF9;
	Tue, 14 Apr 2026 02:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776134743;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kej4LVOBrlbxeDZrnYI8+j/J66lXlW2fq/t0IS29pSo=;
	b=Wk/mvkXBK3+iaOAkIFaqtvg2I+yw3RJTwMe5yH7VeAdl5z/ivFU/QQIJetY9w8X+k4/6my
	Gdwm3MGE+VpRw5FeobuY1s3jmuCmkLc1pY/Pd39ex83cWH2v/wYcp7WLwZkvYk1TR/YFIY
	PQGB1175is/f9Wayd2ksoa5dFqnDpaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776134743;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kej4LVOBrlbxeDZrnYI8+j/J66lXlW2fq/t0IS29pSo=;
	b=+13XL6l+OFWcifjUxnMCT7fvvygdgqVkFbLkZEJ0mzCNdDu0VLyKrYsGhPwLmbl3Hqfcmb
	ExPxiHUB+JWItpDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776134743;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kej4LVOBrlbxeDZrnYI8+j/J66lXlW2fq/t0IS29pSo=;
	b=Wk/mvkXBK3+iaOAkIFaqtvg2I+yw3RJTwMe5yH7VeAdl5z/ivFU/QQIJetY9w8X+k4/6my
	Gdwm3MGE+VpRw5FeobuY1s3jmuCmkLc1pY/Pd39ex83cWH2v/wYcp7WLwZkvYk1TR/YFIY
	PQGB1175is/f9Wayd2ksoa5dFqnDpaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776134743;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kej4LVOBrlbxeDZrnYI8+j/J66lXlW2fq/t0IS29pSo=;
	b=+13XL6l+OFWcifjUxnMCT7fvvygdgqVkFbLkZEJ0mzCNdDu0VLyKrYsGhPwLmbl3Hqfcmb
	ExPxiHUB+JWItpDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C5224B1FC;
	Tue, 14 Apr 2026 02:45:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id viikCleq3WmGRAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 14 Apr 2026 02:45:43 +0000
Date: Tue, 14 Apr 2026 04:45:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: enable shutdown ioctl for non-experimental builds
Message-ID: <20260414024541.GM12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <f818123ba52a15913ea862aba75eacdbf4c06aeb.1776133240.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f818123ba52a15913ea862aba75eacdbf4c06aeb.1776133240.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -8.00
X-Spam-Level: 
X-Spamd-Result: default: False [-8.00 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto]
X-Spam-Flag: NO

On Tue, Apr 14, 2026 at 11:51:15AM +0930, Qu Wenruo wrote:
> Although commit 304076527c38 ("btrfs: move shutdown and remove_bdev
> callbacks out of experimental features") tries to move both shutdown and
> remove_bdev out of experimental features, that commit has only addressed
> the super block operation callback, the ioctl one is left untouched.
> 
> Fix that missing aspect by also moving shutdown ioctl out of
> experimental features.
> 
> Since we're here, also add unknown flag detection to reject any
> unsupported shutdown flags.
> 
> Fixes: 304076527c38 ("btrfs: move shutdown and remove_bdev callbacks out of experimental features")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
