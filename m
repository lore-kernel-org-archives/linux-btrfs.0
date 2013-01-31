Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:63865 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753574Ab3AaABi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:01:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/11] btrfs: handle null fs_info in btrfs_panic()
Date: Wed, 30 Jan 2013 18:54:55 -0600
Message-Id: <1359593702-53056-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At least backref_tree_panic() can apparently pass
in a null fs_info, so handle that in __btrfs_panic
to get the message out on the console.

The btrfs_panic macro also uses fs_info, but that's
largely pointless; it's testing to see if
BTRFS_MOUNT_PANIC_ON_FATAL_ERROR is not set.
But if it *were* set, __btrfs_panic() would have,
well, paniced and we wouldn't be here, testing it!
So just BUG() at this point.

And since we only use fs_info once now, just use it
directly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/ctree.h |    9 ++++++---
 fs/btrfs/super.c |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 547b7b0..57121fc 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3620,11 +3620,14 @@ __printf(5, 6)
 void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 		   unsigned int line, int errno, const char *fmt, ...);
 
+/*
+ * If BTRFS_MOUNT_PANIC_ON_FATAL_ERROR is in mount_opt, __btrfs_panic
+ * will panic().  Otherwise we BUG() here.
+ */
 #define btrfs_panic(fs_info, errno, fmt, args...)			\
 do {									\
-	struct btrfs_fs_info *_i = (fs_info);				\
-	__btrfs_panic(_i, __func__, __LINE__, errno, fmt, ##args);	\
-	BUG_ON(!(_i->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR));	\
+	__btrfs_panic(fs_info, __func__, __LINE__, errno, fmt, ##args);	\
+	BUG();								\
 } while (0)
 
 /* acl.c */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e933a5f..d5e7e18 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -289,7 +289,7 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 	vaf.va = &args;
 
 	errstr = btrfs_decode_error(errno, nbuf);
-	if (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR)
+	if (fs_info && (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR))
 		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
 			s_id, function, line, &vaf, errstr);
 
-- 
1.7.1

