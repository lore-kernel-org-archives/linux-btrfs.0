Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64743 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2HNFCe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 01:02:34 -0400
From: <liub.liubo@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH RFC] Btrfs: fix deadlock between sys_sync and freeze
Date: Tue, 14 Aug 2012 13:01:14 +0800
Message-Id: <1344920474-10014-1-git-send-email-liub.liubo@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <bo.li.liu@oracle.com>

I found this while testing xfstests 068, the story is

    t1                                            t2
  sys_sync                                    thaw_super
    iterate_supers
      down_read(sb->s_umount)                   down_write(sb->s_umount) --->wait for t1
      sync_fs (with wait mode)
        start_transaction
          sb_start_intwrite --------------------> wait for t2 to set s_writers.frozen to SB_UNFROZEN

In this patch, I add an helper sb_start_intwrite_trylock() and use it before we
start_transaction in sync_fs() with wait mode so that we won't hit the deadlock.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/super.c   |   15 +++++++++++++++
 include/linux/fs.h |    5 +++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f2eb24c..1e04b41 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -847,6 +847,21 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
+	/*
+	 * sys_sync can cause an ABBA deadlock with freeze/thaw
+	 * o freeze_super()   grabs s_umount lock and set sb to SB_FREEZE_FS.
+	 * o thaw_super()     grabs s_umount lock and set sb to SB_UNFROZEN.
+	 * o iterate_supers() grabs s_umount lock, and sync fs, during which
+	 *                    we need to do sb_start_intwrite() in starting a
+	 *                    new transaction.
+	 * so iterate_supers() will wait for thaw_super() to reset sb's frozen
+	 * state, while thaw_super() will wait for iterate_supers() to drop the
+	 * s_umount lock.  This is an ABBA deadlock.
+	 */
+	if (!sb_start_intwrite_trylock(sb))
+		return 0;
+	sb_end_intwrite(sb);
+
 	btrfs_wait_ordered_extents(root, 0, 0);
 
 	trans = btrfs_start_transaction(root, 0);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..8a3efd0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1700,6 +1700,11 @@ static inline void sb_start_intwrite(struct super_block *sb)
 	__sb_start_write(sb, SB_FREEZE_FS, true);
 }
 
+static inline int sb_start_intwrite_trylock(struct super_block *sb)
+{
+	return __sb_start_write(sb, SB_FREEZE_FS, false);
+}
+
 
 extern bool inode_owner_or_capable(const struct inode *inode);
 
-- 
1.7.7.6

