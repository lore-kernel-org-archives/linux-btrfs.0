Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B4F30C37E
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180777; cv=none; b=RwIjfZZIXVAy/lGXbvrz/LNFuJMAChCzvYwhXHLZ3rPtOxmn30j3JdOjElH46Lpm+6fZfy+CJJNFh8+vC+FAr5iosg/8AlPQdIuuO/ChFo3HngxcUVs7AKDDHOW1yvYmnLyJkShmzpFlS9UyIVweAmj92TXfZ00W3c614O0u2CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180777; c=relaxed/simple;
	bh=qbmjQL/u70cLWdc58iL1JOKlX+vMeRFylCrJGqDqDd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gre7Ue1cr7FDGaahT8SbaOhsPHhM8PrAZwHwaIcjiei6hzAZGJkvJ+kQpEpjfJyicMIo2gn02/6GSiDzQIj77wDtC4t6ooPqWJ0d1sbyqLWAVPYgeLN2Ay6ZupGijoZxvhrz9iRHyEXfCd4zcJf5ha75bILQon9HKsq3ou77bUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=s+sCQ2Jd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KVN8WT/R; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=s+sCQ2Jd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KVN8WT/R; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="s+sCQ2Jd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KVN8WT/R";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="s+sCQ2Jd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KVN8WT/R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 28AA96A7C2;
	Tue, 14 Apr 2026 15:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776180774;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhNj2GYXe7QNLP+fMXXyb9bdu//sz5oyCXr+yocuQRE=;
	b=s+sCQ2JdaNu4CKnYREm69JwC26ongElkw65u+sLOVZ/qEyAwy15ovqyhgcugiDFNlhp/xO
	2gSXauMF98va9TbPEScAjM2Yc5PbvqTtZuQPSGup+hOhAaUKoQ7t6C5TerxSQDH1js4qYr
	xMXV1Q8wJa146dWwNxuPEWPIj7Xcpec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776180774;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhNj2GYXe7QNLP+fMXXyb9bdu//sz5oyCXr+yocuQRE=;
	b=KVN8WT/RTJm+SMEkNXb4oCPLdpAQqpLA/c+GglSKrmvGaQWAH5vurhQoje+KFOiaLMwSSU
	g4FabOOH3QxoIFAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s+sCQ2Jd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="KVN8WT/R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776180774;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhNj2GYXe7QNLP+fMXXyb9bdu//sz5oyCXr+yocuQRE=;
	b=s+sCQ2JdaNu4CKnYREm69JwC26ongElkw65u+sLOVZ/qEyAwy15ovqyhgcugiDFNlhp/xO
	2gSXauMF98va9TbPEScAjM2Yc5PbvqTtZuQPSGup+hOhAaUKoQ7t6C5TerxSQDH1js4qYr
	xMXV1Q8wJa146dWwNxuPEWPIj7Xcpec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776180774;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhNj2GYXe7QNLP+fMXXyb9bdu//sz5oyCXr+yocuQRE=;
	b=KVN8WT/RTJm+SMEkNXb4oCPLdpAQqpLA/c+GglSKrmvGaQWAH5vurhQoje+KFOiaLMwSSU
	g4FabOOH3QxoIFAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B2F84B4FB;
	Tue, 14 Apr 2026 15:32:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6F6OAiZe3mnEPQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 14 Apr 2026 15:32:54 +0000
Date: Tue, 14 Apr 2026 17:32:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/2] btrfs: remove COW fixup and checked folio flag
Message-ID: <20260414153248.GN12792@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1776137603.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1776137603.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 28AA96A7C2
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Tue, Apr 14, 2026 at 01:05:25PM +0930, Qu Wenruo wrote:
> Changelog:
> v3:
> - Open-code btrfs_writepage_cow_fixup()
>   The function is now only a folio_test_ordered() and error message.
>   There is no need to keep it as an dedicated function.
> 
> v2:
> - Also remove the fixup worker
> 
> - Slightly reword the cover letter
> 
> - Remove COW fixup related comments
> 
> - Update Kconfig to reflect this change.
> 
> For experimental builds we're already rejecting dirty folios which
> don't have ordered flags since v6.15.
> 
> Unfortunately we're not yet removing that COW fixup machanism for
> non-experimental builds even at v7.0, as we can still trigger the
> warning when we detect dirty folios without ordered extents.
> 
> So far all those problems only happen when errors are injected into the
> IO path, e.g. generic/475, and I haven't yet seen it triggered without
> error handling.
> 
> Although I prefer to remove the COW fixup after all error handling
> problems are fixed, I run out of ideas how those cases can happen, and
> the current handling of treating such cases as write errors is not
> going to make things any worse anyway.
> 
> Furthermore for the future of huge folios (order 9, 2M page on 4K page
> size systems), we can not afford the extra bitmap for a huge folio.
> In that case, a huge folio will need 64 bytes per bitmap, which is no
> longer a small amount.
> 
> I believe it's time to remove the COW fixup mechanism even for
> non-experimental builds, along with the checked folio flags.
> 
> Qu Wenruo (2):
>   btrfs: remove the COW fixup mechanism
>   btrfs: remove folio checked subpage bitmap tracking

Reviewed-by: David Sterba <dsterba@suse.com>
