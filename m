Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab3A2KE0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 05:04:26 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0TA4OY2020348
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 18:04:24 +0800
Message-ID: <51079ED1.1020609@cn.fujitsu.com>
Date: Tue, 29 Jan 2013 18:05:05 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 04/10] Btrfs: add a comment for fs_info->max_inline
References: <51079D72.7000301@cn.fujitsu.com>
In-Reply-To: <51079D72.7000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Though ->max_inline is a 64bit variant, and may be accessed by
multi-task, but it is just suggestive number, so we needn't add
anything to protect fs_info->max_inline, just add a comment to
explain wny we don't use a lock to protect it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- modify the changelog and make it more clear.
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

