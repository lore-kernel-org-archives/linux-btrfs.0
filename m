Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44003 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbcCPAz2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 20:55:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH] btrfs: btrfs_assert fix coding style
Date: Wed, 16 Mar 2016 08:55:15 +0800
Message-Id: <1458089715-597-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c9fb7b9ca8a4..5b5002a242e4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4283,8 +4283,8 @@ static inline void assfail(char *expr, char *file, int line)
 #define ASSERT(expr)	((void)0)
 #endif
 
-#define btrfs_assert()
-__printf(5, 6)
+#define btrfs_assert() __printf(5, 6)
+
 __cold
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		     unsigned int line, int errno, const char *fmt, ...);
-- 
2.7.0

