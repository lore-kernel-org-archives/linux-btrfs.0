Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3FDWSI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 18:18:08 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54MI8I5007724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:08 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r54MI2Q8002655
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:08 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: get fewer delayed item refs during readdir
Date: Tue,  4 Jun 2013 15:18:00 -0700
Message-Id: <1370384280-28652-7-git-send-email-zab@redhat.com>
In-Reply-To: <1370384280-28652-1-git-send-email-zab@redhat.com>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On every readdir call all the delayed items for the dir are put on a
private list with a held reference.  If they're outside the f_pos values
that this readdir call ends up using they're just dropped and removed
from the list.  We can make some tiny changes to cut down on this
overhead.

First, let's use the delayed item's key-sorted rbtree to skip items that
are before f_pos and will never be used.

Second, let's only acquire the new delayed items after we've exausted
the existing in-tree items and still have room in the readdir buffer for
more entries.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/delayed-inode.c | 21 ++++++++++-----------
 fs/btrfs/delayed-inode.h |  4 ++--
 fs/btrfs/inode.c         | 14 +++++++++++---
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index fcce951..2c3ec89 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1567,28 +1567,27 @@ int btrfs_inode_delayed_dir_index_count(struct inode *inode)
 	return 0;
 }
 
-void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
-			     struct list_head *del_list)
+void btrfs_get_delayed_items(struct inode *inode, struct list_head *list,
+			     struct btrfs_key *key, int action)
 {
 	struct btrfs_delayed_node *delayed_node;
 	struct btrfs_delayed_item *item;
+	struct btrfs_delayed_item *next;
+	struct rb_root *root;
 
 	delayed_node = btrfs_get_delayed_node(inode);
 	if (!delayed_node)
 		return;
 
-	mutex_lock(&delayed_node->mutex);
-	item = __btrfs_first_delayed_insertion_item(delayed_node);
-	while (item) {
-		atomic_inc(&item->refs);
-		list_add_tail(&item->readdir_list, ins_list);
-		item = __btrfs_next_delayed_item(item);
-	}
+	root = get_ins_del_root(delayed_node, action);
 
-	item = __btrfs_first_delayed_deletion_item(delayed_node);
+	mutex_lock(&delayed_node->mutex);
+	item = __btrfs_lookup_delayed_item(root, key, NULL, &next);
+	if (item == NULL)
+		item = next;
 	while (item) {
 		atomic_inc(&item->refs);
-		list_add_tail(&item->readdir_list, del_list);
+		list_add_tail(&item->readdir_list, list);
 		item = __btrfs_next_delayed_item(item);
 	}
 	mutex_unlock(&delayed_node->mutex);
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 573506b..7c401e1 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -133,8 +133,8 @@ void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
 void btrfs_destroy_delayed_inodes(struct btrfs_root *root);
 
 /* Used for readdir() */
-void btrfs_get_delayed_items(struct inode *inode, struct list_head *ins_list,
-			     struct list_head *del_list);
+void btrfs_get_delayed_items(struct inode *inode, struct list_head *list,
+			     struct btrfs_key *key, int action);
 void btrfs_put_delayed_items(struct list_head *list);
 int btrfs_should_delete_dir_index(struct list_head *del_list,
 				  u64 index);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 53a8696..ad42724 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5048,13 +5048,14 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 	path->reada = 1;
 
-	if (key_type == BTRFS_DIR_INDEX_KEY)
-		btrfs_get_delayed_items(inode, &ins_list, &del_list);
-
 	btrfs_set_key_type(&key, key_type);
 	key.offset = filp->f_pos;
 	key.objectid = btrfs_ino(inode);
 
+	if (key_type == BTRFS_DIR_INDEX_KEY)
+		btrfs_get_delayed_items(inode, &del_list, &key,
+					BTRFS_DELAYED_DELETION_ITEM);
+
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
 		goto err;
@@ -5146,7 +5147,14 @@ next:
 		path->slots[0]++;
 	}
 
+	/* don't acquire delayed item mutex while holding locked path */
+	btrfs_free_path(path);
+	path = NULL;
+
 	if (key_type == BTRFS_DIR_INDEX_KEY) {
+		key.offset = filp->f_pos;
+		btrfs_get_delayed_items(inode, &ins_list, &key,
+					BTRFS_DELAYED_INSERTION_ITEM);
 		ret = btrfs_readdir_delayed_dir_index(filp, dirent, filldir,
 						      &ins_list);
 		if (ret)
-- 
1.7.11.7

