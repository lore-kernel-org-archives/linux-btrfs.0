Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3FDWSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 18:18:06 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54MI5Jd017163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:06 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r54MI2Q5002655
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:05 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: trivial delayed item readdir list cleanups
Date: Tue,  4 Jun 2013 15:17:57 -0700
Message-Id: <1370384280-28652-4-git-send-email-zab@redhat.com>
In-Reply-To: <1370384280-28652-1-git-send-email-zab@redhat.com>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just call btrfs_put_delayed_items() for each list rather than having two
list arguments and duplicated code.

list_for_each_entry_safe() can handle an empty list.

We don't have to conditionally use and tear down the lists if we always
initialize them to be empty.  They're only populated when needed and the
rest of the uses just find empty lists.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/delayed-inode.c | 17 ++---------------
 fs/btrfs/delayed-inode.h |  3 +--
 fs/btrfs/inode.c         | 17 ++++++-----------
 3 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 4d846a2..bc753fc 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1618,18 +1618,11 @@ void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
 	atomic_dec(&delayed_node->refs);
 }
 
-void btrfs_put_delayed_items(struct list_head *ins_list,
-			     struct list_head *del_list)
+void btrfs_put_delayed_items(struct list_head *list)
 {
 	struct btrfs_delayed_item *curr, *next;
 
-	list_for_each_entry_safe(curr, next, ins_list, readdir_list) {
-		list_del(&curr->readdir_list);
-		if (atomic_dec_and_test(&curr->refs))
-			kfree(curr);
-	}
-
-	list_for_each_entry_safe(curr, next, del_list, readdir_list) {
+	list_for_each_entry_safe(curr, next, list, readdir_list) {
 		list_del(&curr->readdir_list);
 		if (atomic_dec_and_test(&curr->refs))
 			kfree(curr);
@@ -1642,9 +1635,6 @@ int btrfs_should_delete_dir_index(struct list_head *del_list,
 	struct btrfs_delayed_item *curr, *next;
 	int ret;
 
-	if (list_empty(del_list))
-		return 0;
-
 	list_for_each_entry_safe(curr, next, del_list, readdir_list) {
 		if (curr->key.offset > index)
 			break;
@@ -1679,9 +1669,6 @@ int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
 	int over = 0;
 	unsigned char d_type;
 
-	if (list_empty(ins_list))
-		return 0;
-
 	/*
 	 * Changing the data of the delayed item is impossible. So
 	 * we needn't lock them. And we have held i_mutex of the
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 1d5c5f7..573506b 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -135,8 +135,7 @@ void btrfs_destroy_delayed_inodes(struct btrfs_root *root);
 /* Used for readdir() */
 void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
 			     struct list_head *del_list);
-void btrfs_put_delayed_items(struct list_head *ins_list,
-			     struct list_head *del_list);
+void btrfs_put_delayed_items(struct list_head *list);
 int btrfs_should_delete_dir_index(struct list_head *del_list,
 				  u64 index);
 int btrfs_readdir_delayed_dir_index(struct file *filp, void *dirent,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6e2b86..53a8696 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5003,8 +5003,8 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_path *path;
-	struct list_head ins_list;
-	struct list_head del_list;
+	LIST_HEAD(ins_list);
+	LIST_HEAD(del_list);
 	int ret;
 	struct extent_buffer *leaf;
 	int slot;
@@ -5048,11 +5048,8 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 	path->reada = 1;
 
-	if (key_type == BTRFS_DIR_INDEX_KEY) {
-		INIT_LIST_HEAD(&ins_list);
-		INIT_LIST_HEAD(&del_list);
+	if (key_type == BTRFS_DIR_INDEX_KEY)
 		btrfs_get_delayed_items(inode, &ins_list, &del_list);
-	}
 
 	btrfs_set_key_type(&key, key_type);
 	key.offset = filp->f_pos;
@@ -5083,9 +5080,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 			break;
 		if (found_key.offset < filp->f_pos)
 			goto next;
-		if (key_type == BTRFS_DIR_INDEX_KEY &&
-		    btrfs_should_delete_dir_index(&del_list,
-						  found_key.offset))
+		if (btrfs_should_delete_dir_index(&del_list, found_key.offset))
 			goto next;
 
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
@@ -5165,8 +5160,8 @@ next:
 nopos:
 	ret = 0;
 err:
-	if (key_type == BTRFS_DIR_INDEX_KEY)
-		btrfs_put_delayed_items(&ins_list, &del_list);
+	btrfs_put_delayed_items(&ins_list);
+	btrfs_put_delayed_items(&del_list);
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.11.7

