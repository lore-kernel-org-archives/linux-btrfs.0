Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302BEC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF896215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="s3rvmWeS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF896215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbeI1Rm4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:56 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33176 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbeI1Rmz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id i10-v6so6194935qtp.0
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=LU0+VWWWubdNmxxLWHJ3F1vkXtQo+CBzk4lWtJGRwKk=;
        b=s3rvmWeSk8G4Pn4Tfrz4vt6RmUW4McbmawLNthU+LHGeE151wTp5Wz30OTpIosfWJT
         BpoVk79D653/aEjdt+SQjn+BJDnPcSHSGBP5n6aBW9V3n9YgFjGovRj7Bdk66uZN8ft+
         nQ6whrvX7nOMKfyRGhWtnhO2taf16aQv3f5Q9eOYQoWuS6mo1OWHrUEwLx2X8oy4QRSp
         9y9P10X1hyi9BCI5+3PFu0k3zuTXQdtkXG1TCJBLTKCYj0vSZQdxIHmZ08XDRCbByLXj
         zT3SPFJ0qO1GHXasXwh8ZNiMA2ZNn/suLVzg459r/VNOR1ELgjsyqJq1joE3zN9XE9zJ
         SStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=LU0+VWWWubdNmxxLWHJ3F1vkXtQo+CBzk4lWtJGRwKk=;
        b=BSAVD9uyk7/TX2fzPg2S4P5yuZ9F5fbDYujdZSKttBLtzwXuAwkZuCp1MXOYvZj8ji
         FIdRy84EiviaAco/jH5eHDa4EVftlGAYtQAoSRxJIpLJ5T0FB6GSDrqwYgVczmfi43xk
         kDeyDEfVBSJ0+YTETMkvy3qhLBMBUlMZpC1etkaUk7Su86QnAPfIUaYGOjlrCOXgIWvL
         JCb1YrkEvzOVjfC/4iFACE7l1O80Si3BjcVLqI/8UG4izYlvSuYhXqCPs58uNcYLtIlO
         CXkShVsbX3RXWzcjwpCJ4pHPKLFhrsLCArK7B2VXAQJaCLeWDMweiEa93n/gVJQ9NH5F
         bdyQ==
X-Gm-Message-State: ABuFfojXFOCeAUYTspdkC3LnMM16GTFtbYcvfXPTu07aipfGa39k5tJ0
        DXEVSGFr0zLN852I90iy4tctsw==
X-Google-Smtp-Source: ACcGV60djeCNCU+5USVF0a7VrZUV1N53qUIcNDeo5jrFGr9QsVL5QMxFpWQnoJTyC2V8D7FULGFlWg==
X-Received: by 2002:a0c:be01:: with SMTP id k1-v6mr11188406qvg.169.1538133577094;
        Fri, 28 Sep 2018 04:19:37 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f85-v6sm3252406qkh.35.2018.09.28.04.19.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:36 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 39/42] btrfs: replace cleaner_delayed_iput_mutex with a waitqueue
Date:   Fri, 28 Sep 2018 07:18:18 -0400
Message-Id: <20180928111821.24376-40-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The throttle path doesn't take cleaner_delayed_iput_mutex, which means
we could think we're done flushing iputs in the data space reservation
path when we could have a throttler doing an iput.  There's no real
reason to serialize the delayed iput flushing, so instead of taking the
cleaner_delayed_iput_mutex whenever we flush the delayed iputs just
replace it with an atomic counter and a waitqueue.  This removes the
short (or long depending on how big the inode is) window where we think
there are no more pending iputs when there really are some.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h       |  4 +++-
 fs/btrfs/disk-io.c     |  5 ++---
 fs/btrfs/extent-tree.c |  9 +++++----
 fs/btrfs/inode.c       | 21 +++++++++++++++++++++
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e40356ca0295..1ef0b1649cad 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -894,7 +894,8 @@ struct btrfs_fs_info {
 
 	spinlock_t delayed_iput_lock;
 	struct list_head delayed_iputs;
-	struct mutex cleaner_delayed_iput_mutex;
+	atomic_t nr_delayed_iputs;
+	wait_queue_head_t delayed_iputs_wait;
 
 	/* this protects tree_mod_seq_list */
 	spinlock_t tree_mod_seq_lock;
@@ -3212,6 +3213,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info);
+int btrfs_wait_on_delayed_iputs(struct btrfs_fs_info *fs_info);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
 			      u64 start, u64 num_bytes, u64 min_size,
 			      loff_t actual_len, u64 *alloc_hint);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 51b2a5bf25e5..3dce9ff72e41 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1692,9 +1692,7 @@ static int cleaner_kthread(void *arg)
 			goto sleep;
 		}
 
-		mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
 		btrfs_run_delayed_iputs(fs_info);
-		mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
 
 		again = btrfs_clean_one_deleted_snapshot(root);
 		mutex_unlock(&fs_info->cleaner_mutex);
@@ -2677,7 +2675,6 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->delete_unused_bgs_mutex);
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
-	mutex_init(&fs_info->cleaner_delayed_iput_mutex);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
@@ -2699,6 +2696,7 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->qgroup_op_seq, 0);
 	atomic_set(&fs_info->reada_works_cnt, 0);
+	atomic_set(&fs_info->nr_delayed_iputs, 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
@@ -2776,6 +2774,7 @@ int open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->transaction_wait);
 	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
+	init_waitqueue_head(&fs_info->delayed_iputs_wait);
 
 	INIT_LIST_HEAD(&fs_info->pinned_chunks);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a7ba0d0e8de1..77bc53ad84e9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4258,8 +4258,9 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 				 * operations. Wait for it to finish so that
 				 * more space is released.
 				 */
-				mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
-				mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
+				ret = btrfs_wait_on_delayed_iputs(fs_info);
+				if (ret)
+					return ret;
 				goto again;
 			} else {
 				btrfs_end_transaction(trans);
@@ -4829,9 +4830,9 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	 * pinned space, so make sure we run the iputs before we do our pinned
 	 * bytes check below.
 	 */
-	mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
 	btrfs_run_delayed_iputs(fs_info);
-	mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
+	wait_event(fs_info->delayed_iputs_wait,
+		   atomic_read(&fs_info->nr_delayed_iputs) == 0);
 
 	trans = btrfs_join_transaction(fs_info->extent_root);
 	if (IS_ERR(trans))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0a1671fb03bf..ab8242b10601 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3319,6 +3319,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
+	atomic_inc(&fs_info->nr_delayed_iputs);
 	spin_lock(&fs_info->delayed_iput_lock);
 	ASSERT(list_empty(&binode->delayed_iput));
 	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
@@ -3338,11 +3339,31 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
 		list_del_init(&inode->delayed_iput);
 		spin_unlock(&fs_info->delayed_iput_lock);
 		iput(&inode->vfs_inode);
+		if (atomic_dec_and_test(&fs_info->nr_delayed_iputs))
+			wake_up(&fs_info->delayed_iputs_wait);
 		spin_lock(&fs_info->delayed_iput_lock);
 	}
 	spin_unlock(&fs_info->delayed_iput_lock);
 }
 
+/**
+ * btrfs_wait_on_delayed_iputs - wait on the delayed iputs to be done running
+ * @fs_info - the fs_info for this fs
+ * @return - EINTR if we were killed, 0 if nothing's pending
+ *
+ * This will wait on any delayed iputs that are currently running with KILLABLE
+ * set.  Once they are all done running we will return, unless we are killed in
+ * which case we return EINTR.
+ */
+int btrfs_wait_on_delayed_iputs(struct btrfs_fs_info *fs_info)
+{
+	int ret = wait_event_killable(fs_info->delayed_iputs_wait,
+			atomic_read(&fs_info->nr_delayed_iputs) == 0);
+	if (ret)
+		return -EINTR;
+	return 0;
+}
+
 /*
  * This creates an orphan entry for the given inode in case something goes wrong
  * in the middle of an unlink.
-- 
2.14.3

