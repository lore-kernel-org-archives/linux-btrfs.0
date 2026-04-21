Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A0033260C
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Apr 2026 03:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776741507; cv=none; b=bNjqz3RV8X/SlIrYnUJpdm3WaNawVdIyGpxdZ0fhXyMseEk0hwkh+1FuuUwoSO0mbWtIP+n6SlOEnFkf+6vVS/b6iCMy3soEkYQ8JXXB3AZNvLFhrJu3p6jAWK8vpS+oYTx1RpeA1acQc91E6hLBuS0kBCAOAI97PZk/2NRlr7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776741507; c=relaxed/simple;
	bh=Wo1x3MI25VRhWpAZXnZ+uiiCQReKElT9h9YQGqUI5AQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=av84Aniivj+I4vCXGi7vt9PPnwxr3tjSg51+ApXLppENnEdOqcEZS0U3ZKvN4brpbsU8jtLN84H3icNNv7L3O6LJpF6RMceYBzoZY1H6O8VvGlLQSxdbdwATMK0PmUYBfVH18biZaB0s5dQNaSk0p/1Fp561TP2+HFIwwRHeJoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ivBUwDuj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9LQEf8tZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EnRp5mch; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dOxvYYgr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ivBUwDuj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9LQEf8tZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EnRp5mch";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dOxvYYgr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4EE6C6A7DB;
	Tue, 21 Apr 2026 03:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776741504;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99PnP1NbPzaBykcT4WypniiKpJiJHVZApnnJW/SEl8s=;
	b=ivBUwDujhSBXDMVhI8QMtJPTrGRQGHTLbGdnSPLc8QdCZHRcKEy8Or4fRFSDCg9/N1gmeK
	b60w/SwF8ZzKB0ZvIf6vzGoiA6R6dx5vikfbkvFYhWdVL36wkwRVilooEw5EJaTNkOobw2
	wHwjJGO3sI8/gDNEmCK5FkPq04tZX2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776741504;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99PnP1NbPzaBykcT4WypniiKpJiJHVZApnnJW/SEl8s=;
	b=9LQEf8tZ35jJ9VwPRWhRL54iF3XiUGId3r4dCQ1CjucI50YY4XPG8P6gvCNQoWPYMnI1YW
	KOihK/b4KQzW2RAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EnRp5mch;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dOxvYYgr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776741503;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99PnP1NbPzaBykcT4WypniiKpJiJHVZApnnJW/SEl8s=;
	b=EnRp5mchIiJDzy7XK7seYF4kO+w7R10S05Y+zWpKMj/Yv+wN8spEjWdPwwkWqfu+yhY2PP
	05lbUIJVzXYP1sQEraSOADKJMgYL8XuhMWkai8IktFJ3W5kdexfAIir1Vs62ptnvUss1r6
	WLVbwRBAIbAZ6hUKywmf4XXS7+MKvj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776741503;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99PnP1NbPzaBykcT4WypniiKpJiJHVZApnnJW/SEl8s=;
	b=dOxvYYgr2GzhBCumYNyZQ2P6ON8Zz/Xqs2mBi1CTnC5Ay9XRiUxZJAZ5AvYwxKzzvIWPJc
	VYqgMSRxoWtUNvCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3723C593AF;
	Tue, 21 Apr 2026 03:18:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1e5KDX/s5mntPQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 21 Apr 2026 03:18:23 +0000
Date: Tue, 21 Apr 2026 05:18:18 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use the enums instead of int type in struct
 btrfs_block_group fields
Message-ID: <20260421031817.GD12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <085942c2ba1ec8fec438f49c6f8e2d6bb2011eb1.1776693204.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <085942c2ba1ec8fec438f49c6f8e2d6bb2011eb1.1776693204.git.fdmanana@suse.com>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid,suse.com:email]
X-Rspamd-Queue-Id: 4EE6C6A7DB
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Mon, Apr 20, 2026 at 02:54:11PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The 'disk_cache_state' and 'cached' fields are defined with an int type
> but all the values we assigned to them come from the enums
> btrfs_disk_cache_state and btrfs_caching_type. So change the type in the
> btrfs_block_group structure from int to these enums - in practice an enum
> is an int, so this is more for readability and clarity.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
