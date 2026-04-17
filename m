Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20123507C
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2026 02:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776391756; cv=none; b=gtlrRHbNZFnhlxUSaXZ03KJM0gDQUrxW6E02+YhgXIhJwvZrHxEy2wnEL1EYlQrDGFLxOqQDJQNSzrSZ9og5lNsXDYughf+Qim7LrGQrS635Q57ZIZFhuz/7tDjxyhVFooID79NJ3xVxfKBHYmSk00KeQpfuwQWH4Y14hICZI40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776391756; c=relaxed/simple;
	bh=6hfJ50Ft9XbHZAL79c0Hxev2FXzUayVDGEuJL/SWk48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tp100KDS+M0d647pr/9omi7I7Gu6pPJuTlIsrRpdVxNKxhddmksoCyRBdWIgs+cBLXjH5gR7XnF1S70yVaZuA5UbuOPrq4wYNrVF8nEY6ruGe8s4zvG0HaGVndOGrqmnEopOGkLi8vMi2WRkZiCh7RqBUblZx0jf1zHOrYHnvI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=beEKc7mj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UGJoPxKI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3UZIVOUV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z+w++fu3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="beEKc7mj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UGJoPxKI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3UZIVOUV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z+w++fu3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E2F986A831;
	Fri, 17 Apr 2026 02:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776391754;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98aALYhp+zoFO6708d0MhdOacBr3eI4S4gusRf56ZLM=;
	b=beEKc7mjrVVYxNdAyCtUkHBSsQL6mTNkKHgeDUjbZWG3PnvsS2Fw6o6cWRywmAOJgl4KCV
	agUGAEMT1i+EwVbaVQNq1LfIcd+pnI3jY7Qcg3E3CyBSs+lRetvDLCW02RA0HnkzVT701Q
	BWhbiv3JSya0goErN81VS195sCRVOr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776391754;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98aALYhp+zoFO6708d0MhdOacBr3eI4S4gusRf56ZLM=;
	b=UGJoPxKIIZ7KMt+mm/irV38CecL+Mq0qz+eM/RzfVuHgJMK1cbD9YyS9oKeVdoMesyzNsk
	GDUlc/fADj6/1mBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3UZIVOUV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Z+w++fu3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776391753;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98aALYhp+zoFO6708d0MhdOacBr3eI4S4gusRf56ZLM=;
	b=3UZIVOUV+T7QfoALZ7Gz2dCq9Eq9GGLJxZ9yGZ1OH1f043hcv6/M6zSz46tN1axad6rYdZ
	xFt9jA3X1hkebo4ThrV3RvYuO7pjycNAuiugBUqt1GONwclRgUP9I7+noyaQ8c42o7SzB1
	ZxjQNQpzBppinytE3ePlebR/g6GrcJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776391753;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98aALYhp+zoFO6708d0MhdOacBr3eI4S4gusRf56ZLM=;
	b=Z+w++fu3GaLS+/l9UFzlEN4602aZ8vln3fkELbXYvUf60mK/+hs2r3RhjiOYrDns/5Id68
	lceVRsqEJNE8OdBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBA47593AE;
	Fri, 17 Apr 2026 02:09:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id quyIMUmW4WlwUgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 17 Apr 2026 02:09:13 +0000
Date: Fri, 17 Apr 2026 04:09:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Martin Raiber <martin@urbackup.org>
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 02/10] btrfs: reduce size of struct btrfs_block_group
Message-ID: <20260417020912.GV12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1776278490.git.fdmanana@suse.com>
 <ef130a3bd2f994d615e9b7dc8b17132b6c3a7fc1.1776278490.git.fdmanana@suse.com>
 <0102019d92c1ee11-d6caef74-9449-4f16-aa67-31c5995f8676-000000@eu-west-1.amazonses.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0102019d92c1ee11-d6caef74-9449-4f16-aa67-31c5995f8676-000000@eu-west-1.amazonses.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E2F986A831

On Wed, Apr 15, 2026 at 08:07:56PM +0000, Martin Raiber wrote:
> I found that putting ro, cached and size_class in the same cache line 
> brought performance benefits for |find_free_extent. I cannot say how 
> important that is compared to other kinds of users.|

I don't see any obvious use pattern where grouping the class, ro and
cached would be beneficial. What usually works is when a lock and the
members used in the locked section are on the same cacheline.  As block
group is a big structure and used in different ways there are
possibilites where the cacheline placement will have good or bad effects
but without a reproducible or described workload it could be just a
random occasion.

Specifically for find_free_extent, there could be some potential for
optimization but this again would need at least a perf profile to find a
starting point.
