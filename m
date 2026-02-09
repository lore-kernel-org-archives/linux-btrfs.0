Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAB440757A
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Feb 2026 19:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770664305; cv=none; b=TSQw3owRXEBUjMFjPiw3N43HhgVlOy2YMGC8tpRkIsOg1f+3Gsl8LUvOIFqQLZPZwkO1hSNDyyP4tYdBbpPGS2zZrgqkW+SVB0hySaxlF6kzvY2PjFIK8ZilevFTLM5w6lY6mnukuPn4PrxLmkMKx77YRGBFJhEvn0Tka3FTZQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770664305; c=relaxed/simple;
	bh=pvKUvij1U5MtZKKj9uAg0M8irNxsgGVLVyxiv+qSbtk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EPSeOcDkUWZD1ZuH4ns4bjsrirYgFj3RTmFnbj1Zv1IKJd2iQ7jfkuAESXvygVvFEGboz0zfoaKWypaKvKs/ASclDehvCpF103mlrwFad0EuHmpuCY/6GADtYSCD25VrZlk5ClsxNo2ydOwTcLFBpXZlqCPf34D0+Hl4QNB5l2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RtEQnw8Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=otC1Q+NF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RtEQnw8Y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=otC1Q+NF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RtEQnw8Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="otC1Q+NF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RtEQnw8Y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="otC1Q+NF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 51BCC5BD12
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Feb 2026 19:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770664303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=PBQzQ+6nZQjuhDzIEnxhDmOvzFRDcifs7xjiydCNH0w=;
	b=RtEQnw8YJmduCXoHZ/Vg73dX4peCEKVDnW7+o/khitfkgfnTjUZ0AW/9uJmu7aiOeHlaDn
	w7zKnCS93VU3Xu8/fBy3HrRCxz/L9Vqz+HSeF02gMBSR+DrJtM4Y9VRaYk7y5ooc+ywfyl
	oe1RNmoawBB+YR5u2p4i373Slm11joo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770664303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=PBQzQ+6nZQjuhDzIEnxhDmOvzFRDcifs7xjiydCNH0w=;
	b=otC1Q+NF8ZbLjXXJvSYRiDeNdX+3oTp1MpliLYGSGw1RsaxKAvK0qQXkUzsstpfw6UtN1B
	1wC7T5Y0r+EZEmDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770664303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=PBQzQ+6nZQjuhDzIEnxhDmOvzFRDcifs7xjiydCNH0w=;
	b=RtEQnw8YJmduCXoHZ/Vg73dX4peCEKVDnW7+o/khitfkgfnTjUZ0AW/9uJmu7aiOeHlaDn
	w7zKnCS93VU3Xu8/fBy3HrRCxz/L9Vqz+HSeF02gMBSR+DrJtM4Y9VRaYk7y5ooc+ywfyl
	oe1RNmoawBB+YR5u2p4i373Slm11joo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770664303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=PBQzQ+6nZQjuhDzIEnxhDmOvzFRDcifs7xjiydCNH0w=;
	b=otC1Q+NF8ZbLjXXJvSYRiDeNdX+3oTp1MpliLYGSGw1RsaxKAvK0qQXkUzsstpfw6UtN1B
	1wC7T5Y0r+EZEmDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D1CE3EA63
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Feb 2026 19:11:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id II+WOG4ximldVgAAD6G6ig
	(envelope-from <rgoldwyn@suse.de>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2026 19:11:42 +0000
Date: Mon, 9 Feb 2026 14:11:37 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: use inode->i_sb to calculate fs_info
Message-ID: <djynzzkwdfzqq6rks5njvhjexmje2zoofffkx2qtectxlyv53f@r54cgbf5l2b3>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

If overlay is used on top of btrfs, dentry->d_sb translates to overlay's
super block and fsid assignment will lead to a crash.

Use inode->i_sb to calculate btrfs_sb.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 include/trace/events/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 125bdc166bfe..94a197557382 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -772,7 +772,7 @@ TRACE_EVENT(btrfs_sync_file,
 		const struct dentry *dentry = file->f_path.dentry;
 		const struct inode *inode = d_inode(dentry);
 
-		TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
+		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
 		__entry->parent		= btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
 		__entry->datasync	= datasync;
-- 
2.53.0
