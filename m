Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B772483BD3;
	Fri,  4 Sep 2026 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788539922; cv=none; b=YGye4FRYtpo/fmECaz70R5/Hw1sqfycYo67FuDIa/fobOC2X+99fUjZtTdpnDIAbaYfz5jU64TBhOHbwiBrsiWflT/UAxqcgwmppAuFZofVeBTC77n3Peg3jyXXTNk485eCriItGYS4GeEExwhOj/AGn5tRnro4UU4mmSOMTNaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788539922; c=relaxed/simple;
	bh=rGkagFf+huICoP6Y4V3XUG/Ll7qGrM3zVGT65zhZaVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nY3uB66nvnqQ1ifPNm1vDRcje8VSR1P+T2GkIjnxsFt/lJQo9oKKCgZ+yPWzhvrdajoBcntoHShwBMpckAFKJnM4X9RsUaaGSfVG5eO9g6WF+5Ys+jkZ27cKSZVM08KeOCIf9fjL86dTUVUi3/Shz71gd8NlIBY9mKIm4P4E5xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=r8L6HTBa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jjoIp5nP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3dGXn5a7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bnPY0SdV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="r8L6HTBa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jjoIp5nP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3dGXn5a7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bnPY0SdV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0186D22BA3;
	Fri,  4 Sep 2026 16:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788539915;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vnal5zyB8ZdnYJrOd9Z/LLYm/CB+jozKbPXEw/PDvRE=;
	b=r8L6HTBaq6kUJb0C7kmUecrSWP6TaBefowwIStlArN8AtFco4h+KEMst3KbyjWRL5oZ0P8
	wKv/5fHLO2XSZCScPfKVdK0bgTkvWIBSUO0ZDcJLxiZNXvVZ3ND+IgvojpX9rS5A9pFsSq
	Hitf6HWSW4C7LU6Ifb48mSy72AFWoWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788539915;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vnal5zyB8ZdnYJrOd9Z/LLYm/CB+jozKbPXEw/PDvRE=;
	b=jjoIp5nPSdvWCnQScxdp8jNqNVFeWNKR8xK3uGGc1Zx4jVOZh+tCRL68tAyO/PsROc5kG4
	rSyMJzMVwa59wOBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3dGXn5a7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bnPY0SdV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788539911;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vnal5zyB8ZdnYJrOd9Z/LLYm/CB+jozKbPXEw/PDvRE=;
	b=3dGXn5a7Y/tv2BJZV3Q/4QFsGHwgr5wL/oyq5oaKtT3QZO/YNFChSXToZad472gT3LsKGq
	AklgGQUtEB/pzS7LqmpBtrMEe5uQWnmkQIL3LemNVXjd8DwdE9A4jnq3UuWfPiiMtgPW5/
	e1D17+F9Nf/qxYkeXdl5DeHw4Gi+tI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788539911;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vnal5zyB8ZdnYJrOd9Z/LLYm/CB+jozKbPXEw/PDvRE=;
	b=bnPY0SdVV+6AgdU4fX1eZqXPuM6X9hut6ZN+Jh1C5ygBLfjrcFMvqWgQ/aW4WvArFcw0UX
	bah/vNZ32EQmsJAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C782513726;
	Fri,  4 Sep 2026 16:38:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KeZ9MAb0mmogTAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 04 Sep 2026 16:38:30 +0000
Date: Fri, 4 Sep 2026 18:38:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix typos in comments
Message-ID: <20260904163814.GK9053@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260904115202.7113-1-hemanth.selam@gmail.com>
 <20260904115202.7113-2-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904115202.7113-2-hemanth.selam@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -2.71
X-Rspamd-Queue-Id: 0186D22BA3
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.71 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:replyto,twin.jikos.cz:mid];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

On Fri, Sep 04, 2026 at 05:21:59PM +0530, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Thanks, despite all efforts the typos always make it back. Please merge
the two patches together as they're fixing only comments.

I'm not sure which branch you've used, the most recent is
https://github.com/btrfs/linux for-next

I did a quick check using codespell and it found a few more typos,
please include them in v2 too.

block-group.h:138: commited ==> committed
extent-io-tree.c:754: Temporarilly ==> Temporarily
fs.c:82: Checksume ==> Checksum
raid56.c:991: coresponding ==> corresponding
raid56.c:2635: caclulated ==> calculated
transaction.h:291: wheather ==> weather, whether
tree-checker.c:231: cannnot ==> cannot
