Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54594 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab3AJMqH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 07:46:07 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0ACk5DP022071
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 20:46:05 +0800
Message-ID: <50EEB833.4040708@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 20:46:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/11] Btrfs: add a comment for fs_info->max_inline
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need not add anything to protect fs_info->max_inline, but we need a comment to
explain why we don't add a lock to protect it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 745e7ad..3e672916 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1288,6 +1288,12 @@ struct btrfs_fs_info {
 	atomic64_t last_trans_log_full_commit;
 	unsigned long mount_opt;
 	unsigned long compress_type:4;
+	/*
+	 * It is a suggestive number, the read side is safe even it gets a
+	 * wrong number because we will write out the data into a regular
+	 * extent. The write side(mount/remount) is under ->s_umount lock,
+	 * so it is also safe.
+	 */
 	u64 max_inline;
 	u64 alloc_start;
 	struct btrfs_transaction *running_transaction;
-- 
1.7.11.7
