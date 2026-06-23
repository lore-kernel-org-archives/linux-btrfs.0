Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2786F3D3CE5
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 11:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782214663; cv=none; b=NqP+feEcGDp574UPrefA4tYb9IpYiPnhod+GehjD+8iSFzsOfzRHvxSnS9I/kB7plynLyK6z9IW6ot/mjHySs9+DjeUDc+Y+xihqFsHMvAn/huSzsLt7Jwk1f6ZRB/bx7n2zylpu5BdwNcMK90+mOReeJoDhOpBvI16k9MPXB/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782214663; c=relaxed/simple;
	bh=sXtAOOOIR5Ag2OXYvWOJHRL54zE1U8sTvHOu+AlHYYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVuwTgZITcmOGgbbYg+jTIiKujkt+lI8DHzylQVFxmlwbVFb26SSjyIdNAg21aZ/9BgULddIQot23P9ttuo93+jegRe9fb/rQagailtH2Al/mou7agSKiEu/CvQZxTrL1sfaB7dpLgHxSJifHSTssw2TuolGy1wjILnZxMJboz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ajftX0fs; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ajftX0fs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ajftX0fs";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ajftX0fs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B35970D9E;
	Tue, 23 Jun 2026 11:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782214659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76q+cCQjdkd1790+HJEpewnzXniT10hPSuip+CsClpg=;
	b=ajftX0fs3xxaXYxCxAnm+YTzL/99xykSf22e2Kj1clZ018YSWdS8auGDeLMc6DOq8mosYe
	3om8fXrfNeJHwdw6O2rL139UH06nzN5L+tf6mfScPvyuyCgjv6yhFgEGdsO7h9P+kjE2MO
	3tqpDVXhiG2Fm+gIwiAj5F7hE6Rll7o=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ajftX0fs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782214659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76q+cCQjdkd1790+HJEpewnzXniT10hPSuip+CsClpg=;
	b=ajftX0fs3xxaXYxCxAnm+YTzL/99xykSf22e2Kj1clZ018YSWdS8auGDeLMc6DOq8mosYe
	3om8fXrfNeJHwdw6O2rL139UH06nzN5L+tf6mfScPvyuyCgjv6yhFgEGdsO7h9P+kjE2MO
	3tqpDVXhiG2Fm+gIwiAj5F7hE6Rll7o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 37BF0779AB;
	Tue, 23 Jun 2026 11:37:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mHh8NgFwOmqDBAAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 23 Jun 2026 11:37:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: reject inline file extents item in get_new_location()
Date: Tue, 23 Jun 2026 21:07:15 +0930
Message-ID: <04f68adabb209bd91b00a51b9cd24618a283ef02.1782214614.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782214614.git.wqu@suse.com>
References: <cover.1782214614.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7B35970D9E
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Commit a6908f88c9da ("btrfs: validate data reloc tree file extent item
members") introduced extra checks on file extent items for data reloc
inodes, but it checks the file extent offset without checking if the file
extent is inlined.

This can lead to either false alerts (as the offset member is inside the
inlined data) or even reading beyond the item range.

This has already triggered a warning in a syzbot report.
Although the root fix is to avoid compression for data reloc inodes, for
the sake of consistency, reject inlined file extents first.

Fixes: a6908f88c9da ("btrfs: validate data reloc tree file extent item members")
Cc: stable@vger.kernel.org
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index e1dd9939f4f1..f5fac0e34494 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -893,6 +893,13 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 	leaf = path->nodes[0];
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
+	if (unlikely(btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)) {
+		btrfs_print_leaf(leaf);
+		btrfs_err(fs_info,
+	"unexpected inline file extent item for data reloc inode %llu key offset %llu",
+			  btrfs_ino(BTRFS_I(reloc_inode)), bytenr);
+		return -EUCLEAN;
+	}
 
 	/*
 	 * The cluster-boundary key searched above is always written by
-- 
2.54.0

