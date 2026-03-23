Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32AA2BEC55
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 12:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774268450; cv=none; b=DLMABxp72fk0/uxqeRPwjMj9Oor93hqTGtKpAlLF6XuU91pHpDfbDQmNoVZ8Bmub18BTYyEr0LMTf72z82EjnO+DVyns/xJKvzmT/wU0+rFktUyOvgR7Jns3y2tkTe7VrgD4xOSCMrZBaLmqWQ9ua//WGiVwj2zdFeKrENg2G0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774268450; c=relaxed/simple;
	bh=ijua+k+z9HX5E8G+qvife66TUkfkaRCaSsdTSATPy4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DKw7rZbaCvAE7eDICxNHTCiq/eoTQu95Uv26g/6X8v66lE1V/oijiaiHhY+HXgLXbphWjHOvkoJb/U+L8ecJ8sQSNQcrCUTsr8s3mG5W1PG/XF08X4pqtk+1nZRO5GAvwg6UtQgsOm7zghGCWRZ6VhoNBCm3SUCemD9VMeCBeM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0XhQqK+k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RVJQ6t1a; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0XhQqK+k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RVJQ6t1a; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0XhQqK+k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RVJQ6t1a";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0XhQqK+k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RVJQ6t1a"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA5C55BE69;
	Mon, 23 Mar 2026 12:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774268446;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SlkIhOoXl/SUgmoKO9omnemiCn3XZmSqyYCCp5aCFg=;
	b=0XhQqK+k/CVcH0RGr+u+CMuNIIItWtFI0UFG6z8aJyDOujlolOwybp+F4xXipFgzEu6+OZ
	PEontYVevWLkqhW0dai5Tngg6iIKD59d7HuMYOnNcpRYplTzd8/IeIooWYOTZHSiao5857
	8wh5tXiCmdIO00zFXqXejWiqJxJmU54=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774268446;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SlkIhOoXl/SUgmoKO9omnemiCn3XZmSqyYCCp5aCFg=;
	b=RVJQ6t1ai9+mTGLuKK5xR6zob6wTnMkZ+q3FdtIENuO+ceEVhqZUsj1fs07U5UelDvG/qC
	qj/QY6gfAfBXq+Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0XhQqK+k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RVJQ6t1a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774268446;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SlkIhOoXl/SUgmoKO9omnemiCn3XZmSqyYCCp5aCFg=;
	b=0XhQqK+k/CVcH0RGr+u+CMuNIIItWtFI0UFG6z8aJyDOujlolOwybp+F4xXipFgzEu6+OZ
	PEontYVevWLkqhW0dai5Tngg6iIKD59d7HuMYOnNcpRYplTzd8/IeIooWYOTZHSiao5857
	8wh5tXiCmdIO00zFXqXejWiqJxJmU54=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774268446;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SlkIhOoXl/SUgmoKO9omnemiCn3XZmSqyYCCp5aCFg=;
	b=RVJQ6t1ai9+mTGLuKK5xR6zob6wTnMkZ+q3FdtIENuO+ceEVhqZUsj1fs07U5UelDvG/qC
	qj/QY6gfAfBXq+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89DFF43889;
	Mon, 23 Mar 2026 12:20:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YvluIR4wwWkpFgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 23 Mar 2026 12:20:46 +0000
Date: Mon, 23 Mar 2026 13:20:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Leo Martins <loemra.dev@gmail.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: avoid GFP_ATOMIC allocations in qgroup free paths
Message-ID: <20260323122045.GJ5735@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <44a36cda2b9cdc4a600c942c051f9e028239308b.1773941507.git.loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44a36cda2b9cdc4a600c942c051f9e028239308b.1773941507.git.loemra.dev@gmail.com>
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
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: AA5C55BE69
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Thu, Mar 19, 2026 at 04:49:08PM -0700, Leo Martins wrote:
> When qgroups are enabled, __btrfs_qgroup_release_data() and
> qgroup_free_reserved_data() pass an extent_changeset to
> btrfs_clear_record_extent_bits() to track how many bytes had their
> EXTENT_QGROUP_RESERVED bits cleared. Inside the extent IO tree spinlock,
> add_extent_changeset() calls ulist_add() with GFP_ATOMIC to record each
> changed range. If this allocation fails, it hits a BUG_ON and panics the
> kernel.
> 
> However, both of these callers only read changeset.bytes_changed
> afterwards — the range_changed ulist is populated and immediately freed
> without ever being iterated. The GFP_ATOMIC allocation is entirely
> unnecessary for these paths.
> 
> Introduce extent_changeset_init_bytes_only() which uses a sentinel value
> (EXTENT_CHANGESET_BYTES_ONLY) on the ulist's prealloc field to signal
> that only bytes_changed should be tracked. add_extent_changeset() checks
> for this sentinel and returns early after updating bytes_changed,
> skipping the ulist_add() call entirely. This eliminates the GFP_ATOMIC
> allocation and makes the BUG_ON unreachable for these paths.
> 
> Callers that need range tracking (qgroup_reserve_data,
> qgroup_unreserve_range, btrfs_qgroup_check_reserved_leak) continue to
> use extent_changeset_init() and are unaffected.
> 
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>

Added to for-next, thanks.
