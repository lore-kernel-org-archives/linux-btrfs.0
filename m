Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475475;
	b=gODe9ETo3Po1xiDV2zUCV5tNaRWtiP0lmy7wsN9rz3WM2qTJMbWeBR6WxP1O1x706lwM
	 tcP7FSLKYgLdryLQfSsv3tgiDZMMc1LplDLyzcSU/ql1Jkqvp9HOiRlB9bx6fHs2Gr6y8
	 vG+WUAszhiLIHxpnb1uzrv+PZleB2QQ+NuB00J7+Pfpm5bvZhsS818TkyMEjfC/KblkzW
	 KGurP5kzUh2UNmpzQVr0DBSkWVI9lRljFxjDhJvJ9lqeTkIrIauklPgoAzut/a0bD+R7K
	 hCoFVk8SJWYBrvRLRRymX1KzASYD7mobaelMxcv+ggsVFwpoJ6LJdoWX1zzyRsyQBdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475475;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=C3uiFWYL2JEsWtzMJEGbYDPZMkeevKcCGQVN12Rehn4=;
	b=MaxKZ8zJbaXAgrAcLLm6Jq7asfr5ySrsfAA+WPOc/KCPmAEC8kx31pAwzz4TESTuQnLx
	 GP4BD1mJIuEPkvM1B6w/OhPUddMWi+54i6O/uZjv+29aT9PX4brHbohSzQ0Df00yTdjyP
	 9vgSGEwt5LR7UY81O3gWoeFbYENyYl7GGozwzfQcGcJxBygf3PpL+XQIubGJOY6d/C4Aq
	 usGWT2kqnE3Cka+4WgoE/WxCfxMgQzXISsg0MwW+MXSfsG+Z4fsPCIdiU4KTbRNAF7xE7
	 lAMSDOTHTbaDzlJB+rmnbkGiw7Olp63y9LdeoV0RGz/zwIzkaVrts/f+xsZwC+EosAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dww9M6fo;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dww9M6fo;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A22D606A331
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A22D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dww9M6fo;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=dww9M6fo
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 68B551F8B2
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795475472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C3uiFWYL2JEsWtzMJEGbYDPZMkeevKcCGQVN12Rehn4=;
	b=dww9M6fokzdCf38jdF2ZvZ/r8xWc6nTMJ5cixEQ9j6lnE5g37Jq+v6qzOk5wZ6HPB2hjqu
	+4j1WWr66qLSMcfwFMyGdqjkC4JeTKmS1X2IzQXaBbIEb8dFzikNgfyVwBwLapo3PRA5Am
	89vXg5qSXLHHSLNjOSFavZCZeKPW0KQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795475472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C3uiFWYL2JEsWtzMJEGbYDPZMkeevKcCGQVN12Rehn4=;
	b=dww9M6fokzdCf38jdF2ZvZ/r8xWc6nTMJ5cixEQ9j6lnE5g37Jq+v6qzOk5wZ6HPB2hjqu
	+4j1WWr66qLSMcfwFMyGdqjkC4JeTKmS1X2IzQXaBbIEb8dFzikNgfyVwBwLapo3PRA5Am
	89vXg5qSXLHHSLNjOSFavZCZeKPW0KQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4859B13505
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PLMLMwzIBGtlZQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: make btrfs_backref_finish_upper_links() fail before touching the cache
Date: Tue, 24 Nov 2026 09:40:45 +1030
Message-ID: <41b9b10dc1a88e721711e13c9ac3c8d1766eb959.1795475376.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cover.1795475376.git.wqu@suse.com>
References: <cover.1795475376.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

btrfs_backref_finish_upper_links() returns -EUCLEAN if it finds an
unchecked upper node, but it does so in the middle of the walk.  By then
@start and some upper nodes are already inserted into the rb tree, and
the remaining edges are queued on a local pending_edge list on the stack.

This makes the error handling in btrfs_backref_error_cleanup() complex
and incomplete:

- The queued edges still point to the dead stack list head
  btrfs_backref_error_cleanup() does list_del() on them and writes into
  stale stack memory.

- Cached nodes have edges to uncached upper nodes
  btrfs_backref_error_cleanup() stops at cached nodes, so the uncached
  upper nodes above them are leaked.

Avoid the partial state by checking all the uncached upper nodes before
anything is modified.  If the check fails, nothing is cached and no edge
is queued.

The old check inside the loop becomes an ASSERT().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index a0fb90b7a9ed..9354eec71b35 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3564,6 +3564,21 @@ int btrfs_backref_add_tree_node(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static bool backref_uppers_checked(struct btrfs_backref_node *node)
+{
+	struct btrfs_backref_edge *edge;
+
+	list_for_each_entry(edge, &node->upper, list[LOWER]) {
+		struct btrfs_backref_node *upper = edge->node[UPPER];
+
+		if (upper->detached || !RB_EMPTY_NODE(&upper->rb_node))
+			continue;
+		if (!upper->checked || !backref_uppers_checked(upper))
+			return false;
+	}
+	return true;
+}
+
 /*
  * Finish the upwards linkage created by btrfs_backref_add_tree_node()
  */
@@ -3577,6 +3592,11 @@ int btrfs_backref_finish_upper_links(struct btrfs_backref_cache *cache,
 
 	ASSERT(start->checked);
 
+	if (unlikely(!backref_uppers_checked(start))) {
+		DEBUG_WARN("we should not have any unchecked nodes");
+		return -EUCLEAN;
+	}
+
 	rb_node = rb_simple_insert(&cache->rb_root, &start->simple_node);
 	if (rb_node)
 		btrfs_backref_panic(cache->fs_info, start->bytenr, -EEXIST);
@@ -3622,11 +3642,7 @@ int btrfs_backref_finish_upper_links(struct btrfs_backref_cache *cache,
 			continue;
 		}
 
-		/* Sanity check, we shouldn't have any unchecked nodes */
-		if (unlikely(!upper->checked)) {
-			DEBUG_WARN("we should not have any unchecked nodes");
-			return -EUCLEAN;
-		}
+		ASSERT(upper->checked);
 
 		rb_node = rb_simple_insert(&cache->rb_root, &upper->simple_node);
 		if (unlikely(rb_node))
-- 
2.56.1

