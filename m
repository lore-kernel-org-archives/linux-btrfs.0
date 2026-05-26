Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518383E1699
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 11:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779795021; cv=none; b=G+81b1PHpdY/x6bo8fo3NS5wcz4RLwoIig+NquNfLF0Nqu7+zvEMZ7t5UF0vPabn08QnX0wHshLwjOegG6LkLkd+TkTyeJ+/3Slmhp6OYQG2+8VKi/CjN/xs9s9JHqI776a+01vjugLTPsR3JF6cCgqs6AeG0Ew2TLNSTga0Sew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779795021; c=relaxed/simple;
	bh=GUg9U+XftMc68LOyjgKlOy5QYYE88iTCxlOt8byKuMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LI3oGDR0UUB4EuLBnIe7SxqysDxfDn0bRg2hb83egIPbX1tOCKozEctSpH7hFUSiEKcpscfDAHRNsCh+UKMVqJ6e2ZdOybCpKH0pRVueE+Bkb5LBf3L0pbY+qbfOnjZshgxsu5iec6/1FPEUEWvyB1TCGcFEOoSz9+DXNOFSh4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uI5QVDj4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XO2ySNSK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uI5QVDj4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XO2ySNSK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7967375D34;
	Tue, 26 May 2026 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779795012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SPu/mvwqqNPJ+kgTWY40ilpgGLxo38+l6mL1+o9L2Bw=;
	b=uI5QVDj4wY1pY99nmFY/MT6+lycG3LfozcNFftFwH/cYV50mO3gun76fMGr4+diOUTMXm2
	W0eU2ijk7SeWHtyGeFyM6pDWvgIHug0BtBYdO81sGBOxvC7GJgROXcn6eN1Oj7+5p79Pr6
	qnCA+fjzNZEuxa/M0FM9SneokhKL93k=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779795011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SPu/mvwqqNPJ+kgTWY40ilpgGLxo38+l6mL1+o9L2Bw=;
	b=XO2ySNSKGQqdNeXMUrULIuZ5G4HdeMgUoQ9de4WjLRdJWDDm8y6VWFacqSNYcCoP499PUM
	xjHWgkCZQPWobR/4uv2gYROFbkFyrlpu8gcYfgaSxw57QiedbPlF3urlUDxrKYrqYtedAx
	NHNT2uUiND7rTmLd+UaDB9raLVUcwUw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 723C45A1A4;
	Tue, 26 May 2026 11:30:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CondG0OEFWp3ewAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 26 May 2026 11:30:11 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: send: pass bool for pending_move and refs_processed parameters
Date: Tue, 26 May 2026 13:29:49 +0200
Message-ID: <20260526112949.124881-1-dsterba@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Level: 
X-Spam-Flag: NO

We're passing simple indicators as int, switch them to bool types.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 89d72d8cb85fdf..a264f909d0b15c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4157,7 +4157,7 @@ static int rename_current_inode(struct send_ctx *sctx,
 /*
  * This does all the move/link/unlink/rmdir magic.
  */
-static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
+static int process_recorded_refs(struct send_ctx *sctx, bool *pending_move)
 {
 	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
 	int ret = 0;
@@ -4417,7 +4417,7 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 				goto out;
 			if (ret == 1) {
 				can_rename = false;
-				*pending_move = 1;
+				*pending_move = true;
 			}
 		}
 
@@ -4428,7 +4428,7 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 				goto out;
 			if (ret == 1) {
 				can_rename = false;
-				*pending_move = 1;
+				*pending_move = true;
 			}
 		}
 
@@ -4793,7 +4793,7 @@ static int process_all_refs(struct send_ctx *sctx,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	iterate_inode_ref_t cb;
-	int pending_move = 0;
+	bool pending_move = false;
 
 	path = alloc_path_for_send();
 	if (!path)
@@ -6524,8 +6524,7 @@ static int process_all_extents(struct send_ctx *sctx)
 }
 
 static int process_recorded_refs_if_needed(struct send_ctx *sctx, bool at_end,
-					   int *pending_move,
-					   int *refs_processed)
+					   bool *pending_move, bool *refs_processed)
 {
 	int ret;
 
@@ -6543,7 +6542,7 @@ static int process_recorded_refs_if_needed(struct send_ctx *sctx, bool at_end,
 	if (ret < 0)
 		return ret;
 
-	*refs_processed = 1;
+	*refs_processed = true;
 	return 0;
 }
 
@@ -6563,8 +6562,8 @@ static int finish_inode_if_needed(struct send_ctx *sctx, bool at_end)
 	int need_chown = 0;
 	bool need_fileattr = false;
 	int need_truncate = 1;
-	int pending_move = 0;
-	int refs_processed = 0;
+	bool pending_move = false;
+	bool refs_processed = false;
 
 	if (sctx->ignore_cur_inode)
 		return 0;
-- 
2.54.0

