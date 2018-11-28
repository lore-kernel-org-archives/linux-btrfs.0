Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF4FC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C3D82086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C3D82086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbeK1OE2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:28 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54216 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727008AbeK1OES (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:18 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766245"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:14 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1B3914B6AE19
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:12 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:17 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 08/17] btrfs: priority alloc: add btrfs_update_block_group_priority()
Date:   Wed, 28 Nov 2018 11:11:39 +0800
Message-ID: <20181128031148.357-9-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 1B3914B6AE19.A9477
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce btrfs_update_block_group_priority() to update
block_groups::priority. It will move block group from old tree
to new tree if need.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b559c9a9afc6..5ea1f2e40701 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11466,3 +11466,79 @@ void btrfs_remove_block_group_priority(struct btrfs_block_group_cache *cache)
 	spin_unlock(&cache->lock);
 	up_write(&pt->groups_sem);
 }
+
+static inline struct btrfs_priority_tree *
+find_priority_tree(struct btrfs_space_info *sinfo, u64 flags, int level)
+{
+	int index = btrfs_bg_flags_to_raid_index(flags);
+
+	return search_priority_tree(&sinfo->priority_trees[index], level);
+}
+
+void btrfs_update_block_group_priority(struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_priority_tree *old_tree, *new_tree;
+	struct rw_semaphore *front_sem, *back_sem;
+	long priority;
+	int old_level, new_level;
+
+	if (!is_priority_alloc_enabled(cache->fs_info))
+		return;
+
+	spin_lock(&cache->lock);
+	if (cache->priority != PRIORITY_BG_UPDATING) {
+		spin_unlock(&cache->lock);
+		return;
+	}
+
+	old_level = cache->priority_tree->level;
+	priority = compute_block_group_priority(cache);
+	new_level = compute_priority_level(cache->fs_info, priority);
+
+	/* no need to move the block group */
+	if (old_level == new_level) {
+		cache->priority = priority;
+		spin_unlock(&cache->lock);
+		return;
+	}
+	spin_unlock(&cache->lock);
+
+	old_tree = cache->priority_tree;
+	new_tree = find_priority_tree(cache->space_info, cache->flags,
+				      new_level);
+
+	if (!old_tree || !new_tree) {
+		btrfs_err(cache->fs_info,
+"can't found priority tree %d for block_group %llu old level %d new priority %ld",
+			  old_tree ? new_level : old_level,
+			  cache->key.objectid, old_level, priority);
+		BUG();
+	}
+
+	if (old_level > new_level) {
+		front_sem = &old_tree->groups_sem;
+		back_sem = &new_tree->groups_sem;
+	} else {
+		front_sem = &new_tree->groups_sem;
+		back_sem = &old_tree->groups_sem;
+	}
+
+	down_write(front_sem);
+	down_write(back_sem);
+	spin_lock(&cache->lock);
+
+	/* the block group was removed/is removing */
+	if (cache->priority != PRIORITY_BG_UPDATING ||
+	    priority != compute_block_group_priority(cache) ||
+	    old_tree != cache->priority_tree)
+		goto out;
+
+	unlink_block_group_priority(old_tree, cache);
+	cache->priority = priority;
+	link_block_group_priority(new_tree, cache);
+	cache->priority_tree = new_tree;
+out:
+	spin_unlock(&cache->lock);
+	up_write(front_sem);
+	up_write(back_sem);
+}
-- 
2.19.1



