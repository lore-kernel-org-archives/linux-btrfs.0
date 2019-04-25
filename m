Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DE0C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 20:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C9F206BF
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 20:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="AlaO0IJ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387657AbfDYUwv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 16:52:51 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:34047 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfDYUwu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 16:52:50 -0400
Received: by mail-yw1-f68.google.com with SMTP id u14so424321ywe.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 13:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=tu/GUFU/ra7x9u8KYeGsPuCdGxqXH37A6eCbA6dufJ8=;
        b=AlaO0IJ8BYli7ERHWZ9ozPf946UrtPzOa/2VdQ6RU4W+iWKJnzeVG0dM5slNbGTYw0
         e5I08mR19QRhWGduPb9pylPMxDdrZD68/a26nyTgaaMLdLXMmNH73WNBZNIevmhQU7lB
         6B/xkBupM8bAZoOKqoaF4GDXef7/RhRrNdDxx3/Qi6Y0r8DoAJ44MlEoCfu9zg8BJQSw
         apUm5UIfpU9duwQ6FOI70rw8XTlpUNti7vmJZ4Xc99LuyjVe61cE3IP3g1/D2cmiO4vr
         E4Exe1EiMyr3E7bMN0cgKeCxa+9TX26rZca13rtPA2P2TeBVhQ76UuHJsugVIsbeGLGx
         D2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=tu/GUFU/ra7x9u8KYeGsPuCdGxqXH37A6eCbA6dufJ8=;
        b=IhY4az3XuqvDzbeucAO5Q6uvL7Y8lafsfLX+XcvZUHWR2/9OEcO9uShTpHQu3IeWh8
         dMOF31/5DS0ku9xwyM/IsStUQAz7005/blBvD7yNEFwGcdHQlOgPMGff30SRZBg1TYB6
         xgllJ/XiI0jtdi2nZWRszvHIgWUXg35gow0KDbIbCTGapa8gx+9rtTgUZgNsVxnaTs9i
         C8ID+6oJjsaElYJ7vVtNtm/JDhRAyzP6PwN4y5dA/dic6Grod9RJ5EjnrMSwaBix8MJo
         hVsjRZD3CA//CGL180nwLtdLdeHAHIwsWFMUveRzXgyR1O02kfRTaEqU4wUdWLUAv3eB
         dkeQ==
X-Gm-Message-State: APjAAAVRb3QYnml2iW4RhiQphVUpHeTsMUF86MdItrfP8VdWjy3CotXn
        X8eNxu6YpdxzZrHDSzu7yuDQhL7OpxXt6A==
X-Google-Smtp-Source: APXvYqwf4g11X2mafCQo7BMec13V2GLFECimRPbauOzPTnTkZsyST23LfIAweGh8YJ1Qw72+rupyxA==
X-Received: by 2002:a81:9292:: with SMTP id j140mr23647752ywg.301.1556225569108;
        Thu, 25 Apr 2019 13:52:49 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::590e])
        by smtp.gmail.com with ESMTPSA id 207sm26832ywo.85.2019.04.25.13.52.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 13:52:48 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH][v2] btrfs: track odirect bytes in flight
Date:   Thu, 25 Apr 2019 16:52:47 -0400
Message-Id: <20190425205247.99177-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190410195610.84110-1-josef@toxicpanda.com>
References: <20190410195610.84110-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When diagnosing a slowdown of generic/224 I noticed we were not doing
anything when calling into shrink_delalloc().  This is because all
writes in 224 are O_DIRECT, not delalloc, and thus our delalloc_bytes
counter is 0, which short circuits most of the work inside of
shrink_delalloc().  However O_DIRECT writes still consume metadata
resources and generate ordered extents, which we can still wait on.

Fix this by tracking outstandingn odirect write bytes, and use this as
well as the delalloc byts counter to decide if we need to lookup and
wait on any ordered extents.  If we have more odirect writes than
delalloc bytes we'll go ahead and wait on any ordered extents
irregardless of our flush state as flushing delalloc is likely to not
gain us anything.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
v1->v2:
- updated the changelog

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

