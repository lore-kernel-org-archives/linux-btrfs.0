Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B643EFD00
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 10:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777460073; cv=none; b=WJJZWqo9Qd43YeD4TX3P9kmRigaox7DTpPquKy9K4yZs758+rJYebldifjwBcxXKSWhatQBVmmdInNLu7MRlEKfnfzrZOFyN4Vi7mtLa1ThWCtwOJBOW+pJqk35prcOgKiw8gB10N5+12EN0karuKNHJvu+ohj7GOgYn/lSgTpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777460073; c=relaxed/simple;
	bh=jzSDSX6DwOmL8QCqbGiKZ4F+VomyEdlrdYYzd2JYPAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=La7gjq2DALKvBwHmaX4AtoWF+Yg88VHy3Bl8l0/Ne1g0pVDD8w14py++BERb5m8Nc0yh3bCNk6Xg/knEP+BmppOBl4OdREjcn3FQjcm/ypniAOxV0R7ssQZHMG21bC7zFJzwH1rnQW1OqyR8d04JBQj4r0ttCMNs3bpXd63hZ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y9ospdlA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DMpTEmME; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y9ospdlA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DMpTEmME; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y9ospdlA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DMpTEmME";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y9ospdlA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DMpTEmME"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0CEAA5BD3F;
	Wed, 29 Apr 2026 10:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777460069;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5GW+ObWoR/P6BAkZiL5O/rEwhv6FeUWxVqxjPFyFgNk=;
	b=Y9ospdlAB0S2OctxG+M0xxd3Qh1i2FdHV97pBzuaLA//69WhWbvhy0SH857MJJXyAuveuH
	xD3qoKxzmd13x6FM8Auuo0JkpaOUvXmGL1q1IGOrhw4FSqhuyDuYse0HMdEcWdDk4JfjED
	uBJpf5XlL/feHHEAPDKf5vE2FayVh9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777460069;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5GW+ObWoR/P6BAkZiL5O/rEwhv6FeUWxVqxjPFyFgNk=;
	b=DMpTEmMEOzDDDRZg78uL5lvBkA8nySrTww9QiadPqxtChS0AGH+vdzVoKL9TfhEqfQFac/
	EJwaJjsZNIsYL3AA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y9ospdlA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DMpTEmME
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777460069;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5GW+ObWoR/P6BAkZiL5O/rEwhv6FeUWxVqxjPFyFgNk=;
	b=Y9ospdlAB0S2OctxG+M0xxd3Qh1i2FdHV97pBzuaLA//69WhWbvhy0SH857MJJXyAuveuH
	xD3qoKxzmd13x6FM8Auuo0JkpaOUvXmGL1q1IGOrhw4FSqhuyDuYse0HMdEcWdDk4JfjED
	uBJpf5XlL/feHHEAPDKf5vE2FayVh9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777460069;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5GW+ObWoR/P6BAkZiL5O/rEwhv6FeUWxVqxjPFyFgNk=;
	b=DMpTEmMEOzDDDRZg78uL5lvBkA8nySrTww9QiadPqxtChS0AGH+vdzVoKL9TfhEqfQFac/
	EJwaJjsZNIsYL3AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F132B593B0;
	Wed, 29 Apr 2026 10:54:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wdytOmTj8WmNDAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Wed, 29 Apr 2026 10:54:28 +0000
Date: Wed, 29 Apr 2026 12:54:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Calvin Owens <calvin@wbinvd.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	"JP Kobryn (Meta)" <jp.kobryn@linux.dev>,
	Mark Harmstone <mark@harmstone.com>, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH] btrfs: always pass __GFP_NOWARN from add_ra_bio_pages()
Message-ID: <20260429105423.GI3906171@suse.cz>
Reply-To: dsterba@suse.cz
References: <fa015cf39d4dd9575052141e86bce7417c61d4e1.1777445157.git.calvin@wbinvd.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa015cf39d4dd9575052141e86bce7417c61d4e1.1777445157.git.calvin@wbinvd.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:mid,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 0CEAA5BD3F

On Wed, Apr 29, 2026 at 12:10:25AM -0700, Calvin Owens wrote:
> A build workload newly prints order-0 allocation failures on 7.1-rc1:
> 
>     sh: page allocation failure: order:0
>     mode:0x14084a(__GFP_HIGHMEM|__GFP_MOVABLE|__GFP_IO|__GFP_KSWAPD_RECLAIM|
>                   __GFP_COMP|__GFP_HARDWALL)
>     CPU: 27 UID: 1000 PID: 855540 Comm: sh Not tainted 7.1.0-rc1-llvm-00058-gdca922e019dd #1 PREEMPTLAZY
>     Call Trace:
>      <TASK>
>      dump_stack_lvl+0x50/0x70
>      warn_alloc+0xeb/0x100
>      __alloc_pages_slowpath+0x567/0x5a0
>      ? filemap_get_entry+0x11a/0x140
>      __alloc_frozen_pages_noprof+0x249/0x2d0
>      alloc_pages_mpol+0xe4/0x180
>      folio_alloc_noprof+0x80/0xa0
>      add_ra_bio_pages+0x13c/0x4b0
>      btrfs_submit_compressed_read+0x229/0x300
>      submit_one_bio+0x9e/0xe0
>      btrfs_readahead+0x185/0x1a0
>      [...]
> 
>     (lldb) source list -a add_ra_bio_pages+0x13c
>     .../vmlinux.unstripped add_ra_bio_pages + 316 at .../fs/btrfs/compression.c:454:8
>        451
>        452                  folio = filemap_alloc_folio(mapping_gfp_constraint(mapping, constraint_gfp),
>        453                                              0, NULL);
>     -> 454                  if (!folio)
>        455                          break;
> 
> I can reproduce this consistently by running a memory hog concurrently
> with a buffered writer on a machine with a very large amount of swap.
> 
> Commit 7ae37b2c94ed ("btrfs: prevent direct reclaim during compressed
> readahead") clearly intended to suppress these warnings. But because the
> mask set in the address_space with mapping_set_gfp_mask() doesn't include
> __GFP_NOWARN, mapping_gfp_constraint() removes it from constraint_gfp
> before it is passed to filemap_alloc_folio().
> 
> Fix by refactoring the code to add __GFP_NOWARN after the call to
> mapping_gfp_constraint().
> 
> Fixes: 7ae37b2c94ed ("btrfs: prevent direct reclaim during compressed readahead")
> Signed-off-by: Calvin Owens <calvin@wbinvd.org>

This is on me, the original patch https://lore.kernel.org/linux-btrfs/20260323051414.64704-1-jp.kobryn@linux.dev/
had the __GFP_NOWARN at the allocation. As this was not explained as
necessary I moved it to the constant assignments to be grouped. But this
changed the semantics.

Added to for-next, thanks.
