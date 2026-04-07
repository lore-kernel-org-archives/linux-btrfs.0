Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B121257F
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 22:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775601631; cv=none; b=Owvs5+wZaezl12BOMFSCFrwndgJ2MWC1HZNCVSz1uQUvvvvClcs/DisRBsCu/WxMAm81Um2pateaVL/wPjNKusDc+Npaomc+nRtC6CGzu9AVymgm9NJaCgbO+L2wrf5Cho88XyGEG2rDQhOXAujb4z3tC2hMOSZNYhGvj6iGQ6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775601631; c=relaxed/simple;
	bh=LWaT66DG6Xpp/XbkOCKrUlA9okBwXse/AbsL5bZ0EMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTbT6gaNhHXofmRbq42sXeMDEVVnVSO3rsVDz46V+9bbZcfnDQLpR3EfMjP3gG9iA+b9IOsKbAUaoG865uPEIsWPNfp/19aFr4hP/T7CUgnXi5Pvla/g9rgroAhaOmxxX9XUGmwA+bK0dZp3fgu999kAsHFp82t7MUeDzpRjvQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nuyF6k10; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rLQGWuJx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nuyF6k10; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rLQGWuJx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nuyF6k10";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rLQGWuJx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nuyF6k10";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rLQGWuJx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B28A95BD54;
	Tue,  7 Apr 2026 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775601628;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7I79eoXPQ01cfv/+OvM+q6EamapMczjWTdXaxcHCcG8=;
	b=nuyF6k10CJ7EwfjjFCRCW9t0n2IqOeQqVFfG1hOBf+6mNWZZvq+vuz5xyjCa4T3Rks88nq
	XDghYQA/6or7ixp+8XOpHz8vCYX59y1QbcOyJ582FVTmsDpll9w6owGUU1K8ceesWqckud
	yR87eP2Ql02TpICln5TZJIO2lSKYYrc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775601628;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7I79eoXPQ01cfv/+OvM+q6EamapMczjWTdXaxcHCcG8=;
	b=rLQGWuJxcP4sVFyKTppoaILqxkFvYlSpGXrLcqyUnPFuWqfF9NkABNtyk9UdC6kvFvNAlp
	+U1OZMeqCpETwfDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775601628;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7I79eoXPQ01cfv/+OvM+q6EamapMczjWTdXaxcHCcG8=;
	b=nuyF6k10CJ7EwfjjFCRCW9t0n2IqOeQqVFfG1hOBf+6mNWZZvq+vuz5xyjCa4T3Rks88nq
	XDghYQA/6or7ixp+8XOpHz8vCYX59y1QbcOyJ582FVTmsDpll9w6owGUU1K8ceesWqckud
	yR87eP2Ql02TpICln5TZJIO2lSKYYrc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775601628;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7I79eoXPQ01cfv/+OvM+q6EamapMczjWTdXaxcHCcG8=;
	b=rLQGWuJxcP4sVFyKTppoaILqxkFvYlSpGXrLcqyUnPFuWqfF9NkABNtyk9UdC6kvFvNAlp
	+U1OZMeqCpETwfDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96FDB4A0B0;
	Tue,  7 Apr 2026 22:40:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lfGYJNyH1Wl4egAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 07 Apr 2026 22:40:28 +0000
Date: Wed, 8 Apr 2026 00:40:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make more ASSERTs verbose, part 3
Message-ID: <20260407224019.GO5735@suse.cz>
Reply-To: dsterba@suse.cz
References: <20260331223659.2098718-1-dsterba@suse.com>
 <CAL3q7H7CVWM_WSafttqhn8x-q3iUFxOGaipZExuchZH73SP9Fg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7CVWM_WSafttqhn8x-q3iUFxOGaipZExuchZH73SP9Fg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.991];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO

On Wed, Apr 01, 2026 at 03:24:39PM +0100, Filipe Manana wrote:
> > @@ -2335,7 +2338,8 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
> >                             btrfs_item_ptr_offset(leaf, slot),
> >                             sizeof(struct btrfs_file_extent_item));
> >         extent = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
> > -       ASSERT(btrfs_file_extent_type(leaf, extent) != BTRFS_FILE_EXTENT_INLINE);
> > +       ASSERT(btrfs_file_extent_type(leaf, extent) != BTRFS_FILE_EXTENT_INLINE,
> > +              "file_extent_type=%u", btrfs_file_extent_type(leaf, extent));
> 
> There's no point printing the file extent type here, if the assertion
> fails it's because it's an inline extent. This would only be useful if
> we were asserting it's inline, not that it's not inline.

Right, I was skipping the pattern where it was clear why the assertion
failed but missed that one.
