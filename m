From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix array bound checking
Date: Tue, 06 Sep 2011 16:55:34 +0800
Message-ID: <4E65E006.8030707@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Otherwise we can execced the array bound of path->slots[].

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 011cab3..0fe615e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -902,9 +902,10 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
 
 	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
 
-	if (level < BTRFS_MAX_LEVEL - 1)
+	if (level < BTRFS_MAX_LEVEL - 1) {
 		parent = path->nodes[level + 1];
-	pslot = path->slots[level + 1];
+		pslot = path->slots[level + 1];
+	}
 
 	/*
 	 * deal with the case where there is only one pointer in the root
@@ -1107,9 +1108,10 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
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
1.7.3.1
