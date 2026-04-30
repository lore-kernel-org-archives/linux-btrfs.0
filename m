Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A041B2DF137
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562728; cv=none; b=KeB4icVawnUAs0NvSS0xuoscZoCaaSfXyG/DXPeS7FiK8qhR2vUPzJLKu/9x0LgkmTWOIbXQj+rL4KbTxvC2yQ1EgCHkvR2dth4L0NDM1kEjsru3C7OtrsjcsUjhtdC3oK89QjfhDzviz2UML7aN6e5P3QD0+YVUYxVV5JU4wEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562728; c=relaxed/simple;
	bh=jYfM0DEjnYEAq5dwLPMoUIMSr8OYgF5IEaVBSALSHjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv38cZmH77nDd1tJdiZKO68WaPhOXohuaPMTCTkvkcVYhX0tuuPFS93PRi2nI2R7vDsoIjlCEh2LuPnKdLTf6O9C6kMai8k47xtxky/2gM86mFgr1SrEfPpUfU6CgnWg9C83ikxN59QIF3DrEEF4F3aw65f4rnri4mKQ/ttn8Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 38E1A6A862;
	Thu, 30 Apr 2026 15:25:20 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32D5A593B0;
	Thu, 30 Apr 2026 15:25:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3nRnDGB082kuKwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 30 Apr 2026 15:25:20 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: use on stack backref iterator in build_backref_tree()
Date: Thu, 30 Apr 2026 17:25:01 +0200
Message-ID: <b6b710b079c8be4766519c11cdf98275af3a6276.1777561536.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777561536.git.dsterba@suse.com>
References: <cover.1777561536.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 38E1A6A862
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

The iterator is used only once and within build_backref_tree() so we can
avoid one allocation and place it on stack.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/backref.c    | 22 +++++++---------------
 fs/btrfs/backref.h    |  4 ++--
 fs/btrfs/relocation.c | 13 ++++++-------
 3 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 303f6cfc97c10d..0abcec0ceead0c 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2814,25 +2814,17 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
 	return ifp;
 }
 
-struct btrfs_backref_iter *btrfs_backref_iter_alloc(void)
+int btrfs_backref_iter_init(struct btrfs_backref_iter *iter)
 {
-	struct btrfs_backref_iter *ret;
-
-	ret = kzalloc_obj(*ret, GFP_NOFS);
-	if (!ret)
-		return NULL;
-
-	ret->path = btrfs_alloc_path();
-	if (!ret->path) {
-		kfree(ret);
-		return NULL;
-	}
+	iter->path = btrfs_alloc_path();
+	if (!iter->path)
+		return -ENOMEM;
 
 	/* Current backref iterator only supports iteration in commit root */
-	ret->path->search_commit_root = true;
-	ret->path->skip_locking = true;
+	iter->path->search_commit_root = true;
+	iter->path->skip_locking = true;
 
-	return ret;
+	return 0;
 }
 
 static void btrfs_backref_iter_release(struct btrfs_backref_iter *iter)
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 96717460e2e04d..179791de6b1955 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -284,8 +284,6 @@ struct btrfs_backref_iter {
 	u32 end_ptr;
 };
 
-struct btrfs_backref_iter *btrfs_backref_iter_alloc(void);
-
 /*
  * For metadata with EXTENT_ITEM key (non-skinny) case, the first inline data
  * is btrfs_tree_block_info, without a btrfs_extent_inline_ref header.
@@ -301,6 +299,8 @@ static inline bool btrfs_backref_has_tree_block_info(
 	return false;
 }
 
+int btrfs_backref_iter_init(struct btrfs_backref_iter *iter);
+
 int btrfs_backref_iter_start(struct btrfs_fs_info *fs_info, struct btrfs_backref_iter *iter, u64 bytenr);
 
 int btrfs_backref_iter_next(struct btrfs_fs_info *fs_info, struct btrfs_backref_iter *iter);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 843fdcacb31555..67af02e732d0ce 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -407,7 +407,7 @@ static noinline_for_stack struct btrfs_backref_node *build_backref_tree(
 			struct reloc_control *rc, struct btrfs_key *node_key,
 			int level, u64 bytenr)
 {
-	struct btrfs_backref_iter *iter;
+	struct btrfs_backref_iter iter;
 	struct btrfs_backref_cache *cache = &rc->backref_cache;
 	/* For searching parent of TREE_BLOCK_REF */
 	struct btrfs_path *path;
@@ -416,9 +416,9 @@ static noinline_for_stack struct btrfs_backref_node *build_backref_tree(
 	struct btrfs_backref_edge *edge;
 	int ret;
 
-	iter = btrfs_backref_iter_alloc();
-	if (!iter)
-		return ERR_PTR(-ENOMEM);
+	ret = btrfs_backref_iter_init(&iter);
+	if (ret < 0)
+		return ERR_PTR(ret);
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
@@ -435,7 +435,7 @@ static noinline_for_stack struct btrfs_backref_node *build_backref_tree(
 
 	/* Breadth-first search to build backref cache */
 	do {
-		ret = btrfs_backref_add_tree_node(trans, cache, path, iter,
+		ret = btrfs_backref_add_tree_node(trans, cache, path, &iter,
 						  node_key, cur);
 		if (ret < 0)
 			goto out;
@@ -460,8 +460,7 @@ static noinline_for_stack struct btrfs_backref_node *build_backref_tree(
 	if (handle_useless_nodes(rc, node))
 		node = NULL;
 out:
-	btrfs_free_path(iter->path);
-	kfree(iter);
+	btrfs_free_path(iter.path);
 	btrfs_free_path(path);
 	if (ret) {
 		btrfs_backref_error_cleanup(cache, node);
-- 
2.53.0

