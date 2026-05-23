Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1B72C15B0
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779558682; cv=none; b=rmBKwrEZkrolVEev5KHc48JtP+QAfAC1grmzGlWDiUAQXGpuDaZkbj4jaJQeCBs0mC8HBiFPKdzXQyNdkl2WDvjSRqGp9oT0Yy6dRMpiz88QIGeFSP6e/hrKKkZvFGaUsihD7Qs69Jn4LNg1hv6zDnPxyQtXxy0CslYJOvDPiGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779558682; c=relaxed/simple;
	bh=JrzG4Ff+TuoA+5oHGgaUzz+c9MrqeCDJYSZafesGXSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KV+Gmj0/aoikcDwpcHDgiCzeZDGMgn2ZikZrcuVC2YJ6MWdJw/Orn4PgEffTW+1RyJ5k6shCblH9VsRkPnsi0+4naT/sorA1wrK68964ysO0K1u+WRcg0KSL65v9spwECoIlkVsE7gJ1ZyXAOMyNXrJJgVlVRsAcc1iektqawAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rgOhhzh3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wSci6K7d; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rgOhhzh3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wSci6K7d; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rgOhhzh3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wSci6K7d";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rgOhhzh3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wSci6K7d"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B014767349;
	Sat, 23 May 2026 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779558679;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c5IxXqQnPSJZj/smnucU22SwJVgYBTV4+t9L2Eq2nKE=;
	b=rgOhhzh3tQZf5vJuWXiBSTOqdTMe7kgnmCCRZUs7yCIYpHpSVrIOr+omPVURTYx5QHuHdG
	rjizpYWfWD6VHrR+eij0aVdvbURBWGpDexNq0p9SEYGoXvtUlzRki3psMLIUXUHWiWHFj3
	AnqG3R2rWtVw/cZZHjf3KkkAJrz+WLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779558679;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c5IxXqQnPSJZj/smnucU22SwJVgYBTV4+t9L2Eq2nKE=;
	b=wSci6K7diBMYR1CCmF3jROOawh+ABk1v7azybZgA9iqd2WtLZwGscVjB9an2lDL/xvIECG
	RgITE7cdYs4qnBAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779558679;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c5IxXqQnPSJZj/smnucU22SwJVgYBTV4+t9L2Eq2nKE=;
	b=rgOhhzh3tQZf5vJuWXiBSTOqdTMe7kgnmCCRZUs7yCIYpHpSVrIOr+omPVURTYx5QHuHdG
	rjizpYWfWD6VHrR+eij0aVdvbURBWGpDexNq0p9SEYGoXvtUlzRki3psMLIUXUHWiWHFj3
	AnqG3R2rWtVw/cZZHjf3KkkAJrz+WLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779558679;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c5IxXqQnPSJZj/smnucU22SwJVgYBTV4+t9L2Eq2nKE=;
	b=wSci6K7diBMYR1CCmF3jROOawh+ABk1v7azybZgA9iqd2WtLZwGscVjB9an2lDL/xvIECG
	RgITE7cdYs4qnBAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 939B8593A8;
	Sat, 23 May 2026 17:51:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WXlWIxfpEWoIbQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Sat, 23 May 2026 17:51:19 +0000
Date: Sat, 23 May 2026 19:51:14 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 19/28] btrfs: tracepoints: add trace event for
 add_conflicting_inode()
Message-ID: <20260523175114.GK183694@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1778776706.git.fdmanana@suse.com>
 <238c79ed66ab85e05394448aeddf91899839ca22.1778776707.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <238c79ed66ab85e05394448aeddf91899839ca22.1778776707.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid,suse.com:email];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

On Fri, May 15, 2026 at 06:00:16PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> +	TP_fast_assign(
> +		TP_fast_assign_fsid(trans->fs_info);
> +		__entry->root_objectid		= btrfs_root_id(ctx->inode->root);
> +		__entry->transid		= trans->transid;
> +		__entry->ctx_ino		= btrfs_ino(ctx->inode);
> +		__entry->conflict_ino		= ino;
> +		__entry->conflict_ino_parent	= parent;
> +	),
> +
> +	TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_ino=%llu conflic_ino=%llu"
                                                                 ^^^^^^^^^^^

This looks like a typo, "conflict_ino" as the variable names.

> +			" conflict_ino_parent=%llu",
> +			show_root_type(__entry->root_objectid), __entry->transid,
> +			__entry->ctx_ino, __entry->conflict_ino,
> +			__entry->conflict_ino_parent)
> +);
> +
> +TRACE_EVENT(btrfs_add_conflicting_inode_exit,
...
> +	TP_printk_btrfs("root=%llu(%s) transid=%llu ctx_ino=%llu conflic_ino=%llu"

And here.

Otherwise no other typos spotted in the whole series and the formats
look consistent. I'll fix the two in for-next. Thanks.

> +			" conflict_ino_parent=%llu ret=%d",
> +			show_root_type(__entry->root_objectid), __entry->transid,
> +			__entry->ctx_ino, __entry->conflict_ino,
> +			__entry->conflict_ino_parent, __entry->ret)
> +);
