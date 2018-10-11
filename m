Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC43C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5869D2086E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5869D2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbeJKNG2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 09:06:28 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:5199 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727772AbeJKNG2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 09:06:28 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45913756"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 13:40:47 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7A8B84B6ED95
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:40:47 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 11 Oct
 2018 13:40:52 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/6] btrfs: remove fs_info from btrfs_check_space_for_delayed_refs
Date:   Thu, 11 Oct 2018 13:40:35 +0800
Message-ID: <20181011054038.5428-4-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 7A8B84B6ED95.A9EC4
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It can be referenced from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 6 +++---
 fs/btrfs/inode.c       | 2 +-
 fs/btrfs/transaction.c | 2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 15c659f23411..4002c9fd924b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2600,8 +2600,7 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
 
 int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
 				       struct btrfs_fs_info *fs_info);
-int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
-				       struct btrfs_fs_info *fs_info);
+int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans);
 void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
 					 const u64 start);
 void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 77156bd2a9a7..831dc2ac1942 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2789,9 +2789,9 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes)
 	return num_csums;
 }
 
-int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
-				       struct btrfs_fs_info *fs_info)
+int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_block_rsv *global_rsv;
 	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
 	u64 csum_bytes = trans->transaction->delayed_refs.pending_csums;
@@ -2842,7 +2842,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
 	if (val >= NSEC_PER_SEC / 2)
 		return 2;
 
-	return btrfs_check_space_for_delayed_refs(trans, fs_info);
+	return btrfs_check_space_for_delayed_refs(trans);
 }
 
 struct async_delayed_refs {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6c476dc81b8e..6a5557e8909d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5319,7 +5319,7 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 		 * Try to steal from the global reserve if there is space for
 		 * it.
 		 */
-		if (!btrfs_check_space_for_delayed_refs(trans, fs_info) &&
+		if (!btrfs_check_space_for_delayed_refs(trans) &&
 		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, false))
 			return trans;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e7f618b17b07..c5015458c5c8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -760,7 +760,7 @@ static int should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 
-	if (btrfs_check_space_for_delayed_refs(trans, fs_info))
+	if (btrfs_check_space_for_delayed_refs(trans))
 		return 1;
 
 	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
-- 
2.19.1



