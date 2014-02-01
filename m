Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:38952 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaBAV2V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Feb 2014 16:28:21 -0500
Received: by mail-we0-f177.google.com with SMTP id t61so837383wes.22
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Feb 2014 13:28:19 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: ainan@mathematik.uni-freiburg.de,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: use late_initcall instead of module_init
Date: Sat,  1 Feb 2014 21:27:56 +0000
Message-Id: <1391290076-13149-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems that when init_btrfs_fs() is called, crc32c/crc32c-intel might
not always be already initialized, which results in the call to crypto_alloc_shash()
returning -ENOENT, as experienced by Ahmet who reported this.

Therefore make sure init_btrfs_fs() is called after crc32c is initialized (which
is at initialization level 6, module_init), by using late_initcall (which is at
initialization level 7) instead of module_init for btrfs.

Reported-and-Tested-by: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c02f633..97cc241 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1996,7 +1996,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_hash_exit();
 }
 
-module_init(init_btrfs_fs)
+late_initcall(init_btrfs_fs);
 module_exit(exit_btrfs_fs)
 
 MODULE_LICENSE("GPL");
-- 
1.7.9.5

