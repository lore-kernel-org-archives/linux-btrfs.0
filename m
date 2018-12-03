Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC3BC04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D86B720834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:20:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="W07ErAjs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D86B720834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbeLCPU6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:20:58 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40058 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbeLCPU5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:20:57 -0500
Received: by mail-yw1-f66.google.com with SMTP id r130so5515195ywg.7
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Cr1m1zvL9JLqyKDwy0q2EVm1GLsJx38am63DnjAxXpI=;
        b=W07ErAjsvg3Awji7G8RtZ+wFsElDafrxg1PaK7DsVKo+pYVLOuhoyX0xppwpFsh6D+
         AfjIUTXvnYWWMT7Tqmlh5BAnHfog0ejqW3IOWBpefLSiKgUzrikUOG+a8LFwCW5gUEgi
         vLKVkR2k0DT1yG+9nsp1kaoqo1Xmc+wZSQPUqt9XhE/fBa8iF+cqRnQxw5Y+HcEcDpAt
         FDnxF458XkwNkEZynsDzvew+U/nOx8Vse9xNxQRMH2TChpmGP6rZhIBIlKiW12FTIzeH
         0Fw8Mi0dX1Hk2LUhDlujV0qH379BO7tFv9F3jmu+oW93dn/FoG558Eyw3xdIJAhDmW43
         zO5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Cr1m1zvL9JLqyKDwy0q2EVm1GLsJx38am63DnjAxXpI=;
        b=G8zIGMwkBvzUIVfHoP94C3cyTX8FfAzWGgaCQmZpmC02/zvxXV7JVavO8hvneVrFi4
         2OxKZ5zgKbCTTUdYJpRPkrUWXyUISWno9KuWyMP0ky+ezaoAX/4qICXrDqzGnqg+pS6h
         gpMk0H2qhpxtwEau5xeP22Yn8Q3SkIqNVfASvgPsd6cg/X1ATqkKIAkD6A23k87ZeWAb
         W5EVqk/tpiq33DmeAFqAJzW8i0PC0dyV/VKZnvgk2LyC0n4h95yO0iOo4I9hu8731VsA
         mbqhOFloXByDmZ9B2EvJXQepunL3RDQLjwqnTWOE0nwYTvbvHNZGZD9kxN9yE2KdBM0h
         zqfQ==
X-Gm-Message-State: AA+aEWbXyvmOXFibqJZZS+1+PYOa+DmuAiK4rILlPkz5EhHiPYBy5V7b
        meoR0pe1cGqKRYLD5NK6eA4r5NJQzJs=
X-Google-Smtp-Source: AFSGD/WrAMSuL9GEdO9f/BzLbPfQTS2xcmMDOWBP6N6wiWjjD83H1mo39HSCi8crmMljeEOv1dmA6w==
X-Received: by 2002:a81:af68:: with SMTP id x40mr16210615ywj.372.1543850455601;
        Mon, 03 Dec 2018 07:20:55 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id n65sm4425339ywf.15.2018.12.03.07.20.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:20:55 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 08/10] btrfs: rework btrfs_check_space_for_delayed_refs
Date:   Mon,  3 Dec 2018 10:20:36 -0500
Message-Id: <20181203152038.21388-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now with the delayed_refs_rsv we can now know exactly how much pending
delayed refs space we need.  This means we can drastically simplify
btrfs_check_space_for_delayed_refs by simply checking how much space we
have reserved for the global rsv (which acts as a spill over buffer) and
the delayed refs rsv.  If our total size is beyond that amount then we
know it's time to commit the transaction and stop any more delayed refs
from being generated.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c | 48 ++++++++++++++++++------------------------------
 fs/btrfs/inode.c       |  4 ++--
 fs/btrfs/transaction.c |  2 +-
 4 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2eba398c722b..30da075c042e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2631,7 +2631,7 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
 }
 
 int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans);
-int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans);
+bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info);
 void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
 					 const u64 start);
 void btrfs_wait_block_group_reservations(struct btrfs_block_group_cache *bg);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5a2d0b061f57..07ef1b8087f7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2839,40 +2839,28 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes)
 	return num_csums;
 }
 
-int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans)
+bool btrfs_check_space_for_delayed_refs(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_block_rsv *global_rsv;
-	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
-	u64 csum_bytes = trans->transaction->delayed_refs.pending_csums;
-	unsigned int num_dirty_bgs = trans->transaction->num_dirty_bgs;
-	u64 num_bytes, num_dirty_bgs_bytes;
-	int ret = 0;
+	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	bool ret = false;
+	u64 reserved;
 
-	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
-	num_heads = heads_to_leaves(fs_info, num_heads);
-	if (num_heads > 1)
-		num_bytes += (num_heads - 1) * fs_info->nodesize;
-	num_bytes <<= 1;
-	num_bytes += btrfs_csum_bytes_to_leaves(fs_info, csum_bytes) *
-							fs_info->nodesize;
-	num_dirty_bgs_bytes = btrfs_calc_trans_metadata_size(fs_info,
-							     num_dirty_bgs);
-	global_rsv = &fs_info->global_block_rsv;
+	spin_lock(&global_rsv->lock);
+	reserved = global_rsv->reserved;
+	spin_unlock(&global_rsv->lock);
 
 	/*
-	 * If we can't allocate any more chunks lets make sure we have _lots_ of
-	 * wiggle room since running delayed refs can create more delayed refs.
+	 * Since the global reserve is just kind of magic we don't really want
+	 * to rely on it to save our bacon, so if our size is more than the
+	 * delayed_refs_rsv and the global rsv then it's time to think about
+	 * bailing.
 	 */
-	if (global_rsv->space_info->full) {
-		num_dirty_bgs_bytes <<= 1;
-		num_bytes <<= 1;
-	}
-
-	spin_lock(&global_rsv->lock);
-	if (global_rsv->reserved <= num_bytes + num_dirty_bgs_bytes)
-		ret = 1;
-	spin_unlock(&global_rsv->lock);
+	spin_lock(&delayed_refs_rsv->lock);
+	reserved += delayed_refs_rsv->reserved;
+	if (delayed_refs_rsv->size >= reserved)
+		ret = true;
+	spin_unlock(&delayed_refs_rsv->lock);
 	return ret;
 }
 
@@ -2891,7 +2879,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans)
 	if (val >= NSEC_PER_SEC / 2)
 		return 2;
 
-	return btrfs_check_space_for_delayed_refs(trans);
+	return btrfs_check_space_for_delayed_refs(trans->fs_info);
 }
 
 struct async_delayed_refs {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a097f5fde31d..8532a2eb56d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5326,8 +5326,8 @@ static struct btrfs_trans_handle *evict_refill_and_join(struct btrfs_root *root,
 		 * Try to steal from the global reserve if there is space for
 		 * it.
 		 */
-		if (!btrfs_check_space_for_delayed_refs(trans) &&
-		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, false))
+		if (!btrfs_check_space_for_delayed_refs(fs_info) &&
+		    !btrfs_block_rsv_migrate(global_rsv, rsv, rsv->size, 0))
 			return trans;
 
 		/* If not, commit and try again. */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a21c4defad92..2d8401bf8df9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -789,7 +789,7 @@ static int should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 
-	if (btrfs_check_space_for_delayed_refs(trans))
+	if (btrfs_check_space_for_delayed_refs(fs_info))
 		return 1;
 
 	return !!btrfs_block_rsv_check(&fs_info->global_block_rsv, 5);
-- 
2.14.3

