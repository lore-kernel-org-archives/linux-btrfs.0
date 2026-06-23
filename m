Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54062030A
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 00:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782173285; cv=none; b=FRw/UUZAw8Lb8JJDnd98fxbyoz0W33fUgEz1k1e5LSJKMxJhfjzlIKjuBk44rrNOIEQQPIadvRgVJB5EWklt9AISqiEn6wr0/xRXJaftwlAqCO7OSSVt3OKzL6bMtARvPZvN29d5sECi9bW5gR3/aGvea54zZoLXCCSAahzJRWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782173285; c=relaxed/simple;
	bh=jz8ubS6R93zktf9aELOdsFJJmnAdbFXvqBy6qB01Bmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzcEOCcTRbrdPwRMaetvZSzQweBIx/N38Gp0x9UEb1/fwiE5z0KoeP8HFx4mGNerG+Kwy7gvwjHWkGjzao6UDvfKv/tpTGHe9tOenM5XyGgjTWCl4WNqXb1jch1UtYuaVqn7t79XEaF0uRwIMxUXxLYQHnWjI6vztyESxbFYYZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jXVtdvfB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Mr9+yewz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KRwyNPe/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cz3HHuV4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jXVtdvfB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mr9+yewz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KRwyNPe/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cz3HHuV4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E47A875DEF;
	Tue, 23 Jun 2026 00:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782173282;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVQzwGWRvnD250jrmKkaQrzEkfK/rVDJ9yXXLTtqZ4A=;
	b=jXVtdvfBIbQqWSdGBxS4icZ9+4Fe8gcPgAtE44g6/b1/CZuPZJJcEhwEVAQrE7ONVovz3/
	BuLVYtCYuvjU9w7pA1lvBLqs3eFJK9vT34Ha8N5o5sr+zJjOzFmFHM6vrLi5GfxsWWBJT3
	ha0Y5DC/PQwKxlzAIxsC7ACMR9xWPEQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782173282;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVQzwGWRvnD250jrmKkaQrzEkfK/rVDJ9yXXLTtqZ4A=;
	b=Mr9+yewzwCfQ5iTxk0hmXshWIFVKw8nwdycJB2bKAyrTLdHiO6SD45NzEjsikZvVCtUec0
	/DZDdv3UO0M0jNAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="KRwyNPe/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cz3HHuV4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782173281;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVQzwGWRvnD250jrmKkaQrzEkfK/rVDJ9yXXLTtqZ4A=;
	b=KRwyNPe/eHg6lWzHt7+Wm5QcNYzXxtIVstvw8LFkqUWymrVIGD6CBvpPh0mJbWfvndiUh8
	zBD2WQqDBC7VwF4dh2kgP9/7jzy7YGCJzmn8bg/Z7FD00sFixU7AbYOnZ7y+EtvQD/Dnts
	QiqFla/9FqFpmL503+S7Vs4JcZdonBg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782173281;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tVQzwGWRvnD250jrmKkaQrzEkfK/rVDJ9yXXLTtqZ4A=;
	b=cz3HHuV4jn3KuIWl1HVqgnOKFg+hUi3ITxsFKD/hi3X0a74QaVjXT/42KT71r9jrURSLhV
	EEv2soE1qYpRgsBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9C09779A8;
	Tue, 23 Jun 2026 00:08:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xzviNGHOOWo7fAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 23 Jun 2026 00:08:01 +0000
Date: Tue, 23 Jun 2026 02:07:56 +0200
From: David Sterba <dsterba@suse.cz>
To: sun k <sunk67188@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: print-tree: print header owner as signed
Message-ID: <20260623000756.GA150664@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1344e141511245ec5cbfbeabd5bd733f0c18d940.1782033097.git.wqu@suse.com>
 <CAAuSuOoNE4wgaqx-5MH_cqpeu0MyrUikrVS98K2H4xLnRW5mxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAuSuOoNE4wgaqx-5MH_cqpeu0MyrUikrVS98K2H4xLnRW5mxA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E47A875DEF
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon, Jun 22, 2026 at 08:00:06PM +0800, sun k wrote:
> Looks good.
> 
> Reviewed-by: Sun YangKai <sunk67188@gmail.com>
> 
> BTW, this reminds me the print-tree result of dir items that points to a
> subvol, which currently looks like this:
> 
> item 4 key (256 DIR_ITEM 224155391) itemoff 15967 itemsize 48
>                 location key (43123 ROOT_ITEM 18446744073709551615) type DIR
>                 transid 896627 data_len 0 name_len 18
>                 name: home.20260621T2000
> 
> And I wonder if we can also print the location key's offset field as s64
> to make it easier to read.

It should be consistent for the ROOT_ITEM and references and we can
actually print the name of the tree, as is done in dump-tree output.
