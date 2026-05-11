Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD201DCB24
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778461048; cv=none; b=RVBNlbXxlr3/mzEiT8HexrWmkRqi9IMnIWnoXY3bfQpfcn6P7TFoxZECcGbGPxy+OrD0/EaG8ZUtOZ/2C1j+ndHw5KBME/oUpyk2e4S+UUJfNdG15QEJakSnoExQaCtmeBemyZV4N2OOMONpyQEXmhuCR+AoOkoZIjhZs66pLXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778461048; c=relaxed/simple;
	bh=MMv/98FyvUVeQBxmqiQqkgbbZYuRp1Z0ITICHmfeers=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iH4XWsxjVceKPME64z2lEJM1QhO9vUm18HGWq9leLtip3a1VXy40qB3kvNcYje3R4T+dg/h3t9tOmoLw8z/fjQrLwE/bdD3ByJ8jY7bHsmDGXX5RfZtjpvdTWbPdYUeprnIZ+8NedNcS+1UVqOBTb0grXpY1zRxNZvpJBz5dIOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KSn2kKcy; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KSn2kKcy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KSn2kKcy";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KSn2kKcy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B8CA05CC49
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778461040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMGv2ehxNtSpLJ9Zn0LJuJPGkjIzYTjbIyyK5bNzQJU=;
	b=KSn2kKcyj8bN4o8KwtVbbAAm6CQdfJKl+59z8dasO3LDErKK8qDzUhU7/T/dV+M2TDF7SC
	aEPs7+AoYS4pV9NCIJU/IVL7ZkmJmRovD0lo9TpEohzeOKHZm49ibm759ci59daiwy1Hqd
	F3DkkD25ZSMCYiwXI5YQXkwgEv6rmho=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KSn2kKcy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778461040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMGv2ehxNtSpLJ9Zn0LJuJPGkjIzYTjbIyyK5bNzQJU=;
	b=KSn2kKcyj8bN4o8KwtVbbAAm6CQdfJKl+59z8dasO3LDErKK8qDzUhU7/T/dV+M2TDF7SC
	aEPs7+AoYS4pV9NCIJU/IVL7ZkmJmRovD0lo9TpEohzeOKHZm49ibm759ci59daiwy1Hqd
	F3DkkD25ZSMCYiwXI5YQXkwgEv6rmho=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2F17593A3
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YIT9LG8pAWp3OwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 00:57:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: tree-checker: ensure free space tree entries won't overflow
Date: Mon, 11 May 2026 10:26:50 +0930
Message-ID: <77ed7a079eb04f99dfc3927423bd4e24dd950ec7.1778460959.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778460959.git.wqu@suse.com>
References: <cover.1778460959.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: B8CA05CC49
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

Add an extra check to ensure the free space extent/bitmap and space info
keys won't overflow.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 4d6dde876c6d..ca9bb695f826 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2071,6 +2071,7 @@ static int check_free_space_info(struct extent_buffer *leaf, struct btrfs_key *k
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	struct btrfs_free_space_info *fsi;
 	const u32 blocksize = fs_info->sectorsize;
+	u64 end;
 	u32 flags;
 
 	if (unlikely(!IS_ALIGNED(key->objectid, blocksize))) {
@@ -2085,6 +2086,12 @@ static int check_free_space_info(struct extent_buffer *leaf, struct btrfs_key *k
 			    blocksize, BTRFS_KEY_FMT_VALUE(key));
 		return -EUCLEAN;
 	}
+	if (unlikely(check_add_overflow(key->objectid, key->offset, &end))) {
+		generic_err(leaf, slot,
+			    "free space info key overflows, has " BTRFS_KEY_FMT,
+			    BTRFS_KEY_FMT_VALUE(key));
+		return -EUCLEAN;
+	}
 	if (unlikely(btrfs_item_size(leaf, slot) !=
 		     sizeof(struct btrfs_free_space_info))) {
 		generic_err(leaf, slot,
@@ -2117,6 +2124,7 @@ static int check_free_space_common_key(struct extent_buffer *leaf, struct btrfs_
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	const u32 blocksize = fs_info->sectorsize;
 	const char *type_str = (key->type == BTRFS_FREE_SPACE_EXTENT_KEY) ? "extent" : "bitmap";
+	u64 end;
 
 	if (unlikely(!IS_ALIGNED(key->objectid, blocksize))) {
 		generic_err(leaf, slot,
@@ -2134,6 +2142,12 @@ static int check_free_space_common_key(struct extent_buffer *leaf, struct btrfs_
 		generic_err(leaf, slot, "free space %s length is 0", type_str);
 		return -EUCLEAN;
 	}
+	if (unlikely(check_add_overflow(key->objectid, key->offset, &end))) {
+		generic_err(leaf, slot,
+			    "free space %s end overflow, have objectid %llu offset %llu",
+			    type_str, key->objectid, key->offset);
+		return -EUCLEAN;
+	}
 	return 0;
 }
 
-- 
2.54.0

