Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:45274 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbeGSPeA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:34:00 -0400
Received: by mail-qt0-f194.google.com with SMTP id y5-v6so7396173qti.12
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:28 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 15/22] btrfs: run delayed iputs before committing
Date: Thu, 19 Jul 2018 10:49:59 -0400
Message-Id: <20180719145006.17532-15-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We want to have a complete picture of any delayed inode updates before
we make the decision to commit or not, so make sure we run delayed iputs
before making the decision to commit or not.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 355884445f38..81396bac53f1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4923,6 +4923,10 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 		goto commit;
 	}
 
+	mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
+	btrfs_run_delayed_iputs(fs_info);
+	mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
+
 	spin_lock(&delayed_rsv->lock);
 	reclaim_bytes += delayed_rsv->reserved;
 	spin_unlock(&delayed_rsv->lock);
-- 
2.14.3

