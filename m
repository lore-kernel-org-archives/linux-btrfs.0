Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00D7519DE9
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750163; cv=none; b=nFNb1zNHEKX66Y6eXlgRK35mbM7Aeh3YkBEj12JPAuxv+jNqTZtxgqbv2ysLGrbZMoCtYpKfs6P9xIgvb6KvQOddI0O5XU83t67KSChbdXJjBaL7Lqwkx3pvBlaD/rbOzCDupliGyqZutYBahHnO1XvaQ/1b2GRmEmA4CC7nupk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750163; c=relaxed/simple;
	bh=apIzj8ICOzsQh3w2GZfOLKQcbsg/kGt9Sc/3xvWkURo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dCKZDHHmjgAj2bAWmci1Y2pJB2PIY1OK2Ja0ITNPNalv9kbPQRt+myq315QKncRC5XKSbQo0i8HnQercMYBdowiEoUkOmeveUo2JgI1/HtHtI31GRNDGsqh0VKx9rYk5IcPuWVlsQW83JlLOp6LRYXYE23AQrZ4lnGOkyYmSUF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPIb2Luc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPIb2Luc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC39F1F000FF
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789750158;
	bh=pLTI88x8vX+DvAhNF+NJJNmrHlTJivsN1YwI/4QVHg4=;
	h=From:To:Subject:Date;
	b=YPIb2LuccuibxROq5bDnWGM5DAMyk7jDN7u8QO1bqaqtmjw39DN3aFwEve3VVQrI7
	 kKAMH22e6Na/ddakM1IfqsO77jowbN0BPqXv++nERbJMFr8MTpqXhuldAkxdCClbRz
	 c48xRrDATePiFhFDHgi7rJEq8vpYK2YORAc+Ob4ae72H5KQhG57aOOW9teY9NXNSPb
	 pg5Phu5HVlBe7gCwQtr3H1CzDyken2U6eSuqkFXRuOfAYxdwSvC/BoWP2mcThrl1Zn
	 X7IJ2LzT4abLF+9UUsWNAVme43NW7cfnJQV5ONG1QFTlKMfZW29NwLgfUqH/nutb+k
	 3pcuPxISsmp0A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
Date: Fri, 18 Sep 2026 17:49:14 +0100
Message-ID: <d2bc9a10e82d87166dbd60797a93a69560f02411.1789750133.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If in btrfs_tree_mod_log_insert_root() there is an error in the call to
tree_mod_log_insert() (the only possible error is -EEXIST, which means we
have a bug or some memory corruption maybe) we free all the nodes in the
'tm_list' array but we don't remove them from the tree-mod-log rbtree,
which can result in use-after-free bugs later.

So make sure we remove the nodes from the rbtree before freeing them after
an error.

Fixes: 5de865eebb83 ("Btrfs: fix tree mod logging")
Assisted-by: LLM (found the bug)
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-mod-log.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-mod-log.c b/fs/btrfs/tree-mod-log.c
index a8094928f4c9..f2a00a7df1cd 100644
--- a/fs/btrfs/tree-mod-log.c
+++ b/fs/btrfs/tree-mod-log.c
@@ -498,8 +498,11 @@ int btrfs_tree_mod_log_insert_root(struct extent_buffer *old_root,
 
 free_tms:
 	if (tm_list) {
-		for (i = 0; i < nritems; i++)
+		for (i = 0; i < nritems; i++) {
+			if (tm_list[i] && !RB_EMPTY_NODE(&tm_list[i]->node))
+				rb_erase(&tm_list[i]->node, &fs_info->tree_mod_log);
 			kfree(tm_list[i]);
+		}
 		kfree(tm_list);
 	}
 	kfree(tm);
-- 
2.47.2

