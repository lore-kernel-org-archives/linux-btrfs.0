Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B957DC6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EE8020835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="XVMH9OQZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EE8020835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbeJLDYf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:35 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35915 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbeJLDYf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:35 -0400
Received: by mail-qk1-f193.google.com with SMTP id a85-v6so6280367qkg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=0pFXVY2NKlGxnx5addw7+EqJLIsrQdT/gx6gstwLZiU=;
        b=XVMH9OQZ8Gaj7bTG235SKlI0BYOZZY6TX53Kw2KO/78QusTAC453h7XnKCrr7ciPpd
         ts4iT3M4I92RzeOyDha5GhjL/kCgETuz6DJf/6M8JaFzrN9g6a1yVbBZcD7VWWNTpvJt
         NVXZuguktRuTHWmwi7GkqZKXoL/D51tWPHqYW8bQVlO/CsgwYZROp27Ify8v/po59KXH
         /M+G8cc7AkQSW0Ta4BK4FtXFB/sgumu8pTl4NzAI0xqHzbG29EZwcGUbUw1zgXp+b/HG
         Tajw3DZt7/mGD2FR8f1+99+q6BiHlu8p0xGTukyS4K6WqyCv/Brgjccb0s4SezueoOGW
         zAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=0pFXVY2NKlGxnx5addw7+EqJLIsrQdT/gx6gstwLZiU=;
        b=ixUg7Yvzfo3ZDv2i7b4E8jri4ilXSRcmT+EnB5PjXRlT+tt7zLPG7zzdVJM9UW8nxu
         IDfuGv1dR668FsoqTg/Bz+ye8NBEsK0vVzHF3KmyzfDYuYcE7xdjBE8Hews2ZOaMwHva
         HI+XrUCEblgErdifQQSR0Q2eD3YWtO75M7IgV+qJjT+eKhzdm/UtK4v6QU5/6KjN05Y7
         MYEQxJqJAmx8db9f6xhELtR1LiUW4rQwYC2Q/1p6dxFkayp6MAHfzUpfVrw+DlT/ycB8
         ms+/Fm+YGg9xFB+jJI90yVsL4TFejgRRufr6tU3ooRfFKCMOtt7z08K2Vfj6Rpl+Z2pk
         a/0g==
X-Gm-Message-State: ABuFfogj/6ZEtLbjcHlBJsAhKlGggNeKEFdBYDKD0uaDyZXeweHGMSRv
        bG6tuFSm8UliNQK6MQPdsGWJL2Mi5x8=
X-Google-Smtp-Source: ACcGV622s9d3Dzpz2MbYdPg4DdLIbquMLvYzGOF04bLzDv7dIehfxiFCqUdDAyie5OSLgFt44U6V7w==
X-Received: by 2002:a37:a795:: with SMTP id q143-v6mr3091371qke.92.1539287748649;
        Thu, 11 Oct 2018 12:55:48 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y186-v6sm10810553qkd.68.2018.10.11.12.55.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:47 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 40/42] btrfs: drop min_size from evict_refill_and_join
Date:   Thu, 11 Oct 2018 15:54:29 -0400
Message-Id: <20181011195431.3441-41-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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

