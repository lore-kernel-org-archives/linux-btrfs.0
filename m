Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AC231E849
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 23:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775776627; cv=none; b=j6WNsCovvTh1B6xHVq4NC68qNNgaAj85kEudgFHATXcK6rQa2zJD2qzphKJGlnajdiEYfqBnvKYG9q6M8b89w1J7bu1hcfOMj2e4rs1dPjNNX87XkbfIwf1QqGmGaZRtKMYZ8GExxA+jhqAVQqQ5+7vPFBEH+H2Eze8I4cDrJWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775776627; c=relaxed/simple;
	bh=Smgtr0rqHVKP7mSOsbLjC+BruNa5Unw41MvIcoGSLyo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=J24SfF5CxPAGxxAc6x2llbWoZ3Be8J/78Zr6wAVwMzKERj49mggfzswTUfeGUhtcCmxORT2FS1TbWvyzr6TeVHhSXVAzsHGxaFFIUGuOr0WnXf3UFaoyKXX4eBVc/V6UXl9zus+kIsJorWOontmslGmva6Li6/dy88yY6xu0haU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=agvohQCb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=is1D0rQn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="agvohQCb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="is1D0rQn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E33575BCEF
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 23:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775776624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wZI5Zw2Po0FSPingX8ngB7nti6Y/5DTHh7aVh9/C2Ow=;
	b=agvohQCbPYrU7J/Ms/06SHSZ03dSIiS7ruiAZlcXOHg1e9/jBorx7ZvrtDKIo1ozQzX0OD
	gc6u7WjyTtFghBCenha5JXaN6cEuLRMP8XOirnOruYVvxnpysC2N7B5TUpA3oB+HHILEJ4
	ruekq5tuO+2C/BpvImKZ0x9V91zm+10=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=is1D0rQn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775776623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wZI5Zw2Po0FSPingX8ngB7nti6Y/5DTHh7aVh9/C2Ow=;
	b=is1D0rQnYPxKcXx/cga/NM1Jec0Jqm0bOTN2SGGmjnGsyUMDxwuITpVgSG+06wlpuy+Bsi
	0HLAIyMFi4qoDA9Vf23qPkZYMd4TyAQXoKX+863utOfvpwFKnk5m2qa5onrl0cv+JekpVf
	tO9r6zuA3w0duH2W1jPPnT6N3JiYME8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E59734A0B3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 23:17:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4L28JG4z2GmbdgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 23:17:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: pass a valid btrfs_tree_parent_check when possible
Date: Fri, 10 Apr 2026 08:46:40 +0930
Message-ID: <64f82fae3b8c690a3ad27d21fa80401f62b9e0ac.1775776582.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email]
X-Rspamd-Queue-Id: E33575BCEF
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Commit 6e181cfe2409 ("btrfs: revalidate cached tree blocks on the
uptodate path") introduced the @check parameter for
btrfs_buffer_uptodate() to allow re-validation of a cached extent
buffer.

But there are still call sites that doesn't utilize this parameter,
which exposes them to possible corrupted tree blocks, e.g. an empty
child leaf of a parent node, which should be rejected by
btrfs_verify_level_key() but if @check is NULL such check will be
skipped and cause problems.

Thankfully for a lot of cases there is already an existing @check
structure around and we can pass it directly to btrfs_buffer_uptodate().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.c       | 16 +++++-----------
 fs/btrfs/extent-tree.c | 11 ++++++++---
 fs/btrfs/extent_io.c   |  2 +-
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d70da290bedf..829d8be7f423 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1497,17 +1497,11 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 		if (p->reada == READA_FORWARD_ALWAYS)
 			reada_for_search(fs_info, p, parent_level, slot, key->objectid);
 
-		/* first we do an atomic uptodate check */
-		if (btrfs_buffer_uptodate(tmp, check.transid, NULL) > 0) {
-			/*
-			 * Do extra check for first_key, eb can be stale due to
-			 * being cached, read from scrub, or have multiple
-			 * parents (shared tree blocks).
-			 */
-			if (unlikely(btrfs_verify_level_key(tmp, &check))) {
-				ret = -EUCLEAN;
-				goto out;
-			}
+		/* Check if the cached eb is uptodate. */
+		ret = btrfs_buffer_uptodate(tmp, check.transid, &check);
+		if (unlikely(ret < 0))
+			goto out;
+		if (ret > 0) {
 			*eb_ret = tmp;
 			tmp = NULL;
 			ret = 0;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 391fad41c3b6..5d5b42ea4ade 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5781,16 +5781,21 @@ static int check_next_block_uptodate(struct btrfs_trans_handle *trans,
 
 	generation = btrfs_node_ptr_generation(path->nodes[level], path->slots[level]);
 
-	if (btrfs_buffer_uptodate(next, generation, NULL))
-		return 0;
-
 	check.level = level - 1;
 	check.transid = generation;
 	check.owner_root = btrfs_root_id(root);
 	check.has_first_key = true;
 	btrfs_node_key_to_cpu(path->nodes[level], &check.first_key, path->slots[level]);
 
+	ret = btrfs_buffer_uptodate(next, generation, &check);
+	if (ret > 0)
+		return 0;
 	btrfs_tree_unlock(next);
+	if (ret < 0) {
+		free_extent_buffer(next);
+		return ret;
+	}
+
 	if (level == 1)
 		reada_walk_down(trans, root, wc, path);
 	ret = btrfs_read_extent_buffer(next, &check);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a8887285deda..3f59fb0a9ee5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4648,7 +4648,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 	if (IS_ERR(eb))
 		return;
 
-	if (btrfs_buffer_uptodate(eb, gen, NULL)) {
+	if (btrfs_buffer_uptodate(eb, gen, &check)) {
 		free_extent_buffer(eb);
 		return;
 	}
-- 
2.53.0

