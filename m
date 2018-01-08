Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35874 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754946AbeAHDE3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jan 2018 22:04:29 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Subject: [PATCH 1/2] btrfs: add missing BTRFS_SUPER_FLAG define
Date: Mon,  8 Jan 2018 11:05:11 +0800
Message-Id: <20180108030512.22344-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs uses super flag bit BTRFS_SUPER_FLAG_METADUMP_V2 (1ULL << 34).
So just define that in kernel so that we know its been used. This patch
does not add it to BTRFS_SUPER_FLAG_SUPP yet, and will continue to warn
about unsupported flag.

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

