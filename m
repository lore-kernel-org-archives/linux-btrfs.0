Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794248205;
	b=aTJ/LpwcdFEbGYrcyIdLt8CD5u+GnJgf/NUYiDXaDSChW+OoNvaplA59TVGjYHvMFwQV
	 pgSX/hHRdSBl/0ch9QacqjB1nCXUQnAxpEPvHcBBVZ7hQJyNP2yoY6eQouT+sEEYfIYz6
	 OqH9L3EJnjjcly2tXfMUM7it4MwmEnq9BnCklO0lLFkactL+wg2RWi2Buyo15NLq0vpnw
	 lsrcRW2Skqn6Inb0Us7CgDDuLILrFU1rg1Xgr1MCDTCejHCegwUHyyhKjedbRFv5QYVwa
	 Vmjc2ay6ydcM3LJe/o+ANfNUV4bjtdx8rzkDmcj3DQ7lSJCYe1+T+JYIVbyzsKsZj+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794248205;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=HwJSxXJdrvN1QjCdMeDzHJsJHoIsw9iASVs7CCOIbc4=;
	b=Waa2Qlee3ofiH5LgTFp7sD+XGHH91Rw72eSApbK1IQAMhTH25Qn0iJqNJTZMJiE45BEq
	 lKEWyyYbCTBIDpTxsvmyM1YG2zQ7mvM+DV1mhJBfgCNIsWsBECdyGPtKmUqxJiUIPSXqg
	 3SzD8/cP+zpZ73U1xJ0Ct2hviIPAwvyqpR43jhL+pycIoKfGINBnw/3x+IqLDd3e0i6oh
	 GCcI3GNlEx22/IIKRuOnjOGL0GKHaMkafkekuc2sN2aPPPCmbZXg+szcj3ItSgdpEsv8C
	 jN2njLOoS2FdglnntCUBZ+dafNasF4AHg04XegbIMt7m32ryciLoRTswUlOvMqbF6lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=3B2lzBEt;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=y9sWCsIL;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="NlIbVV/a";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TyVw7qhd;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5852B606A326;
	Mon,  9 Nov 2026 18:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5852B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=3B2lzBEt;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=y9sWCsIL;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NlIbVV/a;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TyVw7qhd
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 06395220BC;
	Mon,  9 Nov 2026 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794248202;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwJSxXJdrvN1QjCdMeDzHJsJHoIsw9iASVs7CCOIbc4=;
	b=3B2lzBEtfxWa4On/eJaIrsC37NbKPW2fT6WkCQrXYyF5l4Qv/MI+/eNZ/PJWj1rFXjK5nT
	yBtsP4LawaLJW85j18DQ8dCtpDjOlkCv8ufh/wrlIOZPjDq/5vZVaGNTsb0UQVtiQXHGkC
	Axztq5W0rWJZzAo4gEh8SNYd7/rRdgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794248202;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwJSxXJdrvN1QjCdMeDzHJsJHoIsw9iASVs7CCOIbc4=;
	b=y9sWCsIL492ZByPiZla7bovZxO5GS/htk45tN0G9T/jb0cn+EBOq3reS0ZGcO0+9X8R/QE
	kARNc7PbFo7s3SDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NlIbVV/a";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TyVw7qhd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794248201;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwJSxXJdrvN1QjCdMeDzHJsJHoIsw9iASVs7CCOIbc4=;
	b=NlIbVV/a3apB6ADiiasMmf6Q5NNjHqIkypLsiMAt7sXuw3y6fCsywykUMjgjUWz5bZMIry
	6ffwDyHy1Ip/8Zrxe0DUpHX4ohMThM44KEL6x5OrKXFbCrFjY1OjVYu5JPvCofZ0LKSJo5
	9Frisz5KLIPxSepAk9CbJ0xy+x5n7ng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794248201;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HwJSxXJdrvN1QjCdMeDzHJsJHoIsw9iASVs7CCOIbc4=;
	b=TyVw7qhdEMTtx0FSAbWkwIQYAyxK27PSiTnUROj7y2B8TTsXxIZcvckq2KoMyBhNYIEsYv
	8kZYa+ovdtGyoPCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A200413319;
	Mon,  9 Nov 2026 18:16:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hlLSHAgO8mrtVgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 09 Nov 2026 18:16:40 +0000
Date: Mon, 9 Nov 2026 19:16:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>, Chuck Lever <cel@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] btrfs: fix FMODE_NOCMTIME handling in btrfs
Message-ID: <20261109181639.GD4186782@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
 <20261109161019.GC4186782@twin.jikos.cz>
 <ceec68acafcec5d598a47bac4e065e762641c25e.camel@kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ceec68acafcec5d598a47bac4e065e762641c25e.camel@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-13.21 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.21
X-Spam-Level: 
X-Rspamd-Queue-Id: 06395220BC

On Mon, Nov 09, 2026 at 11:48:12AM -0500, Jeff Layton wrote:
> On Mon, 2026-11-09 at 17:10 +0100, David Sterba wrote:
> > On Thu, Nov 05, 2026 at 03:07:41PM -0500, Jeff Layton wrote:
> > > I tested the delegated timestamp support in nfsd recently. That support
> > > relies heavily on FMODE_NOCMTIME, and I found several places where btrfs
> > > didn't handle that flag properly. This series seems to fix them for me.
> > > I tested mostly with the git regression testsuite, because it is very
> > > sensitive to subtle bugs in timestamp handling.
> > > 
> > > Please consider for v7.5.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > > Jeff Layton (4):
> > >       btrfs: honor FMODE_NOCMTIME in btrfs_write_check()
> > >       btrfs: honor FMODE_NOCMTIME when punching holes
> > >       btrfs: honor FMODE_NOCMTIME in fallocate
> > >       btrfs: honor FMODE_NOCMTIME when cloning
> > 
> > There's a comment from sashiko for patch 4 regarding the unconditional
> > i_version update but this is mentioned in patch 3 as intentional. I
> > can't tell if it's a problem, it seems more like a suggestion for
> > cleanup. I'll add the series to for-next, please check if the question
> > is valid. Thanks.
> 
> Thanks, I think the suggestion from sashiko is a false positive and we
> should just merge this set as-is. That said, the kernel _is_
> inconsistent in how it treats i_version under FMODE_NOCMTIME:
> 
> The generic VFS layer (so ext4, tmpfs, etc.) suppresses i_version
> updates when FMODE_NOCMTIME is set.
> 
> XFS keeps incrementing it. This is because i_version behavior is a bit
> different there (historical reasons). IIRC they more or less keep it in
> lockstep with the LSN.
> 
> btrfs is mixed -- the write path suppresses it (like the generic VFS
> does) but hole punching, fallocate, clone, etc. bump i_version anyway.
> This is probably accidental.
> 
> In practice, it's harmless for nfsd. While there is a delegation
> outstanding, it doesn't consult i_version anyway, and i_version is
> updated when the delegation is released.
> 
> It might be worth making this more consistent at some point just for
> neatness sake though, or in case we want to use i_version some other
> way. I'll think about it.

Thanks for the exmpalation, this seems nuanced enough for the AI review
to miss something.
