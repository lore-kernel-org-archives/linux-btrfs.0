Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:48935 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJDCFw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 22:05:52 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 2AFE0AC021C
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Oct 2017 11:05:45 +0900 (JST)
Message-Id: <201710040205.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 04 Oct 2017 11:05:17 +0900
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] Btrfs: fix overlap of fs_info->flags values
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because the values of BTRFS_FS_EXCL_OP and BTRFS_FS_QUOTA_OVERRIDE overlap,
we should change the value.

First, BTRFS_FS_EXCL_OP was set to 14.

  commit 171938e52807 ("btrfs: track exclusive filesystem operation in flags")

Next, the value of BTRFS_FS_QUOTA_OVERRIDE was set to 14.

  commit f29efe292198 ("btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE")

As a result, the value 14 overlapped.
This problem is solved by defining the value of BTRFS_FS_QUOTA_OVERRIDE
as 16.

Fixes: f29efe292198 ("btrfs: add quota override flag to enable quota override for CAP_SYS_RESOURCE")
CC: stable@vger.kernel.org # 4.13+
Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
v2: changed the value of BTRFS_FS_QUOTA_OVERRIDE instead of BTRFS_FS_EXCL_OP
    to 16.

 fs/btrfs/ctree.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 899ddaeeacec..d265ea7f763e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -714,15 +714,14 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_BTREE_ERR			11
 #define BTRFS_FS_LOG1_ERR			12
 #define BTRFS_FS_LOG2_ERR			13
-#define BTRFS_FS_QUOTA_OVERRIDE			14
-/* Used to record internally whether fs has been frozen */
-#define BTRFS_FS_FROZEN				15
-
 /*
  * Indicate that a whole-filesystem exclusive operation is running
  * (device replace, resize, device add/delete, balance)
  */
 #define BTRFS_FS_EXCL_OP			14
+/* Used to record internally whether fs has been frozen */
+#define BTRFS_FS_FROZEN				15
+#define BTRFS_FS_QUOTA_OVERRIDE			16
 
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
-- 
2.13.2

