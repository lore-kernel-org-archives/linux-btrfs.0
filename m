Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F00D175A78
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774029330; cv=none; b=urjJLtzmuR//3MvbkaRAgBUrye6x7+M8+wfsYODoNbFprUGgXORMnZxcCz4Cske08gmergY3qswFsECbqGfJMcSdOhzCfor7YQDcLkj6ULoLFvVsUeGQUNbigx6VCmfJSc0Iz/WZLlPsvvwZNxDURGCTImAOW81xJZCBwGV4Y9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774029330; c=relaxed/simple;
	bh=nm4EZB/jjixJTzOYTjCNeAiYC3Cla4SutPL4iW+WGBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3pj/elO/hNh3WLhB5LQXc5mH2m7LU7+FxiNLDpllOBj1rq1HWznwz6me75hjX0uZ0hK+R3Y95gol1bTD4vsLvdKOai94VPGxOTeGbmuMU2P18Mjw6jEB7bVKBghU+EXq6YsgTPfySzHFsYOHiIDYO3S9FRft3zLpzacrCxr89A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3JRG7AMg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Nvp+6tW5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3JRG7AMg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Nvp+6tW5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3JRG7AMg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Nvp+6tW5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3JRG7AMg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Nvp+6tW5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACD835BE0E;
	Fri, 20 Mar 2026 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774029327;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sqHbRBnOJZ9MASadKFSaJWmQzM/cmsIWZ8vyqcj80PY=;
	b=3JRG7AMgpj6JK+YSTiT2tb8+xRwWYu9KrebNXc2epSARy+chy8ws/f7+glUcD8fbcZpQYb
	TFrE5cVfkBb7qqkqPY+AN53qUtF3ojrEcOqmpQUQAcpVmDFUKgPY4LOtPxket0XMU88LQC
	J7ixVDKpi+rmrtURuKJ3ItD3lcVKVy8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774029327;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sqHbRBnOJZ9MASadKFSaJWmQzM/cmsIWZ8vyqcj80PY=;
	b=Nvp+6tW5vz/s9PfdHcsDHDX1BeQaFswlUrqFjzHKeRbFmvvdhGzr06YgZ8nxATq5QAHDd3
	deBhD7TWfAYOHmDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3JRG7AMg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Nvp+6tW5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774029327;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sqHbRBnOJZ9MASadKFSaJWmQzM/cmsIWZ8vyqcj80PY=;
	b=3JRG7AMgpj6JK+YSTiT2tb8+xRwWYu9KrebNXc2epSARy+chy8ws/f7+glUcD8fbcZpQYb
	TFrE5cVfkBb7qqkqPY+AN53qUtF3ojrEcOqmpQUQAcpVmDFUKgPY4LOtPxket0XMU88LQC
	J7ixVDKpi+rmrtURuKJ3ItD3lcVKVy8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774029327;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sqHbRBnOJZ9MASadKFSaJWmQzM/cmsIWZ8vyqcj80PY=;
	b=Nvp+6tW5vz/s9PfdHcsDHDX1BeQaFswlUrqFjzHKeRbFmvvdhGzr06YgZ8nxATq5QAHDd3
	deBhD7TWfAYOHmDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8AAC242914;
	Fri, 20 Mar 2026 17:55:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8mgHIQ+KvWmeEQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 20 Mar 2026 17:55:27 +0000
Date: Fri, 20 Mar 2026 18:55:26 +0100
From: David Sterba <dsterba@suse.cz>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: boris@bur.io, mark@harmstone.com, clm@fb.com, wqu@suse.com,
	dsterba@suse.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-team@meta.com
Subject: Re: [PATCH 1/2] btrfs: additional gfp api for allocating compressed
 folios
Message-ID: <20260320175526.GF5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260320073445.80218-1-jp.kobryn@linux.dev>
 <20260320073445.80218-2-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320073445.80218-2-jp.kobryn@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: ACD835BE0E
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Fri, Mar 20, 2026 at 12:34:44AM -0700, JP Kobryn (Meta) wrote:
> btrfs_alloc_compr_folio() assumes all callers want GFP_NOFS. This is fine
> for most cases, however there are some call sites that would benefit from
> different flags. One such case is preventing direct reclaim from occurring
> during readahead allocations. With unbounded reclaim during this time,
> noticeable latency will occur under high memory pressure.
> 
> Provide an additional API that accepts one additional gfp_t parameter,
> giving callers flexibility over the characteristics of their allocation.

If you still need to set the gfp flags in v2, please drop this patch and
extend btrfs_alloc_compr_folio(), the API is internal and we don't need
it fine grained.
