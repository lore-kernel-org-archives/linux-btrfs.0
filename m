Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475476;
	b=o0ZvjA1yUKubnG2G3f4WCcmDDcQdjsnf0/71tcZmxWHLf8YLvn7+A0Nvj8udDlwSebBn
	 mP9K0TljYEw//sVGeJKHjpWvunx6XIg9sltf+9Xy97QfnAqnVxInoXAcNGy0Mtjwm9ZZq
	 UwGWLwGtMmoxhsNTJY1j7XmWdZQfVdBx7YGwV0C5/WCvoaJiWiT4JpYKqPNStKtUNf8VD
	 EXR6NLLYyXOBSQrDOx7WB8iA6AVc3XovIlEHH5bN4SLZMBSEeK0I4UBzGe0/4CXFR/xbs
	 U3n8LBB4cWZj64mtfViDPs22zcegiwHnlqmD16HDOm2nhWC7oKsqQChk9PWiqTRAv2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475476;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=ivf6GWQ4C/JfE1WcaVa386Vy1AAxxestYoYrP9BZywQ=;
	b=XXvKGnZoRzr8qVbVUBfDsHLXN58lV634wsgs91KE2tdzs2cWzwXx6zWMO59oQC+9+f/n
	 axxYmH4UoR+cCL36CK+SoawqFW8afyZO8bwbdBoqFAgBE3W8IIpj5OLlhAaJVsfp09i1c
	 w1LmC9Yfw4lkywsLZ6rfhLQNcpZamInKcC7VwyZpZqag1LS1NQZtldHp6sMhjuysBHxSH
	 aDUsHzpPw4Bm8NilBT8fspl/EABqDuEyqdETFLctMoN/Rc2B0DknHcCvInADzncrF+18M
	 i8XGE3twOJ3b9rl3VuA4OlXNBPUkulSCYDMAZO/S+IBGsWiYQXdiTX70T+lMOV6KvEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MeG77ZTu;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MeG77ZTu;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AA3606A335
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15AA3606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MeG77ZTu;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=MeG77ZTu
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F5A722032
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795475474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ivf6GWQ4C/JfE1WcaVa386Vy1AAxxestYoYrP9BZywQ=;
	b=MeG77ZTu992GWvJ5agaV73s1/Bp58rteOqAlRettcvjQD8KRcjMnalBAnfmymF0ZY5Ghb0
	sGZZUCf7db9PUX1KLny+KBsxAAlptbmRX/SgLB7xP/0reBE5ypOLVqr87I0CkyCsEnATFJ
	7Ez2sbCsxat2+8Nk05WSR+aICyKJQFI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=MeG77ZTu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795475474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ivf6GWQ4C/JfE1WcaVa386Vy1AAxxestYoYrP9BZywQ=;
	b=MeG77ZTu992GWvJ5agaV73s1/Bp58rteOqAlRettcvjQD8KRcjMnalBAnfmymF0ZY5Ghb0
	sGZZUCf7db9PUX1KLny+KBsxAAlptbmRX/SgLB7xP/0reBE5ypOLVqr87I0CkyCsEnATFJ
	7Ez2sbCsxat2+8Nk05WSR+aICyKJQFI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F375A13505
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PLMLMwzIBGtlZQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix leaked backref nodes in btrfs_backref_error_cleanup()
Date: Tue, 24 Nov 2026 09:40:46 +1030
Message-ID: <5c0faff0fb1d09ccfc788dbe479c2a55b8d96a04.1795475376.git.wqu@suse.com>
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
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 1F5A722032

Sashiko reported a bug that if build_backref_tree() fails after
handle_indirect_tree_backref() has created new upper nodes, those nodes
are never freed.

btrfs_backref_error_cleanup() finds the new nodes only through
cache->pending_edge, which is not enough:

- Not all new edges are queued there
  If the upper node doesn't need its backrefs checked (e.g. the tree
  block can't be shared, upper->checked == 1), the edge is initialized
  with INIT_LIST_HEAD(&edge->list[UPPER]) and never queued.

- Queued edges are removed before their upper node is processed
  build_backref_tree() does list_del_init() on the edge before it uses
  edge->node[UPPER] as the next @cur.

For example, take this tree, where C is the @node and B was created
before a snapshot so it can be shared, while the root A can not:

 A (root)
 |
 \- B
    |
    \- C (@node)

 build_backref_tree()
 |- btrfs_backref_add_tree_node(@cur = C)
 |  \- handle_indirect_tree_backref(@cur = C)
 |     allocates B and A, and the edges C -> B and B -> A
 |     only C -> B is queued in pending_edge, A is a root and not shared
 |
 |- list_del_init()
 |  removes the edge C -> B from pending_edge, @cur becomes B
 |
 |- btrfs_backref_add_tree_node(@cur = B)
 |  fails, e.g. -ENOMEM
 |
 \- btrfs_backref_error_cleanup()
    |  pending_edge is empty, B and A are never found
    |
    \- btrfs_backref_cleanup_node(@node = C)
       only frees the edge C -> B and C

B, A and the edge B -> A are in no list nor in the rb tree, so nothing
can free them anymore.  A is only reachable through B.

Fix it by walking upwards from @node through the upper edges, which is
how all new nodes are linked, and stop at nodes already in the cache.
The walk is breadth first, so a node is dropped only after all of its
lower nodes are processed and no edge refers to it.

Nodes on useless_node and edges on pending_edge are not used to find the
nodes to free.  They should be reachable from @node, which is checked by
the final ASSERT() that both lists are empty.

Link: https://sashiko.dev/#/bug/linux-6b8466f1-cacd-4417-b046-f02bd8a80dd2
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c | 66 ++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 9354eec71b35..8bba24dd1371 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3663,53 +3663,31 @@ int btrfs_backref_finish_upper_links(struct btrfs_backref_cache *cache,
 void btrfs_backref_error_cleanup(struct btrfs_backref_cache *cache,
 				 struct btrfs_backref_node *node)
 {
-	struct btrfs_backref_node *lower;
-	struct btrfs_backref_node *upper;
+	struct btrfs_backref_node *cur;
 	struct btrfs_backref_edge *edge;
+	LIST_HEAD(queue);
 
-	while (!list_empty(&cache->useless_node)) {
-		lower = list_first_entry(&cache->useless_node,
-				   struct btrfs_backref_node, list);
-		list_del_init(&lower->list);
+	if (node)
+		list_move_tail(&node->list, &queue);
+
+	while (!list_empty(&queue)) {
+		cur = list_first_entry(&queue, struct btrfs_backref_node, list);
+
+		while (!list_empty(&cur->upper)) {
+			struct btrfs_backref_node *upper;
+
+			edge = list_first_entry(&cur->upper,
+					struct btrfs_backref_edge, list[LOWER]);
+			upper = edge->node[UPPER];
+			list_del(&edge->list[LOWER]);
+			list_del(&edge->list[UPPER]);
+			btrfs_backref_free_edge(cache, edge);
+
+			if (RB_EMPTY_NODE(&upper->rb_node))
+				list_move_tail(&upper->list, &queue);
+		}
+		btrfs_backref_drop_node(cache, cur);
 	}
-	while (!list_empty(&cache->pending_edge)) {
-		edge = list_first_entry(&cache->pending_edge,
-				struct btrfs_backref_edge, list[UPPER]);
-		list_del(&edge->list[UPPER]);
-		list_del(&edge->list[LOWER]);
-		lower = edge->node[LOWER];
-		upper = edge->node[UPPER];
-		btrfs_backref_free_edge(cache, edge);
-
-		/*
-		 * Lower is no longer linked to any upper backref nodes and
-		 * isn't in the cache, we can free it ourselves.
-		 */
-		if (list_empty(&lower->upper) &&
-		    RB_EMPTY_NODE(&lower->rb_node))
-			list_add(&lower->list, &cache->useless_node);
-
-		if (!RB_EMPTY_NODE(&upper->rb_node))
-			continue;
-
-		/* Add this guy's upper edges to the list to process */
-		list_for_each_entry(edge, &upper->upper, list[LOWER])
-			list_add_tail(&edge->list[UPPER],
-				      &cache->pending_edge);
-		if (list_empty(&upper->upper))
-			list_add(&upper->list, &cache->useless_node);
-	}
-
-	while (!list_empty(&cache->useless_node)) {
-		lower = list_first_entry(&cache->useless_node,
-				   struct btrfs_backref_node, list);
-		list_del_init(&lower->list);
-		if (lower == node)
-			node = NULL;
-		btrfs_backref_drop_node(cache, lower);
-	}
-
-	btrfs_backref_cleanup_node(cache, node);
 	ASSERT(list_empty(&cache->useless_node) &&
 	       list_empty(&cache->pending_edge));
 }
-- 
2.56.1

