Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E82C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E015020700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbfCYSpy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:39108 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730411AbfCYSpw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5ECE0AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C7BBADA98F; Mon, 25 Mar 2019 19:47:04 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 22/30] btrfs: tree-checker: get fs_info from eb in check_leaf
Date:   Mon, 25 Mar 2019 19:47:04 +0100
Message-Id: <7e571eee20d8d8dc026bc793badbec562e30fab6.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/tree-checker.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 0330e2d27afb..dd37d23ae8ba 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -474,9 +474,10 @@ static int check_leaf_item(struct extent_buffer *leaf,
 	return ret;
 }
 
-static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
-		      bool check_item_data, bool check_empty_leaf)
+static int check_leaf(struct extent_buffer *leaf, bool check_item_data,
+		      bool check_empty_leaf)
 {
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	/* No valid key type is 0, so all key should be larger than this key */
 	struct btrfs_key prev_key = {0, 0, 0};
 	struct btrfs_key key;
@@ -643,13 +644,13 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
 			  struct extent_buffer *leaf)
 {
-	return check_leaf(fs_info, leaf, true, true);
+	return check_leaf(leaf, true, true);
 }
 
 int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
 			     struct extent_buffer *leaf)
 {
-	return check_leaf(fs_info, leaf, false, true);
+	return check_leaf(leaf, false, true);
 }
 
 /*
@@ -660,7 +661,7 @@ int btrfs_check_leaf_relaxed(struct btrfs_fs_info *fs_info,
 int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
 			   struct extent_buffer *leaf)
 {
-	return check_leaf(fs_info, leaf, false, false);
+	return check_leaf(leaf, false, false);
 }
 
 int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
-- 
2.21.0

