Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35970 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752336AbeFGGtl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 02:49:41 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 2/3] btrfs-progs: check: lowmem: check symlinks with append/immutable flags
Date: Thu, 7 Jun 2018 14:55:41 +0800
Message-ID: <20180607065542.17273-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180607065542.17273-1-suy.fnst@cn.fujitsu.com>
References: <20180607065542.17273-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Define new error bit INODE_FLAGS_ERROR to represents invalid inode
flags error.

Symlinks should never have append/immutable flags set.
While checking inodes, if found a symlink with append/immutable
flags, report and record the inode flags error.

This is for lowmem mode.

Issue: #133
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 check/mode-lowmem.c | 10 ++++++++++
 check/mode-lowmem.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 989306f03c2a..66da45319053 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2274,6 +2274,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 	struct btrfs_key last_key;
 	u64 inode_id;
 	u32 mode;
+	u64 flags;
 	u64 nlink;
 	u64 nbytes;
 	u64 isize;
@@ -2307,10 +2308,19 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 	isize = btrfs_inode_size(node, ii);
 	nbytes = btrfs_inode_nbytes(node, ii);
 	mode = btrfs_inode_mode(node, ii);
+	flags = btrfs_inode_flags(node, ii);
 	dir = imode_to_type(mode) == BTRFS_FT_DIR;
 	nlink = btrfs_inode_nlink(node, ii);
 	nodatasum = btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
 
+	if (S_ISLNK(mode) &&
+	    flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND)) {
+		err |= INODE_FLAGS_ERROR;
+		error(
+"symlinks must never have immutable/append flags set, root %llu inode item %llu flags %llu may be corrupted",
+		      root->objectid, inode_id, flags);
+	}
+
 	while (1) {
 		btrfs_item_key_to_cpu(path->nodes[0], &last_key, path->slots[0]);
 		ret = btrfs_next_item(root, path);
diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
index e7ba62e2413e..91f7b6b1db53 100644
--- a/check/mode-lowmem.h
+++ b/check/mode-lowmem.h
@@ -44,6 +44,7 @@
 #define DIR_COUNT_AGAIN         (1<<20) /* DIR isize should be recalculated */
 #define BG_ACCOUNTING_ERROR     (1<<21) /* Block group accounting error */
 #define FATAL_ERROR             (1<<22) /* Fatal bit for errno */
+#define INODE_FLAGS_ERROR	(1<<23) /* Invalid inode flags */
 
 /*
  * Error bit for low memory mode check.
-- 
2.17.1



