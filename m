Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98659262FF8
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 20:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776197541; cv=none; b=oL77fvBN35SJhpGlg0i+Su9cYe94ETrXKglvr9Z3TCCG7Gqb9hqtSj9emLw6wth8bmXLta1WWS7MwETJlWpKGnGHDsKSJwU3PhggFfbPzdz8/7fPAi/hQa5M+Fr2tRIsb6MXNrYSnw9z8HY2Y1oTbQKiGl0uMbDcTi76RQ8Go/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776197541; c=relaxed/simple;
	bh=MeDR97w6qJVmxkq1iHJqykcVdBVSiRaCVkbtf/4wuc8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DZkfjbABA4z0dr8XTo7KdyCOISpJKjEofKI3mCsgqs7KBCI3vmAtGYKltWk8U9j497C9Gqr446Sar7MUk5stZ+A7ayTRsZ9zR8umOyAdxwSBZKHZIQYsdaO7R/v1c3Ia5sgvSvP1Edj5xyFm1gLbQiRfA+B6ToRYbxRFPP5aCWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tGG2O1j+; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tGG2O1j+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tGG2O1j+";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tGG2O1j+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DEA55BCCD;
	Tue, 14 Apr 2026 20:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776197537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qgf6Rcj52nNWK0wZEL+oMk8GV1QzvhAvs27g5ehqT1w=;
	b=tGG2O1j+rJDi7s/129PMWBfmOw1vlsP07PZsiBBPSaVaxtqz4zohHMjd0GDj8+sl7WSlsg
	hLz60mKTu7ybpr7oCN2JSFWElu+rU/aTjr3MWgm5sLahyX/qLUGohp2plcmkdWI0nBKRrl
	0g6O3CZTNtwlVO9UStxs5th51rkm0hc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=tGG2O1j+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776197537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qgf6Rcj52nNWK0wZEL+oMk8GV1QzvhAvs27g5ehqT1w=;
	b=tGG2O1j+rJDi7s/129PMWBfmOw1vlsP07PZsiBBPSaVaxtqz4zohHMjd0GDj8+sl7WSlsg
	hLz60mKTu7ybpr7oCN2JSFWElu+rU/aTjr3MWgm5sLahyX/qLUGohp2plcmkdWI0nBKRrl
	0g6O3CZTNtwlVO9UStxs5th51rkm0hc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 606E54B612;
	Tue, 14 Apr 2026 20:12:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rl0DF6Gf3mliTQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 14 Apr 2026 20:12:17 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: remove 32bit compat code for VFS inode number
Date: Tue, 14 Apr 2026 22:12:08 +0200
Message-ID: <20260414201208.2749178-1-dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6DEA55BCCD

Commit 0b2600f81cefcd ("treewide: change inode->i_ino from unsigned long
to u64") sets the inode number type to u64 unconditionally, so we can
use it directly as there's no difference on 32bit and 64bit platform. We
used to have a copy of the number in our btrfs_inode.

The size of btrfs_inode on 32bit platform is about 688 bytes (after the
change).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/btrfs_inode.h | 31 -------------------------------
 fs/btrfs/verity.c      |  4 ++--
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 55c272fe5d92a0..3481c91fec7cfb 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -128,15 +128,6 @@ struct btrfs_inode {
 	/* which subvolume this inode belongs to */
 	struct btrfs_root *root;
 
-#if BITS_PER_LONG == 32
-	/*
-	 * The objectid of the corresponding BTRFS_INODE_ITEM_KEY.
-	 * On 64 bits platforms we can get it from vfs_inode.i_ino, which is an
-	 * unsigned long and therefore 64 bits on such platforms.
-	 */
-	u64 objectid;
-#endif
-
 	/* Cached value of inode property 'compression'. */
 	u8 prop_compress;
 
@@ -372,30 +363,11 @@ static inline unsigned long btrfs_inode_hash(u64 objectid,
 	return (unsigned long)h;
 }
 
-#if BITS_PER_LONG == 32
-
-/*
- * On 32 bit systems the i_ino of struct inode is 32 bits (unsigned long), so
- * we use the inode's location objectid which is a u64 to avoid truncation.
- */
-static inline u64 btrfs_ino(const struct btrfs_inode *inode)
-{
-	u64 ino = inode->objectid;
-
-	if (test_bit(BTRFS_INODE_ROOT_STUB, &inode->runtime_flags))
-		ino = inode->vfs_inode.i_ino;
-	return ino;
-}
-
-#else
-
 static inline u64 btrfs_ino(const struct btrfs_inode *inode)
 {
 	return inode->vfs_inode.i_ino;
 }
 
-#endif
-
 static inline void btrfs_get_inode_key(const struct btrfs_inode *inode,
 				       struct btrfs_key *key)
 {
@@ -406,9 +378,6 @@ static inline void btrfs_get_inode_key(const struct btrfs_inode *inode,
 
 static inline void btrfs_set_inode_number(struct btrfs_inode *inode, u64 ino)
 {
-#if BITS_PER_LONG == 32
-	inode->objectid = ino;
-#endif
 	inode->vfs_inode.i_ino = ino;
 }
 
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 0062b3a5578199..983365a7354168 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -458,7 +458,7 @@ static int rollback_verity(struct btrfs_inode *inode)
 	if (ret) {
 		btrfs_handle_fs_error(root->fs_info, ret,
 				"failed to drop verity items in rollback %llu",
-				(u64)inode->vfs_inode.i_ino);
+				inode->vfs_inode.i_ino);
 		goto out;
 	}
 
@@ -472,7 +472,7 @@ static int rollback_verity(struct btrfs_inode *inode)
 		trans = NULL;
 		btrfs_handle_fs_error(root->fs_info, ret,
 			"failed to start transaction in verity rollback %llu",
-			(u64)inode->vfs_inode.i_ino);
+			inode->vfs_inode.i_ino);
 		goto out;
 	}
 	inode->ro_flags &= ~BTRFS_INODE_RO_VERITY;
-- 
2.53.0

