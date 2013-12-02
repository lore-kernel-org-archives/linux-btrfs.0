Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49064 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3LBHWi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Dec 2013 02:22:38 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rB27MbNt024959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 07:22:37 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB27MZqf003159
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 07:22:37 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rB27MZ2n003145
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Dec 2013 07:22:35 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix bus error on sparc
Date: Mon,  2 Dec 2013 15:22:27 +0800
Message-Id: <1385968947-8630-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A type punning from (void *) to (u64 *) plus reading its value will cause
bus error on the Linux OS installed on sparc arch, because sparc core will
do a misaligned access and we don't have an option like -misalign or -xmemalign
in gcc.

Instead we introduce a struct to avoid the memory misalignment.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 disk-io.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 0af3898..eed7d7e 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -650,10 +650,14 @@ insert:
 	return root;
 }
 
+struct root_obj {
+	u64 objectid;
+};
+
 static int btrfs_fs_roots_compare_objectids(struct rb_node *node,
 					    void *data)
 {
-	u64 objectid = *((u64 *)data);
+	u64 objectid = ((struct root_obj *)data)->objectid;
 	struct btrfs_root *root;
 
 	root = rb_entry(node, struct btrfs_root, rb_node);
@@ -669,9 +673,11 @@ static int btrfs_fs_roots_compare_roots(struct rb_node *node1,
 					struct rb_node *node2)
 {
 	struct btrfs_root *root;
+	struct root_obj obj;
 
 	root = rb_entry(node2, struct btrfs_root, rb_node);
-	return btrfs_fs_roots_compare_objectids(node1, (void *)&root->objectid);
+	obj.objectid = root->objectid;
+	return btrfs_fs_roots_compare_objectids(node1, (void *)&obj);
 }
 
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
@@ -680,6 +686,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *root;
 	struct rb_node *node;
 	int ret;
+	struct root_obj obj;
 
 	if (location->objectid == BTRFS_ROOT_TREE_OBJECTID)
 		return fs_info->tree_root;
@@ -695,7 +702,8 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	       location->offset != (u64)-1);
 
-	node = rb_search(&fs_info->fs_root_tree, (void *)&location->objectid,
+	obj.objectid = location->objectid;
+	node = rb_search(&fs_info->fs_root_tree, (void *)&obj,
 			 btrfs_fs_roots_compare_objectids, NULL);
 	if (node)
 		return container_of(node, struct btrfs_root, rb_node);
-- 
1.8.1.4

