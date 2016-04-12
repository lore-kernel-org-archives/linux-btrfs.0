Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47741 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784AbcDLOQn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 10:16:43 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 06/13] btrfs: introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV
Date: Tue, 12 Apr 2016 22:15:56 +0800
Message-Id: <1460470563-752-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
References: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Add BTRFS_FEATURE_INCOMPAT_SPARE_DEV (400) flag to identify
a spare device.

Along with this it checks in the mount context that a spare
device will fail to mount.  As spare devices aren't mountable.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
 fs/btrfs/ctree.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7a6471269b34..a823ff7944f1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -531,6 +531,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_SPARE_DEV	(1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
@@ -551,7 +552,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_SPARE_DEV)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
-- 
2.7.0

