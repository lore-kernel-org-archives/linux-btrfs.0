Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340EC2FE56E
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 19:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781639873; cv=none; b=nW9qlpZEEA1z1T6jg/F5S2ZOhLQFGJvt3l6ae/BaCkEkRrViw8sTb2JZTdw8Okrl9wJm22cpU5pd+Lm72ERKQwUNW+Mu6rPgRlsRszdkMFrycobs/r7ck42+Rl39kFeAJ+WgGVuQYj4MYIsiV+MlFhLhEIRLTzodYz3nmptPs5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781639873; c=relaxed/simple;
	bh=lP3AWCnZzqgMoeH6Jyqob5BD0sxyQHTuo9X4SIvnVUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tq4piY1fXY92tXWvnuGAeKX4bacmAgicJdFsXfGunvo2qwMCspYwXx8YthjaoUW+Jkj8DTx7uu2Bp8SNWkgYsNKv4f3aOOx/mLWMzSUFtF3AeXQQz6i/MGkVcERqD0sEv0xNbLORQ2v0NxVLpCAsFs9PYH9afN8d+829NTFwtF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p3ayvkr2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+bBkq8Nd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p3ayvkr2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+bBkq8Nd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p3ayvkr2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+bBkq8Nd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p3ayvkr2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+bBkq8Nd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9061375E13;
	Tue, 16 Jun 2026 19:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781639869;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rea2hXK8kwR6IR83lvwEa0IDqfrBylp+ApdpsG237OE=;
	b=p3ayvkr2qmPh+ia2n4yE/liSFQ6TPzWuB+5rzMDIfa5ereMWYkk2RQoA/w9LIt29AKO2OG
	LTu6MG+uJn4lvA8kCfMcY9b2Dp8+yryI7UThtJh2ZQ7N5Xo+1X2NM8xdKk8wfQnDKujoZD
	q5ouvZwO53JIWu1mZZa5/nexkFTJTfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781639869;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rea2hXK8kwR6IR83lvwEa0IDqfrBylp+ApdpsG237OE=;
	b=+bBkq8Nd7Ra3vxXPeTR4Rck24H2hPkiyHNGGSPpMqNS9FgDMqsrnvXVO6YRdHD8eCxpvjv
	1nHoxvJgZG2wN9Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p3ayvkr2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+bBkq8Nd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781639869;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rea2hXK8kwR6IR83lvwEa0IDqfrBylp+ApdpsG237OE=;
	b=p3ayvkr2qmPh+ia2n4yE/liSFQ6TPzWuB+5rzMDIfa5ereMWYkk2RQoA/w9LIt29AKO2OG
	LTu6MG+uJn4lvA8kCfMcY9b2Dp8+yryI7UThtJh2ZQ7N5Xo+1X2NM8xdKk8wfQnDKujoZD
	q5ouvZwO53JIWu1mZZa5/nexkFTJTfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781639869;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rea2hXK8kwR6IR83lvwEa0IDqfrBylp+ApdpsG237OE=;
	b=+bBkq8Nd7Ra3vxXPeTR4Rck24H2hPkiyHNGGSPpMqNS9FgDMqsrnvXVO6YRdHD8eCxpvjv
	1nHoxvJgZG2wN9Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A8BF779A8;
	Tue, 16 Jun 2026 19:57:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pkmwHb2qMWrBLgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 16 Jun 2026 19:57:49 +0000
Date: Tue, 16 Jun 2026 21:57:48 +0200
From: David Sterba <dsterba@suse.cz>
To: You-Kai Zheng <ykzheng@synology.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH] btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8
Message-ID: <20260616195748.GA306614@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260616103907.2157960-1-ykzheng@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616103907.2157960-1-ykzheng@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9061375E13
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.com:email,twin.jikos.cz:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Tue, Jun 16, 2026 at 06:39:07PM +0800, You-Kai Zheng wrote:
> The variable-sized buffer buf in struct btrfs_ioctl_search_args_v2 is
> declared as __u64[], but it holds a packed byte stream of search results,
> where all offsets into the buffer are in bytes.
> 
> Declaring buf as __u64[] makes it easy for user space to write incorrect
> pointer arithmetic: adding a byte offset directly to a __u64 pointer
> scales the offset by 8, landing at byte position offset*8 instead of
> offset.
> 
> This recently caused an infinite loop in btrfs-progs: the accessor read
> all-zero data from misaddressed items, which fed zeroed search keys back
> into the ioctl loop and spun forever. The issue was worked around at the
> time by disabling TREE_SEARCH_V2 entirely in btrfs-progs (d73e69824854:
> "btrfs-progs: temporarily disable usage of v2 of search tree ioctl").
> 
> The kernel side already treats buf as a byte buffer, so change the
> declaration to __u8[] to match the actual semantics and prevent similar
> misuse in user space. The change is ABI compatible: both the structure size
> and alignment are unchanged.
> 
> Suggested-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: You-Kai Zheng <ykzheng@synology.com>

Fixes: cc68a8a5a433 ("btrfs: new ioctl TREE_SEARCH_V2")

Thanks for fixing it.

Reviewed-by: David Sterba <dsterba@suse.com>
