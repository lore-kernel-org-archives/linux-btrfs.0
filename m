Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792431280;
	b=OyokDZ8VovwX2metjyRnhNaeN6UZM4rKT7ZPXwdWJS2TvkQmEC3x8CaJFyZH8GsxJrTN
	 S4cGdtuEG74HCvii5A+hHuG1eYAqb+Zs9UB4E2iCzbeGFlw4s0x8tlVOkwp/H67DmRLxV
	 4niHvLRRV590LO+BzXgdqpzxNeZc6/ad5dj7no57T2hWgE8ADeopIGWzA8T5yhnjLEs+Y
	 rk1GoWzvQR7Su7EJ8CxXvNu6IZISapJowti1nzBf/IP6dcGyq7mgGsnRSbi2uJ5rHvCHn
	 HSBOcJf17j1A1dUXmRb6XIBdr2u3bouGiI39e8CH2p9JAcFdh6YYOqywkvIZ8DFcuYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792431280;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 Reply-To:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:User-Agent:X-Rspamd-Server:X-Rspamd-Queue-Id:
	 X-Rspamd-Action:X-Spam-Level:X-Spamd-Result:X-Spam-Flag:X-Spam-Score;
	bh=pyvJz4LDE61ET6IRjs5jPraQ2KidbJ8crbWqGbkBNvg=;
	b=xFdpV6EBY+PoErOMztd2/jDXB+NuScmCKqAUkvXeBe5vkURJFurHn5+EgLuQQTdp7ghB
	 Bj6FPzBsB2pHOHrmsC0kwCSqlX+v48RMaEsuHTvDtaH2WSOR1XkcJsAeL6O+p2hMClCiS
	 A/9ak+e117Z6sWbt4z3ZbSG3r2YbWqflTd0i1Rek34O/SPq1kCf5MPymzNiMS97uUrX1I
	 Q42jNUdtTvevWDvlqmNDu4wMK5qp3Kr9vDZ/rdBsYAFBF5aB2bD7Xfyfqgo+Ur9z2Dp86
	 XfAp7sw9dVgpWeQsOJUqXqng4WQk/sNNFzFG0Cj8ikeTWR5mfATDghX9Ud8vquzWpZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1CWdlZDF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EQLDU9o8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1CWdlZDF;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EQLDU9o8;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEB6606A31B;
	Mon, 19 Oct 2026 17:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CEB6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1CWdlZDF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EQLDU9o8;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1CWdlZDF;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EQLDU9o8
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF8D91F750;
	Mon, 19 Oct 2026 17:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792431277;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pyvJz4LDE61ET6IRjs5jPraQ2KidbJ8crbWqGbkBNvg=;
	b=1CWdlZDFBBUEr3ddpWbUHrLYDSpdnh/ax05OLA1gsYnlnnj/FH3s1BKNvSrqohBvoSWAoe
	mEuA9bmDZQXnRt6uyY28SEJQB4wL074v3zoj8xsUK2osTQuVxIyD22US8gHlUYfuht6vKn
	s3rLQvEH/9L4rslT/J/b747gVCwqa8Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792431277;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pyvJz4LDE61ET6IRjs5jPraQ2KidbJ8crbWqGbkBNvg=;
	b=EQLDU9o8D44DQRWS3A1+plo1vLhYWWV0yyfzeszkQvyGtLHtLxyQziOnbHhoXZUxgEHKuX
	KrRNnP/pxerTG2DA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1CWdlZDF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EQLDU9o8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792431277;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pyvJz4LDE61ET6IRjs5jPraQ2KidbJ8crbWqGbkBNvg=;
	b=1CWdlZDFBBUEr3ddpWbUHrLYDSpdnh/ax05OLA1gsYnlnnj/FH3s1BKNvSrqohBvoSWAoe
	mEuA9bmDZQXnRt6uyY28SEJQB4wL074v3zoj8xsUK2osTQuVxIyD22US8gHlUYfuht6vKn
	s3rLQvEH/9L4rslT/J/b747gVCwqa8Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792431277;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pyvJz4LDE61ET6IRjs5jPraQ2KidbJ8crbWqGbkBNvg=;
	b=EQLDU9o8D44DQRWS3A1+plo1vLhYWWV0yyfzeszkQvyGtLHtLxyQziOnbHhoXZUxgEHKuX
	KrRNnP/pxerTG2DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8340C134B3;
	Mon, 19 Oct 2026 17:34:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3QbUFq1U1mrzLQAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 19 Oct 2026 17:34:37 +0000
Date: Mon, 19 Oct 2026 19:34:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Tao Cui <cui.tao@linux.dev>
Cc: mason@kernel.org, dsterba@suse.com, sforshee@kernel.org, wqu@suse.com,
	brauner@kernel.org, josef@toxicpanda.com,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v3] btrfs: allow idmapped DEFRAG ioctls
Message-ID: <20261019173436.GE1310987@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20261009075326.144319-1-cui.tao@linux.dev>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009075326.144319-1-cui.tao@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BF8D91F750
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:replyto,suse.cz:dkim,kylinos.cn:email]
X-Spam-Flag: NO
X-Spam-Score: -4.21

On Fri, Oct 09, 2026 at 03:53:25PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> btrfs_ioctl_defrag() checks MAY_WRITE against nop_mnt_idmap, so on an
> idmapped mount the owner comparison uses the caller's fsuid against the
> raw on-disk uid and the ioctl fails with -EPERM even for the file's
> owner.  Pass the mount idmap down so defrag works on idmapped mounts.
> 
> The check, added in 616d374efa23 ("btrfs: allow defrag on a file opened
> read-only that has rw permissions"), is not a privilege gate.  It only
> tests whether the file could have been opened for writing, and a user
> who owns the file on the idmapped mount can already open it O_RDWR,
> write() to it or fallocate() it.  Defragmenting a regular file only
> rearranges the caller's own extents; there is nothing it can rewrite
> that the caller could not rewrite anyway.  Whole-subvolume defrag on a
> directory keeps its capable(CAP_SYS_ADMIN) requirement, and the
> !capable() guard around this check is left as is.
> 
> FIDEDUPERANGE already works this way for unprivileged callers:
> may_dedupe_file() in fs/remap_range.c compares the inode owner through
> file_mnt_idmap(file) and falls back to inode_permission() with the same
> idmap, and dedupe can rewrite one file's extents from another file's
> contents, which is a stronger operation than defrag.
> 
> On regular mounts file_mnt_idmap() is nop_mnt_idmap and nothing
> changes.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> Reviewed-by: Seth Forshee <sforshee@kernel.org>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> Changes in v3:
> - Rebase onto linux-next (next-20261008); no functional changes.
> - Collect tags from review.

Added to for-next, thanks.
