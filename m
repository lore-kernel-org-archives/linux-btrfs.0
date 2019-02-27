Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06081C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C504D21852
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfB0GGK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 01:06:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:34000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbfB0GGK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 01:06:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 764B6AC5F;
        Wed, 27 Feb 2019 06:06:09 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v1.1 02/14] btrfs-progs: lowmem: add argument path to punch_extent_hole()
Date:   Wed, 27 Feb 2019 14:05:40 +0800
Message-Id: <20190227060552.3841-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190227060552.3841-1-wqu@suse.com>
References: <20190227060552.3841-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

Since repair will do CoW, the outer path may be invalid.

This patch will add an argument, @path, to punch_extent_hole().
When punch_extent_hole() returns, path will still point to the same key.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
[Update comment and commit message]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index bbda2bb23c65..1754d60c7a75 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1756,28 +1756,37 @@ out:
 /*
  * Wrapper function of btrfs_punch_hole.
  *
+ * @path:	The path holder, will point to the same key after hole punching.
+ *
  * Returns 0 means success.
  * Returns not 0 means error.
  */
-static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
-			     u64 len)
+static int punch_extent_hole(struct btrfs_root *root, struct btrfs_path *path,
+			     u64 ino, u64 start, u64 len)
 {
 	struct btrfs_trans_handle *trans;
-	int ret = 0;
+	struct btrfs_key key;
+	int ret;
 
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
 	ret = btrfs_punch_hole(trans, root, ino, start, len);
-	if (ret)
+	if (ret) {
 		error("failed to add hole [%llu, %llu] in inode [%llu]",
 		      start, len, ino);
-	else
-		printf("Add a hole [%llu, %llu] in inode [%llu]\n", start, len,
-		       ino);
-
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
+	printf("Add a hole [%llu, %llu] in inode [%llu]\n", start, len, ino);
 	btrfs_commit_transaction(trans, root);
+
+	btrfs_release_path(path);
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
 	return ret;
 }
 
@@ -2028,7 +2037,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 	/* Check EXTENT_DATA hole */
 	if (!no_holes && *end != fkey.offset) {
 		if (repair)
-			ret = punch_extent_hole(root, fkey.objectid,
+			ret = punch_extent_hole(root, path, fkey.objectid,
 						*end, fkey.offset - *end);
 		if (!repair || ret) {
 			err |= FILE_EXTENT_ERROR;
@@ -2599,7 +2608,7 @@ out:
 
 		if (!nbytes && !no_holes && extent_end < isize) {
 			if (repair)
-				ret = punch_extent_hole(root, inode_id,
+				ret = punch_extent_hole(root, path, inode_id,
 						extent_end, isize - extent_end);
 			if (!repair || ret) {
 				err |= NBYTES_ERROR;
-- 
2.21.0

