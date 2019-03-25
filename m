Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A89C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE88920700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbfCYSqN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:46:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:39268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729478AbfCYSqM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:46:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4998CAF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:46:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8CF72DA98F; Mon, 25 Mar 2019 19:47:23 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 30/30] btrfs: get fs_info from eb in btrfs_check_leaf_write
Date:   Mon, 25 Mar 2019 19:47:23 +0100
Message-Id: <3076478bb8e11ae9fe17fb848fded598fe8e137b.1553539114.git.dsterba@suse.com>
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
index 78a4f6cf866e..5373f4ad4114 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -539,7 +539,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	if (btrfs_header_level(eb))
 		err = btrfs_check_node(eb);
 	else
-		err = btrfs_check_leaf_write(fs_info, eb);
+		err = btrfs_check_leaf_write(eb);
 
 	if (err < 0) {
 		btrfs_err(fs_info,
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index b4f7d47f8d75..aea626a3af53 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -656,8 +656,7 @@ int btrfs_check_leaf_relaxed(struct extent_buffer *leaf)
  * Don't check if the empty leaf belongs to a tree root. Mostly for balance
  * and new tree created in current transaction.
  */
-int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *leaf)
+int btrfs_check_leaf_write(struct extent_buffer *leaf)
 {
 	return check_leaf(leaf, false, false);
 }
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index fd09f2247b7c..6a3e96e26b6f 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -21,8 +21,7 @@ int btrfs_check_leaf_full(struct extent_buffer *leaf);
  * Will only check item pointers, not reading item data.
  */
 int btrfs_check_leaf_relaxed(struct extent_buffer *leaf);
-int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *leaf);
+int btrfs_check_leaf_write(struct extent_buffer *leaf);
 int btrfs_check_node(struct extent_buffer *node);
 
 #endif
-- 
2.21.0

