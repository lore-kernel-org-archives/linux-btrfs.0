Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2987AC04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E599221582
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="09f8JORQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E599221582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388453AbeKVFpD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:45:03 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35025 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388448AbeKVFpC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:45:02 -0500
Received: by mail-yw1-f65.google.com with SMTP id h32so2692825ywk.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=9bPPV7NkfBrLK2PcGSqEp/CCsUF5YqP0GCJnqYp4fm4=;
        b=09f8JORQ1fdvgzOyHKE3iutQoLLGjGAddTqS0xxmaOtLmuDp9S2ShwN5334ybjlHed
         YcyxgSNR1Y86mjWTmaCKzqj58+dIeSF8SPDrCfXFAXoPeIzp2kw06dZGpvOQg41m/15p
         DpYxXZQBv5Ovr1Qgq2/3Ja1XkFBPzUdB1snW+XgctKF0MBALET8RZOyL23XZqv8nA0pn
         CwwZbr9egQwbzJbaBxG+Xfhz1QMh+WCdPFPmdTkiP1v+DATEFmU/f/YW3GMZh1YJzWAu
         /X+Veo78pi1bgu9oBLovcx5sfu+/nVDghKLSkFzdlrjy3aRgJY/v0l2qoSAKVEQHXN8f
         pVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=9bPPV7NkfBrLK2PcGSqEp/CCsUF5YqP0GCJnqYp4fm4=;
        b=ptz6tBY+Kd7HKOHiKvkHynS7X0oXi3Hkr/o0VrHUYdZdmBcXmQEHpY7FMvB6zAq9qj
         Kf1M+bPP7ehLKpJacJq/MZXPgBtAjmw71zSsiR+9p1IgxdFpjHc4+z/m7aeDpLnxjsoU
         qMW1dJ1fTe1uxdUAhosvwB3LZWMz3EfbU64+NlNti3Y1wI3PqzCQ7CWxxVncMwUhIlg0
         il/Ksc2jdzu+gB2Xl7IKM3F+m7iIKVdwOjiuEzlCQdrP/QUIFyTYyYVVJwIwlQMFtBEO
         AI4RSY6tpDywFqGvWV9y6L22pYLVEI389kbePcowRB7QY/oV08BJp4Na1BmTQE5hCSJH
         0gTg==
X-Gm-Message-State: AGRZ1gKlMkEol9rdrjnz9nYbPq2EwVQJurjjWryQLbDr92nKuJnfyB6g
        4ss7q+9KNsAx65zHOS/43oqqU6hwMPk=
X-Google-Smtp-Source: AJdET5e42G+lx73wayv1pkxvDWCdF/LpCWy1pUsWqE5OrGUCfceLG13wXo537BitaTxa30U5/e7fJQ==
X-Received: by 2002:a0d:d84c:: with SMTP id a73mr7955748ywe.184.1542827369163;
        Wed, 21 Nov 2018 11:09:29 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c127sm7279933ywb.67.2018.11.21.11.09.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:09:28 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 3/3] btrfs: replace cleaner_delayed_iput_mutex with a waitqueue
Date:   Wed, 21 Nov 2018 14:09:22 -0500
Message-Id: <20181121190922.25038-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190922.25038-1-josef@toxicpanda.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
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
index 709de7471d86..a835fe7076eb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -912,7 +912,8 @@ struct btrfs_fs_info {
 
 	spinlock_t delayed_iput_lock;
 	struct list_head delayed_iputs;
-	struct mutex cleaner_delayed_iput_mutex;
+	atomic_t nr_delayed_iputs;
+	wait_queue_head_t delayed_iputs_wait;
 
 	/* this protects tree_mod_seq_list */
 	spinlock_t tree_mod_seq_lock;
@@ -3237,6 +3238,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info);
+int btrfs_wait_on_delayed_iputs(struct btrfs_fs_info *fs_info);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
 			      u64 start, u64 num_bytes, u64 min_size,
 			      loff_t actual_len, u64 *alloc_hint);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c5918ff8241b..3f81dfaefa32 100644
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
@@ -2651,7 +2649,6 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->delete_unused_bgs_mutex);
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
-	mutex_init(&fs_info->cleaner_delayed_iput_mutex);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
@@ -2673,6 +2670,7 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->qgroup_op_seq, 0);
 	atomic_set(&fs_info->reada_works_cnt, 0);
+	atomic_set(&fs_info->nr_delayed_iputs, 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
@@ -2750,6 +2748,7 @@ int open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->transaction_wait);
 	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
+	init_waitqueue_head(&fs_info->delayed_iputs_wait);
 
 	INIT_LIST_HEAD(&fs_info->pinned_chunks);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3a90dc1d6b31..36f43876be22 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4272,8 +4272,9 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
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
@@ -4838,9 +4839,9 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
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
index 3c42d8887183..57bf514a90eb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3260,6 +3260,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
+	atomic_inc(&fs_info->nr_delayed_iputs);
 	spin_lock(&fs_info->delayed_iput_lock);
 	ASSERT(list_empty(&binode->delayed_iput));
 	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
@@ -3279,11 +3280,31 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
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

