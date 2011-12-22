From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 02/10] Btrfs: added helper btrfs_next_item()
Date: Thu, 22 Dec 2011 17:03:16 +0100
Message-ID: <c7d22a3c3cdb73d8a0151e2ccc8cf4a48c48310b.1324568415.git.list.btrfs@jan-o-sch.net>
References: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
Cc: lizf@cn.fujitsu.com, sensille@gmx.net
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1324568415.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_next_item() makes the btrfs path point to the next item, crossing leaf
boundaries if needed.

Signed-off-by: Arne Jansen <sensille@gmx.net>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 50634abe..3e4a07b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2482,6 +2482,13 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
+static inline int btrfs_next_item(struct btrfs_root *root, struct btrfs_path *p)
+{
+	++p->slots[0];
+	if (p->slots[0] >= btrfs_header_nritems(p->nodes[0]))
+		return btrfs_next_leaf(root, p);
+	return 0;
+}
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
 void btrfs_drop_snapshot(struct btrfs_root *root,
-- 
1.7.3.4

