Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35604 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:35 -0400
Received: by mail-qt0-f195.google.com with SMTP id j7-v6so29236079qtp.2
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:59:09 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 32/36] btrfs: clear delayed_refs_rsv for dirty bg cleanup
Date: Tue, 11 Sep 2018 13:58:03 -0400
Message-Id: <20180911175807.26181-33-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We keep track of dirty bg's as a reservation in the delayed_refs_rsv, so
when we abort and we cleanup those dirty bgs we need to drop their
reservation so we don't have accounting issues and lots of scary
messages on umount.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index caaca8154a1a..54fbdc944a3f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4412,6 +4412,7 @@ void btrfs_cleanup_dirty_bgs(struct btrfs_transaction *cur_trans,
 
 		spin_unlock(&cur_trans->dirty_bgs_lock);
 		btrfs_put_block_group(cache);
+		btrfs_delayed_refs_rsv_release(fs_info, 1);
 		spin_lock(&cur_trans->dirty_bgs_lock);
 	}
 	spin_unlock(&cur_trans->dirty_bgs_lock);
-- 
2.14.3
