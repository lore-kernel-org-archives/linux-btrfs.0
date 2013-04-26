Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37325 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab3DZVGP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:15 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/9] Btrfs-progs: make extent_ref_type() match kernelspace
Date: Fri, 26 Apr 2013 16:06:08 -0500
Message-Id: <1367010370-21571-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

extent_ref_type() contains inconsequential differences between
kernelspace and userspace, and has since the initial commits
to each.  Just make userspace look like kernelspace.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 extent-tree.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index b8403d6..fe74f99 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -967,17 +967,19 @@ static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
 
 static inline int extent_ref_type(u64 parent, u64 owner)
 {
+	int type;
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		if (parent > 0)
-			return BTRFS_SHARED_BLOCK_REF_KEY;
+			type = BTRFS_SHARED_BLOCK_REF_KEY;
 		else
-			return BTRFS_TREE_BLOCK_REF_KEY;
+			type = BTRFS_TREE_BLOCK_REF_KEY;
 	} else {
 		if (parent > 0)
-			return BTRFS_SHARED_DATA_REF_KEY;
+			type = BTRFS_SHARED_DATA_REF_KEY;
 		else
-			return BTRFS_EXTENT_DATA_REF_KEY;
+			type = BTRFS_EXTENT_DATA_REF_KEY;
 	}
+	return type;
 }
 
 static int find_next_key(struct btrfs_path *path, struct btrfs_key *key)
-- 
1.7.1

