Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4029C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B49132086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B49132086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbeK1OEK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:10 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25793 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726847AbeK1OEJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:09 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766230"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:07 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0E4B94B7349D
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:08 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:13 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 01/17] btrfs: priority alloc: prepare of priority aware allocator
Date:   Wed, 28 Nov 2018 11:11:32 +0800
Message-ID: <20181128031148.357-2-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 0E4B94B7349D.AE539
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

To implement priority aware allocator, this patch:
Introduces struct btrfs_priority_tree which contains block groups
in same level.
Adds member priority to struct btrfs_block_group_cache and pointer
points to the priority tree it's located.

Adds member priority_trees to struct btrfs_space_info to represents
priority trees in different raid types.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e62824cae00a..5c4651d8a524 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -437,6 +437,8 @@ struct btrfs_space_info {
 	struct rw_semaphore groups_sem;
 	/* for block groups in our same type */
 	struct list_head block_groups[BTRFS_NR_RAID_TYPES];
+	/* for priority trees in our same type */
+	struct rb_root priority_trees[BTRFS_NR_RAID_TYPES];
 	wait_queue_head_t wait;
 
 	struct kobject kobj;
@@ -558,6 +560,21 @@ struct btrfs_full_stripe_locks_tree {
 	struct mutex lock;
 };
 
+/*
+ * Tree to record all block_groups in same priority level.
+ * Only used in priority aware allocator.
+ */
+struct btrfs_priority_tree {
+	/* protected by groups_sem */
+	struct rb_root block_groups;
+	struct rw_semaphore groups_sem;
+
+	/* for different level priority trees in same index*/
+	struct rb_node node;
+
+	int level;
+};
+
 struct btrfs_block_group_cache {
 	struct btrfs_key key;
 	struct btrfs_block_group_item item;
@@ -571,6 +588,8 @@ struct btrfs_block_group_cache {
 	u64 flags;
 	u64 cache_generation;
 
+	/* It's used only when priority aware allocator is enabled. */
+	long priority;
 	/*
 	 * If the free space extent count exceeds this number, convert the block
 	 * group to bitmaps.
@@ -616,6 +635,9 @@ struct btrfs_block_group_cache {
 	/* for block groups in the same raid type */
 	struct list_head list;
 
+	/* for block groups in the same priority level */
+	struct rb_node node;
+
 	/* usage count */
 	atomic_t count;
 
@@ -670,6 +692,8 @@ struct btrfs_block_group_cache {
 
 	/* Record locked full stripes for RAID5/6 block group */
 	struct btrfs_full_stripe_locks_tree full_stripe_locks_root;
+
+	struct btrfs_priority_tree *priority_tree;
 };
 
 /* delayed seq elem */
-- 
2.19.1



