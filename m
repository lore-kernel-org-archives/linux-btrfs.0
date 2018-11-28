Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34691C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 061E12086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 061E12086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbeK1OES (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:18 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19247 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727229AbeK1OES (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:18 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766248"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:14 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id ABCA54B7348C
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:12 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:18 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 09/17] btrfs: priority alloc: call create/remove_priority_trees in space_info
Date:   Wed, 28 Nov 2018 11:11:40 +0800
Message-ID: <20181128031148.357-10-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: ABCA54B7348C.AAA5E
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Call create_priority_trees() in create_space_info().
Call remove_priority_trees() before free of space_info.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5ea1f2e40701..2dec02782df1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3940,6 +3940,10 @@ static const char *alloc_name(u64 flags)
 	};
 }
 
+static int create_priority_trees(struct btrfs_fs_info *fs_info,
+				 struct btrfs_space_info *space_info);
+static void remove_priority_trees(struct btrfs_fs_info *fs_info,
+				  struct btrfs_space_info *space_info);
 static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 {
 
@@ -3958,8 +3962,17 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 		return ret;
 	}
 
-	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 		INIT_LIST_HEAD(&space_info->block_groups[i]);
+		space_info->priority_trees[i] = RB_ROOT;
+	}
+
+	ret = create_priority_trees(info, space_info);
+	if (ret) {
+		kfree(space_info);
+		return ret;
+	}
+
 	init_rwsem(&space_info->groups_sem);
 	spin_lock_init(&space_info->lock);
 	space_info->flags = flags & BTRFS_BLOCK_GROUP_TYPE_MASK;
@@ -3974,6 +3987,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 				    alloc_name(space_info->flags));
 	if (ret) {
 		percpu_counter_destroy(&space_info->total_bytes_pinned);
+		remove_priority_trees(info, space_info);
 		kfree(space_info);
 		return ret;
 	}
@@ -9928,6 +9942,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			    space_info->bytes_may_use > 0))
 			dump_space_info(info, space_info, 0, 0);
 		list_del(&space_info->list);
+		remove_priority_trees(info, space_info);
+
 		for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 			struct kobject *kobj;
 			kobj = space_info->block_group_kobjs[i];
@@ -11282,9 +11298,6 @@ static void remove_priority_trees(struct btrfs_fs_info *fs_info,
 	struct btrfs_priority_tree *pt, *next_pt;
 	int i;
 
-	if (!is_priority_alloc_enabled(fs_info))
-		return;
-
 	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 		root = &space_info->priority_trees[i];
 		rbtree_postorder_for_each_entry_safe(pt, next_pt, root, node) {
-- 
2.19.1



