Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A521C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 16:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE9220700
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 16:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfC0QBh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:01:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:44424 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbfC0QBh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 12:01:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42D68AF9A
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 16:01:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A27DFDA8D8; Wed, 27 Mar 2019 17:02:47 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: qgroup: remove obsolete fs_info members
Date:   Wed, 27 Mar 2019 17:02:45 +0100
Message-Id: <20190327160245.27181-1-dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The commit fcebe4562dec ("Btrfs: rework qgroup accounting") reworked
qgroups and added some new structures. Another rework of qgroup
mechanics e69bcee37692 ("btrfs: qgroup: Cleanup the old
ref_node-oriented mechanism.") stopped using them and left uncleaned.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 3 ---
 fs/btrfs/disk-io.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1d1e12400552..5d85c55032dd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1092,10 +1092,7 @@ struct btrfs_fs_info {
 
 	/* holds configuration and tracking. Protected by qgroup_lock */
 	struct rb_root qgroup_tree;
-	struct rb_root qgroup_op_tree;
 	spinlock_t qgroup_lock;
-	spinlock_t qgroup_op_lock;
-	atomic_t qgroup_op_seq;
 
 	/*
 	 * used to avoid frequently calling ulist_alloc()/ulist_free()
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8740152cce1f..c3b89584dad6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2174,7 +2174,6 @@ static void btrfs_init_qgroup(struct btrfs_fs_info *fs_info)
 	spin_lock_init(&fs_info->qgroup_lock);
 	mutex_init(&fs_info->qgroup_ioctl_lock);
 	fs_info->qgroup_tree = RB_ROOT;
-	fs_info->qgroup_op_tree = RB_ROOT;
 	INIT_LIST_HEAD(&fs_info->dirty_qgroups);
 	fs_info->qgroup_seq = 1;
 	fs_info->qgroup_ulist = NULL;
@@ -2679,7 +2678,6 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->defrag_inodes_lock);
 	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	spin_lock_init(&fs_info->super_lock);
-	spin_lock_init(&fs_info->qgroup_op_lock);
 	spin_lock_init(&fs_info->buffer_lock);
 	spin_lock_init(&fs_info->unused_bgs_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
@@ -2706,7 +2704,6 @@ int open_ctree(struct super_block *sb,
 
 	atomic_set(&fs_info->async_delalloc_pages, 0);
 	atomic_set(&fs_info->defrag_running, 0);
-	atomic_set(&fs_info->qgroup_op_seq, 0);
 	atomic_set(&fs_info->reada_works_cnt, 0);
 	atomic_set(&fs_info->nr_delayed_iputs, 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
-- 
2.21.0

