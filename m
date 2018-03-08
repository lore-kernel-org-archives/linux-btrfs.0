Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755460AbeCHLvf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 06:51:35 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E2D55AEEB
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 11:51:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: introduce conditional wakeup helpers
Date: Thu,  8 Mar 2018 12:49:13 +0100
Message-Id: <96b9c7113ac06d981c3f69638762c4502651f6af.1520509627.git.dsterba@suse.com>
In-Reply-To: <cover.1520509627.git.dsterba@suse.com>
References: <cover.1520509627.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add convenience wrappers for the waitqueue management that involves
memory barriers to prevent deadlocks. The helpers will let us remove
barriers and the necessary comments in several places.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bf545e7552b8..c9827a1b676d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3748,4 +3748,27 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
 #endif
 	return 0;
 }
+
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

