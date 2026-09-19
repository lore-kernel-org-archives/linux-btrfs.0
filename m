Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A25B381EAD;
	Sat, 19 Sep 2026 20:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789850795; cv=none; b=LO9XTcv1OMDu2QLP//zUNBVd6chhRIlMEuJnqcToirECX0zxodBzP0xPvl6sNRoZA9gt9V7SMv9af7ttMycopbMbJ3cyELJPPQgUkPiJmeEvPSzFbjK9/j0o7bBOta/60aEdN8R/B1Hw3okiguRCwJWhWTKpz4/C/KEOjRYUeqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789850795; c=relaxed/simple;
	bh=nlJiER+kDXS3d2daiPSvVpFIPEQ+6sw6rHJaRPpLD6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QbZedXHO2Lj5y4N3TDw4EHHSceJOZRaQ0SyEqHxkYIb1eniBHx1TlJbhPj6/i0v9x8qd1yj6fOI55I4aNDliDgg3FC1IklrBfU3Qvx34UVjcHo+AEI4ZwRokp/j1LDwwFL7mElb/HF8QDU/zogpfosjVwVKBavKQZ9npL0nLjDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F19q3Kq6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3htMDqVN; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UiApHGCb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KKCvQmaH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F19q3Kq6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3htMDqVN";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UiApHGCb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KKCvQmaH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6B85221D72;
	Sat, 19 Sep 2026 20:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789850784;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJMe82CQ3Djnx2A8rPKycYLGgzecxoVzpCYmqYJA/Gk=;
	b=F19q3Kq61Uc2yaXnjoEtjooK49h5azwAWOVghKOIZiI4TFYEJhTlmHMikmMM6c7FU/MLid
	EUW1/AD/kftYRr+TuLFQhR241dxbSB0HJ7DloCn5TbbGBfLjjEC/UrnHqcFVWl0XSIvBiC
	YpcRzMv//MlXRba6y3vttkCRQygMarI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789850784;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJMe82CQ3Djnx2A8rPKycYLGgzecxoVzpCYmqYJA/Gk=;
	b=3htMDqVNwXfBqjZJD7Lzxz2hhQv/IuauJ+9YqkspWgEuy4UnfjEcIquxF1U6wOiRDVieaS
	70Vvv6tKuJPT6QDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UiApHGCb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KKCvQmaH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789850780;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJMe82CQ3Djnx2A8rPKycYLGgzecxoVzpCYmqYJA/Gk=;
	b=UiApHGCbDA7I98fMcOJAhQgxcrWYKpXo2jgP4ns6A8DzAfHgULruzAJPqW8CTw9woHsNqc
	GUH1ceGHSS0++w6VZcInWlZLI/7Ukznln1Gly1rtAQbKrbvI9HJ1PB5lkkNuNudiQdQetw
	+UzNSRYZ9whvMHDJEtywg1FOCqaITQA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789850780;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJMe82CQ3Djnx2A8rPKycYLGgzecxoVzpCYmqYJA/Gk=;
	b=KKCvQmaHHoHm7v+Nw0pNd5NOvzSQmggDDPpl3W0cT7oUttCmabSohbvilq5ucCcBwAG33U
	+bEiZKHi93jiYBDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3EB8D13331;
	Sat, 19 Sep 2026 20:46:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3ljlBpz0rmoSPQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 19 Sep 2026 20:46:20 +0000
Date: Sat, 19 Sep 2026 22:46:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs fixes for 7.3-rc4
Message-ID: <20260919204614.GY54722@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1789845496.git.dsterba@suse.com>
 <CAHk-=wjwehxF3wP-vj23RXYH8RmK-Crmnq0g2wr6wNDet87S6g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjwehxF3wP-vj23RXYH8RmK-Crmnq0g2wr6wNDet87S6g@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.21
X-Rspamd-Queue-Id: 6B85221D72
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,suse.cz:replyto,suse.cz:mid]
X-Spam-Flag: NO

On Sat, Sep 19, 2026 at 12:53:08PM -0700, Linus Torvalds wrote:
> On Sat, 19 Sept 2026 at 12:44, David Sterba <dsterba@suse.com> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc3-tag
> 
> -ENOSUCHTAG.
> 
> I see a 'for-7.3-rc3' branch that has that top commit in it, but no
> signed tags. Forgot to push?

Yes, sorry, now pushed.
