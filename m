Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaBYLu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 06:50:59 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1PBon6r016049
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 19:50:51 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs-progs: use bitfield instead of integer for some variants in fs_info
Date: Tue, 25 Feb 2014 19:48:57 +0800
Message-Id: <1393328937-26171-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1393328937-26171-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1393328937-26171-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 ctree.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/ctree.h b/ctree.h
index 3cc3477..9b461af 100644
--- a/ctree.h
+++ b/ctree.h
@@ -984,9 +984,11 @@ struct btrfs_fs_info {
 	struct btrfs_fs_devices *fs_devices;
 	struct list_head space_info;
 	int system_allocs;
-	int readonly;
-	int on_restoring;
-	int is_chunk_recover;
+
+	unsigned int readonly:1;
+	unsigned int on_restoring:1;
+	unsigned int is_chunk_recover:1;
+
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
-- 
1.9.0

