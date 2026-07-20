Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C816A3EDE58
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 10:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784545084; cv=none; b=uR+g3YEcqh/mJ7m08UWP/9yzeIALHG7HJp7OF1BdQ+HWSxGUy7zJ4Xy+uJLdgbjvb3jireyXSBLXPF4b969NICUouFM7g+G0VXfOGBEH9Ql7aiDEzzENpBm3RyEaDwXlkKOgy64sJRn/LpxgROYahAfczaOoQECWB0hEiZJCFGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784545084; c=relaxed/simple;
	bh=1vaWIUg/WSTTXq9JzODhHF/VPQbLAzTPYZz4jQVExiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rnxr+0+GmAHiOGXS83LhiOo5O+EP6LFTc38x+VXV9KgEtzhVjmTSGn2WUe066rgZesOzj7pnHUNEd/PEIPTY+0URy9/SmXM4Ds6wkOA6KgTnEQeypJm9wtYrEBoxoQbukq7uDkjGXNEm0NZIZciMAkhTXp2qTovofie/F7ctohU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bmb+Ri9T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R9UBb+A/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bmb+Ri9T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R9UBb+A/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bmb+Ri9T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R9UBb+A/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bmb+Ri9T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R9UBb+A/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BB0013DF9;
	Mon, 20 Jul 2026 10:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784545079;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74rQQV13mN6Sj1qV6FUpZHGfr84rLm0vDX/bpi6Yir8=;
	b=Bmb+Ri9TIAYxOeMbj0699T3Iv5mTFQJ40Lkdy/NI7thkCpjqgtCmKu6vbP/Gl3j9mQSQh1
	91VzSTX7a3b5/8NyxToVE4wMuBOnOKmzDwbAYEt9BK20/dw4PCK+vp25xfDYle2CsAU4XK
	iXtyJaQ6LJappgsnC2f2zRN18HO1Y7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784545079;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74rQQV13mN6Sj1qV6FUpZHGfr84rLm0vDX/bpi6Yir8=;
	b=R9UBb+A/taH3fGqiLtamh45ERzUjdg9OIP77KL3wYjvj70uiQ8OdUHTFcRKbkRlSdE4tPS
	MvD3tzrt11wfZLDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784545079;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74rQQV13mN6Sj1qV6FUpZHGfr84rLm0vDX/bpi6Yir8=;
	b=Bmb+Ri9TIAYxOeMbj0699T3Iv5mTFQJ40Lkdy/NI7thkCpjqgtCmKu6vbP/Gl3j9mQSQh1
	91VzSTX7a3b5/8NyxToVE4wMuBOnOKmzDwbAYEt9BK20/dw4PCK+vp25xfDYle2CsAU4XK
	iXtyJaQ6LJappgsnC2f2zRN18HO1Y7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784545079;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74rQQV13mN6Sj1qV6FUpZHGfr84rLm0vDX/bpi6Yir8=;
	b=R9UBb+A/taH3fGqiLtamh45ERzUjdg9OIP77KL3wYjvj70uiQ8OdUHTFcRKbkRlSdE4tPS
	MvD3tzrt11wfZLDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD66D779AA;
	Mon, 20 Jul 2026 10:57:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 66cXKjf/XWpOfAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 20 Jul 2026 10:57:59 +0000
Date: Mon, 20 Jul 2026 12:57:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com,
	David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs: Add missing sctx check in cleanup path
Message-ID: <20260720105750.GC10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260714012850.611545-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714012850.611545-1-zenghongling@kylinos.cn>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[126.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[fb.com,suse.com,vger.kernel.org,126.com,suse.cz];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid,suse.cz:email,suse.cz:replyto,kylinos.cn:email];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 

On Tue, Jul 14, 2026 at 09:28:50AM +0800, Hongling Zeng wrote:
> Add sctx NULL check in the for loop condition of the sort_clone_roots
> cleanup path for consistency with the else branch
> 
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> Suggested-by: David Sterba <dsterba@suse.cz>

Added to for-next, thanks.
