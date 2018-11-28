Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27065C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA3372086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA3372086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbeK1OEX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:23 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19247 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727209AbeK1OEU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:20 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766254"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:16 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 972034B6AE19
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:16 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:21 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 16/17] btrfs: priority alloc: write bg->priority_tree->groups_sem to avoid race in btrfs_delete_unused_bgs()
Date:   Wed, 28 Nov 2018 11:11:47 +0800
Message-ID: <20181128031148.357-17-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 972034B6AE19.A8A2A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If use priority aware allocator, bg->priority_tree->groups_sem should
be written instead of space_info->groups_sem.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 60 +++++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6627bbe56ad5..5c9536609621 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10944,6 +10944,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
+	bool use_priority = is_priority_alloc_enabled(fs_info);
 	int ret = 0;
 
 	if (!test_bit(BTRFS_FS_OPEN, &fs_info->flags))
@@ -10953,6 +10954,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 	while (!list_empty(&fs_info->unused_bgs)) {
 		u64 start, end;
 		int trimming;
+		struct btrfs_priority_tree *pt;
 
 		block_group = list_first_entry(&fs_info->unused_bgs,
 					       struct btrfs_block_group_cache,
@@ -10969,29 +10971,55 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 
 		mutex_lock(&fs_info->delete_unused_bgs_mutex);
 
-		/* Don't want to race with allocators so take the groups_sem */
-		down_write(&space_info->groups_sem);
-		spin_lock(&block_group->lock);
-		if (block_group->reserved || block_group->pinned ||
-		    btrfs_block_group_used(&block_group->item) ||
-		    block_group->ro ||
-		    list_is_singular(&block_group->list)) {
+		if (use_priority) {
+			spin_lock(&block_group->lock);
+			if (block_group->reserved || block_group->pinned ||
+			    btrfs_block_group_used(&block_group->item) ||
+			    block_group->ro ||
+			    block_group->priority != 0) {
+				trace_btrfs_skip_unused_block_group(
+					block_group);
+				spin_unlock(&block_group->lock);
+				goto next;
+			}
+			block_group->priority = PRIORITY_BG_BUSY;
+			spin_unlock(&block_group->lock);
+			pt = block_group->priority_tree;
+			down_write(&pt->groups_sem);
+		} else {
 			/*
-			 * We want to bail if we made new allocations or have
-			 * outstanding allocations in this block group.  We do
-			 * the ro check in case balance is currently acting on
-			 * this block group.
+			 * Don't want to race with allocators so take the
+			 * groups_sem
 			 */
-			trace_btrfs_skip_unused_block_group(block_group);
+			down_write(&space_info->groups_sem);
+			spin_lock(&block_group->lock);
+			if (block_group->reserved || block_group->pinned ||
+			    btrfs_block_group_used(&block_group->item) ||
+			    block_group->ro ||
+			    list_is_singular(&block_group->list)) {
+				/*
+				 * We want to bail if we made new allocations
+				 * or have outstanding allocations in this
+				 * block group.  We do the ro check in case
+				 * balance is currently acting on this block
+				 * group.
+				 */
+				trace_btrfs_skip_unused_block_group(
+					block_group);
+				spin_unlock(&block_group->lock);
+				up_write(&space_info->groups_sem);
+				goto next;
+			}
 			spin_unlock(&block_group->lock);
-			up_write(&space_info->groups_sem);
-			goto next;
 		}
-		spin_unlock(&block_group->lock);
 
 		/* We don't want to force the issue, only flip if it's ok. */
 		ret = inc_block_group_ro(block_group, 0);
-		up_write(&space_info->groups_sem);
+		if (use_priority)
+			up_write(&pt->groups_sem);
+		else
+			up_write(&space_info->groups_sem);
+
 		if (ret < 0) {
 			ret = 0;
 			goto next;
-- 
2.19.1



