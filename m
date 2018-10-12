Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B485C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5553B2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="xWDwe50u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5553B2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbeJMDIe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:34 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39917 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeJMDIe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:34 -0400
Received: by mail-qt1-f194.google.com with SMTP id e22-v6so15075127qto.6
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=0pFXVY2NKlGxnx5addw7+EqJLIsrQdT/gx6gstwLZiU=;
        b=xWDwe50uOk2SNqQssrArVUqWrahx7FZjCeFOktq26Fb1Yh7UH6mPGAU3e5U+4igK0z
         wucjgxJ3z6ELN7MoiYvz1B3/qnA5D9xgOlfkIyMGxDy+qk87FJRRQZdJO+5Wequikslr
         n5hFVuKCMapWMELEXWLaQkjlb2ZT/imWVXDRLKkPWpzWoOEbs9G8t4o187STPpBNeKQ5
         m/td5aCuIvvInbFtO37TzLroMbtvNYBeLdHqRDtluJcRG7tKNjHiDzCf0zgrmrKEH3PK
         rDcpvy03Sm+8poMUrY83TR6vO/l7XuAGK4bnXNp0dU/UaGWOhyrdJT5SqIIYq+eBpgzk
         NWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=0pFXVY2NKlGxnx5addw7+EqJLIsrQdT/gx6gstwLZiU=;
        b=F6CeatpT4h4CTpxvdoNELu2nuKejBLriV9xZU5aV+8f2jNQ2nVeQDX8SvvHb9sHCVk
         NdJ2UFSD+azcjATQ5t4QOE7RhKoTAD8Z/e1BxL1qlIV9RkfULKMBQO3rtRIp2FzlllDz
         Cxu2sk0Awv2xgajmDlLvn4RYW+u988YcUwf7TrWmjoqkZoGo9XpzmLlYxLdv2Thrip+K
         Mb9TdZi8/GitoI1OfmBKSO28FNeXFbP9P49rMpiZEHP4/VUlnVSM/eT9Caurlj/XgVNb
         lojs1DyDQS/yeNZ2fdiMwEKx+G6LT0bTWF1pgC/s6oDCMZhKM3KfR+6Lc2kZb5G/WAUa
         tYcQ==
X-Gm-Message-State: ABuFfointYKbdlHTboEVD9p5YHtEPhIBLeBYAjSqtsynZvJ79QSVMrSO
        qUgY3anXCtfDEa16SIeYy6O1zw1I8HM=
X-Google-Smtp-Source: ACcGV60R1NRDAYomDYzO5BHthY7CzZKyFMxduwV+rPIjd3f1dXxX0hMRniXGEShqkQmedA+wa+21Rg==
X-Received: by 2002:a0c:af49:: with SMTP id j9mr7381392qvc.72.1539372872647;
        Fri, 12 Oct 2018 12:34:32 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c8-v6sm1023590qkb.81.2018.10.12.12.34.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:31 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 40/42] btrfs: drop min_size from evict_refill_and_join
Date:   Fri, 12 Oct 2018 15:32:54 -0400
Message-Id: <20181012193256.13735-41-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We don't need it, rsv->size is set once and never changes throughout
its lifetime, so just use that for the reserve size.

Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ab8242b10601..dbcca915e681 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5339,8 +5339,7 @@ static void evict_inode_truncate_pages(struct inode *inode)
 }
 
 static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
-							struct btrfs_block_rsv *rsv,
-							u64 min_size)
+							struct btrfs_block_rsv *rsv)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
@@ -5350,7 +5349,7 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 		struct btrfs_trans_handle *trans;
 		int ret;
 
-		ret = btrfs_block_rsv_refill(root, rsv, min_size,
+		ret = btrfs_block_rsv_refill(root, rsv, rsv->size,
 					     BTRFS_RESERVE_FLUSH_LIMIT);
 
 		if (ret && ++failures > 2) {
@@ -5368,7 +5367,7 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 		 * it.
 		 */
 		if (!btrfs_check_space_for_delayed_refs(fs_info) &&
-		    !btrfs_block_rsv_migrate(global_rsv, rsv, min_size, 0))
+		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, 0))
 			return trans;
 
 		/* If not, commit and try again. */
@@ -5384,7 +5383,6 @@ void btrfs_evict_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv;
-	u64 min_size;
 	int ret;
 
 	trace_btrfs_inode_evict(inode);
@@ -5394,8 +5392,6 @@ void btrfs_evict_inode(struct inode *inode)
 		return;
 	}
 
-	min_size = btrfs_calc_trunc_metadata_size(fs_info, 1);
-
 	evict_inode_truncate_pages(inode);
 
 	if (inode->i_nlink &&
@@ -5428,13 +5424,13 @@ void btrfs_evict_inode(struct inode *inode)
 	rsv = btrfs_alloc_block_rsv(fs_info, BTRFS_BLOCK_RSV_TEMP);
 	if (!rsv)
 		goto no_delete;
-	rsv->size = min_size;
+	rsv->size = btrfs_calc_trunc_metadata_size(fs_info, 1);
 	rsv->failfast = 1;
 
 	btrfs_i_size_write(BTRFS_I(inode), 0);
 
 	while (1) {
-		trans = evict_refill_and_join(root, rsv, min_size);
+		trans = evict_refill_and_join(root, rsv);
 		if (IS_ERR(trans))
 			goto free_rsv;
 
@@ -5459,7 +5455,7 @@ void btrfs_evict_inode(struct inode *inode)
 	 * If it turns out that we are dropping too many of these, we might want
 	 * to add a mechanism for retrying these after a commit.
 	 */
-	trans = evict_refill_and_join(root, rsv, min_size);
+	trans = evict_refill_and_join(root, rsv);
 	if (!IS_ERR(trans)) {
 		trans->block_rsv = rsv;
 		btrfs_orphan_del(trans, BTRFS_I(inode));
-- 
2.14.3

