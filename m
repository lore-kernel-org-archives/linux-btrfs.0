From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: [PATCH] Btrfs: Fix balance panic
Date: Wed, 26 Jan 2011 18:38:43 +0800
Message-ID: <4D3FF9B3.3030504@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Mark the cloned backref_node as checked in clone_backref_node()

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 045c9c2..bef9c22 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1157,6 +1157,7 @@ static int clone_backref_node(struct btrfs_trans_handle *trans,
 	new_node->bytenr = dest->node->start;
 	new_node->level = node->level;
 	new_node->lowest = node->lowest;
+	new_node->checked = 1;
 	new_node->root = dest;
 
 	if (!node->lowest) {
