Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47312 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755852AbeAHIDf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 03:03:35 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Subject: [PATCH 2/3] btrfs: define SUPER_FLAG_METADUMP_V2
Date: Mon,  8 Jan 2018 16:04:20 +0800
Message-Id: <20180108080421.17668-3-anand.jain@oracle.com>
In-Reply-To: <20180108080421.17668-1-anand.jain@oracle.com>
References: <20180108080421.17668-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs uses super flag bit BTRFS_SUPER_FLAG_METADUMP_V2 (1ULL << 34).
So just define that in kernel so that we know its been used. This patch
does not add it to BTRFS_SUPER_FLAG_SUPP yet.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/uapi/linux/btrfs_tree.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 6d6e5da51527..38ab0e06259a 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -456,6 +456,7 @@ struct btrfs_free_space_header {
 
 #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
+#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
 
 
 /*
-- 
2.15.0

