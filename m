Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB717C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 913BC2086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 913BC2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbeK1OER (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:17 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19247 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727207AbeK1OEQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:16 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766246"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:14 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7D5FC4B7349C
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:11 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:16 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 07/17] btrfs: priority alloc: add functions to remove block group from priority tree
Date:   Wed, 28 Nov 2018 11:11:38 +0800
Message-ID: <20181128031148.357-8-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 7D5FC4B7349C.AA45B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce btrfs_remove_block_group_priority() to remove block group
from priority tree.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5bae757786dc..b559c9a9afc6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11429,3 +11429,40 @@ static void add_block_group_priority(struct btrfs_block_group_cache *cache)
 	up_write(&pt->groups_sem);
 	BUG_ON(ret);
 }
+
+static void unlink_block_group_priority(struct btrfs_priority_tree *pt,
+					struct btrfs_block_group_cache *cache)
+{
+	rb_erase(&cache->node, &pt->block_groups);
+	RB_CLEAR_NODE(&cache->node);
+}
+
+void btrfs_remove_block_group_priority(struct btrfs_block_group_cache *cache)
+{
+	struct btrfs_priority_tree *pt;
+
+	if (!is_priority_alloc_enabled(cache->fs_info))
+		return;
+
+	spin_lock(&cache->lock);
+	if (cache->priority_tree == NULL) {
+		spin_unlock(&cache->lock);
+		return;
+	}
+
+	pt = cache->priority_tree;
+	cache->priority = PRIORITY_BG_DELETED;
+	spin_unlock(&cache->lock);
+
+	down_write(&pt->groups_sem);
+	spin_lock(&cache->lock);
+
+	if (cache->priority_tree == NULL)
+		goto out;
+
+	unlink_block_group_priority(pt, cache);
+	cache->priority_tree = NULL;
+out:
+	spin_unlock(&cache->lock);
+	up_write(&pt->groups_sem);
+}
-- 
2.19.1



