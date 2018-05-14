Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752037AbeENLNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:13:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 793F2ADB4
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 11:13:39 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/9] btrfs-progs: btrfs-corrupt-block: Factor out specific-root code
Date: Mon, 14 May 2018 14:13:26 +0300
Message-Id: <1526296414-27638-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1526296414-27638-1-git-send-email-nborisov@suse.com>
References: <1526296414-27638-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some options operate on a specific root so let's extract the code which
deals with this. No functional change.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index da0ec8c51e5a..ab6ca0a1e90a 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -1080,6 +1080,26 @@ static int find_chunk_offset(struct btrfs_root *root,
 	return ret;
 
 }
+
+static struct btrfs_root *open_root(struct btrfs_fs_info *fs_info,
+				    u64 root_objectid)
+{
+
+	struct btrfs_key root_key;
+	struct btrfs_root *root;
+
+	root_key.objectid = root_objectid;
+	root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root_key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(fs_info, &root_key);
+	if (IS_ERR(root)) {
+		fprintf(stderr, "Couldn't find root %llu\n", root_objectid);
+		print_usage(1);
+	}
+
+	return root;
+}
 int main(int argc, char **argv)
 {
 	struct cache_tree root_cache;
@@ -1326,20 +1346,9 @@ int main(int argc, char **argv)
 
 		if (!key.objectid)
 			print_usage(1);
-		if (root_objectid) {
-			struct btrfs_key root_key;
-
-			root_key.objectid = root_objectid;
-			root_key.type = BTRFS_ROOT_ITEM_KEY;
-			root_key.offset = (u64)-1;
-
-			target = btrfs_read_fs_root(root->fs_info, &root_key);
-			if (IS_ERR(target)) {
-				fprintf(stderr, "Couldn't find root %llu\n",
-					(unsigned long long)root_objectid);
-				print_usage(1);
-			}
-		}
+		if (root_objectid)
+			target = open_root(root->fs_info, root_objectid);
+
 		ret = delete_item(target, &key);
 		goto out_close;
 	}
-- 
2.7.4

