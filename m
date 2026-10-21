Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792618904;
	b=YAanUCEhC9s20MLBxKWZQeUR4ZLiC+8wQaf1kIX3YP5KZD7ieaKdohdS0ZkL9hcveWvH
	 Vn0+49DwN9uilh+ZQkAB46w/IIWoKKgDQAe4UslUtNqxhcnSn33d5liHkDk49Cfuo40Kc
	 khKqdCH39ovt17YDOXPvvc0g7AqylsqJbIdHJ/aTKSgvPdXvQSvjLZs2wt7PZxvMtCT1R
	 divQ/4bh0JWDQT9kVUMJjEiL6b7GVSD0NRKVAlPq1XkekSLAVclgxZBnt5BJK2pvwaSR4
	 seLxnITxyl06qoMLE7GDFpJmv1in3ArcVzQG3TC4GIWyDkHIBMvXzwDK/6EhnHRZ42w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792618904;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=E0I3edwLid9KaZ/Z5g5e2DFr3K8Vu9KvfM4vv5CVN+k=;
	b=O1frwKIgX2E1G999Z+M5e20i6lHTBMMXS5lWYHyTw3MiBez+qyKzj0V+pc8tydU5aoW7
	 GjTUylMqle8/ock27cn8rmKqC2XfGEGJHIcMi/4U4ZSIcvzDNiZp3i8vIBZlIujOey1b6
	 rxoP+jiArtXyILEvi6TzhmugGFNQmpFD8v8mstZHFOw0H69DH0WWabkbDfBILAWoy8Vsh
	 6ffq7CnPePUOeOa/CbCFwvhOZ9WS/ndIf2zfqAoOCw74Wrh2zoQZ/AKkXTy+cAZSp5G44
	 D9MJPR/U6ip5FmkWTp0h0fQXZWIeoY+Oh6o0RJ3XuHJzu6na1B4bYDo8bzZCQZdX7rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bttkg2Qc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44497606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bttkg2Qc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691FA1F000C1
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 21:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792618903;
	bh=E0I3edwLid9KaZ/Z5g5e2DFr3K8Vu9KvfM4vv5CVN+k=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Bttkg2Qc0575N29q/WzFq+MZ+4u9HG2hl32XjnCESOie5TiixjpNL1QomKnAsMes/
	 +f0E4dMLQuvAr60/VxZ+6W5ue7aWJ3b6RVRPjii+9A5uH2b7eEoQAJTApVNyQbt4zG
	 RrpjQYPRdMXFDA4MgLhgyoZoL9/dyVO2grGRq08Tznc7ZROh2Zbr2x4IVacxt3W4/h
	 YA7S+IBQZga/xQWAPQFCSquw8/e/fQpgR0knohCC1p57r69WZuHe5DN/oL5ZVfelgD
	 YksRKKZntRctwnO1Xc35YYLu6VxDyZCb86xRApVKqu40ckiXiHbSXa5EBrocClYTN7
	 LrNke4UMiCCLw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: send: fix missing hole punching during incremental send
Date: Wed, 21 Oct 2026 22:41:41 +0100
Message-ID: <087634ad0970d81654b2f1cc72cd35bbde47df97.1792618636.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <25a6b104e8af433508c425cd7470426470f811f2.1792613378.git.fdmanana@suse.com>
References: <25a6b104e8af433508c425cd7470426470f811f2.1792613378.git.fdmanana@suse.com>
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

From: Filipe Manana <fdmanana@suse.com>

When using the no-holes feature (enabled by default since btrfs-progs
v5.15) and doing an incremental send, we can miss issuing a hole punching
command when the following conditions happen:

1) A hole is punched in a tail section of a file extent item that happens
   to be the last item in a leaf (for example the extent covers the file
   range [1M, 3M) and a hole is punched in the range [2M, 3M)). Between
   the end of this file extent item's range and the i_size, there are
   other file extent items;

2) The next leaf was not modified in the send snapshot, remaining shared
   with the parent snapshot.

In this scenario we are unable to detect a hole was punched and never
issue a hole punch command because with no-holes there we don't have an
exlicit file extent item to mark a hole.

Fix this by teaching maybe_send_hole() to detect such case.
A test case for fstests will follow soon.

Reported-by: Tristan Elvers <tristanelvers@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAFoLKK+aErV4p6ZJPnVeH5SHQ5++0f=8ZgxPWe-E-CkeKBs8PA@mail.gmail.com/
Fixes: 16e7549f045d ("Btrfs: incompatible format change to remove hole extents")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Address a couple issues pointed by sashiko, simplify a few things.

 fs/btrfs/send.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c523bf950c89..cec1aae5ce14 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6371,6 +6371,8 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 			   struct btrfs_key *key)
 {
+	BTRFS_PATH_AUTO_FREE(next_path);
+	u64 next_offset;
 	int ret = 0;
 
 	if (sctx->cur_ino != key->objectid || !need_send_hole(sctx))
@@ -6397,14 +6399,66 @@ static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 		ret = range_is_hole_in_parent(sctx,
 					      sctx->cur_inode_last_extent,
 					      key->offset);
-		if (ret < 0)
-			return ret;
-		else if (ret == 0)
+		if (ret == 0)
 			ret = send_hole(sctx, key->offset);
-		else
+		else if (ret == 1)
 			ret = 0;
+
+		if (ret < 0)
+			return ret;
 	}
 	sctx->cur_inode_last_extent = btrfs_file_extent_end(path);
+
+	/*
+	 * If we are the last file extent item in a leaf, we may have had a tail
+	 * section that got a hole punched, and if there is no change in the
+	 * next leaf, we must find out if we have such a hole and punch it.
+	 */
+	if (path->slots[0] != btrfs_header_nritems(path->nodes[0]) - 1)
+		return ret;
+
+	next_path = alloc_path_for_send();
+	if (!next_path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(NULL, sctx->send_root, key, next_path, 0, 0);
+	if (ret < 0)
+		return ret;
+	if (WARN_ON(ret != 0))
+		return -EUCLEAN;
+
+	ret = btrfs_next_leaf(sctx->send_root, next_path);
+	if (ret < 0) {
+		return ret;
+	} else if (ret > 0) {
+		/*
+		 * No next leaf, must punch hole to i_size and set the path back
+		 * to where it was before.
+		 */
+		next_offset = sctx->cur_inode_size;
+	} else {
+		struct btrfs_key next_key;
+
+		btrfs_item_key_to_cpu(next_path->nodes[0], &next_key,
+				      next_path->slots[0]);
+		if (next_key.objectid != key->objectid ||
+		    next_key.type != BTRFS_EXTENT_DATA_KEY)
+			next_offset = sctx->cur_inode_size;
+		else
+			next_offset = next_key.offset;
+	}
+
+	btrfs_free_path(next_path);
+	next_path = NULL;
+
+	ret = range_is_hole_in_parent(sctx, sctx->cur_inode_last_extent, next_offset);
+	if (ret == 0)
+		ret = send_hole(sctx, next_offset);
+	else if (ret == 1)
+		ret = 0;
+
+	sctx->cur_inode_last_extent = next_offset;
+
 	return ret;
 }
 
-- 
2.53.0

