Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:37295 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbeIKW7k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:40 -0400
Received: by mail-qt0-f194.google.com with SMTP id n6-v6so29180945qtl.4
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:59:15 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 35/36] btrfs: wait on ordered extents on abort cleanup
Date: Tue, 11 Sep 2018 13:58:06 -0400
Message-Id: <20180911175807.26181-36-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we flip read-only before we initiate writeback on all dirty pages for
ordered extents we've created then we'll have ordered extents left over
on umount, which results in all sorts of bad things happening.  Fix this
by making sure we wait on ordered extents if we have to do the aborted
transaction cleanup stuff.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 54fbdc944a3f..51b2a5bf25e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4188,6 +4188,14 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 		spin_lock(&fs_info->ordered_root_lock);
 	}
 	spin_unlock(&fs_info->ordered_root_lock);
+
+	/*
+	 * We need this here because if we've been flipped read-only we won't
+	 * get sync() from the umount, so we need to make sure any ordered
+	 * extents that haven't had their dirty pages IO start writeout yet
+	 * actually get run and error out properly.
+	 */
+	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-- 
2.14.3
