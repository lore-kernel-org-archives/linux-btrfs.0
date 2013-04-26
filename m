Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37317 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab3DZVGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:14 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/9] Btrfs-progs: fix array bound checking
Date: Fri, 26 Apr 2013 16:06:04 -0500
Message-Id: <1367010370-21571-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Otherwise we can execced the array bound of path->slots[].

[Eric Sandeen: port kernel commit a05a9bb to userspace]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 ctree.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/ctree.c b/ctree.c
index 0311e25..5409552 100644
--- a/ctree.c
+++ b/ctree.c
@@ -815,9 +815,10 @@ static int balance_level(struct btrfs_trans_handle *trans,
 
 	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
 
-	if (level < BTRFS_MAX_LEVEL - 1)
+	if (level < BTRFS_MAX_LEVEL - 1) {
 		parent = path->nodes[level + 1];
-	pslot = path->slots[level + 1];
+		pslot = path->slots[level + 1];
+	}
 
 	/*
 	 * deal with the case where there is only one pointer in the root
@@ -1007,9 +1008,10 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	mid = path->nodes[level];
 	WARN_ON(btrfs_header_generation(mid) != trans->transid);
 
-	if (level < BTRFS_MAX_LEVEL - 1)
+	if (level < BTRFS_MAX_LEVEL - 1) {
 		parent = path->nodes[level + 1];
-	pslot = path->slots[level + 1];
+		pslot = path->slots[level + 1];
+	}
 
 	if (!parent)
 		return 1;
-- 
1.7.1

