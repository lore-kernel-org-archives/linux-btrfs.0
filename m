From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 1/4] Btrfs: add filesystem state for error handle
Date: Thu, 25 Nov 2010 17:53:50 +0800
Message-ID: <4CEE322E.4020204@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

Add filesystem state and two flags of it to tell if the filesystem is
valid or insane now.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8db9234..78b4c34 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -294,6 +294,16 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
+
+/*
+ * File system states
+ */
+
+/* Unmount cleanly */
+#define BTRFS_SUPER_FLAG_VALID		(1ULL << 2)
+/* Errors detected */
+#define BTRFS_SUPER_FLAG_ERROR		(1ULL << 3)
+
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
 
@@ -1050,6 +1060,9 @@ struct btrfs_fs_info {
 	unsigned metadata_ratio;
 
 	void *bdev_holder;
+
+	/* filesystem state */
+	unsigned short fs_state;
 };
 
 /*
-- 
1.7.0.1
