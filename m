Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793791992;
	b=1BdKS19IdY/S1DOoWa8Tp2E1dVIcC2svY8WB4Vel5L4oZTzMvU1/AFYsjYZwU8bz9qKh
	 i+gkFxIUGNADP9CUkE6UuO//KTdXmr6p9yuO4QVgKfoInCGhTVZWud65Bokr54agW+Vnn
	 hDWJnENM91omnXH9hP5PYcMbVR8+PtvtmgYbAvcbWTmTG94+CZPx+SjU6ksRlW0hSnrQm
	 6ONaEsmafO43G6dzMdpyV62j+XhcP5hgd6x3R3cFk3VXCkzDBsr/Pm4YapQFAH+leIxX6
	 rBZbFpW1THqA54MuqHsBSqanlo7Qd1s9rFOAgD1fkKs6T5cdXfO1zvLwT1EFxfdva5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793791992;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=DA9gSK8SSw7yCKYFv/FiBrYaS7lH4KCu7a0mok+44Hw=;
	b=fz7bdNJJCtj0BkfhlrT4fpKqdndf32GKtPlIdg9aJRbeZXbXJatoBs2sTriN3SZ+HJNF
	 smkQVfRZfDLdsdn2C5fOom9D4Wb8mX+SlRTr5g690WVYq33Ne4jaMgZu8TXkC51/l92Pi
	 wAdUyjihD9u3dJwAm5wwpgc0SZfbqk1L5BRzJl+dfOzmimN8smz603SWSkmAZiOcSG/mV
	 qmzx1cVGdXf6gqkfC6w7CW0KgUTz23k3WEi+pgv9IbtKfhEKmofvHtodeFeBR+l2z65G6
	 /C9OFjjb11/9QNnzM/8VOLFbBaNLZencKLhV9wGkVoe9Nv+1lfOw7rjzToXj6GyNaUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=K3o9XeQG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iKx8Vm2z;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=K3o9XeQG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iKx8Vm2z;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7165E606A326;
	Wed,  4 Nov 2026 11:33:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7165E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=K3o9XeQG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iKx8Vm2z;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=K3o9XeQG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iKx8Vm2z
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 531F11F7BE;
	Wed,  4 Nov 2026 11:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793791989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DA9gSK8SSw7yCKYFv/FiBrYaS7lH4KCu7a0mok+44Hw=;
	b=K3o9XeQGzok53jazelgy5Z8SnsmktVuxS3wbnsk4FBgZY8vaU2ERDfvmqskcp7OADTjmSD
	7vMRvgB54NCDxhOCGQQWABEXjsPqedVgo+2k4J49IjDgOGQr6PwJUAFHoiRb/3/fOfnqaa
	6ng0oVJWSyZTTMwoupQXzvR3ycJOQko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793791989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DA9gSK8SSw7yCKYFv/FiBrYaS7lH4KCu7a0mok+44Hw=;
	b=iKx8Vm2zq+MRBLzn1lzmhQErTr1wbqhMZQ3hZ21ZMNUanlt2beQm0pggIrkeESJufsSQsc
	aEUK8lRIk5CfdABA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K3o9XeQG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iKx8Vm2z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793791989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DA9gSK8SSw7yCKYFv/FiBrYaS7lH4KCu7a0mok+44Hw=;
	b=K3o9XeQGzok53jazelgy5Z8SnsmktVuxS3wbnsk4FBgZY8vaU2ERDfvmqskcp7OADTjmSD
	7vMRvgB54NCDxhOCGQQWABEXjsPqedVgo+2k4J49IjDgOGQr6PwJUAFHoiRb/3/fOfnqaa
	6ng0oVJWSyZTTMwoupQXzvR3ycJOQko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793791989;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DA9gSK8SSw7yCKYFv/FiBrYaS7lH4KCu7a0mok+44Hw=;
	b=iKx8Vm2zq+MRBLzn1lzmhQErTr1wbqhMZQ3hZ21ZMNUanlt2beQm0pggIrkeESJufsSQsc
	aEUK8lRIk5CfdABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29A27134A5;
	Wed,  4 Nov 2026 11:33:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7RUZAvUX62r4NQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 11:33:09 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A8A99B325; Wed, 04 Nov 2026 12:33:08 +0100 (CET)
Date: Wed, 4 Nov 2026 12:33:08 +0100
From: Jan Kara <jack@suse.cz>
To: koraynilay <koray.fra@gmail.com>
Cc: Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chris Mason <mason@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] add provenance time (ptime)
Message-ID: <unzslqbr7karhkgfxrcmjwgtps3byokmsqecyouqlc7aa6cszv@pgup6q2nxwt6>
References: <20261027220532.736352-1-koray.fra@gmail.com>
 <upe7qvhod63zd724s7uiql6kanqyrcwplodoavcvqjt35vd4ee@s3iglizxejlr>
 <DMLN8XHASPL4.1R3MI7CMA5KCD@gmail.com>
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
In-Reply-To: <DMLN8XHASPL4.1R3MI7CMA5KCD@gmail.com>
X-Rspamd-Queue-Id: 531F11F7BE
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,suse.com,zeniv.linux.org.uk,kernel.org,gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Score: -11.51

On Tue 03-11-26 15:26:20, koraynilay wrote:
> On Tue Nov 3, 2026 at 2:25 PM CET, Jan Kara wrote:
> > On Tue 27-10-26 23:05:30, koraynilay wrote:
> >> This is an initial implementation of a new timestamp to indicate the
> >> time when a file/directory was initially created.
> >> 
> >> This patch series takes inspiration from the one by Sean Smith
> >> <defendthedisabled@gmail.com> [1], but using
> >> file_setattr()/file_getattr() as suggested by Darrick J. Wong
> >> <djwong@kernel.org> in [2].
> >> 
> >> The semantics of this new timestamp should be at least these:
> >> - it should be the same as btime on a newly created file
> >> - it's user-settable, so it can be preserved for backups, filesystem
> >>   conversions, archives and any similar operation
> >> - it should be preserved every time mtime gets preserved
> >> 
> >> and the correspondence with the other timestamps is as follows:
> >> 
> >> ctime <-> btime
> >> mtime <-> ptime
> >
> > One thing I miss in this series is an explanation what this new timestamp is
> > good for. Because frankly, I don't miss such timestamp as a Linux user :).
> >
> > 								Honza
> 
> Hello, my concrete use-cases are backups and filesystem conversions.
> 
> For backups, my setup is btrfs and using btrbk (so btrfs send to my nas
> with ssh) and the only missing thing from the backup is the timestamp of
> file creation (which I'm currently working around using xattrs).
> 
> The situation that prompted me to finally start working on this RFC
> PATCH was when I wanted to merge 2 btrfs FSs and the only way of doing
> that (AFAIK at least) is using cp/rsync, which can't set the creation
> time since btime is immutable. The workaround I used was the same as
> with backups, so with xattrs, but noticed that some files (symlinks)
> wouldn't accept xattrs, so I looked into it and found out xattrs are
> only for regular files/dirs.
> 
> (also see https://lore.kernel.org/DMGS4KQLY24Q.14MUTR6U93GIC@gmail.com/)

Ah, OK, I think I finally understand why do you want this. Thanks for
explanation!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
