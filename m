Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE12C04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B89F20834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="vL896RDF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B89F20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbeLCQHH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 11:07:07 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44254 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbeLCQHH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 11:07:07 -0500
Received: by mail-qt1-f193.google.com with SMTP id n32so14300750qte.11
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 08:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=KmoLkQUmJ5y15XdoBR+CyEsDcPwcXoC/2RTzlLCIUKI=;
        b=vL896RDF0tz6PFnrIOLyrMJc3A5ESDrwcXGF7KolHBlGo2MRK/FPgS1yjUTRJmIrk8
         8hgAUCRL18UXGzQvY+GEjcfUqKvxaxcnaLl91WoxlduA5PsPVqCVYVvfwEZpWAFPDogI
         NLUMhQPl5CGMU8pUW5CUZgnXRy2B9dr9kQRYrIEPXRYfJy/P3Rv/wunB1pefaG1mp26Y
         bdI0xBcL6OR9byQhDNPzhSd/cEQYSmu+qw1WfZu7fnqqhyCOvHNpTTc6Ma72llsXQCv7
         hGk1x0i5i1V+TxD8pMvXlUZYhVPeHYukeEi/pMrtYKFxzP+N/WfwWmI9ALmNHskYrMMC
         UiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=KmoLkQUmJ5y15XdoBR+CyEsDcPwcXoC/2RTzlLCIUKI=;
        b=aN+hNoHUMTWUB6HrpE7qsCvPnv4nsP4rnuR1et2llAvC2uA2cELjw6XTbfRSGH+Ecg
         +mNrVe7eAfVpOTn/fQTp61d9GSrGLk3zedOvsPACkj3FXOMBuD3HmXB0x2hOmOLAIjwc
         +g1OXBYsA/x6lgXfVNRLepMYiW1WZYAcOJDM9RodEVgbRb31TBXQlDPWSlH3nCMgz6O9
         s442FLFu4/SclqNHspfH2BJrfLnFf00mZWIDq0FTfm6PFNBIRQgAKjF+UwwtC20BHBeY
         xKr20Hsf4gdQDwvhNz93uvhIWz+4vaiZX3knPI5ZJ/3oVCbKC++mFmCC0XJPv56WI0C0
         BrmQ==
X-Gm-Message-State: AA+aEWamHB6+2a3iX3gvQ8bwXgE3Uh2VxUrtgr5/R4YktTz+WUF/apL2
        30r+4bBnN7nI9n7A+zXrFqrGXkx5b18=
X-Google-Smtp-Source: AFSGD/U3FNsy51leB/8wJyRtvKryGTbNkJ3DxampGOH5fmpt05g9lf4eDRe3CG/438AtxEGlAUSIJA==
X-Received: by 2002:ac8:3f2d:: with SMTP id c42mr15994317qtk.33.1543853219935;
        Mon, 03 Dec 2018 08:06:59 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f13sm6798493qkm.52.2018.12.03.08.06.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 08:06:59 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 3/3] btrfs: replace cleaner_delayed_iput_mutex with a waitqueue
Date:   Mon,  3 Dec 2018 11:06:52 -0500
Message-Id: <20181203160652.25078-4-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203160652.25078-1-josef@toxicpanda.com>
References: <20181203160652.25078-1-josef@toxicpanda.com>
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
 fs/btrfs/extent-tree.c | 13 ++++++++-----
 fs/btrfs/inode.c       | 21 +++++++++++++++++++++
 4 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index dc56a4d940c3..20af5d6d81f1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -915,7 +915,8 @@ struct btrfs_fs_info {
 
 	spinlock_t delayed_iput_lock;
 	struct list_head delayed_iputs;
-	struct mutex cleaner_delayed_iput_mutex;
+	atomic_t nr_delayed_iputs;
+	wait_queue_head_t delayed_iputs_wait;
 
 	/* this protects tree_mod_seq_list */
 	spinlock_t tree_mod_seq_lock;
@@ -3240,6 +3241,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info);
+int btrfs_wait_on_delayed_iputs(struct btrfs_fs_info *fs_info);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
 			      u64 start, u64 num_bytes, u64 min_size,
 			      loff_t actual_len, u64 *alloc_hint);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f40f6fdc1019..238e0113f2d3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1694,9 +1694,7 @@ static int cleaner_kthread(void *arg)
 			goto sleep;
 		}
 
-		mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
 		btrfs_run_delayed_iputs(fs_info);
-		mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
 
 		again = btrfs_clean_one_deleted_snapshot(root);
 		mutex_unlock(&fs_info->cleaner_mutex);
@@ -2654,7 +2652,6 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->delete_unused_bgs_mutex);
 	mutex_init(&fs_info->reloc_mutex);
 	mutex_init(&fs_info->delalloc_root_mutex);
-	mutex_init(&fs_info->cleaner_delayed_iput_mutex);
 	seqlock_init(&fs_info->profiles_lock);
 
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
@@ -2676,6 +2673,7 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->qgroup_op_seq, 0);
 	atomic_set(&fs_info->reada_works_cnt, 0);
+	atomic_set(&fs_info->nr_delayed_iputs, 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
@@ -2753,6 +2751,7 @@ int open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->transaction_wait);
 	init_waitqueue_head(&fs_info->transaction_blocked_wait);
 	init_waitqueue_head(&fs_info->async_submit_wait);
+	init_waitqueue_head(&fs_info->delayed_iputs_wait);
 
 	INIT_LIST_HEAD(&fs_info->pinned_chunks);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0127d272cd2a..5b6c9fc227ff 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4280,10 +4280,14 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 				/*
 				 * The cleaner kthread might still be doing iput
 				 * operations. Wait for it to finish so that
-				 * more space is released.
+				 * more space is released.  We don't need to
+				 * explicitly run the delayed iputs here because
+				 * the commit_transaction would have woken up
+				 * the cleaner.
 				 */
-				mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
-				mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
+				ret = btrfs_wait_on_delayed_iputs(fs_info);
+				if (ret)
+					return ret;
 				goto again;
 			} else {
 				btrfs_end_transaction(trans);
@@ -4958,9 +4962,8 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		 * bunch of pinned space, so make sure we run the iputs before
 		 * we do our pinned bytes check below.
 		 */
-		mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
 		btrfs_run_delayed_iputs(fs_info);
-		mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
+		btrfs_wait_on_delayed_iputs(fs_info);
 
 		ret = may_commit_transaction(fs_info, space_info);
 		break;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0b9f3e482cea..958e30c7c744 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3260,6 +3260,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
+	atomic_inc(&fs_info->nr_delayed_iputs);
 	spin_lock(&fs_info->delayed_iput_lock);
 	ASSERT(list_empty(&binode->delayed_iput));
 	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
@@ -3280,11 +3281,31 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
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

