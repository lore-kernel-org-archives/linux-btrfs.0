Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6404FC04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385992086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 385992086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbeK1OEZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:25 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54216 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727229AbeK1OET (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:19 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766256"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:16 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 0E1824B734A7
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:16 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:21 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 15/17] btrfs: priority alloc: write bg->priority_groups_sem while waiting reservation
Date:   Wed, 28 Nov 2018 11:11:46 +0800
Message-ID: <20181128031148.357-16-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 0E1824B734A7.ACF3D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since if use priority alloc, we should down/up_write()
bg->priority_groups_sem.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f530a4344368..6627bbe56ad5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6425,6 +6425,8 @@ void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
 	btrfs_put_block_group(bg);
 }
 
+static inline bool
+is_priority_alloc_enabled(struct btrfs_fs_info *fs_info);
 void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg)
 {
 	struct btrfs_space_info *space_info = bg->space_info;
@@ -6433,7 +6435,11 @@ void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg)
 
 	if (!(bg->flags & BTRFS_BLOCK_GROUP_DATA))
 		return;
-
+	if (is_priority_alloc_enabled(bg->fs_info)) {
+		down_write(&bg->priority_tree->groups_sem);
+		up_write(&bg->priority_tree->groups_sem);
+		goto wait;
+	}
 	/*
 	 * Our block group is read only but before we set it to read only,
 	 * some task might have had allocated an extent from it already, but it
@@ -6446,7 +6452,7 @@ void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg)
 	 */
 	down_write(&space_info->groups_sem);
 	up_write(&space_info->groups_sem);
-
+wait:
 	wait_var_event(&bg->reservations, !atomic_read(&bg->reservations));
 }
 
-- 
2.19.1



