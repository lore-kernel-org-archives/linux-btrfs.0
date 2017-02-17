Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35205 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934293AbdBQOnv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:43:51 -0500
Received: by mail-wm0-f68.google.com with SMTP id u63so2924747wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:43:51 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 03/38] btrfs: make btrfs_set_inode_index_count take btrfs_inode
Date: Fri, 17 Feb 2017 16:42:54 +0200
Message-Id: <1487342609-20652-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f438257be5a0..c8796391eed3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5977,15 +5977,15 @@ static int btrfs_update_time(struct inode *inode, struct timespec *now,
  * and then set the in-memory index_cnt variable to reflect
  * free sequence numbers
  */
-static int btrfs_set_inode_index_count(struct inode *inode)
+static int btrfs_set_inode_index_count(struct btrfs_inode *inode)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	struct btrfs_key key, found_key;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	int ret;
 
-	key.objectid = btrfs_ino(BTRFS_I(inode));
+	key.objectid = btrfs_ino(inode);
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = (u64)-1;
 
@@ -6008,7 +6008,7 @@ static int btrfs_set_inode_index_count(struct inode *inode)
 	 * else has to start at 2
 	 */
 	if (path->slots[0] == 0) {
-		BTRFS_I(inode)->index_cnt = 2;
+		inode->index_cnt = 2;
 		goto out;
 	}
 
@@ -6017,13 +6017,13 @@ static int btrfs_set_inode_index_count(struct inode *inode)
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
-	if (found_key.objectid != btrfs_ino(BTRFS_I(inode)) ||
+	if (found_key.objectid != btrfs_ino(inode) ||
 	    found_key.type != BTRFS_DIR_INDEX_KEY) {
-		BTRFS_I(inode)->index_cnt = 2;
+		inode->index_cnt = 2;
 		goto out;
 	}
 
-	BTRFS_I(inode)->index_cnt = found_key.offset + 1;
+	inode->index_cnt = found_key.offset + 1;
 out:
 	btrfs_free_path(path);
 	return ret;
@@ -6040,7 +6040,7 @@ int btrfs_set_inode_index(struct inode *dir, u64 *index)
 	if (BTRFS_I(dir)->index_cnt == (u64)-1) {
 		ret = btrfs_inode_delayed_dir_index_count(BTRFS_I(dir));
 		if (ret) {
-			ret = btrfs_set_inode_index_count(dir);
+			ret = btrfs_set_inode_index_count(BTRFS_I(dir));
 			if (ret)
 				return ret;
 		}
-- 
2.7.4

