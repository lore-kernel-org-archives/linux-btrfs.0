Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935001AbcCPIoQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 04:44:16 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH] btrfs: remove unused function btrfs_assert()
Date: Wed, 16 Mar 2016 16:43:07 +0800
Message-Id: <1458117788-840-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
References: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apparently looks like ASSERT does the same intended job,
as intended btrfs_assert().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d6ae2d324080..bb5a1114da7c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4283,7 +4283,6 @@ static inline void assfail(char *expr, char *file, int line)
 #define ASSERT(expr)	((void)0)
 #endif
 
-#define btrfs_assert()
 __printf(5, 6)
 __cold
 void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function,
-- 
2.7.0

