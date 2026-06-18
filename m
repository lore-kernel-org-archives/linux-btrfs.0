Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837B62DCF74
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 17:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781804100; cv=none; b=Y/ff7YScjwanWso1bfbCWxcbrvd0lJYCR0TtCLaR9owjA/09l0ztrwbGucH7+rszC0yYfqAlnB7V6F9KhqXdE5m/ac6G84PVc0cO/th6vJ7lb49i0yJJFS9vKtbASG21EkHr1iumSRgEaORsQruVSekpVbgYZvl05pPKMcm/10E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781804100; c=relaxed/simple;
	bh=8ZNjUmBtGVEKgb/c9dckKvYJotrZas/6cERht+qVTco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWLbkPupWhjMdE5zV1EDiAIh+uJIpBFE5c/IQsYftKzalmBkADL+PEkIOI5cIsnARg5YjjKf3wUusl3oJzVrrO57rKgomnbZrUIoew2vu5uw/aXEForcElglJ/BBqy9ASRhbKWhJWrQoAAj5Ubb6Lo36iP/o6AvKjZ9J9kzfyPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wNkULvBK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KR1j8Xq+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wNkULvBK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KR1j8Xq+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wNkULvBK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KR1j8Xq+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wNkULvBK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KR1j8Xq+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A089E75FDB;
	Thu, 18 Jun 2026 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781804096;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LL76xschNGr6VgqaBEWkJ3PWA85d4kAxudS6PlW0SJk=;
	b=wNkULvBKdvQO+tY+quELmXHsQ70QJ4lPRa8R/usPvasdN+C4X0QRYxAdoAEboBwLu2ecku
	8h+cpcJjTBp0ITbBkkYtZzPZfE4gJ/HeWQGp9/esbgd/z3bSfW6G15oKwxjZyxlZIPJ2h5
	wPyNMswGljUdonMh9ole9W/RuImknG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781804096;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LL76xschNGr6VgqaBEWkJ3PWA85d4kAxudS6PlW0SJk=;
	b=KR1j8Xq+u0jU3eD6njzenk4cAy29Ye7g39Wpr10JdMQCJEjjYEc8DB8UjNrNq5pNyh0kX0
	RX7cBE3+aIoZvsCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781804096;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LL76xschNGr6VgqaBEWkJ3PWA85d4kAxudS6PlW0SJk=;
	b=wNkULvBKdvQO+tY+quELmXHsQ70QJ4lPRa8R/usPvasdN+C4X0QRYxAdoAEboBwLu2ecku
	8h+cpcJjTBp0ITbBkkYtZzPZfE4gJ/HeWQGp9/esbgd/z3bSfW6G15oKwxjZyxlZIPJ2h5
	wPyNMswGljUdonMh9ole9W/RuImknG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781804096;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LL76xschNGr6VgqaBEWkJ3PWA85d4kAxudS6PlW0SJk=;
	b=KR1j8Xq+u0jU3eD6njzenk4cAy29Ye7g39Wpr10JdMQCJEjjYEc8DB8UjNrNq5pNyh0kX0
	RX7cBE3+aIoZvsCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8556C779A8;
	Thu, 18 Jun 2026 17:34:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lV5PIEAsNGrKUwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 18 Jun 2026 17:34:56 +0000
Date: Thu, 18 Jun 2026 19:34:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH] btrfs: tree-checker: validate INODE_REF's namelen
Message-ID: <20260618173451.GA1049224@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <581e4f2fddc1a4cbf1ba6954ece973c36da60dd1.1781130368.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <581e4f2fddc1a4cbf1ba6954ece973c36da60dd1.1781130368.git.wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,asu.edu];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:replyto,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Level: 
X-Spam-Score: -4.00

On Thu, Jun 11, 2026 at 07:56:12AM +0930, Qu Wenruo wrote:
> From: Weiming Shi <bestswngs@gmail.com>
>=20
> [BUG]
> A crafted btrfs image can trigger the following crash:
>=20
>  BUG: unable to handle page fault for address: ffffd1dc42884000
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  CPU: 9 UID: 0 PID: 1034 Comm: poc Not tainted 7.1.0-rc4-custom+ #383 PRE=
EMPT(full)  46af0a92938a63be7132e0dfd71e62327c51d5c2
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2=
022
>  RIP: 0010:memcpy+0xc/0x10
>  Call Trace:
>   <TASK>
>   read_extent_buffer+0xe4/0x100 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1=
f92a8f]
>   btrfs_get_name+0x15e/0x1e0 [btrfs 3cf0785dd58fec8c5ff84633b772f17ce1f92=
a8f]
>   reconnect_path+0x165/0x390
>   exportfs_decode_fh_raw+0x337/0x400
>   ? drop_caches_sysctl_handler+0xb0/0xb0
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  RIP: 0010:memcpy+0xc/0x10
>  Kernel panic - not syncing: Fatal exception
>=20
> [CAUSE]
> The crafted image has the following corrupted INODE_REF item:
>=20
> 	item 9 key (258 INODE_REF 257) itemoff 11544 itemsize 4106
> 		index 2 namelen 4096 name: d\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\0=
00\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\=
000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000=
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\00=
0\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000
>=20
> The itemsize matches the namelen, but the namelen is 4096, way larger
> than normal name length limit (BTRFS_NAME_LEN, 255).
>=20
> Meanwhile the memory of the @name is only 255 byte sized, this will cause
> out-of-boundary access, and cause the above crash.
>=20
> [FIX]
> Add extra namelen verification for INODE_REF, just like what we have
> done in ROOT_REF checks.
>=20
> Now the crafted image can be rejected gracefully:
>=20
>  BTRFS critical (device dm-2): corrupt leaf: root=3D5 block=3D30572544 sl=
ot=3D14 ino=3D259, invalid inode ref name length, has 4096 expect [1, 255]
>  BTRFS error (device dm-2): read time tree block corruption detected on l=
ogical 30572544 mirror 2
>=20
> Link: https://lore.kernel.org/linux-btrfs/aik0hEV6ehKx6Ldv@Air.local/
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> [ Rebase, add a Link: tag, add an simple cause analyze ]
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I don't see the patch in for-next, please add it.
