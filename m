Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41123 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752207AbeENLNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1390CAD97
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/9] btrfs-progs: btrfs-corrupt-block: Factor out common "-r" handling code
Date: Mon, 14 May 2018 14:13:31 +0300
Message-Id: <1526296414-27638-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since more and more of the "corrupt XXX" options are going to support
combination with -r option, let's extract the common code needed for
this. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 7a5513c455e6..8bbfe1cdb855 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -1114,7 +1114,7 @@ int main(int argc, char **argv)
 {
 	struct cache_tree root_cache;
 	struct btrfs_key key;
-	struct btrfs_root *root;
+	struct btrfs_root *root, *target_root;
 	char *dev;
 	/* chunk offset can be 0,so change to (u64)-1 */
 	u64 logical = (u64)-1;
@@ -1245,6 +1245,10 @@ int main(int argc, char **argv)
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
 	}
+	target_root = root;
+	if (root_objectid)
+		target_root = open_root(root->fs_info, root_objectid);
+
 	if (extent_rec) {
 		struct btrfs_trans_handle *trans;
 
@@ -1342,26 +1346,19 @@ int main(int argc, char **argv)
 		goto out_close;
 	}
 	if (corrupt_item) {
-		struct btrfs_root *target;
 		if (!key.objectid)
 			print_usage(1);
 		if (!root_objectid)
 			print_usage(1);
 
-		target = open_root(root->fs_info, root_objectid);
-
-		ret = corrupt_btrfs_item(target, &key, field);
+		ret = corrupt_btrfs_item(target_root, &key, field);
 		goto out_close;
 	}
 	if (delete) {
-		struct btrfs_root *target = root;
-
 		if (!key.objectid)
 			print_usage(1);
-		if (root_objectid)
-			target = open_root(root->fs_info, root_objectid);
 
-		ret = delete_item(target, &key);
+		ret = delete_item(target_root, &key);
 		goto out_close;
 	}
 	if (should_corrupt_key) {
-- 
2.7.4

