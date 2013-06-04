Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3FDWSF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 18:18:05 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54MI4jP020435
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:04 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r54MI2Q3002655
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:04 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: set readdir f_pos only after filldir
Date: Tue,  4 Jun 2013 15:17:55 -0700
Message-Id: <1370384280-28652-2-git-send-email-zab@redhat.com>
In-Reply-To: <1370384280-28652-1-git-send-email-zab@redhat.com>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only time we need to advance f_pos is after we've successfully given
a result to userspace via filldir.  This simplification gets rid of the
is_curr variable used to update f_pos for the delayed item readdir
entries.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/delayed-inode.c |  5 +++--
 fs/btrfs/inode.c         | 17 +++++++----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5615eac..4d846a2 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1696,8 +1696,6 @@ int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
 			continue;
 		}
 
-		filp->f_pos = curr->key.offset;
-
 		di = (struct btrfs_dir_item *)curr->data;
 		name = (char *)(di + 1);
 		name_len = le16_to_cpu(di->name_len);
@@ -1708,6 +1706,9 @@ int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
 		over = filldir(dirent, name, name_len, curr->key.offset,
 			       location.objectid, d_type);
 
+		if (!over)
+			filp->f_pos = curr->key.offset + 1;
+
 		if (atomic_dec_and_test(&curr->refs))
 			kfree(curr);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b11a95e..6a5784b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5007,7 +5007,6 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	char tmp_name[32];
 	char *name_ptr;
 	int name_len;
-	int is_curr = 0;	/* filp->f_pos points to the current index? */
 
 	/* FIXME, use a real flag for deciding about the key type */
 	if (root->fs_info->tree_root == root)
@@ -5076,9 +5075,6 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 						  found_key.offset))
 			goto next;
 
-		filp->f_pos = found_key.offset;
-		is_curr = 1;
-
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
 		di_cur = 0;
 		di_total = btrfs_item_size(leaf, item);
@@ -5130,6 +5126,9 @@ skip:
 
 			if (over)
 				goto nopos;
+
+			filp->f_pos = found_key.offset + 1;
+
 			di_len = btrfs_dir_name_len(leaf, di) +
 				 btrfs_dir_data_len(leaf, di) + sizeof(*di);
 			di_cur += di_len;
@@ -5140,23 +5139,21 @@ next:
 	}
 
 	if (key_type == BTRFS_DIR_INDEX_KEY) {
-		if (is_curr)
-			filp->f_pos++;
 		ret = btrfs_readdir_delayed_dir_index(filp, dirent, filldir,
 						      &ins_list);
 		if (ret)
 			goto nopos;
 	}
 
-	/* Reached end of directory/root. Bump pos past the last item. */
-	if (key_type == BTRFS_DIR_INDEX_KEY)
+	/* Reached end of directory/root */
+	if (key_type == BTRFS_DIR_INDEX_KEY) {
 		/*
 		 * 32-bit glibc will use getdents64, but then strtol -
 		 * so the last number we can serve is this.
 		 */
 		filp->f_pos = 0x7fffffff;
-	else
-		filp->f_pos++;
+	}
+
 nopos:
 	ret = 0;
 err:
-- 
1.7.11.7

