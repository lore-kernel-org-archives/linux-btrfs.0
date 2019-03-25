Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E467C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E685D20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730429AbfCYSp6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:39140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730422AbfCYSp5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF6D9AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6591FDA98F; Mon, 25 Mar 2019 19:47:09 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 24/30] btrfs: get fs_info from eb in btrfs_check_leaf_relaxed
Date:   Mon, 25 Mar 2019 19:47:09 +0100
Message-Id: <f5945e0bb826d82fd936162d83025a7c3a95d256.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c      | 2 +-
 fs/btrfs/tree-checker.c | 3 +--
 fs/btrfs/tree-checker.h | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index eb7323e40006..b6a813705023 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4127,7 +4127,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	 * So here we should only check item pointers, not item data.
 	 */
 	if (btrfs_header_level(buf) == 0 &&
-	    btrfs_check_leaf_relaxed(fs_info, buf)) {
+	    btrfs_check_leaf_relaxed(buf)) {
 		btrfs_print_leaf(buf);
 		ASSERT(0);
 	}
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 271694a479fd..0c908a49a525 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -646,8 +646,7 @@ int btrfs_check_leaf_full(struct extent_buffer *leaf)
 	return check_leaf(leaf, true, true);
 }
 
-int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
-			     struct extent_buffer *leaf)
+int btrfs_check_leaf_relaxed(struct extent_buffer *leaf)
 {
 	return check_leaf(leaf, false, true);
 }
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index d190ada1a58d..8923ddcc9956 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -20,8 +20,7 @@ int btrfs_check_leaf_full(struct extent_buffer *leaf);
  * Less strict leaf checker.
  * Will only check item pointers, not reading item data.
  */
-int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
-			     struct extent_buffer *leaf);
+int btrfs_check_leaf_relaxed(struct extent_buffer *leaf);
 int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
 			   struct extent_buffer *leaf);
 int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
-- 
2.21.0

