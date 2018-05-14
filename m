Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3707 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752259AbeENKXf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 06:23:35 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 4A0464B3ED60
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 18:23:29 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: lowmem: check symlinks with append/immutable flags
Date: Mon, 14 May 2018 18:29:21 +0800
Message-ID: <20180514102922.8840-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Symlinks should never have append/immutable flags.
While checking inodes, if found a symlink with append/immutable
flags, report and record the fatal error.

This is for lowmem mode.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 9890180d1d3c..61c4e7f23d47 100644
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
 
+	if (mode & BTRFS_FT_SYMLINK &&
+	    (flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND))) {
+		err = FATAL_ERROR;
+		error(
+"symlinks shall never be with immutable/append, root %llu inode item [%llu] flags %llu may be corrupted",
+		      root->objectid, inode_id, flags);
+	}
+
 	while (1) {
 		btrfs_item_key_to_cpu(path->nodes[0], &last_key, path->slots[0]);
 		ret = btrfs_next_item(root, path);
-- 
2.17.0



