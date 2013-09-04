Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47276 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3IDPXg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 11:23:36 -0400
Received: by mail-pd0-f175.google.com with SMTP id q10so459311pdj.20
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 08:23:36 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com
Subject: [PATCH 17/20] Btrfs-progs: fix magic return value in random-test.c
Date: Wed,  4 Sep 2013 23:22:34 +0800
Message-Id: <1378308157-4621-18-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 random-test.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/random-test.c b/random-test.c
index 2f44593..b7c6cdb 100644
--- a/random-test.c
+++ b/random-test.c
@@ -43,7 +43,7 @@ again:
 	ret = radix_tree_gang_lookup(root, (void **)res, num, 2);
 	if (exists) {
 		if (ret == 0)
-			return -1;
+			return -EEXIST;
 		num = res[0];
 	} else if (ret != 0 && num == res[0]) {
 		num++;
@@ -79,7 +79,7 @@ static int ins_one(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	return ret;
 error:
 	printf("failed to insert %llu\n", (unsigned long long)key.objectid);
-	return -1;
+	return ret;
 }
 
 static int insert_dup(struct btrfs_trans_handle *trans, struct btrfs_root
@@ -98,7 +98,7 @@ static int insert_dup(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (ret != -EEXIST) {
 		printf("insert on %llu gave us %d\n",
 		       (unsigned long long)key.objectid, ret);
-		return 1;
+		return ret;
 	}
 	return 0;
 }
@@ -127,7 +127,7 @@ static int del_one(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	return 0;
 error:
 	printf("failed to delete %llu\n", (unsigned long long)key.objectid);
-	return -1;
+	return ret;
 }
 
 static int lookup_item(struct btrfs_trans_handle *trans, struct btrfs_root
@@ -147,7 +147,7 @@ static int lookup_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	return 0;
 error:
 	printf("unable to find key %llu\n", (unsigned long long)key.objectid);
-	return -1;
+	return ret;
 }
 
 static int lookup_enoent(struct btrfs_trans_handle *trans, struct btrfs_root
@@ -168,7 +168,7 @@ static int lookup_enoent(struct btrfs_trans_handle *trans, struct btrfs_root
 error:
 	printf("able to find key that should not exist %llu\n",
 	       (unsigned long long)key.objectid);
-	return -1;
+	return -EEXIST;
 }
 
 static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
@@ -209,7 +209,7 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 			fprintf(stderr,
 				"failed to remove %lu from tree\n",
 				found);
-			return -1;
+			return ret;
 		}
 		btrfs_release_path(&path);
 		ptr = radix_tree_delete(radix, found);
@@ -221,7 +221,7 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 	return 0;
 error:
 	fprintf(stderr, "failed to delete from the radix %lu\n", found);
-	return -1;
+	return -ENOENT;
 }
 
 static int fill_tree(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -428,6 +428,6 @@ int main(int ac, char **av)
 	}
 out:
 	close_ctree(root, &super);
-	return err;
+	return !!err;
 }
 
-- 
1.7.11.7

