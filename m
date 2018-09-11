Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f178.google.com ([209.85.222.178]:41389 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:19 -0400
Received: by mail-qk1-f178.google.com with SMTP id h138-v6so17324221qke.8
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:53 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 23/36] btrfs: make sure we create all new bgs
Date: Tue, 11 Sep 2018 13:57:54 -0400
Message-Id: <20180911175807.26181-24-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allocating new chunks modifies both the extent and chunk tree, which can
trigger new chunk allocations.  So instead of doing list_for_each_safe,
just do while (!list_empty()) so we make sure we don't exit with other
pending bg's still on our list.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ac7b740be4ff..5e928275826f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10356,7 +10356,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_block_group_cache *block_group, *tmp;
+	struct btrfs_block_group_cache *block_group;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_item item;
 	struct btrfs_key key;
@@ -10364,7 +10364,10 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
 
 	trans->can_flush_pending_bgs = false;
-	list_for_each_entry_safe(block_group, tmp, &trans->new_bgs, bg_list) {
+	while (!list_empty(&trans->new_bgs)) {
+		block_group = list_first_entry(&trans->new_bgs,
+					       struct btrfs_block_group_cache,
+					       bg_list);
 		if (ret)
 			goto next;
 
-- 
2.14.3
