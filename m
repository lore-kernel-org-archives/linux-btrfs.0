Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5329FC6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15D862087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="SexBi4y6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15D862087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbeJMDIc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:32 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43257 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeJMDIc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:32 -0400
Received: by mail-qt1-f193.google.com with SMTP id q41-v6so15046050qtq.10
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=376B5Ewk9SX6zKU3F++7M86mkOiT1w+Wgn5fDYhS55g=;
        b=SexBi4y6aJiZZOmDM9kDlDU7WqHdFJNdOgWRBuIcdFMHYQcr5qvn7h+5rqYghVy2rj
         q+0ysKs1bsG0WfHISMBIs1Yh3Q/SIoR4AetDzEsg5Us3+U5dJLZy994tmsQgNl5fN5XS
         KKClGrtqBI4rDBDUrl267sMwXJ4iG6Qkc/kGHjNjT73Mz+9STusUUdHIM25pxhurTx4q
         UtAQK2AG67JPiSmvLhVlbvTrX9UKp+grb637aYr7KlccKcOHelotRTtku1nii1kELeV5
         Xne5xOF3N4h1XaV3nfkPTspwRFouYDCVSAreQmrjyBRVW21VRbv8WLsnQcF2KqAhm8D/
         nj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=376B5Ewk9SX6zKU3F++7M86mkOiT1w+Wgn5fDYhS55g=;
        b=CyEVVvszTGK130o8m7droqW04jqxKgcPkPjleV1vGFwktKSknlJgFALQ74qeVp0duu
         QQYbJPpOTnZIF5lae/kP0RH9JdeT5nMefZ2TUA0LYc+TSH9n4DmsH6vUk1A62yFHJ0QS
         8NLWysDvWbcX8YgqnCW0h5J2J5TLK+nHhFFcEoZtUL/203LdjEnrYz3bX/POdGHw+N6t
         /SoTsjiGGT4CRl0FOo8MUDjiJ0+nxIXU2QEGdZHJngMqzUdHJxHBzAzhXaIRPLc8GFnm
         Bo2TrRWdOQXRDtdPDyyYTmB+b01nFKWOseixwyAIoBZxWwx2WLtmGeOzjnBRJsfAUPPd
         VIAQ==
X-Gm-Message-State: ABuFfogGkH2RrLrYr01xDO9X2y5hYMcx5ItC1GCLYtewU29ksaibSUQM
        TfGDG8hjjssO5OvDr1TerNOZA0c4XXs=
X-Google-Smtp-Source: ACcGV63PpgvLaN00tundypUNXk6GDKTbUv1yYjUgRoE4Ii7IGff12dW3aVo01Bngo0TH80/ZNgwRDA==
X-Received: by 2002:ac8:145:: with SMTP id f5-v6mr6958476qtg.221.1539372870015;
        Fri, 12 Oct 2018 12:34:30 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1576227qta.0.2018.10.12.12.34.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:34:29 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 39/42] btrfs: replace cleaner_delayed_iput_mutex with a waitqueue
Date:   Fri, 12 Oct 2018 15:32:53 -0400
Message-Id: <20181012193256.13735-40-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
index 2056d5d37dfe..d0a7b0589826 100644
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

