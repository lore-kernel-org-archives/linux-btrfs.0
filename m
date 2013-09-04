Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57111 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3IDPXe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:34 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so454131pbc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:34 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 16/20] Btrfs-progs: fix magic return value in dir-test.c
Date: Wed,  4 Sep 2013 23:22:33 +0800
Message-Id: <1378308157-4621-17-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 dir-test.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/dir-test.c b/dir-test.c
index d95219a..a54b777 100644
--- a/dir-test.c
+++ b/dir-test.c
@@ -140,7 +140,7 @@ fatal_release:
 	btrfs_release_path(&path);
 fatal:
 	printf("failed to insert %lu ret %d\n", oid, ret);
-	return -1;
+	return ret;
 }
 
 static int insert_dup(struct btrfs_trans_handle *trans, struct btrfs_root
@@ -213,7 +213,7 @@ out_release:
 	btrfs_release_path(path);
 out:
 	printf("failed to delete %lu %d\n", radix_index, ret);
-	return -1;
+	return ret;
 }
 
 static int del_one(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -241,7 +241,7 @@ static int del_one(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 out_release:
 	btrfs_release_path(&path);
 	printf("failed to delete %lu %d\n", oid, ret);
-	return -1;
+	return ret;
 }
 
 static int lookup_item(struct btrfs_trans_handle *trans, struct btrfs_root
@@ -269,7 +269,7 @@ static int lookup_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_release_path(&path);
 	if (ret) {
 		printf("unable to find key %lu\n", oid);
-		return -1;
+		return ret;
 	}
 	return 0;
 }
@@ -292,7 +292,7 @@ static int lookup_enoent(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_release_path(&path);
 	if (!ret) {
 		printf("able to find key that should not exist %lu\n", oid);
-		return -1;
+		return ret;
 	}
 	return 0;
 }
@@ -342,14 +342,14 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 			fprintf(stderr,
 				"failed to remove %lu from tree\n",
 				found);
-			return -1;
+			return ret;
 		}
 		if (!keep_running)
 			break;
 	}
 	return 0;
 	fprintf(stderr, "failed to delete from the radix %lu\n", found);
-	return -1;
+	return ret;
 }
 
 static int fill_tree(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -512,6 +512,6 @@ int main(int ac, char **av)
 	}
 out:
 	close_ctree(root, &super);
-	return err;
+	return !!err;
 }
 
-- 
1.7.11.7

