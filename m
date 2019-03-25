Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3A8C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A00A820700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbfCYSp7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:39164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729926AbfCYSp7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4A8EFAFBD
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B497FDA98F; Mon, 25 Mar 2019 19:47:11 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 25/30] btrfs: get fs_info from eb in btrfs_check_node
Date:   Mon, 25 Mar 2019 19:47:11 +0100
Message-Id: <5baccf335bf8706b40b193f9c58e19d2d4c93ec7.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/disk-io.c      | 4 ++--
 fs/btrfs/tree-checker.c | 3 ++-
 fs/btrfs/tree-checker.h | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b6a813705023..78a4f6cf866e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -537,7 +537,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 		return -EINVAL;
 
 	if (btrfs_header_level(eb))
-		err = btrfs_check_node(fs_info, eb);
+		err = btrfs_check_node(eb);
 	else
 		err = btrfs_check_leaf_write(fs_info, eb);
 
@@ -670,7 +670,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		ret = -EIO;
 	}
 
-	if (found_level > 0 && btrfs_check_node(fs_info, eb))
+	if (found_level > 0 && btrfs_check_node(eb))
 		ret = -EIO;
 
 	if (!ret)
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0c908a49a525..b4f7d47f8d75 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -662,8 +662,9 @@ int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
 	return check_leaf(leaf, false, false);
 }
 
-int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
+int btrfs_check_node(struct extent_buffer *node)
 {
+	struct btrfs_fs_info *fs_info = node->fs_info;
 	unsigned long nr = btrfs_header_nritems(node);
 	struct btrfs_key key, next_key;
 	int slot;
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index 8923ddcc9956..fd09f2247b7c 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -23,6 +23,6 @@ int btrfs_check_leaf_full(struct extent_buffer *leaf);
 int btrfs_check_leaf_relaxed(struct extent_buffer *leaf);
 int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
 			   struct extent_buffer *leaf);
-int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node);
+int btrfs_check_node(struct extent_buffer *node);
 
 #endif
-- 
2.21.0

