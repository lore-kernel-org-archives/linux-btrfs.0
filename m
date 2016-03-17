Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22322 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbcCQCjM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 22:39:12 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: remove save_error_info()
Date: Thu, 17 Mar 2016 10:38:57 +0800
Message-Id: <1458182337-3841-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Actually save_error_info() sets the FS state to error
and nothing else. Further the word save doesn't induce
caffeine when compared to the word set in what actually
it does.

So to make it better understandable move save_error_info()
code to its only consumer itself.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Title changed
       old: btrfs: rename save_error_info to set_fs_error
    Instead of rename to set_fs_error(), move the code to
     its parent.

 fs/btrfs/super.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 63a74303da9e..302f744b4d54 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -97,15 +97,6 @@ const char *btrfs_decode_error(int errno)
 	return errstr;
 }
 
-static void save_error_info(struct btrfs_fs_info *fs_info)
-{
-	/*
-	 * today we only save the error info into ram.  Long term we'll
-	 * also send it down to the disk
-	 */
-	set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
-}
-
 /* btrfs handle error by forcing the filesystem readonly */
 static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 {
@@ -170,8 +161,13 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	}
 #endif
 
+	/*
+	 * today we only save the error info into ram.  Long term we'll
+	 * also send it down to the disk
+	 */
+	set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
+
 	/* Don't go through full error handling during mount */
-	save_error_info(fs_info);
 	if (sb->s_flags & MS_BORN)
 		btrfs_handle_error(fs_info);
 }
-- 
2.7.0

