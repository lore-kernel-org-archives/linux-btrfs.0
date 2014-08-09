Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41276 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaHILv0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Aug 2014 07:51:26 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: clm@fb.com, jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] btrfs: Drop stray check of fixup_workers creation
Date: Sat,  9 Aug 2014 14:51:15 +0300
Message-Id: <1407585075-31035-1-git-send-email-andrey.krieger.utkin@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The issue was introduced in a79b7d4b3e8118f265dcb4bdf9a572c392f02708,
adding allocation of extent_workers, so this stray check is surely not
meant to be a check of something else.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=82021
Reported-by: Maks Naumov <maksqwe1@ukr.net>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 08e65e9..1881713 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2601,7 +2601,7 @@ int open_ctree(struct super_block *sb,
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
 	      fs_info->caching_workers && fs_info->readahead_workers &&
 	      fs_info->fixup_workers && fs_info->delayed_workers &&
-	      fs_info->fixup_workers && fs_info->extent_workers &&
+	      fs_info->extent_workers &&
 	      fs_info->qgroup_rescan_workers)) {
 		err = -ENOMEM;
 		goto fail_sb_buffer;
-- 
1.8.5.5

