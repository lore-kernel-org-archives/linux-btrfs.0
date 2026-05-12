Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ABB3E172F
	for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2026 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778599132; cv=none; b=tRdAtHhN21Xtmr+6+HTxaNiCjFq1JNk6QPQcaRqLFGuSWvwQ0/k10OQ31GDrNPGjQc9IiSsHPnZ4LkMwWrnlkNt0so3XhFNESDyz8X70FQtIjm8fbTM7zGZn1P85uT3QxS9E5oDCo0rYl6PUXtESYEZd+ughYJgVgoKVb5ELKoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778599132; c=relaxed/simple;
	bh=jvd+MDamcvt/hP9X/KMaF+Mf0JvrbzEXpZxZAkLaRcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyoCCrK0RYD9EHU+qHQZIqRWodGrhRCJDDfC0WJWH+EMc5JLk7Gy82QA+LO475gznOBnqpe3JzmE/WwFnnr1gnqZLs3in7wQkNpiaek2+MSkgSRiEa1faMi7/I1OuWQ12RmSSfzJp4wjPnD8SZ9epAEtPgd7o+RB9dHr8AExchc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bYJ+Rbma; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YIRkQcDc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZE6Vf/mW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CEJ+cODB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bYJ+Rbma";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YIRkQcDc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZE6Vf/mW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CEJ+cODB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4BDBB6B84E;
	Tue, 12 May 2026 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778599129;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBnVZ87OU95lwBeuP0QsA39hhypzUd99Z32VJYcxa+Y=;
	b=bYJ+RbmaECRNs3ncID+DvMLsP7dJTIcFsP0lMJZzBv/i+J/ymGqcnytm2XNYjk/d8JVQhL
	q7dMsYJeGK2EBblQsiDqNyRsLsILJPmhk97UnCh/3B7D6gXhAiYFn4U2U7aMQzJcacs2SE
	/0f3pg774JGzNf6dn/iIf51QF5/Og0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778599129;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBnVZ87OU95lwBeuP0QsA39hhypzUd99Z32VJYcxa+Y=;
	b=YIRkQcDcW18I8JRkdRzOnWKlXWSkeV8a4e/jdMJYUE+fNAhE3ZzET5Fkuh1aWt+LDXY9PY
	xqwFkshm3usxE+CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ZE6Vf/mW";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CEJ+cODB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778599128;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBnVZ87OU95lwBeuP0QsA39hhypzUd99Z32VJYcxa+Y=;
	b=ZE6Vf/mWfgKJt4gU9is8Tb+vvjQ6xOIMh6zeZZhUc8yafMNg1hsX2rtWrrT4J68FEn6ivL
	s71t1Pf6dikLfpLLjEvcnjxdjyIFmd/3FjQieEJmTAbVAvRpITLs+bmUVEDkmreJNrYkQk
	6AgyIvir45lvIEUMJcesJ1TPyksLPLI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778599128;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hBnVZ87OU95lwBeuP0QsA39hhypzUd99Z32VJYcxa+Y=;
	b=CEJ+cODBzitdehQmJE+fEq9OuulnrzpnK4cpt1mqBdhYkuak7FvNoWzkCoKwwVe7NqPkYW
	I0cXVW4dNNc3akCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B383593A9;
	Tue, 12 May 2026 15:18:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ATflCdhEA2pRRwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 12 May 2026 15:18:48 +0000
Date: Tue, 12 May 2026 17:18:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhang Cen <rollkingzzc@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>, zerocling0077@gmail.com,
	2045gemini@gmail.com
Subject: Re: [PATCH v3] btrfs: free-space-tree: reject mismatched extent and
 bitmap items
Message-ID: <20260512151846.GJ2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260510074943.2644334-1-rollkingzzc@gmail.com>
 <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.rollkingzzc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccb16e1f1b9490dc3d76e219cc2d9fe8cdd3afa7.1778403060.git.rollkingzzc@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[fb.com,suse.com,vger.kernel.org,gmail.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.cz:replyto,suse.cz:dkim,twin.jikos.cz:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4BDBB6B84E
X-Spam-Level: 

On Sun, May 10, 2026 at 11:03:22PM +0800, Zhang Cen wrote:
> +static int validate_free_space_key(struct btrfs_block_group *block_group,
> +				   const struct btrfs_key *key,
> +				   u8 expected_type)
> +{
> +	const u64 end = btrfs_block_group_end(block_group);
> +
> +	if (unlikely(key->type != expected_type)) {
> +		btrfs_err(block_group->fs_info,
> +			  "block group %llu has unexpected free space key type %u, expected %u",
> +			  block_group->start, key->type, expected_type);
> +		return -EUCLEAN;
> +	}
> +
> +	if (unlikely(key->objectid + key->offset > end)) {

This has a review comment https://sashiko.dev/#/patchset/20260510152848.3844894-1-rollkingzzc%40gmail.com
that the expression can overflow. I did a light check if it is valid at
all (we're still evaluating the quality of AI reviews) but I think in
this case more checks to the key.offset and key.objectid could be added.
As this would is in checker it's meant to be extensive so partially
overlapping conditions are not a problem.
