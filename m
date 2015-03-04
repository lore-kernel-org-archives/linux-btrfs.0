Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:43178 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbbCDBYO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Mar 2015 20:24:14 -0500
Received: by mail-qa0-f43.google.com with SMTP id bm13so31212256qab.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Mar 2015 17:24:13 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: clm@fb.com
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] btrfs/disk-io: Use '%zu' to print 'sizeof'
Date: Tue,  3 Mar 2015 22:23:56 -0300
Message-Id: <1425432236-20883-1-git-send-email-festevam@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

The following build warning is seen when building for ARM:

fs/btrfs/disk-io.c:3927:21: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]

Use the '%zu' specifier when printing 'sizeof'.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f79f385..639f266 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3921,7 +3921,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	}
 	if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
 			+ sizeof(struct btrfs_chunk)) {
-		printk(KERN_ERR "BTRFS: system chunk array too small %u < %lu\n",
+		printk(KERN_ERR "BTRFS: system chunk array too small %u < %zu\n",
 				btrfs_super_sys_array_size(sb),
 				sizeof(struct btrfs_disk_key)
 				+ sizeof(struct btrfs_chunk));
-- 
1.9.1

