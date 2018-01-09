Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755360AbeAIBFz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 20:05:55 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
Subject: [PATCH 1/3] btrfs: define SUPER_FLAG_METADUMP_V2
Date: Tue,  9 Jan 2018 09:05:41 +0800
Message-Id: <20180109010543.16053-2-anand.jain@oracle.com>
In-Reply-To: <20180109010543.16053-1-anand.jain@oracle.com>
References: <20180109010543.16053-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs uses super flag bit BTRFS_SUPER_FLAG_METADUMP_V2 (1ULL << 34).
So just define that in kernel so that we know its been used.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c              | 3 ++-
 include/uapi/linux/btrfs_tree.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a69e5944dc08..7cd4935f690f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -61,7 +61,8 @@
 				 BTRFS_HEADER_FLAG_RELOC |\
 				 BTRFS_SUPER_FLAG_ERROR |\
 				 BTRFS_SUPER_FLAG_SEEDING |\
-				 BTRFS_SUPER_FLAG_METADUMP)
+				 BTRFS_SUPER_FLAG_METADUMP |\
+				 BTRFS_SUPER_FLAG_METADUMP_V2)
 
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
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

