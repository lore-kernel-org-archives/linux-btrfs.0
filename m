Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43603C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 08:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C0E220879
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 08:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfCYIXO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 04:23:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:36594 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729943AbfCYIXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 04:23:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EE538AEBB
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 08:23:11 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] btrfs: check/lowmem: Check and repair free space cache inode mode
Date:   Mon, 25 Mar 2019 16:22:51 +0800
Message-Id: <20190325082253.19583-6-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190325082253.19583-1-wqu@suse.com>
References: <20190325082253.19583-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Unlike inodes in fs roots, we don't really check the inode items in root
tree, in fact we just skip everything other than ROOT_ITEM and ROOT_REF.

This makes invalid inode items sneak into root tree.
For example:
        item 9 key (256 INODE_ITEM 0) itemoff 13702 itemsize 160
                generation 30 transid 30 size 65536 nbytes 1507328
                block group 0 mode 0 links 1 uid 0 gid 0 rdev 0
				   ^ Should be 100600
                sequence 23 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
                atime 0.0 (1970-01-01 08:00:00)
                ctime 1553491158.189771625 (2019-03-25 13:19:18)
                mtime 0.0 (1970-01-01 08:00:00)
                otime 0.0 (1970-01-01 08:00:00)

There is a report of such problem in the mail list.

This patch will check and repair inode items of free space cache inodes in
lowmem mode.

Since free space cache inodes doesn't have INODE_REF but still has 1
link, we can't use check_inode_item() directly.
Instead we only check the inode mode, as that's the important part.

The check and repair function: check_repair_free_space_inode() is also
exported for original mode.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-common.h |  1 +
 check/mode-lowmem.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 check/mode-lowmem.h |  2 ++
 3 files changed, 48 insertions(+)

diff --git a/check/mode-common.h b/check/mode-common.h
index 8895747adf1d..855f83617854 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -24,6 +24,7 @@
 #include <sys/stat.h>
 #include "ctree.h"
 
+#define FREE_SPACE_CACHE_INODE_MODE	(0100600)
 /*
  * Use for tree walk to walk through trees whose leaves/nodes can be shared
  * between different trees. (Namely subvolume/fs trees)
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index f37c3b42e6b6..cdb9b66a63a3 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -5091,6 +5091,40 @@ out:
 	return err;
 }
 
+/*
+ * For free space inodes, we can't call check_inode_item() as free space
+ * cache inode doesn't have INODE_REF.
+ * We just check its inode mode.
+ */
+int check_repair_free_space_inode(struct btrfs_fs_info *fs_info,
+				  struct btrfs_path *path)
+{
+	struct btrfs_inode_item *iitem;
+	struct btrfs_key key;
+	u32 mode;
+	int ret = 0;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	ASSERT(key.type == BTRFS_INODE_ITEM_KEY && is_fstree(key.objectid));
+	iitem = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			       struct btrfs_inode_item);
+	mode = btrfs_inode_mode(path->nodes[0], iitem);
+	if (mode != FREE_SPACE_CACHE_INODE_MODE) {
+		error(
+	"free space cache inode %llu has invalid mode: has 0%o expect 0%o",
+			key.objectid, mode, FREE_SPACE_CACHE_INODE_MODE);
+		ret = -EUCLEAN;
+		if (repair) {
+			ret = repair_imode_lowmem(fs_info->tree_root,
+						  path);
+			if (ret < 0)
+				return ret;
+			return ret;
+		}
+	}
+	return ret;
+}
+
 /*
  * Check all fs/file tree in low_memory mode.
  *
@@ -5130,6 +5164,17 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
 		btrfs_item_key_to_cpu(node, &key, slot);
 		if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
 			goto out;
+		if (key.type == BTRFS_INODE_ITEM_KEY &&
+		    is_fstree(key.objectid)) {
+			ret = check_repair_free_space_inode(fs_info, &path);
+			/* Check if we still have a valid path to continue */
+			if (ret < 0 && path.nodes[0]) {
+				err |= ret;
+				goto next;
+			}
+			if (ret < 0 && !path.nodes[0])
+				goto out;
+		}
 		if (key.type == BTRFS_ROOT_ITEM_KEY &&
 		    fs_root_objectid(key.objectid)) {
 			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
index e0ab30b770d5..d2983fd12eb4 100644
--- a/check/mode-lowmem.h
+++ b/check/mode-lowmem.h
@@ -67,5 +67,7 @@
 
 int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info);
 int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info);
+int check_repair_free_space_inode(struct btrfs_fs_info *fs_info,
+				  struct btrfs_path *path);
 
 #endif
-- 
2.21.0

