Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268317;
	b=g70W5xXPKMY/TDmI5R0ISbZoQdN9TWHDPnfDf60rAeAihHfP1XCWYMVeuYPe6BwOMxWq
	 zdo6n3DYdRevyuL/QWalKv4f28y7IT3U6s+GY/vNG3bmOggTpqGOJZFLW5qunxYBAdYjH
	 /hCtadwl+Qrv+lLQPeSyDHQXxrzs9A4GaJfFmnzF2tUDFdsDuFrSj3bClicgkwpKr+jIm
	 kF9S0fCDOBCwuIuvs2qSL0ItkWd9lhjL3HbHvabzEOpHq8fcgz8lNm4M8DZlx5GltS+aS
	 eDzyBQuhJiMrvVyfVWduf+36F5fEVMDDCroAxJLx3rRDER7dLLbwRdqKckmPiUu8YnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268317;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=HNvLzo95Eww4HJyeriViD5/YrjMc3XMW5/jWDyLYhuU=;
	b=j0+Bm8gauhrGfa/4jxoyn5tnkl2Ww6rAWnJM3FrC/pamIvXbnAFsmVNWIUuLJtt19A04
	 GBXj9PT0GkQ7HJp7lSUMhgN5cUnpmeAqn44UAsPTtVuI84QJEkUeL5gpCOfhjlR48Dfog
	 vLOuccwF7+56VF9EtXgv/q3uQcvOov9+n3oSdwliKIQozS2ttFLPVQiMW0Paq1lhUtqT7
	 PBXZD3PAC98sZ3wsWjzGJmXFme3VP7C3VA2C36YMzUjkdG9mfzgV2SNfyRYo6cgLWVK1r
	 l9OYNXN+xgY0+1mst8NUxITOn3MRqnkJSiLX4ANoxNYHgyTUAhC5nJXwvD0uaXZVCDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eFc4zk9M;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eFc4zk9M;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EA5606A324
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38EA5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eFc4zk9M;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eFc4zk9M
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B7F241FB88
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793268315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNvLzo95Eww4HJyeriViD5/YrjMc3XMW5/jWDyLYhuU=;
	b=eFc4zk9MjRK7d1Fx8wRxO59PeUstdQHEnYh3JyrNkK0/URi8V9LqemIv3k+/WkZpdbLJRx
	CDWj7yw7en1hehv1T0qCnJhZnNcSdFu+xmI7E3pi4Qpl3Biqb6TTqONPiN+RbDSzbCc25O
	ofkziCkYrJ9S2hQ4XuEQ1Ci0p1yRcKw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=eFc4zk9M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793268315; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNvLzo95Eww4HJyeriViD5/YrjMc3XMW5/jWDyLYhuU=;
	b=eFc4zk9MjRK7d1Fx8wRxO59PeUstdQHEnYh3JyrNkK0/URi8V9LqemIv3k+/WkZpdbLJRx
	CDWj7yw7en1hehv1T0qCnJhZnNcSdFu+xmI7E3pi4Qpl3Biqb6TTqONPiN+RbDSzbCc25O
	ofkziCkYrJ9S2hQ4XuEQ1Ci0p1yRcKw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A536513419
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 380rJ1Ma42qwKgAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs-progs: fix a path leak in alloc_reserved_tree_block()
Date: Thu, 29 Oct 2026 20:34:40 +1030
Message-ID: <94c1b65ed9a4f7e3e4790c09080ca0fb84b7ea49.1793268211.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793268211.git.wqu@suse.com>
References: <cover.1793268211.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: B7F241FB88
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

If btrfs_insert_empty_item() failed with -EEXIST, the path is not
released by btrfs_insert_empty_item().

But the function returns without freeing @path, causing a leak.

This function has lagged behind kernel quite some, so here I just fix
the path leak by utilizing BTRFS_PATH_AUTO_FREE() inside the if ()
branch.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shared/extent-tree.c b/kernel-shared/extent-tree.c
index 64479e6e43f1..bac44654eab8 100644
--- a/kernel-shared/extent-tree.c
+++ b/kernel-shared/extent-tree.c
@@ -2403,7 +2403,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_space_info *sinfo;
 	struct extent_buffer *leaf;
-	struct btrfs_path *path;
 	struct btrfs_key ins;
 	u32 size = sizeof(*extent_item) + sizeof(*iref);
 	u64 start, end;
@@ -2415,6 +2414,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	ins.objectid = node->bytenr;
 
 	if (ref->root != BTRFS_REMAP_TREE_OBJECTID) {
+		BTRFS_PATH_AUTO_FREE(path);
+
 		if (skinny_metadata) {
 			ins.type = BTRFS_METADATA_ITEM_KEY;
 			ins.offset = ref->level;
@@ -2462,7 +2463,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_set_extent_inline_ref_offset(leaf, iref, ref->root);
 
 		btrfs_mark_buffer_dirty(leaf);
-		btrfs_free_path(path);
 	}
 
 	ret = remove_from_free_space_tree(trans, ins.objectid, fs_info->nodesize);
-- 
2.56.0

