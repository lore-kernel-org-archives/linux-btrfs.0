Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755916AbeAHIDg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 03:03:36 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Subject: [PATCH 3/3] btrfs: add support for SUPER_FLAG_CHANGING_FSID in btrfs.ko
Date: Mon,  8 Jan 2018 16:04:21 +0800
Message-Id: <20180108080421.17668-4-anand.jain@oracle.com>
In-Reply-To: <20180108080421.17668-1-anand.jain@oracle.com>
References: <20180108080421.17668-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Userland sets SUPER_FLAG_CHANGING_FSID and resets it only when changing
fsid is complete. Its not a good idea to mount the device anything in
between, so this patch fails the mount if SB SUPER_FLAG_CHANGING_FSID
is set. As we don't add SUPER_FLAG_CHANGING_FSID into
BTRFS_SUPER_FLAG_SUPP list, so mount will fail if SUPER_FLAG_CHANGING_FSID
is set in the user land.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
cc: wqu@suse.com
---
 include/uapi/linux/btrfs_tree.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 38ab0e06259a..aff1356c2bb8 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -457,6 +457,7 @@ struct btrfs_free_space_header {
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
 #define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
+#define BTRFS_SUPER_FLAG_CHANGING_FSID	(1ULL << 35)
 
 
 /*
-- 
2.15.0

