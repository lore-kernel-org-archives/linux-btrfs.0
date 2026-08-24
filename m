Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C9E44C66D;
	Mon, 24 Aug 2026 15:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787586469; cv=none; b=XwjBBxbSiPu5ni6QmORmNKyddclkbn64yYPoYm5GX5zIM8zQJ3VrUsT1XlQW9zt4skQpty/15IFlnAm0FWDr4OA7r7cZyZaL6uR0n2kclzffO5EERj/yuG55T+/VqJuEUHmyDl+hC+PSycxFNxlJ3lyx0lf1K0AMDgpMyxcSQ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787586469; c=relaxed/simple;
	bh=lexfaqeQqL83FnTzMN3wIln8coR5oTiA8AEdjbDHU68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Owbv/t417OVCTFbFVwbgSFxFev/duvkm19Y9Qq8hyq7AuEONjzhOdxdz8LloTuBxvN2cLOt79twOzb/ci1rBYLlGx2jTW5TGh014ZWx1juD68MrLcP2YT2iEx+dj1Kvnx0wqc8mTCIu3fnHrb9fAj17nN76YZ7IsckJB5sDw2/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EsAaQ1G0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HrbkNCOt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2a4wZN4R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bdpnhltj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EsAaQ1G0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HrbkNCOt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2a4wZN4R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bdpnhltj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E678D1F7A5;
	Mon, 24 Aug 2026 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787586460;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VoRMTnnVep4qsEUD57HgkNVHLjXhi8i3MvpW4vubbto=;
	b=EsAaQ1G0njND9KI058uJRrLl9c2Lk+g6uUqE8FJVupv6SZw/6yBEj5hjUhYAdPhqY+p9sI
	Yg38rpIg6vKse17ofYn5AiY0C5+4iJ+jMW5/ZwuDUhYBW8hAIPNqPVTHytdTr7Ez2F0cBa
	y5vkY+fPO5H7aj9DXDMHF0KoWkrmTNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787586460;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VoRMTnnVep4qsEUD57HgkNVHLjXhi8i3MvpW4vubbto=;
	b=HrbkNCOtvuGFjvTjDIsS5PfRA4qYLN/WmJOp7A5VnRx6GydyPOaORGl49ghRBMw36oqdQA
	Ho8KSi6dSdmJ/ABw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2a4wZN4R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Bdpnhltj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787586455;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VoRMTnnVep4qsEUD57HgkNVHLjXhi8i3MvpW4vubbto=;
	b=2a4wZN4RtCo3Ze4+b6WCb5Jytvb25qZ0+NcvIvJxnBwD1URPIAXC3Ysw66KyJd6cSVtwW1
	xxcgmRQTrF4fElZwHso7gGb2jJ2QfTOqT6xOqfQU1LPSkjL7SIzfDo9H0+yRn+OVIYPxEP
	Cl6LPDmt5Byw4Spdw7LE3Sram6H0DWA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787586455;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VoRMTnnVep4qsEUD57HgkNVHLjXhi8i3MvpW4vubbto=;
	b=Bdpnhltjj0BZTSXB7xa5rWzt2+1L/t9r2mHlF58DTm4tesWV3T1i1fX8lKnEOSLzm9wRqi
	XsRCKqiCDxnufmBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D089413335;
	Mon, 24 Aug 2026 15:47:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XiOyMpdnjGqWZAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 24 Aug 2026 15:47:35 +0000
Date: Mon, 24 Aug 2026 17:47:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update btrfs git tree entries
Message-ID: <20260824154730.GE9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260819102828.3220130-1-dsterba@suse.com>
 <CAHk-=whWQKHpgAWUm=REzpD=t2DWn2_WVNMDXAerh3J9N3fG1g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whWQKHpgAWUm=REzpD=t2DWn2_WVNMDXAerh3J9N3fG1g@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E678D1F7A5
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,suse.com:email,suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Sun, Aug 23, 2026 at 09:34:24AM -0700, Linus Torvalds wrote:
> On Wed, 19 Aug 2026 at 03:28, David Sterba <dsterba@suse.com> wrote:
> >
> > Add new entry pointing to the development branch so e.g. sashiko can
> > pick it as the baseline. The other entry is for linux-next and slightly
> > behind.
> 
> So I expected this to come in with the btrfs pull, but it didn't. So I
> applied it directly, which I assume you wanted.

Yes indeed, thanks.

> Just as a general workflow issue: I typically think that patches I see
> are sent out as a FYI kind of thing - particularly when they come from
> people who normally send me a git pull request.
> 
> So if you actually want expect me to apply said patch directly, please
> do say so explicitly, so that it doesn't end up being one of these
> "what was the expectation for this patch" issues...
> 
> As it is, I kind of have to guess from the context ("was I cc'd or the
> main recipient, did I get a pull request or not").

I should have mentioned it under the "--" marker, sorry. The reason was
the pull request was not ready at that time and guys were noticing too
many patches dropped by sashiko due to incorrect base.  Sending the git
URL/branch change to speed things up sounded like a good idea to me.
