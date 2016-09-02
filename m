Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56091 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932780AbcIBTmM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 15:42:12 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82JYgpY003885
        for <linux-btrfs@vger.kernel.org>; Fri, 2 Sep 2016 12:42:11 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 257dbc0yj9-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:42:11 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 7/7] Btrfs: kill BUG_ON()'s in btrfs_mark_extent_written
Date: Fri, 2 Sep 2016 15:40:06 -0400
Message-ID: <1472845206-22870-8-git-send-email-jbacik@fb.com>
In-Reply-To: <1472845206-22870-1-git-send-email-jbacik@fb.com>
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No reason to bug on in here, fs corruption could easily cause these things to
happen.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/file.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f060b08..85bf035 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1110,13 +1110,25 @@ again:
 
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-	BUG_ON(key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY);
+	if (key.objectid != ino ||
+	    key.type != BTRFS_EXTENT_DATA_KEY) {
+		ret = -EINVAL;
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
-	BUG_ON(btrfs_file_extent_type(leaf, fi) !=
-	       BTRFS_FILE_EXTENT_PREALLOC);
+	if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_PREALLOC) {
+		ret = -EINVAL;
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
 	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
-	BUG_ON(key.offset > start || extent_end < end);
+	if (key.offset > start || extent_end < end) {
+		ret = -EINVAL;
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
 
 	bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	num_bytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
@@ -1213,12 +1225,19 @@ again:
 		ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
 					   root->root_key.objectid,
 					   ino, orig_offset);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto out;
+		}
 
 		if (split == start) {
 			key.offset = start;
 		} else {
-			BUG_ON(start != key.offset);
+			if (start != key.offset) {
+				ret = -EINVAL;
+				btrfs_abort_transaction(trans, ret);
+				goto out;
+			}
 			path->slots[0]--;
 			extent_end = end;
 		}
@@ -1240,7 +1259,10 @@ again:
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
 					ino, orig_offset);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto out;
+		}
 	}
 	other_start = 0;
 	other_end = start;
@@ -1257,7 +1279,10 @@ again:
 		ret = btrfs_free_extent(trans, root, bytenr, num_bytes,
 					0, root->root_key.objectid,
 					ino, orig_offset);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto out;
+		}
 	}
 	if (del_nr == 0) {
 		fi = btrfs_item_ptr(leaf, path->slots[0],
-- 
2.7.4

