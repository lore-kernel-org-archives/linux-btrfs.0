Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199404;
	b=3XgYdgUAq7I5DnEMsflsBARdnRnbFo7V2c0VJi4lPLXP9ZOOxAVCk32y56ZtsVcPBThO
	 A4O+hs9fr+xtCUTAMgbwrCnkWRVLYDAWcdpk4KQFfCkWX4E1uIM1Y5V6ZartidVVRolxo
	 JAFMC7m0y7najjmvCEPYDN4nAfS+Pif+Wbi6UdpMUdUGPNCj1ApmNh0yHGR7o4V4a3YO2
	 kZit/baMj+srnuq8LA8vYar/rPDNYz3IBZanU+ulsV3oVyZbQX/UBZmon3gErQkRV3wWH
	 KeRlkegUNPdzhnvWC6JKxJzG2K13URw5HbxQ+jZSki5Y3WB2hpM0aaTnP0QiS3nLz4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199404;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=MpOZTsfE06cY+8SeYYGnBDJdlSMkcn1V3ClwKM8SQ20=;
	b=jxvsFSfmGcYrY7qH2iXTI4mjEEn9YdrFyOL1iK3N8XofB5lBvpQkfY25+Ol4dzQKkZ3E
	 YYKBlotK3XwYech8mdDv74DrgKPnKelIycZJeW+R33ck68gPQlwjibFnKQH8rkbbfESLH
	 RqDaX9fABOJtIHtL2QS8GZ0jOzJ4rZ9m8LoY46Dqt3pddQw6gXcdcJy52P7IiSuwsyvlQ
	 eNd3cP6eW9S/MpKjbrd8HoCVqSjL/qSYRNTWRDRJXui6iIt6YlJdgLwaWRBKQOVwcaUTJ
	 xsv+c8jx7E+DMiRkfekuBZwj49zsVjRg1wAX/fNrqiA6qIH5Wh6EfrXeeRlkjfxVrRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=YkeGdScM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qxyl04Fw;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GmWdamrH;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BanYp3vc;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D37606A31D;
	Wed, 28 Oct 2026 14:56:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22D37606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=YkeGdScM;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qxyl04Fw;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GmWdamrH;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BanYp3vc
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD2B72201F;
	Wed, 28 Oct 2026 14:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793199402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpOZTsfE06cY+8SeYYGnBDJdlSMkcn1V3ClwKM8SQ20=;
	b=YkeGdScMThH8j6dJfiTaafkGPL/pWRQRZzh8MwlB95aWbe03eM8F4EchDHZFYTHYUiA5gi
	pRAhAYaYll3ww50a3//at3PhRKk/ZCgaT96PMKwl8Tf4uEGa99M6BEFL5rguTBST3jsq1W
	dx1OC5Wa09CcJLCYQSwFr85UL89omSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793199402;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpOZTsfE06cY+8SeYYGnBDJdlSMkcn1V3ClwKM8SQ20=;
	b=qxyl04FwcGFuSTt3w+/QylbeygpLqKyp0tU/nbJveIloJmVMebfRpC50zhcbc2iINfD1bQ
	ALXEhBd2J4GIAPBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GmWdamrH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BanYp3vc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793199401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpOZTsfE06cY+8SeYYGnBDJdlSMkcn1V3ClwKM8SQ20=;
	b=GmWdamrH6k3qVhqSj/koryPWzRXEnvLkZ+5ITEw95lvYt8ha24LJPv/3Sa54H8bUjPEYG3
	awtlnuoi1BxNcIck2MW/WIAQ5gMou5xB04nAynct2jIXOG+OSBntnTpqf5FnaX/B5/Zr7z
	VrwJ6XrN/j/X+Tznt15pufd/zKeCW+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793199401;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpOZTsfE06cY+8SeYYGnBDJdlSMkcn1V3ClwKM8SQ20=;
	b=BanYp3vcHbtwwoQcGofrjr2zXFMGjN5JwAW5RINqoKb0P0spLHrjBwiQkVpwudeHYBDpog
	FyzIqjj9u8S9A/Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E194513419;
	Wed, 28 Oct 2026 14:56:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S/aZKigN4moGFwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 14:56:40 +0000
Date: Wed, 28 Oct 2026 14:56:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chris Mason <mason@kernel.org>, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] vfs: add provenance time (ptime)
Message-ID: <auILs54TUcWXf3us@pedro-suse.tail5790ac.ts.net>
References: <20261028134728.294127-1-koray.fra@gmail.com>
 <20261028134728.294127-2-koray.fra@gmail.com>
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
In-Reply-To: <20261028134728.294127-2-koray.fra@gmail.com>
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,zeniv.linux.org.uk,kernel.org,suse.cz,gmail.com,vger.kernel.org];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: DD2B72201F

On Wed, Oct 28, 2026 at 02:47:27PM +0100, koraynilay wrote:
> Add provenance time (ptime), indicating the time when a file or
> directory was created. This is user-settable via file_setattr() and
> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> 
> The semantics of when to preserve this new timestamp are the same as
> mtime, the idea being that there is a correspondence like this:
> 
> ctime <-> btime
> mtime <-> ptime
> 
> so every operation (copying, moving, ...) that currently preserves mtime
> should also preserve ptime.
> 
> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
> allow ptime to be used with the file_setattr()/file_getattr() syscalls.

Random comment, but: could this be doable with xattrs instead? I'm not sure
where I would put the xattrs code (if in userspace exclusively, or if hooking
the VFS up with this, or if doing it on the filesystem side), but it would
surely be less disruptive than modifying a bunch of filesystems one-by-one.

This patch is quite simple, but changing btrfs, then ext4, xfs, etc is a
mess, and inevitably you can't get these timestamps until you upgrade your
filesystems.

-- 
Pedro
