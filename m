Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE738282F30
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562723; cv=none; b=ZsSDEnrlfeq5bklHlVoz1ljt7FMn4ZGK9ZX/qBmUmV6d3ZPS1OTbXmPqCYcnxCmFbg95LRWXS/8mDRbYUu6GI5v2Xj6uzUScp0Q91mye7IPK7G3z5GFgyiz7L9FcH4Q1Y90EJmM+BdHd/duzt5QCSV1aqBhtMou3HfKQaN/Fe2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562723; c=relaxed/simple;
	bh=mQm/s+FeZweAEwoU5nWdSVdMDi/mxBK6BjEhalZ0i68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvViB8MxQh6M1JG9/G39dxXSAxRkQWv+oJ7OlJSCF7tUs1bVdUnWGtEfkHrlDPWUujf9Q2VLdwY1KqShQYCgq3lgi0S0p1U7UZlMp5HpV/oX1rwe9/m8kL1Zj7qQ6Ri1UagXB4rKTt8v+LLarfAySpww/uLaSDp57jYPHeD33kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F10ED6A860;
	Thu, 30 Apr 2026 15:25:17 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA99A593B0;
	Thu, 30 Apr 2026 15:25:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IXFEOV1082krKwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 30 Apr 2026 15:25:17 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: remove fs_info from struct btrfs_backref_iter
Date: Thu, 30 Apr 2026 17:25:00 +0200
Message-ID: <547368d2e5c55c5a87c3207d4700051761e23617.1777561536.git.dsterba@suse.com>
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
X-Rspamd-Queue-Id: F10ED6A860
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

The fs_info is available everywhere and we don't need to store it inside
a structure that is used within one function only, which is
build_backref_tree(). The size of btrfs_backref_iter is now 48 bytes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/backref.c    | 19 ++++++++-----------
 fs/btrfs/backref.h    |  7 +++----
 fs/btrfs/relocation.c |  2 +-
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 2c25e5d86f3e42..303f6cfc97c10d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2814,7 +2814,7 @@ struct inode_fs_paths *init_ipath(s32 total_bytes, struct btrfs_root *fs_root,
 	return ifp;
 }
 
-struct btrfs_backref_iter *btrfs_backref_iter_alloc(struct btrfs_fs_info *fs_info)
+struct btrfs_backref_iter *btrfs_backref_iter_alloc(void)
 {
 	struct btrfs_backref_iter *ret;
 
@@ -2831,7 +2831,6 @@ struct btrfs_backref_iter *btrfs_backref_iter_alloc(struct btrfs_fs_info *fs_inf
 	/* Current backref iterator only supports iteration in commit root */
 	ret->path->search_commit_root = true;
 	ret->path->skip_locking = true;
-	ret->fs_info = fs_info;
 
 	return ret;
 }
@@ -2846,9 +2845,8 @@ static void btrfs_backref_iter_release(struct btrfs_backref_iter *iter)
 	memset(&iter->cur_key, 0, sizeof(iter->cur_key));
 }
 
-int btrfs_backref_iter_start(struct btrfs_backref_iter *iter, u64 bytenr)
+int btrfs_backref_iter_start(struct btrfs_fs_info *fs_info, struct btrfs_backref_iter *iter, u64 bytenr)
 {
-	struct btrfs_fs_info *fs_info = iter->fs_info;
 	struct btrfs_root *extent_root = btrfs_extent_root(fs_info, bytenr);
 	struct btrfs_path *path = iter->path;
 	struct btrfs_extent_item *ei;
@@ -2963,7 +2961,7 @@ static bool btrfs_backref_iter_is_inline_ref(struct btrfs_backref_iter *iter)
  * Return >0 if there is no extra backref for this bytenr.
  * Return <0 if there is something wrong happened.
  */
-int btrfs_backref_iter_next(struct btrfs_backref_iter *iter)
+int btrfs_backref_iter_next(struct btrfs_fs_info *fs_info, struct btrfs_backref_iter *iter)
 {
 	struct extent_buffer *eb = iter->path->nodes[0];
 	struct btrfs_root *extent_root;
@@ -2997,10 +2995,9 @@ int btrfs_backref_iter_next(struct btrfs_backref_iter *iter)
 	}
 
 	/* We're at keyed items, there is no inline item, go to the next one */
-	extent_root = btrfs_extent_root(iter->fs_info, iter->bytenr);
+	extent_root = btrfs_extent_root(fs_info, iter->bytenr);
 	if (unlikely(!extent_root)) {
-		btrfs_err(iter->fs_info,
-			  "missing extent root for extent at bytenr %llu",
+		btrfs_err(fs_info, "missing extent root for extent at bytenr %llu",
 			  iter->bytenr);
 		return -EUCLEAN;
 	}
@@ -3454,7 +3451,7 @@ int btrfs_backref_add_tree_node(struct btrfs_trans_handle *trans,
 	struct btrfs_backref_node *exist;
 	int ret;
 
-	ret = btrfs_backref_iter_start(iter, cur->bytenr);
+	ret = btrfs_backref_iter_start(trans->fs_info, iter, cur->bytenr);
 	if (ret < 0)
 		return ret;
 	/*
@@ -3462,7 +3459,7 @@ int btrfs_backref_add_tree_node(struct btrfs_trans_handle *trans,
 	 * stored in it, but fetch it from the tree block
 	 */
 	if (btrfs_backref_has_tree_block_info(iter)) {
-		ret = btrfs_backref_iter_next(iter);
+		ret = btrfs_backref_iter_next(trans->fs_info, iter);
 		if (ret < 0)
 			goto out;
 		/* No extra backref? This means the tree block is corrupted */
@@ -3492,7 +3489,7 @@ int btrfs_backref_add_tree_node(struct btrfs_trans_handle *trans,
 		exist = NULL;
 	}
 
-	for (; ret == 0; ret = btrfs_backref_iter_next(iter)) {
+	for (; ret == 0; ret = btrfs_backref_iter_next(trans->fs_info, iter)) {
 		struct extent_buffer *eb;
 		struct btrfs_key key;
 		int type;
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 1d009b0f4c699a..96717460e2e04d 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -278,14 +278,13 @@ struct prelim_ref {
 struct btrfs_backref_iter {
 	u64 bytenr;
 	struct btrfs_path *path;
-	struct btrfs_fs_info *fs_info;
 	struct btrfs_key cur_key;
 	u32 item_ptr;
 	u32 cur_ptr;
 	u32 end_ptr;
 };
 
-struct btrfs_backref_iter *btrfs_backref_iter_alloc(struct btrfs_fs_info *fs_info);
+struct btrfs_backref_iter *btrfs_backref_iter_alloc(void);
 
 /*
  * For metadata with EXTENT_ITEM key (non-skinny) case, the first inline data
@@ -302,9 +301,9 @@ static inline bool btrfs_backref_has_tree_block_info(
 	return false;
 }
 
-int btrfs_backref_iter_start(struct btrfs_backref_iter *iter, u64 bytenr);
+int btrfs_backref_iter_start(struct btrfs_fs_info *fs_info, struct btrfs_backref_iter *iter, u64 bytenr);
 
-int btrfs_backref_iter_next(struct btrfs_backref_iter *iter);
+int btrfs_backref_iter_next(struct btrfs_fs_info *fs_info, struct btrfs_backref_iter *iter);
 
 /*
  * Backref cache related structures
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9cbae3cf8bdd1e..843fdcacb31555 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -416,7 +416,7 @@ static noinline_for_stack struct btrfs_backref_node *build_backref_tree(
 	struct btrfs_backref_edge *edge;
 	int ret;
 
-	iter = btrfs_backref_iter_alloc(rc->extent_root->fs_info);
+	iter = btrfs_backref_iter_alloc();
 	if (!iter)
 		return ERR_PTR(-ENOMEM);
 	path = btrfs_alloc_path();
-- 
2.53.0

