Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52325 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751468AbbASGrW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:22 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kilZ022576
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 06/10] btrfs-progs: Add better search generation judgment for btrfs-find-root.
Date: Mon, 19 Jan 2015 14:45:08 +0800
Message-ID: <1421649912-14539-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before the patch, btrfs-find-root will only consider it find a good root
if its generation matches generation in superblock and its level is
currently found highest level.

But that's not correct in 2 ways.
1) Root with decreased level
Since tree level can decrease, like subvolume/file deletion.
Which will make the new root have higher generation but lower level.

2) Root not updated in latest transaction.
If there is some root not updated in latest transaction, its generation
will be smaller than the one in superblock, and btrfs-find-root will not
find it.

This patch will use different generation for different tree to search,
solving the above problems.

Currently, it only supports generation/level in superblock. Using tree
root level/generation if possible will be introduced later.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-find-root.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index bc2b344..45c48c2 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -278,6 +278,61 @@ static int find_root(struct btrfs_root *root)
 	return ret;
 }
 
+/*
+ * Get reliable generation and level for given root.
+ *
+ * We have two sources of gen/level: superblock and tree root.
+ * superblock include the following level:
+ *   Root, chunk, log
+ * and the following generations:
+ *   Root, chunk, uuid
+ * Other gen/leven can only be read from its btrfs_tree_root if possible.
+ *
+ * Currently we only believe things from superblock.
+ */
+static void get_root_gen_and_level(u64 objectid, struct btrfs_fs_info *fs_info,
+				   u64 *ret_gen, u8 *ret_level)
+{
+	struct btrfs_super_block *super = fs_info->super_copy;
+	u64 gen = (u64)-1;
+	u8 level = (u8)-1;
+
+	switch (objectid) {
+	case BTRFS_ROOT_TREE_OBJECTID:
+		level = btrfs_super_root_level(super);
+		gen = btrfs_super_generation(super);
+		break;
+	case BTRFS_CHUNK_TREE_OBJECTID:
+		level = btrfs_super_chunk_root_level(super);
+		gen = btrfs_super_chunk_root_generation(super);
+		printf("Search for chunk root is not supported yet\n");
+		break;
+	case BTRFS_TREE_LOG_OBJECTID:
+		level = btrfs_super_log_root_level(super);
+		gen = btrfs_super_log_root_transid(super);
+		break;
+	case BTRFS_UUID_TREE_OBJECTID:
+		gen = btrfs_super_uuid_tree_generation(super);
+		break;
+	}
+	if (gen != (u64)-1) {
+		printf("Superblock thinks the generation is %llu\n", gen);
+		if (ret_gen)
+			*ret_gen = gen;
+	} else {
+		printf("Superblock doesn't contain generation info for root %llu\n",
+		       objectid);
+	}
+	if (level != (u8)-1) {
+		printf("Superblock thinks the level is %u\n", level);
+		if (ret_level)
+			*ret_level = level;
+	} else {
+		printf("Superblock doesn't contain the level info for root %llu\n",
+		       objectid);
+	}
+}
+
 int main(int argc, char **argv)
 {
 	struct btrfs_root *root;
@@ -316,7 +371,8 @@ int main(int argc, char **argv)
 	}
 
 	if (search_generation == 0)
-		search_generation = btrfs_super_generation(root->fs_info->super_copy);
+		get_root_gen_and_level(search_objectid, root->fs_info,
+				       &search_generation, NULL);
 
 	csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	ret = find_root(root);
-- 
2.2.2

