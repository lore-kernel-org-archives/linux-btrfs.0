Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A7BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 10:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6901520811
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 10:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="Kae7+dAb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfC2KDp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 06:03:45 -0400
Received: from mail.synology.com ([211.23.38.101]:47030 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726590AbfC2KDp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 06:03:45 -0400
Received: from localhost.localdomain (unknown [10.17.32.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id ABDB51A45196D;
        Fri, 29 Mar 2019 18:03:41 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1553853821; bh=RIAZB/ewQi9evgEe+dRdDTz27ifpTwG28KPFgMOYLUo=;
        h=From:To:Cc:Subject:Date;
        b=Kae7+dAbcBiN/yNVhd6mUGLhnT7CThckvHPy0b5SX+kFgKkNMkQV1yHGOljfvjvqL
         zr8USoqv1ejHQK/1KQNrLGJAg1NBiORvGSSfbgj/28eWuHiSFjRyJcqze4Qy/0MiUA
         XhXoWbDfgByI0aCM2+458CmW5iFVAWG4vn8KOeYs=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2] Btrfs: send, improve clone range
Date:   Fri, 29 Mar 2019 18:03:27 +0800
Message-Id: <1553853807-25293-1-git-send-email-robbieko@synology.com>
X-Mailer: git-send-email 1.9.1
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

Improve clone_range two use scenarios.

1. Remove the limit of inode size when find clone inodes
We can do partial clone, so there is no need to limit the
size of the candidate inode.
When clone a range, we clone the legal range only by bytenr,
offset, len, inode size.

2. In the scenarios of rewrite or clone_range, data_offset
rarely matches exactly, so the chance of a clone is missed.

e.g.
    1. Write a 1M file
        dd if=/dev/zero of=1M bs=1M count=1

    2. Clone 1M file
       cp --reflink 1M clone

    3. Rewrite 4k on the clone file
       dd if=/dev/zero of=clone bs=4k count=1 conv=notrunc

    The disk layout is as follows:
    item 16 key (257 EXTENT_DATA 0) itemoff 15353 itemsize 53
	extent data disk byte 1103101952 nr 1048576
	extent data offset 0 nr 1048576 ram 1048576
	extent compression(none)
    ...
    item 22 key (258 EXTENT_DATA 0) itemoff 14959 itemsize 53
	extent data disk byte 1104150528 nr 4096
	extent data offset 0 nr 4096 ram 4096
	extent compression(none)
    item 23 key (258 EXTENT_DATA 4096) itemoff 14906 itemsize 53
	extent data disk byte 1103101952 nr 1048576
	extent data offset 4096 nr 1044480 ram 1048576
	extent compression(none)

When send, inode 258 file offset 4096~1048576 (item 23) has a
chance to clone_range, but because data_offset does not match
inode 257 (item 16), it causes missed clone and can only transfer
actual data.

Improve the problem by judging whether the current data_offset
has overlap with the file extent item, and if so, adjusting
offset and extent_len so that we can clone correctly.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
V2:
* fix clone error when offset > isize
* fix uninitialized warning
* remove unused variable backref_ctx->path

 fs/btrfs/send.c | 52 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7ea2d6b..1e9caa5 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1160,7 +1160,6 @@ static int get_inode_path(struct btrfs_root *root,
 struct backref_ctx {
 	struct send_ctx *sctx;
 
-	struct btrfs_path *path;
 	/* number of total found references */
 	u64 found;
 
@@ -1213,8 +1212,6 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
 {
 	struct backref_ctx *bctx = ctx_;
 	struct clone_root *found;
-	int ret;
-	u64 i_size;
 
 	/* First check if the root is in the list of accepted clone sources */
 	found = bsearch((void *)(uintptr_t)root, bctx->sctx->clone_roots,
@@ -1231,19 +1228,6 @@ static int __iterate_backrefs(u64 ino, u64 offset, u64 root, void *ctx_)
 	}
 
 	/*
-	 * There are inodes that have extents that lie behind its i_size. Don't
-	 * accept clones from these extents.
-	 */
-	ret = __get_inode_info(found->root, bctx->path, ino, &i_size, NULL, NULL,
-			       NULL, NULL, NULL);
-	btrfs_release_path(bctx->path);
-	if (ret < 0)
-		return ret;
-
-	if (offset + bctx->data_offset + bctx->extent_len > i_size)
-		return 0;
-
-	/*
 	 * Make sure we don't consider clones from send_root that are
 	 * behind the current inode/offset.
 	 */
@@ -1319,8 +1303,6 @@ static int find_extent_clone(struct send_ctx *sctx,
 		goto out;
 	}
 
-	backref_ctx->path = tmp_path;
-
 	if (data_offset >= ino_size) {
 		/*
 		 * There may be extents that lie behind the file's size.
@@ -5082,6 +5064,7 @@ static int clone_range(struct send_ctx *sctx,
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	int ret;
+	u64 clone_src_i_size;
 
 	/*
 	 * Prevent cloning from a zero offset with a length matching the sector
@@ -5107,6 +5090,16 @@ static int clone_range(struct send_ctx *sctx,
 		return -ENOMEM;
 
 	/*
+	 * There are inodes that have extents that lie behind its i_size. Don't
+	 * accept clones from these extents.
+	 */
+	ret = __get_inode_info(clone_root->root, path, clone_root->ino,
+			       &clone_src_i_size, NULL, NULL, NULL, NULL, NULL);
+	btrfs_release_path(path);
+	if (ret < 0)
+		goto out;
+
+	/*
 	 * We can't send a clone operation for the entire range if we find
 	 * extent items in the respective range in the source file that
 	 * refer to different extents or if we find holes.
@@ -5148,6 +5141,7 @@ static int clone_range(struct send_ctx *sctx,
 		u8 type;
 		u64 ext_len;
 		u64 clone_len;
+		u64 clone_data_offset;
 
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(clone_root->root, path);
@@ -5201,10 +5195,30 @@ static int clone_range(struct send_ctx *sctx,
 		if (key.offset >= clone_root->offset + len)
 			break;
 
+		if (key.offset >= clone_src_i_size)
+			break;
+
+		if (key.offset + ext_len > clone_src_i_size)
+			ext_len = clone_src_i_size - key.offset;
+
+		clone_data_offset = btrfs_file_extent_offset(leaf, ei);
+		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte) {
+			clone_root->offset = key.offset;
+			if (clone_data_offset < data_offset &&
+				clone_data_offset + ext_len > data_offset) {
+				u64 extent_offset;
+
+				extent_offset = data_offset - clone_data_offset;
+				ext_len -= extent_offset;
+				clone_data_offset += extent_offset;
+				clone_root->offset += extent_offset;
+			}
+		}
+
 		clone_len = min_t(u64, ext_len, len);
 
 		if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte &&
-		    btrfs_file_extent_offset(leaf, ei) == data_offset)
+		    clone_data_offset == data_offset)
 			ret = send_clone(sctx, offset, clone_len, clone_root);
 		else
 			ret = send_extent_data(sctx, offset, clone_len);
-- 
1.9.1

