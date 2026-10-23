Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792745507;
	b=G5gA4H/k3lh1hb1gbb63XMwmFXTxQpkl/RvpegJ/MQqOW40ZLSWdMlh6QFVQzY4ai39E
	 2HHNQbwdwcBs1p1ciVG41g6xyC4BN/1uhszIZYsoeKdtAOJXSwYx5P5wjkKLBeJF5hLzW
	 VoLW32G3czvy27kmkduipKriR4KbRN9EHnstHovC+94catofQQP2TP/uoBiWeVekfOl+K
	 5K7vVHpVPUR67eWGMPQOQDAugnP1TmVY6ODQt/EkTzSghkbEJ5RfZ6Y1jiXRuvEfuNDtc
	 gnO8S0aAuzLFO4W5XiomPPsJ44qnfJgkyHWkQZGmxaQ1qTLeTb+1zQCRyQiA3qj1/Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792745507;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UnHzYNYF+NWT+COuU1D8DBb8cNMRSZnS7LQCU+cgQZ4=;
	b=ufwU4IXcZoos1H+vrHnmjvtr0BD+mUBf8WDEkgpj6H5hO/DXwn/E67KeQspUr4r1j9hu
	 m5xYFwJTjtyoCN1QNF+SimJZwt8ANPvkZLLE7u59WFMteapF/7CXQI1e/K+Cwrn/ILux2
	 I6bZXprV6BaTkzY/KFsTJ7FwCsMZJFDqST6pvSMdRDe4VrKO4O12tFtowT1yxQz9atHoh
	 RhwzJYM0FFy/kSlObI5GC7MlRsYPYPzE9GaFOjVMxk4OgqnjKgiSAdL3tK6BYv2YI0/5g
	 7n25tBC5caWGfr+I50QqZXfjp0Cv3rM3FToXblkxnj3XgZvhRnCCeVwnl6WScw6DUug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kj8xks+o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334F5606A31A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 08:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kj8xks+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DE21F01825
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Oct 2026 08:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792745506;
	bh=UnHzYNYF+NWT+COuU1D8DBb8cNMRSZnS7LQCU+cgQZ4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Kj8xks+ofq40bduJBPGcgONM8QpBiLI+3M/0xRx93AgUGoxe/qUIZqiKMfuqJAIa9
	 nVJWyXDkLTgweXuzGNgcy3SfGchSbtlw3aS5QmfGU2fWFGA53Wo27sr2dUi6oM6ewi
	 i0Yj2Wj7LOi+Wc1rvEilPftaUvKUXz6TpZWIXp5hQ3NBx7sTbXwQwdsdmgy1gLVgma
	 0ap2Vx4j4jSGdhfFcBDQbwB7hPo7WR2DXYDDM5SzewZVbzT2hRv2XwY8mEwWIZzKug
	 wfZBCLWgJJKNoK6i8gEHRFFynl7H9sToaDGeOMcVw8dp/WVEVuTcsbEbwkqzfwJWXn
	 R7M0lA8th9IIA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: send: fix missing hole punching during incremental send
Date: Fri, 23 Oct 2026 09:51:43 +0100
Message-ID: <84ee388d9368cddb21943a129af572685a7167c5.1792745199.git.fdmanana@suse.com>
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

V3: Avoid tree searches in case the i_size is in the last file extent
    item and in case there is no hole between the last file extent
    item and the first one in the next leaf.

V2: Address a couple issues pointed by sashiko, simplify a few things.

 fs/btrfs/send.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c523bf950c89..1b903e75cec0 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6371,6 +6371,9 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 			   struct btrfs_key *key)
 {
+	BTRFS_PATH_AUTO_FREE(next_path);
+	const u64 cur_extent_end = btrfs_file_extent_end(path);
+	u64 next_offset;
 	int ret = 0;
 
 	if (sctx->cur_ino != key->objectid || !need_send_hole(sctx))
@@ -6397,14 +6400,72 @@ static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 		ret = range_is_hole_in_parent(sctx,
 					      sctx->cur_inode_last_extent,
 					      key->offset);
+		if (ret == 0)
+			ret = send_hole(sctx, key->offset);
+		else if (ret == 1)
+			ret = 0;
+
 		if (ret < 0)
 			return ret;
-		else if (ret == 0)
-			ret = send_hole(sctx, key->offset);
+	}
+	sctx->cur_inode_last_extent = cur_extent_end;
+
+	/*
+	 * If we are the last file extent item in a leaf, we may have had a tail
+	 * section that got a hole punched or the extent replaced with a smaller
+	 * one, and if there is no change in the next leaf, we must find out if
+	 * we have such a hole and punch it.
+	 */
+	if (!btrfs_fs_incompat(sctx->send_root->fs_info, NO_HOLES) ||
+	    (sctx->cur_inode_size <= cur_extent_end) ||
+	    (path->slots[0] != btrfs_header_nritems(path->nodes[0]) - 1))
+		return 0;
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
 		else
-			ret = 0;
+			next_offset = next_key.offset;
 	}
-	sctx->cur_inode_last_extent = btrfs_file_extent_end(path);
+
+	if (next_offset == cur_extent_end)
+		return 0;
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

