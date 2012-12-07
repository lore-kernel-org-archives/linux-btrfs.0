Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38145 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab2LGPmO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2012 10:42:14 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so546604pad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Dec 2012 07:42:13 -0800 (PST)
From: Wang Sheng-Hui <shhuiw@gmail.com>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: make sure fs_info is not null before its field is used in __btrfs_panic
Date: Fri,  7 Dec 2012 23:42:04 +0800
Message-Id: <1354894924-13050-1-git-send-email-shhuiw@gmail.com>
In-Reply-To: <n>
References: <n>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should make sure fs_info is not null before we refer to its field.
Add simple check here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..c6a3633 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -280,7 +280,7 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 	vaf.va = &args;
 
 	errstr = btrfs_decode_error(fs_info, errno, nbuf);
-	if (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR)
+	if (fs_info && (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR))
 		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (%s)\n",
 			s_id, function, line, &vaf, errstr);
 
-- 
1.7.10.4

