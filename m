Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:28208 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbdJBIpx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 04:45:53 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id C60A7AC01BA
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Oct 2017 17:34:44 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.101.65])
        by m3051.s.css.fujitsu.com (Postfix) with SMTP id A96D7128
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Oct 2017 17:34:44 +0900 (JST)
Message-Id: <201710020834.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Mon, 02 Oct 2017 17:34:12 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix fs_info->flags value
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because the values of BTRFS_FS_QUOTA_OVERRIDE and BTRFS_FS_EXCL_OP overlap,
we should change the value.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 899ddaeeacec..566c0ba8dfb8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -717,12 +717,11 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_QUOTA_OVERRIDE			14
 /* Used to record internally whether fs has been frozen */
 #define BTRFS_FS_FROZEN				15
-
 /*
  * Indicate that a whole-filesystem exclusive operation is running
  * (device replace, resize, device add/delete, balance)
  */
-#define BTRFS_FS_EXCL_OP			14
+#define BTRFS_FS_EXCL_OP			16
 
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
-- 
2.13.2

