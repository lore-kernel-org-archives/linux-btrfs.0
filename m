Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:49524 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbeBIHow (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 9 Feb 2018 02:44:52 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 08/10] btrfs-progs: Move chunk stripe size calcution function to volumes.h
Date: Fri,  9 Feb 2018 15:44:26 +0800
Message-Id: <20180209074428.29187-10-wqu@suse.com>
In-Reply-To: <20180209074428.29187-1-wqu@suse.com>
References: <20180209074428.29187-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 22 ----------------------
 volumes.h    | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/check/main.c b/check/main.c
index c051a862eb35..96607f6817af 100644
--- a/check/main.c
+++ b/check/main.c
@@ -7638,28 +7638,6 @@ repair_abort:
 	return err;
 }
 
-u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
-{
-	u64 stripe_size;
-
-	if (type & BTRFS_BLOCK_GROUP_RAID0) {
-		stripe_size = length;
-		stripe_size /= num_stripes;
-	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
-		stripe_size = length * 2;
-		stripe_size /= num_stripes;
-	} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
-		stripe_size = length;
-		stripe_size /= (num_stripes - 1);
-	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
-		stripe_size = length;
-		stripe_size /= (num_stripes - 2);
-	} else {
-		stripe_size = length;
-	}
-	return stripe_size;
-}
-
 /*
  * Check the chunk with its block group/dev list ref:
  * Return 0 if all refs seems valid.
diff --git a/volumes.h b/volumes.h
index 3741d45cae80..950de5a9f910 100644
--- a/volumes.h
+++ b/volumes.h
@@ -216,6 +216,28 @@ static inline int check_crossing_stripes(struct btrfs_fs_info *fs_info,
 		(bg_offset + len - 1) / BTRFS_STRIPE_LEN);
 }
 
+static inline u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
+{
+	u64 stripe_size;
+
+	if (type & BTRFS_BLOCK_GROUP_RAID0) {
+		stripe_size = length;
+		stripe_size /= num_stripes;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID10) {
+		stripe_size = length * 2;
+		stripe_size /= num_stripes;
+	} else if (type & BTRFS_BLOCK_GROUP_RAID5) {
+		stripe_size = length;
+		stripe_size /= (num_stripes - 1);
+	} else if (type & BTRFS_BLOCK_GROUP_RAID6) {
+		stripe_size = length;
+		stripe_size /= (num_stripes - 2);
+	} else {
+		stripe_size = length;
+	}
+	return stripe_size;
+}
+
 int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		      u64 logical, u64 *length, u64 *type,
 		      struct btrfs_multi_bio **multi_ret, int mirror_num,
-- 
2.16.1

