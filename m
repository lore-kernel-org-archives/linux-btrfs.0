Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F85440A0A
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 09:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788775198; cv=none; b=XiJp+rWb1by2G5hj5RgQYCAdHe1sV0Xla8fs5vd4wii22YfJ1gCOL+4d21TeTjBWcyh3jMqK9TSfjI5PZvGhQBVh7WPosh0B3fKPWgNeiy3TFRcABhzZT3LXm7obi6yw2SaPiIDBmba70QMR2fL0vg/M8217v5JxnU6fJUOLoN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788775198; c=relaxed/simple;
	bh=Eg6cVCOGoyzyxjCgsqppamWAwCZw9IgKwyGycfmrFVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRe9YBnxMigTe20ZnNeia2bq9nrYKjXDXhUjWDA1aQTtm0b1FMhmy9ooM0HM+wIJASxLnMMNobnPPg+qTejrsi2b7YcQen8iXBkucAzjhnChUwNn0Ae2nx1eS50vURpczGA9FwBoOEWkYPZQL/AP+MVG9ctCix6UjipJlq0Suqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=em+ZKlAn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tQTLIzO/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=w89T24Cm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=va7yfkNV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="em+ZKlAn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tQTLIzO/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="w89T24Cm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="va7yfkNV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3386A219C9;
	Mon,  7 Sep 2026 09:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788775191;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoBCRCCUi/Pcr9oaUDmBrv0EOzkqni+kpCaw3AbaUNQ=;
	b=em+ZKlAnyYvW65P5O2EwSgTCBhldKO14s5St/APxNVTQkBjUGGpuPFJ4eQEGaIuZUs9V7o
	kT9YA56ZN+mkQT7rAstdS9LadtE7GdMdpur99bhDUaM3DN9iwuk8XAioeWpUElfMtTfPDy
	yaSJ/0bYiw4XExdzRmegar9+evk92r4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788775191;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoBCRCCUi/Pcr9oaUDmBrv0EOzkqni+kpCaw3AbaUNQ=;
	b=tQTLIzO/ssslfR1y96VoqwRgyK7FFbyhN/MVYiKtXnTMWyEYM60vKgQtrelOKZV3Rv5A1l
	+VjOyQSp4xXRZ2DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788775187;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoBCRCCUi/Pcr9oaUDmBrv0EOzkqni+kpCaw3AbaUNQ=;
	b=w89T24CmaWLvfOGgLu9WdnQ66tv+pWn3Z/x+1rCzlfB4q8IR1p4WmygBOlqv2CPStu/p2p
	KC8DyfJFPc/BkKbEEU3TYqTDyYXMuLU8hpMgzsEUt9FKQA/N2n8TkLCbiDKHr2X2mpVX7E
	lkVpZrPmvgZ5M39fHME/dUxs6ZbmZdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788775187;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoBCRCCUi/Pcr9oaUDmBrv0EOzkqni+kpCaw3AbaUNQ=;
	b=va7yfkNVCk39scTiY+flIg4TU51rp0wxawt/gE8pUtDi0gzx6AyUYI63KjtSD8uZb8u5DQ
	hMcs1pJcdPrFM9BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0548B1339B;
	Mon,  7 Sep 2026 09:59:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YGcUAROLnmq0GwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 07 Sep 2026 09:59:47 +0000
Date: Mon, 7 Sep 2026 11:59:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
	Daniel Vacek <neelx@suse.com>
Subject: Re: [PATCH] btrfs: move async csum generation out of experimental
 features
Message-ID: <20260907095945.GQ9053@suse.cz>
Reply-To: dsterba@suse.cz
References: <700ba6c46da86ace18a502b43c5e61d16a556060.1788424754.git.wqu@suse.com>
 <20260904170035.GN9053@twin.jikos.cz>
 <d79d06ab-721d-4fec-a2a3-823e9380c792@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d79d06ab-721d-4fec-a2a3-823e9380c792@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmx.com];
	FREEMAIL_ENVRCPT(0.00)[gmx.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Sat, Sep 05, 2026 at 07:51:42AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/9/5 02:30, David Sterba 写道:
> > On Thu, Sep 03, 2026 at 06:09:41PM +0930, Qu Wenruo wrote:
> >> @@ -4437,19 +4432,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
> >>   	 */
> >>   	btrfs_flush_workqueue(fs_info->delalloc_workers);
> >>   
> >> -	/*
> >> -	 * We can have ordered extents getting their last reference dropped from
> >> -	 * the fs_info->workers queue because for async writes for data bios we
> >> -	 * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
> >> -	 * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
> >> -	 * has an error, and that later function can do the final
> >> -	 * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
> >> -	 * which adds a delayed iput for the inode. So we must flush the queue
> >> -	 * so that we don't have delayed iputs after committing the current
> >> -	 * transaction below and stopping the cleaner and transaction kthreads.
> >> -	 */
> >> -	btrfs_flush_workqueue(fs_info->workers);
> > 
> > In the final fs closing sequence there's always some possible
> > interaction between the workers, but I don't think we need an explicit
> > flush anymore. The work offloaded to the system workers will be done
> > before we get here.
> 
> In fact, Daniel's commit ("btrfs: use bio::remaining for async 
> checksumming synchronization") changed the behavior back, and we may 
> need to be more cautious now.
> 
> Previously, the csum generation workload will never call endio in its 
> context, the only work it really bothers is just to wake the completion.
> 
> But now his commit changed to use bio_endio(), which means we can again 
> run the workload from csum generation workqueue.

Yeah, this kind of problems I'm expecting but haven't done a deeper
analysis to have concrete examples like that.

> In fact, I do not believe it's the proper timing to move async csum out 
> of experimental anymore, after his commit.
> 
> I'd prefer more the next merge window at least.

We can do that, the main part, otherwise any preparatory or cleanup work
can be done now, as usual.
