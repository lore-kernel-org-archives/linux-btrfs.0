Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A60388E71
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 18:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776105788; cv=none; b=Iaih1QKCkuUm9K6xCNQ0wfuIfZ7N7K4hfTlrtt0n+h7ti3w9QWhYruccbdwmJtgt/Br08JZe+uWU3He5rQbs35yjXdomZb5PfXZ3tCqIsjM//kheZ9v+Xkf1z0cBOrrC2rASByGkbf4LCRlrdvJ4uVrTGm00OBLw9cJ6nXk5ovY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776105788; c=relaxed/simple;
	bh=4c6yPgMYHgn2ONlZbtD2bZUXn6yZGWGXuBx9yOWMw4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0q/0f5zbXm0AKMMblXfN3FUG94cAKRzOPip6thW1VC+V2RjkDYGcBh8pUZhl7ktquIhdrn6CKx6VRaDaiu+4K+Tl5AsEL5yWyQ8+p+Xg9dp6d/Db2493dIDjMvoh2NcW9iJHZSPrWf4yuFvE5rG1ZGBX9xv4/09SM5he1sz0DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Sg/saGsl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=m9IAue7u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Sg/saGsl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=m9IAue7u; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Sg/saGsl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="m9IAue7u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Sg/saGsl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="m9IAue7u"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2FB806A8B4;
	Mon, 13 Apr 2026 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776105785;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MqACQVeP5Mfrxm+k6MpiDbePIqSGZClafISzSmgdX+8=;
	b=Sg/saGslc63ODwm1daP4lfVp5F8XsR0NqBjQbr1vGk7ZP4Zn2FPY5GsR2mf5SWrVD17BU8
	s4WxvHthTU1ThgDE5HEtv/C6TqWheDU5Iknd7L/bQZtshPdgrRn0BRRPmlilkgI8FOiKfP
	H8yPHOgYhTI09vCKmKJd3ydlOkgG/QE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776105785;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MqACQVeP5Mfrxm+k6MpiDbePIqSGZClafISzSmgdX+8=;
	b=m9IAue7uMGG9eaUnJXTBsF3RkKt0SabCEpKwr2yeOBYXO1QHrSkVxpqgWVEQ7DcSLK2TlM
	ZPr2Px4U8Mzs9uAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Sg/saGsl";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m9IAue7u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776105785;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MqACQVeP5Mfrxm+k6MpiDbePIqSGZClafISzSmgdX+8=;
	b=Sg/saGslc63ODwm1daP4lfVp5F8XsR0NqBjQbr1vGk7ZP4Zn2FPY5GsR2mf5SWrVD17BU8
	s4WxvHthTU1ThgDE5HEtv/C6TqWheDU5Iknd7L/bQZtshPdgrRn0BRRPmlilkgI8FOiKfP
	H8yPHOgYhTI09vCKmKJd3ydlOkgG/QE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776105785;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MqACQVeP5Mfrxm+k6MpiDbePIqSGZClafISzSmgdX+8=;
	b=m9IAue7uMGG9eaUnJXTBsF3RkKt0SabCEpKwr2yeOBYXO1QHrSkVxpqgWVEQ7DcSLK2TlM
	ZPr2Px4U8Mzs9uAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 176354B020;
	Mon, 13 Apr 2026 18:43:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wtuOBTk53Wk2eAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 13 Apr 2026 18:43:05 +0000
Date: Mon, 13 Apr 2026 20:43:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 3/4] btrfs: make inode->outstanding_extents a u64
Message-ID: <20260413184303.GE12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1775756789.git.boris@bur.io>
 <fab916144bcfc974c3231ac9dbd57e28faa02a28.1775756790.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fab916144bcfc974c3231ac9dbd57e28faa02a28.1775756790.git.boris@bur.io>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2FB806A8B4

On Thu, Apr 09, 2026 at 10:48:50AM -0700, Boris Burkov wrote:
> -	inode->outstanding_extents += mod;
> +	ASSERT(mod == 1 || mod == -1, "mod=%d", mod);
> +	ASSERT(nr_extents <= S64_MAX, "nr_extents=%llu", nr_extents);
> +	ASSERT(mod == -1 || inode->outstanding_extents <= U64_MAX - nr_extents,
> +	       "nr_extents=%llu, inode->outstanding_extents=%llu",

Small note, please don't put "," between the key=values, it's just
stylistic but to keep it consistent with the rest of the ASSERTs.
Thanks.
