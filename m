Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B7937AA6F
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Mar 2026 21:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773610726; cv=none; b=qEQ0DwnQv2SQUvEPQY4jQweInknZYyr1SDmixWnXORE83KhpJaqVQqcrHR5CvgUcq17C33p2imOL/UiDGR7RJr8wnz4iNuI/OlmlCuKK7unLlKfKKsl+5NeAidCrInnCSnDbskmvSqkWv2w8sEmg62zijrae8eLWM3+vc3gmxHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773610726; c=relaxed/simple;
	bh=rUtMz8WyA2yKQjjIE36rA1QdiWXVdA66morA2xXpxLs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rbLAggYzC4t3f9GFdyEyNKWpoLe1hSdROO6Y6t+oBj2fCpUpEIoOon2zWBXOABxUx/a6+cSt9tbRY7yGGbmNHZzO28GQF+PRELUPc0GZxDOxJRJmBBJ1sgNfJI1GNpmN8IWKOb0tbH12EqRupl3cH1+iuyelJsJm49sqXsiUISg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=C/yU6Z7Z; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=C/yU6Z7Z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="C/yU6Z7Z";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="C/yU6Z7Z"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A40E4D208
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Mar 2026 21:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773610723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=S8WJjn1xZqtHAs+U3bNevvBpUfCgV21qG4haUKnZwf0=;
	b=C/yU6Z7ZyX4BkDqlM7YdYsMpqW0mOYFFEIOU7kBRNwrjqo4G6v+q2u0Z9h0NJaBSh5eRSS
	cBuZkYU5YFZXH6QTGDSRJGyd7EiFZMZbCoCzs68j+RtRw4+8nJu/XqgRXdogAvf6ETPo8i
	njY1kK2kfhSAtGT66ESjjhaH9iayhAk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773610723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=S8WJjn1xZqtHAs+U3bNevvBpUfCgV21qG4haUKnZwf0=;
	b=C/yU6Z7ZyX4BkDqlM7YdYsMpqW0mOYFFEIOU7kBRNwrjqo4G6v+q2u0Z9h0NJaBSh5eRSS
	cBuZkYU5YFZXH6QTGDSRJGyd7EiFZMZbCoCzs68j+RtRw4+8nJu/XqgRXdogAvf6ETPo8i
	njY1kK2kfhSAtGT66ESjjhaH9iayhAk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B441B4273B
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Mar 2026 21:38:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mQZZHeImt2kMWgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Mar 2026 21:38:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove @atomic parameter from btrfs_buffer_uptodate()
Date: Mon, 16 Mar 2026 08:08:24 +1030
Message-ID: <188ad91e78cda1fe6430eaf0ae158a5554c2a4c7.1773610691.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

That parameter is introduced by commit b9fab919b748 ("Btrfs: avoid
sleeping in verify_parent_transid while atomic").
At that time we need to lock the extent buffer range inside the io tree,
to avoid content changes thus it may sleep.

But that behavior is no longer there, as later commit 947a629988f1
("btrfs: move tree block parentness check into
validate_extent_buffer()") changed the transid check into the endio
function thus there is no need to lock io tree.

We can remove the @atomic parameter safely now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c       | 2 +-
 fs/btrfs/disk-io.c     | 7 ++-----
 fs/btrfs/disk-io.h     | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/extent_io.c   | 6 +++---
 fs/btrfs/tree-log.c    | 2 +-
 6 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cdd6c1422b53..5c68c541de51 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1499,7 +1499,7 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 			reada_for_search(fs_info, p, parent_level, slot, key->objectid);
 
 		/* first we do an atomic uptodate check */
-		if (btrfs_buffer_uptodate(tmp, check.transid, true, NULL) > 0) {
+		if (btrfs_buffer_uptodate(tmp, check.transid, NULL) > 0) {
 			/*
 			 * Do extra check for first_key, eb can be stale due to
 			 * being cached, read from scrub, or have multiple
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 868afeb37235..75d8ab39601d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -109,7 +109,7 @@ static void csum_tree_block(struct extent_buffer *buf, u8 *result)
  * detect blocks that either didn't get written at all or got written
  * in the wrong place.
  */
-int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid, bool atomic,
+int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid,
 			  const struct btrfs_tree_parent_check *check)
 {
 	if (!extent_buffer_uptodate(eb))
@@ -125,9 +125,6 @@ int btrfs_buffer_uptodate(struct extent_buffer *eb, u64 parent_transid, bool ato
 		return 1;
 	}
 
-	if (atomic)
-		return -EAGAIN;
-
 	if (btrfs_header_generation(eb) != parent_transid) {
 		btrfs_err_rl(eb->fs_info,
 "parent transid verify failed on logical %llu mirror %u wanted %llu found %llu",
@@ -1001,7 +998,7 @@ static struct btrfs_root *read_tree_root_path(struct btrfs_root *tree_root,
 		goto fail;
 	}
 
-	ret = btrfs_buffer_uptodate(root->node, generation, false, &check);
+	ret = btrfs_buffer_uptodate(root->node, generation, &check);
 	if (unlikely(ret <= 0)) {
 		if (ret == 0)
 			ret = -EIO;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 343e332b17c0..9185f8f02eeb 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -107,7 +107,7 @@ static inline struct btrfs_root *btrfs_grab_root(struct btrfs_root *root)
 void btrfs_put_root(struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct btrfs_trans_handle *trans,
 			     struct extent_buffer *buf);
-int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid, bool atomic,
+int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  const struct btrfs_tree_parent_check *check);
 int btrfs_read_extent_buffer(struct extent_buffer *buf,
 			     const struct btrfs_tree_parent_check *check);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a0a0212c5f40..a55b910c755b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5780,7 +5780,7 @@ static int check_next_block_uptodate(struct btrfs_trans_handle *trans,
 
 	generation = btrfs_node_ptr_generation(path->nodes[level], path->slots[level]);
 
-	if (btrfs_buffer_uptodate(next, generation, false, NULL))
+	if (btrfs_buffer_uptodate(next, generation, NULL))
 		return 0;
 
 	check.level = level - 1;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 980f16313e11..56a2c8e01b83 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3905,7 +3905,7 @@ int read_extent_buffer_pages_nowait(struct extent_buffer *eb, int mirror_num,
 	if (extent_buffer_uptodate(eb)) {
 		int ret;
 
-		ret = btrfs_buffer_uptodate(eb, 0, true, check);
+		ret = btrfs_buffer_uptodate(eb, 0, check);
 		if (unlikely(ret <= 0)) {
 			if (ret == 0)
 				ret = -EIO;
@@ -3936,7 +3936,7 @@ int read_extent_buffer_pages_nowait(struct extent_buffer *eb, int mirror_num,
 		int ret;
 
 		clear_extent_buffer_reading(eb);
-		ret = btrfs_buffer_uptodate(eb, 0, true, check);
+		ret = btrfs_buffer_uptodate(eb, 0, check);
 		if (unlikely(ret <= 0)) {
 			if (ret == 0)
 				ret = -EIO;
@@ -4654,7 +4654,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(eb))
 		return;
 
-	if (btrfs_buffer_uptodate(eb, gen, true, NULL)) {
+	if (btrfs_buffer_uptodate(eb, gen, NULL)) {
 		free_extent_buffer(eb);
 		return;
 	}
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6cf2828ba500..de4707b1227e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -457,7 +457,7 @@ static int process_one_buffer(struct extent_buffer *eb,
 			return ret;
 		}
 
-		if (btrfs_buffer_uptodate(eb, gen, false, NULL) && level == 0) {
+		if (btrfs_buffer_uptodate(eb, gen, NULL) && level == 0) {
 			ret = btrfs_exclude_logged_extents(eb);
 			if (ret)
 				btrfs_abort_transaction(trans, ret);
-- 
2.53.0

