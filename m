Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:42321 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbeCSIRt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 04:17:49 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B2A04AC0065
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 17:17:41 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 02C62BD6625
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Mar 2018 17:17:41 +0900 (JST)
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of FS_TREE
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <7ca269db-a724-5938-f4d8-b85e893fd558@jp.fujitsu.com>
Date: Mon, 19 Mar 2018 17:16:42 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, the top-level subvolume lacks the UUID. As a result, both
non-snapshot subvolume and snapshot of top-level subvolume do not have
Parent UUID and cannot be distinguisued. Therefore "fi show" of
top-level lists all the subvolumes which lacks the UUID in
"Snapshot(s)" filed.  Also, it lacks the otime information.

Fix this by adding the UUID and otime at the mkfs time.  As a
consequence, snapshots of top-level subvolume now have a Parent UUID and
UUID tree will create an entry for top-level subvolume at mount time.
This should not cause the problem for current kernel, but user program
which relies on the empty Parent UUID may be affected by this change.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
This is also needed in order that "sub list -s" works properly for
non-privileged user[1] even if there are snapshots of toplevel subvolume.

Currently the check if a subvolume is a snapshot is done by looking at the key
offset of ROOT_ITEM of subvolume (non-zero for snapshot) used by tree search ioctl.
However, non-privileged version of "sub list" won't use tree search ioctl and just
looking if parent uuid is null or not. Therefore there is no way to recognize
snapshots of toplevel subvolume.

[1] https://marc.info/?l=linux-btrfs&m=152144463907830&w=2

 mkfs/common.c | 14 ++++++++++++++
 mkfs/main.c   |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/mkfs/common.c b/mkfs/common.c
index 16916ca2..6924d9b7 100644
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
+			memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
+			btrfs_set_stack_timespec_sec(&root_item.otime, now);
+			btrfs_set_stack_timespec_sec(&root_item.ctime, now);
+		} else {
+			memset(uuid, 0, BTRFS_UUID_SIZE);
+			memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
+			btrfs_set_stack_timespec_sec(&root_item.otime, 0);
+			btrfs_set_stack_timespec_sec(&root_item.ctime, 0);
+		}
 		write_extent_buffer(buf, &root_item,
 			btrfs_item_ptr_offset(buf, nritems),
 			sizeof(root_item));
diff --git a/mkfs/main.c b/mkfs/main.c
index 5a717f70..52d92581 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -315,6 +315,7 @@ static int create_tree(struct btrfs_trans_handle *trans,
 	struct btrfs_key location;
 	struct btrfs_root_item root_item;
 	struct extent_buffer *tmp;
+	u8 uuid[BTRFS_UUID_SIZE] = {0};
 	int ret;
 
 	ret = btrfs_copy_root(trans, root, root->node, &tmp, objectid);
@@ -325,6 +326,8 @@ static int create_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_root_bytenr(&root_item, tmp->start);
 	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
 	btrfs_set_root_generation(&root_item, trans->transid);
+	/* clear uuid of source tree */
+	memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
 	free_extent_buffer(tmp);
 
 	location.objectid = objectid;
-- 
2.14.3

