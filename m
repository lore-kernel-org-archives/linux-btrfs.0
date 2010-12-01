From: liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 1/4 v2] Btrfs: add filesystem state for error handle
Date: Wed, 01 Dec 2010 18:19:56 +0800
Message-ID: <4CF6214C.70500@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, liubo <liubo2009@cn.fujitsu.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Add filesystem state and a flags to tell if the filesystem is 
valid or insane now.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8db9234..92b5ca2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -294,6 +294,14 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
+
+/*
+ * File system states
+ */
+
+/* Errors detected */
+#define BTRFS_SUPER_FLAG_ERROR		(1ULL << 2)
+
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
 
@@ -1050,6 +1058,9 @@ struct btrfs_fs_info {
 	unsigned metadata_ratio;
 
 	void *bdev_holder;
+
+	/* filesystem state */
+	u64 fs_state;
 };
 
 /*
-- 
1.7.1

