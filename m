Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ED53FE344
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229929; cv=none; b=T7++my1INC2vYcCUsVCMkmYukxFmY1sv6OXwTmWwAPcB8SYhytrC5YVoP0vctuXrShOBXUhtUQta8cvRzxK1OY2fBkbEZ0OVSmFY/zEHx8P6eNKuaiTZs3t4FM/hjxuc9R8FUD3sJChcBNJpXCNu5YaRJTz6wZ4KiQBqxXgszcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229929; c=relaxed/simple;
	bh=PzeAjjOuGibcfg1aoyLdtDdxAbeUMWG0hFp1M2FGHks=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKKbMq6RSmKgct4VFU88wEUWaDXpI/pkGW2qA1RN6qjD7eyrmhu3R6SP3PS96n+QuB5jgqi/x8sePl0TRe98xbgDDYxA79LGclrrKMSHC/EHNl3ZeU2YQm7NOcABOAgGGo/XwPRs6vzNKQxaVMLd1FVVGsxOR/ehG1/8unL8dyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WCQxm57D; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XKZsDKfC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WCQxm57D";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XKZsDKfC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 095923E35
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785229913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=whJgpqgKj1zt9sYZ2gzh1V1DW3qf0LjHz6gFNmEqb70=;
	b=WCQxm57Db/GKzndKCIUT/xXAYAw/R4Xt9vxcWLM9cSXatxkvERcTDGwp1eBMyflqYyPIcH
	gyzXEDiYOjGVBTpVYlk38ESNF+jZDUtzMcdzv7DeT3B26L52SXiJ0ObhgmP+UoeP9Hv7ky
	on+4r9VFgoe5JTsafYXYwdaOdSdudSU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785229909; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=whJgpqgKj1zt9sYZ2gzh1V1DW3qf0LjHz6gFNmEqb70=;
	b=XKZsDKfCJ9d2oybSdc3B44L7NkLICip4bJxz/qzMCLcnrS66aGuu006XI1pFUzsoEdFoKw
	alOXRmtIq1DBq7Mvx/hRuCwnPWe8y51zG+O02sJvlfAwg06Xna/c094rtMxTwpU68vEhK8
	xmOE93LxfzUjguOH38ITIvonKSutnwg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D692779BF
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CAIpLFNyaGpfXQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: add validation for extent states
Date: Tue, 28 Jul 2026 18:41:24 +0930
Message-ID: <5cd4bb1a9e30e8d81f5ef51b36c416377725bf9b.1785229591.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785229591.git.wqu@suse.com>
References: <cover.1785229591.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Extent maps have the extra validation since commit 3f255ece2f1e ("btrfs:
introduce extra sanity checks for extent maps"), but extent states do
not have a similar check.

Introduce a basic alignment check for the following call sites, so that
we can cover all extent states inserted into the tree:

- insert_state_fast()
- insert_state()
- split_state()

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-io-tree.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index c18ea5ef2974..c6e639d0fcc1 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -334,6 +334,21 @@ static inline struct extent_state *tree_search(struct extent_io_tree *tree, u64
 	return tree_search_for_insert(tree, offset, NULL, NULL);
 }
 
+static void validate_extent_state(const struct extent_io_tree *tree,
+				  struct extent_state *state)
+{
+	u32 blocksize;
+
+	if (tree->owner != IO_TREE_INODE_IO)
+		return;
+
+	blocksize = btrfs_extent_io_tree_to_fs_info(tree)->sectorsize;
+	ASSERT(IS_ALIGNED(state->start, blocksize) &&
+	       IS_ALIGNED(state->end + 1, blocksize),
+	       "unaligned extent state, blocksize=%u start=%llu end=%llu state=0x%x",
+	       blocksize, state->start, state->end, state->state);
+}
+
 #define extent_io_tree_panic(tree, state, opname, err)                      \
 	btrfs_panic(btrfs_extent_io_tree_to_fs_info((tree)), (err),         \
 		    "extent io tree error on %s state start %llu end %llu", \
@@ -429,6 +444,8 @@ static struct extent_state *insert_state(struct extent_io_tree *tree,
 	const u64 end = state->end + 1;
 	const bool try_merge = !(bits & (EXTENT_LOCK_BITS | EXTENT_BOUNDARY));
 
+	validate_extent_state(tree, state);
+
 	set_state_bits(tree, state, bits, changeset);
 
 	node = &tree->state.rb_node;
@@ -481,6 +498,8 @@ static void insert_state_fast(struct extent_io_tree *tree,
 			      struct rb_node *parent, unsigned bits,
 			      struct extent_changeset *changeset)
 {
+	validate_extent_state(tree, state);
+
 	set_state_bits(tree, state, bits, changeset);
 	rb_link_node(&state->rb_node, parent, node);
 	rb_insert_color(&state->rb_node, &tree->state);
@@ -533,6 +552,8 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 		}
 	}
 
+	validate_extent_state(tree, orig);
+	validate_extent_state(tree, prealloc);
 	rb_link_node(&prealloc->rb_node, parent, node);
 	rb_insert_color(&prealloc->rb_node, &tree->state);
 
-- 
2.54.0

