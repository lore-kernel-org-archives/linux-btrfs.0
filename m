Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35160 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaKLPBA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 10:01:00 -0500
From: Daniel Dressler <danieru.dressler@gmail.com>
To: danieru.dressler@gmail.com
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org (open list:BTRFS FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Btrfs: qgroup: add BUILD_BUG to report pointer cast breakage
Date: Thu, 13 Nov 2014 00:00:44 +0900
Message-Id: <1415804444-9765-1-git-send-email-danieru.dressler@gmail.com>
In-Reply-To: <danieru.dressler@gmail.com>
References: <danieru.dressler@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Our ulist data structure stores at max 64bit
values. qgroup has used this structure to store
pointers. In the future when we upgrade to 128bit
this casting of pointers to uint64_t will break.

This patch adds a BUILD_BUG ensuring that this
code will not be left untouched in the upgrade.

It also marks this issue on the TODO list so it
may be addressed before such an upgrade.

Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
---
 fs/btrfs/qgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 48b60db..87f7c98 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -44,6 +44,7 @@
  *  - caches fuer ulists
  *  - performance benchmarks
  *  - check all ioctl parameters
+ *  - do not cast uintptr_t to uint64_t in ulist usage
  */
 
 /*
@@ -101,6 +102,7 @@ struct btrfs_qgroup_list {
 
 #define ptr_to_u64(x) ((u64)(uintptr_t)x)
 #define u64_to_ptr(x) ((struct btrfs_qgroup *)(uintptr_t)x)
+BUILD_BUG_ON(UINTPTR_MAX > UINT64_MAX);
 
 static int
 qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
-- 
2.1.0

