Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752618AbeENM00 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 08:26:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B4A49ABE9
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 12:26:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v3 1/3] btrfs: introduce conditional wakeup helpers
Date: Mon, 14 May 2018 14:23:46 +0200
Message-Id: <df68c030205d09ade77d0fc0e74cff5ccf219fe8.1526300425.git.dsterba@suse.com>
In-Reply-To: <cover.1526300425.git.dsterba@suse.com>
References: <cover.1526300425.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add convenience wrappers for the waitqueue management that involves
memory barriers to prevent deadlocks. The helpers will let us remove
barriers and the necessary comments in several places.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2771cc56a622..1389942f3be1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3765,4 +3765,26 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+static inline void cond_wake_up(struct wait_queue_head *wq)
+{
+	/*
+	 * This implies a full smp_mb barrier, see comments for
+	 * waitqueue_active why.
+	 */
+	if (wq_has_sleeper(wq))
+		wake_up(wq);
+}
+
+static inline void cond_wake_up_nomb(struct wait_queue_head *wq)
+{
+	/*
+	 * Special case for conditional wakeup where the barrier required for
+	 * waitqueue_active is implied by some of the preceding code. Eg. one
+	 * of such atomic operations (atomic_dec_and_return, ...), or a
+	 * unlock/lock sequence, etc.
+	 */
+	if (waitqueue_active(wq))
+		wake_up(wq);
+}
+
 #endif
-- 
2.16.2

