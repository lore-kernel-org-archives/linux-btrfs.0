Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8705AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C1B720850
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 05:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfDAF4E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 01:56:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:54348 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfDAF4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 01:56:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1043DACBF
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2019 05:56:02 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/7] btrfs-progs: check/lowmem: Repair invalid inode mode in root tree
Date:   Mon,  1 Apr 2019 13:55:47 +0800
Message-Id: <20190401055551.6837-4-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190401055551.6837-1-wqu@suse.com>
References: <20190401055551.6837-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In root tree, we only have 2 types of inodes:
- ROOT_TREE_DIR inode
  Its mode is fixed to 40755
- free space cache inodes
  Its mode is fixed to 100600

This patch will add the ability to repair such inodes to lowmem mode.
For fs/subvolume tree error, at least we haven't see such corruption
yet, so we don't need to rush to fix corruption in fs trees yet.

The repair function, reset_imode() and repair_imode_common() can be
reused by later original mode patch, so it's placed in check/mode-common.c.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-common.c | 94 +++++++++++++++++++++++++++++++++++++++++++++
 check/mode-common.h |  3 ++
 check/mode-lowmem.c |  8 +++-
 3 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/check/mode-common.c b/check/mode-common.c
index fed102b0ce7a..466e7a8d09a7 100644
--- a/check/mode-common.c
+++ b/check/mode-common.c
@@ -795,3 +795,97 @@ out:
 	btrfs_release_path(&path);
 	return ret;
 }
+
+/*
+ * Reset the mode of inode (specified by @root and @ino) to @mode.
+ *
+ * Caller should ensure @path is not populated, the @path is mainly for caller
+ * to grab the correct new path of the inode.
+ *
+ * Return 0 if repair is done, @path will point to the correct inode item.
+ * Return <0 for errors.
+ */
+int reset_imode(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		struct btrfs_path *path, u64 ino, u32 mode)
+{
+	struct btrfs_inode_item *iitem;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	int slot;
+	int ret;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0) {
+		errno = -ret;
+		error("failed to search tree %llu: %m",
+		      root->root_key.objectid);
+		return ret;
+	}
+	leaf = path->nodes[0];
+	slot = path->slots[0];
+	iitem = btrfs_item_ptr(leaf, slot, struct btrfs_inode_item);
+	btrfs_set_inode_mode(leaf, iitem, mode);
+	btrfs_mark_buffer_dirty(leaf);
+	return ret;
+}
+
+/*
+ * Reset the inode mode of the inode specified by @path.
+ *
+ * Caller should ensure the @path is pointing to an INODE_ITEM and root is tree
+ * root. Repair imode for other trees is not supported yet.
+ *
+ * Return 0 if repair is successful.
+ * Return <0 if error happens.
+ */
+int repair_imode_common(struct btrfs_root *root, struct btrfs_path *path)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	u32 imode;
+	int ret;
+
+	if (root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID) {
+		error(
+		"repair inode mode outside of root tree is not supported yet");
+		return -ENOTTY;
+	}
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	ASSERT(key.type == BTRFS_INODE_ITEM_KEY);
+	if (key.objectid != BTRFS_ROOT_TREE_DIR_OBJECTID &&
+	    !is_fstree(key.objectid)) {
+		error("unsupported ino %llu", key.objectid);
+		return -ENOTTY;
+	}
+	if (key.objectid == BTRFS_ROOT_TREE_DIR_OBJECTID)
+		imode = 040755;
+	else
+		imode = 0100600;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		errno = -ret;
+		error("failed to start transaction: %m");
+		return ret;
+	}
+	btrfs_release_path(path);
+
+	ret = reset_imode(trans, root, path, key.objectid, imode);
+	if (ret < 0)
+		goto abort;
+	ret = btrfs_commit_transaction(trans, root);
+	if (!ret)
+		printf("reset mode for inode %llu root %llu\n",
+			key.objectid, root->root_key.objectid);
+	return ret;
+abort:
+	btrfs_abort_transaction(trans, ret);
+ 	return ret;
+}
diff --git a/check/mode-common.h b/check/mode-common.h
index 4c88365abbcc..5aaf3aaa389b 100644
--- a/check/mode-common.h
+++ b/check/mode-common.h
@@ -125,6 +125,9 @@ int delete_corrupted_dir_item(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct btrfs_key *di_key, char *namebuf,
 			      u32 namelen);
+int reset_imode(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		struct btrfs_path *path, u64 ino, u32 mode);
+int repair_imode_common(struct btrfs_root *root, struct btrfs_path *path);
 
 /*
  * Check if the inode mode @imode is valid
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1553a4a5d2c1..8ecf27795c36 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2454,7 +2454,13 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 
 	if (!is_valid_imode(mode)) {
 		error("invalid imode mode bits: 0%o", mode);
-		err |= INODE_MODE_ERROR;
+		if (repair) {
+			ret = repair_imode_common(root, path);
+			if (ret < 0)
+				err |= INODE_MODE_ERROR;
+		} else {
+			err |= INODE_MODE_ERROR;
+		}
 	}
 
 	if (S_ISLNK(mode) &&
-- 
2.21.0

