Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:30243 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752169AbdJ3IO1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 04:14:27 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 50F33AC00AC
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 17:14:20 +0900 (JST)
Received: from g01jpexchkw37.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id A0C9A328646
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 17:14:19 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of
 FS_TREE
Message-ID: <c5cfe661-fb6a-8346-874b-b20cd9cf0d90@jp.fujitsu.com>
Date: Mon, 30 Oct 2017 17:14:15 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the top-level subvolume lacks the UUID. As a result, both
non-snapshot subvolume and snapshot of top-level subvolume do not have
Parent UUID and cannot be distinguisued. Therefore "fi show" of
top-level lists all the subvolumes which lacks the UUID in
"Snapshot(s)". Also, it lacks the otime information.

Fix this by adding the UUID and otime at the mkfs time.  As a
consequence, snapshots of top-level subvolume now have a Parent UUID and
UUID tree will create an entry for top-level subvolume at mount time.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 ctree.h       |  5 +++++
 mkfs/common.c | 14 ++++++++++++++
 mkfs/main.c   |  3 +++
 3 files changed, 22 insertions(+)

diff --git a/ctree.h b/ctree.h
index 2280659..5737978 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2071,6 +2071,11 @@ BTRFS_SETGET_STACK_FUNCS(root_stransid, struct btrfs_root_item,
 			 stransid, 64);
 BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
 			 rtransid, 64);
+static inline void btrfs_set_root_uuid(struct btrfs_root_item *root_item,
+			 u8 uuid[BTRFS_UUID_SIZE])
+{
+	memcpy(root_item->uuid, uuid, BTRFS_UUID_SIZE);
+}
 
 /* struct btrfs_root_backup */
 BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
diff --git a/mkfs/common.c b/mkfs/common.c
index c9ce10d..808d343 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -44,6 +44,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	u32 itemoff;
 	int ret = 0;
 	int blk;
+	u8 uuid[BTRFS_UUID_SIZE];
 
 	memset(buf->data + sizeof(struct btrfs_header), 0,
 		cfg->nodesize - sizeof(struct btrfs_header));
@@ -77,6 +78,19 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 		btrfs_set_item_offset(buf, btrfs_item_nr(nritems), itemoff);
 		btrfs_set_item_size(buf, btrfs_item_nr(nritems),
 				sizeof(root_item));
+		if (blk == MKFS_FS_TREE) {
+			time_t now = time(NULL);
+
+			uuid_generate(uuid);
+			btrfs_set_root_uuid(&root_item, uuid);
+			btrfs_set_stack_timespec_sec(&root_item.otime, now);
+			btrfs_set_stack_timespec_sec(&root_item.ctime, now);
+		} else {
+			memset(uuid, 0, BTRFS_UUID_SIZE);
+			btrfs_set_root_uuid(&root_item, uuid);
+			btrfs_set_stack_timespec_sec(&root_item.otime, 0);
+			btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
+		}
 		write_extent_buffer(buf, &root_item,
 			btrfs_item_ptr_offset(buf, nritems),
 			sizeof(root_item));
diff --git a/mkfs/main.c b/mkfs/main.c
index 1b4cabc..4184a2d 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -329,6 +329,7 @@ static int create_tree(struct btrfs_trans_handle *trans,
 	struct btrfs_key location;
 	struct btrfs_root_item root_item;
 	struct extent_buffer *tmp;
+	u8 uuid[BTRFS_UUID_SIZE] = {0};
 	int ret;
 
 	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
@@ -339,6 +340,8 @@ static int create_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_root_bytenr(&root_item, tmp->start);
 	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
 	btrfs_set_root_generation(&root_item, trans->transid);
+	/* clear uuid of source tree */
+	btrfs_set_root_uuid(&root_item, uuid);
 	free_extent_buffer(tmp);
 
 	location.objectid = objectid;
-- 
2.9.5

