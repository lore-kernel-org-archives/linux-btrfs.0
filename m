Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267206;
	b=EuBCQpFh5F0P2nqWnti3v+l2F6sePNTmpzjVPYUQq8MwUElNUE5r5DWBnsYhMWHiiomp
	 UjJaJduQQ98BdfPy9Jzuktq0bevmZA8dfnSaQZs+iA30WijLDx68bXdZuA3b2FquJr4aH
	 //ZBHpg6gLGZwEWyzIdOqwlWYzBnnByg4Noq5m3LJsqQt3rUN4FYdfWOMl6RDcJ5ohPmm
	 1z/JzSyHeX8mCnIG6zqyGFrY4WDq/weMD9GXzyFCqt1ZYZTIbNqqB9eOVUTCVc8MR9UDy
	 dAn6og3FMHyVpVaSuxk1tiG++rwN7zBKZh+DcI0W9mg0Tb623r1OjbbVIAp8kv3wFkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267206;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=R5v+rxWvaXnx769LA4koUjV1KRWl3EkRVVNZaxHQPi8=;
	b=SlodighiVgiIAqzRV0wlel61s1fqU2Az3yD5RgKf83gvbHHY3IYkvoAAMN4vIx2Xgufi
	 6+913Q14jV//fyJmuJKpZKgNOBnqVVNoj+I6Hrfwg7zRARIxp+5j5KIxsph5p8atIUBQ9
	 pNDhv4CtnbZNU5RbM3XdhRSjvXtCtni/fw+pxX5nUmENKBHjldQVaNOkPtoLYT5sXYRIb
	 puqTg4796SdHOer4mLmd2EWuB7Ax+uw22cWWhu0I8pQ3y8+jEFWZMdaxMvMSWz1QMsv0d
	 6KeiNB+Hf/7BhYe/qWo3Si8vmJv3cn+R2Ym5XNNWjbuSHU0SdVxH+BaWbS1J4cIPy9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=FlSn0Hi1;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=FlSn0Hi1;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AA6606A323
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89AA6606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=FlSn0Hi1;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=FlSn0Hi1
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E6D9221DD9
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5v+rxWvaXnx769LA4koUjV1KRWl3EkRVVNZaxHQPi8=;
	b=FlSn0Hi1xqfDwUEVdfhLZpk+ybYbUauxDL6FMs/7mtfX5Ey5xXMbhe+dZBTgNsZtijrDMG
	niZ5OSaNuB7kAE8Ti5l31cPTEcMK94Yo+pR/v2czEfFordW7hHgjbVm4syQrBaj0LERRdu
	GDyVq1zZ+VY7VaTvD20ZEictnhEGNxc=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=FlSn0Hi1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R5v+rxWvaXnx769LA4koUjV1KRWl3EkRVVNZaxHQPi8=;
	b=FlSn0Hi1xqfDwUEVdfhLZpk+ybYbUauxDL6FMs/7mtfX5Ey5xXMbhe+dZBTgNsZtijrDMG
	niZ5OSaNuB7kAE8Ti5l31cPTEcMK94Yo+pR/v2czEfFordW7hHgjbVm4syQrBaj0LERRdu
	GDyVq1zZ+VY7VaTvD20ZEictnhEGNxc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D30A713419
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fpy8FP0V42o+FwAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs-progs: sync btrfs_translate_remap() to fix a path leak
Date: Thu, 29 Oct 2026 20:16:13 +1030
Message-ID: <4429fe97556444606503624edbf0f9e2914da241.1793266694.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793266694.git.wqu@suse.com>
References: <cover.1793266694.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: E6D9221DD9
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

In the current implementation, if btrfs_next_leaf() returned 1, the
function returned without freeing the path.

Fix it by syncing the code from kernel, which do a key search using
(*logical, -1, -1), then moving to the previous slot, which should be
safer than the current one.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/volumes.c | 55 ++++++++++-------------------------------
 1 file changed, 13 insertions(+), 42 deletions(-)

diff --git a/kernel-shared/volumes.c b/kernel-shared/volumes.c
index e2b6708ad872..fedcaa5f9216 100644
--- a/kernel-shared/volumes.c
+++ b/kernel-shared/volumes.c
@@ -2098,75 +2098,46 @@ static int btrfs_translate_remap(struct btrfs_fs_info *fs_info, u64 *logical, u6
 	struct btrfs_key key, found_key;
 	struct extent_buffer *leaf;
 	struct btrfs_remap_item *remap;
-	struct btrfs_path *path;
+	BTRFS_PATH_AUTO_FREE(path);
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
 
 	key.objectid = *logical;
-	key.type = BTRFS_IDENTITY_REMAP_KEY;
-	key.offset = 0;
+	key.type = (u8)-1;
+	key.offset = (u64)-1;
 
 	ret = btrfs_search_slot(NULL, fs_info->remap_root, &key, path, 0, 0);
-	if (ret < 0) {
-		btrfs_free_path(path);
+	if (ret < 0)
 		return ret;
-	}
 
 	leaf = path->nodes[0];
+	if (path->slots[0] == 0)
+		return -ENOENT;
 
-	if (path->slots[0] >= btrfs_header_nritems(leaf)) {
-		ret = btrfs_next_leaf(fs_info->remap_root, path);
-		if (ret < 0) {
-			btrfs_free_path(path);
-			return ret;
-		}
-
-		leaf = path->nodes[0];
-	}
+	path->slots[0]--;
 
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
-	if (found_key.objectid > *logical) {
-		if (path->slots[0] == 0) {
-			ret = btrfs_prev_leaf(fs_info->remap_root, path);
-			if (ret) {
-				if (ret == 1)
-					ret = -ENOENT;
-				return ret;
-			}
-
-			leaf = path->nodes[0];
-		} else {
-			path->slots[0]--;
-		}
-
-		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-	}
-
-	if (found_key.type != BTRFS_REMAP_KEY && found_key.type != BTRFS_IDENTITY_REMAP_KEY) {
-		btrfs_free_path(path);
+	if (found_key.type != BTRFS_REMAP_KEY &&
+	    found_key.type != BTRFS_IDENTITY_REMAP_KEY) {
 		return -ENOENT;
 	}
 
-	if (found_key.objectid > *logical || found_key.objectid + found_key.offset <= *logical) {
-		btrfs_free_path(path);
+	if (found_key.objectid > *logical ||
+	    found_key.objectid + found_key.offset <= *logical) {
 		return -ENOENT;
 	}
 
 	if (*logical + *length > found_key.objectid + found_key.offset)
 		*length = found_key.objectid + found_key.offset - *logical;
 
-	if (found_key.type == BTRFS_IDENTITY_REMAP_KEY) {
-		btrfs_free_path(path);
+	if (found_key.type == BTRFS_IDENTITY_REMAP_KEY)
 		return 0;
-	}
 
 	remap = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_remap_item);
-	*logical = *logical - found_key.objectid + btrfs_remap_address(leaf, remap);
-
-	btrfs_free_path(path);
+	*logical += btrfs_remap_address(leaf, remap) - found_key.objectid;
 
 	return 0;
 }
-- 
2.56.0

