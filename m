Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73D6C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB9D22086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB9D22086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbeK1OEN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:13 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19247 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727008AbeK1OEN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:13 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766235"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:10 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5B40A4B7349D
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:10 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:15 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 05/17] btrfs: priority alloc: introduce functions to add block group to priority tree
Date:   Wed, 28 Nov 2018 11:11:36 +0800
Message-ID: <20181128031148.357-6-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 5B40A4B7349D.A9411
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce compute_priority_level() to compute priority level according
priority, now just divides PRIORITY_USAGE_FACOTR.

Introduce add_block_group_priority() to add block groups to
priority tree.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 787a68b5bdcb..d63078930a1e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11344,3 +11344,79 @@ static int create_priority_trees(struct btrfs_fs_info *fs_info,
 		remove_priority_trees(fs_info, space_info);
 	return ret;
 }
+
+static int link_block_group_priority(struct btrfs_priority_tree *tree,
+				     struct btrfs_block_group_cache *cache)
+{
+	struct rb_node **p = &tree->block_groups.rb_node;
+	struct rb_node *parent = NULL;
+	struct btrfs_block_group_cache *tmp;
+
+	while (*p) {
+		parent = *p;
+		tmp = rb_entry(parent, struct btrfs_block_group_cache, node);
+		if (cache->key.objectid < tmp->key.objectid)
+			p = &(*p)->rb_left;
+		else if (cache->key.objectid > tmp->key.objectid)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	rb_link_node(&cache->node, parent, p);
+	rb_insert_color(&cache->node, &tree->block_groups);
+	return 0;
+}
+
+static struct btrfs_priority_tree *
+search_priority_tree(struct rb_root *root, int level)
+{
+	struct rb_node *node = root->rb_node;
+	struct btrfs_priority_tree *pt;
+
+	while (node) {
+		pt = rb_entry(node, struct btrfs_priority_tree, node);
+
+		if (level > pt->level)
+			node = node->rb_left;
+		else if (level < pt->level)
+			node = node->rb_right;
+		else
+			return pt;
+	}
+
+	return NULL;
+}
+
+static void add_block_group_priority(struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_priority_tree *pt;
+	int index = btrfs_bg_flags_to_raid_index(cache->flags);
+	int level, max_level, min_level;
+	int ret;
+
+	if (!is_priority_alloc_enabled(cache->fs_info))
+		return;
+
+	if (btrfs_test_opt(cache->fs_info, PRIORITY_USAGE)) {
+		max_level = compute_priority_level(cache->fs_info,
+					   (u8)100 << PRIORITY_USAGE_SHIFT);
+		min_level = 0;
+	}
+
+	level = compute_priority_level(cache->fs_info, cache->priority);
+	if (level > max_level || level < min_level) {
+		WARN_ON(level);
+		return;
+	}
+
+	pt = search_priority_tree(&cache->space_info->priority_trees[index],
+				  level);
+	BUG_ON(pt == NULL);
+
+	down_write(&pt->groups_sem);
+	cache->priority_tree = pt;
+	ret = link_block_group_priority(pt, cache);
+	up_write(&pt->groups_sem);
+	BUG_ON(ret);
+}
-- 
2.19.1



