Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3FDWSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 18:18:07 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54MI7nj007720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:07 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r54MI2Q7002655
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:07 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: add helper to get delayed item root
Date: Tue,  4 Jun 2013 15:17:59 -0700
Message-Id: <1370384280-28652-6-git-send-email-zab@redhat.com>
In-Reply-To: <1370384280-28652-1-git-send-email-zab@redhat.com>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This just moves some duplicated code into a helper.  I couldn't bring
myself to add another copy in an upcoming patch.

The delayed_root BUG() in __btrfs_remove_delayed_item() wasn't needed.
The pointer deref will oops later if its null.

And now the remaining BUG() is in one place! :)

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/delayed-inode.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 67e0f9f..fcce951 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -382,6 +382,16 @@ static struct btrfs_delayed_item *__btrfs_lookup_delayed_insertion_item(
 	return item;
 }
 
+static struct rb_root *get_ins_del_root(struct btrfs_delayed_node *delayed_node,
+					int ins_del)
+{
+	if (ins_del == BTRFS_DELAYED_INSERTION_ITEM)
+		return &delayed_node->ins_root;
+	if (ins_del == BTRFS_DELAYED_DELETION_ITEM)
+		return &delayed_node->del_root;
+	BUG();
+}
+
 static int __btrfs_add_delayed_item(struct btrfs_delayed_node *delayed_node,
 				    struct btrfs_delayed_item *ins,
 				    int action)
@@ -392,12 +402,7 @@ static int __btrfs_add_delayed_item(struct btrfs_delayed_node *delayed_node,
 	struct btrfs_delayed_item *item;
 	int cmp;
 
-	if (action == BTRFS_DELAYED_INSERTION_ITEM)
-		root = &delayed_node->ins_root;
-	else if (action == BTRFS_DELAYED_DELETION_ITEM)
-		root = &delayed_node->del_root;
-	else
-		BUG();
+	root = get_ins_del_root(delayed_node, action);
 	p = &root->rb_node;
 	node = &ins->rb_node;
 
@@ -460,15 +465,8 @@ static void __btrfs_remove_delayed_item(struct btrfs_delayed_item *delayed_item)
 
 	delayed_root = delayed_item->delayed_node->root->fs_info->delayed_root;
 
-	BUG_ON(!delayed_root);
-	BUG_ON(delayed_item->ins_or_del != BTRFS_DELAYED_DELETION_ITEM &&
-	       delayed_item->ins_or_del != BTRFS_DELAYED_INSERTION_ITEM);
-
-	if (delayed_item->ins_or_del == BTRFS_DELAYED_INSERTION_ITEM)
-		root = &delayed_item->delayed_node->ins_root;
-	else
-		root = &delayed_item->delayed_node->del_root;
-
+	root = get_ins_del_root(delayed_item->delayed_node,
+				delayed_item->ins_or_del);
 	rb_erase(&delayed_item->rb_node, root);
 	delayed_item->delayed_node->count--;
 
-- 
1.7.11.7

