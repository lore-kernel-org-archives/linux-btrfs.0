Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091AbaKNKdP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 05:33:15 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D452DAD35
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 10:33:14 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/6] btrfs: introduce pending action: commit
Date: Fri, 14 Nov 2014 11:33:14 +0100
Message-Id: <d51033d05547675f898ce4233a7d8d1a0dfe2984.1415894837.git.dsterba@suse.cz>
In-Reply-To: <cover.1415894837.git.dsterba@suse.cz>
References: <cover.1415894837.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some contexts, like in sysfs handlers, we don't want to trigger a
transaction commit. It's a heavy operation, we don't know what external
locks may be taken. Instead, make it possible to finish the operation
through sync syscall or SYNC_FS ioctl.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       | 1 +
 fs/btrfs/transaction.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1c9157e4ab0c..817fc19b8159 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2132,6 +2132,7 @@ struct btrfs_ioctl_defrag_range_args {
 
 #define BTRFS_PENDING_SET_INODE_MAP_CACHE	(0)
 #define BTRFS_PENDING_CLEAR_INODE_MAP_CACHE	(1)
+#define BTRFS_PENDING_COMMIT			(2)
 
 #define btrfs_test_pending(info, opt)	\
 	test_bit(BTRFS_PENDING_##opt, &(info)->pending_changes)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 703238ed7337..9d8e2b8d12b4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2036,6 +2036,11 @@ void btrfs_apply_pending_changes(struct btrfs_fs_info *fs_info)
 		btrfs_clear_opt(fs_info->mount_opt, INODE_MAP_CACHE);
 	prev &= ~bit;
 
+	bit = 1 << BTRFS_PENDING_COMMIT;
+	if (prev & bit)
+		btrfs_debug(fs_info, "pending commit done");
+	prev &= ~bit;
+
 	if (prev)
 		btrfs_warn(fs_info,
 			"unknown pending changes left 0x%lx, ignoring", prev);
-- 
1.8.4.5

