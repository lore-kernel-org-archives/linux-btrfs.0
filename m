Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44054 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934980AbcCPIoO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 04:44:14 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH] btrfs: rename save_error_info to set_fs_error
Date: Wed, 16 Mar 2016 16:43:05 +0800
Message-Id: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Actually save_error_info() is setting the FS state to error.
So rename is more appropriate.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 63a74303da9e..a11823b317ac 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -97,7 +97,7 @@ const char *btrfs_decode_error(int errno)
 	return errstr;
 }
 
-static void save_error_info(struct btrfs_fs_info *fs_info)
+static void set_fs_error(struct btrfs_fs_info *fs_info)
 {
 	/*
 	 * today we only save the error info into ram.  Long term we'll
@@ -171,7 +171,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 #endif
 
 	/* Don't go through full error handling during mount */
-	save_error_info(fs_info);
+	set_fs_error(fs_info);
 	if (sb->s_flags & MS_BORN)
 		btrfs_handle_error(fs_info);
 }
-- 
2.7.0

