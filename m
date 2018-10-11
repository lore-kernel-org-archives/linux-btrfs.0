Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A15C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6DEA2085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6DEA2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbeJKNGb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 09:06:31 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:5199 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727772AbeJKNGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 09:06:31 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45913760"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 13:40:47 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 182874B6ED9D
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:40:48 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 11 Oct
 2018 13:40:52 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/6] btrfs: remove fs_info from btrfs_should_throttle_delayed_refs
Date:   Thu, 11 Oct 2018 13:40:36 +0800
Message-ID: <20181011054038.5428-5-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
References: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 182874B6ED9D.ADA86
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The avg_delayed_ref_runtime can be referenced from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 5 ++---
 fs/btrfs/inode.c       | 5 ++---
 fs/btrfs/transaction.c | 2 +-
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 4002c9fd924b..68ca41dbbef3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2598,8 +2598,7 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
 	return (u64)fs_info->nodesize * BTRFS_MAX_LEVEL * num_items;
 }
 
-int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
-				       struct btrfs_fs_info *fs_info);
+int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans);
 int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans);
 void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
 					 const u64 start);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 831dc2ac1942..241de034ba09 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2826,8 +2826,7 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans)
 	return ret;
 }
 
-int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
-				       struct btrfs_fs_info *fs_info)
+int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans)
 {
 	u64 num_entries =
 		atomic_read(&trans->transaction->delayed_refs.num_entries);
@@ -2835,7 +2834,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
 	u64 val;
 
 	smp_mb();
-	avg_runtime = fs_info->avg_delayed_ref_runtime;
+	avg_runtime = trans->fs_info->avg_delayed_ref_runtime;
 	val = num_entries * avg_runtime;
 	if (val >= NSEC_PER_SEC)
 		return 1;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6a5557e8909d..f22f77172c5f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4713,7 +4713,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				btrfs_abort_transaction(trans, ret);
 				break;
 			}
-			if (btrfs_should_throttle_delayed_refs(trans, fs_info))
+			if (btrfs_should_throttle_delayed_refs(trans))
 				btrfs_async_run_delayed_refs(fs_info,
 					trans->delayed_ref_updates * 2,
 					trans->transid, 0);
@@ -4722,8 +4722,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 							 extent_num_bytes)) {
 					should_end = true;
 				}
-				if (btrfs_should_throttle_delayed_refs(trans,
-								       fs_info))
+				if (btrfs_should_throttle_delayed_refs(trans))
 					should_throttle = true;
 			}
 		}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c5015458c5c8..5686290a50e1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -835,7 +835,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	trans->delayed_ref_updates = 0;
 	if (!trans->sync) {
 		must_run_delayed_refs =
-			btrfs_should_throttle_delayed_refs(trans, info);
+			btrfs_should_throttle_delayed_refs(trans);
 		cur = max_t(unsigned long, cur, 32);
 
 		/*
-- 
2.19.1



