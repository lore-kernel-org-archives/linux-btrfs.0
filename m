Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EF2C10F03
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 848A220700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbfCYSpO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:38914 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD5D5AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 37BAFDA98F; Mon, 25 Mar 2019 19:46:25 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 05/30] btrfs: get fs_info from eb in btrfs_exclude_logged_extents
Date:   Mon, 25 Mar 2019 19:46:25 +0100
Message-Id: <83d5149292cf0ca046531926754f1f02fadeb119.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/tree-log.c    | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 78b20567253e..9465e5360c3f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2708,8 +2708,7 @@ int btrfs_pin_extent(struct btrfs_fs_info *fs_info,
 		     u64 bytenr, u64 num, int reserved);
 int btrfs_pin_extent_for_log_replay(struct btrfs_fs_info *fs_info,
 				    u64 bytenr, u64 num_bytes);
-int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
-				 struct extent_buffer *eb);
+int btrfs_exclude_logged_extents(struct extent_buffer *eb);
 int btrfs_cross_ref_exist(struct btrfs_root *root,
 			  u64 objectid, u64 offset, u64 bytenr);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b0c86a817a99..44fd4553004b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6601,9 +6601,9 @@ static int __exclude_logged_extent(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
-				 struct extent_buffer *eb)
+int btrfs_exclude_logged_extents(struct extent_buffer *eb)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_file_extent_item *item;
 	struct btrfs_key key;
 	int found_type;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a59e98c9fbb9..4cb61cb72c4e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -315,7 +315,7 @@ static int process_one_buffer(struct btrfs_root *log,
 
 	if (!ret && btrfs_buffer_uptodate(eb, gen, 0)) {
 		if (wc->pin && btrfs_header_level(eb) == 0)
-			ret = btrfs_exclude_logged_extents(fs_info, eb);
+			ret = btrfs_exclude_logged_extents(eb);
 		if (wc->write)
 			btrfs_write_tree_block(eb);
 		if (wc->wait)
-- 
2.21.0

