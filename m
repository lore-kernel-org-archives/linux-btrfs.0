Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C08C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6C9C2086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6C9C2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbeK1OES (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:18 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16765 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727233AbeK1OES (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:18 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766249"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:14 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D043E4B734A1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:13 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:19 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 11/17] btrfs: priority alloc: remove block group from priority tree while removing block group
Date:   Wed, 28 Nov 2018 11:11:42 +0800
Message-ID: <20181128031148.357-12-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: D043E4B734A1.A83E8
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Export btrfs_remove_block_group_priority() to header ctree.h.
Call btrfs_remove_block_group_priority() while deleting
transaction->deleted_bgs, btrfs_free_block_groups() and
btrfs_remove_block_group().

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 1 +
 fs/btrfs/extent-tree.c | 3 +++
 fs/btrfs/transaction.c | 1 +
 3 files changed, 5 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4c56baf9f7cf..091b878e326c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2752,6 +2752,7 @@ u64 btrfs_data_alloc_profile(struct btrfs_fs_info *fs_info);
 u64 btrfs_metadata_alloc_profile(struct btrfs_fs_info *fs_info);
 u64 btrfs_system_alloc_profile(struct btrfs_fs_info *fs_info);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
+void btrfs_remove_block_group_priority(struct btrfs_block_group_cache *cache);
 
 enum btrfs_reserve_flush_enum {
 	/* If we are in the transaction, we can't flush anything.*/
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fc40901b4772..74955f79fcce 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9896,6 +9896,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		list_del(&block_group->list);
 		up_write(&block_group->space_info->groups_sem);
 
+		btrfs_remove_block_group_priority(block_group);
 		/*
 		 * We haven't cached this block group, which means we could
 		 * possibly have excluded extents on this block group.
@@ -10571,6 +10572,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		clear_avail_alloc_bits(fs_info, block_group->flags);
 	}
 	up_write(&block_group->space_info->groups_sem);
+	btrfs_remove_block_group_priority(block_group);
+
 	if (kobj) {
 		kobject_del(kobj);
 		kobject_put(kobj);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f92c0a88c4ad..74234de9304a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -72,6 +72,7 @@ void btrfs_put_transaction(struct btrfs_transaction *transaction)
 						 struct btrfs_block_group_cache,
 						 bg_list);
 			list_del_init(&cache->bg_list);
+			btrfs_remove_block_group_priority(cache);
 			btrfs_put_block_group_trimming(cache);
 			btrfs_put_block_group(cache);
 		}
-- 
2.19.1



