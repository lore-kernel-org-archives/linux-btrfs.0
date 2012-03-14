From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] btrfs/ctree.h: trivial fixup the comment for struct btrfs_dev_extent
 with the right fields' names
Date: Wed, 14 Mar 2012 13:43:55 +0800
Message-ID: <4F60301B.8030601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/ctree.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 80b6486..a515e4e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -597,9 +597,9 @@ struct btrfs_extent_ref_v0 {
 } __attribute__ ((__packed__));
 
 
-/* dev extents record free space on individual devices.  The owner
+/* dev extents record free space on individual devices.  The chunk_tree
  * field points back to the chunk allocation mapping tree that allocated
- * the extent.  The chunk tree uuid field is a way to double check the owner
+ * the extent.  The chunk_tree_uuid field is a way to double check the owner
  */
 struct btrfs_dev_extent {
 	__le64 chunk_tree;
-- 
1.7.1
