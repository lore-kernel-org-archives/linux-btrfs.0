Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72953C04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 422EB2086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 422EB2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbeK1OEP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:15 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19247 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727008AbeK1OEP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:15 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766236"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:10 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C01F54B6ED56
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:09 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:15 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 04/17] btrfs: priority alloc: add functions to create/remove priority trees
Date:   Wed, 28 Nov 2018 11:11:35 +0800
Message-ID: <20181128031148.357-5-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: C01F54B6ED56.ACAE7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce create_priority_trees() to create priority trees in
space_info.
Introduce remove_priority_trees() to remove priority trees in
space_info.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 94 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0f4c5b1e0bcc..787a68b5bdcb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11250,3 +11250,97 @@ static int compute_priority_level(struct btrfs_fs_info *fs_info,
 
 	return level;
 }
+
+static inline bool
+is_priority_alloc_enabled(struct btrfs_fs_info *fs_info)
+{
+	if (btrfs_test_opt(fs_info, PRIORITY_USAGE))
+		return true;
+	return false;
+}
+
+static void init_priority_tree(struct btrfs_priority_tree *pt, int level)
+{
+	pt->block_groups = RB_ROOT;
+	init_rwsem(&pt->groups_sem);
+	pt->level = level;
+}
+
+static void remove_priority_trees(struct btrfs_fs_info *fs_info,
+				  struct btrfs_space_info *space_info)
+{
+	struct rb_root *root;
+	struct btrfs_priority_tree *pt, *next_pt;
+	int i;
+
+	if (!is_priority_alloc_enabled(fs_info))
+		return;
+
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		root = &space_info->priority_trees[i];
+		rbtree_postorder_for_each_entry_safe(pt, next_pt, root, node) {
+			kfree(pt);
+		}
+		space_info->priority_trees[i] = RB_ROOT;
+	}
+}
+
+static int insert_priority_tree(struct rb_root *root,
+				struct btrfs_priority_tree *pt)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_priority_tree *tmp;
+
+	while (*p) {
+		parent = *p;
+		tmp = rb_entry(parent, struct btrfs_priority_tree, node);
+		if (pt->level > tmp->level)
+			p = &(*p)->rb_left;
+		else if (pt->level < tmp->level)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(&pt->node, parent, p);
+	rb_insert_color(&pt->node, root);
+	return 0;
+}
+
+static int create_priority_trees(struct btrfs_fs_info *fs_info,
+				 struct btrfs_space_info *space_info)
+{
+	struct rb_root *root;
+	struct btrfs_priority_tree *pt;
+	int ret = 0;
+	int i, level, max_level;
+	u64 priority;
+
+	if (!is_priority_alloc_enabled(fs_info))
+		return 0;
+
+	if (btrfs_test_opt(fs_info, PRIORITY_USAGE)) {
+		priority = (u8)100 << PRIORITY_USAGE_SHIFT;
+		max_level = compute_priority_level(fs_info, priority);
+	}
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
+		root = &space_info->priority_trees[i];
+
+		for (level = 0; level <= max_level; level++) {
+			pt = kzalloc(sizeof(*pt), GFP_NOFS);
+			if (!pt) {
+				ret = -ENOMEM;
+				break;
+			}
+			init_priority_tree(pt, level);
+			ret = insert_priority_tree(root, pt);
+			if (ret)
+				break;
+		}
+	}
+
+	if (ret)
+		remove_priority_trees(fs_info, space_info);
+	return ret;
+}
-- 
2.19.1



