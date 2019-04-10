Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866F4C10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 19:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE9720830
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 19:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Py+rvVp+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbfDJT4S (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:56:18 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38000 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbfDJT4S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 15:56:18 -0400
Received: by mail-qt1-f193.google.com with SMTP id d13so4414859qth.5
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 12:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=I7jYfahfxCdMopFKYT/hCdg8fYMNBILAopL39PmDIbU=;
        b=Py+rvVp+X1KS5PPCRUjM4OTe+5hdXo6FjLr8nnzCKhslVx2kKjJ9zxUd+sdFheeYkP
         0leayJ9EJv1byoNT9QbU4SM6yIgird6LApJ/NlPvAIuD6VDVRRv0R2Yg6LNpdCB1pkOB
         Xt/OK6NB6M+eJeiXr+BV1VO4qlexteuK/7VG1PxZ3LRm1Avw7k18cKToJyLD9Il0t54x
         QWH8ia4+/gzjv82W24i32TZ2nzvlC9ZqC6vndcnK2wdfl+sz0AU9M+0/1a5rXVsTVA3E
         ov2Tteh8QDt4LksSi4GyvgD1krPT8opnM//K91wMJH24wIZyGLv2juWTL2XsHtyV5xdY
         HxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=I7jYfahfxCdMopFKYT/hCdg8fYMNBILAopL39PmDIbU=;
        b=VaAdDZ2JeWdFo5AMq5slx3F811IVfStDaEghIT51RqpqXaoxj9lTF/izCSIWLMsQer
         kDBGJ99+vAKD6tdXjSGr9gZhM3RzCGvWmzCQPRlKzjnJZ0cFqH7ks1EBS8CHQMy87xJQ
         rw1OIG1QIcvzYajvSGlzmCPLtXCoNsXmpKRF+iui+x9dWo4/MpepnshvYkz9xeeON9jO
         Q83DShf+kgS9Jv8SssWLMcl6KYkD7uflPB31tx5k4DaxQxQXC1R/nHduUSij6CUjaIaL
         HdDmAPOy/RyTcEwEHKwqiXZH9ngsI8Gj6fvxNpmKJmkC1y1Da2yfjeJwbFHBwSpPiqNw
         Gfeg==
X-Gm-Message-State: APjAAAVBVo1XtFgCqPU226Lk3Icxf0LTo1Z3KhAt5dUlNlbC6f3voVoF
        5zHXtxZnGzrnQ1a8TpwlHZ6TOUeb4estQQ==
X-Google-Smtp-Source: APXvYqwfdiCnBnKo+jUiNK2DcRikPVQaWZM/dY09y1jGmF+Q4g3hPEqyeLR5P4SEbG6MfF9jvTb19w==
X-Received: by 2002:ac8:674f:: with SMTP id n15mr37156326qtp.289.1554926176405;
        Wed, 10 Apr 2019 12:56:16 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t2sm20688130qkd.57.2019.04.10.12.56.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 12:56:15 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: track odirect bytes in flight
Date:   Wed, 10 Apr 2019 15:56:09 -0400
Message-Id: <20190410195610.84110-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190410195610.84110-1-josef@toxicpanda.com>
References: <20190410195610.84110-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When diagnosing a slowdown of generic/224 I noticed we were wasting a
lot of time in shrink_delalloc() despite all writes being O_DIRECT
writes.  O_DIRECT writes still have outstanding extents, but obviously
cannot be directly flushed, instead we need to wait on their
corresponding ordered extent.  Track the outstanding odirect write bytes
and if this amount is higher than the delalloc bytes in the system go
ahead and force us to wait on the ordered extents.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h        |  1 +
 fs/btrfs/disk-io.c      | 15 ++++++++++++++-
 fs/btrfs/extent-tree.c  | 17 +++++++++++++++--
 fs/btrfs/ordered-data.c |  9 ++++++++-
 4 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7e774d48c48c..e293d74b2ead 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1016,6 +1016,7 @@ struct btrfs_fs_info {
 	/* used to keep from writing metadata until there is a nice batch */
 	struct percpu_counter dirty_metadata_bytes;
 	struct percpu_counter delalloc_bytes;
+	struct percpu_counter odirect_bytes;
 	s32 dirty_metadata_batch;
 	s32 delalloc_batch;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7a88de4be8d7..3f0b1854cedc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2641,11 +2641,17 @@ int open_ctree(struct super_block *sb,
 		goto fail;
 	}
 
-	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0, GFP_KERNEL);
+	ret = percpu_counter_init(&fs_info->odirect_bytes, 0, GFP_KERNEL);
 	if (ret) {
 		err = ret;
 		goto fail_srcu;
 	}
+
+	ret = percpu_counter_init(&fs_info->dirty_metadata_bytes, 0, GFP_KERNEL);
+	if (ret) {
+		err = ret;
+		goto fail_odirect_bytes;
+	}
 	fs_info->dirty_metadata_batch = PAGE_SIZE *
 					(1 + ilog2(nr_cpu_ids));
 
@@ -3344,6 +3350,8 @@ int open_ctree(struct super_block *sb,
 	percpu_counter_destroy(&fs_info->delalloc_bytes);
 fail_dirty_metadata_bytes:
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
+fail_odirect_bytes:
+	percpu_counter_destroy(&fs_info->odirect_bytes);
 fail_srcu:
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 fail:
@@ -4025,6 +4033,10 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
+	if (percpu_counter_sum(&fs_info->odirect_bytes))
+		btrfs_info(fs_info, "at unmount odirect count %lld",
+			   percpu_counter_sum(&fs_info->odirect_bytes));
+
 	btrfs_sysfs_remove_mounted(fs_info);
 	btrfs_sysfs_remove_fsid(fs_info->fs_devices);
 
@@ -4056,6 +4068,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
 	percpu_counter_destroy(&fs_info->delalloc_bytes);
+	percpu_counter_destroy(&fs_info->odirect_bytes);
 	percpu_counter_destroy(&fs_info->dev_replace.bio_counter);
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d0626f945de2..0982456ebabb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4727,6 +4727,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
 	u64 delalloc_bytes;
+	u64 odirect_bytes;
 	u64 async_pages;
 	u64 items;
 	long time_left;
@@ -4742,7 +4743,9 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 
 	delalloc_bytes = percpu_counter_sum_positive(
 						&fs_info->delalloc_bytes);
-	if (delalloc_bytes == 0) {
+	odirect_bytes = percpu_counter_sum_positive(
+						&fs_info->odirect_bytes);
+	if (delalloc_bytes == 0 && odirect_bytes == 0) {
 		if (trans)
 			return;
 		if (wait_ordered)
@@ -4750,8 +4753,16 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 		return;
 	}
 
+	/*
+	 * If we are doing more ordered than delalloc we need to just wait on
+	 * ordered extents, otherwise we'll waste time trying to flush delalloc
+	 * that likely won't give us the space back we need.
+	 */
+	if (odirect_bytes > delalloc_bytes)
+		wait_ordered = true;
+
 	loops = 0;
-	while (delalloc_bytes && loops < 3) {
+	while ((delalloc_bytes || odirect_bytes)  && loops < 3) {
 		nr_pages = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
 
 		/*
@@ -4801,6 +4812,8 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 		}
 		delalloc_bytes = percpu_counter_sum_positive(
 						&fs_info->delalloc_bytes);
+		odirect_bytes = percpu_counter_sum_positive(
+						&fs_info->odirect_bytes);
 	}
 }
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 6fde2b2741ef..967c62b85d77 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -194,8 +194,11 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
 		set_bit(type, &entry->flags);
 
-	if (dio)
+	if (dio) {
+		percpu_counter_add_batch(&fs_info->odirect_bytes, len,
+					 fs_info->delalloc_batch);
 		set_bit(BTRFS_ORDERED_DIRECT, &entry->flags);
+	}
 
 	/* one ref for the tree */
 	refcount_set(&entry->refs, 1);
@@ -468,6 +471,10 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	if (root != fs_info->tree_root)
 		btrfs_delalloc_release_metadata(btrfs_inode, entry->len, false);
 
+	if (test_bit(BTRFS_ORDERED_DIRECT, &entry->flags))
+		percpu_counter_add_batch(&fs_info->odirect_bytes, -entry->len,
+					 fs_info->delalloc_batch);
+
 	tree = &btrfs_inode->ordered_tree;
 	spin_lock_irq(&tree->lock);
 	node = &entry->rb_node;
-- 
2.13.5

