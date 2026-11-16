Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868479;
	b=GHcvQZwIDErcRs+oFXKhFWsYa5XOpdqzzqqG9CHe+0/6eoe2gIUn61q0x6geXmPxF2JJ
	 J1ANiaPOkCl/SdVRVfpd2FB0DI1OAkGDdTWw2Gp0+7jnrgzNi5HWWnqcbRqZftXPOP5kk
	 jfjcDZHkwNzQoIz2N/INucl0COkKKhVbByvKgcnLy8XKrJtn9EI0s8+AWWFQaf5j1RHlY
	 t+Nvhpozri98FcmAqkw01/lCQbWLtSz/sFadMxGeo6K8/VuXQknh+Lji/Y3pKlDV+tZoH
	 1g/LUHlscZsfs25foK2+qNe08rk608AYJj5/pnc1Wd271gzzy+6rwBcse98rGMwEWGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868479;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=M5P0LfOgvXtLxANYpsWPIBs7t2KiZi16+VlUoM7m/xw=;
	b=wgzNbw++YGHuq3gFKTzELhSLSXmvkgBmv83NpErxLH/7jqJCoktOn64cLGAZRpX+YmGc
	 vmTwSEwNA7cAUpm1QKzr15HXxkYBmivP3QniYFCvUI1+N/Lx0wcKQO4S1hwwXN5TugvQq
	 3h3J+/N2WCk/Tp/ig9tmytEL6bF9011GA1f/bzXhbb5P7M0auv4l6HI+kx7dh/UIJJHgw
	 IsY8GgM7mknJ7G1dp4FXAe65S0ZALSd+Wbcvsb0mklnmcPSuGkDH1u1/I+Y9Re+6egogI
	 s6fWJAPxlBjC3Sncb9mvdZLEUJltM/BS5BJ9SrtbqmFjQRYxRxLhdLZY9BpnVjdePew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RvoSnFOD;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RvoSnFOD;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C12606A33F
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 22:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7C12606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RvoSnFOD;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RvoSnFOD
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0000E1F88D
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 22:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794868477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=M5P0LfOgvXtLxANYpsWPIBs7t2KiZi16+VlUoM7m/xw=;
	b=RvoSnFODI8aArbIKNYPWYnIYFEK1NyiswUZ+mcHn/YMjtvbzA2risMwMLw/atTxC9LDVW7
	eUHP1mGd6FqUW/E/VItL5u0QUvuv3wiWg+YuFzzoRnsl1FSop1ewyX+Rfz4lg6OYdtKX5t
	NlyrRwEupavCtih4QLem2Ke/+tZFm4o=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794868477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=M5P0LfOgvXtLxANYpsWPIBs7t2KiZi16+VlUoM7m/xw=;
	b=RvoSnFODI8aArbIKNYPWYnIYFEK1NyiswUZ+mcHn/YMjtvbzA2risMwMLw/atTxC9LDVW7
	eUHP1mGd6FqUW/E/VItL5u0QUvuv3wiWg+YuFzzoRnsl1FSop1ewyX+Rfz4lg6OYdtKX5t
	NlyrRwEupavCtih4QLem2Ke/+tZFm4o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D23D51334C
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 22:34:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tMNxC/uE+2p2ZwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 22:34:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: scrub: fix several races which can lead to UAF
Date: Tue, 17 Nov 2026 09:04:15 +1030
Message-ID: <cover.1794867985.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

This is inspired by the fix in raid56:
https://lore.kernel.org/linux-btrfs/20261116001903.63524-1-mc@raidlab.org/

And there are two similar cases inside scrub.c:
- scrub_stripe::repair_wait
- scrub_stripe::io_wait

The only difference is, the window is much smaller compared to RAID56,
as most scrub_stripe structure have a very long lifespan, as long as the
scrub/replace ioctl. Only the RAID56 data stripes has a shorter
lifespan.

But still it's possible in theory, so here comes the same fix for scrub.

For repair_wait it's pretty straight foward.

For io_wait we have several locations that we submit a batch of bios in
one go, and pending_io may drop to zero during IOs.
Follow the existing behavior by grabbing one extra ref to ensure the
pending_io won't reach zero during IOs.

Qu Wenruo (2):
  btrfs: scrub: fix use-after-free when waking up the repair waiter
  btrfs: scrub: fix use-after-free when waking up the stripe I/O waiter

 fs/btrfs/scrub.c | 116 +++++++++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 39 deletions(-)

-- 
2.56.0

