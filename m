Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31309353A80
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791046811; cv=none; b=OMWghJzqcnhCPULPdjCwhGcNn2voToFpvKzXX0eFyX9QI+tleN9WjD9Ida0KwBNZ4vZOt/8LTCSNZ/ujF6+l+EqOaT+eJ5xEBsPLyYCIeyEnLIwlUy9l8ey+riSqU0WmLQr5jnL5w0lljUHMZlSamSn5cB+iFKZvSv8O/aogmgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791046811; c=relaxed/simple;
	bh=k7F5qgZLg/b55ewbVTfO99tZVkabPS9eHPmkUucCJ3o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcR4w07xKyH1TUw+mlZbqfEBSYXBGhGxGcCQsoaGhm/3EN2fveC70YNZ0iR0OHpAjNB5WWncvmtzC1A4tgXf0x8Vwb5XwTUhzIx1sGOrm3DNfwYDmpULr2bw3p6xreg023je78jtYvJ+7/vDDZxLBdX5p52SnZHcyfyfaI0bv8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dR2LVkP0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dR2LVkP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B901F0089C
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791046809;
	bh=Te0olAMn9KX8DqSZbTqvwdxGoeOYRjs7LEDb9V9mwEE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=dR2LVkP0pHTvuEdXH9H/+TFT9Fqfut5ROjsjIcoDR3XcdIpQOP9tyVT2YZq6L4PdB
	 H1YZQu4Z7+wn3awNC1g5h4Yw9VTknOIqXHhcXFaDMRCvPPBC5lGajubIh5qgPgjlDg
	 o6j3GdmDCfAlvDMemlQtlHC3pSVHcxg7bKulqC9n2V+i1oLg94JhC/8l/1yxAvLscG
	 6FPYkDq6aYywRRxGn0Jh2eVCw7p58OxxrIMj6YgyIFeVX//HPK0GRKpqQVtzVje1EN
	 y3YKUyZA9xb22r01D8fgA2Kd1EtBNcsSPd3aiPL6y1i0EQBGXUay5fYsKpRDbCdWO+
	 /2jjfv2X7uIWw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/6] btrfs: qgroup: fix swapped blocks existence check when tracing after COW
Date: Sat,  3 Oct 2026 18:00:00 +0100
Message-ID: <59dc69757209cf74399ee29786aee0f5392f1a47.1791046651.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1791046651.git.fdmanana@suse.com>
References: <cover.1791046651.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

In btrfs_qgroup_trace_subtree_after_cow(), after we erase the swapped
block, iterate over all possible tree levels to check if we sill have
other swapped blocks. However the check is wrong, it considers that there
are other swapped blocks if any rbtree for any level is empty, instead of
not empty. As a consequence we set blocks->swapped to true basically every
time since we always find an empty rbtree at least at level 7, since in
practice it's nearly impossible to find such a huge btree. This makes
every future call to btrfs_qgroup_trace_subtree_after_cow() do an
unnecessary rbtree search instead of returning immediately.

Fix this by updating the condition to set swapped to true if we find an
rbtree that is not empty.

Fixes: f616f5cd9da7 ("btrfs: qgroup: Use delayed subtree rescan for balance")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h  | 2 +-
 fs/btrfs/qgroup.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 22ba2b4505b3..00d4c4184e76 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -160,7 +160,7 @@ enum {
  */
 struct btrfs_qgroup_swapped_blocks {
 	spinlock_t lock;
-	/* RM_EMPTY_ROOT() of above blocks[] */
+	/* True if any of the rbtrees in the blocks array below is not empty. */
 	bool swapped;
 	struct rb_root blocks[BTRFS_MAX_LEVEL];
 };
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 46de0a5e80d5..798f21608de5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4913,7 +4913,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 	/* Found one, remove it from @blocks first and update blocks->swapped */
 	rb_erase(&block->node, &blocks->blocks[level]);
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
-		if (RB_EMPTY_ROOT(&blocks->blocks[i])) {
+		if (!RB_EMPTY_ROOT(&blocks->blocks[i])) {
 			swapped = true;
 			break;
 		}
-- 
2.47.2

