Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3JGVnQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:16 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhGA8000743
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:16 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/12] btrfs-progs: check link_subvol name base
Date: Mon,  7 Oct 2013 14:42:58 -0700
Message-Id: <1381182185-10896-6-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In principle, link_subvol() can be given an abitrary string as the name
of the saved subvolume.  It copies it into a fixed-size stack buffer and
then uses it as dirent names without testing its length.

This limits its length to BTRFS_NAME_LEN.  This was found by static
analsys.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-convert.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 221dd45..edef1bd 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1428,10 +1428,15 @@ static struct btrfs_root * link_subvol(struct btrfs_root *root,
 	struct btrfs_key key;
 	u64 dirid = btrfs_root_dirid(&root->root_item);
 	u64 index = 2;
-	char buf[64];
+	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
+	int len;
 	int i;
 	int ret;
 
+	len = strlen(base);
+	if (len < 1 || len > BTRFS_NAME_LEN)
+		return NULL;
+
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
@@ -1467,18 +1472,22 @@ static struct btrfs_root * link_subvol(struct btrfs_root *root,
 	key.offset = (u64)-1;
 	key.type = BTRFS_ROOT_ITEM_KEY;
 
-	strcpy(buf, base);
+	memcpy(buf, base, len);
 	for (i = 0; i < 1024; i++) {
-		ret = btrfs_insert_dir_item(trans, root, buf, strlen(buf),
+		ret = btrfs_insert_dir_item(trans, root, buf, len,
 					    dirid, &key, BTRFS_FT_DIR, index);
 		if (ret != -EEXIST)
 			break;
-		sprintf(buf, "%s%d", base, i);
+		len = snprintf(buf, ARRAY_SIZE(buf), "%s%d", base, i);
+		if (len < 1 || len > BTRFS_NAME_LEN) {
+			ret = -EINVAL;
+			break;
+		}
 	}
 	if (ret)
 		goto fail;
 
-	btrfs_set_inode_size(leaf, inode_item, strlen(buf) * 2 +
+	btrfs_set_inode_size(leaf, inode_item, len * 2 +
 			     btrfs_inode_size(leaf, inode_item));
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(path);
@@ -1487,13 +1496,13 @@ static struct btrfs_root * link_subvol(struct btrfs_root *root,
 	ret = btrfs_add_root_ref(trans, tree_root, root_objectid,
 				 BTRFS_ROOT_BACKREF_KEY,
 				 root->root_key.objectid,
-				 dirid, index, buf, strlen(buf));
+				 dirid, index, buf, len);
 	BUG_ON(ret);
 
 	/* now add the forward ref */
 	ret = btrfs_add_root_ref(trans, tree_root, root->root_key.objectid,
 				 BTRFS_ROOT_REF_KEY, root_objectid,
-				 dirid, index, buf, strlen(buf));
+				 dirid, index, buf, len);
 
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
-- 
1.7.11.7

