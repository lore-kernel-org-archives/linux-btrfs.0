Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794587455;
	b=op1TQY2U7JzaNSa+RR4NJaK9WdhS04wlr0kFqs5vNn6mRUI1605TWK1m2q9jCLISABZd
	 vFpS8SZNMztVKC4H/B2cEXWAa+kh7H1lJacPDn05IqS02x2xHhhnJT6ajgM83W6GMC/qk
	 YE4f7mErTGQL9UxKwr9VLOyR0U/IlMthI4yIgdWybz/10KsYt5Ifk5AeSVyJj28bX8Jrc
	 5qSk/ycjIOLALwze2N4JfzqrtoJKUoL1PFnLePTl07xxoZZ20YYfQA/hfWxHS9Fv/7OdJ
	 aQslsAPIKkbb53POcmeeeQz/xDpmpBg/7zyMMgRJMDjejvHQIU/0nZcJsIzGkQ3FBqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794587455;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:User-Agent:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=SFq8ddNJzc006WJhU0yarY6wE/1nnfxn+pbXXQhjiVY=;
	b=uyxz2cWo6Vij9z1NXjeps1MMRhiPr93PF4WJqimXvgdfDzwiCNONQu8PtjqVss3zCVmD
	 KH/jTaItmj2hrIVv+r5ihKw/8WVAJa4I97jGlE3PSi9pCh11p1alumjdpBJ6Yh+WsuDbs
	 jzkgKeBiUCFvTfCmHEUK0ARKSAm4239zQT6HpBlSB7NcJJRkMNyiCBSqSSFldbTsKw8Hx
	 hzKIMiK0sWELUuOhq8nhOO2KyMA5QjO/+wF2o0JDrx47sXcHjmViSbucawEJtdhnVcYdE
	 XHVoqDoiP6j1gC+toaHDntBVVk6DLSNaNxhm7KWEADKn0oPikEf64b98frxS11u/mKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2lHI1mCM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NFY8lT4T;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=utyDHd+e;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="Fy7/yVF7";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA8A606A32D;
	Fri, 13 Nov 2026 16:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DA8A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2lHI1mCM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NFY8lT4T;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=utyDHd+e;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Fy7/yVF7
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5AC071F74C;
	Fri, 13 Nov 2026 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794587452;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFq8ddNJzc006WJhU0yarY6wE/1nnfxn+pbXXQhjiVY=;
	b=2lHI1mCMiKdtTNfiDYhbrcWS8MtNJOw10T+JuhPVk5dEHrd/qr3IxEpLsUT/yDbWe1Jcw/
	lmyyQAE0u3fTc8QUQeCZKKYZT6Rs3N8GiJHzY+5QtGjs6S8rpfoi45PeilfAF2JnFAvLmi
	fYyqMi2Dc98pvp7LNhIgAjo2NjqdAEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794587452;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFq8ddNJzc006WJhU0yarY6wE/1nnfxn+pbXXQhjiVY=;
	b=NFY8lT4TMS324TlTVzvC0XdyT2YZ+9rYr0sev27+R9Qrhpi26YJryCw7j7tjb35v+clNys
	unn2K/GuC3BpunCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794587451;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFq8ddNJzc006WJhU0yarY6wE/1nnfxn+pbXXQhjiVY=;
	b=utyDHd+elflaW8pX1u1nfL/l0o/6c6U0vfLc5XrUHqwBMZ/c3JfeEmP4/04tPGVJEUz8pu
	+7xpJ//2v5EAeYUjeLwup+jTdIpH+VKmvwC+38fH0CxQMBeA247HiQXZL1mGgjBK4LcyRf
	4hFNM3kMWg7LM4C34Q08vWmkP5usz/M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794587451;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SFq8ddNJzc006WJhU0yarY6wE/1nnfxn+pbXXQhjiVY=;
	b=Fy7/yVF76B1GwHUbGL3CvO22WfKSoXA6fxwJ8d3OYUW/Ef4aXV95LCWDM5R7hkICraKKw3
	7Yw9ffB99G0aSZBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1ECDC134F4;
	Fri, 13 Nov 2026 16:30:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E45zOjo792rddgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 13 Nov 2026 16:30:51 +0000
Date: Fri, 13 Nov 2026 17:30:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: reject refs=0 subvolume without DEAD in
 SUBVOL_SYNC_WAIT
Message-ID: <20261113163049.GA49432@suse.cz>
Reply-To: dsterba@suse.cz
References: <20261101062539.1744605-1-teel4res@gmail.com>
 <a92d223b-55fa-493e-821a-e5acc8afee08@suse.com>
 <b4962b1b-bc5e-4302-8456-73b9b8a6474b@suse.com>
 <20261109184712.GF4186782@twin.jikos.cz>
 <70aa1a4e-895b-416f-a3cb-195af489b55e@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70aa1a4e-895b-416f-a3cb-195af489b55e@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-13.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.com,kernel.org,vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto]
X-Spam-Score: -13.00
X-Spam-Level: 
X-Spam-Flag: NO

On Tue, Nov 10, 2026 at 07:00:34AM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/11/10 05:17, David Sterba 写道:
> > On Sun, Nov 01, 2026 at 05:48:21PM +1030, Qu Wenruo wrote:
> >> With that said, there are more problems with the ioctl.
> >>
> >> - No real user
> >>     No one is utilizing BTRFS_SUBVOL_SYNC* flags. Btrfs-progs itself
> >>     doesn't even bother it.
> >>
> >>     So all these fixes are very low priority, unless there are some wild
> >>     programs utilizing this.
> >>
> >>     But even btrfs-progs doesn't utilize them, the possibility are very
> >>     low.
> > 
> > Obviously the ioctl was added so progs 'subvol sync' can use it for
> > non-root users. I started working on it but there's a problem with the
> > behaviour change between the user types. Root has full access and
> > reports the progress while with this ioctl there were some problems I
> > don't remember. The ioctl was designed to emulate all modes that root
> > can do so it should be possible to get 1:1 output.
> 
> Are you still planning to implement the full root-less subvolume wait in 
> progs?

Yes, but I don't have an ETA.

> Or is this feature deprecated and we can eventually remove it to reduce 
> LLM bug reports?

I don't understand what would need to be deprecated, it's a new ioctl
missing the userspace counterpart to implement an unprivileged
functionality where it makes sense.
