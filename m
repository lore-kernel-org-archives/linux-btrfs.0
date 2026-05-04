Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C223DA7F9
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 13:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777900931; cv=none; b=ZYV5lqSE/n4XhnVSIPpD4R/1u2KxicT5v6xIple8Ye8IUk8S8VRDnrbGQWp3qMbNA2LGCg8siZr8EtOrLrzKHYUmfTrGzj9otFAWykpnchjSj4LnZc6DUJ/fa239C3kx44vGobO2OkyaPO5jZ+55IWgI1fXg1iZhK7/vKJSIeuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777900931; c=relaxed/simple;
	bh=Tdq+h/suO3Vlav7HiQYf+S/hyy6gXl0NudoepIYywuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oOdjGRNCTzWchCh+tizlolwqiiL6IZzIeU/U4FAajbZ8ScpMWVMfnw/2YypeTZLWm7MrUix4Rgwn4CPOonG53WU7w/Hiyw+4hUKTACIaYdZ6Nz6bxYEvam6ouPbcM7segm+74aRx4P4YsxMOPzxEA4SGUJ3L48cBZQGTbOE+qfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SvLbNORe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3/D2yRYX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SvLbNORe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3/D2yRYX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SvLbNORe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3/D2yRYX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SvLbNORe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3/D2yRYX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C6AD5C570;
	Mon,  4 May 2026 13:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777900927;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lO/YDNTqQaT9U2SKGCmry2HSWQGvPppoXAhTs5V1T+0=;
	b=SvLbNOReopfuBqWVsK9Ymd5XEWkyYBxh/1wdnecRjRBf91h9jST9st9fQi4KF3Er7DyYoN
	1D6QhIe1IK2JEReD0Iu/8LtUm1uAuZflo1Kds5jQJZ9LgxNQ8XxrMCwGLf0OWqwrQHYGXf
	I4Ps/EHdyhTcemZFb0qeKhPy8DZY3l0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777900927;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lO/YDNTqQaT9U2SKGCmry2HSWQGvPppoXAhTs5V1T+0=;
	b=3/D2yRYXO0brrogu9yhBCYN/QKnRRw7IyoHcJTza5sGovEdIpmYZ4B9PXGDsWjMcOtjpZ5
	SIgUymZHCQ3diZAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SvLbNORe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3/D2yRYX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777900927;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lO/YDNTqQaT9U2SKGCmry2HSWQGvPppoXAhTs5V1T+0=;
	b=SvLbNOReopfuBqWVsK9Ymd5XEWkyYBxh/1wdnecRjRBf91h9jST9st9fQi4KF3Er7DyYoN
	1D6QhIe1IK2JEReD0Iu/8LtUm1uAuZflo1Kds5jQJZ9LgxNQ8XxrMCwGLf0OWqwrQHYGXf
	I4Ps/EHdyhTcemZFb0qeKhPy8DZY3l0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777900927;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lO/YDNTqQaT9U2SKGCmry2HSWQGvPppoXAhTs5V1T+0=;
	b=3/D2yRYXO0brrogu9yhBCYN/QKnRRw7IyoHcJTza5sGovEdIpmYZ4B9PXGDsWjMcOtjpZ5
	SIgUymZHCQ3diZAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81DEA593A3;
	Mon,  4 May 2026 13:22:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wOaFH3+d+GmUEgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 04 May 2026 13:22:07 +0000
Date: Mon, 4 May 2026 15:22:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: simple cleanup around
Message-ID: <20260504132206.GA2558453@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1777801546.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777801546.git.wqu@suse.com>
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
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,twin.jikos.cz:mid,suse.com:email,suse.cz:dkim,suse.cz:replyto];
	FROM_HAS_DN(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 8C6AD5C570
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 

On Sun, May 03, 2026 at 07:17:49PM +0930, Qu Wenruo wrote:
> The first patch moves and unexport the function.
> 
> The second one open-codes the function into the only caller, and
> replaces remove the need for @offset/@length usage.
> 
> Qu Wenruo (2):
>   btrfs: unexport and move extent_invalidate_folio()
>   btrfs: simplify the btree folio wait during invalidation

Reviewed-by: David Sterba <dsterba@suse.com>
