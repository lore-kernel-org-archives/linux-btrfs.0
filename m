Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211212F872
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 12:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779710562; cv=none; b=tLbre6zCboLGx6QmZcBd3y/HXSvo5M3htSd6Lm4TXAb2DHIXoW5tNqrFtgAvtx2A8ncy+Sg5b6ytxLuFsdDL/y7PUvosWAECUlTM1NHHafvg1pdDnNHWsd0TsX4LG4nnXnIeU2jZsJLPI8qleZMSM70+gsyC6cyn7BSlJaTXTIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779710562; c=relaxed/simple;
	bh=HergUjqBYhJWAQjPhl62uF5yJWfFu44mrHVwsp6e7DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kr4XCUW4JDrJMPb6So3IHbAsy8jczfz5sDREzSX60pVnCrVWukQf/ktVpcBpAf9yr0hI7za6azHdToRB41xtS9okP+N/NUjpZQTi+qwDehMgD2NA9Qg/MLCHa2aw0QhEla7Ve6htlk6BudObm7D9v9bEQdhQ+ltJipqcXXYdlgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Zn1uFk21; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=M0CID3v4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PKl0ZVBZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9rQLpEHD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Zn1uFk21";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="M0CID3v4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PKl0ZVBZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9rQLpEHD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 429546B6BF;
	Mon, 25 May 2026 12:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779710559;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bj7hKbUPvAjjuVzOijnKSyTmUqMc1tIEuPcJtft1ZJI=;
	b=Zn1uFk212zMGZtSpIEh4lND+GUwGLWdy1pUwH0vm2sTH19oRLUMekp49ufrPFnZloVGi0w
	jCOcyb0xlD4XSYF8LxDSQOklGO1JKOv5vJu6tM7iZlK8ZdB8VzioiKmMCQ4qUxsAk1iBlx
	meWsML29BcBF/dqYBUycYyjuVKc/Efw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779710559;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bj7hKbUPvAjjuVzOijnKSyTmUqMc1tIEuPcJtft1ZJI=;
	b=M0CID3v48O04Nsym44OIj2ZXlYlTt989uQ8csUc4vwyR8teY+8qBifGXTyO/h44AQWdYYa
	PpeW/YiIwUuCfaDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779710558;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bj7hKbUPvAjjuVzOijnKSyTmUqMc1tIEuPcJtft1ZJI=;
	b=PKl0ZVBZttZhfa8lc86YILf/JfMg2Kb/+7GoRNpdum/nTFeajUdo6g0pOgW/9taH3VlEb1
	/Nn4GWFOoRJr2IarqyRQ+SpFMRzTn80PnbsPSJwd6QahwOAhcybY7tMyg6nFyEXypUsAi2
	lSb0bKM5OAXz4VLbQqMsWQyP734vf20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779710558;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bj7hKbUPvAjjuVzOijnKSyTmUqMc1tIEuPcJtft1ZJI=;
	b=9rQLpEHDE/iDThUY/iMkdV+JGTQoZJu+GsDMJIhuKRtDdj6qvfdMc6uAbhJEpO/4L2CBRE
	RIYJJG2fxiwSGgAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C38159C25;
	Mon, 25 May 2026 12:02:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iBc3Bl46FGqwIQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 25 May 2026 12:02:38 +0000
Date: Mon, 25 May 2026 14:02:36 +0200
From: David Sterba <dsterba@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
Message-ID: <20260525120236.GZ12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260522181411.2487732-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522181411.2487732-1-willy@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto]
X-Spam-Level: 
X-Spam-Flag: NO

On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
> All of these were discovered through auditing the (mis)uses of the folio
> API throughout the kernel; I haven't been specifically reviewing btrfs,
> nor testing.
> 
> Matthew Wilcox (Oracle) (3):
>   Revert "btrfs: fix the file offset calculation inside
>     btrfs_decompress_buf2page()"
>   btrfs: Use folio_put()
>   btrfs: Remove use of bv_page

Added to for-next, thanks.
