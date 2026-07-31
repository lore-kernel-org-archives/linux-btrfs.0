Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCE23F8234
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785510261; cv=none; b=rgPp3dit6IOLOQ7su4DhIqbppYf8wUE/aDYGiDafCPJoDDtplFvNWZo0DuMPcojT+KZ8RFoLtXIYqdj+1Cg4quj9gZ2VE7xBV2qMlBRPR5SbglDXoMcfEBQnxKN5GvzzwS1Eju53l2XRiQm5JsX3fTR+zMXB662ODabVZZ4WRvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785510261; c=relaxed/simple;
	bh=q1fh/keGRb0rUQ2V7wrR3sseekkTV0gu3GnoA5qUImI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyR942GfC80qEGe2wkEU7uJMCFHV3MThdgJQeQPrR6V2VAig9J0fEg38ZsCurT6x27Q+tSWMryJd6GY2LJcprVIpy4c5XwpuV2aEtly1rgOCFSscEb5o/XMzUFSCwXAnhu8ucFkIXDZiBE2vYB0JffxwZVchRQlY1EJVJtm5fJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OlLhUD2T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DS9GD9dF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CojPctaD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6CQnmH5/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OlLhUD2T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DS9GD9dF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CojPctaD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6CQnmH5/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 397807E000;
	Fri, 31 Jul 2026 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785510254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCZEVWcHK4q2iP3rbeswNSAVfSgOnkHk2+3mjsHlu54=;
	b=OlLhUD2TTHPsleuAnxbDKfHuyiXRKMUWkYtlBB78ZNIWmVezqlbkIyMVpM7q498IoaDq5V
	kErz7GNwey4z2Cp+Yeh5LlWNhg0pl3GU2Mg2alDN3ctAeU+3/X56t4ja4/+lO0g/vB3bmw
	JoeiQLexYjBIp9/1SjZcW4p8Pgbfqwk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785510254;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCZEVWcHK4q2iP3rbeswNSAVfSgOnkHk2+3mjsHlu54=;
	b=DS9GD9dF4H72/MKNbMEE2IT+f+9augQjs8ycmTn4pdEvxN47Tr/MkeEt1NHEQ6L5lQiJ4v
	5zsl7vpRlKExDVDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CojPctaD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="6CQnmH5/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785510250;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCZEVWcHK4q2iP3rbeswNSAVfSgOnkHk2+3mjsHlu54=;
	b=CojPctaDLwdQFjg4t6JI8W5/NaLlBlEhv2wOO0gUrmk9r+4dkuw5iu1tt50QY4oMtfZElR
	/jHNv/D5cIkgjXKk3WnhpPf+pNVZxUydxXXa3Kdz7+J2BDyHC3UHSJUu32rzN5pNHKeRQV
	gcJbv6LOXgbWa0LchpS3XZ3d0p7Ps9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785510250;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCZEVWcHK4q2iP3rbeswNSAVfSgOnkHk2+3mjsHlu54=;
	b=6CQnmH5/f7L0CURm3uzy/MBU0gY7tFXGF9yHEHV3dP0GY5dWsno0lyCiCXPFyd/tftN52J
	NTRJpIkhoHu0gbDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26434779B0;
	Fri, 31 Jul 2026 15:04:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5lskCWq5bGpWIgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Fri, 31 Jul 2026 15:04:10 +0000
Date: Fri, 31 Jul 2026 17:04:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, Omar Sandoval <osandov@fb.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	jlayton@kernel.org, boris@bur.io, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix extent changeset leak in encoded writes
Message-ID: <20260731150408.GW10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260731-btrfs_kmemleak-v1-1-9600453eef4e@debian.org>
 <CAL3q7H5P6XngF7O8Pfp_WawazCeq26V+=G7OQnnNLsnD4EbZDA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H5P6XngF7O8Pfp_WawazCeq26V+=G7OQnnNLsnD4EbZDA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spamd-Result: default: False [-4.21 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.21
X-Spam-Level: 
X-Rspamd-Queue-Id: 397807E000
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Fri, Jul 31, 2026 at 12:56:20PM +0100, Filipe Manana wrote:
> On Fri, Jul 31, 2026 at 12:52 PM Breno Leitao <leitao@debian.org> wrote:
> >
> > Investigating some machines with kmemleak, I am constantly seeing
> > the following memory leak that seems real.
> >
> >   kmemleak: unreferenced object 0xffff88869f7d01c0 (size 64):
> >   kmemleak:   comm "btrfs", pid 1613416, jiffies 4316358595
> >   kmemleak:   backtrace (crc ab59040a):
> >   kmemleak:     __kmalloc_cache_noprof
> >   kmemleak:     qgroup_reserve_data
> >   kmemleak:     btrfs_qgroup_reserve_data
> >   kmemleak:     btrfs_do_encoded_write
> >   kmemleak:     btrfs_do_write_iter
> >   kmemleak:     btrfs_ioctl_encoded_write
> >   kmemleak:     btrfs_ioctl
> >   kmemleak:   ... and 2 more object(s) with the same backtrace
> >
> > and
> >
> >   kmemleak: unreferenced object 0xffff88830d94edc0 (size 64):
> >   kmemleak:   comm "btrfs", pid 1613416, jiffies 4316358595
> > <snip>
> >   kmemleak:   ... and 2 more object(s) with the same backtrace
> >
> > Looking at the code, it seems we don't free data_reserved, but
> > we should (!?). I was able to come up with a xfstest test that exposes
> > the kmemleak above:
> >
> > https://github.com/leitao/xfstest/commit/81c83a3fbb20b4ad695055ede7fcb73d3ffa2e52
> >
> > Free the changeset on the way out, as every other caller of
> > btrfs_qgroup_reserve_data() already does.
> >
> > Fixes: 7c0c7269f7b5 ("btrfs: add BTRFS_IOC_ENCODED_WRITE")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> This is already fixed here:
> 
> https://lore.kernel.org/linux-btrfs/20260727115352.12622-1-dmantipov@yandex.ru/

Will be sent next week.
