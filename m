Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55153 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3CSK5T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 06:57:19 -0400
Received: by mail-pb0-f42.google.com with SMTP id xb4so333092pbc.29
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2013 03:57:19 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, sensille@gmx.net
Subject: [PATCH] Btrfs: fix missing qgroup reservation before fallocating
Date: Tue, 19 Mar 2013 18:57:14 +0800
Message-Id: <1363690634-1622-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Steps to reproduce:
	mkfs.btrfs <disk>
	mount <disk> <mnt>
	btrfs quota enable <mnt>
	btrfs sub create <mnt>/subv
	btrfs qgroup limit 10M <mnt>/subv
	fallocate --length 20M <mnt>/subv/data

For the above example, fallocating will return successfully which
is not expected, we try to fix it by doing qgroup reservation before
fallocating.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index af1d060..bdf5cd7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2141,6 +2141,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 {
 	struct inode *inode = file_inode(file);
 	struct extent_state *cached_state = NULL;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 cur_offset;
 	u64 last_byte;
 	u64 alloc_start;
@@ -2168,6 +2169,11 @@ static long btrfs_fallocate(struct file *file, int mode,
 	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start);
 	if (ret)
 		return ret;
+	if (root->fs_info->quota_enabled) {
+		ret = btrfs_qgroup_reserve(root, alloc_end - alloc_start);
+		if (ret)
+			goto out_reserve_fail;
+	}
 
 	/*
 	 * wait for ordered IO before we have any locks.  We'll loop again
@@ -2271,6 +2277,9 @@ static long btrfs_fallocate(struct file *file, int mode,
 			     &cached_state, GFP_NOFS);
 out:
 	mutex_unlock(&inode->i_mutex);
+	if (root->fs_info->quota_enabled)
+		btrfs_qgroup_free(root, alloc_end - alloc_start);
+out_reserve_fail:
 	/* Let go of our reservation. */
 	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
 	return ret;
-- 
1.7.7.6

