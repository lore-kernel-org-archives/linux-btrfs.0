Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36817 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbbJSLjI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:39:08 -0400
Received: by pacfv9 with SMTP id fv9so93540216pac.3
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:39:08 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 01/10] btrfs-progs: fix leak of "path" in btrfs_find_item() error paths
Date: Mon, 19 Oct 2015 19:37:50 +0800
Message-Id: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

path needs to be freed before return.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 ctree.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/ctree.c b/ctree.c
index e6e5689..1434007 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1058,26 +1058,28 @@ int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *found_path,
 		path = found_path;
 
 	ret = btrfs_search_slot(NULL, fs_root, &key, path, 0, 0);
-	if ((ret < 0) || (found_key == NULL)) {
-		if (path != found_path)
-			btrfs_free_path(path);
-		return ret;
-	}
+	if ((ret < 0) || (found_key == NULL))
+		goto out;
 
 	eb = path->nodes[0];
 	if (ret && path->slots[0] >= btrfs_header_nritems(eb)) {
 		ret = btrfs_next_leaf(fs_root, path);
 		if (ret)
-			return ret;
+			goto out;
 		eb = path->nodes[0];
 	}
 
 	btrfs_item_key_to_cpu(eb, found_key, path->slots[0]);
 	if (found_key->type != key.type ||
-			found_key->objectid != key.objectid)
-		return 1;
+			found_key->objectid != key.objectid) {
+		ret = 1;
+		goto out;
+	}
 
-	return 0;
+out:
+	if (path != found_path)
+		btrfs_free_path(path);
+	return ret;
 }
 
 /*
-- 
2.4.3

