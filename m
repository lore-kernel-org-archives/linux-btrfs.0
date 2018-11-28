Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C2AC04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5A002086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5A002086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbeK1OEU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:20 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16765 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727247AbeK1OET (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:19 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766251"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:14 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 522584B734CC
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:14 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:19 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 12/17] btrfs: priority alloc: introduce find_free_extent_search()
Date:   Wed, 28 Nov 2018 11:11:43 +0800
Message-ID: <20181128031148.357-13-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 522584B734CC.A846A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In origin, find_free_extent() just searches block groups in space_info
one by one.

In priority aware allocator, we first search block groups in
higher priority tree than in lower priority tree.

This helper unify above two ways for further use.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 77 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 74955f79fcce..5484256169dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7331,6 +7331,83 @@ struct find_free_extent_ctl {
 };
 
 
+/*
+ * Helper function for find_free_extent().
+ *
+ * Return next block_group_cache to use.
+ * Return NULL mean no more block group to use.
+ *
+ * If use_priority is false: return the next of @block_group in
+ * space_info->block_groups[index] or if @blockgroup is NULL, return first
+ * block group in the list.
+ *
+ * If use_priority is true: if *pt_ret is NULL, return first block group in
+ * highest priority level. If *pt_ret is NOT NULL, return the next of
+ * @block_group or if @block_group is NULL, return first available block group
+ * which located in priority level <= *pt_ret->level.
+ * The tree will be down_read if return value is not NULL.
+ *
+ */
+static struct btrfs_block_group_cache *
+find_free_extent_search(struct btrfs_space_info *space_info, int index,
+		struct btrfs_block_group_cache *block_group, bool use_priority,
+		struct btrfs_priority_tree **pt_ret)
+{
+
+	struct list_head *lentry, *head;
+	struct rb_root *root;
+	struct rb_node *node, *bg_node;
+	struct btrfs_priority_tree *pt;
+	bool read;
+
+	if (!use_priority) {
+		head = &space_info->block_groups[index];
+		if (!block_group)
+			lentry = head->next;
+		else
+			lentry = block_group->list.next;
+		if (lentry == head)
+			return NULL;
+		return list_entry(lentry, struct btrfs_block_group_cache,
+				  list);
+	}
+
+	root = &space_info->priority_trees[index];
+	pt = pt_ret ? *pt_ret : NULL;
+
+	if (!pt) {
+		node = rb_first(root);
+		read = true;
+	} else {
+		node = &pt->node;
+		read = false;
+
+		if (block_group)
+			bg_node = rb_next(&block_group->node);
+		else
+			bg_node = rb_first(&pt->block_groups);
+	}
+
+	for (; node; node = rb_next(node)) {
+		pt = rb_entry(node, struct btrfs_priority_tree, node);
+		if (read) {
+			down_read(&pt->groups_sem);
+			bg_node = rb_first(&pt->block_groups);
+		}
+		for (; bg_node; bg_node = rb_next(bg_node)) {
+			if (bg_node) {
+				*pt_ret = pt;
+				return rb_entry(bg_node,
+					struct btrfs_block_group_cache, node);
+			}
+		}
+
+		up_read(&pt->groups_sem);
+		read = true;
+	}
+
+	return NULL;
+}
 /*
  * Helper function for find_free_extent().
  *
-- 
2.19.1



