Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE67650276
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779620859; cv=none; b=EeOtIYCohCiU0e+LiWa7VA2aZtsotef9hreGqBhu/ZCVFfEp4VKwFDIZTnCQZBGAS1ovFedgQPDlci3J66YcX+HFtZhUXv/WGqiTCRHBQLyjj5kZHCNRnSzDTnPk+/URpPHIYAK7gYLLbfSEv/1jWEPs9CZfhrdPXW816w/zVcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779620859; c=relaxed/simple;
	bh=iwsnyY1pWmXT4J0629aHUf0c+4rvvNkU/OGiSLoJ5hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X20Zh3zUWQjbzI9OWZsJkBGy666d6u7v7C69nHk80JhXlMH7jHfKtto3XS0bQjGRFd7EPeCqtUlaN5KemLRt0wIOYyHrZzMWZBCiRRNa/6acVDCKIHAG0JBfw4WbUnhN2RKsVWrSJr1FoU1IgHAH0yVuzxCiX/lCGO01G84L3ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iKCrmoQ+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2FypIxTe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iKCrmoQ+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2FypIxTe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iKCrmoQ+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2FypIxTe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iKCrmoQ+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2FypIxTe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C52C68212;
	Sun, 24 May 2026 11:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779620856;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hi3VldtmQ+CntJ2P0TnAohL32r8wQfVq7jrnYhIqX5s=;
	b=iKCrmoQ+OCFBZaogIrM+IBGtcRAsmPPYsITNIQaoL8WteeDGGfxkpgn1qQFt8ndaxvxeXT
	zoy5xxX3Rr4jyfH4vPJlBi/X3Sy+dHCzalWydYy+TozYDc/KpG3Y7BKQp85AbWf95N7OKO
	RFdGVquY8IVG64KJ2yk4DGS205gLGTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779620856;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hi3VldtmQ+CntJ2P0TnAohL32r8wQfVq7jrnYhIqX5s=;
	b=2FypIxTe5G35uUTTuS5UtKZ6LUl5BtGevzT+4Dtds8WlLAfi6xReMdit4grEtCNoXnIdLx
	V+Jlvf3jGb6jUFCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779620856;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hi3VldtmQ+CntJ2P0TnAohL32r8wQfVq7jrnYhIqX5s=;
	b=iKCrmoQ+OCFBZaogIrM+IBGtcRAsmPPYsITNIQaoL8WteeDGGfxkpgn1qQFt8ndaxvxeXT
	zoy5xxX3Rr4jyfH4vPJlBi/X3Sy+dHCzalWydYy+TozYDc/KpG3Y7BKQp85AbWf95N7OKO
	RFdGVquY8IVG64KJ2yk4DGS205gLGTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779620856;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hi3VldtmQ+CntJ2P0TnAohL32r8wQfVq7jrnYhIqX5s=;
	b=2FypIxTe5G35uUTTuS5UtKZ6LUl5BtGevzT+4Dtds8WlLAfi6xReMdit4grEtCNoXnIdLx
	V+Jlvf3jGb6jUFCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A60359651;
	Sun, 24 May 2026 11:07:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x3mSDfjbEmpJKQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sun, 24 May 2026 11:07:36 +0000
Date: Sun, 24 May 2026 13:07:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 19/28] btrfs: tracepoints: add trace event for
 add_conflicting_inode()
Message-ID: <20260524110730.GL183694@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778776706.git.fdmanana@suse.com>
 <238c79ed66ab85e05394448aeddf91899839ca22.1778776707.git.fdmanana@suse.com>
 <20260523175114.GK183694@twin.jikos.cz>
 <CAL3q7H7g4JCCw=n0DDq-tRNiBuiOAO=Pc4SZxQZyoemOMV26Yg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7g4JCCw=n0DDq-tRNiBuiOAO=Pc4SZxQZyoemOMV26Yg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Sat, May 23, 2026 at 06:57:32PM +0100, Filipe Manana wrote:
> On Sat, May 23, 2026 at 6:51 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Fri, May 15, 2026 at 06:00:16PM +0100, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > > +     TP_fast_assign(
> > > +             TP_fast_assign_fsid(trans->fs_info);
> > > +             __entry->root_objectid          = btrfs_root_id(ctx->inode->root);
> > > +             __entry->transid                = trans->transid;
> > > +             __entry->ctx_ino                = btrfs_ino(ctx->inode);
> > > +             __entry->conflict_ino           = ino;
> > > +             __entry->conflict_ino_parent    = parent;
> > > +     ),
> > > +
> > > +     TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_ino=%llu conflic_ino=%llu"
> >                                                                  ^^^^^^^^^^^
> >
> > This looks like a typo, "conflict_ino" as the variable names.
> >
> > > +                     " conflict_ino_parent=%llu",
> > > +                     show_root_type(__entry->root_objectid), __entry->transid,
> > > +                     __entry->ctx_ino, __entry->conflict_ino,
> > > +                     __entry->conflict_ino_parent)
> > > +);
> > > +
> > > +TRACE_EVENT(btrfs_add_conflicting_inode_exit,
> > ...
> > > +     TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_ino=%llu conflic_ino=%llu"
> >
> > And here.
> >
> > Otherwise no other typos spotted in the whole series and the formats
> > look consistent. I'll fix the two in for-next. Thanks.
> 
> No it's not a typo. It's intentional to call it conflict_ino - as ino

conflic_ino ... with missing 't', or did you reall mean to write 'conflic'?
